<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%--
  ~ Copyright (c) 2014.
  ~ haojunhua
  --%>

<s:include value="common/head.jsp" />
<script type="text/javascript">
	function openTab(title, url) {
		if ($('#tt').tabs('exists', title)) {
			$('#tt').tabs('close', title);
		}

		if (url) {
			var content = '<iframe scrolling="yes" frameborder="0"  src="' + url
					+ '" style="width:100%;height:100%;"></iframe>';
		} else {
			var content = '未实现';
		}
		$('#tt').tabs('add', {
			title : title,
			content : content,
			closable : true
		});
	}
</script>
<style>
.nav-item {
	padding: 5 30 5 30;
	text-align: right;
}

a:link,a:visited {
	text-decoration: none;
	color: gray;
	font-size: 14px;
}

a:hover {
	text-decoration: underline;
	color: gray;
	font-size: 14px;
}

a.north:link,a.north:visited {
	text-decoration: none;
	color: black;
	font-size: 12px;
}

a.north:hover {
	text-decoration: underline;
	color: black;
	font-size: 12px;
}
</style>
<body class="easyui-layout">
	<div region="north" style="height:50px; overflow: hidden; padding-left: 20px;position: relative;">
		<div>
			<h2>奇乐萌BlackCat汉字管理后台</h2>
		</div>
		<div style="position:absolute;bottom: 2px;right: 5px; ">
			<span style="color:gray;"> <s:if test="admin.isSuper">超级管理员</s:if> <s:else>管理员</s:else> :</span>
			<span style="color:gray;"><s:property value="#session.admin.username" /> </span> <a
				class="north" href="logout">退出登陆</a>
		</div>
	</div>
	<div region="west" split="true" style="width:200px;">
		<div id="aa" class="easyui-accordion" fit="true" border="false">
			<div title="汉字管理" selected="true">
				<div class="nav-item">
					<a href="javascript:openTab('汉字管理','hanzi_list_page')"><span>汉字管理</span> </a>
				</div>
				<s:if test="admin.isEditable">
					<div class="nav-item">
						<a href="javascript:openTab('词语管理','ciyu_list_page')"><span>词语管理</span> </a>
					</div>
					<div class="nav-item">
						<a href="javascript:openTab('文件管理','upload_list_page')"><span>文件管理</span> </a>
					</div>
				</s:if>
			</div>
			<s:if test="admin.isSuper">
				<div title="管理员管理">
					<div class="nav-item">
						<a href="javascript:openTab('管理员管理','admin_list_page')"><span>管理员管理</span> </a>
					</div>
					<div class="nav-item">
						<a href="javascript:openTab('管理员统计','admin_statistic_page')"><span>管理员统计</span> </a>
					</div>
				</div>
			</s:if>
			<div title="账号管理">
				<div class="nav-item">
					<a href="javascript:openTab('密码管理','admin_pswd_page')"><span>密码管理</span> </a>
				</div>
			</div>
		</div>
	</div>
	<div region="center">
		<div id="tt" class="easyui-tabs" fit="true" border="false"></div>

	</div>
</body>
</html>
