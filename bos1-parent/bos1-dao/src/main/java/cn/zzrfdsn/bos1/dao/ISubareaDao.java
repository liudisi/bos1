package cn.zzrfdsn.bos1.dao;

import java.util.List;

import cn.zzrfdsn.bos1.dao.base.IBaseDao;
import cn.zzrfdsn.bos1.model.Subarea;

public interface ISubareaDao extends IBaseDao<Subarea>{

	List<Object> findAllGroupByProvince();
}
