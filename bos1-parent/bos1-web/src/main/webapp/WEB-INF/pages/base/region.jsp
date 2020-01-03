<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>区域设置</title>
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
<script src="${pageContext.request.contextPath }/js/jquery.ocupload.js"></script>
<script type="text/javascript">
	function doAdd(){
		$("#RegionForm").form("clear");
		$('#addRegionWindow').window({title:'添加区域'}).window("open");
	}
	
	function doView(){
		var selected=$('#grid').datagrid('getSelections');
		if(selected.length>1){
			$.messager.alert('操作有误','一次只能编辑一行数据！','warning');
			return;
		}
		if(selected.length<1){
			$.messager.alert('操作有误','未选择数据！','warning');
			return;
		}
		$('#addRegionWindow').window({title:'修改区域'}).window("open");
		//使用form表单对象的load方法回显数据
		$("#RegionForm").form("load",selected[0]);
	}
	
	function addOrUpadteRegion(){
		var v=$("#RegionForm").form('validate');
		if(!v){
			return;
		}
		$.messager.progress(); 
		$("#RegionForm").form("submit",{
			url:'${pageContext.request.contextPath }/region/addOrUpdate',
			success:function(resData){
				$.messager.progress('close');
				resData=JSON.parse(resData);
				if(resData.state==200){
					$('#addRegionWindow').window('close');
					$.messager.alert('操作成功','更新数据成功！','info');
					$('#grid').datagrid('load');
					
				}else{
					$.messager.alert('操作失败',resData.msg,'error');
				}
				
			}
		});
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
				$.post('${pageContext.request.contextPath}/region/delete',{'ids':ids.join(',')},function(resData){
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
	
	function importRegion(){
		
	}
	
	//工具栏
	var toolbar = [ {
		id : 'button-edit',	
		text : '修改',
		iconCls : 'icon-edit',
		handler : doView
	}, {
		id : 'button-add',
		text : '增加',
		iconCls : 'icon-add',
		handler : doAdd
	}, {
		id : 'button-delete',
		text : '删除',
		iconCls : 'icon-cancel',
		handler : doDelete
	}, {
		id : 'button-import',
		text : '导入',
		iconCls : 'icon-redo'
	},{
		id : 'button-templateDownlaoad',
		text : '模板下载',
		iconCls : 'icon-syl-excel',
		handler : function(){
			location.href='${pageContext.request.contextPath}/template/region-t.xls';
		}
	}
	];
	// 定义列
	var columns = [ [ {
		field : 'id',
		checkbox : true,
	},{
		field : 'province',
		title : '省',
		width : 120,
		align : 'center'
	}, {
		field : 'city',
		title : '市',
		width : 120,
		align : 'center'
	}, {
		field : 'district',
		title : '区',
		width : 120,
		align : 'center'
	}, {
		field : 'postcode',
		title : '邮编',
		width : 120,
		align : 'center'
	}, {
		field : 'shortcode',
		title : '简码',
		width : 120,
		align : 'center'
	}, {
		field : 'citycode',
		title : '城市编码',
		width : 200,
		align : 'center'
	} ] ];
	
	$(function(){
		// 先将body隐藏，再显示，不会出现页面刷新效果
		$("body").css({visibility:"visible"});
		
		// 收派标准数据表格
		$('#grid').datagrid( {
			iconCls : 'icon-forward',
			fit : true,
			border : false,
			rownumbers : true,
			striped : true,
			pageList: [30,50,100],
			pagination : true,
			toolbar : toolbar,
			url : "${pageContext.request.contextPath}/region/listData?format=1",
			idField : 'id',
			columns : columns,
			onDblClickRow : function(index,rowData){
				$('#addRegionWindow').window({title:'修改区域'}).window("open");
				//使用form表单对象的load方法回显数据
				$("#RegionForm").form("load",rowData);
			}
		});
		//数据表格加载完成后初始化上传按钮
		var regions=$('#button-import').upload({
			name:'regions',
			action:'${pageContext.request.contextPath}/region/batchImport',
			autoSubmit: false,
			onSelect:function(){
				this.autoSubmit=false;
				$.messager.confirm('提示','确定上传'+this.filename()+'吗？确保文件后缀为xls！编号存在会自动更新！如果你不确定编号，请不要填写编号列，将由程序生成！除编号列其他列必填',function(r){
					if(r){
						var index=regions.filename().lastIndexOf('.')+1;
						var subfix=regions.filename().substring(index);
						if(subfix=='xls'){
							regions.submit();
						}else{
							$.messager.alert('错误，','文件格式错误！非xls格式','warning');
						}
						
					}
				})
			},
			onComplete:function(response){
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
			}
		});
		
		// 添加区域窗口
		var a=$('#addRegionWindow').window({
	        width: 400,
	        modal: true,
	        shadow: true,
	        closed: true,
	        height: 400,
	        resizable:false
	    });
		// 修改区域窗口
		$('#editRegionWindow').window({
	        title: '修改区域',
	        width: 400,
	        modal: true,
	        shadow: true,
	        closed: true,
	        height: 400,
	        resizable:false
	    });
		
	});

</script>	
</head>
<body class="easyui-layout" style="visibility:hidden;">
	<div region="center" border="false">
    	<table id="grid"></table>
	</div>
	<div class="easyui-window" id="addRegionWindow" collapsible="false" minimizable="false" maximizable="false" style="top:20px;left:200px">
		<div region="north" style="height:31px;overflow:hidden;" split="false" border="false" >
			<div class="datagrid-toolbar">
				<a id="save" icon="icon-save" href="javascript:addOrUpadteRegion()" class="easyui-linkbutton" plain="true" >保存</a>
			</div>
		</div>
		
		<div region="center" style="overflow:auto;padding:5px;" border="false">
			<form method="post" id="RegionForm">
				<input type="hidden" name="id"/> 
				<input type="hidden" name="shortcode"/> 
				<input type="hidden" name="citycode"/> 
				<table class="table-edit" width="80%" align="center">
					<tr class="title">
						<td colspan="2">区域信息</td>
					</tr>
					<tr>
						<td>省</td>
						<td><input type="text" name="province" class="easyui-validatebox" required="true"/></td>
					</tr>
					<tr>
						<td>市</td>
						<td><input type="text" name="city" class="easyui-validatebox" required="true"/></td>
					</tr>
					<tr>
						<td>区</td>
						<td><input type="text" name="district" class="easyui-validatebox" required="true"/></td>
					</tr>
					<tr>
						<td>邮编</td>
						<td><input type="text" name="postcode" class="easyui-validatebox" required="true"/></td>
					</tr>
					</table>
			</form>
		</div>
	</div>
</body>
</html>