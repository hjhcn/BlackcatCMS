<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage=""%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%--
  ~ Copyright (c) 2014.
  ~ haojunhua
  --%>

<s:include value="../common/head.jsp" />
<script>
	$(function() {
		$('#data').datagrid({
			url : 'json/admin_list_admins',
			loadFilter : function(data) {
				return data.admins;
			},
			columns : [ [ {
				field : "ck",
				checkbox : true
			}, {
				field : "id",
				hidden : true
			}, {
				title : "用户名",
				field : "username",
				width : "200"
			}, {
				title : "角色",
				field : "role",
				width : "200",
				sortable : true,
				formatter : function(value, row, index) {
					if (value == 0)
						return "超级管理员";
					else
						return "管理员";
				}
			} ] ],
			pageNumber : 1,
			pageSize : 20,
			view : detailview,
			detailFormatter : function(index, row) {
				return '<div id="ddv-' + index + '" style="padding:5px 0"></div>';
			},
			onExpandRow : function(index, row) {
				$('#ddv-' + index).panel({
					height : 80,
					border : false,
					cache : false,
					href : 'admin_statisticAAdmin?aid=' + row.id,
					onLoad : function() {
						$('#data').datagrid('fixDetailRowHeight', index);
					}
				//需要关闭进度条
				/*,extractor : function(data) {
					return "<div>hh</div>";
				}*/
				});
				$('#data').datagrid('fixDetailRowHeight', index);
			}
		});
	});
	function search() {
		$("#data").data().datagrid.cache = null;
		var queryparams = $("#data").datagrid("options").queryParams;
		queryparams.uid = $("#uid").val();
		queryparams.smsphone = $("#smsphone").val();
		queryparams.username = $("#username").val();
		$('#data').datagrid("load");
	}
	function editUser() {
		var row = $('#data').datagrid('getSelected');
		if (row) {
			alert(JSON.stringify(row));
		}
	}
</script>
<body>
	<table id="data" pagination="true" fit="true"
		data-options="rownumbers:true,singleSelect:true,toolbar:'#tb'" border="no">
	</table>
</body>