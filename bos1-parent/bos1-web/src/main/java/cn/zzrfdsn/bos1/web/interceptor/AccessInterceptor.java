package cn.zzrfdsn.bos1.web.interceptor;

import java.util.Map;

import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.interceptor.MethodFilterInterceptor;

public class AccessInterceptor extends MethodFilterInterceptor{
	private static final long serialVersionUID = 1L;

	@Override
	protected String doIntercept(ActionInvocation invocation) throws Exception {
		Map<String, Object> session = invocation.getInvocationContext().getSession();
		
		Object object = session.get("loginUser");
		if(object==null) {
			
			return "login";
		}
		return invocation.invoke();
	}

}
