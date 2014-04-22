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
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
<script type="text/javascript" src="admin/js/jquery.min.js"></script>
<script type="text/javascript">
	//canvas添加画虚线方法
	CanvasRenderingContext2D.prototype.drawDashedLine = function(fromX, fromY, toX, toY, pattern,
			wthArrow) {
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
		for ( var dl = 0; dl < dashlineInteveral; dl++) {
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

	var CallObjcCMD = {
		kLoadedFinish : 0,
		kWriteOk : 1,
		kChangeToWriteMode : 2,
		kYanshi : 3
	}
	var Modes = {
		kNormal : {
			text : "全字轮廓模式"
		},
		kEditStroke : {
			text : "笔划编辑模式"
		},
		kDrawStroke : {
			text : "笔划演示模式"
		},
		kDrawHanzi : {
			text : "全字演示模式"
		},
		kWrite : {
			text : "写字模式"
		}
	};
	function P(t, x, y) {
		return new Point.init(t, x, y);
	}

	var Point = {
		"t" : 0,
		"x" : 0,
		"y" : 0,
		"init" : function(t, x, y) {
			this.t = t;
			this.x = x;
			this.y = y;
		},
		"ccpEquals" : function(a, b) {
			if (a.x == b.x && a.y == b.y) {
				return true;
			} else
				return false;
		},
		"ccpLerp" : function(a, b, alpha) {
			return this.ccpAdd(this.ccpMult(a, 1 - alpha), this.ccpMult(b, alpha));
		},
		"ccpMult" : function(v, s) {
			return P(0, v.x * s, v.y * s);
		},
		"ccpAdd" : function(v1, v2) {
			return P(0, v1.x + v2.x, v1.y + v2.y);
		},
		"ccpDistance" : function(v1, v2) {
			return Math.sqrt(Math.pow((v2.x - v1.x), 2) + Math.pow((v2.y - v1.y), 2));
		},
		"ccpSub" : function(v1, v2) {
			return P(0, v1.x - v2.x, v1.y - v2.y);
		},
		"ccpRotateByAngle" : function(v, pivot, angle) {
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
	var ContourArray = [];//轮廓数组
	var LocusArray = [];//轨迹数组
	var WriteArray = [];//书写数组
	var IntervalDraw;//绘图定时器
	var IntervalStep;//STEP定时器
	var IntervalYanshi;//演示定时器。书写模式下,若一段时间没有任何操作,则认为当前笔划不会写,将进行该笔划演示
	var IsYanshi = false;//是否进行演示，定时置true，将用于step调用

	var ImagePencil = new Image();//笔图标
	var IsImagePencilLoaded = false;

	var HANZI_CANVAS_SCALE = 0.95;//CANVAS相对于页面宽度百分比
	var HANZI_CANVAS_HANZI_SCALE = 0.95;//汉字相对于canvas比例，防止过于接近边框
	var COORD_X_SHIFT = 30;//原始坐标数据 X偏移

	var FRAME_RATE = 60;//刷新帧频
	var WRITE_YANSHI_RATE = 5000;//书写等待时间，配合IntervalYanshi进行单个笔划演示

	var HANZI_CANVAS_WIDTH;//画板宽度
	var HANZI_CANVAS_HEIGHT;//画板高度
	var HANZI_CANVAS_OFFSETX;
	var HANZI_CANVAS_OFFSETY;
	var HANZI_OFFSET_X;//汉字相对于canvas左上角 水平偏移
	var HANZI_OFFSET_Y;//汉字相对于canvas左上角 垂直偏移
	var WRITE_LINE_WIDTH;//演示（书写）线宽
	var WRITE_ACCEPTED_DISTANCE;//书写误差距离
	var HEART_DISTANCE;//心跳距离

	$(function() {
		//初始化环境参数
		initSettings();

		//初始化数据
		initData('<s:property escape="false" value="hanzi.contour" />',
				'<s:property escape="false" value="hanzi.locus" />');

		//初始化模式为全字演示
		setMode(Modes.kDrawHanzi);

		//绑定事件
		$("#yanshi").click(function(event) {
			setMode(Modes.kDrawHanzi);
		});
		$("#rewrite").click(function(event) {
			reWrite();
		});
		$("#hanzi")[0].addEventListener("touchstart", write, true);
		$("#hanzi")[0].addEventListener("touchmove", write, true);
		$("#hanzi")[0].addEventListener("touchend", write, true);
		$("#hanzi")[0].addEventListener("touchcancel", write, true);
		//$("#hanzi")[0].addEventListener("mousedown", write, true);
		//$("#hanzi")[0].addEventListener("mousemove", write, true);
		//$("#hanzi")[0].addEventListener("mouseup", write, true);
		//$("#hanzi")[0].addEventListener("mouseout", write, true);

	});

	function initSettings() {
		HANZI_CANVAS_WIDTH = document.body.clientWidth * HANZI_CANVAS_SCALE;
		HANZI_CANVAS_HEIGHT = document.body.clientWidth * HANZI_CANVAS_SCALE;
		WRITE_LINE_WIDTH = HANZI_CANVAS_WIDTH / 10.0;//线宽修改
		WRITE_ACCEPTED_DISTANCE = HANZI_CANVAS_WIDTH / 10.0;//误差接收修改
		HEART_DISTANCE = HANZI_CANVAS_WIDTH / 400.0 * 10;//心跳距离修改
		HANZI_OFFSET_X = HANZI_CANVAS_WIDTH * (1 - HANZI_CANVAS_SCALE) / 2;
		HANZI_OFFSET_Y = HANZI_CANVAS_HEIGHT * (1 - HANZI_CANVAS_SCALE) / 2;
		HANZI_CANVAS_OFFSETX = elementLeft($("#hanzi")[0]);
		HANZI_CANVAS_OFFSETY = elementTop($("#hanzi")[0]);
		$("#hanzi").css("width", HANZI_CANVAS_WIDTH);
		$("#hanzi").css("height", HANZI_CANVAS_HEIGHT);
		$("#hanzi").css("margin-left", HANZI_CANVAS_WIDTH * (1 - HANZI_CANVAS_SCALE) / 2);

		//初始化笔图标
		ImagePencil.src = "css/images/pencil.png";
		ImagePencil.width = 20;
		ImagePencil.height = 48;
		ImagePencil.onload = function() {
			IsImagePencilLoaded = true;
		}

		if (window.devicePixelRatio > 1) {
			$("#hanzi").attr("width", HANZI_CANVAS_WIDTH * window.devicePixelRatio);
			$("#hanzi").attr("height", HANZI_CANVAS_HEIGHT * window.devicePixelRatio);
			$("#hanzi")[0].getContext("2d").scale(window.devicePixelRatio, window.devicePixelRatio);
			ImagePencil.src = "css/images/pencil@2x.png";

		} else {
			$("#hanzi").attr("width", HANZI_CANVAS_WIDTH);
			$("#hanzi").attr("height", HANZI_CANVAS_HEIGHT);

		}
	}

	function initData(contourStr, locusStr) {

		var widthScale = HANZI_CANVAS_WIDTH / 200 * HANZI_CANVAS_HANZI_SCALE;
		var heightScale = HANZI_CANVAS_HEIGHT / 200 * HANZI_CANVAS_HANZI_SCALE;

		//轮廓数据抽取
		var strokeArray = contourStr.split(";");
		for ( var i = 0; i < strokeArray.length; i++) {
			if (strokeArray[i] == "")
				break;
			ContourArray[i] = [];
			var dbPointArray = strokeArray[i].split("@");
			for ( var j = 0; j < dbPointArray.length; j++) {
				if (dbPointArray[j] == "")
					break;
				var _point = dbPointArray[j].split(",");
				var Point = P(_point[0], (_point[1] - COORD_X_SHIFT) * widthScale + HANZI_OFFSET_X,
						_point[2] * heightScale + HANZI_OFFSET_Y);
				ContourArray[i].push(Point);
			}
		}

		//轨迹数据抽取
		var strokeArray = locusStr.split(";");
		for ( var i = 0; i < strokeArray.length; i++) {
			if (strokeArray[i] == "")
				break;
			LocusArray[i] = [];
			var dbPointArray = strokeArray[i].split("@");
			for ( var j = 0; j < dbPointArray.length; j++) {
				if (dbPointArray[j] == "")
					break;
				var _point = dbPointArray[j].split(",");
				LocusArray[i].push(P(_point[0], (_point[1] - COORD_X_SHIFT) * widthScale
						+ HANZI_OFFSET_X, _point[2] * heightScale + HANZI_OFFSET_Y));
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
		case Modes.kWrite:
			if (IsYanshi) {//******等待修改
				//笔划模式
				if (distance <= HEART_DISTANCE) {
					TEMP_POINT = endPoint;
					if (LOCUS_INDEX < LocusArray[STROKE_INDEX].length - 2) {
						//下一个轨迹点
						LOCUS_INDEX++;
					} else {
						LOCUS_INDEX = 0;//从头开始
						TEMP_POINT = LocusArray[STROKE_INDEX][0];
						IsYanshi = false;//关闭演示，只演示一次
					}
				} else {
					TEMP_POINT = Point.ccpLerp(TEMP_POINT, endPoint, HEART_DISTANCE / distance);
				}
			}

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

		//底色
		ctx.beginPath();
		ctx.moveTo(0, 0);
		ctx.lineTo(HANZI_CANVAS_WIDTH, 0);
		ctx.lineTo(HANZI_CANVAS_WIDTH, HANZI_CANVAS_HEIGHT);
		ctx.lineTo(0, HANZI_CANVAS_HEIGHT);
		ctx.closePath();
		ctx.fillStyle = "rgb(253,249,238)";
		ctx.fill();

		//田字框
		ctx.lineWidth = 2;
		ctx.strokeStyle = "rgb(160,160,160)";
		//虚线稍微添加
		ctx.drawDashedLine(0, 0, HANZI_CANVAS_WIDTH, HANZI_CANVAS_HEIGHT, 5);
		ctx.drawDashedLine(HANZI_CANVAS_WIDTH, 0, 0, HANZI_CANVAS_HEIGHT, 5);
		ctx.drawDashedLine(HANZI_CANVAS_WIDTH / 2, 0, HANZI_CANVAS_WIDTH / 2, HANZI_CANVAS_HEIGHT,
				5);
		ctx.drawDashedLine(0, HANZI_CANVAS_HEIGHT / 2, HANZI_CANVAS_WIDTH, HANZI_CANVAS_HEIGHT / 2,
				5);

		//边框
		ctx.beginPath();
		ctx.moveTo(0, 0);
		ctx.lineTo(HANZI_CANVAS_WIDTH, 0);
		ctx.lineTo(HANZI_CANVAS_WIDTH, HANZI_CANVAS_HEIGHT);
		ctx.lineTo(0, HANZI_CANVAS_HEIGHT);
		ctx.closePath();
		ctx.lineWidth = 10;
		ctx.strokeStyle = "rgb(84,85,104)";
		ctx.stroke();
		//恢复lineWidth
		ctx.lineWidth = 1;

		switch (MODE) {
		case Modes.kNormal:
			//绘制全字轮廓
			ctx.beginPath();
			for ( var i = 0; i < ContourArray.length; i++) {
				for ( var j = 0; j < ContourArray[i].length; j++) {
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
			ctx.fillStyle = "rgb(100,53,14)";
			for ( var i = 0; i < STROKE_INDEX; i++) {
				for ( var j = 0; j < ContourArray[i].length; j++) {
					if (j == 0)
						ctx.moveTo(ContourArray[i][0].x, ContourArray[i][0].y);
					else
						ctx.lineTo(ContourArray[i][j].x, ContourArray[i][j].y);
				}
				ctx.fill();
			}

			//剩余轮廓轮廓，在当前笔划前绘制剩余，使得当前不会不被遮挡
			ctx.beginPath();
			for ( var i = STROKE_INDEX; i < ContourArray.length; i++) {
				for ( var j = 0; j < ContourArray[i].length; j++) {
					if (j == 0)
						ctx.moveTo(ContourArray[i][0].x, ContourArray[i][0].y);
					else
						ctx.lineTo(ContourArray[i][j].x, ContourArray[i][j].y);
				}
				ctx.closePath();
				ctx.strokeStyle = "rgb(100,53,14)";
				ctx.stroke();
				ctx.fillStyle = "rgb(255,255,255)";
				ctx.fill();
			}

			ctx.save();
			//绘制笔划轮廓
			ctx.beginPath();
			for ( var j = 0; j < ContourArray[STROKE_INDEX].length; j++) {
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
				ctx.strokeStyle = "rgb(100,53,14)";
				ctx.lineWidth = WRITE_LINE_WIDTH;
				for ( var j = 0; j <= LOCUS_INDEX; j++) {
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

		case Modes.kWrite:
			//绘制剩余轮廓
			ctx.strokeStyle = "rgb(100,53,14)";
			ctx.fillStyle = "rgb(255,255,255)";
			ctx.beginPath();
			for ( var i = STROKE_INDEX; i < ContourArray.length; i++) {
				for ( var j = 0; j < ContourArray[i].length; j++) {
					if (j == 0)
						ctx.moveTo(ContourArray[i][0].x, ContourArray[i][0].y);
					else
						ctx.lineTo(ContourArray[i][j].x, ContourArray[i][j].y);
				}
				ctx.closePath();
				ctx.stroke();
				ctx.fill();
			}

			//已画笔划
			if (WriteArray.length > 0) {
				ctx.save();
				ctx.lineWidth = WRITE_LINE_WIDTH / 2;
				//                    ctx.globalAlpha = 0.8;
				ctx.beginPath();
				for ( var i = 0; i < STROKE_INDEX; i++) {
					for ( var j = 0; j < WriteArray[i].length; j++) {
						if (j == 0)
							ctx.moveTo(WriteArray[i][j].x, WriteArray[i][j].y);
						else
							ctx.lineTo(WriteArray[i][j].x, WriteArray[i][j].y);
					}
				}
				ctx.stroke();
				ctx.restore();
			}

			//当前笔划轨迹演示
			if (LocusArray.length > STROKE_INDEX
					&& typeof (LocusArray[STROKE_INDEX]) != "undefined") {

				//绘制当前笔划轮廓
				ctx.beginPath();
				for ( var j = 0; j < ContourArray[STROKE_INDEX].length; j++) {
					if (j == 0) {
						ctx
								.moveTo(ContourArray[STROKE_INDEX][j].x,
										ContourArray[STROKE_INDEX][j].y);
					} else {
						ctx
								.lineTo(ContourArray[STROKE_INDEX][j].x,
										ContourArray[STROKE_INDEX][j].y);
					}
				}
				ctx.fillStyle = "rgb(232,232,232)";
				ctx.fill();

				//演示轨迹
				ctx.strokeStyle = "rgb(84,85,104)";
				var withArrow = false;
				for ( var j = 0; j < LocusArray[STROKE_INDEX].length - 1; j++) {
					if (j == LocusArray[STROKE_INDEX].length - 2)
						withArrow = true;
					ctx.drawDashedLine(LocusArray[STROKE_INDEX][j].x,
							LocusArray[STROKE_INDEX][j].y, LocusArray[STROKE_INDEX][j + 1].x,
							LocusArray[STROKE_INDEX][j + 1].y, 3, withArrow);
				}

				//当前笔划书写
				if (WriteArray.length >= STROKE_INDEX
						&& typeof (WriteArray[STROKE_INDEX]) != "undefined") {
					ctx.save();
					ctx.lineWidth = WRITE_LINE_WIDTH / 2;
					ctx.strokeStyle = "rgb(100,53,14)";
					//                        ctx.globalAlpha = 0.8;
					ctx.beginPath();
					for ( var j = 0; j < WriteArray[STROKE_INDEX].length; j++) {
						if (j == 0)
							ctx
									.moveTo(WriteArray[STROKE_INDEX][j].x,
											WriteArray[STROKE_INDEX][j].y);
						else
							ctx
									.lineTo(WriteArray[STROKE_INDEX][j].x,
											WriteArray[STROKE_INDEX][j].y);
					}
					ctx.stroke();
					ctx.restore();
				}

				//演示笔图像
				if (STROKE_INDEX<LocusArray.length&&LocusArray[STROKE_INDEX].length>1) {
					var x = TEMP_POINT.x, y = TEMP_POINT.y;
					if (!IsYanshi && typeof (WriteArray[STROKE_INDEX]) != "undefined"
							&& WriteArray[STROKE_INDEX].length > 1) {
						x = WriteArray[STROKE_INDEX][WriteArray[STROKE_INDEX].length - 1].x;
						y = WriteArray[STROKE_INDEX][WriteArray[STROKE_INDEX].length - 1].y;
					}
					ctx.drawImage(ImagePencil, x, y - ImagePencil.height, ImagePencil.width,
							ImagePencil.height);
				}

			}

			break;

		}

	}

	var IsMouseDown = false;//用于非触屏设备的鼠标按下编辑
	var NextTargetIndex = 0;//目标点(用于move的时候记录是否偏移太大)
	var NextDistance = 0;
	var IsWriteWrong = false;
	function write(event) {
		if (MODE == Modes.kWrite) {

			//关闭演示定时器
			clearInterval(IntervalYanshi);
			IsYanshi = false;//关闭演示
			TEMP_POINT = LocusArray[STROKE_INDEX][0];//write模式下TEMP_POINT用于演示

			if (event.type == "mouseup" || event.type == "touchend" || event.type == "touchcancel") {
				//启动等待演示
				IntervalYanshi = setInterval(function() {
					IsYanshi = true;
					callObjc(CallObjcCMD.kYanshi);
				}, WRITE_YANSHI_RATE);

				IsMouseDown = false;
				if (LocusArray[STROKE_INDEX].length > 0) {
					switch (event.type) {
					case "mouseup":
					case "touchend":
					case "touchcancel":
						if (!IsWriteWrong) {
							var endPoint = LocusArray[STROKE_INDEX][LocusArray[STROKE_INDEX].length - 1];
							var writePoint = WriteArray[STROKE_INDEX][WriteArray[STROKE_INDEX].length - 1];
							if (Point.ccpDistance(writePoint, endPoint) < WRITE_ACCEPTED_DISTANCE) {//汉字当前笔划书写成功
								if (STROKE_INDEX < LocusArray.length - 1) {
									STROKE_INDEX++;
									TEMP_POINT = LocusArray[STROKE_INDEX][0];//write模式下TEMP_POINT用于演示
								} else {
									STROKE_INDEX++;//用于隐藏笔
									callObjc(CallObjcCMD.kWriteOk);
								}
							} else {
								WriteArray[STROKE_INDEX] = [];
							}
						} else {
							WriteArray[STROKE_INDEX] = [];
						}
						break;
					}
				}
			} else if (event.type == "mouseout") {
				//启动等待演示
				IntervalYanshi = setInterval(function() {
					IsYanshi = true;
					callObjc(CallObjcCMD.kYanshi);
				}, WRITE_YANSHI_RATE);
				//移出
				IsMouseDown = false;
			} else {
				var writePoint;
				if (event.type == "mousedown" || event.type == "mousemove") {
					writePoint = P(0, event.clientX - HANZI_CANVAS_OFFSETX, event.clientY
							- HANZI_CANVAS_OFFSETY);
				} else {
					writePoint = P(0, event.touches[0].clientX - HANZI_CANVAS_OFFSETX,
							event.touches[0].clientY - HANZI_CANVAS_OFFSETY);
				}
				switch (event.type) {
				case "mousedown":
				case "touchstart":
					IsMouseDown = true;
					var startPoint = LocusArray[STROKE_INDEX][0];
					if (Point.ccpDistance(writePoint, startPoint) < WRITE_ACCEPTED_DISTANCE) {
						WriteArray[STROKE_INDEX] = [];
						WriteArray[STROKE_INDEX].push(writePoint);
						IsWriteWrong = false;
						NextTargetIndex = 1;
						NextDistance = getNextDistance(writePoint, NextTargetIndex);
					} else {
						IsWriteWrong = true;
						return false;
					}
					break;
				case "mousemove":
				case "touchmove":
					event.preventDefault(); //阻止滚动
					if (IsMouseDown || event.type == "touchmove") {
						if (!IsWriteWrong)
							WriteArray[STROKE_INDEX].push(writePoint);
						else {
							var distance = Point.ccpDistance(writePoint,
									LocusArray[STROKE_INDEX][NextTargetIndex]);
							if (!IsWriteWrong && distance <= NextDistance) {
								if (distance < WRITE_ACCEPTED_DISTANCE) {
									if (NextTargetIndex < LocusArray[STROKE_INDEX].length - 1)
										NextTargetIndex++;
									NextDistance = getNextDistance(writePoint, NextTargetIndex);
								}
							} else {
								//console.log(" NextTargetIndex:"+NextTargetIndex+" distance:"+distance+" NextDistance:"+NextDistance);
								WriteArray[STROKE_INDEX] = [];
								IsWriteWrong = true;
							}
						}

					}
					break;
				}

			}
		} else {
			//更换模式
			setMode(Modes.kWrite);
			callObjc(CallObjcCMD.kChangeToWriteMode);//调用objecttive更换模式
		}
	}

	function getNextDistance(writePoint, NextTargetIndex) {
		var distance = Point.ccpDistance(writePoint, LocusArray[STROKE_INDEX][NextTargetIndex]);
		return distance > WRITE_ACCEPTED_DISTANCE ? distance + WRITE_ACCEPTED_DISTANCE
				: WRITE_ACCEPTED_DISTANCE;
	}

	function reWrite() {
		if (MODE == Modes.kWrite) {
			STROKE_INDEX = 0;
			WriteArray.length = 0;
			WriteArray = [];
			TEMP_POINT = P(0, 0, 0);
		}
	}

	function setMode(mode) {
		if (MODE == mode)
			return;
		MODE = mode;
		STROKE_INDEX = 0;
		LOCUS_INDEX = 0;
		TEMP_POINT = P(0, 0, 0);
		if (MODE == Modes.kWrite) {
			reWrite();
			//关闭演示定时器
			clearInterval(IntervalYanshi);
			//启动等待演示
			IntervalYanshi = setInterval(function() {
				IsYanshi = true;
				callObjc(CallObjcCMD.kYanshi);
			}, WRITE_YANSHI_RATE);
		} else {
			//关闭演示定时器
			clearInterval(IntervalYanshi);
			//重新启动绘制定时器
			clearInterval(IntervalDraw);
			clearInterval(IntervalStep);
			IntervalDraw = setInterval(draw, FRAME_RATE);
			IntervalStep = setInterval(step, FRAME_RATE);
		}
	}

	//貌似只支持小写
	function callObjc(cmd) {
		//var url = "callobjc:" + cmd;
		//document.location = url;
	}

	function elementLeft(e) {
		var offset = e.offsetLeft;
		if (e.offsetParent != null)
			offset += elementLeft(e.offsetParent);
		return offset;
	}
	function elementTop(e) {
		var offset = e.offsetTop;
		if (e.offsetParent != null)
			offset += elementTop(e.offsetParent);
		return offset;
	}
</script>
<style>
#btn {
	display: -webkit-box;
	display: -moz-box;
	width: 100%;
	margin: 0 auto;
	font-size: 20px;
}

#btn div {
	-webkit-border-radius: 5px;
	-moz-border-radius: 5px;
	border-radius: 5px;
	border: #999 2px solid;
	-webkit-box-sizing: border-box;
	-moz-box-sizing: border-box;
	padding: 15px;
	margin: 2.5%;
	-webkit-box-flex: 1;
	-moz-box-flex: 1;
	-webkit-box-ordinal-group: 2;
	-moz-box-ordinal-group: 2;
	text-align: center;
	cursor: pointer;
}
</style>
</head>
<body style="margin:2px 0px;">

	<canvas id="hanzi">请使用支持HTML5的设备(IE9+,Chrome,safari1.3+,firefox1.5+,Opera9+)</canvas>

	<div id="btn">
		<div id="yanshi">演示</div>
		<div id="rewrite">清除</div>
	</div>
</body>
</html>
