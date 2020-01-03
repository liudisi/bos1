package cn.zzrfdsn.bos1.utils;

import java.text.SimpleDateFormat;
import java.util.Date;

import net.sf.json.JsonConfig;
import net.sf.json.processors.JsonValueProcessor;

/**
 * date类型json处理
 * @author SYL
 *
 */
public class DateJsonValueProcessor implements JsonValueProcessor {
	
	private SimpleDateFormat dateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

	public static final DateJsonValueProcessor jsonValueProcessor=new DateJsonValueProcessor();
	
	private DateJsonValueProcessor() {
		super();
	}

	// 处理数组类型的值
	@Override
	public Object processArrayValue(Object array, JsonConfig config) {
		
		return array;
	}

	//处理对象类型的值
	@Override
	public Object processObjectValue(String filedName, Object object, JsonConfig config) {
		
		if (object instanceof Date) {
			return dateFormat.format(object);
		}
		
		return object;
	}

}
