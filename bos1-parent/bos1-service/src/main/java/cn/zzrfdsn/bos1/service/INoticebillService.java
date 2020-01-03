package cn.zzrfdsn.bos1.service;
/**
 * 通知单
 * @author SYL
 *
 */

import java.io.Serializable;
import java.util.List;

import org.hibernate.criterion.DetachedCriteria;

import cn.zzrfdsn.bos1.model.Noticebill;
import cn.zzrfdsn.bos1.model.User;
import cn.zzrfdsn.bos1.vo.PageBean;

public interface INoticebillService {
	/**
	 * 保存通知单并尝试进行自动分单
	 * @param noticebill
	 * @param decidedzoneId
	 * @return
	 */
	Serializable save(Noticebill noticebill,String decidedzoneId,User user);

	/**
	 * 根据给定的条件查询
	 * @param detachedCriteria
	 * @return
	 */
	List<Noticebill> findNoticebillListByGiveConditions(DetachedCriteria detachedCriteria);

	void pageQuery(PageBean<Noticebill> pageBean);

	void createWorkBill(String[] idArray, String id);
}
