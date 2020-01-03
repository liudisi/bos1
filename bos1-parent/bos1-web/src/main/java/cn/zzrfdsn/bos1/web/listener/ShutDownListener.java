package cn.zzrfdsn.bos1.web.listener;

import java.util.Date;
import java.util.List;
import java.util.Set;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobDetail;
import org.quartz.JobKey;
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.quartz.Trigger;
import org.quartz.impl.matchers.GroupMatcher;
import org.springframework.scheduling.quartz.MethodInvokingJobDetailFactoryBean;
import org.springframework.scheduling.quartz.MethodInvokingJobDetailFactoryBean.MethodInvokingJob;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

/**
 * 关闭tomcat时销毁定时任务
 * 
 * @author SYL
 *
 */
public class ShutDownListener implements ServletContextListener {

	private Logger logger = Logger.getLogger(ShutDownListener.class);

	@Override
	public void contextInitialized(ServletContextEvent sce) {
		logger.info("----------tomcat启动------------");
	}

	@Override
	public void contextDestroyed(ServletContextEvent sce) {
		logger.info("销毁容器......关闭定时任务");
		try {
			WebApplicationContext webApplicationContext = WebApplicationContextUtils
					.getWebApplicationContext(sce.getServletContext());
			Scheduler scheduler = (Scheduler) webApplicationContext.getBean("scheduler");
			if (!scheduler.isShutdown()) {
				scheduler.shutdown(true);
			}
		} catch (SchedulerException e) {
			
		}
	}

}
