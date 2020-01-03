package cn.zzrfdsn.bos1.service.impl;

import java.io.Serializable;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.zzrfdsn.bos1.dao.IDecidedzoneDao;
import cn.zzrfdsn.bos1.dao.ISubareaDao;
import cn.zzrfdsn.bos1.model.Decidedzone;
import cn.zzrfdsn.bos1.model.Subarea;
import cn.zzrfdsn.bos1.service.IDecidedzoneService;
import cn.zzrfdsn.bos1.vo.PageBean;

@Service
@Transactional
public class DecidedzoneServiceImpl implements IDecidedzoneService {

	@Autowired
	private ISubareaDao subareaDao;
	@Autowired
	private IDecidedzoneDao decidedzoneDao;
	@Override
	public Serializable save(Decidedzone decidedzone, String... subareaId) {
		Serializable id = decidedzoneDao.save(decidedzone);
		//一个的一方已经放弃外键维护，只能多的一方维护
		if(subareaId!=null) {
			for (String sid : subareaId) {
				Subarea subarea = subareaDao.findById(sid);
				subarea.setDecidedzone(decidedzone);
			}
		}
		return id;
	}
	@Override
	public void pageQuery(PageBean<Decidedzone> pageBean) {
		decidedzoneDao.pageQuery(pageBean);
	}
	
	@Override
	public void update(Decidedzone decidedzone, String... subareaId) {
		decidedzoneDao.update(decidedzone);
		//一个的一方已经放弃外键维护，只能多的一方维护
		if(subareaId!=null) {
			for (String sid : subareaId) {
				Subarea subarea = subareaDao.findById(sid);
				subarea.setDecidedzone(decidedzone);
			}
		}
	}
	@Override
	public void batchDelete(String... ids) {
		if(ids!=null&&ids.length>0) {
			for (String id : ids) {
				Decidedzone decidedzone=new Decidedzone();
				decidedzone.setId(id);
				decidedzoneDao.delete(decidedzone);
			}
		}
	}

}
