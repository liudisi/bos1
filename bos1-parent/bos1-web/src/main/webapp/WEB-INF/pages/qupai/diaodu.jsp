<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>人工调度</title>
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
	$(function() {
		// 先将body隐藏，再显示，不会出现页面刷新效果
		$("body").css({visibility:"visible"});
		
		$("#grid").datagrid({
			singleSelect : false,
			fit:true,
			onLoadSuccess:function(){
				$('.diaodu-btn').click(function(){
					$('#selects').datagrid('loadData',[{id:this.dataset.id}]);
					$('#selects').datagrid('checkAll');
					$("#diaoduWindow").window('open');
				});
			},
			toolbar : [ {
				id : 'diaodu-btn',
				text : '人工调度',
				iconCls : 'icon-add',
				handler : function() {
					var selects=$("#grid").datagrid('getSelections');
					if(selects.length<1){
						$.messager.alert('提示','未选择数据！','info');
						return;
					}
					$('#selects').datagrid('loadData',selects);
					$('#selects').datagrid('checkAll');
					$('#checkSelect').empty();
					selects.forEach(function(item){
						$('#checkSelect').append('<li style="padding:10px">'+item.id+'</li>');
					});
					
					// 弹出窗口
					$("#diaoduWindow").window('open');
					
				}
			},{
				iconCls:'icon-edit',
				text:'工单操作',
				handler:function(){
					location.href='${pageContext.request.contextPath }/page_qupai_noticebill.action';
				}
			} ],
			columns : [ [ {
				field : 'id',
				align:'center',
				checkbox:true,
			}, {
				field : 'delegater',
				title : '联系人',
				width : 100,
				align:'center'
			}, {
				field : 'telephone',
				title : '电话',
				width : 100,
				align:'center'
			}, {
				field : 'pickaddress',
				title : '取件地址',
				width : 350,
				align:'center'
			}, {
				field : 'product',
				title : '商品名称',
				width : 100,
				align:'center'
			}, {
				field : 'pickdate',
				title : '预约取件日期',
				width : 100,
				formatter:function(value){
					return value.substr(0,10);
				},
				align:'center'
			},{
				field:'userId',
				title:'查看受理人',
				width : 100,
				align:'center',
				formatter:function(value,rowData){
					return '<a style="text-decoration:none" href="${pageContext.request.contextPath}/user/info?id='+value+'">查看</a>';
				}
			},{
				field:'diaodu-btn',
				title:'操作',
				width : 100,
				align:'center',
				formatter:function(value,rowData){
					return '<a style="text-decoration:none" href="javascript:;" data-id="'+rowData.id+'" class="diaodu-btn"">安排取派员</a>';
				}
			} ] ],
			url : '${pageContext.request.contextPath}/noticebill/needmanMadeList?format=1'
		});
		
		$('#selects').datagrid({
		    columns:[[
				{field:'id',checkbox:true},
				{field:'idview',title:'点击取消该编号',formatter:function(value,rowData){return rowData.id}},
		    ]]
		});

		// 点击保存按钮，为通知单 进行分单 --- 生成工单
		$("#save").click(function() {
			var isSeleted=$('#staff-id').attr('isselecte');
			if(!Number(isSeleted)){
				$.messager.alert('提示','请选择取派员！','warning');
				return;
			}
			var count=$('#selects').datagrid('getSelections').length;
			if(count<1){
				$.messager.alert('警告','至少选择一行！','warning');
				return;
			}
			
			$.messager.progress({text:'提交中.....'}); 
			$('#diaoduForm').form('submit',{
				url:'${pageContext.request.contextPath}/noticebill/createWorkBill',
				success:function(resData){
					$.messager.progress('close');
					resData=JSON.parse(resData);
					if(resData.state==200){
						$("#diaoduWindow").window('close');
						$("#grid").datagrid('clearSelections');
						$("#grid").datagrid('reload');
						$.messager.confirm('成功', '分单成功是否前往查看？', function(r){
							if (r){
								location.href='${pageContext.request.contextPath}/page_qupai_noticebill.action';
							}
						});
					}else{
						$.messager.alert('失败',resData.msg,'error');
					}
				}
			});
		});
		
		
		$('#staff-id').combobox({
		    url:'${pageContext.request.contextPath }/staff/availableStaffList?format=1',
		    valueField:'id',
		    textField:'name',
		    onSelect:function(){
	    		$(this).attr('isSelecte',1);
	    	},
		    onUnselect:function(){
		    	$(this).attr('isSelecte',0);
		    }
		});
		
	});
</script>
</head>
<body class="easyui-layout" style="visibility:hidden;">
	<div data-options="region:'center',border:false">
		<table id="grid"></table>
	</div>
	<div class="easyui-window" title="人工调度" id="diaoduWindow"  closed="true" modal="true"
		collapsible="false" minimizable="false" maximizable="false"
		style="top:100px;left:200px;width: 400px;">
		<div region="north" style="height:31px;overflow:hidden;" split="false"
			border="false">
			<div class="datagrid-toolbar">
				<a id="save" icon="icon-save" href="#" class="easyui-linkbutton"
					plain="true">保存</a>
			</div>
		</div>
		<div region="center" style="overflow:auto;padding:5px;" border="false">
			<form id="diaoduForm" action="XXXXXXXXX" method="post">
				<table class="table-edit" width="80%" align="center">
					<tr>
						<td>选择取派员</td>
						<td><input id="staff-id" class="easyui-combobox" required="true" name="staff.id"/>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<div>
								<table title="请再次检查选择的单号" id="selects" border=0 style="height:200px"></table>
							</div>
						</td>
					</tr>
				</table>
			</form>
		</div>
	</div>
</body>
</html>