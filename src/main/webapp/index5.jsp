<%-- 
    Document   : index5
    Created on : Jun 28, 2017, 3:19:00 PM
    Author     : LG-2
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
        <h1><%=request.getAttribute("name")%></h1>
    </body>
</html>
