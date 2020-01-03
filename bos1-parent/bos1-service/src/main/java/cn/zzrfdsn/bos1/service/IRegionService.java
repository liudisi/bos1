package cn.zzrfdsn.bos1.service;

import java.util.List;

import org.hibernate.criterion.DetachedCriteria;

import cn.zzrfdsn.bos1.model.Region;
import cn.zzrfdsn.bos1.vo.PageBean;

public interface IRegionService {
	void batchSaveOrUpdate(List<Region> regions);

	void pageQuery(PageBean<Region> pageBean);

	List<Region> findAllBySearch(DetachedCriteria detachedCriteria);

	Region findById(String id);

	void batchDelete(String... ids);

}
