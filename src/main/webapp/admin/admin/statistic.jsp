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
			url : 'json/admin_statistic_asView',
			loadFilter : function(data) {
				return data.asView;
			},
			columns : [ [ {
				field : "id",
				hidden : true,
				formatter : function(value, row, index) {
					return row.admin.id;
				}
			}, {
				title : "用户名",
				field : "username",
				formatter : function(value, row, index) {
					return row.admin.username;
				}
			}, {
				title : "角色",
				field : "role",
				sortable : true,
				formatter : function(value, row, index) {
					if (row.admin.role == 0)
						return "超级管理员";
					else
						return "管理员";
				}
			}, {
				title : "汉字待编辑",
				field : "hanziS",
				sortable : true,
				formatter : function(value, row, index) {
					if (row.hs)
						return row.hs.hanziS
					else
						return 0;
				}
			}, {
				title : "汉字等待审核",
				field : "hanziE",
				sortable : true,
				formatter : function(value, row, index) {
					if (row.hs)
						return row.hs.hanziE
					else
						return 0;
				}
			}, {
				title : "汉字审核不通过",
				field : "hanziVNP",
				sortable : true,
				formatter : function(value, row, index) {
					if (row.hs)
						return row.hs.hanziVNP
					else
						return 0;
				}
			}, {
				title : "汉字审核通过",
				field : "hanziVP",
				sortable : true,
				formatter : function(value, row, index) {
					if (row.hs)
						return row.hs.hanziVP
					else
						return 0;
				}
			}, {
				title : "词语已删除",
				field : "ciyuD",
				sortable : true,
				formatter : function(value, row, index) {
					if (row.cs)
						return row.cs.ciyuD
					else
						return 0;
				}
			}, {
				title : "词语待审核",
				field : "ciyuDF",
				sortable : true,
				formatter : function(value, row, index) {
					if (row.cs)
						return row.cs.ciyuDF
					else
						return 0;
				}
			}, {
				title : "词语审核不通过",
				field : "ciyuVNP",
				sortable : true,
				formatter : function(value, row, index) {
					if (row.cs)
						return row.cs.ciyuVNP
					else
						return 0;
				}
			}, {
				title : "词语审核通过",
				field : "ciyuVP",
				sortable : true,
				formatter : function(value, row, index) {
					if (row.cs)
						return row.cs.ciyuVP
					else
						return 0;
				}
			} ] ],
			pageNumber : 1,
			pageSize : 20
		});
	});
</script>
<body>
	<table id="data" pagination="true" fit="true"
		data-options="rownumbers:true,singleSelect:true,toolbar:'#tb'" border="no">
	</table>
</body>