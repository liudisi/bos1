package cn.zzrfdsn.bos1.service.impl;

import java.io.Serializable;
import java.util.List;

import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.zzrfdsn.bos1.dao.ISubareaDao;
import cn.zzrfdsn.bos1.model.Region;
import cn.zzrfdsn.bos1.model.Subarea;
import cn.zzrfdsn.bos1.service.ISubareaService;
import cn.zzrfdsn.bos1.vo.PageBean;

@Service
@Transactional
public class SubareaServiceImpl implements ISubareaService{
 
	@Autowired
	private ISubareaDao subareaDao;
	@Override
	public Serializable save(Subarea subarea) {
		
		return subareaDao.save(subarea);
	}
	
	@Override
	public void pageQuery(PageBean<Subarea> pageBean) {
		subareaDao.pageQuery(pageBean);
	}

	@Override
	public List<Subarea> findAll() {
		return subareaDao.findAll();
	}

	@Override
	public List<Subarea> findNoAssociationList(DetachedCriteria detachedCriteria) {
		
		return subareaDao.detachedCriteriaQuery(detachedCriteria);
	}

	@Override
	public List<Subarea> findListByDecidedzoneId(String id) {
		DetachedCriteria detachedCriteria=DetachedCriteria.forClass(Subarea.class);
		detachedCriteria.add(Restrictions.eq("decidedzone.id", id));
		return subareaDao.detachedCriteriaQuery(detachedCriteria);
	}

	@Override
	public List<Object> findAllGroupByProvince() {
		
		return subareaDao.findAllGroupByProvince();
	}

	@Override
	public void update(Subarea model) {
		subareaDao.update(model);
	}

	@Override
	public void batchDelete(String... ids) {
		if(ids!=null&&ids.length>0) {
			for (String id : ids) {
				Subarea subarea=new Subarea();
				subarea.setId(id);
				subareaDao.delete(subarea);
			}
		}
	}

	@Override
	public void batchSaveOrUpdate(List<Subarea> subareas) {
		for (Subarea subarea : subareas) {
			subareaDao.saveOrUpdate(subarea);
		}
	}

	@Override
	public void cancelAssociationDecidezone(String id) {
		Subarea subarea = subareaDao.findById(id);
		subarea.setDecidedzone(null);
	}

}
