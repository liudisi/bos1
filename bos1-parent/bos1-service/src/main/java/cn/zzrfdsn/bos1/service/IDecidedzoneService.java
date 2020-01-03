package cn.zzrfdsn.bos1.service;

import java.io.Serializable;

import org.springframework.stereotype.Service;

import cn.zzrfdsn.bos1.model.Decidedzone;
import cn.zzrfdsn.bos1.vo.PageBean;

@Service
public interface IDecidedzoneService {
	Serializable save(Decidedzone decidedzone,String... subareaId);

	void pageQuery(PageBean<Decidedzone> pageBean);

	void update(Decidedzone model, String... subareaId);

	void batchDelete(String... ids);
}
