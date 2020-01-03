package cn.zzrfdsn.bos1.dao;

import java.util.List;

import cn.zzrfdsn.bos1.dao.base.IBaseDao;
import cn.zzrfdsn.bos1.dao.impl.WorkbillDaoImpl;
import cn.zzrfdsn.bos1.model.Workbill;

public interface IWorkbillDao extends IBaseDao<Workbill> {

	List<Workbill> findAllNew();
}
