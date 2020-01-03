package cn.zzrfdsn.bos1.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import cn.zzrfdsn.bos1.dao.IPermitDao;
import cn.zzrfdsn.bos1.dao.base.impl.BaseDaoImpl;
import cn.zzrfdsn.bos1.model.Permit;
import cn.zzrfdsn.bos1.model.User;

@Repository
public class PermitDaoImpl extends BaseDaoImpl<Permit> implements IPermitDao {

	/**
	 * 层级数据
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Permit> findAllForLeaves() {
		String hql="FROM Permit WHERE pid is null";
		return (List<Permit>) getHibernateTemplate().find(hql);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Permit> findPermitByUserId(String userId) {
		String hql="SELECT DISTINCT p "
				+ "FROM Permit p "
				+ "LEFT JOIN p.roles r "
				+ "LEFT JOIN r.users u "
				+ "WHERE u.id=?";
		
		return (List<Permit>) getHibernateTemplate().find(hql, userId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Permit> findAllMenu(User user,String menugroup) {
		String hql="SELECT DISTINCT p "
				+ "FROM Permit p "
				+ "LEFT JOIN p.roles r "
				+ "LEFT JOIN r.users u "
				+ "WHERE p.generatemenu=? AND menugroup=? AND u.id=? ORDER BY zindex DESC";
		
		return (List<Permit>) getHibernateTemplate().find(hql, "1",menugroup,user.getId());
	}
}	
