package cn.zzrfdsn.bos1.dao.impl;

import java.util.List;

import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import cn.zzrfdsn.bos1.dao.IWorkbillDao;
import cn.zzrfdsn.bos1.dao.base.impl.BaseDaoImpl;
import cn.zzrfdsn.bos1.model.Workbill;

@Repository
public class WorkbillDaoImpl extends BaseDaoImpl<Workbill> implements IWorkbillDao {

	@Override
	public List<Workbill> findAllNew() {
		DetachedCriteria detachedCriteria=DetachedCriteria.forClass(Workbill.class);
		detachedCriteria.add(Restrictions.eq("type", "新单"));
		return this.detachedCriteriaQuery(detachedCriteria);
	}
}
