<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<% out.println("<h2 style='color:red'>");
/*
Standard error protocol
If key contraint is violated on UPDATE, use INSERT ON DUPLICATE KEY
If user enters a bad value (impossible value e.g. negative quantity) prevent DDL from being attempted
If user could benefit from being informed of their error, send them to error page after appropriately setting errno
session.setAttribute("errno", errno);


1=user not logged in and tried to access cart
2=user searched empty string *linked
3=user not logged in tried to enter credit card (via url)
4=user entered credit card they already had (optional redirect)
5=user entered bad quantity (<0) 
6=user entered bad row (<0 No update happens when row exceeds view size) 
7=user attempted to register an account with a duplicate username 
to add, quantity greater than stock
8=user attempted to add item to cart when seller doesn't exist or doesn't match
9=

*/


int errno= (int)session.getAttribute("errno");
out.println("Error number:"+errno+" ");
if(errno == 1){
	out.println("You need to login first before you access the cart"); %>
	<br></br>
	<a href="Login.html" style="font-size: 50px; text-decoration: none">Login</a> 
	<br></br>
<%
}else if(errno == 9|| errno==8){
	out.println("Bad quantity. Try entering a lower number");
	%> <br><% 
}else if(errno==10){
	out.println("Bad quantity. Try entering a positive");
	%> <br><% 
} %>
<a href="index.html" style="font-size: 50px; text-decoration: none">HOME PAGE</a>
</body>
</html>