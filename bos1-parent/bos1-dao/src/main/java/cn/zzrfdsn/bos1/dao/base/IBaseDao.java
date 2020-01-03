package cn.zzrfdsn.bos1.dao.base;

import java.io.Serializable;
import java.util.List;

import org.hibernate.criterion.DetachedCriteria;

import cn.zzrfdsn.bos1.vo.PageBean;

public interface IBaseDao<T> {

//	增
	Serializable save(T t);
//	刪
	void delete(T t);
//	改
	void update(T t);
//	根据id查
	T findById(Serializable id);
//	查询所有
	List<T> findAll();
//	通过给定语句查询
	int execute(String sqlName, Object... obj);
//	分页查询
	void pageQuery(PageBean<T> pageBean);
	
//	保存或更新
	void saveOrUpdate(T t);
	
//	根据离线查询条件查询
	List<T> detachedCriteriaQuery(DetachedCriteria detachedCriteria);
	
}
