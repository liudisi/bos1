package cn.zzrfdsn.bos1.service.impl;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.apache.commons.lang.StringUtils;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.zzrfdsn.bos1.dao.IUserDao;
import cn.zzrfdsn.bos1.model.Role;
import cn.zzrfdsn.bos1.model.User;
import cn.zzrfdsn.bos1.service.IUserService;
import cn.zzrfdsn.bos1.utils.MD5Util;
import cn.zzrfdsn.bos1.vo.PageBean;

@Service
@Transactional
public class UserServiceImpl implements IUserService {

	@Autowired
	private IUserDao userDao;

	public UserServiceImpl() {
		super();
	}

	public void setUserDao(IUserDao userDao) {
		this.userDao = userDao;
	}

	@Transactional(readOnly = true)
	@Override
	public User login(User user) {
		return userDao.findUserByUserNameAndPassword(user);
	}

	@Override
	public int updatePassword(User model) {
		String password = MD5Util.md5(model.getPassword());
		return userDao.execute("updatePassword", password, model.getId());
	}

	@Override
	public User findUserByUserName(String userName) {
		return userDao.findUserByUserName(userName);
	}

	@Override
	public String save(User user, String... roleIds) {
		user.setPassword(MD5Util.md5(user.getPassword()));
		String saveId = (String) userDao.save(user);
		Set<Role> roles = user.getRoles();
		if (roleIds != null) {
			for (String roleId : roleIds) {
				Role role = new Role();
				role.setId(roleId);
				roles.add(role);
			}
		}

		return saveId;
	}

	@Override
	public User findUserByTelephone(String telephone) {
		DetachedCriteria detachedCriteria = DetachedCriteria.forClass(User.class);
		detachedCriteria.add(Restrictions.eq("telephone", telephone));
		List<User> users = userDao.detachedCriteriaQuery(detachedCriteria);
		return users != null && users.size() > 0 ? users.get(0) : null;
	}

	@Override
	public void pageQuery(PageBean<User> pageBean) {
		userDao.pageQuery(pageBean);
	}

	@Override
	public void update(User newUser, String[] roleIds) {
		User user = userDao.findById(newUser.getId());
		user.setBirthday(newUser.getBirthday());
		if (StringUtils.isNotBlank(newUser.getTelephone())) {
			user.setTelephone(newUser.getTelephone());
		}
		user.setSalary(newUser.getSalary());
		user.setStation(newUser.getStation());
		
		Set<Role> roles = new HashSet<Role>();
		if (roleIds != null) {
			for (String roleId : roleIds) {
				Role role = new Role();
				role.setId(roleId);
				roles.add(role);
			}
		}
		
		user.setRoles(roles);
		userDao.update(user);
	}

	@Override
	public int delete(String[] ids, User loginUser) {
		int affectRow = 0;
		for (String id : ids) {
			User user = userDao.findById(id.trim());
			if (user == null || user.getId() == loginUser.getId())
				continue;
			userDao.delete(user);
			affectRow++;
		}
		return affectRow;
	}

	@Override
	public User findUserById(String id) {
		return userDao.findById(id);
	}

}
