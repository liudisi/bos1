package cn.zzrfdsn.bos1.dao.base.impl;

import java.io.Serializable;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.util.List;

import org.apache.log4j.Logger;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Projections;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.hibernate5.HibernateCallback;
import org.springframework.orm.hibernate5.support.HibernateDaoSupport;

import cn.zzrfdsn.bos1.dao.base.IBaseDao;
import cn.zzrfdsn.bos1.model.User;
import cn.zzrfdsn.bos1.utils.MD5Util;
import cn.zzrfdsn.bos1.vo.PageBean;

@SuppressWarnings("unchecked")
public class BaseDaoImpl<T> extends HibernateDaoSupport implements IBaseDao<T> {

	private static final Logger logger = Logger.getLogger(BaseDaoImpl.class);

	private Class<T> clazz;

	@Autowired
	public void MySetSessionFactory(SessionFactory sessionFactory) {

		super.setSessionFactory(sessionFactory);
	}

	public BaseDaoImpl() {
		Type superclass = this.getClass().getGenericSuperclass();
		ParameterizedType paramType = (ParameterizedType) superclass;
		clazz = (Class<T>) paramType.getActualTypeArguments()[0];

		logger.info("------------------" + clazz + "------------------------");

	}

	@Override
	public Serializable save(T t) {
		return getHibernateTemplate().save(t);
	}

	@Override
	public void delete(T t) {
		getHibernateTemplate().delete(t);
	}

	@Override
	public void update(T t) {
		getHibernateTemplate().update(t);
	}

	@Override
	public T findById(Serializable id) {
		return (T) getHibernateTemplate().get(clazz, id);
	}

	@Override
	public List<T> findAll() {
		return (List<T>) getHibernateTemplate().find("FROM " + clazz.getSimpleName());
	}

	@Override
	public int execute(String sqlName, Object... obj) {
		return this.getHibernateTemplate().execute(new HibernateCallback<Integer>() {

			@Override
			public Integer doInHibernate(Session session) throws HibernateException {
				Query query = session.getNamedQuery(sqlName);
				for (int i = 0; i < obj.length; i++) {
					query.setParameter(i, obj[i]);
				}
				int affectRow = query.executeUpdate();
				return affectRow;
			}

		});
	}

	@Override
	public void pageQuery(PageBean<T> pageBean) {
		DetachedCriteria detachedCriteria = pageBean.getDetachedCriteria();

		// 查询总记录数
		detachedCriteria.setProjection(Projections.rowCount());
		List<Long> total = (List<Long>) getHibernateTemplate().findByCriteria(pageBean.getDetachedCriteria());
		pageBean.setTotal(total.get(0).intValue());

		// 查询数据
		detachedCriteria.setProjection(null);
		// 指定封装对象的方式，连表查询时默认会将每个对象放到单独的数组中
		detachedCriteria.setResultTransformer(DetachedCriteria.DISTINCT_ROOT_ENTITY);
		List<T> rows = (List<T>) getHibernateTemplate().findByCriteria(detachedCriteria, pageBean.getStart(),
				pageBean.getShowSize());
		pageBean.setRows(rows);
	}

	@Override
	public void saveOrUpdate(T t) {
		getHibernateTemplate().saveOrUpdate(t);
	}

	@Override
	public List<T> detachedCriteriaQuery(DetachedCriteria detachedCriteria) {
		return (List<T>) getHibernateTemplate().findByCriteria(detachedCriteria);
	}

}
