<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%--
  ~ Copyright (c) 2014.
  ~ haojunhua
  --%>

<s:include value="../common/head.jsp"/>
<!--[if IE]>
<script type="text/javascript" src="js/excanvas.compiled.js"></script>
<![endif]-->
<style>
    #main-canvas-border {
        border: dashed 1px black;
        width: 520px;
        height: 400px;
        position: relative;
        margin: 0 auto;
    }

    #hanzi {
        position: absolute;
        top: 0px;
        left: 0px
    }

    #mode-info {
        position: absolute;
        right: 0px;
        bottom: 0px;
        color: gray;
        font-size: 16px;
    }

    #strokes {
        margin: 10px;
        padding: 0px;
    }

    #strokes li {
        width: 120px;
        height: 100px;
        border: solid 1px black;
        margin: 2px;
        position: relative;
        list-style: none;
        float: left;
    }

    #strokes li .status {
        position: absolute;
        right: 1px;
        bottom: 1px;
        width: 16px;
        height: 16px;
    }

    .ok {
        background: url("easyui/themes/icons/ok.png");
    }

    .edit {
        background: url("easyui/themes/icons/pencil.png");
    }

    .lock {
        background: url("easyui/themes/icons/filesave.png");
    }

    .unedit {
        background-color: white;
    }

    .edited {
        background-color: #AFEEEE;
    }

    .editing {
        background-color: #E8E8E8;
    }

    #strokes canvas {
        border: dashed 1px black;
        position: absolute;
        top: 10px;
        left: 10px;
    }

    #strokes .index {
        position: absolute;
        left: 1px;
        bottom: 1px;
        opacity: 0.4;
        font: italic 16px arial, sans-serif;
    }

    #strokes .action {
        position: absolute;
        top: 50px;
        right: 20px;
    }

    #strokes .action a:link, #strokes .action a:visited {
        text-decoration: none;
        color: black;
    }

    #strokes .action a:hover {
        text-decoration: underline;
        color: black;
    }
</style>
<script>
//canvas添加画虚线方法
CanvasRenderingContext2D.prototype.drawDashedLine = function (fromX, fromY, toX, toY, pattern, wthArrow) {
    // default interval distance -> 5px
    if (typeof pattern === "undefined") {
        pattern = 5;
    }

    // calculate the delta x and delta y
    var dx = (toX - fromX);
    var dy = (toY - fromY);
    var distance = Math.floor(Math.sqrt(dx * dx + dy * dy));
    var dashlineInteveral = (pattern <= 0) ? distance : (distance / pattern);
    var deltay = (dy / distance) * pattern;
    var deltax = (dx / distance) * pattern;

    // draw dash line
    this.beginPath();
    for (var dl = 0; dl < dashlineInteveral; dl++) {
        if (dl % 2) {
            this.lineTo(fromX + dl * deltax, fromY + dl * deltay);
        } else {
            this.moveTo(fromX + dl * deltax, fromY + dl * deltay);
        }
    }

    if (wthArrow) {
        this.moveTo(toX, toY);
        var startPoint = P(0, fromX, fromY);
        var endPoint = P(0, toX, toY);
        var distance = Point.ccpDistance(startPoint, endPoint);
        var rotatePoint = Point.ccpLerp(endPoint, startPoint, 10 / distance);
        var point1 = Point.ccpRotateByAngle(rotatePoint, endPoint, 30);//箭头一边终点
        this.lineTo(point1.x, point1.y);
        this.moveTo(toX, toY);
        var point2 = Point.ccpRotateByAngle(rotatePoint, endPoint, 330);//箭头另一边终点
        this.lineTo(point2.x, point2.y);
    }

    this.stroke();
};

var Modes = {
    kNormal: {
        text: "全字轮廓模式"
    },
    kEditStroke: {
        text: "笔划编辑模式"
    },
    kDrawStroke: {
        text: "笔划演示模式"
    },
    kDrawHanzi: {
        text: "全字演示模式"
    },
    kShowAllStroke: {
        text: "全字轨迹模式"
    }
};

function P(t, x, y) {
    return new Point.init(t, x, y);
}

var Point = {
    "t": 0,
    "x": 0,
    "y": 0,
    "init": function (t, x, y) {
        this.t = t;
        this.x = x;
        this.y = y;
    },
    "ccpEquals": function (a, b) {
        if (a.x == b.x && a.y == b.y) {
            return true;
        } else
            return false;
    },
    "ccpLerp": function (a, b, alpha) {
        return this.ccpAdd(this.ccpMult(a, 1 - alpha), this.ccpMult(b, alpha));
    },
    "ccpMult": function (v, s) {
        return P(0, v.x * s, v.y * s);
    },
    "ccpAdd": function (v1, v2) {
        return P(0, v1.x + v2.x, v1.y + v2.y);
    },
    "ccpDistance": function (v1, v2) {
        return Math.sqrt(Math.pow((v2.x - v1.x), 2) + Math.pow((v2.y - v1.y), 2));
    },
    "ccpSub": function (v1, v2) {
        return P(0, v1.x - v2.x, v1.y - v2.y);
    },
    "ccpRotateByAngle": function (v, pivot, angle) {
        var r = this.ccpSub(v, pivot);
        var cosa = Math.cos(2 * Math.PI / 360 * angle), sina = Math.sin(2 * Math.PI / 360
                * angle);
        var t = r.x;
        r.x = Math.floor(t * cosa - r.y * sina + pivot.x);
        r.y = Math.floor(t * sina + r.y * cosa + pivot.y);
        return r;
    }
};

var MODE = Modes.kNormal;//绘制模式
var STROKE_INDEX = 0;//笔划序号
var LOCUS_INDEX = 0;//轨迹点序号
var TEMP_POINT = P(0, 0, 0);//临时轨迹点
var ContourArray = new Array();//轮廓数组
var LocusArray = new Array();//轨迹数组
var IntervalDraw;//绘图定时器
var IntervalStep;//STEP定时器

var HANZI_CANVAS_WIDTH = 520;//画板宽度
var HANZI_CANVAS_HEIGHT = 400;//画板高度
var COORD_X_SHIFT = 0;//原始坐标数据 X偏移

var HEART_DISTANCE = 5;//心跳距离
var KEYPOINT_DISTANCE = 70;//关键点距离
var FRAME_RATE = 50;//刷新帧频
var WRITE_LINE_WIDTH = 40;//演示线宽

$(function () {
    init();
    draw();
    drawStrokeList();

    $("#hanzi").mousedown(
            function (e) {
                if (isFirefox = navigator.userAgent.indexOf("Firefox") > 0) {
                    addLocus(P(0, e.originalEvent.clientX - $(this).offset().left,
                            e.originalEvent.clientY - $(this).offset().top));
                } else {
                    addLocus(P(0, e.originalEvent.offsetX, e.originalEvent.offsetY));
                }
            });
});

function init() {
    $("#hanzi").css("width", HANZI_CANVAS_WIDTH);
    $("#hanzi").css("height", HANZI_CANVAS_HEIGHT);
    if (window.devicePixelRatio > 1) {
        $("#hanzi").attr("width", HANZI_CANVAS_WIDTH * window.devicePixelRatio);
        $("#hanzi").attr("height", HANZI_CANVAS_HEIGHT * window.devicePixelRatio);
        $("#hanzi")[0].getContext("2d").scale(window.devicePixelRatio, window.devicePixelRatio);
    } else {
        $("#hanzi").attr("width", HANZI_CANVAS_WIDTH);
        $("#hanzi").attr("height", HANZI_CANVAS_HEIGHT);
    }

    MODE = Modes.kNormal;
    $("#mode-info").html(MODE.text);

    var contourStr = "<s:property escape="false" value="hanzi.contour" />";
    var locusStr = "<s:property escape="false" value="hanzi.locus" />";

    //轮廓数据抽取
    var strokeArray = contourStr.split(";");
    ORDER = "";
    for (var i = 0; i < strokeArray.length; i++) {
        if (strokeArray[i] == "")
            break;
        ContourArray[i] = new Array();
        var dbPointArray = strokeArray[i].split("@");
        for (var j = 0; j < dbPointArray.length; j++) {
            if (dbPointArray[j] == "")
                break;
            var _point = dbPointArray[j].split(",");
            var Point = P(_point[0], (_point[1] - COORD_X_SHIFT) * 2, _point[2] * 2);
            ContourArray[i].push(Point);
        }

        //初始化笔划列表
        $("#strokes")
                .append(
                        "<li class='unedit'><canvas width='90' height='80'></canvas><div class='action'></div><div class='index'>"
                                + (i + 1) + "</div><div class='status'></div></li>");
        var strokeCTX = $("#strokes li canvas")[i].getContext("2d");

        strokeCTX.scale(0.2, 0.2);
    }
    $("#strokes li").click(function () {
        changeMode(Modes.kEditStroke, $("#strokes li").index($(this)));
    });

    //笔顺排序
    var SortIndex = 0;
    $("#strokes").sortable({
        "start": function (event, ui) {
            SortIndex = $("#strokes li").index(ui.item);
        },
        "update": function (event, ui) {
            var index = $("#strokes li").index(ui.item);
            reorder(SortIndex, index - SortIndex);
            $("#strokes .index").each(function (i, val) {
                $(this).html(i + 1);
            });
            if (STROKE_INDEX == SortIndex)
                STROKE_INDEX = index;
            else {
                if (STROKE_INDEX < SortIndex && STROKE_INDEX > index) {
                    STROKE_INDEX++;
                } else if (STROKE_INDEX > SortIndex && STROKE_INDEX < index) {
                    STROKE_INDEX--;
                }
            }
        }
    });

    //轨迹数据抽取
    var strokeArray = locusStr.split(";");
    for (var i = 0; i < strokeArray.length; i++) {
        if (strokeArray[i] == "")
            break;
        LocusArray[i] = new Array();
        var dbPointArray = strokeArray[i].split("@");
        if (dbPointArray.length > 0) {
            strokeListStatus(true, i);
        }
        for (var j = 0; j < dbPointArray.length; j++) {
            if (dbPointArray[j] == "")
                break;
            var _point = dbPointArray[j].split(",");
            LocusArray[i].push(P(_point[0], (_point[1] - COORD_X_SHIFT) * 2, _point[2] * 2));
        }

    }

}

/**
 * 刷新数据
 */
function step() {
    if (typeof (LocusArray[STROKE_INDEX]) == "undefined"
            || LocusArray[STROKE_INDEX].length <= 0)
        return;

    if (typeof (TEMP_POINT) == "undefined" || Point.ccpEquals(TEMP_POINT, P(0, 0, 0))) {
        TEMP_POINT = LocusArray[STROKE_INDEX][0];
    }
    var endPoint = LocusArray[STROKE_INDEX][LOCUS_INDEX + 1];
    var distance = Point.ccpDistance(TEMP_POINT, endPoint);

    switch (MODE) {
        case Modes.kDrawHanzi:
            //全字模式
            if (distance <= HEART_DISTANCE) {
                TEMP_POINT = endPoint;
                if (LOCUS_INDEX < LocusArray[STROKE_INDEX].length - 2) {
                    //下一个轨迹点
                    LOCUS_INDEX++;
                } else {
                    if (STROKE_INDEX < LocusArray.length - 1) {
                        STROKE_INDEX++;//下一个笔划
                        LOCUS_INDEX = 0;//从头开始

                        if (LocusArray[STROKE_INDEX].length > 0) {
                            //新笔划从头开始写
                            TEMP_POINT = LocusArray[STROKE_INDEX][0];
                        } else {
                            //没有轨迹信息了，需要(但未实现)停止心跳
                        }
                    } else {
                        STROKE_INDEX = 0;
                        LOCUS_INDEX = 0;
                        TEMP_POINT = P(0, 0, 0);
                    }
                }
            } else {
                TEMP_POINT = Point.ccpLerp(TEMP_POINT, endPoint, HEART_DISTANCE / distance);
            }
            break;
        case Modes.kDrawStroke:
            //笔划模式
            if (distance <= HEART_DISTANCE) {
                TEMP_POINT = endPoint;
                if (LOCUS_INDEX < LocusArray[STROKE_INDEX].length - 2) {
                    //下一个轨迹点
                    LOCUS_INDEX++;
                } else {
                    LOCUS_INDEX = 0;//从头开始
                    TEMP_POINT = LocusArray[STROKE_INDEX][0];
                }
            } else {
                TEMP_POINT = Point.ccpLerp(TEMP_POINT, endPoint, HEART_DISTANCE / distance);
            }
            break;
        default:
            break;
    }
}

/**
 * 绘制方法
 */
function draw() {
    var ctx = $("#hanzi")[0].getContext("2d");
    ctx.clearRect(0, 0, HANZI_CANVAS_WIDTH, HANZI_CANVAS_HEIGHT);
    ctx.lineJoin = "round";
    ctx.lineCap = "round";

    switch (MODE) {
        case Modes.kNormal:
            //绘制全字轮廓
            ctx.beginPath();
            for (var i = 0; i < ContourArray.length; i++) {
                for (var j = 0; j < ContourArray[i].length; j++) {
                    if (j == 0)
                        ctx.moveTo(ContourArray[i][0].x, ContourArray[i][0].y);
                    else
                        ctx.lineTo(ContourArray[i][j].x, ContourArray[i][j].y);
                }
                ctx.closePath();
            }
            ctx.stroke();
            break;
        case Modes.kDrawHanzi:

            //已划笔划
            ctx.beginPath();
            ctx.fillStyle = "#000000";
            for (var i = 0; i < STROKE_INDEX; i++) {
                for (var j = 0; j < ContourArray[i].length; j++) {
                    if (j == 0)
                        ctx.moveTo(ContourArray[i][0].x, ContourArray[i][0].y);
                    else
                        ctx.lineTo(ContourArray[i][j].x, ContourArray[i][j].y);
                }
                ctx.fill();
            }

            //剩余轮廓轮廓，在当前笔划前绘制剩余，使得当前不会不被遮挡
            ctx.beginPath();
            for (var i = STROKE_INDEX; i < ContourArray.length; i++) {
                for (var j = 0; j < ContourArray[i].length; j++) {
                    if (j == 0)
                        ctx.moveTo(ContourArray[i][0].x, ContourArray[i][0].y);
                    else
                        ctx.lineTo(ContourArray[i][j].x, ContourArray[i][j].y);
                }
                ctx.closePath();
            }
            ctx.stroke();

            ctx.save();
            //绘制笔划轮廓
            ctx.beginPath();
            for (var j = 0; j < ContourArray[STROKE_INDEX].length; j++) {
                if (j == 0)
                    ctx.moveTo(ContourArray[STROKE_INDEX][j].x, ContourArray[STROKE_INDEX][j].y);
                else
                    ctx.lineTo(ContourArray[STROKE_INDEX][j].x, ContourArray[STROKE_INDEX][j].y);
            }

            ctx.fillStyle = "#EEEEEE";
            ctx.fill();
            ctx.restore();

            //绘制笔顺
            if (!Point.ccpEquals(TEMP_POINT, P(0, 0, 0))) {
                ctx.save();
                ctx.clip();
                ctx.beginPath();
                ctx.lineWidth = WRITE_LINE_WIDTH;
                for (var j = 0; j <= LOCUS_INDEX; j++) {
                    if (j == 0)
                        ctx.moveTo(LocusArray[STROKE_INDEX][j].x, LocusArray[STROKE_INDEX][j].y);
                    else
                        ctx.lineTo(LocusArray[STROKE_INDEX][j].x, LocusArray[STROKE_INDEX][j].y);
                }
                ctx.lineTo(TEMP_POINT.x, TEMP_POINT.y);
                ctx.stroke();
                ctx.restore();
            }

            break;
        case Modes.kEditStroke:

            if (LocusArray.length > STROKE_INDEX
                    && typeof (LocusArray[STROKE_INDEX]) != "undefined") {

                //绘制关键点
                for (var j = 0; j < LocusArray[STROKE_INDEX].length; j++) {
                    ctx.beginPath();
                    ctx.fillStyle = "rgb(0,0,0)";
                    ctx.arc(LocusArray[STROKE_INDEX][j].x, LocusArray[STROKE_INDEX][j].y, 5, 0,
                            Math.PI * 2, true);
                    ctx.fill();
                    ctx.font = "11px sans-serif";
                    ctx.fillStyle = "rgb(255,255,255)";
                    ctx.textAlign = "center";
                    ctx.textBaseline = "middle";
                    ctx.fillText(j + 1, LocusArray[STROKE_INDEX][j].x,
                            LocusArray[STROKE_INDEX][j].y);
                }

                //绘制轨迹虚线
                ctx.strokeStyle = "rgb(84,85,104)";
                var withArrow = false;
                for (var j = 0; j < LocusArray[STROKE_INDEX].length - 1; j++) {
                    ctx.drawDashedLine(LocusArray[STROKE_INDEX][j].x,
                            LocusArray[STROKE_INDEX][j].y, LocusArray[STROKE_INDEX][j + 1].x,
                            LocusArray[STROKE_INDEX][j + 1].y, 3);
                }

            }

            //绘制笔划轮廓
            ctx.beginPath();
            for (var j = 0; j < ContourArray[STROKE_INDEX].length; j++) {
                if (j == 0)
                    ctx.moveTo(ContourArray[STROKE_INDEX][j].x, ContourArray[STROKE_INDEX][j].y);
                else
                    ctx.lineTo(ContourArray[STROKE_INDEX][j].x, ContourArray[STROKE_INDEX][j].y);
            }
            ctx.closePath();
            ctx.stroke();
            break;
        case Modes.kDrawStroke:
            //绘制笔划轮廓
            ctx.beginPath();
            for (var j = 0; j < ContourArray[STROKE_INDEX].length; j++) {
                if (j == 0)
                    ctx.moveTo(ContourArray[STROKE_INDEX][j].x, ContourArray[STROKE_INDEX][j].y);
                else
                    ctx.lineTo(ContourArray[STROKE_INDEX][j].x, ContourArray[STROKE_INDEX][j].y);
            }
            ctx.stroke();

            ctx.save();
            ctx.fillStyle = "#EEEEEE";
            ctx.fill();
            ctx.restore();

            //绘制笔顺
            if (!Point.ccpEquals(TEMP_POINT, P(0, 0, 0))) {
                ctx.save();
                ctx.clip();
                ctx.beginPath();
                ctx.lineWidth = WRITE_LINE_WIDTH;
                for (var j = 0; j <= LOCUS_INDEX; j++) {
                    if (j == 0)
                        ctx.moveTo(LocusArray[STROKE_INDEX][j].x, LocusArray[STROKE_INDEX][j].y);
                    else
                        ctx.lineTo(LocusArray[STROKE_INDEX][j].x, LocusArray[STROKE_INDEX][j].y);
                }
                ctx.lineTo(TEMP_POINT.x, TEMP_POINT.y);
                ctx.stroke();
                ctx.restore();
            }

            break;
        case Modes.kShowAllStroke:
            //绘制全字轮廓
            ctx.beginPath();
            ctx.fillStyle = "rgb(185,172,164)";
            for (var i = 0; i < ContourArray.length; i++) {
                for (var j = 0; j < ContourArray[i].length; j++) {
                    if (j == 0)
                        ctx.moveTo(ContourArray[i][0].x, ContourArray[i][0].y);
                    else
                        ctx.lineTo(ContourArray[i][j].x, ContourArray[i][j].y);
                }
                ctx.fill();
            }

            for (var i = 0; i < LocusArray.length; i++) {
                //绘制关键点
                var Radius = 7;
                if (LocusArray[i].length > 1) {
                    var FirstPoint = Point.ccpLerp(LocusArray[i][0], LocusArray[i][1], Radius
                            / Point.ccpDistance(LocusArray[i][0], LocusArray[i][1]));

                    //绘制轨迹虚线
                    ctx.strokeStyle = "rgb(255,255,255)";
                    var withArrow = false;
                    for (var j = 0; j < LocusArray[i].length - 1; j++) {
                        if (j == LocusArray[i].length - 2)
                            withArrow = true;
                        var startPoint = LocusArray[i][j];
                        if (j == 0)
                            startPoint = FirstPoint;
                        var entPoint = LocusArray[i][j + 1];
                        ctx.drawDashedLine(startPoint.x, startPoint.y, entPoint.x, entPoint.y, 3,
                                withArrow);
                    }

                    ctx.beginPath();
                    ctx.strokeStyle = "rgb(0,0,0)";
                    ctx.arc(FirstPoint.x, FirstPoint.y, Radius, 0, Math.PI * 2, true);
                    ctx.stroke();
                    ctx.font = "12px sans-serif";
                    ctx.fillStyle = "rgb(0,0,0)";
                    ctx.textAlign = "center";
                    ctx.textBaseline = "middle";
                    ctx.fillText(i + 1, FirstPoint.x, FirstPoint.y);

                }

            }

            break;
        default:
            break;
    }
}

function changeMode(mode, index) {
    MODE = mode;
    if (index >= 0) {
        if (STROKE_INDEX != index) {
            if (MODE == Modes.kEditStroke) {
                if (typeof (LocusArray[STROKE_INDEX]) != "undefined"
                        && LocusArray[STROKE_INDEX].length >= 2) {
                    $("#strokes li:eq(" + STROKE_INDEX + ")").removeClass("editing unedit")
                            .addClass("edited");
                    $("#strokes li:eq(" + STROKE_INDEX + ")").find(".status").removeClass(
                            "edit").addClass("ok");
                } else {
                    $("#strokes li:eq(" + STROKE_INDEX + ")").removeClass("editing edited")
                            .addClass("unedit");
                    $("#strokes li:eq(" + STROKE_INDEX + ")").find(".status").removeClass(
                            "edit ok");
                }
            }
            STROKE_INDEX = index;
        }
        if (MODE == Modes.kEditStroke) {
            if (typeof (LocusArray[index]) == "undefined" || LocusArray[index].length < 2) {
                $("#strokes li:eq(" + index + ")").removeClass("edited unedit").addClass(
                        "editing");
            }
            $("#strokes li:eq(" + index + ")").find(".status").removeClass("ok").addClass(
                    "edit");
        }
    }
    clearInterval(IntervalDraw);
    clearInterval(IntervalStep);

    if (MODE == Modes.kShowAllStroke) {
        $("#export-stroke").show();
    } else {
        $("#export-stroke").hide();
    }

    if (MODE == Modes.kEditStroke) {
        $("#draw-stroke").show();
        $("#clear-stroke").show();
    } else {
        $("#draw-stroke").hide();
        $("#clear-stroke").hide();
    }

    if (mode == Modes.kDrawHanzi) {
        if (!isAllStrokeEdit()) {
            $.messager.alert("笔划未全部编辑", "完成全部笔划的轨迹后可进行全字演示");
            return;
        } else {
            STROKE_INDEX = 0;//全字从第一笔开始
        }
    }

    if (MODE == Modes.kDrawStroke || MODE == Modes.kDrawHanzi || MODE == Modes.kShowAllStroke) {
        $("#strokes").sortable("disable").find(".status").addClass("lock");
        IntervalDraw = setInterval(draw, FRAME_RATE);
        IntervalStep = setInterval(step, FRAME_RATE);
        $("#stop-draw").show();
    } else {
        $("#strokes").sortable("enable").find(".status").removeClass("lock");
        $("#stop-draw").hide();
    }

    if (mode == Modes.kNormal)
        STROKE_INDEX = 0;

    LOCUS_INDEX = 0;//轨迹点从头开始计
    TEMP_POINT = P(0, 0, 0);

    $("#mode-info").html(MODE.text);
    draw();
}

function isAllStrokeEdit() {
    if (LocusArray.length < ContourArray.length)
        return false;
    for (var i = 0; i < LocusArray.length; i++) {
        if (typeof (LocusArray[i]) == "undefined" || LocusArray[i].length < 1)
            return false;
    }
    return true;
}

function drawStrokeList() {
    //绘制笔划列表
    for (var i = 0; i < ContourArray.length; i++) {
        var strokeCTX = $("#strokes li canvas")[i].getContext("2d");
        for (var j = 0; j < ContourArray[i].length; j++) {
            if (j == 0)
                strokeCTX.moveTo(ContourArray[i][0].x, ContourArray[i][0].y);
            else
                strokeCTX.lineTo(ContourArray[i][j].x, ContourArray[i][j].y);
        }
        strokeCTX.fill();
    }
}

function clearLocus() {
    if (MODE == Modes.kEditStroke) {
        LocusArray[STROKE_INDEX] = [];
        draw();
        strokeListStatus(false, STROKE_INDEX);
    } else {
        $.messager.alert("是想编辑轨迹吗？", "请点击笔划列表中的“编辑轨迹”链接进入“笔划编辑模式”");
    }
}

function addLocus(point) {
    if (MODE == Modes.kEditStroke) {
        if (typeof (LocusArray[STROKE_INDEX]) == "undefined")
            LocusArray[STROKE_INDEX] = new Array();
        if (LocusArray[STROKE_INDEX].length > 0) {
            var lastPoint = LocusArray[STROKE_INDEX][LocusArray[STROKE_INDEX].length - 1];
            var distance = Point.ccpDistance(lastPoint, point);
            while (distance > KEYPOINT_DISTANCE * 2) {
                lastPoint = Point.ccpLerp(lastPoint, point, KEYPOINT_DISTANCE / distance);
                LocusArray[STROKE_INDEX].push(lastPoint);
                distance = Point.ccpDistance(lastPoint, point);
            }
        }
        LocusArray[STROKE_INDEX].push(point);
        draw();
        if (LocusArray[STROKE_INDEX].length >= 2)
            strokeListStatus(true, STROKE_INDEX);
    } else {
        $.messager.alert("是想添加笔划吗?", "请点击笔划列表中的“编辑轨迹”链接进入“笔划编辑模式”");
    }
}

function reorder(index, move) {
    if (move == 0)
        return false;
    var newIndex = index + move;
    if (index < ContourArray.length && newIndex > -1 && newIndex < ContourArray.length) {
        var i = 0;
        if (move > 0) {
            for (i = index; i < newIndex;) {
                arrayExchangeObject(ContourArray, i, i + 1);
                arrayExchangeObject(LocusArray, i, i + 1);
                ++i;
            }

        } else {
            for (i = index; i > newIndex;) {
                arrayExchangeObject(ContourArray, i, i - 1);
                arrayExchangeObject(LocusArray, i, i - 1);
                --i;
            }
        }
        return true;
    }
    return false;
}
function arrayExchangeObject(array, i1, i2) {
    var temp = array[i1];
    array[i1] = array[i2];
    array[i2] = temp;
}

function strokeListStatus(isEdited, index) {
    if (isEdited) {
        $("#strokes li:eq(" + index + ")").removeClass("unedit editing").addClass("edited");
        $("#strokes li:eq(" + index + ")").find(".status").addClass("ok");
    } else {
        $("#strokes li:eq(" + index + ")").removeClass("edited").addClass("unedit");
        $("#strokes li:eq(" + index + ")").find(".status").removeClass("ok");
    }
}

function save() {
    if (!isAllStrokeEdit()) {
        $.messager.alert("笔划未全部编辑", "完成全部笔划的轨迹后才可以保存！");
        return;
    }
    var contourStr = "";
    var locusStr = "";

    for (var i = 0; i < ContourArray.length; i++) {
        for (var j = 0; j < ContourArray[i].length; j++) {
            contourStr += ContourArray[i][j].t + "," + ContourArray[i][j].x / 2 + ","
                    + ContourArray[i][j].y / 2 + "@";
        }
        contourStr += ";";
    }
    for (var i = 0; i < LocusArray.length; i++) {
        for (var j = 0; j < LocusArray[i].length; j++) {
            locusStr += LocusArray[i][j].t + "," + LocusArray[i][j].x / 2 + ","
                    + LocusArray[i][j].y / 2 + "@";
        }
        locusStr += ";";
    }

    var param = {
        "hanzi.id": <s:property escape="false" value="hanzi.id" />,
        "hanzi.contour": contourStr,
        "hanzi.locus": locusStr
    };
    $.post("json/hanzi_updateContourLocus_feedback", param, function (data) {
        if (data.feedback == 100) {
            $.messager.show({
                title: "保存成功",
                msg: "“<s:property escape="false" value="hanzi.zi" />”笔划数据保存成功！"
            });
        } else if (data.feedback == -301) {
            alert("上传失败");
        }
    }, "json");
}

function exportStroke() {
    var image = $("#hanzi")[0]
            .toDataURL("image/png")
            .replace(
                    "image/png",
                    "image/octet-stream;Content-Disposition: attachment;filename=<s:property escape="false" value="hanzi.zi" />.png");
    window.location.href = image;
}
</script>
</head>
<body class="easyui-layout">
<div region="west" split="true" style="width:300px;">
    <ul id="strokes">
    </ul>
</div>
<div region="center" split="true" style="text-align: center;padding-top: 30px;">
    <div id="main-canvas-border">
        <canvas id="hanzi" width="520" height="400">请使用支持HTML5的浏览器编辑汉字轨迹(IE9+,Chrome,safari1.3+,firefox1.5+,Opera9+)
        </canvas>
        <div id="mode-info"></div>
    </div>
</div>
<div region="east" split="true" style="width:200px;text-align: center;padding: 20px;">
    <p>
        <a href="javascript:changeMode(Modes.kShowAllStroke,0);" class="easyui-linkbutton"
           iconCls="icon-do">全字轨迹</a>
    </p>

    <p>
        <a href="javascript:exportStroke()" id="export-stroke" class="easyui-linkbutton"
           iconCls="icon-save">导出轨迹</a>
    </p>

    <s:if test="admin.isEditable">
        <p>
            <a href="javascript:changeMode(Modes.kDrawStroke)" id="draw-stroke" class="easyui-linkbutton"
               iconCls="icon-do" style="display: none">演示轨迹</a>
        </p>

        <p>
            <a href="javascript:clearLocus()" id="clear-stroke" class="easyui-linkbutton"
               iconCls="icon-cancel" style="display: none">清空轨迹</a>
        </p>

        <p>
            <a href="javascript:changeMode(Modes.kDrawHanzi,0)" class="easyui-linkbutton" iconCls="icon-ok">演示全字</a>
        </p>

        <p>
            <a href="javascript:$('#help-dialog').dialog('open');" class="easyui-linkbutton"
               iconCls="icon-help">编辑说明</a>
        </p>

        <p>
            <a href="javascript:changeMode(Modes.kNormal,0)" class="easyui-linkbutton" iconCls="icon-no"
               id="stop-draw" style="display: none">停止演示</a>
        </p>

        <p>
            <a href="javascript:save()" class="easyui-linkbutton" iconCls="icon-save">保存数据</a>
        </p>

    </s:if>
</div>


<div id="help-dialog" class="easyui-dialog" title="编辑说明"
     style="width:800px;height:500px;padding:10px;" closed="true">
    <iframe scrolling="yes" frameborder="0" src="hanzi_rule_page" style="width:100%;height:100%;"></iframe>
</div>
</body>
</html>
