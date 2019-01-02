<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>ShopMart</title>
</head>
<body>
	<%@ page import="java.sql.*"%>
	<%@ page import="javax.sql.*"%>
	<%
		String user = request.getParameter("userid");
		String pwd = request.getParameter("pwd");
		String fname = request.getParameter("fname");
		String addr = request.getParameter("addr");
		

		Class.forName("com.mysql.jdbc.Driver");
		java.sql.Connection con = DriverManager.getConnection(
				"jdbc:mysql://mitchlewdbinstance.cgkdmmiwqxzv.us-east-2.rds.amazonaws.com/MitchLew", "Chu_Lew",
				"Mountainboy");
		
		Statement userTest = con.createStatement();
		ResultSet rs=userTest.executeQuery("Select * From Account_Info Where username='"+user+"';");
		if(rs.next()){ //user already exists
			out.println("Username already exists");
			session.setAttribute("errno", 7);
		}else{
		
		Statement st = con.createStatement();
		int i = st.executeUpdate("insert into Account_Info values ('" + user + "','" + pwd + "','" + fname + "','"
				+ addr + "','" + pwd + "')");
		
		Statement st3= con.createStatement();
		st3.executeUpdate("CREATE OR REPLACE VIEW  `"+user+"_cart` AS SELECT `C`.`item_id` AS `item_id`,`C`.`seller_id` AS `seller_id`, `I`.`name` AS `item`, `S`.`name` AS `seller`, `C`.`quantity` AS `quantity`, `C`.`price` AS `price` FROM ((`Items` `I` JOIN `Sellers` `S`) JOIN `Carts` `C`) WHERE ((`I`.`item_id` = `C`.`item_id`) AND (`S`.`seller_id` = `C`.`seller_id`) AND (`C`.`username` = '"+user+"')) ORDER BY `C`.`item_id` , `C`.`seller_id` ASC;");
		out.println("YOU ARE NOW REGISTERED AT SHOPMART");
		}
	%>
	<a href="Login.html">Login</a>
	<br />
	<br />
	<a href="index.html">Home</a>
</body>
</html>