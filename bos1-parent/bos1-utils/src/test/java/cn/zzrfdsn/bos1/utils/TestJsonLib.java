package cn.zzrfdsn.bos1.utils;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.junit.Test;

import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

/**
 * 测试日期转换
 * @author SYL
 *
 */
public class TestJsonLib {

	@Test
	public void t1() {
		List<String> list=new ArrayList<String>();
		list.add("数学");
		list.add("英语");
		list.add("哲学");
		list.add("经济学");
		list.add("历史学");
		Student student=new Student("张三", 22, '男', new Date(), list);
		
		JsonConfig jsonConfig=new JsonConfig();
		jsonConfig.registerJsonValueProcessor(Date.class,DateJsonValueProcessor.jsonValueProcessor);
		
		JSONObject fromObject = JSONObject.fromObject(student,jsonConfig);
		
		System.out.println(fromObject.toString());
		
	}
}
