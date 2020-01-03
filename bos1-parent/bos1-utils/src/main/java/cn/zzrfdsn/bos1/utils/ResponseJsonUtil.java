package cn.zzrfdsn.bos1.utils;

import java.io.IOException;
import java.util.Collection;

import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

public class ResponseJsonUtil {

	private static final Logger LOGGER=Logger.getLogger(ResponseJsonUtil.class);
	
	public static void responseJson(HttpServletResponse response,String json){
		
		LOGGER.info(json);
		
		try {
			response.addHeader("Access-Control-Allow-Origin", "*");
			response.setContentType("application/json;charset=UTF-8");
			response.getWriter().write(json);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public static void responseJson(HttpServletResponse response,Object obj,JsonConfig jsonConfig){
		if(obj==null) {
			obj=new int[]{};
		}
		if(obj instanceof Collection||obj.getClass().isArray()) {
			String json = JSONArray.fromObject(obj,jsonConfig).toString();
			responseJson(response,json);
			return;
		}
		String json = JSONObject.fromObject(obj,jsonConfig).toString();
		responseJson(response,json);
	}
	
	public static void responseJson(HttpServletResponse response,Object obj){
		responseJson(response, obj, null);
	}
}
