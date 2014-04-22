<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage=""%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%--
  ~ Copyright (c) 2014.
  ~ haojunhua
  --%>

<s:include value="../common/head.jsp" />
<script>
    //编辑ID
    var id= <s:property value="id"/>;
	
	$(function() {
		
		$("#upload-icon-btn").uploadify(
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
					'buttonText' : '上传图片',// 按钮上的文字
					'fileExt' : '*.jpg;*.gif;*.png;*.bmp;',
					'fileDesc' : '请上传图片文件',
					'displayData' : 'percentage',// 有speed和percentage两种，一个显示速度，一个显示完成百分比
					'onComplete' : function(event, queueID, fileObj, res, _data) {
						data = JSON.parse(res);
						if (data.feedback > 0) {
							var uploadFile = data.uploadFile;
							$("#icon").combobox("setValue", uploadFile.id).combobox("setText",
									uploadFile.description);
							$("#ci").val(uploadFile.description);
							$("#img").attr("src",uploadFile.webUrl).show();
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
						$("#icon").combobox("setValue", "加载中...");
					}

				});
		
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
					'buttonText' : '上传中文音频',// 按钮上的文字
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
					'buttonText' : '上传英语音频',// 按钮上的文字
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
					if ($("#fm").form("validate")&&verifyCombobox("icon",false,"‘图片’文件输入有误")) {
						var param = {
							"ciyu.icon.id" : $("#icon").combobox("getValue"),
							"ciyu.cnAudio.id" : $("#cnAudio").combobox("getValue"),
							"ciyu.enAudio.id" : $("#enAudio").combobox("getValue"),
							"ciyu.ci" : $("#ci").val(),
							"ciyu.pinyin" : $("#pinyin").val(),
							"ciyu.pinyinyindiao" : $("#pinyinyindiao").val(),
							"ciyu.english" : $("#english").val()
						};

						var url = "json/ciyu_uploadOrEdit_feedback";
						var succword="创建成功！";
						param.operate="UPLOAD";
						if (id> 0) {
							param.operate="EDIT";
							param["ciyu.id"]=id;
							succword="编辑成功！";
						}

						$.post(url, param, function(data) {
							if (data.feedback == 100)
								alert(succword);
							else {
								if (data.feedback == -401) {
									$.messager.alert("出错了", "词ID错误");
								} else if (data.feedback == -402) {
									$.messager.alert("出错了", "词语已存在");
								} else if (data.feedback == -403) {
									$.messager.alert("出错了", "词语不是汉字词语");
								} else if (data.feedback == -404) {
									$.messager.alert("出错了", "图片上传错误");
								}
							}
						}, "json");
					}

				});
		

		//初始化表单
		init();

	});
	
	function init(){
		<s:if test="id>0">
			$("#id").val(id);
			$("#ci").val("<s:property value="ciyu.ci" escape="false"/>");
			$("#pinyin").val("<s:property value="ciyu.pinyin" escape="false"/>");
			$("#pinyinyindiao").val("<s:property value="ciyu.pinyinyindiao" escape="false"/>");
			$("#english").val("<s:property value="ciyu.english" escape="false"/>");
			
			$("#icon").combobox("setValue",<s:property value="ciyu.icon.id"/>);
			<s:if test="ciyu.cnAudio!=null">
			$("#cnAudio").combobox("setValue",<s:property value="ciyu.cnAudio.id"/>);
			</s:if>
			<s:if test="ciyu.enAudio!=null">
			$("#enAudio").combobox("setValue",<s:property value="ciyu.enAudio.id"/>);
			</s:if>
		</s:if>
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
					description : item.description+"."+item.fileType
				};
			});
			<s:if test="id>0">
		    	//编辑时，增加原有文件项
				items.push({id:<s:property value="ciyu.icon.id"/>,description:"<s:property value="ciyu.icon.description" escape="false"/>.<s:property value="ciyu.icon.fileType" escape="false"/>"});
				<s:if test="ciyu.cnAudio!=null">
				items.push({id:<s:property value="ciyu.cnAudio.id"/>,description:"<s:property value="ciyu.cnAudio.description" escape="false"/>.<s:property value="ciyu.cnAudio.fileType" escape="false"/>"});
				</s:if>
				<s:if test="ciyu.enAudio!=null">
				items.push({id:<s:property value="cciyu.enAudio.id"/>,description:"<s:property value="ciyu.enAudio.description" escape="false"/>.<s:property value="ciyu.enAudio.fileType" escape="false"/>"});
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
		<input id="id" type="hidden"/>
		<div class="fitem">
			<label><span style="color: red">*</span>图片:</label> <input id="icon" class="easyui-combobox"
				type="text" required="true"
				data-options="loader:uploadFileLoader,onBeforeLoad:function(param){param.ext= 'PIC';},mode: 'remote',valueField: 'id',textField: 'description',panelHeight:'auto'" />
			<input type="file" id="upload-icon-btn" /><img id="img" width="200px" height="200px"
				style="display: none;" />
		</div>
		<div class="fitem">
			<label><span style="color: red">*</span>词语:</label> <input id="ci" class="easyui-validatebox"
				type="text" required="true" />
		</div>
		<div class="fitem">
			<label>拼音:</label> <input id="pinyin" class="easyui-validatebox" type="text" />
		</div>
		<div class="fitem">
			<label>拼音音调:</label> <input id="pinyinyindiao" class="easyui-validatebox" type="text" />
		</div>
		<div class="fitem">
			<label>英文:</label> <input id="english" class="easyui-validatebox" type="text" />
		</div>
		<div class="fitem">
			<label>中文音频:</label> <input id="cnAudio" class="easyui-combobox" type="text"
				data-options="loader:uploadFileLoader,onBeforeLoad:function(param){param.ext= 'AUDIO';},mode: 'remote',valueField: 'id',textField: 'description',panelHeight:'auto'" /><input
				type="file" id="upload-cnAudio-btn" />
		</div>
		<div class="fitem">
			<label>英文音频:</label> <input id="enAudio" class="easyui-combobox" type="text"
				data-options="loader:uploadFileLoader,onBeforeLoad:function(param){param.ext= 'AUDIO';},mode: 'remote',valueField: 'id',textField: 'description',panelHeight:'auto'" /><input
				type="file" id="upload-enAudio-btn" />
		</div>
		<div class="fitem">
			<label></label> <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search"
				id="sub">提交</a>
		</div>


	</form>

</body>
</html>