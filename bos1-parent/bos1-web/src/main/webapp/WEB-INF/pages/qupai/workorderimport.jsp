<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>工作单批量导入</title>
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
<script type="text/javascript"
	src="${pageContext.request.contextPath }/js/jquery.ocupload.js"></script>	
<script type="text/javascript">
	$(function(){
		$("#grid").datagrid({
			url : '${pageContext.request.contextPath }/workordermanage/listData?format=1',
			toolbar : [
				{
					id : 'btn-download',
					text : '模板下载',
					iconCls : 'icon-syl-excel',
					handler : function(){
						location.href = "${pageContext.request.contextPath}/template/workorder-t.xls";
					}
				},{
					id : 'btn-upload',
					text : '批量导入',
					iconCls : 'icon-redo'
				},{
					id : 'btn-refresh',
					text : '刷新',
					iconCls : 'icon-reload',
					handler : function(){
						$("#grid").datagrid('reload');						
					}
				}        
			],
			columns : [[
				{
					field : 'id',
					title : '编号',
					width : 120 ,
					align : 'center'
				},{
					field : 'product',
					title : '产品',
					width : 120 ,
					align : 'center'
				},{
					field : 'prodtimelimit',
					title : '产品时限',
					width : 120 ,
					align : 'center',
					formatter:function(value){
						return value==""?"未录入":value;
					}
				},{
					field : 'prodtype',
					title : '产品类型',
					width : 120 ,
					align : 'center',
					formatter:function(value){
						return value==""?"未录入":value;
					}
				},{
					field : 'sendername',
					title : '发件人姓名',
					width : 120 ,
					align : 'center'
				},{
					field : 'senderphone',
					title : '发件人电话',
					width : 120 ,
					align : 'center'
				},{
					field : 'senderaddr',
					title : '发件人地址',
					width : 300,
					align : 'center'
				},{
					field : 'receivername',
					title : '收件人姓名',
					width : 120,
					align : 'center'
				},{
					field : 'receiverphone',
					title : '收件人电话',
					width : 120 ,
					align : 'center'
				},{
					field : 'receiveraddr',
					title : '收件人地址',
					width : 300,
					align : 'center'
				},{
					field : 'actlweit',
					title : '实际重量',
					width : 120 ,
					align : 'center',
					formatter:function(value){
						return value==""?"未录入":value;
					}
				},{
					field : 'updatetime',
					title : '最后修改时间',
					width : 120,
					align : 'center',
					formatter:function(value){
						return value.substr(0,10);
					}
				}
			]],
			pageList: [10,20,30],
			pagination : true,
			striped : true,
			singleSelect: true,
			rownumbers : true,
			fit : true // 占满容器
		});
		
		// 一键上传
		var workOrders=$("#btn-upload").upload({
			 name: 'workOrders',  // <input name="file" />
		     action: '${pageContext.request.contextPath}/workordermanage/batchImport',  // 提交请求action路径
		     enctype: 'multipart/form-data', // 编码格式
		     autoSubmit: false, // 选中文件提交表单
		     onSelect:function(){
					this.autoSubmit=false;
					$.messager.confirm('提示','确定上传'+this.filename()+'吗？确保文件后缀为xls',function(r){
						if(r){
							var index=workOrders.filename().lastIndexOf('.')+1;
							var subfix=workOrders.filename().substring(index);
							if(subfix=='xls'){
								workOrders.submit();
							}else{
								$.messager.alert('错误，','文件格式错误！非xls格式','warning');
							}
							
						}
					})
				},
		     onComplete: function(response) {
		    	 if(response==200){
		        		$.messager.alert("提示信息","数据导入成功！","info");
		        		$("#grid").datagrid("load");
		        	}else{
		        		
		        		if(response.length>30){
		        			$.messager.alert("错误提示",'导入失败，请检查数据格式是否正确......',"error");
		        			console.log(response);
		        		}else{
		        			$.messager.alert("错误提示",response,"error");
		        		}
		        		
		        	}
		     }// 请求完成时 调用函数
		});
	});
</script>	
</head>
<body class="easyui-layout" >
	<div region="center">
		<table id="grid"></table>
	</div>
</body>
</html>