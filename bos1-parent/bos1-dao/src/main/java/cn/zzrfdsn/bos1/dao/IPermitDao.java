package cn.zzrfdsn.bos1.dao;

import java.util.List;

import cn.zzrfdsn.bos1.dao.base.IBaseDao;
import cn.zzrfdsn.bos1.model.Permit;
import cn.zzrfdsn.bos1.model.User;

public interface IPermitDao extends IBaseDao<Permit>{

	List<Permit> findAllForLeaves();

	List<Permit> findPermitByUserId(String userId);

	List<Permit> findAllMenu(User user, String menugroup);
}
