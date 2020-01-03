package cn.zzrfdsn.bos1.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import cn.zzrfdsn.bos1.dao.ISubareaDao;
import cn.zzrfdsn.bos1.dao.base.impl.BaseDaoImpl;
import cn.zzrfdsn.bos1.model.Subarea;

@Repository
@SuppressWarnings("unchecked")
public class SubareaDaoImpl extends BaseDaoImpl<Subarea> implements ISubareaDao {

	@Override
	public List<Object> findAllGroupByProvince() {
		String hql="SELECT r.province,count(*) FROM Subarea s LEFT JOIN s.region r GROUP BY r.province";
		return (List<Object>) getHibernateTemplate().find(hql);
	}
}
