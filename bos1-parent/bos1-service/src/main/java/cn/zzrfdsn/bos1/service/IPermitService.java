package cn.zzrfdsn.bos1.service;

import java.util.List;

import cn.zzrfdsn.bos1.model.Permit;
import cn.zzrfdsn.bos1.model.User;
import cn.zzrfdsn.bos1.vo.PageBean;

public interface IPermitService {

	List<Permit> findAll();

	Permit findById(String id);

	String save(Permit permit);

	void pageQuery(PageBean<Permit> pageBean);
	
	List<Permit> findAllForLeaves();

	List<Permit> findAllMenu(User user, String menugroup);
}
