<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://shiro.apache.org/tags" prefix="shiro"%>
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
<script type="text/javascript">
	function doAdd() {
		//alert("增加...");
		$('#addStaffWindow').window("open");
	}

	function doView() {
		$('#searchStaffWindow').window("open");
	}

	function doDelete() {
		/* 获取所有选中行数据 */
		var rowDatas = $('#grid').datagrid('getSelections');
		if (rowDatas.length < 1) {
			$.messager.alert('未选择', '你一条数据也没有选择！', 'warning');
			return;
		}

		$.messager
				.confirm(
						'删除确认',
						'您确认要删除' + rowDatas.length + '条数据吗？',
						function(r) {
							if (r) {
								var ids = [];
								for (var i = 0; i < rowDatas.length; i++) {
									if (rowDatas[i].deltag != '1') {
										ids.push(rowDatas[i].id);
									}
								}
								if (ids.length <= 0) {
									$.messager.alert('未选择', '0条数据已更新', 'info');
									return;
								}
								$.messager.progress({
									title : '删除中.....'
								});
								$
										.post(
												'${pageContext.request.contextPath}/staff/delete',
												{
													'ids' : ids.join(',')
												},
												function(resData) {
													$.messager
															.progress('close');
													if (resData.state == 200) {
														$.messager
																.alert(
																		'成功',
																		'删除成功！'
																				+ resData.affectRow
																				+ '条数据已更新',
																		'info');
														$('#grid').datagrid(
																'reload');
													} else {
														$.messager
																.alert(
																		'失败',
																		'删除失败！原因：'
																				+ resData.msg,
																		'error');
													}
												});
							}
						});
	}

	function doRestore() {
		/* 获取所有选中行数据 */
		var rowDatas = $('#grid').datagrid('getSelections');
		if (rowDatas.length < 1) {
			$.messager.alert('未选择', '你一条数据也没有选择！', 'warning');
			return;
		}

		$.messager
				.confirm(
						'还原确认',
						'您确认要还原' + rowDatas.length + '条数据吗？',
						function(r) {
							if (r) {
								var ids = [];
								for (var i = 0; i < rowDatas.length; i++) {
									if (rowDatas[i].deltag != '0') {
										ids.push(rowDatas[i].id);
									}
								}
								if (ids.length <= 0) {
									$.messager.alert('未选择', '0条数据已更新', 'info');

									return;
								}
								$.messager.progress({
									title : '还原中.....'
								});
								$
										.post(
												'${pageContext.request.contextPath}/staff/restore',
												{
													'ids' : ids.join(',')
												},
												function(resData) {
													$.messager
															.progress('close');
													if (resData.state == 200) {
														$.messager
																.alert(
																		'成功',
																		'还原成功！'
																				+ resData.affectRow
																				+ '条数据已更新',
																		'info');
														$('#grid').datagrid(
																'reload');
													} else {
														$.messager
																.alert(
																		'失败',
																		'还原失败！原因：'
																				+ resData.msg,
																		'error');
													}
												});
							}
						});
	}
	//工具栏
	var toolbar = [ {
		id : 'button-view',
		text : '查询',
		iconCls : 'icon-search',
		handler : doView
	}, {
		id : 'button-add',
		text : '增加',
		iconCls : 'icon-add',
		handler : doAdd
	}, {
		id : 'button-delete',
		text : '作废',
		iconCls : 'icon-cancel',
		handler : doDelete
	}, {
		id : 'button-save',
		text : '还原',
		iconCls : 'icon-save',
		handler : doRestore
	} ];
	// 定义列
	var columns = [ [ {
		field : 'id',
		checkbox : true,
	}, {
		field : 'name',
		title : '姓名',
		width : 120,
		align : 'center'
	}, {
		field : 'telephone',
		title : '手机号',
		width : 120,
		align : 'center'
	}, {
		field : 'haspda',
		title : '是否有PDA',
		width : 120,
		align : 'center',
		formatter : function(data, row, index) {
			if (data == "1") {
				return "有";
			} else {
				return "无";
			}
		}
	}, {
		field : 'deltag',
		title : '是否作废',
		width : 120,
		align : 'center',
		formatter : function(data, row, index) {
			if (data == "0") {
				return "正常使用"
			} else {
				return "已作废";
			}
		}
	}, {
		field : 'standard',
		title : '取派标准',
		width : 120,
		align : 'center'
	}, {
		field : 'station',
		title : '所属单位',
		width : 200,
		align : 'center'
	} ] ];

	$(function() {
		// 先将body隐藏，再显示，不会出现页面刷新效果
		$("body").css({
			visibility : "visible"
		});

		// 取派员信息表格
		$('#grid').datagrid({
			iconCls : 'icon-forward',
			pagination : true,
			fit : true,
			border : false,
			rownumbers : true,
			striped : true,
			pagination : true,
			toolbar : toolbar,
			url : "${pageContext.request.contextPath}/staff/listData?format=1",
			idField : 'id',
			columns : columns,
			onDblClickRow : doDblClickRow
		});

		// 添加取派员窗口
		$('#addStaffWindow').window({
			title : '添加取派员',
			width : 400,
			modal : true,
			shadow : true,
			closed : true,
			height : 400,
			resizable : false
		});

		// 编辑取派员窗口
		$('#editStaffWindow').window({
			title : '编辑取派员',
			width : 400,
			modal : true,
			shadow : true,
			closed : true,
			height : 400,
			resizable : false
		});

	});

	function doDblClickRow(rowIndex, rowData) {
		//打开修改取派员窗口
		$('#editStaffWindow').window("open");
		//使用form表单对象的load方法回显数据
		$("#staffEditForm").form("load", rowData);
	}
</script>
</head>
<body class="easyui-layout" style="visibility: hidden;">
	<div region="center" border="false">
		<table id="grid"></table>
	</div>
	<!-- 添加窗口 -->
	<div class="easyui-window" title="添加收派员" id="addStaffWindow"
		collapsible="false" minimizable="false" maximizable="false"
		style="top: 20px; left: 200px">
		<div region="north" style="height: 31px; overflow: hidden;"
			split="false" border="false">
			<div class="datagrid-toolbar">
				<a id="save" icon="icon-save" href="javascript:staffAdd()"
					class="easyui-linkbutton" plain="true">保存</a>
			</div>
		</div>

		<div region="center" style="overflow: auto; padding: 5px;"
			border="false">
			<form id="staffAddForm"
				action="${pageContext.request.contextPath }/staff/add" method="post">
				<table class="table-edit" width="80%" align="center">
					<tr class="title">
						<td colspan="2">收派员信息</td>
					</tr>
					<!-- TODO 这里完善收派员添加 table -->
					<tr>
						<td>姓名</td>
						<td><input type="text" name="name" class="easyui-validatebox"
							required="true" /></td>
					</tr>
					<tr>
						<td>手机</td>
						<td><input type="text" name="telephone"
							class="easyui-validatebox" required="true" validType="telephone" /></td>
					</tr>
					<tr>
						<td>单位</td>
						<td><input type="text" name="station"
							class="easyui-validatebox" required="true" /></td>
					</tr>
					<tr>
						<td colspan="2"><input type="checkbox" name="haspda"
							value="1" /> 是否有PDA</td>
					</tr>
					<tr>
						<td>取派标准</td>
						<td><input type="text" name="standard"
							class="easyui-validatebox" required="true" /></td>
					</tr>
				</table>
			</form>
		</div>
	</div>

	<!-- 编辑窗口 -->
	<div class="easyui-window" title="修改收派员" id="editStaffWindow"
		collapsible="false" minimizable="false" maximizable="false"
		style="top: 20px; left: 200px">
		<div region="north" style="height: 31px; overflow: hidden;"
			split="false" border="false">
			<div class="datagrid-toolbar">
				<a id="save" icon="icon-save" href="javascript:staffEdit()"
					class="easyui-linkbutton" plain="true">更新</a>
			</div>
		</div>

		<div region="center" style="overflow: auto; padding: 5px;"
			border="false">
			<form id="staffEditForm"
				action="${pageContext.request.contextPath }/staff/edit"
				method="post">
				<input type="hidden" name="id">
				<table class="table-edit" width="80%" align="center">
					<tr class="title">
						<td colspan="2">收派员信息</td>
					</tr>
					<!-- TODO 这里完善收派员添加 table -->
					<tr>
						<td>姓名</td>
						<td><input type="text" name="name" class="easyui-validatebox"
							required="true" /></td>
					</tr>
					<tr>
						<td>手机</td>
						<td><input type="text" name="telephone"
							class="easyui-validatebox" required="true" validType="telephone" /></td>
					</tr>
					<tr>
						<td>单位</td>
						<td><input type="text" name="station"
							class="easyui-validatebox" required="true" /></td>
					</tr>
					<tr>
						<td colspan="2"><input type="checkbox" name="haspda"
							value="1" /> 是否有PDA</td>
					</tr>
					<tr>
						<td>取派标准</td>
						<td><input type="text" name="standard"
							class="easyui-validatebox" required="true" /></td>
					</tr>
				</table>
			</form>
		</div>
	</div>

	<!-- 查询窗口 -->
	<div class="easyui-window" id="searchStaffWindow" title="查询取派员"
		style="width: 400px; height: 400px; padding-top: 20px"
		data-options="collapsible:false,minimizable:false,maximizable:false,modal:true,closed:true">
		<form id="staffSearchForm">
			<table class="table-edit" width="80%" align="center">
				<tr class="title">
					<td colspan="2">收派员信息</td>
				</tr>
				<tr>
					<td>姓名</td>
					<td><input type="text" name="name" /></td>
				</tr>
				<tr>
					<td>手机</td>
					<td><input type="text" name="telephone" /></td>
				</tr>
				<tr>
					<td>单位</td>
					<td><input type="text" name="station" /></td>
				</tr>
				<tr>
					<td>是否有PDA：</td>
					<td><select data-options="panelHeight:'auto'"
						class="easyui-combobox" name="haspda" style="width: 80px;">
							<option selected="selected" value="">查全部</option>
							<option value="0">没有</option>
							<option value="1">有</option>
					</select></td>
				</tr>
				<tr>
					<td>是否作废：</td>
					<td><select data-options="panelHeight:'auto'"
						class="easyui-combobox" name="deltag" style="width: 80px;">
							<option selected="selected" value="">查全部</option>
							<option value="0">未作废</option>
							<option value="1">已作废</option>
					</select></td>
				</tr>
				<tr>
					<td>取派标准</td>
					<td><input type="text" name="standard" /></td>
				</tr>
				<tr>
					<td colspan="2" align="center"><a
						href="javascript:searchStaff();" class="easyui-linkbutton"
						data-options="iconCls:'icon-search'">搜索</a></td>
				</tr>
			</table>
		</form>
	</div>
	<script>
		$(function() {
			$.extend($.fn.validatebox.defaults.rules, {
				telephone : {
					validator : function(value) {
						var reg = /^1[3456789]\d{9}$/;
						return reg.test(value);
					},
					message : '请输入正确的手机号！'
				}
			})
		});

		function staffAdd() {
			var v = $('#staffAddForm').form('validate');
			if (v) {
				$('#staffAddForm').submit();
			}
		}

		function staffEdit() {
			var v = $('#staffEditForm').form('validate');
			if (v) {
				$('#staffEditForm').submit();
			}
		}

		//表单转json
		function form2Json(selector) {
			var jsonObj = {};
			var jsonArray = $(selector).serializeArray();
			$(jsonArray).each(function() {
				jsonObj[this.name] = this.value;
			});
			return jsonObj;
		}

		function searchStaff() {
			var data = form2Json('#staffSearchForm');
			data.search = 1;
			//重新加载表格数据
			$('#grid').datagrid('load', data);
			//关闭查询框
			$('#searchStaffWindow').window('close');
		}
	</script>
</body>
</html>
