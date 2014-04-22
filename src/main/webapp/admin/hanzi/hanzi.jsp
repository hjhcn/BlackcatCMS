<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage=""%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%--
  ~ Copyright (c) 2014.
  ~ haojunhua
  --%>

<s:include value="../common/head.jsp" />
<script type="text/javascript" src="resources/ueditor/ueditor.config.js"></script>
<script type="text/javascript" src="resources/ueditor/ueditor.all.min.js"></script>
<link rel="stylesheet" href="resources/ueditor/themes/default/css/ueditor.css" />
<script>
    //编辑ID
    var id= <s:property value="id"/>;
	
	$(function() {
		var editor = new UE.ui.Editor();
		editor.render("content");
		
		$("#upload-cnAudio-btn").uploadify(
				{
					'uploader' : 'resources/swf/uploadify.swf',
					'script' : 'json/upload_uploadFile_uploadFile;jsessionid=' + JSESSIONID, // 指定服务端处理类的入口
					'folder' : 'avatar',
					'cancelImg' : 'resources/images/cancel.png',
					'fileDataName' : 'file', // 和input的name属性值保持一致就好，Struts2就能处理了
					'queueID' : 'fileQueue2',
					'auto' : true,// 是否选取文件后自动上传
					'multi' : false,// 是否支持多文件上传
					'simUploadLimit' : 1,// 每次最大上传文件数
					'buttonText' : '上传封面',// 按钮上的文字
					'fileExt' : '*.mp3',
					'fileDesc' : '请上传图片文件',
					'displayData' : 'percentage',// 有speed和percentage两种，一个显示速度，一个显示完成百分比
					'onComplete' : function(event, queueID, fileObj, res, _data) {
						data = JSON.parse(res);
						if (data.feedback > 0) {
							var uploadFile = data.uploadFile;
							$("#cnAudio").combobox("setValue", uploadFile.id).combobox("setText",
									uploadFile.description);
						} else if (data.feedback == -1203) {
							$.messager.alert("出错了", "上传的格式不被接收，请上传音频文件");
						} else {
							$.messager.alert("出错了", "文件上传出错");
						}
					},
					'onError' : function(event, queueID, fileObj, errorObj) {
						alert(errorObj.type + "Error:" + errorObj.info);
					},
					'onSelect' : function() {
						$("#cnAudio").combobox("setValue", "加载中...");
					}

				});
		
		$("#upload-enAudio-btn").uploadify(
				{
					'uploader' : 'resources/swf/uploadify.swf',
					'script' : 'json/upload_uploadFile_uploadFile;jsessionid=' + JSESSIONID, // 指定服务端处理类的入口
					'folder' : 'avatar',
					'cancelImg' : 'resources/images/cancel.png',
					'fileDataName' : 'file', // 和input的name属性值保持一致就好，Struts2就能处理了
					'queueID' : 'fileQueue2',
					'auto' : true,// 是否选取文件后自动上传
					'multi' : false,// 是否支持多文件上传
					'simUploadLimit' : 1,// 每次最大上传文件数
					'buttonText' : '上传封面',// 按钮上的文字
					'fileExt' : '*.mp3',
					'fileDesc' : '请上传图片文件',
					'displayData' : 'percentage',// 有speed和percentage两种，一个显示速度，一个显示完成百分比
					'onComplete' : function(event, queueID, fileObj, res, _data) {
						data = JSON.parse(res);
						if (data.feedback > 0) {
							var uploadFile = data.uploadFile;
							$("#enAudio").combobox("setValue", uploadFile.id).combobox("setText",
									uploadFile.description);
						} else if (data.feedback == -1203) {
							$.messager.alert("出错了", "上传的格式不被接收，请上传音频文件");
						} else {
							$.messager.alert("出错了", "文件上传出错");
						}
					},
					'onError' : function(event, queueID, fileObj, errorObj) {
						alert(errorObj.type + "Error:" + errorObj.info);
					},
					'onSelect' : function() {
						$("#enAudio").combobox("setValue", "加载中...");
					}

				});

		
		$("#sub").click(
				function() {
					if ($("#fm").form("validate")&&verifyCombobox("cover",false,"‘封面’文件输入有误")) {
						var param = {
							"news.title" : $("#title").val(),
							"news.content" : editor.getContent(),
							"news.description" : $("#description").val(),
							"news.coverFile.id" : $("#cover").combobox("getValue"),
							"news.status" : ($("#status").is(":checked")) ? 1: 0
						};

						var url = "json/news_add_feedback";
						var succword="创建成功！";
						if (id> 0) {
							param["news.id"] = id;
							url = "json/news_edit_feedback";
							succword="编辑成功！";
						}

						$.post(url, param, function(data) {
							if (data.feedback == 100)
								alert(succword);
							else {
								if (data.feedback == -1101) {
									$.messager.alert("出错了", "标题已存在");
								} else if (data.feedback == -1102) {
									$.messager.alert("出错了", "内容错误，不能为空");
								} else if (data.feedback == -1103) {
									$.messager.alert("出错了", "简介错误，不能为空");
								} else if (data.feedback == -1104) {
									$.messager.alert("出错了", "编辑的新闻不存在");
								}
							}
						}, "json");
					}

				});
		

		//初始化表单
		init();

	});
	
	function init(){
		if(id>0){
			$("#id").val(id);
			$("#title").val("<s:property value="news.title" escape="false"/>");
			$("#description").val('<s:property value="news.description.replaceAll('(?:\n|\r|\t)', '')" escape="false"/>');
			$("#content").val('<s:property value="news.content.replaceAll('(?:\n|\r|\t)', '')" escape="false"/>');
			
			<s:if test="news.coverFile!=null">
			$("#cover").combobox("setValue",<s:property value="news.coverFile.id"/>);
			</s:if>
		}
	}
	
	
	//解决combobox validatebox可能存在的冲突
	function verifyCombobox(id,required,tap){
		var value = $("#" + id).combobox("getValue");
		var text = $("#" + id).combobox("getText");
		if(text==""&&required==false)return true;
		if (value != text && !isNaN(value)) {
			return true;
		}else{
			$.messager.alert("文件输入有误", tap);
			return false;
		}
	}

	var uploadFileLoader = function(param, success, error) {
		var q = param.q || "";
		var params={"search" : q};
		if(param.ext!=undefined&&param.ext!="")
		   params.ext=param.ext;
		$.getJSON("json/upload_list_uploadFiles", params, function(data) {
			var items = $.map(data.uploadFiles.rows, function(item) {
				return {
					id : item.id,
					description : item.description+"."+item.fileType,
				};
			});
			<s:if test="id>0">
		    	//编辑时，增加原有文件项
				<s:if test="news.coverFile!=null">
				items.push({id:<s:property value="news.coverFile.id"/>,description:"<s:property value="news.coverFile.description" escape="false"/>.<s:property value="news.coverFile.fileType" escape="false"/>"});
				</s:if>
		    </s:if>
			success(items);
		});
	}
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
		<input id="id" type="hidden"></input>
		<div class="fitem">
			<label>汉字:</label> <label id="title" required="true" type="text"></label>
		</div>
		<div class="fitem">
			<label>内容:</label>
			<textarea id="content" name="content" style="width:800px; margin-left: 83px;height: 400px;"></textarea>
		</div>
		<div class="fitem">
			<label></label> <input type="checkbox" id="status" checked />是否直接审核通过
		</div>
		<div class="fitem">
			<label></label> <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search"
				id="sub">提交</a>
		</div>


	</form>

</body>
</html>