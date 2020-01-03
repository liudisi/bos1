package cn.zzrfdsn.bos1.job;

import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;

import cn.hutool.extra.mail.MailUtil;
import cn.zzrfdsn.bos1.dao.IWorkbillDao;
import cn.zzrfdsn.bos1.model.Workbill;

public class MailJob {
	private static final Logger LOGGER=Logger.getLogger(MailJob.class);
	
	@Autowired
	private IWorkbillDao workbillDao;
	public void execute() {
		//查询系统新生成的订单，给管理员发送提醒信息
		List<Workbill> workbills = workbillDao.findAllNew();
		if(workbills!=null&&workbills.size()>0) {
			LOGGER.info("---------------------发送邮件----------------");
			String content="你有"+workbills.size()+"个新单待处理！";
			MailUtil.send("617751303@qq.com", "新单提醒", content, false);
			LOGGER.info("---------------------邮件已发送----------------");
		}
	}
}
