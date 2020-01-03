package cn.zzrfdsn.bos1.service;

import java.io.Serializable;
import java.util.List;

import org.hibernate.criterion.DetachedCriteria;

import cn.zzrfdsn.bos1.model.Subarea;
import cn.zzrfdsn.bos1.vo.PageBean;

public interface ISubareaService {

	Serializable save(Subarea subarea);

	void pageQuery(PageBean<Subarea> pageBean);

	List<Subarea> findAll();

	List<Subarea> findNoAssociationList(DetachedCriteria detachedCriteria);

	List<Subarea> findListByDecidedzoneId(String id);

	List<Object> findAllGroupByProvince();

	void update(Subarea model);

	void batchDelete(String... ids);

	void batchSaveOrUpdate(List<Subarea> subareas);

	void cancelAssociationDecidezone(String id);
}
