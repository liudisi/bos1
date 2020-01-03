<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>添加业务受理单</title>
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
	$(function(){
		$("body").css({visibility:"visible"});
		
		// 对save按钮条件 点击事件
		$('#save').click(function(){
			// 对form 进行校验
			if($('#noticebillForm').form('validate')){
				$('#noticebillForm').form('submit',{
					url:'${pageContext.request.contextPath }/noticebill/add',
					success:function(resData){
						resData=$.parseJSON(resData);
						if(resData.state==200){
							var msg='通知单创建成功！'+(resData.type=="自动分单"?'已自动分单，是否前往查看生成的工单？':'自动分单失败，是否前往人工调度');
							
							$.messager.confirm('成功！',msg,function(r){
								if(r){
									if(resData.type=="自动分单"){
										$('a#edit')[0].click();
									}else{
										location.href='${pageContext.request.contextPath }/page_qupai_diaodu.action';
									}
								}else{
									location.reload();
								}
							})
						}else{
							$.messager.alert('出错了！',resData.msg,'error');
						}
					}
				});
			}
		});
	});
</script>
</head>
<body class="easyui-layout" style="visibility:hidden;">
	<div region="north" style="height:31px;overflow:hidden;" split="false"
		border="false">
		<div class="datagrid-toolbar">
			<a id="save" icon="icon-save" href="#" class="easyui-linkbutton"
				plain="true">保存新单</a>
			<a id="edit" icon="icon-edit" href="${pageContext.request.contextPath }/page_qupai_noticebill.action" class="easyui-linkbutton"
				plain="true">工单操作</a>	
		</div>
	</div>
	<div region="center" style="overflow:auto;padding:5px;" border="false">
		<form id="noticebillForm" action="" method="post">
			<input type="hidden" name="decidedzoneId"/>
			<table class="table-edit" width="95%" align="center">
				<tr class="title">
					<td colspan="4">客户信息</td>
				</tr>
				<tr>
					<td>来电号码:</td>
					<td><input type="text" class="easyui-validatebox" name="telephone"
						required="true" onblur="getCustomer(this.value)" /></td>
					<td>客户编号:</td>
					<td><input type="text" class="easyui-validatebox" readonly="readonly"  name="customerId"/></td>
				</tr>
				<tr>
					<td>客户姓名:</td>
					<td><input type="text" class="easyui-validatebox" name="customerName"
						required="true" /></td>
					<td>联系人:</td>
					<td><input type="text" class="easyui-validatebox" name="delegater"
						required="true" /></td>
				</tr>
				<tr class="title">
					<td colspan="4">货物信息</td>
				</tr>
				<tr>
					<td>品名:</td>
					<td><input type="text" class="easyui-validatebox" name="product"/></td>
					<td>件数:</td>
					<td><input type="text" class="easyui-numberbox" name="k"/></td>
				</tr>
				<tr>
					<td>重量:</td>
					<td><input type="text" class="easyui-numberbox" name="weight"/></td>
					<td>体积:</td>
					<td><input type="text" class="easyui-validatebox" name="volume"/></td>
				</tr>
				<tr>
					<td>取件地址</td>
					<td colspan="3"><input type="text" class="easyui-validatebox" name="pickaddress"
						required="true" size="144"/></td>
				</tr>
				<tr>
					<td>到达城市:</td>
					<td><input type="text" class="easyui-validatebox" name="arrivecity"
						required="true" /></td>
					<td>预约取件时间:</td>
					<td><input type="text" class="easyui-datebox" name="pickdate"
						data-options="required:true, editable:false" /></td>
				</tr>
				<tr>
					<td>备注:</td>
					<td colspan="3"><textarea rows="5" cols="80" type="text" class="easyui-validatebox" name="remark"></textarea></td>
				</tr>
			</table>
		</form>
	</div>
	<script type="text/javascript">
		function getCustomer(telephone){
			if($.trim(telephone).length<1){
				return;
			}
			$.post('${pageContext.request.contextPath}/noticebill/customerInfoByTelephone',{'telephone':telephone},function(resData){
				if(resData.state==200){
					var data=data=resData.data;
					var customerId=data.id||'';
					var customerName=data.name||'';
					var pickaddress=data.address||'';
					var decidedzoneId=data.decidedzoneId||'';
					$('input[name=customerId]').val(customerId);
					$('input[name=customerName]').val(customerName);
					$('input[name=delegater]').val(customerName);
					$('input[name=pickaddress]').val(pickaddress);
					$('input[name=decidedzoneId]').val(decidedzoneId);
				}else{
					$.messager.alert('出错了！',resData.msg,'error');
					$('input[name=customerId]').val('');
					$('input[name=customerName]').val('');
					$('input[name=delegater]').val('');
					$('input[name=pickaddress]').val('');
					$('input[name=decidedzoneId]').val('');
				}
			},'json')
		}
	</script>
</body>
</html>