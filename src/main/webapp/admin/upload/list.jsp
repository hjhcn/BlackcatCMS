<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage=""%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%--
  ~ Copyright (c) 2014.
  ~ haojunhua
  --%>

<s:include value="../common/head.jsp" />
<script>
	$(function() {
		$("#data").datagrid({
			url : "json/upload_list_uploadFiles",
			loadFilter : function(data) {
				return data.uploadFiles;
			},
			columns : [ [ {
				field : "ck",
				checkbox : true
			}, {
				title : "ID",
				field : "id",
				width : 50,
				align : "center"
			}, {
				title : "文件描述",
				field : "description",
				width : 200
			}, {
				title : "文件目录",
				field : "fileUrl",
				width : 400
			}, {
				title : "文件大小",
				field : "fileSize",
				width : 80,
				align : "right",
				formatter: function(value,row,index){
					if(value<1024)
						return value+"<span style='color:#D8D8D8;'> KB</span>";
					else
						return Number(value/1024).toFixed(2)+"<span style='color:#606060;'> MB</span>";
				}
			}, {
				title : "上传时间",
				field : "dateline",
				width : 145,
				align : "center",
				sortable:true,
				formatter:function(value,row,index){
					return (new Date(value*1000)).pattern("yyyy-MM-dd HH:mm:ss");
				}
			}, <s:if test="admin.isSuper">{
				title : "管理员",
				field : "adminname",
				align : "center",
				formatter : function(value, row, index) {
					if(row.admin)
					return row.admin.username;
					else return "未存";
				}
			},</s:if> {
				title : "文件状态",
				field : "status",
				sortable:true,
				formatter: function(value,row,index){
					switch (value) {
					case 0:
						return "<span style='color:gray;'>未使用</span>";
						break;
					case 1:
						return "<span style='color:green;'>已转存</span>";
						break;
					default:
						return "<span style='color:gray;'>未使用</span>";
						break;
					}
				}
			}]],
			pageSize:20
		}).datagrid("getPager").pagination({
		    //displayMsg:'当前显示第 {from} 条到第 {to} 条记录，共有 {total} 条记录',
		    showPageList:true,
		    //beforePageText:'当前第',
		    //afterPageText:'页，本页共 {pages}条记录',
		    //total:300,
		    pageSize:20,
		    pageList:[10,20,30,40,50,60,70,80,100,120,150,200,250,300],
		    buttons:[{  
	            iconCls:"icon-do",
	            text:"上传文件",
	            handler:function(){
	            	$("#upload-dialog").dialog("open");
	            }  
	        },{  
	            iconCls:"icon-ok",
	            text:"支持格式查看",
	            handler:function(){
	            	$("#type-support-dialog").dialog("open");
	            }  
	        }]
		});
		
		var statusesData=[{value:-100,text:"全部"},{value:0,text:"未使用"},{value:1,text:"已转存"}];
		$("#statuses").combobox({
	        data : statusesData,
	        multiple : true,
	        panelHeight:"auto",
	        onSelect : function(r){
	            if(r.value == -100){//当选的是‘全部’这个选项
	            	$("#statuses").combobox("setValues","").combobox("setText",'全部');
	            }else{
	                var valArr = $("#statuses").combobox("getValues");
	                valArr.sort();//将值由小到大排序 以保持一致
	                if(valArr.join(',') == statusesData.join(',') || valArr.join(',') == statusesData.join(',')){
	                	$("#statuses").combobox("setValues",statusesData).combobox("setText",'全部');
	                }
	            }
	        },
	        onUnselect : function(r){
	            if(r.value == -100){//当取消选择的是‘全部’这个选项
	            	$("#statuses").combobox("setValues","").combobox("setText",'全部');
	            }else{
	                var valArr = $("#statuses").combobox("getValues");
	                if(valArr[0] == ""){
	                    valArr.shift();
	                    $("#statuses").combobox("setValues",valArr);
	                }
	            }
	        }
	    });
		
		
		$("#batch-uploadfile-btn")
		.uploadify(
				{
					'uploader' : 'resources/swf/uploadify.swf',
					'script' : 'json/upload_uploadFile_feedback;jsessionid='
							+ JSESSIONID, //指定服务端处理类的入口
					'folder' : 'avatar',
					'cancelImg' : 'resources/images/cancel.png',
					'fileDataName' : 'file', //和input的name属性值保持一致就好，Struts2就能处理了   
					'queueID' : 'fileQueue',
					'auto' : true,//是否选取文件后自动上传   
					'multi' : true,//是否支持多文件上传
					'simUploadLimit' : 10,//每次最大上传文件数   
					'buttonText' : '上传文件',//按钮上的文字   
					'fileExt' : '*.jpg;*.mp3;',
					'fileDesc' : '支持图片(jpg\gif\png\bmp)文件、音频文件(MP3)',
					'displayData' : 'percentage',//有speed和percentage两种，一个显示速度，一个显示完成百分比    
					'onComplete' : function(event, queueID, fileObj,
							res, _data) {
					},
					'onError' : function(event, queueID, fileObj,
							errorObj) {
						alert(errorObj.type + "Error:" + errorObj.info);
					},
					'onSelect' : function(event, ID, fileObj) {
					},
					'onAllComplete' : function(event, uploadObj) {
						$("#upload-dialog").dialog("close");
						$("#data").datagrid("load");
					}

				});
		
		
		$("#ftp-add").click(function(){
		　　　　　　　if($("#ftpFile option:selected").length>0)
		　　　　　　　{
		　　　　　　　　　　　$("#ftpFile option:selected").each(function(){
		　　　　　　　　　　　　　　$("#ftpFileUpload").append("<option value='"+$(this).val()+"'>"+$(this).text()+"</option>");
		　　　　　　　　　　　　　　$(this).remove();　
		　　　　　　　　　　　})
		　　　　　　　}
		　　　　　　　else
		　　　　　　　{
		　　　　　　　　　　　alert("请选择要添加的文件！");
		　　　　　　　}
		　　　});
		$("#ftp-delete").click(function(){
		　　　　　　　if($("#ftpFileUpload option:selected").length>0)
		　　　　　　　{
		　　　　　　　　　　　$("#ftpFileUpload option:selected").each(function(){
		　　　　　　　　　　　　　　$("#ftpFile").append("<option value='"+$(this).val()+"'>"+$(this).text()+"</option>");
		　　　　　　　　　　　　　　$(this).remove();　
		　　　　　　　　　　　})
		　　　　　　　}
		　　　　　　　else
		　　　　　　　{
		　　　　　　　　　　　alert("请选择要还原的文件！");
		　　　　　　　}
		　　　});
		   
		$("#ftp-uploadfile-btn").click(function(){
			      if($("#ftpFileUpload option").length>0){
					  var param = {};
			    	  $("#ftpFileUpload option").each(function(index,item){
			  			param["ftpFileNames[" + index + "]"] = $(this).val();
			　　　　　 　});
			    	  $.ajax({
			  			url : "json/upload_importFromFtp_feedback",
			  			data : param,
			  			success : function(data) {
			  				if (data.feedback > 0) {
			  					$.messager.show({
			  						title : "成功",
									msg : "上传成功了" + data.feedback + "个"
			  					});
			  					$("#data").datagrid("reload");
			  				} else {
			  					$.messager.show({
			  						title : "操作没有成功",
			  						msg : "没有上传成功，可能是因为格式不对"
			  					});
			  				}
			  			}
			  		});
			      }
		　　　　　　else
		　　　　　　{
		　　　　　　　　　　　alert("请选择要上传的文件！");
		　　　　　　}
		});

	});
	

	var fileDescLoader = function(param,success,error){
        var q = param.q || "";
        if (q.length <= 1){return false}
        $.getJSON("json/upload_list_uploadFiles",{"search": q},function(data){
                var items = $.map(data.uploadFiles.rows, function(item){
                    return {
                    	description: item.description,
                    };
                });
                success(items);
        });
    }
	
	function search() {
		$("#data").data().datagrid.cache = null;
		var queryparams = $("#data").datagrid("options").queryParams;
		var startTS=Math.floor((new Date($("#startTimeStamp").datetimebox("getValue")).getTime() )/ 1000);
		var endTS=Math.floor((new Date($("#endTimeStamp").datetimebox("getValue")).getTime() )/ 1000);
		queryparams["tsRange.startTimeStamp"]=startTS;
		queryparams["tsRange.endTimeStamp"]=endTS;
		queryparams["search"]=$("#file_desc").combobox("getValue");
		queryparams["statuses"]=($("#statuses").combobox("getValues")).join(",");
		$("#data").datagrid("load");
	}
	 
</script>
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
</style>
<body>
	<div id="tb" style="padding:5px;height:auto">
		<div>
			文件描述: <input class="easyui-combobox" id="file_desc" style="width:200px"
				data-options="loader:fileDescLoader,mode: 'remote',valueField: 'description',textField: 'description',panelHeight:'auto'">
			状态: <select id="statuses" style="width:155px"></select> 开始日期: <input class="easyui-datetimebox"
				style="width:160px" id="startTimeStamp"
				value="<s:bean name="blackcat.utils.Time" id="time"><s:property escape="false"  value="#time.timeFormat(tsRange.startTimeStamp,'MM/dd/yyyy hh:mm:ss')"/></s:bean>">
			截止日期: <input class="easyui-datetimebox" style="width:160px" id="endTimeStamp"
				value="<s:bean name="blackcat.utils.Time" id="time"><s:property escape="false"  value="#time.timeFormat(tsRange.endTimeStamp,'MM/dd/yyyy hh:mm:ss')"/></s:bean>">
			<a href="javascript:search()" class="easyui-linkbutton" iconCls="icon-search" type="sub"
				plain="true">搜索</a>
		</div>
	</div>
	<table id="data" fit="true" pagination="true" data-options="toolbar:'#tb'" border="no">
	</table>
	<div id="type-support-dialog" class="easyui-dialog" title="支持格式" style="width:400px;padding:20px;"
		closed="true">
		目前支持的格式有： <br /> 图片："jpg", "gif", "png", "bmp", "jpeg"<br /> 音频："MP3"<br /> <span
			style="color:red">其他格式不可上传</span>
	</div>

	<div id="upload-dialog" class="easyui-dialog" title="批量上传" style="width:600px;padding:10px;"
		closed="true" data-options="iconCls: 'icon-save',buttons:'#dialog-buttons'">
		<div id="fileQueue" style="height: 200px;overflow: auto;"></div>
	</div>
	<div id="dialog-buttons">
		<input type="file" id="batch-uploadfile-btn" />
	</div>

	<div id="ftp-upload-dialog" class="easyui-dialog" title="FTP上传" style="width:600px;padding:10px;"
		closed="true" data-options="iconCls: 'icon-save',buttons:'#ftp-dialog-buttons'">
		<table style="font-size: 13px;" width="100%">
			<tr>
				<td width="40%">文件列表：<br /> <select width="100%" id="ftpFile" multiple="multiple"
					size="10" style="width:200px" title="按ctrl或shift键可选择多项" class="easyui-tooltip"></select></td>
				<td width="20%" align="center"><a href="javascript:void(0)" class="easyui-linkbutton"
					id="ftp-add">添加&gt;&gt;</a><br /> <br /> <a href="javascript:void(0)"
					class="easyui-linkbutton" id="ftp-delete">&lt;&lt;还原</a></td>
				<td width="40%">上传列表：<br /> <select id="ftpFileUpload" multiple="multiple" size="10"
					style="width:200px" title="按ctrl或shift键可选择多项" class="easyui-tooltip"></select></td>
			</tr>
		</table>
	</div>
	<div id="ftp-dialog-buttons">
		<a href="javascript:void(0)" class="easyui-linkbutton" id="ftp-uploadfile-btn">上传</a>
	</div>
</body>
</html>