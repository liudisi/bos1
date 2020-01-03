package cn.zzrfdsn.bos1.dao.impl;

import java.io.Serializable;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Repository;

import cn.zzrfdsn.bos1.dao.IWorkordermanageDao;
import cn.zzrfdsn.bos1.dao.base.impl.BaseDaoImpl;
import cn.zzrfdsn.bos1.model.Fastnumber;
import cn.zzrfdsn.bos1.model.Workordermanage;
import javassist.expr.NewArray;

@Repository
public class WorkordermanageDaoImpl extends BaseDaoImpl<Workordermanage> implements IWorkordermanageDao {

	
	@Override
	public Serializable save(Workordermanage workordermanage) {
		//先获取单号
		Long id = (Long) getHibernateTemplate().save(new Fastnumber());
		workordermanage.setId("SYL"+id);
		return super.save(workordermanage);
	}
	
	@Override
	public void saveOrUpdate(Workordermanage workordermanage) {
		if(StringUtils.isBlank(workordermanage.getId())) {
			//先获取单号
			Long id = (Long) getHibernateTemplate().save(new Fastnumber());
			workordermanage.setId("SYL"+id);
		}
		
		super.saveOrUpdate(workordermanage);
	}
}
