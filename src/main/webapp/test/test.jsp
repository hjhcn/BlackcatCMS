<%--
  ~ Copyright (c) 2014.
  ~ haojunhua
  --%>

<!DOCTYPE html>
<html>
<head>
<title>HTML5 Canvas Demo</title>
<!--[if IE]>
  <script type="text/javascript" src="excanvas.js"></script>
<![endif]-->
<script>
window.onload=function() {
  var mycanvas=document.getElementById("myCanvasTag");
  var mycontext=mycanvas.getContext('2d');

  //draw face
  mycontext.beginPath();
  mycontext.arc(300, 250, 200, 0, Math.PI * 2, true);
  mycontext.closePath();
  mycontext.stroke();

  //draw left eye
  mycontext.beginPath();
  mycontext.arc(220, 150, 30, 0, Math.PI * 2, true);
  mycontext.closePath();
  mycontext.fillStyle='rgb(100,100,225)';
  mycontext.fill();

  //draw left iris
  mycontext.beginPath();
  mycontext.arc(220, 150, 10, 0, Math.PI * 2, true);
  mycontext.closePath();
  mycontext.fillStyle='rgb(0,0,0)';
  mycontext.fill();

  //draw left eyelid
  mycontext.beginPath();
  mycontext.arc(220, 150, 30, 0, Math.PI, true);
  mycontext.closePath();
  mycontext.fillStyle='rgb(200,200,200)';
  mycontext.fill();

  //draw left eyelashes
  mycontext.strokeStyle='rgb(0,0,0)';
  lashes(mycontext,198, 170, 193, 185);
  lashes(mycontext,208, 177, 204, 193);
  lashes(mycontext,220, 180, 220, 195);
  lashes(mycontext,232, 177, 236, 193);
  lashes(mycontext,242, 170, 247, 185);
  mycontext.stroke();

  openeye();

  //draw right eyelashes
  mycontext.strokeStyle='rgb(0,0,0)';
  lashes(mycontext, 358, 170, 353, 185);
  lashes(mycontext, 368, 177, 364, 193);
  lashes(mycontext, 380, 180, 380, 195);
  lashes(mycontext, 392, 177, 396, 193);
  lashes(mycontext, 402, 170, 407, 185);
  mycontext.stroke();

  //draw nose
  mycontext.beginPath();
  mycontext.arc(300, 250, 20, 0, Math.PI * 2, true);
  mycontext.closePath();
  mycontext.stroke();

  // draw smile
  mycontext.beginPath();
  mycontext.lineWidth = 10;
  mycontext.moveTo(180, 320);
  mycontext.bezierCurveTo(140, 320, 340, 420, 400, 360);
  mycontext.closePath();
  mycontext.stroke();

  //draw message at bottom
  mycontext.font="1em sans-serif";
  mycontext.fillStyle="rgb(0,0,0)";
  mycontext.fillText("Move the mouse over and off the canvas - the face winks!", 10, 480);
}

function lashes(cntx,x1,y1,x2,y2) {
  cntx.moveTo(x1,y1);
  cntx.lineTo(x2,y2);
}

function closeeye() {
  //close right eye
  var mycanvas=document.getElementById("myCanvasTag");
  var mycontext=mycanvas.getContext('2d');
  mycontext.beginPath();
  mycontext.arc(380, 150, 30, 0, Math.PI * 2, true);
  mycontext.closePath();
  mycontext.fillStyle='rgb(200,200,200)';
  mycontext.fill();
}

function openeye() {
  //open right eye
  var mycanvas=document.getElementById("myCanvasTag");
  var mycontext=mycanvas.getContext('2d');
  mycontext.beginPath();
  mycontext.arc(380, 150, 30, 0, Math.PI * 2, true);
  mycontext.closePath();
  mycontext.fillStyle='rgb(100,100,225)';
  mycontext.fill();
  //draw right iris
  mycontext.beginPath();
  mycontext.arc(380, 150, 10, 0, Math.PI * 2, true);
  mycontext.closePath();
  mycontext.fillStyle='rgb(0,0,0)';
  mycontext.fill();
  //draw right eyelid
  mycontext.beginPath();
  mycontext.arc(380, 150, 30, 0, Math.PI, true);
  mycontext.closePath();
  mycontext.fillStyle='rgb(200,200,200)';
  mycontext.fill();
}
</script>
</head>
<body>
<div style="margin-left:30px;">
<canvas id="myCanvasTag" width="600" height="500" style="border: 5px blue solid"
   onmouseover="closeeye()" onmouseout="openeye()"></canvas>
<br /><br />
<a href="index.html">back</a>
</div>
</body>
</html>