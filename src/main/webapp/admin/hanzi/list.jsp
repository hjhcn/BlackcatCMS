<%@ page contentType="text/html; charset=utf-8" language="java" errorPage="" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%--
  ~ Copyright (c) 2014.
  ~ haojunhua
  --%>

<s:include value="../common/head.jsp"/>
<style>
    <!--
    .floatLayer {
        position: absolute;
        right: 0px;
        top: 62px;
        display: none;
        overflow: auto;
        background: white;
        width: 310px;
        border-left: 1px solid #D3D3D3;
        padding: 10px;
    }

    .floatLayer .close {
        position: absolute;
        right: 10px;
        top: 10px;
        width: 16px;
        height: 16px;
        cursor: pointer;
        background: url("easyui/themes/icons/cancel.png");
    }

    .floatLayer #wenhao {
        position: absolute;
        right: 250px;
        top: 10px;
    }

    #hanzi_zi {
        font-size: 50;
    }

    .zuciju {
        position: relative;
        font-size: 12px;
        width: 310px;
    }

    .zuciju ul {
        border: 1px solid #EEEEEE;
        padding: 20px;
        margin: 5px 0px;
    }

    .zuciju li {
        margin: 0px;
        padding: 0px;
        line-height: 30px;
        list-style: none;
    }

    .floatInfo {
        position: absolute;
        right: 330px;
        top: 62px;
        background: #ffffff;
        width: 200px;
        display: none;
        border-left: 1px solid #D3D3D3;
        border-bottom: 1px solid #D3D3D3;
        border-right: 1px solid #D3D3D3;
        padding: 10px;
        font-size: 13px;
    }

    .floatInfo .close {
        position: absolute;
        right: 10px;
        top: 10px;
        width: 16px;
        height: 16px;
        cursor: pointer;
        background: url("easyui/themes/icons/cancel.png");
    }

    -->
</style>
<script>
var ACTION = {VERIFY: "VERIFY", UNVERIFY: "UNVERIFY", SELECT_FOR_WEB: "SELECT_FOR_WEB"};
var statusesData = [
    {
        value: 0,
        text: "默认(未选字)",
        color: "gray"
    },
    {
        value: 1,
        text: "已分配但未编辑",
        color: "blue"
    },
    {
        value: 2,
        text: "已编辑等待审核",
        color: "red"
    },
    {
        value: 3,
        text: "审核未通过",
        color: "orange"
    },
    {
        value: 4,
        text: "已审核通过",
        color: "green"
    },
    {
        value: 5,
        text: "新一批所选未审核",
        color: "orange"
    },
    {
        value: -100,
        text: "全部"
    }
];//顺序不可改，下面已使用index作为序列，有待优化

var cijuStatusesData = [
    {
        value: 0,
        text: "默认(未编辑)",
        color: "gray"
    },
    {
        value: 1,
        text: "已编辑",
        color: "green"
    }
];

var HID;

$(function () {


    $("#data").datagrid({
        url: "json/hanzi_list_hanzis",
        loadFilter: function (data) {
            return data.hanzis;
        },
        columns: [
            [
                {
                    field: "ck",
                    checkbox: true
                },
                {
                    field: "id",
                    hidden: true
                },
                {
                    title: "汉字",
                    field: "zi",
                    align: "center"
                },
                {
                    title: "拼音",
                    field: "pinyin"
                },
                {
                    title: "音调",
                    field: "pinyinyindiao"
                },
                {
                    title: "笔画数",
                    field: "bihuashu"
                },
                {
                    title: "部首",
                    field: "bushou",
                    align: "center"
                }
                <s:if test="admin.isSuper">
                ,
                {
                    title: "管理员",
                    field: "admin",
                    sortable: true,
                    align: "center",
                    formatter: function (value, row, index) {
                        if (row.admin)
                            return row.admin.username;
                        else return "未分配";
                    }
                },
                {
                    title: "WEB公开",
                    field: "selected",
                    sortable: true,
                    align: "center",
                    formatter: function (value, row, index) {
                        if (value == 1) {
                            return "<span style='color:green;'>是</span>";
                        } else {
                            return "否";
                        }
                    }
                }
                </s:if>
                ,
                {
                    title: "状态",
                    field: "status",
                    sortable: true,
                    formatter: function (value, row, index) {
                        return "<span style='color:" + statusesData[value].color + ";'>" + statusesData[value].text + "</span>";
                    }
                }
                ,
                {
                    title: "组词句状态",
                    field: "cijuStatus",
                    sortable: true,
                    formatter: function (value, row, index) {
                        return "<span style='color:" + cijuStatusesData[value].color + ";'>" + cijuStatusesData[value].text + "</span>";
                    }
                }
            ]
        ],
        sortName: "id",
        sortOrder: "asc",
        pageNumber: 1,
        pageSize: 20,
        onClickRow: function (rowIndex, rowData) {
            <s:if test="admin.isEditable">
            HID = rowData.id;
            $("#hanziShow #hanzi_zi").html(rowData.zi);
            var pinyinArray = (rowData.pinyinyindiao).split(",");
            $(".zuciju").html("");

            $(pinyinArray).each(function (i, val) {
                if (val.length > 0) {
                    var zuciju = $("#hanziShow #template").eq(0).clone();
                    $(zuciju).find(".pinyin").html(val);

                    $(rowData.zucijus).each(function (_i, _val) {
                        if (_val.pinyinyindiao == val) {
                            $(zuciju).find("input[name=ci1]").val(_val.ci1);
                            $(zuciju).find("input[name=ci2]").val(_val.ci2);
                            $(zuciju).find("input[name=ju]").val(_val.ju);
                            $(zuciju).find("input[name=id]").val(_val.id);
                        }
                    });

                    $(".zuciju").append(zuciju);
                    $(zuciju).show();
                }
            });
            $("#hanziShow").show();

            $("#info").html(rowData.info);

            $("#updateZuciju").click(function () {
                var param = {};
                var index = 0;
                param["hid"] = HID;
                $("#hanziShow .zuciju ul").each(function () {
                    var pinyinyindiao = $(this).find(".pinyin").html();
                    var ci1 = $(this).find("input[name=ci1]").val();
                    var ci2 = $(this).find("input[name=ci2]").val();
                    var ju = $(this).find("input[name=ju]").val();
                    var id = $(this).find("input[name=id]").val();
                    param["zucijuList[" + index + "].pinyinyindiao"] = pinyinyindiao;
                    param["zucijuList[" + index + "].ci1"] = ci1;
                    param["zucijuList[" + index + "].ci2"] = ci2;
                    param["zucijuList[" + index + "].ju"] = ju;
                    param["zucijuList[" + index + "].id"] = id;
                    index++;
                });
                $.getJSON("json/hanzi_updateZuciju_feedback", param, function (data) {
                    if (data.feedback >= 0) {
                        $("#data").datagrid("reload");
                        $.messager.show({
                            title: "成功",
                            msg: "保存成功"
                        });
                    } else {
                        $.messager.alert("操作没有成功", "操作没有成功");
                    }
                });

            });
            </s:if>
        }
    }).datagrid("getPager").pagination(
            {
                showPageList: true,
                pageSize: 20,
                buttons: [
                    {
                        iconCls: "icon-edit",
                        text: "编辑",
                        handler: function () {
                            var rows = $("#data").datagrid("getSelections");
                            if (rows.length <= 0)
                                $.messager.alert("出错了", "请至少选择一项");
                            else {
                                for (var i in rows) {
                                    parent.openTab("汉字轨迹(" + rows[i].zi + ")",
                                            "hanzi_stroke?id=" + rows[i].id);
                                }
                            }
                        }
                    }
                    <s:if test="admin.isSuper">
                    ,
                    {
                        iconCls: "icon-ok",
                        text: "审核通过",
                        handler: function () {
                            operate(ACTION.VERIFY);
                        }
                    }
                    ,
                    {
                        iconCls: "icon-cancel",
                        text: "审核不通过",
                        handler: function () {
                            operate(ACTION.UNVERIFY);
                        }
                    }
                    ,
                    {
                        iconCls: "icon-do",
                        text: "FOR微信",
                        handler: function () {
                            operate(ACTION.SELECT_FOR_WEB);
                        }
                    },
                    {
                        iconCls: "icon-undo",
                        text: "批量存中文音频",
                        handler: function () {

                            $("#upload-dialog").dialog("open");
                        }
                    }
                    </s:if>
                ]
            });

    $("#fileList").datagrid({
        url: "json/upload_list_uploadFiles",
        queryParams: {
            "statuses": "0",
            "ext": "AUDIO"
        },
        loadFilter: function (data) {
            return data.uploadFiles;
        },
        columns: [
            [
                {
                    field: "ck",
                    checkbox: true
                },
                {
                    title: "名称",
                    field: "description",
                    width: 100
                },
                {
                    title: "地址",
                    field: "webUrl"
                }
            ]
        ],
        pageSize: 20,
        pageList: [ 20, 50, 300, 500 ]
    });

    $("#statuses").combobox(
            {
                data: statusesData,
                multiple: true,
                panelHeight: "auto",
                onSelect: function (r) {
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
                onUnselect: function (r) {
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

    //修改hanziShow的高度
    $("#hanziShow").css("height", ($("body").height() - 62) + "px");
    $(window).resize(function () {
        $("#hanziShow").css("height", ($("body").height() - 62) + "px");
    });
    $("#hanziShow .close").click(function () {
        $("#hanziShow").hide();
    });
    $("#hanziShow #wenhao").click(function () {
        $(".floatInfo").show();
    });
    $(".floatInfo .close").click(function () {
        $(".floatInfo").hide();
    });
})
;

function operate(operate) {
    var ids = "";
    var rows = $("#data").datagrid("getSelections");
    for (var i = 0; i < rows.length; i++) {
        var row = rows[i];
        if (i > 0)
            ids += ",";
        ids += row.id;
    }
    if (ids.length > 0) {
        $.getJSON("json/hanzi_operate_count", {
            "ids": ids,
            "operate": operate
        }, function (data) {
            if (data.count >= 0) {
                $("#data").datagrid("reload");
                $.messager.show({
                    title: "成功",
                    msg: "成功了" + data.count + "记录"
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
    queryparams["zi"] = $("#zi").val();
    queryparams["statuses"] = ($("#statuses").combobox("getValues")).join(",");
    $("#data").datagrid("load");
}

function batchSave() {
    var fileListStr = "";
    var rows = $("#fileList").datagrid("getSelections");
    for (var i = 0; i < rows.length; i++) {
        var row = rows[i];
        if (i > 0)
            fileListStr += ";";
        fileListStr += row.id + "," + row.description;
    }
    if (fileListStr.length > 0) {
        $.post("json/hanzi_batchSaveAudio_feedback", {
            "fileListStr": fileListStr
        }, function (data) {
            if (data.feedback > 0) {
                $("#imageList").datagrid("reload");
                $.messager.show({
                    title: "成功",
                    msg: "成功了" + data.feedback + "记录"
                });
                $("#data").datagrid("load");
                ;
            } else {
                $.messager.alert("操作没有成功", "操作没有成功");
            }
        }, "json");
    } else {
        $.messager.alert("出错了", "请至少选择一条有效");
    }
}


function Zuciju(id, pinyinyindiao, ci1, ci2, ju, hid) {
    this.id = id;
    this.pinyinyindiao = pinyinyindiao;
    this.ci1 = ci1;
    this.ci2 = ci2;
    this.ju = ju;
    this.Hanzi = function () {
        this.id = hid;
    }
}

</script>
<body style="position: relative;">
<div id="tb" style="padding:5px;height:auto">
    <div>
        字: <input id="zi" style="width:200px"> 状态: <select id="statuses" style="width:155px"></select>
        <a href="javascript:search()" class="easyui-linkbutton" iconCls="icon-search" type="sub"
           plain="true">搜索</a>
    </div>
</div>
<table id="data" pagination="true" fit="true" data-options="toolbar:'#tb'"
       data-options="rownumbers:true,singleSelect:true" border="no"></table>


<div id="upload-dialog" class="easyui-dialog" title="选择已上传音频"
     style="width:500px;padding:10px; height: 500px;" closed="true"
     data-options="iconCls: 'icon-save',buttons:'#dialog-buttons'">
    <table id="fileList" fit="true" pagination="true"></table>
</div>
<div id="dialog-buttons">
    <a href="javascript:parent.openTab('文件管理','upload_list_page')" class="easyui-linkbutton"
       iconCls="icon-add" type="sub" plain="true">上传文件</a> <a href="javascript:batchSave()"
                                                              class="easyui-linkbutton" iconCls="icon-save" type="sub">保存</a>
</div>

<div id="hanziShow" class="floatLayer">
    <div class="close"></div>
    <div id="wenhao"><a id="showInfo" class="easyui-linkbutton" iconCls="icon-help" plain="true"></a></div>
    <div id="hanzi_zi"></div>

    <div class="zuciju">

    </div>
    <ul style="display: none" id="template">
        <li>拼音：
            <span class="pinyin"></span>
        </li>
        <li>组词：<input name="ci1" value="" size="10"/></li>
        <li>组词：<input name="ci2" value="" size="10"/></li>
        <li>组句：<input name="ju" value="" size="30"/></li>
    </ul>
    <div><a id="updateZuciju" class="easyui-linkbutton" type="sub">保存</a></div>
</div>
<div class="floatInfo">
    <div class="close"></div>
    <div id="info"></div>
</div>

</body>