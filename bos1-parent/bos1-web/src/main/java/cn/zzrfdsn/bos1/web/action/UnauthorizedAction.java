package cn.zzrfdsn.bos1.web.action;
/**
 * shiro验证没有权限，使用该action处理
 * @author SYL
 *
 */

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.struts2.ServletActionContext;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import cn.zzrfdsn.bos1.web.action.base.BaseAction;

@Controller
@Scope("prototype")
public class UnauthorizedAction extends BaseAction<Object>{
	private static final long serialVersionUID = 1L;

	@Override
		public String execute() throws Exception {
			HttpServletRequest request = ServletActionContext.getRequest();
			String method = request.getMethod();
			
			if(!"GET".equalsIgnoreCase(method)) {
				state=UNAUTHORIZED_STATE;
				this.reponseJson(null);
			}else {
				return AUTHENTICATIONFAILED;
			}
			return null;
		}
}
