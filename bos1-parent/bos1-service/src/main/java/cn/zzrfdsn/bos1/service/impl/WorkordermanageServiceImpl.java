package cn.zzrfdsn.bos1.service.impl;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.zzrfdsn.bos1.dao.IWorkordermanageDao;
import cn.zzrfdsn.bos1.model.Region;
import cn.zzrfdsn.bos1.model.Workordermanage;
import cn.zzrfdsn.bos1.service.IWorkordermanageService;
import cn.zzrfdsn.bos1.vo.PageBean;

@Service
@Transactional
public class WorkordermanageServiceImpl implements IWorkordermanageService {

	@Autowired
	private IWorkordermanageDao workordermanageDao;
	
	@Override
	public String save(Workordermanage workordermanage) {
		workordermanage.setUpdatetime(new Date());
		return (String) workordermanageDao.save(workordermanage);
	}

	@Override
	public void update(Workordermanage workordermanage) {
		workordermanage.setUpdatetime(new Date());
		workordermanageDao.update(workordermanage);
	}

	@Override
	@Transactional(readOnly = true)
	public void pageQuery(PageBean<Workordermanage> pageBean) {
		workordermanageDao.pageQuery(pageBean);
	}

	@Override
	public void batchSaveOrUpdate(List<Workordermanage> workordermanages) {
		for (Workordermanage workordermanage : workordermanages) {
			workordermanageDao.saveOrUpdate(workordermanage);
		}
	}

}
