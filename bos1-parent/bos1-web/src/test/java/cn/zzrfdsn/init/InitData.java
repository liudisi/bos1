package cn.zzrfdsn.init;

import java.util.List;

import org.hibernate.HibernateException;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.hibernate5.HibernateCallback;
import org.springframework.orm.hibernate5.support.HibernateDaoSupport;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

/**
 * 插入初始化数据
 * @author SYL
 *
 */

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("classpath:applicationContext.xml")
@SuppressWarnings("unchecked")
public class InitData extends HibernateDaoSupport{

	@Autowired
	public void setSessionFactory1(SessionFactory sessionFactory) {
		super.setSessionFactory(sessionFactory);
	}
	
	@Test
	public void adminPermit() {
		
		String adminRoleCode="admin";
		
		
		getHibernateTemplate().execute(new HibernateCallback<List<String>>() {

			@Override
			public List<String> doInHibernate(Session session) throws HibernateException {
				Transaction transaction = session.beginTransaction();
				
				SQLQuery sqlQuery = session.createSQLQuery("select id from permit");
				
				List<String> list = sqlQuery.list();
				
				sqlQuery=session.createSQLQuery("select id from role where code=?");
				sqlQuery.setParameter(0, adminRoleCode);
				String  rid = (String) sqlQuery.uniqueResult();
				
				sqlQuery=session.createSQLQuery("delete from role_permit where role_id=?");
				sqlQuery.setParameter(0, rid);
				sqlQuery.executeUpdate();
				
				sqlQuery=session.createSQLQuery("insert into role_permit values(?,?)");
				sqlQuery.setParameter(0, rid);
				for (String pid : list) {
					sqlQuery.setParameter(1, pid);
					sqlQuery.executeUpdate();
				}
				
				transaction.commit();
				session.close();
				return list;
			}
		});
	}
}
