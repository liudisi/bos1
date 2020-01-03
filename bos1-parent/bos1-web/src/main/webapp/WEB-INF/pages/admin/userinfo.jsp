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

</head>
<body class="easyui-layout" style="visibility:hidden;">
	<div region="north" style="height:31px;overflow:hidden;" split="false" border="false" >
		<div class="datagrid-toolbar">
			<a icon="icon-back" href="javascript:history.back()" class="easyui-linkbutton" plain="true" >返回</a>
			<a id="save" icon="icon-save" href="javascript:saveUser();" class="easyui-linkbutton" plain="true" >保存</a>
		</div>
	</div>
    <div region="center" style="overflow:auto;padding:5px;" border="false">
       <form id="userForm" action="${pageContext.request.contextPath }/user/add" method="post" >
           <table class="table-edit"  width="95%" align="center">
           		<tr class="title"><td colspan="4">基本信息</td></tr>
	           	<tr><td>用户名:</td><td><input type="text" name="username" id="username" class="easyui-validatebox" required="true" onblur="checkUserNameIsExist(this.value)"/></td>
					<td>口令:</td><td><input type="password" name="password" id="password" class="easyui-validatebox" required="true" validType="minLength[5]" /></td></tr>
				<tr class="title"><td colspan="4">其他信息</td></tr>
	           	<tr><td>工资:</td><td><input type="text" name="salary" id="salary" class="easyui-numberbox" /></td>
					<td>生日:</td><td><input name="birthday" id="birthday" class="easyui-validatebox easyui-datebox" data-options="validType:'md'" required="true"/></td></tr>
	           	<tr><td>性别:</td><td>
	           		<select name="gender" id="gender" class="easyui-combobox" style="width: 150px;">
	           			<option value="保密">请选择</option>
	           			<option value="男">男</option>
	           			<option value="女">女</option>
	           		</select>
	           	</td>
					<td>单位:</td><td>
					<select name="station" id="station" class="easyui-combobox" style="width: 150px;">
	           			<option value="未分配">请选择</option>
	           			<option value="总公司">总公司</option>
	           			<option value="分公司">分公司</option>
	           			<option value="厅点">厅点</option>
	           			<option value="基地运转中心">基地运转中心</option>
	           			<option value="营业所">营业所</option>
	           		</select>
				</td></tr>
				<tr>
					<td>联系电话</td>
					<td colspan="3">
						<input type="text" name="telephone" id="telephone" onblur="checkTelephoneIsExist(this.value)" class="easyui-validatebox" validType="telephone" required="true" />
					</td>
				</tr>
	           	<tr><td>备注:</td><td colspan="3"><textarea name="remark" style="width:80%"></textarea></td></tr>
	           	<tr>
	           		<td>角色:</td>
	           		<td colspan="3" id="roles">
	           		</td>
	           	</tr>
           </table>
       </form>
	</div>
	
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
			$('#save').click(function(){
				$('#form').submit();
			});
		});
	</script>	
	<script type="text/javascript">
		$(function(){
			
			$.post('${pageContext.request.contextPath}/role/allData',{},function(resData){
				//console.log(resData);
				var $roles=$('#roles');
				var data=resData.data;
				for(var i in data){
					$roles.append('<input name="roleIds" value="'+data[i].id+'" label="'+data[i].name+'">');
					
				}
				$('#roles input[name=roleIds]').checkbox({
				    label: this.name,
				    value: this.value,
				    labelPosition:'after'
				});
			},'json')
			
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
		})
	
		$(function(){
			$.extend($.fn.validatebox.defaults.rules, {
			    telephone: {
					validator: function(value){
						var reg=/^1[3456789]\d{9}$/;
						return reg.test(value);
					},
					message: '请输入正确的手机号！'
			    }
			})
		});
		
		function saveUser(){
			var v=$('#userForm').form('validate');
			if(v){
				$('#userForm').form('submit',{
					success:function(resData){
						resData=$.parseJSON(resData);
						if(resData.state==200){
							location.href='${pageContext.request.contextPath}/page_admin_userlist.action';
						}else{
							$.messager.alert('操作失败','添加用户失败，原因：'+resData.msg,'error');
						}
					}
				})
			}
		}
		
		function checkUserNameIsExist(value){
			if($.trim(value).length<1){
				return;
			}
			$.get('${pageContext.request.contextPath}/user/checkUserName',{username:value},function(resData){
				if(resData.exist){
					$.messager.alert('警告','用户名已经存在！','warning');
				}
			})
		}
		
		function checkTelephoneIsExist(value){
			if($.trim(value).length<1){
				return;
			}
			$.get('${pageContext.request.contextPath}/user/checkTelephone',{telephone:value},function(resData){
				console.log(resData)
				if(resData.exist){
					$.messager.alert('警告','手机号已经被绑定过了！','warning');
				}
			})
		}
	</script>
</body>
</html>