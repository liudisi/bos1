package cn.zzrfdsn.bos1.service;

import cn.zzrfdsn.bos1.model.Workbill;
import cn.zzrfdsn.bos1.vo.PageBean;

public interface IWorkbillService {
	
	void pageQuery(PageBean<Workbill> pageBean);

	void attachbill(String... ids);

	void cancelbill(String... ids);
}
