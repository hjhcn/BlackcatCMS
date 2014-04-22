<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage=""%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%--
  ~ Copyright (c) 2014.
  ~ haojunhua
  --%>

<s:include value="../common/head.jsp" />
<style>
.uploadifyQueueItem {
	width: 550px;
	clear: both;
	height: 30px;
	border-bottom: dashed 1px #999;
	padding-top: 10px;
}

.uploadifyQueueItem .cancel {
	float: right;
}

.floatLayer {
	position: absolute;
	right: 20px;
	top: 62px;
	display: none;
	overflow: auto;
	background: white;
	top: 62px;
}

#imgShow {
	width: 620px;
}

#imgShow #content {
	position: relative;
}

#imgShow img {
	position: absolute;
	top: 0px;
	right: 0px;
	border: 1px solid gray;
	padding: 1px;
	right: 0px;
}

#imgShow .close {
	position: absolute;
	right: 10px;
	top: 10px;
	width: 16px;
	height: 16px;
	cursor: pointer;
	background: url("easyui/themes/icons/cancel.png");
}
</style>
<script>
	var ACTION = {
		VERIFY : "VERIFY",
		UNVERIFY : "UNVERIFY",
		DELETE : "DELETE"
	};
	var statusesData = [ {
		value : 0,
		text : "等待审核",
		color:"red"
	}, {
		value : 1,
		text : "审核不通过",
		color:"orange"
	}, {
		value : 2,
		text : "审核通过",
		color:"green"
	}, {
		value : 3,
		text : "已被抛弃，无需编辑",
		color:"gray"
	} , {
		value : -100,
		text : "全部"
	}];//顺序不可改，下面已使用index作为序列，有待优化
	
	var SaveEXT="PIC";
	
	$(function() {
		//修改imgShow的高度
		$("#imgShow").css("height",($("body").height()-100)+"px");
		$("#imgShow .close").click(function(){$("#imgShow").hide();});
		
		$("#data").datagrid(
				{
					url : "json/ciyu_list_ciyus",
					loadFilter : function(data) {
						return data.ciyus;
					},
					columns : [ [
							{
								field : "ck",
								checkbox : true
							},
							{
								title : "ID",
								field : "id",
								align : "center",
								sortable : true
							},
							{
								title : "词",
								field : "ci",
								width : 60
							},
							{
								title : "图片",
								field : "thumbPath",
								width : 120,
								align : "center",
								formatter : function(value, row, index) {
									switch (row.thumbStatus) {
									case 1:
										return "<img src='" + value
												+ "' width='60px' height='60px'/><img src='" + row.iconPath
												+ "' style='display:none'/>";
										break;
									case 0:
										return "<span style='color:orange'>缩略图生成中或失败</span>";
										break;
									case -1:
										return "<span style='color:red'>生成缩略图失败</span>";
										break;
									default:
										break;
									}
								}
							}, /*{
								title : "拼音",
								field : "pinyin"
							}, {
								title : "音调",
								field : "pinyinyindiao"
							},*/ <s:if test="admin.isSuper">{
								title : "管理员",
								field : "admin",
								align : "center",
								formatter : function(value, row, index) {
									if(row.admin)
									return row.admin.username;
									else return "未分配";
								}
							},</s:if>/*{
								title : "英文",
								field : "english"
							}, {
								title : "中文音频",
								field : "cnAudioPath"
							}, {
								title : "英文音频",
								field : "enAudioPath"
							}, */{
								title : "状态",
								field : "status",
								sortable : true,
								formatter : function(value, row, index) {
									return "<span style='color:"+statusesData[value].color+";'>"+statusesData[value].text+"</span>";
								}
							} ] ],
					pageSize : 20,
					onClickRow: function(rowIndex,rowData){
						$("#imgShow img").attr("src",rowData.iconPath);
						$("#imgShow").show();
					}
				}).datagrid("getPager").pagination({
			//displayMsg:'当前显示第 {from} 条到第 {to} 条记录，共有 {total} 条记录',
			showPageList : true,
			//beforePageText:'当前第',
			//afterPageText:'页，本页共 {pages}条记录',
			//total:300,
			pageSize : 20,
			pageList : [ 10, 20, 30, 40, 50, 60, 70, 80, 100, 120, 150, 200, 250, 300 ],
			buttons : [ {
				iconCls : "icon-add",
				text : "新建词语",
				handler : function() {
					parent.openTab("新建词语", "ciyu_ciyu_page")
				}
			}, {
				iconCls : "icon-edit",
				text : "编辑存词",
				handler : function() {
					var rows = $("#data").datagrid("getSelections");
					if (rows.length <= 0)
						$.messager.alert("出错了", "请至少选择一个词语");
					else{
						for ( var i in rows) {
							if(rows[i].status!=3){
								parent.openTab("编辑词语(" + rows[i].ci + ")",
										"ciyu_ciyu?id=" + rows[i].id);
							}
							else{
								$.messager.alert("出错了", rows[i].ci+"，已被抛弃了，不需要再编辑。");
							}
						}
					}
				}
			}, {
				iconCls : "icon-do",
				text : "批量存词",
				handler : function() {
					$("#fileList").datagrid({
						url : "json/upload_list_uploadFiles",
						queryParams : {
							"statuses" : "0",
							"ext" : "PIC"
						},
						loadFilter : function(data) {
							return data.uploadFiles;
						},
						columns : [ [ {
							field : "ck",
							checkbox : true
						}, {
							title : "名称",
							field : "description",
							width : 100
						}, {
							title : "图片",
							field : "webUrl",
							width : 100,
							formatter : function(value, row, index) {
								return "<img src='"+value+"' width='100px' height='100px'/>";
							},
							align : "center"
						} ] ],
						pageSize : 20
					});
					$("#upload-dialog").dialog("open");
					SaveEXT="PIC";
				}
			}, {
				iconCls : "icon-undo",
				text : "批量存中文音频",
				handler : function() {
					$("#fileList").datagrid({
						url : "json/upload_list_uploadFiles",
						queryParams : {
							"statuses" : "0",
							"ext" : "AUDIO"
						},
						loadFilter : function(data) {
							return data.uploadFiles;
						},
						columns : [ [ {
							field : "ck",
							checkbox : true
						}, {
							title : "名称",
							field : "description",
							width : 100
						}, {
							title : "地址",
							field : "webUrl"
						} ] ],
						pageSize : 20,
						pageList : [ 20,50,300,500 ]
					});
					$("#upload-dialog").dialog("open");
					SaveEXT="AUDIO";
				}
			}<s:if test="!admin.isSuper">, {
				iconCls : "icon-help",
				text : "说明",
				handler : function() {
					$("#info-dialog").dialog("open");
				}
			}</s:if><s:if test="admin.isSuper">, {
				iconCls : "icon-ok",
				text : "审核通过",
				handler : function() {
					operate(ACTION.VERIFY);
				}
			}, {
				iconCls : "icon-undo",
				text : "审核不通过",
				handler : function() {
					operate(ACTION.UNVERIFY);
				}
			}, {
				iconCls : "icon-cancel",
				text : "弃用词语",
				handler : function() {
					operate(ACTION.DELETE);
				}
			}/*, {
				iconCls : "icon-do",
				text : "缩略图批量生成",
				handler : function() {
					$.getJSON("json/ciyu_batchGenThumb_count", {
					}, function(data) {
						$.messager.show({
							title : "正在转换",
							msg : "添加了" + data.count + "个图片到转换队列"
						});
					});
				}
			}*/</s:if> ]
		});

		
		
		
		$("#statuses").combobox(
				{
					data : statusesData,
					multiple : true,
					panelHeight : "auto",
					onSelect : function(r) {
						if (r.value == -100) {//当选的是‘全部’这个选项
							$("#statuses").combobox("setValues", "").combobox("setText", '全部');
						} else {
							var valArr = $("#statuses").combobox("getValues");
							valArr.sort();//将值由小到大排序 以保持一致
							if (valArr.join(',') == statusesData.join(',')
									|| valArr.join(',') == statusesData.join(',')) {
								$("#statuses").combobox("setValues", statusesData).combobox(
										"setText", '全部');
							}
						}
					},
					onUnselect : function(r) {
						if (r.value == -100) {//当取消选择的是‘所有’这个选项
							$("#statuses").combobox("setValues", "").combobox("setText", '全部');
						} else {
							var valArr = $("#statuses").combobox("getValues");
							if (valArr[0] == "") {
								valArr.shift();
								$("#statuses").combobox("setValues", valArr);
							}
						}
					}
				});
		
	});

	var ciLoader = function(param, success, error) {
		var q = param.q || "";
		if (q.length <= 1) {
			return false
		}
		$.getJSON("json/ciyu_list_ciyus", {
			"ci" : q
		}, function(data) {
			var items = $.map(data.ciyus.rows, function(item) {
				return {
					description : item.description
				};
			});
			success(items);
		});
	}

	function batchSave() {
		var fileListStr = "";
		var rows = $("#fileList").datagrid("getSelections");
		for ( var i = 0; i < rows.length; i++) {
			var row = rows[i];
			if (i > 0)
				fileListStr += ";";
			fileListStr += row.id + "," + row.description;
		}
		if (fileListStr.length > 0) {
			
			
			$.post("json/ciyu_batchSave_feedback", {
				"fileListStr" : fileListStr,
				"ext":SaveEXT
			}, function(data) {
				if (data.feedback > 0) {
					$("#imageList").datagrid("reload");
					$.messager.show({
						title : "成功",
						msg : "成功了" + data.feedback + "记录"
					});
					$("#data").datagrid("load");
					;
				} else {
					$.messager.alert("操作没有成功", "可能选择的文件已被提交或者文件名不是汉字词语");
				}
			}, "json");
			
			
			
		} else {
			$.messager.alert("出错了", "请至少选择一条有效");
		}
	}

	function operate(operate) {
		var ids = "";
		var rows = $("#data").datagrid("getSelections");
		for ( var i = 0; i < rows.length; i++) {
			var row = rows[i];
			if (i > 0)
				ids += ",";
			ids += row.id;
		}
		if (ids.length > 0) {
			$.getJSON("json/ciyu_operate_count", {
				"ids" : ids,
				"operate" : operate
			}, function(data) {
				if (data.count >= 0) {
					$("#data").datagrid("reload");
					$.messager.show({
						title : "成功",
						msg : "成功了" + data.count + "记录"
					});
				} else {
					$.messager.alert("操作没有成功", "操作没有成功");
				}
			});
		} else {
			$.messager.alert("出错了", "请至少选择一条有效");
		}
	}

	function search() {
		$("#data").data().datagrid.cache = null;
		var queryparams = $("#data").datagrid("options").queryParams;
		queryparams["ci"] = $("#ci").combobox("getValue");
		queryparams["statuses"] = ($("#statuses").combobox("getValues")).join(",");
		$("#data").datagrid("load");
	}

</script>
<body style="position: relative;">
	<div id="tb" style="padding:5px;height:auto">
		<div>
			词语: <input class="easyui-combobox" id="ci" style="width:200px"
				data-options="loader:ciLoader,mode: 'remote',valueField: 'description',textField: 'description',panelHeight:'auto'">
			<select id="statuses" style="width:155px"></select> <a href="javascript:search()"
				class="easyui-linkbutton" iconCls="icon-search" type="sub" plain="true">搜索</a>
		</div>
	</div>
	<table id="data" fit="true" pagination="true" data-options="toolbar:'#tb'" border="no">
	</table>


	<div id="info-dialog" class="easyui-dialog" title="支持格式" style="width:400px;padding:20px;"
		closed="true">
		<p>
		<h4>新建词语：</h4>
		</p>
		<p>功能介绍：管理员通过填写词语信息新建一条词语信息(简称‘词条’)</p>
		<p>表单信息：图片、词语名称为必填项，其余为选填项</p>
		<p>
		<h4>批量存词：</h4>
		</p>
		<p>功能介绍：将列出管理员上传的所有“未使用”的图片，可从中选择需要上传的图片保存，将批量将图片文件保存为词条</p>
		<p>需要注意：图片名称必须是对应的词语</p>
		<p>一般步骤：1.在文件管理中批量上传图片文件，2.在词语管理中进行批量存词</p>
	</div>

	<div id="upload-dialog" class="easyui-dialog" title="选择已上传图片"
		style="width:500px;padding:10px; height: 500px;" closed="true"
		data-options="iconCls: 'icon-save',buttons:'#dialog-buttons'">
		<table id="fileList" fit="true" pagination="true"></table>
	</div>

	<div id="show-img-dialog" class="easyui-dialog" title=""
		style="width:500px;padding:10px; height: 500px;" closed="true"
		data-options="iconCls: 'icon-print'">
		<img width="100%" />
	</div>
	<div id="dialog-buttons">
		<a href="javascript:parent.openTab('文件管理','upload_list_page')" class="easyui-linkbutton"
			iconCls="icon-add" type="sub" plain="true">上传文件</a> <a href="javascript:batchSave()"
			class="easyui-linkbutton" iconCls="icon-save" type="sub">保存到词语</a>
	</div>

	<div id="imgShow" class="floatLayer">
		<div id="content">
			<img width="600px" height="600px" />
			<div class="close"></div>
		</div>
	</div>

</body>
</html>