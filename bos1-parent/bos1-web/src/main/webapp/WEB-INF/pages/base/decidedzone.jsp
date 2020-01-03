<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>管理定区/调度排班</title>
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
	function doAdd(){
		//加载分区数据放在display为none中不加载
		$('#subareaGrid').datagrid('load');
		$('#subareaGrid').datagrid('getPanel').appendTo('#addDecidedzoneForm .subarea-table');
		$('#addDecidedzoneWindow').window("open");
	}
	
	function doEdit(){
		var selected=$('#grid').datagrid('getSelections');
		if(selected.length>1){
			$.messager.alert('操作有误','一次只能编辑一行数据！','warning');
			return;
		}
		if(selected.length<1){
			$.messager.alert('操作有误','未选择数据！','warning');
			return;
		}
		//加载分区数据放在display为none中不加载
		$('#subareaGrid').datagrid('load');
		$('#subareaGrid').datagrid('getPanel').appendTo('#editDecidedzoneForm .subarea-table');
		$('#editDecidedzoneWindow').window('open');
		selected[0]["staff.id"]=selected[0].staff.id;
		$('#editDecidedzoneForm').form('load',selected[0]);
	}
	
	function doDelete(){
		var rowDatas=$('#grid').datagrid('getSelections');
		if(rowDatas.length<1){
			$.messager.alert('操作有误','未选择数据！','warning');
			return;
		}
		$.messager.confirm('删除确认', '您确认要删除'+rowDatas.length+'条数据吗？', function(r){
			if (r){
				var ids=[];
				for(var i=0;i<rowDatas.length;i++){
						ids.push(rowDatas[i].id);
				}
				$.messager.progress({title:'删除中.....'});
				$.post('${pageContext.request.contextPath}/decidedzone/delete',{'ids':ids.join(',')},function(resData){
					$.messager.progress('close');
					if(resData.state==200){
						$.messager.alert('成功','删除成功！'+resData.affectRow+'条数据已更新','info');
						$('#grid').datagrid('clearSelections');
						$('#grid').datagrid('reload');
					}else{
						$.messager.alert('失败','删除失败！原因：'+resData.msg,'error');
					}
				});
			}
		});
	}
	
	function doSearch(){
		$('#searchDecidedzoneWindow').window("open");
	}
	
	function doAssociations(){
		$('#noassociationSelect').empty();
		$('#associationSelect').empty();
		
		var selectedRow=$('#grid').datagrid('getSelections');
		if(selectedRow.length!=1){
			$.messager.alert('提示','没有选择定区或选择数量超出1','warning');
			return;
		}
		var id=selectedRow[0].id;
		$('#customerDecidedZoneId').val(id);
		//获取没有关联的客户
		$.post('${pageContext.request.contextPath}/decidedzone/noAssociationCustomerData',{},function(resData){
			if(resData.state==200){
				for(var i in resData.data){
					var customer=resData.data[i];
					$('#noassociationSelect').append('<option value='+customer.id+'>'+customer.name+'('+customer.telephone+')</option>')
				}
				
				//获取没有关联的客户成功后再获取关联了选择定区的客户
				$.post('${pageContext.request.contextPath}/decidedzone/hasAssociationCustomerData',{'id':id},function(resData){
					if(resData.state==200){
						for(var i in resData.data){
							var customer=resData.data[i];
							$('#associationSelect').append('<option value='+customer.id+'>'+customer.name+'('+customer.telephone+')</option>')
						}
						
						$('#customerWindow').window('open');
					}else{
						$.messager.alert('加载失败',resData.msg,'error');
					}
				},'json');
				
				
			}else{
				$.messager.alert('加载失败',resData.msg,'error');
			}
		},'json')
	}
	
	//工具栏
	var toolbar = [ {
		id : 'button-search',	
		text : '查询',
		iconCls : 'icon-search',
		handler : doSearch
	}, {
		id : 'button-add',
		text : '增加',
		iconCls : 'icon-add',
		handler : doAdd
	}, {
		id : 'button-edit',	
		text : '修改',
		iconCls : 'icon-edit',
		handler : doEdit
	},{
		id : 'button-delete',
		text : '删除',
		iconCls : 'icon-cancel',
		handler : doDelete
	},{
		id : 'button-association',
		text : '关联客户',
		iconCls : 'icon-sum',
		handler : doAssociations
	}];
	// 定义列
	var columns = [ [ {
		field : 'id',
		title : '定区编号',
		width : 120,
		align : 'center'
	},{
		field : 'name',
		title : '定区名称',
		width : 120,
		align : 'center'
	}, {
		field : 'staff.name',
		title : '负责人',
		width : 120,
		align : 'center',
		formatter : function(data,row ,index){
			return row.staff.name;
		}
	}, {
		field : 'staff.telephone',
		title : '联系电话',
		width : 120,
		align : 'center',
		formatter : function(data,row ,index){
			return row.staff.telephone;
		}
	}, {
		field : 'staff.station',
		title : '所属公司',
		width : 120,
		align : 'center',
		formatter : function(data,row ,index){
			return row.staff.station;
		}
	} ] ];
	
	$(function(){
		// 先将body隐藏，再显示，不会出现页面刷新效果
		$("body").css({visibility:"visible"});
		
		$('#grid').datagrid( {
			iconCls : 'icon-forward',
			fit : true,
			border : true,
			rownumbers : true,
			striped : true,
			pageList: [30,50,100],
			pagination : true,
			toolbar : toolbar,
			url : "${pageContext.request.contextPath}/decidedzone/listData?format=1",
			idField : 'id',
			columns : columns,
			onDblClickRow : doDblClickRow
		});
		
		// 添加定区
		$('#addDecidedzoneWindow,#editDecidedzoneWindow').window({
	        title: '添加定区',
	        width: 600,
	        modal: true,
	        shadow: true,
	        closed: true,
	        height: 400,
	        resizable:false
	    });
		
		// 查询定区
		$('#searchDecidedzoneWindow').window({
	        title: '查询定区',
	        width: 400,
	        modal: true,
	        shadow: true,
	        closed: true,
	        height: 400,
	        resizable:false
	    });
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
	
	function searchDecidedzone(){
		var data=form2Json('#searchDecidedzoneForm');
		//重新加载表格数据
		$('#grid').datagrid('load',data);
		//关闭查询框
		$('#searchDecidedzoneWindow').window('close');
	}
	
	function doDblClickRow(rowIndex, rowData){
		var id=rowData.id;
		$('#association_subarea').datagrid( {
			fit : true,
			border : true,
			rownumbers : true,
			striped : true,
			url : "${pageContext.request.contextPath}/subarea/associationDecidedzoneList?format=1&decidedzone.id="+id,
			columns : [ [
			{
				field : 'id',
				title : '分区编号',
				width : 120,
				align : 'center'
			},{
				field : 'province',
				title : '省',
				width : 120,
				align : 'center',
				formatter : function(data,row ,index){
					return row.region.province;
				}
			}, {
				field : 'city',
				title : '市',
				width : 120,
				align : 'center',
				formatter : function(data,row ,index){
					return row.region.city;
				}
			}, {
				field : 'district',
				title : '区',
				width : 120,
				align : 'center',
				formatter : function(data,row ,index){
					return row.region.district;
				}
			}, {
				field : 'addresskey',
				title : '关键字',
				width : 120,
				align : 'center'
			}, {
				field : 'startnum',
				title : '起始号',
				width : 100,
				align : 'center'
			}, {
				field : 'endnum',
				title : '终止号',
				width : 100,
				align : 'center'
			} , {
				field : 'single',
				title : '单双号',
				width : 100,
				align : 'center'
			} , {
				field : 'position',
				title : '位置',
				width : 200,
				align : 'center'
			},{
				field : 'operation',
				title : '操作',
				width : 200,
				align : 'center',
				formatter:function(value,row,index){
					return '<a href="javascript:cancelAssociation(\''+row.id+'\');" class="easyui-linkbutton" data-options="iconCls:\'icon-search\'">取消关联</a>';
				}
			}
			] ]
		});
		$('#association_customer').datagrid( {
			fit : true,
			border : true,
			rownumbers : true,
			striped : true,
			url : "${pageContext.request.contextPath}/decidedzone/hasAssociationCustomerData?format=1&id="+id,
			columns : [[{
				field : 'id',
				title : '客户编号',
				width : 120,
				align : 'center',
			},{
				field : 'name',
				title : '客户名称',
				width : 120,
				align : 'center'
			}, {
				field : 'station',
				title : '所属单位',
				width : 120,
				align : 'center'
			}]]
		});
		
	}
	
	/* 添加定区 */
	function addDecidedzone(){
		var staff=$('#addDecidedzoneForm input[name="staff.id"]').val();
		if($.trim(staff).length<1){
			$.messager.alert('提示','请选择定区负责人！','warning');
			return;
		}
		var v=$('#addDecidedzoneForm').form('validate');
		if(v){
			$('#addDecidedzoneForm').form('submit',{
				url:'${pageContext.request.contextPath}/decidedzone/add',
				success:function(resData){
					resData=$.parseJSON(resData);
					if(resData.state==200){
						location.reload();
					}else{
						$.messager.alert('失败',resData.msg,'error');
					}
				}
			});
		}
		
	}
	
	/* 修改定区 */
	function updateDecidedzone(){
		var staff=$('#editDecidedzoneForm input[name="staff.id"]').val();
		if($.trim(staff).length<1){
			$.messager.alert('提示','请选择定区负责人！','warning');
			return;
		}
		var v=$('#editDecidedzoneForm').form('validate');
		if(v){
			$('#editDecidedzoneForm').form('submit',{
				url:'${pageContext.request.contextPath}/decidedzone/update',
				success:function(resData){
					resData=$.parseJSON(resData);
					if(resData.state==200){
						location.reload();
					}else{
						$.messager.alert('失败',resData.msg,'error');
					}
				}
			});
		}
		
	}
	
	/* 取消关联定区 */
	function cancelAssociation(subareaId){
		$.messager.confirm('确认', '你确定要取消关联吗？', function(r){
			if (r){
				$.post('${pageContext.request.contextPath}/subarea/cancelAssociationDecidezone',{id:subareaId},function(resData){
					if(resData.state==200){
						$('#association_subarea').datagrid('reload');
					}else{
						$.messager.alert('失败',resData.msg,'error');
					}
				},'json')
			}
		});
	}
</script>	
</head>
<body class="easyui-layout" style="visibility:hidden;">
	<div region="center" border="false">
    	<table id="grid"></table>
	</div>
	<div data-options="maximizable:true" region="south" border="false" style="height:150px">
		<div id="tabs" fit="true" class="easyui-tabs">
			<div title="关联分区" id="subArea"
				style="width:100%;height:100%;overflow:hidden">
				<table id="association_subarea"></table>
			</div>	
			<div title="关联客户" id="customers"
				style="width:100%;height:100%;overflow:hidden">
				<table id="association_customer"></table>
			</div>	
		</div>
	</div>
	
	<div style="display: none">
		<table id="subareaGrid" style="width:400px;height:150px"  class="easyui-datagrid" data-options="url:'${pageContext.request.contextPath}/subarea/noAssociationList?format=1',rownumbers:true,border:true,singleSelect:false">
			<thead>
		        <tr>  
		            <th data-options="field:'subareaId',checkbox:true">编号</th>  
		            <th data-options="field:'addresskey'">关键字</th>  
		            <th data-options="field:'position'">位置</th>  
		        </tr>  
		    </thead> 
		</table>
	</div>
	
	<!-- 添加定区 -->
	<div class="easyui-window" title="定区添加" id="addDecidedzoneWindow" collapsible="false" minimizable="false" maximizable="false" style="top:20px;left:200px">
		<div style="height:31px;overflow:hidden;" split="false" border="false" >
			<div class="datagrid-toolbar">
				<a id="save" icon="icon-save" href="javascript:addDecidedzone()" class="easyui-linkbutton" plain="true" >保存</a>
			</div>
		</div>
		<div style="overflow:auto;padding:5px;" border="false">
			<form id="addDecidedzoneForm" method="post">
				<table class="table-edit" align="center">
					<tr class="title">
						<td colspan="2">定区信息</td>
					</tr>
					<tr>
						<td>定区编码</td>
						<td><input type="text" name="id" class="easyui-validatebox" required="true"/></td>
					</tr>
					<tr>
						<td>定区名称</td>
						<td><input type="text" name="name" class="easyui-validatebox" required="true"/></td>
					</tr>
					<tr>
						<td>选择负责人</td>
						<td>
							<input class="easyui-combobox" name="staff.id"
    							data-options="valueField:'id',textField:'name',url:'${pageContext.request.contextPath }/staff/availableStaffList?format=1'" />  
						</td>
					</tr>
					<tr>
						<td valign="top">关联分区</td>
						<td class="subarea-table">
						</td>
					</tr>
				</table>
			</form>
		</div>
	</div>
	<!-- 修改定区 -->
	<div class="easyui-window" title="定区修改" id="editDecidedzoneWindow" collapsible="false" minimizable="false" maximizable="false" style="top:20px;left:200px">
		<div style="height:31px;overflow:hidden;" split="false" border="false" >
			<div class="datagrid-toolbar">
				<a icon="icon-save" href="javascript:updateDecidedzone();" class="easyui-linkbutton" plain="true" >更新</a>
			</div>
		</div>
		
		<div style="overflow:auto;padding:5px;" border="false">
			<form id="editDecidedzoneForm" method="post">
				<input type="hidden" name="id">
				<table class="table-edit" align="center">
					<tr class="title">
						<td colspan="2">定区信息</td>
					</tr>
					<tr>
						<td>定区名称</td>
						<td><input type="text" name="name" class="easyui-validatebox" required="true"/></td>
					</tr>
					<tr>
						<td>选择负责人</td>
						<td>
							<input class="easyui-combobox" name="staff.id"
    							data-options="valueField:'id',textField:'name',url:'${pageContext.request.contextPath }/staff/availableStaffList?format=1'" />  
						</td>
					</tr>
					<tr>
						<td valign="top">新增关联分区</td>
						<td class="subarea-table">
						</td>
					</tr>
				</table>
			</form>
		</div>
	</div>
	
	
	
	<!-- 查询定区 -->
	<div class="easyui-window" title="查询定区窗口" id="searchDecidedzoneWindow" collapsible="false" minimizable="false" maximizable="false" style="top:20px;left:200px">
		<div style="overflow:auto;padding:5px;" border="false">
			<form id="searchDecidedzoneForm">
				<table class="table-edit" width="80%" align="center">
					<tr class="title">
						<td colspan="2">查询条件</td>
					</tr>
					<tr>
						<td>定区编码</td>
						<td><input type="text" name="id"/></td>
					</tr>
					<tr>
						<td>定区名称</td>
						<td><input type="text" name="name"/></td>
					</tr>
					<tr>
						<td>负责人姓名</td>
						<td><input type="text" name="staff.name"/></td>
					</tr>
					<tr>
						<td>所属单位</td>
						<td><input type="text" name="staff.station"/></td>
					</tr>
					<tr>
						<td colspan="2"><a href="javascript:searchDecidedzone();" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a> </td>
					</tr>
				</table>
			</form>
		</div>
	</div>
	
	<!-- 关联客户窗口 -->
	<div class="easyui-window" modal="true" title="关联客户窗口" id="customerWindow" collapsible="false" closed="true" minimizable="false" maximizable="false" style="top:20px;left:200px;min-width:600px;height: 300px;">
		<div style="overflow:auto;padding:5px;" border="false">
			<form id="customerForm"  method="post">
				<table class="table-edit" width="80%" align="center">
					<tr class="title">
						<td colspan="3">关联客户</td>
					</tr>
					<tr>
						<td>
							<input type="hidden" name="id" id="customerDecidedZoneId" />
							<select id="noassociationSelect" multiple="multiple" size="10" style="min-width:110px"></select>
						</td>
						<td>
							<a class="easyui-linkbutton" data-options="iconCls:'icon-add'" style="margin: 6px;" href="javascript:customerAssociationDecidedzone();">关联到定区</a><br/>
							<a class="easyui-linkbutton" data-options="iconCls:'icon-remove'"  style="margin: 6px;" href="javascript:customerCancleAssociationDecidedzone();">取消关联</a>
						</td>
						<td>
							<select id="associationSelect" name="customerIds" multiple="multiple" size="10" style="min-width:110px"></select>
						</td>
					</tr>
					<tr>
						<td colspan="3"><a id="associationBtn" href="javascript:saveCustomerAssociation();" class="easyui-linkbutton" data-options="iconCls:'icon-save'">关联客户</a> </td>
					</tr>
				</table>
			</form>
		</div>
	</div>
</body>

<script>
	function customerAssociationDecidedzone(){
		$('#associationSelect').append($('#noassociationSelect option:selected'));
	}
	function customerCancleAssociationDecidedzone(){
		$('#noassociationSelect').append($('#associationSelect option:selected'));
	}
	function saveCustomerAssociation(){
		$('#associationSelect option').attr('selected',true);
		$('#customerForm').form('submit',{
			url:'${pageContext.request.contextPath}/decidedzone/customerAssociationToDecidedzone',
			success:function(resData){
				resData=$.parseJSON(resData);
				if(resData.state==200){
					location.reload();
				}else{
					$.messager.alert('保存失败',resData.msg,'error');
				}
			}
		})
	}
</script>
</html>