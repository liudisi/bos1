package cn.zzrfdsn.bos1.web.shiro;

import java.util.List;

import org.apache.log4j.Logger;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.SimpleAuthenticationInfo;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.subject.PrincipalCollection;
import org.springframework.beans.factory.annotation.Autowired;

import cn.zzrfdsn.bos1.dao.IPermitDao;
import cn.zzrfdsn.bos1.dao.IUserDao;
import cn.zzrfdsn.bos1.model.Permit;
import cn.zzrfdsn.bos1.model.User;

public class Bos1Realm extends AuthorizingRealm{
	private final Logger LOGGER=Logger.getLogger(getClass());
	@Autowired
	private IUserDao userDao;
	@Autowired
	private IPermitDao permitDao;
	@Override
	protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principalCollection) {
		//TODO 给用户权限
		SimpleAuthorizationInfo authorizationInfo=new SimpleAuthorizationInfo();
		User user = (User) principalCollection.getPrimaryPrincipal();
		
		List<Permit> permits = permitDao.findPermitByUserId(user.getId());
		
		for (Permit permit : permits) {
			authorizationInfo.addStringPermission(permit.getCode());
		}
		
		return authorizationInfo;
	}

	@Override
	protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken token) throws AuthenticationException {
		LOGGER.info("进行登录验证......");
		UsernamePasswordToken loginToken=(UsernamePasswordToken) token;
		String username = loginToken.getUsername();
		//根据用户名查询数据库中的用户
		User user = userDao.findUserByUserName(username);
		if(user!=null) {
			
			AuthenticationInfo authenticationInfo=new SimpleAuthenticationInfo(user, user.getPassword(), getName());
			
			return authenticationInfo;
		}
		return null;
	}
}
