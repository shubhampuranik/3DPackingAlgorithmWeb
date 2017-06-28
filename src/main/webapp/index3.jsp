<%-- 
    Document   : index3
    Created on : Jun 28, 2017, 3:03:15 PM
    Author     : Shubham Puranik
--%>

<%@page import="com.google.gson.Gson"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%String json=request.getAttribute("resp").toString();
Gson gson=new Gson();
json=gson.fromJson(json,String.class);
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>3D HTML5 CANVAS</title>
        <script type="text/javascript">
            var output=<%=json%>;
            var blr;
            var bin;
            var cubes=[];
            function getRandomIntInclusive(min, max) {
                min = Math.ceil(min);
                max = Math.floor(max);
                return Math.floor(Math.random() * (max - min + 1)) + min; //The maximum is inclusive and the minimum is inclusive 
            }
            function color(r, g, b, a){
                this.r = r;
                this.g = g;
                this.b = b;
                this.a = a;
            }
            function point2D(x, y){
                this.x = x;
                this.y = y;
            }
            point2D.prototype.move = function(p2D){
                this.x += p2D.x;
                this.y += p2D.y;
            }
            function point3D(x, y, z){
                this.x = x;
                this.y = y;
                this.z = z;
            }
            point3D.prototype.move = function(p3D){
                this.x += p3D.x;
                this.y += p3D.y;
                this.z += p3D.z;
            }
            point3D.prototype.swap = function(p3D){
                this.x = p3D.x;
                this.y = p3D.y;
                this.z = p3D.z;
            }
            point3D.prototype.rotate = function(axis, angleGr){
                angleRad = angleGr * Math.PI / 180;
                switch (axis){
                    case "x":{
                        var tempPoint = new point3D(
                            this.x,
                            this.y * Math.cos(angleRad) - this.z * Math.sin(angleRad),
                            this.y * Math.sin(angleRad) + this.z * Math.cos(angleRad)
                        );
                        this.swap(tempPoint);
                        break;
                    } 
                    case "y":{
                        var tempPoint = new point3D(
                            this.x * Math.cos(angleRad) + this.z * Math.sin(angleRad),
                            this.y,
                            -this.x * Math.sin(angleRad) + this.z * Math.cos(angleRad)
                        );
                        this.swap(tempPoint);
                        break;
                    } 
                    case "z":{
                        var tempPoint = new point3D(
                            this.x * Math.cos(angleRad) - this.y * Math.sin(angleRad),
                            this.x * Math.sin(angleRad) + this.y * Math.cos(angleRad),
                            this.z
                        );
                        this.swap(tempPoint);
                        break;
                    } 
                }
            }
            function normal3D(p3D, length){
                this.point = p3D;
                this.length = length;
            }
            function poly(){
                var points = [];
                for(var i = 0; i < arguments.length; i++)
                    points.push(arguments[i]);
                this.points = points;
                // Calculating normal
                var v1 = new point3D(points[2].x - points[1].x, points[2].y - points[1].y, points[2].z - points[1].z);
                var v2 = new point3D(points[0].x - points[1].x, points[0].y - points[1].y, points[0].z - points[1].z);
                var normalP3D = new point3D(v1.y*v2.z-v2.y*v1.z, v1.z*v2.x-v2.z*v1.x, v1.x*v2.y-v2.x*v1.y);
                var normalLen = Math.sqrt(normalP3D.x*normalP3D.x + normalP3D.y*normalP3D.y + normalP3D.z*normalP3D.z);
                this.normal = new normal3D(normalP3D, normalLen);
            }
            poly.prototype.move = function(p3D){
                for(var i = 0; i < this.points.length; i++){
                    var point = this.points[i];
                    point.move(p3D);
                }
            }
            poly.prototype.rotate = function(axis, angle){
                for(var i = 0; i < this.points.length; i++){
                    var point = this.points[i];
                    point.rotate(axis, angle);
                }
                this.normal.point.rotate(axis, angle);
            }
            poly.prototype.put = function(center, fillColor, edgeColor){
                // Calulate visibility
                var normalAngleRad = Math.acos(this.normal.point.z/this.normal.length);
                if(normalAngleRad / Math.PI * 180 >= 90)
                  return;
                var lightIntensity = 1 - 2 * (normalAngleRad / Math.PI);
                ctx.fillStyle = 'rgba('+fillColor.r+','+fillColor.g+','+fillColor.b+','+(fillColor.a*lightIntensity)+')';
                ctx.beginPath();
                for(var i = 0; i < this.points.length; i++){
                    var point = this.points[i];
                    if(i)
                        ctx.lineTo(center.x + parseInt(point.x), center.y - parseInt(point.y));
                    else
                        ctx.moveTo(center.x + parseInt(point.x), center.y - parseInt(point.y));
                }
                ctx.fill();
                ctx.lineWidth = 2;
                ctx.strokeStyle = 'rgba('+edgeColor.r+','+edgeColor.g+','+edgeColor.b+','+(edgeColor.a*lightIntensity)+')';
                ctx.beginPath();
                var point = this.points[this.points.length-1];
                ctx.moveTo(center.x + parseInt(point.x), center.y - parseInt(point.y));
                for(var i = 0; i < this.points.length; i++){
                    var point = this.points[i];
                    ctx.lineTo(center.x + parseInt(point.x), center.y - parseInt(point.y));
                }
                ctx.stroke();
            }
            function Cube(size, fillColor, edgeColor){
                var p000 = new point3D(0,0,0);
                var p0S0 = new point3D(0,size,0);
                var pSS0 = new point3D(size,size,0);
                var pS00 = new point3D(size,0,0);
                var p00S = new point3D(0,0,size);
                var p0SS = new point3D(0,size,size);
                var pSSS = new point3D(size,size,size);
                var pS0S = new point3D(size,0,size);
                var polys = [];
                polys.push(new poly(p000,p0S0,pSS0,pS00));
                polys.push(new poly(pS00,pSS0,pSSS,pS0S));
                polys.push(new poly(pS0S,pSSS,p0SS,p00S));
                polys.push(new poly(p00S,p0SS,p0S0,p000));
                polys.push(new poly(p0S0,p0SS,pSSS,pSS0));
                polys.push(new poly(p00S,p000,pS00,pS0S));
                this.polys = polys;
                var points = [];
                points.push(p000);
                points.push(p0S0);
                points.push(pSS0);
                points.push(pS00);
                points.push(p00S);
                points.push(p0SS);
                points.push(pSSS);
                points.push(pS0S);
                for(var i = 0; i < polys.length; i++){
                  points.push(polys[i].normal.point);
                }
                this.points = points;
                this.fillColor = fillColor;
                this.edgeColor = edgeColor;
            }
        function Cuboid(blr, length, breadth, height, fillColor, edgeColor){
            var p000 = new point3D(blr.x,blr.y,blr.z);
            var p0S0 = new point3D(blr.x,blr.y+height,blr.z);
            var pSS0 = new point3D(blr.x+length,blr.y+height,blr.z);
            var pS00 = new point3D(blr.x+length,blr.y,blr.z);
            var p00S = new point3D(blr.x,blr.y,blr.z+breadth);
            var p0SS = new point3D(blr.x,blr.y+height,blr.z+breadth);
            var pSSS = new point3D(blr.x+length,blr.y+height,blr.z+breadth);
            var pS0S = new point3D(blr.x+length,blr.y,blr.z+breadth);
            var polys = [];
            polys.push(new poly(p000,p0S0,pSS0,pS00));
            polys.push(new poly(pS00,pSS0,pSSS,pS0S));
            polys.push(new poly(pS0S,pSSS,p0SS,p00S));
            polys.push(new poly(p00S,p0SS,p0S0,p000));
            polys.push(new poly(p0S0,p0SS,pSSS,pSS0));
            polys.push(new poly(p00S,p000,pS00,pS0S));
            this.polys = polys;
            var points = [];
            points.push(p000);
            points.push(p0S0);
            points.push(pSS0);
            points.push(pS00);
            points.push(p00S);
            points.push(p0SS);
            points.push(pSSS);
            points.push(pS0S);
            for(var i = 0; i < polys.length; i++){
              points.push(polys[i].normal.point);
            }
            this.points = points;
            this.fillColor = fillColor;
            this.edgeColor = edgeColor;
        }
        function move(o3D, p3D){    
            for(var i = 0; i < o3D.points.length - o3D.polys.length; i++){
                var point = o3D.points[i];
                point.move(p3D);
            }
        }
        function put(o3D, center){
            for(var i = 0; i < o3D.polys.length; i++){
                var poly = o3D.polys[i];
                poly.put(center, o3D.fillColor, o3D.edgeColor);
            }
        }
        function rotate(o3D, axis, angle){
            for(var i = 0; i < o3D.points.length; i++){
                var point = o3D.points[i];
                point.rotate(axis, angle);
            }
        }
        function init(){
            canvas = document.getElementById('3Dcube');
            if (canvas.getContext){
                ctx = canvas.getContext('2d');
                ctx.fillStyle = 'rgba(255, 255, 255, 1)';
                ctx.fillRect(0, 0, canvas.width, canvas.height); // clear canvas
                centerScreen = new point2D(canvas.width / 2, canvas.height / 2);
                bin=output[0];
                blr=new point3D(
                  this.x=bin.bottomLeftRear.x,
                  this.y=bin.bottomLeftRear.y,
                  this.z=bin.bottomLeftRear.z
                );
                cube = new Cuboid(blr,bin.length,bin.breadth,bin.height,new color(255,255,255,0), new color(0,0,0,1));
//                console.log(cube);
//                move(cube, new point3D(-50,-50,-50));
                rotate(cube, 'x', 45);
                rotate(cube, 'y', 45);
                rotate(cube, 'z', 45);
//                console.log(cube);
                cubes.push(cube);
                put(cube, centerScreen);
                
                for(var i=1;i<output.length;i++){
                    bin=output[i];
                    blr=new point3D(
                        this.x=bin.bottomLeftRear.x,
                        this.y=bin.bottomLeftRear.y,
                        this.z=bin.bottomLeftRear.z
                    );
                    cube = new Cuboid(blr,bin.length,bin.breadth,bin.height,
                            new color(getRandomIntInclusive(0,255),getRandomIntInclusive(0,255),getRandomIntInclusive(0,255),1),
//                            new color(255,0,0,1),
                            new color(0,0,0,1));
                    rotate(cube, 'x', 45);
                    rotate(cube, 'y', 45);
                    rotate(cube, 'z', 45);
//                    console.log(cube);
                    cubes.push(cube);
                    put(cube, centerScreen);
                }
                
//		var blr=new point3D(
//                    this.x=0,
//                    this.y=10,
//                    this.z=20
//                ); 
//		cube = new Cuboid(blr,10,20,30,new color(255,0,0,1), new color(0,0,0,1));
//                move(cube, new point3D(-50,-50,-50));
//                rotate(cube, 'x', 45);
//                rotate(cube, 'y', 45);
//                rotate(cube, 'z', 45);
//                centerScreen = new point2D(canvas.width / 2, canvas.height / 2);
//                put(cube, centerScreen);
//                blr=new point3D(
//                    this.x=0,
//                    this.y=30,
//                    this.z=30
//                ); 
//		cube = new Cuboid(blr,10,20,30,new color(0,255,0,1), new color(0,0,0,1));
//                move(cube, new point3D(-50,-50,-50));
//                rotate(cube, 'x', 45);
//                rotate(cube, 'y', 45);
//                rotate(cube, 'z', 45);
//                put(cube, centerScreen);
    //          timer = setInterval(nextFrame, 1000 / 60);
            }
        }
        function nextFrame(){
            ctx.fillStyle = 'rgba(255,255, 255, 1)';  
            ctx.fillRect(0, 0, canvas.width, canvas.height);  // clear canvas
            rotate(cube, 'x', 0.4);
            rotate(cube, 'y', 0.6);
            rotate(cube, 'z', 0.3);
            ctx.fillStyle = 'rgba(255, 255, 255, 1)';
            ctx.strokeStyle = 'rgba(0, 0, 0, 1)';
            put(cube, centerScreen);
        }
        function nextFrameL(){
            ctx.fillStyle = 'rgba(255,255, 255, 1)';  
            ctx.fillRect(0, 0, canvas.width, canvas.height);  // clear canvas
//             rotate(cube, 'x', 0.4);
//             rotate(cube, 'y', 0.6);
//             rotate(cube, 'z', 0.3);
            ctx.fillStyle = 'rgba(255, 255, 255, 1)';
            ctx.strokeStyle = 'rgba(0, 0, 0, 1)';
            for(var i=0;i<cubes.length;i++){
                rotate(cubes[i], 'y', 1);
                put(cubes[i], centerScreen);
            }
        }
        function nextFrameR(){
            ctx.fillStyle = 'rgba(255,255, 255, 1)';  
            ctx.fillRect(0, 0, canvas.width, canvas.height);  // clear canvas
//             rotate(cube, 'x', 0.4);
//             rotate(cube, 'z', 0.3);
            ctx.fillStyle = 'rgba(255, 255, 255, 1)';
            ctx.strokeStyle = 'rgba(0, 0, 0, 1)';
            for(var i=0;i<cubes.length;i++){
                rotate(cubes[i], 'y', -1);
                put(cubes[i], centerScreen);
            }
        }
        function nextFrameB(){
            ctx.fillStyle = 'rgba(255,255, 255, 1)';  
            ctx.fillRect(0, 0, canvas.width, canvas.height);  // clear canvas
//             rotate(cube, 'y', 0.6);
//             rotate(cube, 'z', 0.3);
            ctx.fillStyle = 'rgba(255, 255, 255, 1)';
            ctx.strokeStyle = 'rgba(0, 0, 0, 1)';
            for(var i=0;i<cubes.length;i++){
                rotate(cubes[i], 'x', -1);
                put(cubes[i], centerScreen);
            }
        }
        function nextFrameT(){
            ctx.fillStyle = 'rgba(255,255, 255, 1)';  
            ctx.fillRect(0, 0, canvas.width, canvas.height);  // clear canvas
//             rotate(cube, 'y', 0.6);
//             rotate(cube, 'z', 0.3);
            ctx.fillStyle = 'rgba(255, 255, 255, 1)';
            ctx.strokeStyle = 'rgba(0, 0, 0, 1)';
            for(var i=0;i<cubes.length;i++){
                rotate(cubes[i], 'x', 1);
                put(cubes[i], centerScreen);
            }
        }
        document.onkeydown = function myFunction() {
            switch (event.keyCode) {
                case 38:{
                    nextFrameT();
                    break;
                }
                case 40:{
                    nextFrameB();
                    break;
                }
                case 39:{
                    nextFrameR();
                    break;
                }
                case 37:{
                    nextFrameL();
                    break;
                }
            }
        }
        </script>
        <style type="text/css">
            canvas { border: 0px solid white; }
        </style>
    </head>
    <body onload="init();">
        <canvas id="3Dcube" width="1200" height="650"></canvas>
    </body>
</html>
