<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s" %>
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
<!-- 导入ztree类库 -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath }/js/ztree/zTreeStyle.css"
	type="text/css" />
<script
	src="${pageContext.request.contextPath }/js/ztree/jquery.ztree.all-3.5.js"
	type="text/javascript"></script>	
<script type="text/javascript">
	$(function(){
		// 授权树初始化
		var setting = {
			data : {
				simpleData : {
					enable : true
				}
			},
			check : {
				enable : true,
			},
			view:{
				showIcon:false
			}
		};
		
		$.ajax({
			url : '${pageContext.request.contextPath}/permit/levelsData?format=1',
			type : 'POST',
			dataType : 'json',
			success : function(data) {
				$.fn.zTree.init($("#functionTree"), setting, data);
				
				/* 携带id，编辑 */
				<s:if test="#parameters.id!=null">
					$.get('${pageContext.request.contextPath}/role/info',{id:'<s:property value="#parameters.id"/>'},function(resData){
						if(resData.state==200){
							var data=resData.data;
							$('#roleForm').form('load',data);
							var tree=$.fn.zTree.getZTreeObj("functionTree");
							resData.data.permits.forEach(function(item){
								var node=tree.getNodeByParam('id',item.id);
								tree.checkNode(node,true,false);
							});
						}else{
							$.messager.alert('错误！',resData.msg,'error');
						}
					},'json')
				</s:if>
			},
			error : function(msg) {
				alert('树加载异常!');
			}
		});
		
		// 点击保存
		$('#save').click(function(){
			var v=$('#roleForm').form('validate');
			if(v){
				$.messager.progress()
				var tree=$.fn.zTree.getZTreeObj("functionTree");
				var permits=tree.getCheckedNodes(true);
				var permitIds=[];
				for(var i=0;i<permits.length;i++){
					permitIds.push(permits[i].id);
				}
				$('input[name=permitIds]').val(permitIds.join(','));
				
				$('#roleForm').form('submit',{
					success:function(resData){
						$.messager.progress('close');
						resData=$.parseJSON(resData);
						if(resData.state==200){
							$.messager.confirm('操作成功', '${param.id==null?"添加":"修改"}成功！是否前往列表查看？', function(r){
								if (r){
									location.href="${pageContext.request.contextPath}/page_admin_role.action";
								}
							});
						}else{
							$.messager.alert('操作失败','${param.id==null?"添加":"修改"}失败，原因：'+resData.msg,'error');
						}
					}
				})
				
			}
		});
	});
	
</script>	
</head>
<body class="easyui-layout">
		<div region="north" style="height:31px;overflow:hidden;" split="false" border="false" >
			<div class="datagrid-toolbar">
				<a href="javascript:history.back();" class="easyui-linkbutton" plain="true" data-options="iconCls:'icon-back'">返回</a>
				<a id="save" icon="icon-save" href="javascript:;" class="easyui-linkbutton" plain="true" >保存</a>
			</div>
		</div>
		<div region="center" style="overflow:auto;padding:5px;" border="false">
			<form id="roleForm" method="post" action="${pageContext.request.contextPath }/role/addOrUpdate">
				<input type="hidden" name="permitIds">
				<s:if test="#parameters.id!=null">
					<input type="hidden" name="id" value="<s:property value='#parameters.id'/>">
				</s:if>
				<table class="table-edit" width="80%" align="center">
					<tr class="title">
						<td colspan="2">角色信息</td>
					</tr>
					<tr>
						<td width="200">关键字</td>
						<td>
							<input type="text" name="code" class="easyui-validatebox" data-options="required:true" />						
						</td>
					</tr>
					<tr>
						<td>名称</td>
						<td><input type="text" name="name" class="easyui-validatebox" data-options="required:true" /></td>
					</tr>
					<tr>
						<td>描述</td>
						<td>
							<textarea name="description" rows="4" cols="60"></textarea>
						</td>
					</tr>
					<tr>
						<td>授权</td>
						<td>
							<ul id="functionTree" class="ztree"></ul>
						</td>
					</tr>
					</table>
			</form>
		</div>
</body>
</html>