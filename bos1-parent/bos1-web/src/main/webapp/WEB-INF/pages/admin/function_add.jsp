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
</head>
<body class="easyui-layout">
<div data-options="region:'north'">
	<div class="datagrid-toolbar">
		<a  icon="icon-back" href="javascript:history.back();" class="easyui-linkbutton" plain="true" >返回</a>
		<a id="save" icon="icon-save" href="javascript:savePermit()" class="easyui-linkbutton" plain="true" >保存</a>
	</div>
</div>
<div data-options="region:'center'">
	<form id="functionForm" action="${pageContext.request.contextPath}/permit/add" method="post">
				<table class="table-edit" width="80%" align="center">
					<tr class="title">
						<td colspan="2">功能权限信息</td>
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
						<td>访问路径</td>
						<td><input type="text" name="page"/></td>
					</tr>
					<tr>
						<td>是否生成菜单</td>
						<td>
							<select name="generatemenu" class="easyui-combobox" style="width:162px">
								<option value="0">不生成</option>
								<option value="1">生成</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>优先级</td>
						<td>
							<input type="text" name="zindex" class="easyui-numberbox" data-options="required:true,prompt:'非菜单项填0即可'" />
						</td>
					</tr>
					<tr>
						<td>所属组</td>
						<td>
							<input type="text" name="menugroup" value="basic" class="easyui-textbox" data-options="required:true,missingMessage:'basic或者system'" />
						</td>
					</tr>
					<tr>
						<td>父功能点</td>
						<td>
							<input id="parentPermit" name="parentPermit.id" class="easyui-combotree"/>
						</td>
					</tr>
					<tr>
						<td>描述</td>
						<td>
							<textarea name="description" rows="4" cols="60"></textarea>
						</td>
					</tr>
					</table>
			</form>
</div>
<script type="text/javascript">
	function savePermit(){
		var v=$('#functionForm').form('validate');
		if(v){
			$.messager.confirm('提示','<p style="line-height:1.5rem">请仔细检查填写信息，提交后不可更改，暂不提供修改和删除操作！</p>',function(r){
				if(r){
					$.messager.progress({text:'请稍后......'})
					$('#functionForm').form('submit',{
						success:function(resData){
							$.messager.progress('close');
							resData=$.parseJSON(resData)
							if(resData.state==200){
								$.messager.confirm('操作成功', '添加成功！是否前往列表查看？', function(r){
									if (r){
										location.href="${pageContext.request.contextPath}/page_admin_function.action";
									}else{
										$('#parentPermit').combotree('reload');
									}
								});
							}else{
								$.messager.alert('操作失败','添加失败，原因：'+resData.msg,'error');
							}
						}
					});
				}
			})
		}
	}
	$(function(){
		$('#parentPermit').combotree({
			width:200,
			valueField:'id',
			url:'${pageContext.request.contextPath}/permit/levelsData?format=1',
		   	formatter:function(node){
		   		return node.name+'<span style="font-size:0.8em;color:#ccc;margin-left:1em">'+node.zindex+'</span>';
		   	},
		   	onLoadSuccess:function(){
		   		$('#parentPermit').combotree('tree').tree("collapseAll");
		   	}
		});
		
	})
</script>
</body>
</html>