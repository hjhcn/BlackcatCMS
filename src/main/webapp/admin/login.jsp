<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage=""%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%--
  ~ Copyright (c) 2014.
  ~ haojunhua
  --%>

<s:include value="common/head.jsp" />
<style>
#body {
	position: relative;
}

#login-wrapper {
	position: absolute;
	left: 50%;
	Top: 40%;
	width: 600px;
	height: 300px;
	margin-top: -200px;
	margin-left: -300px;
	text-align: center;
	padding-top: 20px;
	border: 1px solid gray;
	text-align: center;
	width: 600px;
	height: 300px;
	height: 300px;
}

#info {
	color: gray;
	font-size: 13px;
	width: 150px;
}

#tips {
	color: gray;
	font-size: 13px;
	padding-top: 50px;
}
</style>
<body>
	<div id="login-wrapper" class="png_bg">
		<div id="login-top">
			<h1>易迪乐园BlackCat工具后台</h1>
		</div>
		<!-- End #logn-top -->
		<div id="login-content">
			<form action="login" method="post" target="_top">
				<p>
					<label>账&nbsp;&nbsp;&nbsp;&nbsp;号：</label> <input class="text-input" type="text"
						name="username" />
				</p>
				<div class="clear"></div>
				<p>
					<label>密&nbsp;&nbsp;&nbsp;&nbsp;码：</label> <input class="text-input" type="password"
						name="password" />
				</p>
				<div class="clear"></div>

				<div class="clear"></div>
				<p>
					<span id="info"><s:if test="feedback==0||feedback==-501">
           请登录系统进行管理
          </s:if> <s:elseif test="feedback==-502">
           账户名不存在 
          </s:elseif> <s:elseif test="feedback==-503">
           密码错误 
          </s:elseif> <s:else>
           登录系统后，才能进行管理
          </s:else> </span><input class="button" type="submit" value="登录" />
				</p>
			</form>
		</div>
		<!-- End #login-content -->
		<div id="tips">注:请使用支持HTML5的浏览器(IE9+,Chrome,safari1.3+,firefox1.5+,Opera9+)</div>
	</div>
	<!-- End #login-wrapper -->
</body>
</html>
