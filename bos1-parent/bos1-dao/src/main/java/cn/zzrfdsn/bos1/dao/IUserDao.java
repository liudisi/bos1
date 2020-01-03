package cn.zzrfdsn.bos1.dao;

import cn.zzrfdsn.bos1.dao.base.IBaseDao;
import cn.zzrfdsn.bos1.model.User;

public interface IUserDao extends IBaseDao<User>{
	
	User findUserByUserNameAndPassword(User user);

	int execute(String sqlName, Object... obj);

	User findUserByUserName(String username);
}
