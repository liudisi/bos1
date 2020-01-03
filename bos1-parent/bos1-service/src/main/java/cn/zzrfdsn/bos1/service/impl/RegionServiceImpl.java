package cn.zzrfdsn.bos1.service.impl;

import java.util.List;

import org.hibernate.criterion.DetachedCriteria;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.zzrfdsn.bos1.dao.IRegionDao;
import cn.zzrfdsn.bos1.model.Region;
import cn.zzrfdsn.bos1.service.IRegionService;
import cn.zzrfdsn.bos1.vo.PageBean;

@Service
@Transactional
public class RegionServiceImpl implements IRegionService {

	@Autowired
	private IRegionDao regionDao;
	@Override
	public void batchSaveOrUpdate(List<Region> regions) {
		for (Region region : regions) {
			regionDao.saveOrUpdate(region);
		}
	}
	@Override
	public void pageQuery(PageBean<Region> pageBean) {
		regionDao.pageQuery(pageBean);
	}
	@Override
	public List<Region> findAllBySearch(DetachedCriteria detachedCriteria) {
		return regionDao.detachedCriteriaQuery(detachedCriteria);
	}
	@Override
	public Region findById(String id) {
		return regionDao.findById(id);
	}
	@Override
	public void batchDelete(String... ids) {
		if(ids!=null&&ids.length>0) {
			for (String id : ids) {
				Region region=new Region();
				region.setId(id);
				regionDao.delete(region);
			}
		}
	}

}
