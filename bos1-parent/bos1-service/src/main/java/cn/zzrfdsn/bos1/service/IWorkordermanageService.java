package cn.zzrfdsn.bos1.service;

import java.util.List;

import cn.zzrfdsn.bos1.model.Workordermanage;
import cn.zzrfdsn.bos1.vo.PageBean;

public interface IWorkordermanageService {
	
	String save(Workordermanage workordermanage);
	
	void update(Workordermanage workordermanage);
	
	void pageQuery(PageBean<Workordermanage> pageBean);

	void batchSaveOrUpdate(List<Workordermanage> workordermanages);
}
