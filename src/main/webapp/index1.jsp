<%-- 
    Document   : index1
    Created on : 23 Jun, 2017, 12:33:31 PM
    Author     : Shantanu
--%>

<%@page import="java.sql.DriverManager"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
Class.forName("org.postgresql.Driver");
Connection connection = DriverManager.getConnection("jdbc:postgresql://localhost:5433/test","postgres", "lguru");
//Connection connection = DriverManager.getConnection("jdbc:postgresql://localhost:5432/test","postgres", "12345678");
//Connection connection = DriverManager.getConnection("jdbc:postgresql://202.189.238.95:5432/Test","postgres", "12345678");
Statement statement=connection.createStatement();
ResultSet resultSet=statement.executeQuery("select name from \"items\" /*order by \"id\" ASC*/");
ArrayList<String> itemList=new ArrayList<>();
while(resultSet.next())
    itemList.add(resultSet.getString(1));
resultSet=statement.executeQuery("select name from \"vehicles\" /*order by \"id\" ASC*/");
ArrayList<String> vehicleList=new ArrayList<>();
while(resultSet.next())
    vehicleList.add(resultSet.getString(1));
%>


<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <form name="item_details">
            <div>SELECT VEHICLE:- <select name="vehicleName" required >
                                    <option selected disabled hidden>Choose Vehicle</option>
                                    <%for(String vehicleName:vehicleList){%>
                                        <option><%=vehicleName%></option>
                                    <%}%>
                </select>
            </div>
                <br/>
            <span>ORDER ID:- </span><span id="order_id"></span>
            SELECT ORDER ITEM:- <select name="itemName" required >
                                    <option selected disabled hidden>Choose Item</option>
                                    <%for(String itemName:itemList){%>
                                        <option><%=itemName%></option>
                                    <%}%>
            </select>
            ENTER ITEM QUANTITY:- <input type="number" min="1" max="1000" name="itemQuantity" required>
            <input type="button" value="Next Order" onclick="incrementOrderID()"/>
            <input type="button" value="Add" onclick="add(item_details)"/>
        </form>
        <br>
        <table id="item_table" border="1" >
        </table>
        <br>
        <input type="button" value="Create JSON" onclick="showJSON()"/>
        <br>
        <div id="form2"></div>
        <script>
            var table = document.getElementById("item_table");
            var i=0,counter=1;
            document.getElementById("order_id").innerHTML=counter;
            var row=table.insertRow(i);
            row.insertCell(0).innerHTML="ORDER ID";
            row.insertCell(1).innerHTML="ITEM NAME";
            row.insertCell(2).innerHTML="ITEM QUANTITY";
            var jsonListArr=[];
            var jsonString;
            var finalJSON;
            function add(form){
//                alert(form.order_id.value+' '+form.item_name.value+' '+form.item_quantity.value);
                i++;
                row=table.insertRow(i);
                row.insertCell(0).innerHTML=counter;
                row.insertCell(1).innerHTML=form.itemName.value;
                row.insertCell(2).innerHTML=form.itemQuantity.value;
                jsonListArr.push({
                    "orderId":counter,
                    "itemName":form.itemName.value,
                    "itemQuantity":form.itemQuantity.value
                });
                //jsonString=JSON.stringify(jsonListArr);
                //alert(form.vehicleName.value);
                //alert(jsonString);
                finalJSON=new function(){
                    this.vehicleName=form.vehicleName.value;
                    this.orders=jsonListArr;
                };
                //finalJSON.vehicleName=form.vehicleName.value;
                //finalJSON.orders=jsonString;
                //alert(JSON.stringify(finalJSON));
            }
            function incrementOrderID(){
                counter=counter+1;
                document.getElementById("order_id").innerHTML=counter;
            }
            function showJSON(){
                alert(JSON.stringify(finalJSON));
                document.getElementById("form2").innerHTML="<br>\n\
            <form name=\"pack_form\" method=\"post\" action=\"NewServlet_1\">\n\
                <input type=\"hidden\" name=\"json_data\" value='"+JSON.stringify(finalJSON)+"'>\n\
                <input type=\"submit\" value=\"Pack\"/>\n\
            </form>";
            }
        </script>
    </body>
</html>
