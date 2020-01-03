<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<!-- 导入jquery核心类库 -->
<script type="text/javascript"
	src="${pageContext.request.contextPath }/js/jquery-1.8.3.js"></script>
<!-- 导入easyui类库 -->
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath }/js/easyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath }/js/easyui/themes/icon.css">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath }/js/easyui/ext/portal.css">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath }/css/default.css">	
<script type="text/javascript"
	src="${pageContext.request.contextPath }/js/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath }/js/easyui/ext/jquery.portal.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath }/js/easyui/ext/jquery.cookie.js"></script>
<script
	src="${pageContext.request.contextPath }/js/easyui/locale/easyui-lang-zh_CN.js"
	type="text/javascript"></script>	
<script type="text/javascript">
	$(function(){
		$("body").css({visibility:"visible"});
		// 注册按钮事件
		$('#reset').click(function() {
			$('#searchForm').form("clear");
		});
		// 注册所有下拉控件
		$("select").combobox( {
			width : 155,
			listWidth : 180,
			editable : false,
			panelHeight:'auto'
		});
		
		
		//表单转json
		function form2Json(selector){
			var jsonObj={};
			var jsonArray=$(selector).serializeArray();
			$(jsonArray).each(function(){
				jsonObj[this.name]=this.value;
			});
			return jsonObj;
		}
		
		// 注册ajax查询
		$('#ajax').click(function() {
			var data=form2Json('#searchForm');
			data.search=1;
			var elWin = $("#list").get(0).contentWindow;
			elWin.$('#grid').datagrid('load',data);
		});
	});
</script>	
</head>
<body class="easyui-layout" style="visibility:hidden;">
    <div region="east" title="查询条件" icon="icon-forward" style="width:180px;overflow:auto;" split="false" border="true" >
		<div class="datagrid-toolbar">	
			<a id="reset" href="#" class="easyui-linkbutton" plain="true" icon="icon-reload">重置</a>
		</div>
		
		<form id="searchForm" method="post" >
			<table class="table-edit" width="100%" >				
				<tr><td>
					<label>
						<span style="display: block;padding: 8px">用户名：</span>
						<input class="easyui-textbox" name="username" data-options="prompt:'Username',iconCls:'icon-man',iconWidth:38">
					</label>
				</td></tr>
				<tr><td>
					<span style="display: block;padding: 8px">性别：</span>
					<select id="gender" name="gender" >
					    <option value="">全部</option>
					    <option value="女">女</option>
					    <option value="男">男</option>
					</select>
				</td></tr>
				<tr><td>
					<span style="display: block;padding: 8px">生日：</span>
					<input type="text" editable="false" id="birthday" name="birthday" value="1900-01-01" class="easyui-datebox" />
					<p style="padding-left:20px;margin: 10px 0">至</p>
					<input type="text" editable="false" id="_birthday2" name="endBirthday" value="2019-09-01" class="easyui-datebox" />
				</td></tr>

			</table>
		</form>
		
		<div style="padding: 20px 0;text-align: center;">	
			<a id="ajax"href="javascript:;"  class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
		</div>
    </div>
    <div region="center" style="overflow:hidden;" border="false">
		<iframe id="list" src="${pageContext.request.contextPath }/page_admin_userlist.action" scrolling="no" style="width:100%;height:100%;border:0;"></iframe>
    </div>
</body>
</html>