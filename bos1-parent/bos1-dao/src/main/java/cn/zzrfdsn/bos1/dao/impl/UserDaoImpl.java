package cn.zzrfdsn.bos1.dao.impl;

import java.util.List;

import org.apache.log4j.Logger;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.orm.hibernate5.HibernateCallback;
import org.springframework.stereotype.Repository;

import cn.zzrfdsn.bos1.dao.IUserDao;
import cn.zzrfdsn.bos1.dao.base.impl.BaseDaoImpl;
import cn.zzrfdsn.bos1.model.User;
import cn.zzrfdsn.bos1.utils.MD5Util;

@Repository
@SuppressWarnings("unchecked")
public class UserDaoImpl extends BaseDaoImpl<User> implements IUserDao {

	Logger logger = Logger.getLogger(UserDaoImpl.class);

	public UserDaoImpl() {
		super();
	}

	@Override
	public User findUserByUserNameAndPassword(User user) {
		String hql = "FROM User WHERE username=? and password=?";

		List<User> users = (List<User>) getHibernateTemplate().find(hql, user.getUsername(),
				MD5Util.md5(user.getPassword()));

		if (users != null && users.size() > 0) {

			return users.get(0);
		}

		return null;
	}

	@Override
	public User findUserByUserName(String username) {
		String hql = "FROM User WHERE username=?";

		List<User> users = (List<User>) getHibernateTemplate().find(hql,username);

		if (users != null && users.size() > 0) {

			return users.get(0);
		}

		return null;
	}

}
