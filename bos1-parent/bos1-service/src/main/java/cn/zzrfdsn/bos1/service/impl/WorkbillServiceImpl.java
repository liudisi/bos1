package cn.zzrfdsn.bos1.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.zzrfdsn.bos1.dao.IWorkbillDao;
import cn.zzrfdsn.bos1.model.Workbill;
import cn.zzrfdsn.bos1.service.IWorkbillService;
import cn.zzrfdsn.bos1.vo.PageBean;


@Service
@Transactional
public class WorkbillServiceImpl implements IWorkbillService{

	
	@Autowired
	private IWorkbillDao workbilldao;
	
	@Override
	public void pageQuery(PageBean<Workbill> pageBean) {
		workbilldao.pageQuery(pageBean);
	}

	@Override
	public void attachbill(String... ids) {
		for (String id : ids) {
			Workbill workbill = workbilldao.findById(id);
			workbill.setAttachbilltimes(workbill.getAttachbilltimes()+1);
			workbill.setType(Workbill.TYPE_RECOVER);
			//TODO 通知取派员有用户催单啦......
		}
	}

	@Override
	public void cancelbill(String... ids) {
		for (String id : ids) {
			Workbill workbill = workbilldao.findById(id);
			workbill.setType(Workbill.TYPE_DESTRUCTION);
			//TODO 通知取派员有用户取消订单啦......
		}
	}

}
