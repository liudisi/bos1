package cn.zzrfdsn.bos1.service;

import java.io.Serializable;
import java.util.List;

import org.hibernate.criterion.DetachedCriteria;

import cn.zzrfdsn.bos1.model.Staff;
import cn.zzrfdsn.bos1.vo.PageBean;

public interface IStaffService {
	
	Serializable save(Staff staff);
	
	void pageQuery(PageBean<Staff> pageBean);

	int batchDelete(String...ids);

	Staff findById(String id);

	void update(Staff staff);

	List<Staff> findStaffListByGiveConditions(DetachedCriteria detachedCriteria);
	
	int batchRestore(String... ids);
}
