<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage=""%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%--
  ~ Copyright (c) 2014.
  ~ haojunhua
  --%>

<s:include value="../common/head.jsp" />
<script>
	$(function() {

		$("#sub").click(function() {
			if ($("#fm").form("validate")) {
				if ($("#newPassword").val() != $("#newPassword2").val()) {
					$.messager.alert("输入有误", "两次输入的新密码不一致，请重新输入");
					$("#newPassword").val("");
					$("#newPassword2").val("");
					return;
				}
				var param = {
					"password" : $("#password").val(),
					"newPassword" : $("#newPassword").val()
				};

				$.post("json/admin_password_feedback", param, function(data) {
					if (data.feedback == 100)
						$.messager.alert("成功", "密码修改成功");
					else {
						$.messager.alert("警告", "旧密码不对");
					}
				}, "json");
			}

		});

	});
</script>
<style type="text/css">
form {
	font-size: 12px;
}

label {
	width: 150px;
	text-align: right;
}

.fitem {
	padding: 15px 10;
}

input[type="text"] {
	width: 400px;
}
</style>
<body>
	<form id="fm" method="post">
		<div class="fitem">
			<label><span style="color: red">*</span>旧密码:</label> <input type="password" id="password"
				class="easyui-validatebox" type="text"
				data-options="prompt:'请输入旧密码',required:true,validType:'length[6,18]'" />
		</div>
		<div class="fitem">
			<label><span style="color: red">*</span>新密码:</label> <input type="password" id="newPassword"
				class="easyui-validatebox" type="text"
				data-options="prompt:'请输入新密码',required:true,validType:'length[6,18]'" />
		</div>
		<div class="fitem">
			<label><span style="color: red">*</span>新密码:</label> <input type="password" id="newPassword2"
				class="easyui-validatebox" type="text"
				data-options="prompt:'请确认新密码',required:true,validType:'length[6,18]'" />
		</div>
		<div class="fitem">
			<label></label> <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search"
				id="sub">提交</a>
		</div>


	</form>

</body>
</html>