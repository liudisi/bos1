package cn.zzrfdsn.bos1.web.action.base;

import java.io.IOException;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.struts2.ServletActionContext;
import org.hibernate.criterion.DetachedCriteria;

import com.opensymphony.xwork2.ActionSupport;
import com.opensymphony.xwork2.ModelDriven;

import cn.zzrfdsn.bos1.model.User;
import cn.zzrfdsn.bos1.utils.DateJsonValueProcessor;
import cn.zzrfdsn.bos1.utils.ResponseJsonUtil;
import cn.zzrfdsn.bos1.vo.PageBean;
import javassist.expr.NewArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

public class BaseAction<T> extends ActionSupport implements ModelDriven<T> {

	protected static final String LIST = "list";
	protected static final String HOME = "home";
	protected static final String AUTHENTICATIONFAILED = "authenticationFailed";

	protected static final String AJAX_SUCCESS = "成功！";
	protected static final Integer SUCCESS_STATE = 200;
	protected static final String AJAX_PARAMERROR = "参数有误！";
	protected static final Integer PARAMERROR_STATE = 400;
	protected static final String AJAX_SERVERERROR = "服务器内部错误！";
	protected static final Integer SERVERERROR_STATE = 500;
	protected static final Integer UNAUTHORIZED_STATE = 403;
	protected static final String AJAX_UNAUTHORIZED = "没有权限！";

	private static final long serialVersionUID = 1L;

//	实际Action对应模型驱动
	protected T model;
//	用于分页的bean
	protected PageBean<T> pageBean = new PageBean<T>();;
//	离线查询对象，会存到pagebean中一份
	protected DetachedCriteria detachedCriteria;
//	用于json返回状态码
	protected Integer state = PARAMERROR_STATE;
//	用于json返回信息
	protected String msg="";
//	用于转换json
	protected Map<String, Object> standardJsonObject = new HashMap<String, Object>();
//	用于搜索关键字
	protected String keyword;
	
	public String getKeyword() {
		return keyword;
	}
	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}
	
//	用于指定返回json格式
	protected Integer format=0;
	public Integer getFormat() {
		return format;
	}
	public void setFormat(Integer format) {
		this.format = format;
	}
	
	// 这个不能用属性,初始化时调用的时父类的变量，传过来的值无法赋值
	public void setPage(Integer page) {

		pageBean.setCurrentPage(page == null ? 1 : page);
	}

	public void setRows(Integer rows) {
		pageBean.setShowSize(rows == null ? 30 : rows);
	}

	@SuppressWarnings("unchecked")
	public BaseAction() {
		try {
//			获取运行时实际的action的model并实例化
			Type superClass = this.getClass().getGenericSuperclass();
			ParameterizedType superParamClass = (ParameterizedType) superClass;
			Type[] actualTypeArguments = superParamClass.getActualTypeArguments();
			Class<T> modelClass = (Class<T>) actualTypeArguments[0];
			model = modelClass.newInstance();
//			根据实际model创建离线查询对象，并放入pagebean中一份
			detachedCriteria = DetachedCriteria.forClass(modelClass);
			pageBean.setDetachedCriteria(detachedCriteria);
		} catch (InstantiationException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		}
	}

	@Override
	public T getModel() {
		return model;
	}

	/**
	 * 响应json数据
	 * 
	 * @param data         主要数据
	 * @param excludeField 不需要转为json的属性
	 * @return
	 */
	protected String reponseJson(Object data, String... excludeField) {
		if (StringUtils.isBlank(this.msg)) {
			switch (this.state) {
			case 200:
				this.msg = AJAX_SUCCESS;
				break;
			case 400:
				this.msg = AJAX_PARAMERROR;
				break;
			case 403:
				this.msg = AJAX_UNAUTHORIZED;
				break;
			case 500:
				this.msg = AJAX_SERVERERROR;
				break;
			}
		}
		standardJsonObject.put("state", this.state);
		standardJsonObject.put("msg", this.msg);
		if (data == null) {
			standardJsonObject.put("data", new int[] {});
		}else {
			standardJsonObject.put("data", data);
		}
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.registerJsonValueProcessor(Date.class, DateJsonValueProcessor.jsonValueProcessor);
		jsonConfig.setExcludes(excludeField);
		try {
			ResponseJsonUtil.responseJson(ServletActionContext.getResponse(), standardJsonObject, jsonConfig);
		} catch (Exception e) {
			JSONObject errorJson = new JSONObject();
			errorJson.element("state", SERVERERROR_STATE);
			errorJson.element("msg", AJAX_SERVERERROR);
			ResponseJsonUtil.responseJson(ServletActionContext.getResponse(), errorJson.toString());
			e.printStackTrace();
		}

		return null;
	}

	/**
	 * 响应json数据
	 * 
	 * @param useStandardJson 只把主要数据转json不添加其他元素(状态码，msg等)
	 * @param data            主要数据
	 * @param excludeField    不需要转为json的属性
	 * @return
	 */
	protected String reponseJson(Object data, boolean useStandardJson, String... excludeField) {
		if (useStandardJson) {
			reponseJson(data, excludeField);
		} else {
			JsonConfig jsonConfig = new JsonConfig();
			jsonConfig.registerJsonValueProcessor(Date.class, DateJsonValueProcessor.jsonValueProcessor);
			jsonConfig.setExcludes(excludeField);
			try {
				ResponseJsonUtil.responseJson(ServletActionContext.getResponse(), data, jsonConfig);
			} catch (Exception e) {
				JSONObject errorJson = new JSONObject();
				errorJson.element("state", SERVERERROR_STATE);
				errorJson.element("msg", AJAX_SERVERERROR);
				ResponseJsonUtil.responseJson(ServletActionContext.getResponse(), errorJson);
				e.printStackTrace();
			}
		}
		return null;
	}

	protected ServletOutputStream getFileDownloadOutPutStream(String fileName) throws IOException {
		// 根据文件后缀获取mime
		String mimeType = ServletActionContext.getServletContext().getMimeType(fileName);
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType(mimeType);
		// 解决中文文件名不显示问题;
//				String userAgent = ServletActionContext.getRequest().getHeader("User-Agent");
		response.setHeader("content-disposition", "attachment;filename=" + fileName);

		return response.getOutputStream();
	}
	
	/**
	 * 获取当前登录用户
	 * @return
	 */
	protected User getCurrentLoginUser() {
		return (User) ServletActionContext.getRequest().getSession().getAttribute("loginUser");
	}

}
