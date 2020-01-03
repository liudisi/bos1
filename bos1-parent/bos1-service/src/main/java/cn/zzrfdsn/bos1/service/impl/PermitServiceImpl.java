package cn.zzrfdsn.bos1.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.zzrfdsn.bos1.dao.IPermitDao;
import cn.zzrfdsn.bos1.model.Permit;
import cn.zzrfdsn.bos1.model.User;
import cn.zzrfdsn.bos1.service.IPermitService;
import cn.zzrfdsn.bos1.vo.PageBean;

@Service
@Transactional
public class PermitServiceImpl implements IPermitService {

	@Autowired
	private IPermitDao permitDao;

	@Override
	@Transactional(readOnly = true)
	public List<Permit> findAll() {
		return permitDao.findAll();
	}

	@Override
	@Transactional(readOnly = true)
	public Permit findById(String id) {
		return permitDao.findById(id);
	}

	@Override
	public String save(Permit permit) {
		return (String) permitDao.save(permit);
	}

	@Override
	@Transactional(readOnly = true)
	public void pageQuery(PageBean<Permit> pageBean) {
		permitDao.pageQuery(pageBean);
		;
	}

	@Override
	public List<Permit> findAllForLeaves() {
		
		return permitDao.findAllForLeaves();
	}

	@Override
	public List<Permit> findAllMenu(User user,String menugroup) {
		
		return permitDao.findAllMenu(user,menugroup);
	}

}
