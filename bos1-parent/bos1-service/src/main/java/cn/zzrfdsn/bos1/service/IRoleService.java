package cn.zzrfdsn.bos1.service;

import java.util.List;

import cn.zzrfdsn.bos1.model.Role;
import cn.zzrfdsn.bos1.vo.PageBean;

public interface IRoleService {

	void pageQuery(PageBean<Role> pageBean);

	List<Role> findAll();

	void delete(Role role);

	Role findById(String id);

	String saveOrUpdate(Role model, String permitIds);
}
