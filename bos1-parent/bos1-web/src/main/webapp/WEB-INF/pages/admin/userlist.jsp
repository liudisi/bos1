<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Insert title here</title>
		<!-- 导入jquery核心类库 -->
		<script type="text/javascript" src="${pageContext.request.contextPath }/js/jquery-1.8.3.js"></script>
		<!-- 导入easyui类库 -->
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath }/js/easyui/themes/default/easyui.css">
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath }/js/easyui/themes/icon.css">
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath }/js/easyui/ext/portal.css">
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath }/css/default.css">
		<script type="text/javascript" src="${pageContext.request.contextPath }/js/easyui/jquery.easyui.min.js"></script>
		<script type="text/javascript" src="${pageContext.request.contextPath }/js/easyui/ext/jquery.portal.js"></script>
		<script type="text/javascript" src="${pageContext.request.contextPath }/js/easyui/ext/jquery.cookie.js"></script>
		<script src="${pageContext.request.contextPath }/js/easyui/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
	</head>
	<body class="easyui-layout" style="visibility:hidden;">
		<div region="center" border="false">
			<table id="grid"></table>
		</div>
		<!-- 编辑窗口 -->
		<div class="easyui-window" title="修改用户" id="editWindow" collapsible="false" minimizable="false" maximizable="false" style="top:20px;left:200px">
			<div region="north" style="height:31px;overflow:hidden;" split="false" border="false">
				<div class="datagrid-toolbar">
					<a id="save" icon="icon-save" href="javascript:userEdit()" class="easyui-linkbutton" plain="true" >更新</a>
				</div>
			</div>
			
			<div region="center" style="overflow:auto;padding:5px;" border="false">
				<form id="editForm" method="post">
					<input type="hidden" name="id">
					<table class="table-edit" width="80%" align="center">
						<tr class="title">
							<td colspan="2">用户信息</td>
						</tr>
						<tr>
							<td>生日</td>
							<td><input name="birthday" id="birthday" class="easyui-validatebox easyui-datebox" data-options="validType:'md'" required="true"/></td>
						</tr>
						<tr>
							<td>联系电话</td>
							<td>
								<input type="text" name="telephone" id="telephone"  class="easyui-validatebox" validType="telephone"  />
							</td>
						</tr>
						<tr>
							<td>工资</td>
							<td>
								<input class="easyui-numberbox" name="salary" data-options="precision:2" />
							</td>
						</tr>
						<tr>
							<td>单位</td>
							<td>
								<select name="station" id="station" class="easyui-combobox" panelHeight="auto" style="width: 162px;">
				           			<option value="未分配">请选择</option>
				           			<option value="总公司">总公司</option>
				           			<option value="分公司">分公司</option>
				           			<option value="厅点">厅点</option>
				           			<option value="基地运转中心">基地运转中心</option>
				           			<option value="营业所">营业所</option>
				           		</select>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<table id="ownRole" style="width:'400px';height:160px"></table>
							</td>
						</tr>
					</table>
				</form>
			</div>
		</div>
	</body>
	<script type="text/javascript">
		// 工具栏
		var toolbar = [{
			id: 'button-view',
			text: '编辑',
			iconCls: 'icon-edit',
			handler: doView
		}, {
			id: 'button-add',
			text: '新增',
			iconCls: 'icon-add',
			handler: doAdd
		}, {
			id: 'button-delete',
			text: '删除',
			iconCls: 'icon-cancel',
			handler: doDelete
		}];
		
		// 定义标题栏
		var columns = [
			[
				
			{
				field: 'id',
				checkbox: true,
				rowspan: 2,
				width: 80,
			}, {
				field: 'username',
				title: '名称',
				width: 100,
				rowspan: 2
			},
			{
				field: 'gender',
				title: '性别',
				width: 60,
				rowspan: 2,
				align: 'center'
			}, {
				field: 'birthday',
				title: '生日',
				width: 120,
				rowspan: 2,
				align: 'center',
				formatter:function(value){
					return value.substr(0,10);
				}
			}, {
				title: '其他信息',
				colspan: 2
			}, {
				field: 'telephoneString',
				title: '电话',
				width: 150,
				rowspan: 2,
				align: 'center'
			},{
				field: 'roles',
				title: '拥有角色',
				width: 230,
				rowspan: 2,
				align: 'center',
				formatter:function(value,rowData){
					if(rowData.roleIds.length<1){
						return '无';
					}else{
						var roles=[];
						rowData.roleIds.forEach(function(item){
							roles.push(item[1])
						})
						return roles.join(",")
					}
					
				}
			}, {
				field: 'remark',
				title: '备注',
				width: 200,
				rowspan: 2,
				align: 'center'
			}],
			[{
				field: 'station',
				title: '单位',
				width: 120,
				align: 'center'
			}, {
				field: 'salary',
				title: '工资',
				width: 80,
				align: 'center'
			}]
		];
		
		$(function() {
			// 初始化 datagrid
			// 创建grid
			$('#grid').datagrid({
				iconCls: 'icon-forward',
				pagination:true,
				fit: true,
				border: false,
				rownumbers: true,
				striped: true,
				toolbar: toolbar,
				url : "${pageContext.request.contextPath}/user/listData?format=1",
				idField: 'id',
				columns: columns,
				onDblClickRow: doDblClickRow
			});
			
			$('#editWindow').window({
			    width:600,
			    height:440,
			    modal:true,
			    closed:true,
			});
			var now = new Date();
			$('#birthday').datebox().datebox('calendar').calendar({
				validator: function(date){
					var d1 = new Date(now.getFullYear()-80,now.getMonth(), now.getDate());
					var d2 = new Date(now.getFullYear()-16,now.getMonth(), now.getDate());
					return d1<=date && date<=d2;
				}
			});
			
			$.extend($.fn.validatebox.defaults.rules, {
				md: {
					validator: function(value){
						var inputDate = $.fn.datebox.defaults.parser(value);
						var now = new Date();
						var d1 = new Date(now.getFullYear()-80,now.getMonth(), now.getDate());
						var d2 = new Date(now.getFullYear()-16,now.getMonth(), now.getDate());
						return d1<=inputDate && inputDate<=d2;;
					},
					message: '日期格式为xxxx-xx-xx,范围：'+(now.getFullYear()-80)+'-'+now.getMonth()+'-'+now.getDate()+' 至 '+(now.getFullYear()-16)+'-'+now.getMonth()+'-'+now.getDate(),
				},
				telephone: {
					validator: function(value){
						var reg=/^1[3456789]\d{9}$/;
						return reg.test(value);
					},
					message: '请输入正确的手机号！'
			    }
			})
			
			$("body").css({
				visibility: "visible"
			});
		});
		
		
		function createRole(ids){
	    	$('#ownRole').datagrid({
                url: '${pageContext.request.contextPath}/role/allData?format=1',
                singleSelect:false,
                collapsible:true,
                border:false,
                title:'更改角色',
                showHeader:false,
                fitcolumns:true,
                columns:[[
            		{field:'id',width:'10%',formatter:function(value){
            			if(ids.includes(value)){
            				return '<input class="easyui-checkbox roleIds" data-options="checked:true" name="roleIds" value="'+value+'">'
            			}else{
            				return '<input class="easyui-checkbox roleIds" name="roleIds" value="'+value+'">'
            			}
            			
            		}},
            		{field:'name',width:'90%'},
                ]],
                onLoadSuccess:function(){
                	$.parser.parse($(this).parent());
                },
            });
	    }
		
		// 双击
		function doDblClickRow(rowIndex, rowData) {
			$('#editForm').form('load',rowData)
			$('#editForm input[name=telephone]').attr('placeholder',rowData.telephoneString);
			$('#editWindow').window('open');
			var ids=[];
			rowData.roleIds.forEach(function(item){
				ids.push(item[0])
			});
			createRole(ids);
			
		}
		
		function doAdd() {
			window.parent.location.href = "${pageContext.request.contextPath}/page_admin_userinfo.action";
		}
		function doView() {
			var rowData = $('#grid').datagrid('getSelected');
			$('#editForm').form('load',rowData)
			$('#editForm input[name=telephone]').attr('placeholder',rowData.telephoneString);
			$('#editWindow').window('open');
			var ids=[];
			rowData.roleIds.forEach(function(item){
				ids.push(item[0])
			});
			createRole(ids);
		}
		
		function doDelete() {
			
			var ids = [];
			var names=[];
			var items = $('#grid').datagrid('getSelections');
			if(items.length<1){
				return;
			}
			for (var i = 0; i < items.length; i++) {
				ids.push(items[i].id);
				names.push(items[i].username)
			}
			if(ids.includes('${loginUser.id}')){
				$.messager.alert('警告','不能删除自己！','warning');
				return;
			}
			$.messager.confirm('确认', '你确定要删除'+names.join(',')+'吗？', function(r){
				if (r){
					$.messager.progress({text:'请稍后......'}); 
					$.post('${pageContext.request.contextPath}/user/delete',{id:ids.join(",")},function(resData){
						$.messager.progress('close');
						if(resData.state==200){
							$.messager.alert('操作成功',resData.affectRow+'条记录已更新！','success');
							$('#grid').datagrid('reload');
							$('#grid').datagrid('clearSelections');
						}else{
							$.messager.alert('操作失败',resData.msg,'error');
						}
					},'json');
				}
			});
		}
		
		function userEdit(){
			var v=$('#editForm').form('validate');
			if(v){
				$.messager.progress({text:'请稍后......'}); 
				$('#editForm').form('submit',{
					url:'${pageContext.request.contextPath}/user/update',
					success:function(resData){
						$.messager.progress('close');
						resData=$.parseJSON(resData);
						if(resData.state==200){
							$.messager.alert('操作成功！','操作成功，用户信息已更新！','success');
							$('#grid').datagrid('clearSelections');
							$('#grid').datagrid('reload');
							$('#editForm').form('clear');
							$('#editWindow').window('close');
						}else{
							$.messager.alert('操作失败','修改用户失败，原因：'+resData.msg,'error');
						}
					}
				})
			}
		}
	</script>
</html>
