<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>工作单快速录入</title>
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
	var editIndex ;
	
	function doAdd(){
		if(editIndex != undefined){
			$("#grid").datagrid('endEdit',editIndex);
		}
		if(editIndex==undefined){
			//alert("快速添加电子单...");
			$("#grid").datagrid('insertRow',{
				index : 0,
				row : {}
			});
			$("#grid").datagrid('beginEdit',0);
			editIndex = 0;
		}
	}
	
	function doSave(){
		if(editIndex != undefined){
			//结束之前easyui会去验证validate，不符合条件不会结束编辑editIndex就不会是undefined
			a=$("#grid").datagrid('endEdit',editIndex );
		}
	}
	
	function doCancel(){
		//是否为新增行
		var isNewAdd=false;
		if(editIndex!=undefined){
			$("#grid").datagrid('cancelEdit',editIndex);
			if($('#grid').datagrid('getRows')[editIndex].id == undefined){
				$("#grid").datagrid('deleteRow',editIndex);
				isNewAdd=true;
			}
			editIndex = undefined;
		}
		return isNewAdd;
	}
	
	//工具栏
	var toolbar = [ {
		id : 'button-add',	
		text : '新增一行',
		iconCls : 'icon-edit',
		handler : doAdd
	},{
		id : 'button-cancel',
		text : '取消编辑',
		iconCls : 'icon-cancel',
		handler : doCancel
	},{
		id : 'button-save',
		text : '保存',
		iconCls : 'icon-save',
		handler : doSave
	},{
		id : 'button-reload',
		text : '刷新页面',
		iconCls : 'icon-reload',
		handler : function(){
			location.reload();
		}
	}];
	// 定义列
	var columns = [ [ {
		field : 'sendername',
		title : '寄件人姓名',
		width : 120,
		align : 'center',
		editor :{
			type : 'validatebox',
			options : {
				required: true
			}
		}
	},{
		field : 'senderphone',
		title : '寄件人手机号',
		width : 120,
		align : 'center',
		editor :{
			type : 'validatebox',
			options : {
				required: true
			}
		}
	},{
		field : 'senderaddr',
		title : '寄件人地址',
		width : 120,
		align : 'center',
		editor :{
			type : 'validatebox',
			options : {
				required: true
			}
		}
	},{
		field : 'arrivecity',
		title : '到达城市',
		width : 120,
		align : 'center',
		editor :{
			type : 'validatebox',
			options : {
				required: true
			}
		}
	},{
		field : 'receivername',
		title : '收件人姓名',
		width : 120,
		align : 'center',
		editor :{
			type : 'validatebox',
			options : {
				required: true
			}
		}
	},{
		field : 'receiverphone',
		title : '收件人手机号',
		width : 120,
		align : 'center',
		editor :{
			type : 'validatebox',
			options : {
				required: true
			}
		}
	},{
		field : 'receiveraddr',
		title : '收件人地址',
		width : 120,
		align : 'center',
		editor :{
			type : 'validatebox',
			options : {
				required: true
			}
		}
	},{
		field : 'product',
		title : '产品',
		width : 120,
		align : 'center',
		editor :{
			type : 'validatebox',
			options : {
				required: true
			}
		}
	}] ];
	
	$(function(){
		// 先将body隐藏，再显示，不会出现页面刷新效果
		$("body").css({visibility:"visible"});
		
		// 收派标准数据表格
		$('#grid').datagrid( {
			iconCls : 'icon-forward',
			fit : true,
			border : true,
			rownumbers : true,
			striped : true,
			pageList: [30,50,100],
			pagination : true,
			toolbar : toolbar,
			url :  "",
			idField : 'id',
			columns : columns,
			onDblClickRow : doDblClickRow,
			onAfterEdit : function(rowIndex, rowData, changes){
				//判断是否修改
				var c=jQuery.isEmptyObject(changes) 
				if(!c){
					$.messager.progress({text:'保存中'}); 
					$.ajax('${pageContext.request.contextPath}/workordermanage/addOrUpdate',{
						async:false,
						dataType:'json',
						data:rowData,
						success:function(resData){
							if(resData.state==200){
								//保存到服务器后再放开可编辑状态
								editIndex = undefined;
								rowData.id=resData.id;
								$.messager.show({title:'成功!',width:180,height:100,timeout:1500,style:{top:'4px',left:'0',right:'0',margin:'auto',color:'#FFF',background:'rgba(255,255,255,0.6)'},msg:'保存成功!'})
							}else{
								$.messager.alert('失败',resData.msg+'！请刷新页面重试！','error');
							}
						},
						error:function(){
							$.messager.alert('失败','未知错误！请刷新页面重试！','error');
						},
						complete:function(){
							$.messager.progress('close');
						}
					})
				}else{
					//没有更新直接放开
					editIndex = undefined;
				}
			}
		});
	});

	function doDblClickRow(rowIndex, rowData){
		if(editIndex==rowIndex){
			return;
		}
		if(editIndex!=undefined){
			$.messager.confirm('提示','是否放弃当前编辑行？',function(r){
				if(r){
					if(doCancel()){
						rowIndex--;
					}
					$('#grid').datagrid('beginEdit',rowIndex);
					editIndex = rowIndex;
				}
			})
		}else{
			$('#grid').datagrid('beginEdit',rowIndex);
			editIndex = rowIndex;
		}
	}
</script>
</head>
<body class="easyui-layout" style="visibility:hidden;">
	<div region="center" border="false">
    	<table id="grid"></table>
	</div>
</body>
</html>