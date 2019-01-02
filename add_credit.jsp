<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Add credit card</title>
</head>
<body>
<%
Cookie[] cookies = null;
cookies = request.getCookies();
if( cookies == null || cookies.length==1) {
	session.setAttribute("errno", 3);
}else{
	%> 
	<form action="credit.jsp" method="post">

		<br /> credit card number :<input type="text" name="cc" /><br />
		<br /> csc :<input type="text" name="csc" /><br />
		<br /> expiration date<input type="text" name="exp" /><br />
		<br /> Card holder:<input type="text" name="holder" /><br />
		<br /> <br />
		<br /> <input type="submit" />
	
	<%	
}
%>
</body>
</html>