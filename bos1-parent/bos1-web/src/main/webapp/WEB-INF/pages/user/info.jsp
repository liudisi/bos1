<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>用户信息</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/easyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/easyui/themes/icon.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.8.3.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui/jquery.easyui.min.js"></script>
<style>
	.user-info-header{
		background: #5bc0de;
	}
	.user-info-header .panel-title{
		padding-left:22px;
		color: #FFF;
	}
	#userInfo div{
		padding: 8px 20px;
		
	}
	#userInfo div span{
		font-size: 18px
	}
</style>
</head>
<body class="easyui-layout">
<div region="north" style="height:40px;overflow:hidden;padding: 10px 0 0 10px" split="false" border="false" >
	<a href="javascript:history.back()" class="easyui-linkbutton" data-options="iconCls:'icon-back'">返回</a>
</div>
    <div data-options="region:'center'" style="padding:5px" border="false">
    	<div id="userInfo">
		    	<div>
		    		<span>账号：</span><s:property value="#user.username"/>
		    	</div>
		    	<div>
		    		<span>性别：</span><s:property value="#user.gender"/>
		    	</div>
		    	<div>
		    		<span>工资：</span><s:property value="#user.salary"/>
		    	</div>
		    	<div>
		    		<span>单位：</span><s:property value="#user.station"/>
		    	</div>
		    	<div>
		    		<span>角色：</span>
		    		<s:iterator var="role" value="#user.roles">${role.name } </s:iterator>
		    	</div>
		</div>
    </div>
</body>
<script type="text/javascript">
$('#userInfo').panel({
	iconCls:'icon-man',
    title:'用户信息',
    collapsible:true,
    headerCls:'user-info-header',
}); 
</script>
</html>