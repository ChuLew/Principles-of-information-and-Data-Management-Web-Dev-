<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>ShopMart Login</title>
</head>
<style>
	body {
	background-image: url("https://s8.postimg.cc/ccko9di39/heart.jpg")
}
a:link {
    color: blue;
    text-decoration: none;
}
a:visited {
    color: orange;
    text-decoration: none;
}
a:hover {
    color: yellow;
    background-color: transparent;
    text-decoration: underline;
}
a:active {
    color: purple;
    background-color: transparent;
    text-decoration: underline;
}
</style>
<body>
	<%@ page import="java.sql.*"%>
	<%@ page import="javax.sql.*"%>
	<%
		String userid = request.getParameter("usr");
		String pwd = request.getParameter("pwd");
		Class.forName("com.mysql.jdbc.Driver");
		java.sql.Connection con = DriverManager.getConnection(
				"jdbc:mysql://mitchlewdbinstance.cgkdmmiwqxzv.us-east-2.rds.amazonaws.com/MitchLew", "Chu_Lew",
				"Mountainboy");
		Statement st = con.createStatement();
		ResultSet rs = st.executeQuery("select * from Account_Info where username='" + userid + "'");
		if (rs.next()) {
			if (rs.getString(2).equals(pwd)) {
				out.println("You have successfully logged in " + userid);
				Cookie username = new Cookie("user",userid);
				Cookie password = new Cookie("password",pwd);
				username.setMaxAge(60*60);
				password.setMaxAge(60*60);
				response.addCookie(username);
				response.addCookie(password);
			} else {
				response.sendRedirect("invalidLogin.html");
			}
		} else{
			response.sendRedirect("invalidLogin.html");
		}
	
		session.setAttribute("cart mode","view");
	%>
	
	<tr>
	<br></br>
	<td><img src="images/kiss.gif"/></td>
	</tr>
	<br></br>
	<br></br>
	<a href="index.html">home</a>
	<br></br>
	<a href="add_credit.jsp">add credit card information</a>
</body>
</html>