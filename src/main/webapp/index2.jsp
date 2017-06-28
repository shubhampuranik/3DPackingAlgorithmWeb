<%-- 
    Document   : index2
    Created on : 27 Jun, 2017, 4:37:00 PM
    Author     : Shantanu
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="mylogic.Cuboid"%>
<%@page import="com.google.gson.reflect.TypeToken"%>
<%@page import="java.lang.reflect.Type"%>
<%@page import="com.google.gson.Gson"%>
<%String json=request.getAttribute("resp").toString();%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <!--<p><%=json%></p>-->
        <br>
        <table id="cuboids_table" border="1">
            <col width="60">
            <col width="60">
            <col width="60">
            <col width="60">
            <col width="60">
            <col width="60">
            <col width="60">
            <col width="60">
        </table>
        <br>
        <form action="NewServlet_2" method="post">
            <%
                Gson gson=new Gson();
                String json1=gson.toJson(json);
            %>
            <input type="hidden" name="resp" value='<%=json1%>'>
            <input type="submit" value="SUBMIT">
        </form>
        <script>
            var objects=<%=json%>
            var i=0;
            var table=document.getElementById("cuboids_table");
            var row=table.insertRow(0);
            row.insertCell(0).innerHTML="SR. NO.";
            row.insertCell(1).innerHTML="X";
            row.insertCell(2).innerHTML="Y";
            row.insertCell(3).innerHTML="Z";
            row.insertCell(4).innerHTML="LENGTH";
            row.insertCell(5).innerHTML="BREADTH";
            row.insertCell(6).innerHTML="HEIGHT";
            row.insertCell(7).innerHTML="WEIGHT";
            for(i=1;i<objects.length;i++){
                var cuboid=objects[i];
                console.log(cuboid);
                row=table.insertRow(i);
                row.insertCell(0).innerHTML=i;
                row.insertCell(1).innerHTML=cuboid.bottomLeftRear.x;
                row.insertCell(2).innerHTML=cuboid.bottomLeftRear.y;
                row.insertCell(3).innerHTML=cuboid.bottomLeftRear.z;
                row.insertCell(4).innerHTML=cuboid.length;
                row.insertCell(5).innerHTML=cuboid.breadth;
                row.insertCell(6).innerHTML=cuboid.height;
                row.insertCell(7).innerHTML=cuboid.weight;
            }
        </script>
    </body>
</html>
