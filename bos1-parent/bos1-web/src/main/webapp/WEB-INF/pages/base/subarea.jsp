<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>管理分区</title>
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
<style>
	.combobox-item{
		cursor: pointer;
	}
</style>
<script type="text/javascript">
	function doAdd(){
		$('#addSubareaWindow').window("open");
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
		$('#editSubareaWindow').window('open');
		selected[0]["region.id"]=selected[0].region.id;
		$('#editForm').form('load',selected[0]);
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
				$.post('${pageContext.request.contextPath}/subarea/delete',{'ids':ids.join(',')},function(resData){
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
		$('#searchWindow').window("open");
	}
	
	function doExport(){
		location.href='${pageContext.request.contextPath}/subarea/export';
	}
	
	function doImport(){
		$('#subareasFile').click();
	}
	
	function viewDiagram(){
		$('#diagramWindow').window('open');
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
		id : 'button-templateDownlaoad',
		text : '模板下载',
		iconCls : 'icon-syl-excel',
		handler : function(){
			location.href='${pageContext.request.contextPath}/template/subarea-t.xls';
		}
	},{
		id : 'button-import',
		text : '导入',
		iconCls : 'icon-redo',
		handler : doImport
	},{
		id : 'button-export',
		text : '导出',
		iconCls : 'icon-undo',
		handler : doExport
	},{
		id : 'button-diagram',
		text : '分布图',
		iconCls : 'icon-large-chart',
		handler : viewDiagram
	}
	
	];
	// 定义列
	var columns = [ [ {
		field : 'id',
		checkbox : true,
	}, {
		field : 'showid',
		title : '分区编号',
		width : 120,
		align : 'center',
		formatter : function(data,row ,index){
			return row.id;
		}
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
			url : "${pageContext.request.contextPath}/subarea/listData?format=1",
			idField : 'id',
			columns : columns,
			onDblClickRow : doDblClickRow
		});
		
		// 添加分区
		$('#addSubareaWindow').window({
	        title: '添加分区',
	        width: 600,
	        modal: true,
	        shadow: true,
	        closed: true,
	        height: 400,
	        resizable:false
	    });
		
		// 修改分区
		$('#editSubareaWindow').window({
	        title: '修改分区',
	        width: 600,
	        modal: true,
	        shadow: true,
	        closed: true,
	        height: 400,
	        resizable:false
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
		//分布图
		$('#diagramWindow').window({
		    width:'50%',
		    modal:true,
		    collapsible:false,
		    minimizable:false,
		    maximizable:false,
		    draggable:false,
		    resizable:false,
		    closed:true,
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
		$("#btn").click(function(){
			var data=form2Json('#searchSubarea');
			//重新加载表格数据
			$('#grid').datagrid('load',data);
			//关闭查询框
			$('#searchWindow').window('close');
		});
		
	});

	function doDblClickRow(index,rowData){
		$('#editSubareaWindow').window('open');
		rowData["region.id"]=rowData.region.id;
		$('#editForm').form('load',rowData);
	}
</script>	
</head>
<body class="easyui-layout" style="visibility:hidden;">
	<div region="center" border="false">
    	<table id="grid"></table>
	</div>
	<!-- 添加分区 -->
	<div class="easyui-window" title="分区添加" id="addSubareaWindow" collapsible="false" minimizable="false" maximizable="false" style="top:20px;left:200px">
		<div style="height:31px;overflow:hidden;" split="false" border="false" >
			<div class="datagrid-toolbar">
				<a id="save" icon="icon-save" href="javascript:add()" class="easyui-linkbutton" plain="true" >保存</a>
			</div>
		</div>
		
		<div style="overflow:auto;padding:5px;" border="false">
			<form id="addFrom" action="${pageContext.request.contextPath }/subarea/add" method="post">
				<table class="table-edit" width="80%" align="center">
					<tr class="title">
						<td colspan="2">分区信息</td>
					</tr>
					<tr>
						<td>分区编号</td>
						<td><input type="text" name="id" class="easyui-validatebox" required="true"/></td>
					</tr>
					<tr>
						<td>选择区域</td>
						<td>
							<input class="selectRegion" style="min-width:150px;"  name="region.id"/>  
						</td>
					</tr>
					<tr>
						<td>关键字</td>
						<td><input type="text" name="addresskey" class="easyui-validatebox" required="true"/></td>
					</tr>
					<tr>
						<td>起始号</td>
						<td><input type="text" name="startnum" class="easyui-validatebox" required="true"/></td>
					</tr>
					<tr>
						<td>终止号</td>
						<td><input type="text" name="endnum" class="easyui-validatebox" required="true"/></td>
					</tr>
					<tr>
						<td>单双号</td>
						<td>
							<select class="easyui-combobox" name="single" style="width:150px;">  
							    <option value="0">单双号</option>  
							    <option value="1">单号</option>  
							    <option value="2">双号</option>  
							</select> 
						</td>
					</tr>
					<tr>
						<td>位置信息</td>
						<td><input type="text" name="position" class="easyui-validatebox" required="true" style="width:250px;"/></td>
					</tr>
				</table>
			</form>
		</div>
	</div>
	
	<!-- 修改分区 -->
	<div class="easyui-window" title="分区修改" id="editSubareaWindow" collapsible="false" minimizable="false" maximizable="false" style="top:20px;left:200px">
		<div style="height:31px;overflow:hidden;" split="false" border="false" >
			<div class="datagrid-toolbar">
				<a icon="icon-save" href="javascript:update();" class="easyui-linkbutton" plain="true" >保存</a>
			</div>
		</div>
		
		<div style="overflow:auto;padding:5px;" border="false">
			<form id="editForm" method="post">
				<input type="hidden" name="id">
				<table class="table-edit" width="80%" align="center">
					<tr class="title">
						<td colspan="2">分区信息</td>
					</tr>
					<tr>
						<td>选择区域</td>
						<td>
							<input class="selectRegion" style="min-width:150px;"  name="region.id"/>  
						</td>
					</tr>
					<tr>
						<td>关键字</td>
						<td><input type="text" name="addresskey" class="easyui-validatebox" required="true"/></td>
					</tr>
					<tr>
						<td>起始号</td>
						<td><input type="text" name="startnum" class="easyui-validatebox" required="true"/></td>
					</tr>
					<tr>
						<td>终止号</td>
						<td><input type="text" name="endnum" class="easyui-validatebox" required="true"/></td>
					</tr>
					<tr>
						<td>单双号</td>
						<td>
							<select class="easyui-combobox" name="single" style="width:150px;">  
							    <option value="0">单双号</option>  
							    <option value="1">单号</option>  
							    <option value="2">双号</option>  
							</select> 
						</td>
					</tr>
					<tr>
						<td>位置信息</td>
						<td><input type="text" name="position" class="easyui-validatebox" required="true" style="width:250px;"/></td>
					</tr>
				</table>
			</form>
		</div>
	</div>
	
	
	<!-- 查询分区 -->
	<div class="easyui-window" title="查询分区窗口" id="searchWindow" collapsible="false" minimizable="false" maximizable="false" style="top:20px;left:200px">
		<div style="overflow:auto;padding:5px;" border="false">
			<form id="searchSubarea">
				<table class="table-edit" width="80%" align="center">
					<tr class="title">
						<td colspan="2">查询条件</td>
					</tr>
					<tr>
						<td>省</td>
						<td><input type="text" name="region.province"/></td>
					</tr>
					<tr>
						<td>市</td>
						<td><input type="text" name="region.city"/></td>
					</tr>
					<tr>
						<td>区（县）</td>
						<td><input type="text" name="region.district"/></td>
					</tr>
					<tr>
						<td>关键字</td>
						<td><input type="text" name="addresskey"/></td>
					</tr>
					<tr>
						<td colspan="2"><a id="btn" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a> </td>
					</tr>
				</table>
			</form>
		</div>
	</div>
	
	<!-- 用于上传文件 -->
	<div style="display: none;">
		<input type="file" id="subareasFile" name="subareas" accept="application/vnd.ms-excel">
	</div>
	
	<!-- 分布图 -->
	<div class="easyui-window" title="分区分布图" id="diagramWindow">
		<div id="regionDiagram" style="min-width:400px;height:400px">
		</div>
	</div>
	<!-- 使用blueimp-file-upload进行文件上传 -->
	<script
		src="https://cdn.bootcss.com/blueimp-file-upload/10.1.0/js/vendor/jquery.ui.widget.js"></script>
	<script
		src="https://cdn.bootcss.com/blueimp-file-upload/10.1.0/js/jquery.iframe-transport.min.js"></script>
	<script
		src="https://cdn.bootcss.com/blueimp-file-upload/10.1.0/js/jquery.fileupload.min.js"></script>
	<script>
		/* 导入 */
		$(function(){
			$('#subareasFile').fileupload(
					{
						url : 'http://localhost/bos1-web/subarea/batchImport',
						dataType : 'json',
						done : function(e, data) {
							$.messager.progress('close');
							data=data.result;
							if(data.state==200){
								$.messager.alert('成功','导入成功！','info');
								$('#grid').datagrid('load');
							}else{
								$.messager.alert('失败',data.msg,'error');
							}
							
						},
						add: function (e, data) {
							if(data.files[0].size>10485760){
								$.messager.alert('文件太大','文件不能超过10M','warning');
								return;
							}
							$.messager.confirm('确认', '你确认要上传的是'+data.files[0].name+'吗？', function(r){
								if (r){
									data.submit();
								}
							})
				        },
						progressall : function(e, data) {
							var progress = parseInt(data.loaded / data.total
									* 100, 10);
							$.messager.progress({title:'上传中',text:progress+'%',interval:0});
							$.messager.progress('bar').progressbar('setValue', progress);
						}
					});
		})
		function add(formId,url){
			formId=formId||'#addFrom';
			url=url||'${pageContext.request.contextPath }/subarea/add';
			var v=$(formId).form('validate');
			if(v){
				var isSeleted=$(formId).find('.selectRegion').attr('isselecte');
				if(!Number(isSeleted)){
					$.messager.alert('提示','请选择正确的区域！','warning');
					return;
				}
				$(formId).form('submit',{
					url:url,
					success:function(resData){
						resData=$.parseJSON(resData);
						if(resData.state==200){
							location.reload();  
						}else{
							$.messager.alert('失败',resData.msg,'error')
						}
					}
				});
			}
		}
	
		/*
		*	更新分区	
		*/
		function update(){
			add('#editForm','${pageContext.request.contextPath }/subarea/update');
		}
		
		$(function(){
			$('.selectRegion').combobox({
			    url:'${pageContext.request.contextPath}/region/search?format=1',
			    valueField:'id',
			    textField:'address',
			    onSelect:function(){
			    	$(this).attr('isSelecte',1);
			    },
			    onUnselect:function(){
			    	$(this).attr('isSelecte',0);
			    },
			    /* 本地校验规则 */
			    filter: function(q, row){
			    	q=q.replace(/\s+/g,"").toLowerCase();
			    	var address=row.address.replace(/\s+/g,"").toLowerCase();
			    	var province=row.province.replace(/\s+/g,"").toLowerCase();
			    	var district= row.district.replace(/\s+/g,"").toLowerCase();
			    	var postcode=row.postcode.replace(/\s+/g,"").toLowerCase();
			    	var shortcode=row.shortcode.replace(/\s+/g,"").toLowerCase();
			    	var city=row.citycode.replace(/\s+/g,"").toLowerCase();
			    	var citycode=row.city.replace(/\s+/g,"").toLowerCase();
			    	return province.indexOf(q)>=0||
			    		   district.indexOf(q)>=0||
			    		   postcode.indexOf(q)>=0||
			    		   shortcode.indexOf(q)>=0||
			    		   city.indexOf(q)>=0||
			    		   citycode.indexOf(q)>=0||
			    		   address.indexOf(q)>=0;
				}
			});
		})
	</script>
	<script src="http://cdn.highcharts.com.cn/highcharts/highcharts.js"></script> 
	<script src="http://cdn.highcharts.com.cn/highcharts/modules/exporting.js"></script>
	<script type="text/javascript">
	
		Highcharts.setOptions({
			lang:{
				contextButtonTitle:'图表菜单',
				downloadJPEG:'导出为JPEG格式图片',
				downloadPDF:'导出为PDF',
				downloadPNG:'导出为PNG格式图片',
				downloadSVG:'导出为SVG',
				printChart:'打印',
				viewFullscreen:'全屏显示',
			}
		});
		
		$.post('${pageContext.request.contextPath}/subarea/distributeData',{},function(resData){
			if(resData.state==200){
				Highcharts.chart('regionDiagram', {
					chart: {
						plotBackgroundColor: null,//背景色string
						plotBorderWidth: null,	//边框string/number
						plotShadow: false,//绘图区阴影
						type: 'pie'//图表类型
					},
					credits:{	//版权信息
						href:'https://www.zzrfdsn.cn',
						text:'zzrfdsn.cn'
					},
					title: {
						text: '分区分布图'
					},
					tooltip: {
						//point.percentage:.1f表示所占的百分比，保留一位小数。
						pointFormat: '{series.name}: {point.y}个'
					},
					plotOptions: {
						pie: {
							allowPointSelect: true,//就是点击后突出显示
							cursor: 'pointer',//指定鼠标滑过数据列时鼠标的形状
							dataLabels: {	//数据标签
								enabled: true,//启用或禁用数据标签默认是：true
								format: '{point.name}: {point.percentage:.1f} %',//和tooltip.pointFormat类型，这个是显示在数据标签上
								style: {
									//数据标签的颜色
									color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'orange'
								}
							}
						}
					},
					//数据列
					series: [{
						name: '分区个数',//系列的名称，如图例、工具提示等所示
						colorByPoint: true,//色标，五颜六色的显示
						data: resData.data
					}],
					exporting:{
						filename:'zzrfdsn-chart'
					}
				});
			}
		},'json')
	</script>
</body>
</html>