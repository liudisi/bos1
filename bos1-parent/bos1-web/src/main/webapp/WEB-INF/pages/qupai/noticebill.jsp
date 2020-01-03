<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>业务通知单</title>
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
	
	function doRepeat(){
		/* 获取所有选中行数据 */
		var rowDatas=$('#grid').datagrid('getSelections');
		if(rowDatas.length<1){
			$.messager.alert('未选择','你一条数据也没有选择！','warning');
			return;
		}
		
		var ids=[];
		for(var i=0;i<rowDatas.length;i++){
			ids.push(rowDatas[i].id);
		}
		$.messager.progress({title:'更新中.....'});
		$.post('${pageContext.request.contextPath}/workbill/attachbill',{'ids':ids.join(',')},function(resData){
			$.messager.progress('close');
			if(resData.state==200){
				$.messager.alert('成功','催单成功！'+resData.affectRow+'条数据已更新','info');
				$('#grid').datagrid('reload');
			}else{
				$.messager.alert('失败','催单失败！原因：'+resData.msg,'error');
			}
		});
	}
	
	function doCancel(){
		/* 获取所有选中行数据 */
		var rowDatas=$('#grid').datagrid('getSelections');
		if(rowDatas.length<1){
			$.messager.alert('未选择','你一条数据也没有选择！','warning');
			return;
		}
		
		var ids=[];
		for(var i=0;i<rowDatas.length;i++){
			if(rowDatas[i].type=="销单"){
				continue;
			}
			ids.push(rowDatas[i].id);
		}
		if(ids.length<1){
			$.messager.alert('成功','0条数据已更新','info');
			return;
		}
		$.messager.progress({title:'更新中.....'});
		$.post('${pageContext.request.contextPath}/workbill/cancelbill',{'ids':ids.join(',')},function(resData){
			$.messager.progress('close');
			if(resData.state==200){
				$.messager.alert('成功','销单成功！'+resData.affectRow+'条数据已更新','info');
				$('#grid').datagrid('reload');
			}else{
				$.messager.alert('失败','销单失败！原因：'+resData.msg,'error');
			}
		});
	}
	
	function doSearch(){
		$('#searchWindow').window("open");
	}
	
	//工具栏
	var toolbar = [ {
		id : 'button-return',	
		text : '返回',
		iconCls : 'icon-back',
		handler : function(){
			window.history.back()
		}
	},{
		id : 'button-search',	
		text : '查询',
		iconCls : 'icon-search',
		handler : doSearch
	}, {
		id : 'button-repeat',
		text : '催单',
		iconCls : 'icon-redo',
		handler : doRepeat
	}, {
		id : 'button-cancel',	
		text : '销单',
		iconCls : 'icon-cancel',
		handler : doCancel
	}];
	// 定义列
	var columns = [ [ {
		field : 'noticebill_id',
		checkbox : true,
	}, {
		field : 'id',
		title : '通知单号',
		width : 280,
		align : 'center'
	},{
		field : 'type',
		title : '工单类型',
		width : 80,
		align : 'center'
	}, {
		field : 'pickstate',
		title : '取件状态',
		width : 80,
		align : 'center'
	}, {
		field : 'buildtime',
		title : '工单生成时间',
		width : 200,
		align : 'center'
	}, {
		field : 'attachbilltimes',
		title : '催单次数',
		width : 80,
		align : 'center'
	},{
		field : 'noticebill.ordertype',
		title : '分单类型',
		width : 100,
		align : 'center',
		formatter:function(value,rowData,index){
			return rowData.noticebill.ordertype;
		}
	},{
		field : 'noticebill.customerName',
		title : '客户',
		width : 100,
		align : 'center',
		formatter:function(value,rowData,index){
			return rowData.noticebill.customerName;
		}
	},{
		field : 'staff.name',
		title : '取派员',
		width : 100,
		align : 'center',
		formatter:function(value,rowData,index){
			return rowData.staff.name;
		}
	}, {
		field : 'staff.telephone',
		title : '取派员联系方式',
		width : 150,
		align : 'center',
		formatter:function(value,rowData,index){
			return rowData.staff.telephone;
		}
	},{
		field:'userId',
		title:'查看受理人',
		width : 100,
		formatter:function(value,rowData){
			return '<a class="bos1-button btn-info" href="${pageContext.request.contextPath}/user/info?id='+rowData.noticebill.userId+'">查看</a>';
		},
		align:'center'
	} ] ];
	
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
			url :  "${pageContext.request.contextPath}/workbill/listData?format=1",
			idField : 'id',
			columns : columns,
			onDblClickRow : doDblClickRow
		});
		
		// 查询分区
		$('#searchWindow').window({
	        title: '查询分区',
	        width: 400,
	        modal: true,
	        shadow: true,
	        closed: true,
	        height: 400,
	        resizable:false
	    });
	});

	function doDblClickRow(){
		alert("双击表格数据...");
	}
	
	//表单转json
	function form2Json(selector){
		var jsonObj={};
		var jsonArray=$(selector).serializeArray();
		$(jsonArray).each(function(){
			jsonObj[this.name]=this.value;
		});
		return jsonObj;
	}
	
	function search(){
		var data=form2Json('#searchForm');
		data.search=1;
		//重新加载表格数据
		$('#grid').datagrid('load',data);
		//关闭查询框
		$('#searchWindow').window('close');
	}
</script>	
</head>
<body class="easyui-layout" style="visibility:hidden;">
	<div region="center" border="false">
    	<table id="grid"></table>
	</div>
	
	<!-- 查询 -->
	<div class="easyui-window" title="查询窗口" id="searchWindow" collapsible="false" minimizable="false" maximizable="false" style="top:20px;left:200px">
		<div style="overflow:auto;padding:5px;" border="false">
			<form id="searchForm" method="post">
				<table class="table-edit" width="80%" align="center">
					<tr class="title">
						<td colspan="2">查询条件</td>
					</tr>
					<tr>
						<td>客户电话</td>
						<td><input type="text" name="noticebill.telephone"/></td>
					</tr>
					<tr>
						<td>取派员</td>
						<td><input type="text" name="staff.name"/></td>
					</tr>
					<tr>
						<td>受理时间(大于)</td>
						<td><input id="dd" type="text" class="easyui-datebox" name="buildtime"></td>
					</tr>
					<tr>
						<td>催单次数(大于)</td>
						<td><input type="text" class="easyui-numberbox" name="attachbilltimes" data-options="min:0,precision:0"></td>
					</tr>
					<tr>
						<td>工单类型</td>
						<td>
							<select data-options="panelHeight:'auto'" class="easyui-combobox" name="pickstate" style="width:162px;">
							    <option value="-1">全部</option>
							    <option value="未取件">未取件</option>
							    <option value="已取件">已取件</option>
							    <option value="取件中">取件中</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>取件状态</td>
						<td>
							<select data-options="panelHeight:'auto'" class="easyui-combobox" name="type" style="width:162px;">
							    <option value="-1">全部</option>
							    <option value="新单">新单</option>
							    <option value="催单">催单</option>
							    <option value="改单">改单</option>
							    <option value="销单">销单</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>是否自动分单</td>
						<td>
							<select data-options="panelHeight:'auto'" class="easyui-combobox" name="noticebill.ordertype" style="width:162px;">
							    <option value="-1">全部</option>
							    <option value="自动分单">是</option>
							    <option value="人工分单">否</option>
							</select>
						</td>
					</tr>
					<tr>
						<td colspan="2"><a href="javascript:search();" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a> </td>
					</tr>
				</table>
			</form>
		</div>
	</div>
</body>
</html>