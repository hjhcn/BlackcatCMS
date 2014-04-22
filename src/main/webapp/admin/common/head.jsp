<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%--
  ~ Copyright (c) 2014.
  ~ haojunhua
  --%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" type="text/css" href="easyui/themes/gray/easyui.css" />
<link rel="stylesheet" type="text/css" href="easyui/themes/icon.css" />
<script type="text/javascript" src="js/jquery.min.js"></script>
<script type="text/javascript" src="js/jquery-ui.min.js"></script>
<script type="text/javascript" src="easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="easyui/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="easyui/plugins/datagrid-detailview.js"></script>
<script type="text/javascript">
	$(function() {

		$(document).ajaxStart(function() {
			$.messager.progress({
				title : "请等待",
				msg : "数据加载中...",
				interval : 300
			});
		});

		$(document).ajaxSuccess(function() {
			$.messager.progress("close");
		});

		$(document).ajaxError(function() {
			alert("数据请求出错，请稍等或重试!");
			$.messager.progress('close');
		});

		$(document).ajaxComplete(function(event, xhr, settings) {
			//处理全局返回异常
			var feedback = JSON.parse(xhr.responseText).feedback;
			if (feedback == -501)
				top.location.href = "/blackcat/admin/";
			else if (feedback < 0) {
				alert("操作返回错误代码：" + feedback);
			}
			$.messager.progress('close');
		});
	});

	Date.prototype.pattern = function(fmt) {
		var o = {
			"M+" : this.getMonth() + 1, //月份        
			"d+" : this.getDate(), //日        
			"h+" : this.getHours() % 12 == 0 ? 12 : this.getHours() % 12, //小时        
			"H+" : this.getHours(), //小时        
			"m+" : this.getMinutes(), //分        
			"s+" : this.getSeconds(), //秒        
			"q+" : Math.floor((this.getMonth() + 3) / 3), //季度        
			"S" : this.getMilliseconds()
		//毫秒        
		};
		var week = {
			"0" : "\u65e5",
			"1" : "\u4e00",
			"2" : "\u4e8c",
			"3" : "\u4e09",
			"4" : "\u56db",
			"5" : "\u4e94",
			"6" : "\u516d"
		};
		if (/(y+)/.test(fmt)) {
			fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
		}
		if (/(E+)/.test(fmt)) {
			fmt = fmt.replace(RegExp.$1,
					((RegExp.$1.length > 1) ? (RegExp.$1.length > 2 ? "\u661f\u671f" : "\u5468")
							: "")
							+ week[this.getDay() + ""]);
		}
		for ( var k in o) {
			if (new RegExp("(" + k + ")").test(fmt)) {
				fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k])
						.substr(("" + o[k]).length)));
			}
		}
		return fmt;
	}
</script>

<style type="text/css">
#fm {
	margin: 0;
	padding: 10px 30px;
}

.ftitle {
	font-size: 14px;
	font-weight: bold;
	padding: 5px 0;
	margin-bottom: 10px;
	border-bottom: 1px solid #ccc;
}

.fitem {
	margin-bottom: 5px;
}

.fitem label {
	display: inline-block;
	width: 80px;
}
</style>
<script type="text/javascript">
	var JSESSIONID = "${pageContext.session.id}";
</script>
<script type="text/javascript" src="js/swfobject.js"></script>
<script type="text/javascript" src="js/uploadify.js"></script>
<title>奇乐萌BlackCat汉字管理后台</title>
</head>