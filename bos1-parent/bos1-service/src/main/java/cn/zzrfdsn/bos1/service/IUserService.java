package cn.zzrfdsn.bos1.service;

import cn.zzrfdsn.bos1.model.User;
import cn.zzrfdsn.bos1.vo.PageBean;

public interface IUserService {
	User login(User user);

	int updatePassword(User user);

	User findUserByUserName(String userName);

	String save(User model,String...roleIds);

	User findUserByTelephone(String telephone);

	void pageQuery(PageBean<User> pageBean);

	void update(User model, String[] roleIds);

	int delete(String[] ids,User loginUser);

	User findUserById(String id);
}
