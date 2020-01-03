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
<!-- 导入ztree类库 -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath }/js/ztree/zTreeStyle.css"
	type="text/css" />
<script
	src="${pageContext.request.contextPath }/js/ztree/jquery.ztree.all-3.5.js"
	type="text/javascript"></script>	
<script type="text/javascript">
	$(function(){
		// 数据表格属性
		$("#grid").datagrid({
			onLoadSuccess:function(){
				$('.ownPermits').each(function(){
					var data=JSON.parse(this.dataset.permits);
					$(this).combobox({
						data:data,
					    textField:'text',
					    valueField:'index',
					});
				})
			},
			toolbar : [
				{
					id : 'add',
					text : '添加角色',
					iconCls : 'icon-add',
					handler : function(){
						location.href='${pageContext.request.contextPath}/page_admin_role_add.action';
					}
				}           
			],
			url : '${pageContext.request.contextPath}/role/listData?format=1',
			pagination:true,
			fit:true,
			columns : [[
				{
					field : 'id',
					title : '编号',
					width : 300,
				},
				{
					field : 'name',
					title : '名称',
					width : 200
				}, 
				{
					field : 'description',
					title : '描述',
					width : 300
				},
				{
					field : 'ownPermits',
					title : '拥有权限',
					width:200,
					align:'center',
					formatter:function(value,rowData,index){
						var tempArr=value.split(',');
						for(var i=0;i<tempArr.length;i++){
							var tempJson={};
							tempJson.index=i;
							tempJson.disabled=true;
							tempJson.text=tempArr[i];
							tempArr[i]=tempJson
						}
						tempArr[0].selected=true;
					   	return '<input class="ownPermits" data-permits='+JSON.stringify(tempArr)+'>';
					}
				},{
					field:'operation',
					title:'操作',
					width:200,
					align:'center',
					formatter:function(value,rowData,index){
						if(rowData.code=='admin'){
							return '无';
						}
						return '<a class="bos1-button btn-info" href="${pageContext.request.contextPath}/page_admin_role_add.action?id='+rowData.id+'">修改</a><a class="bos1-button btn-warning" href="javascript:deleteRole(\''+rowData.id+'\',\''+rowData.name+'\')">删除</a>';
					}
				}
			]]
		});
		
	});
	
	function deleteRole(id,name){
		$.messager.confirm('确认','<p style="line-height:1.2rem">你确认要删除 '+name+' 角色吗？拥有相应角色的用户将失去角色对应的权限！请三思！</p>',function(r){
			if(r){
				$.post('${pageContext.request.contextPath}/role/delete',{id:id},function(resData){
					if(resData.state==200){
						$.messager.alert('操作成功',name+' 角色已删除！','success');
						$('#grid').datagrid('reload');
					}else{
						$.messager.alert('操作失败',resData.msg,'error');
					}
				},'json')
			}
		});
	}
</script>	
</head>
<body class="easyui-layout">
	<div data-options="region:'center'">
		<table id="grid"></table>
	</div>
</body>
</html>