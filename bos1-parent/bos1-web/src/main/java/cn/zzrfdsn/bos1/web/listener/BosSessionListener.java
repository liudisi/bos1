package cn.zzrfdsn.bos1.web.listener;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

public class BosSessionListener implements HttpSessionListener{
	
	private static int onlineUser;

	@Override
	public void sessionCreated(HttpSessionEvent se) {
		ServletContext context = se.getSession().getServletContext();
		onlineUser++;
		context.setAttribute("onlineUser", onlineUser);
		
	}

	@Override
	public void sessionDestroyed(HttpSessionEvent se) {
		ServletContext context = se.getSession().getServletContext();
		onlineUser--;
		if(onlineUser<0)onlineUser=0;
		context.setAttribute("onlineUser", onlineUser);
	}

}
