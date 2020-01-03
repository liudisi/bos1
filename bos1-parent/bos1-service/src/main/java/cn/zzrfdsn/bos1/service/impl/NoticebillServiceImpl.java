package cn.zzrfdsn.bos1.service.impl;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.hibernate.criterion.DetachedCriteria;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.hutool.core.date.DateUtil;
import cn.zzrfdsn.bos1.dao.IDecidedzoneDao;
import cn.zzrfdsn.bos1.dao.INoticebillDao;
import cn.zzrfdsn.bos1.dao.IWorkbillDao;
import cn.zzrfdsn.bos1.model.Decidedzone;
import cn.zzrfdsn.bos1.model.Noticebill;
import cn.zzrfdsn.bos1.model.Staff;
import cn.zzrfdsn.bos1.model.User;
import cn.zzrfdsn.bos1.model.Workbill;
import cn.zzrfdsn.bos1.service.INoticebillService;
import cn.zzrfdsn.bos1.vo.PageBean;

@Service
@Transactional
public class NoticebillServiceImpl implements INoticebillService {

	@Autowired
	private INoticebillDao noticebillDao;
	
	@Autowired
	private IDecidedzoneDao decidedzoneDao;
	
	@Autowired
	private IWorkbillDao workbillDao;
	@Override
	/**
	 * 保存通知单，创建工单并进行自动分单
	 */
	public Serializable save(Noticebill noticebill,String decidedzoneId,User user) {
		//设置通知单受理人
		noticebill.setUserId(user.getId());
		
		if(StringUtils.isNotBlank(decidedzoneId)) {
			//设置为自动分单
			noticebill.setOrdertype(Noticebill.ORDERTYPE_AUTO);
			//创建工单
			Workbill workbill=new Workbill();
			workbill.setNoticebill(noticebill);	//所属通知单
			workbill.setType(Workbill.TYPE_NEW);//工单类型
			workbill.setPickstate(Workbill.PICKSTATE_NO);//取件状态
			workbill.setBuildtime(new Date());//创建时间
			workbill.setAttachbilltimes(0);//追单次数
			workbill.setRemark(noticebill.getRemark());
			
			//获取定区关联的取派员
			Decidedzone decidedzone = decidedzoneDao.findById(decidedzoneId);
			noticebill.setStaff(decidedzone.getStaff());
			workbill.setStaff(decidedzone.getStaff());
			workbillDao.save(workbill);
			//给收派员发送短信
			
		}else {
			//设置为人工分单
			noticebill.setOrdertype(Noticebill.ORDERTYPE_NONAUTO);
		}
		
		return noticebillDao.save(noticebill);
	}
	@Override
	public List<Noticebill> findNoticebillListByGiveConditions(DetachedCriteria detachedCriteria) {
		return noticebillDao.detachedCriteriaQuery(detachedCriteria);
	}
	@Override
	public void pageQuery(PageBean<Noticebill> pageBean) {
		noticebillDao.pageQuery(pageBean);
	}
	@Override
	public void createWorkBill(String[] idArray, String staffId) {
		for (String nid : idArray) {
			Noticebill noticebill = noticebillDao.findById(nid.trim());
			if(noticebill!=null) {
				Workbill workbill=new Workbill();
				workbill.setNoticebill(noticebill);
				workbill.setBuildtime(new Date());
				workbill.setPickstate(Workbill.PICKSTATE_NO);
				Staff staff=new Staff();
				staff.setId(staffId);
				workbill.setStaff(staff);
				workbill.setType(Workbill.TYPE_NEW);
				workbillDao.save(workbill);
				noticebill.setStaff(staff);
			}
		}
	}

}
