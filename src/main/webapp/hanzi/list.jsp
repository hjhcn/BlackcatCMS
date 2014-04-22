<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%--
  ~ Copyright (c) 2014.
  ~ haojunhua
  --%>

<s:include value="/common/head.jsp" />
<script type="text/javascript">
	var Page = 1;
	var AllPageCount = <s:property escape="false" value="hanzis.totalpage" />;
	var Lock = false;
	var Zi;
	$(function() {

		bindEvent();

		/*
		$(window).scroll(function() {
			//$("#scrollInfo").html(
			//		$(document).scrollTop() + "+" + $(window).height() + ":"
			//				+ $(document).height());
			if (!Lock) {
				if ($(document).scrollTop() + $(window).height() >= $(document).height() - 100) {
					Lock = true;
					if (Page < AllPageCount) {
						$("#loading").show();
						$.getJSON("json/hanzi_list_hanzis", {
							"page" : ++Page
						}, function(data) {
							AllPageCount = data.hanzis.totalpage;
							var html = "";
							jQuery.each(data.hanzis.rows, function(index, hanzi) {
								html += "<li>" + hanzi.zi + "</li>";
							});
							$("#hanzi-list ul").append(html);
							bindEvent();
							Lock = false;
						});
						if (Page == AllPageCount) {
							$("#loading").hide();
						}
					} else {
						$("#loading").hide();
					}
				}
			}

			$("#loading").css("width", 50);
			$("#loading").css("height", 50);
			if (window.devicePixelRatio > 1) {
				$("#loading").attr("width", 50 * window.devicePixelRatio);
				$("#loading").attr("height", 50 * window.devicePixelRatio);
			}

		});
		 */

		function bindEvent() {
			$("#hanzi-list li").bind({
				"touchstart" : function() {
					$(this).addClass("touched");
					Zi = $(this).html();
				},
				"touchmove" : function() {
					$(this).removeClass("touched");
					Zi = "";
				},
				"touchend" : function() {
					$(this).removeClass("touched");
					if (Zi == $(this).html()) {
						location.href = "hanzi_hanzi?zi=" + Zi;
					}
				},
				"touchcancel" : function() {
					$(this).removeClass("touched");
				}
			});
		}
	});
</script>
<div id="hanzi-banner">
	<div id="logo">
		<img src="css/images/yidilogo.png" />
	</div>
	<div id="download">
		易迪汉字乐园
		<!-- <img src="css/images/box_download.png" /> -->
	</div>
</div>

<div id="hanzi-list">
	<ul>
		<s:iterator value="hanzis.records" id="hanzi">
			<li><s:property escape="false" value="#hanzi.zi" /></li>
		</s:iterator>
	</ul>
</div>
<div class="clear"></div>


<div id="scrollInfo" style="position: fixed;right: 0px; bottom: 0px;"></div>

<div
	style="font-size: 14px;padding: 5px;background-color: #EEE;border-bottom:1px dashed #ccc;color:#999;">易迪汉字乐园第一版开放基础100字，后续将逐步开放。同时易迪乐园汉字客户端即将上线，功能更强大，内容更有趣，敬请关注。</div>

<s:include value="/common/foot.jsp" />