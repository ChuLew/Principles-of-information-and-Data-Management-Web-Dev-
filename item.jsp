<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>

<style >
form { 
margin: 0 auto; 
width:600px;
}</style>
<head>
<meta charset="ISO-8859-1">
<title>Items</title>
</head>
<body>
<%@ page import="java.sql.*"%>
	<%@ page import="javax.sql.*"%>
	<%@ page import="java.util.LinkedList"%>
	<%@ page import="java.util.ListIterator"%>
	<%@ page import="java.awt.List"%>

<% String item = request.getParameter("item"); 
	session.setAttribute("item_id", item);
	String sql="Select S.name, S.seller_id, SB.price From Sellers S, Sold_By SB Where S.seller_id=SB.seller_id and SB.item_id='"+item+"';";
	Class.forName("com.mysql.jdbc.Driver");
	java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://mitchlewdbinstance.cgkdmmiwqxzv.us-east-2.rds.amazonaws.com/MitchLew", "Chu_Lew","Mountainboy");
	Statement st = con.createStatement();
	ResultSet rs = st.executeQuery(sql);
	
	sql="Select I.name From Items I Where I.item_id='"+item+"';";	
	Statement st2 = con.createStatement();
	ResultSet iName=st2.executeQuery(sql);
	iName.next();
	
%>
<h1 align="center" >Sellers for <%out.println(iName.getString("name"));%></h1>

<table style="width:80%">
  <tr>
    <th>Seller</th>
    <th>Seller number</th> 
    <th>Price</th>
  </tr>
  <% while(rs.next()){ %>
  <tr>
    <td align="center"><% out.println(rs.getString("name"));%></td>
    <td align="center"><% out.println(rs.getString("seller_id"));%></td> 
    <td align="center"><% out.println(rs.getString("price"));%></td>
  </tr> <% }%>
</table>

<% 
con.close();
Cookie[] cookies = null;
cookies = request.getCookies();
if( cookies == null || cookies.length==1 ){
	//user not logged in 
	
	%> 
	<a align="center" href="Login.html" style="font-size: 20px; text-decoration: none">Log in to add items to cart</a>
	<% 
}else{
%>
<br/> <p align="center"> <form class="example" action="cart.jsp" method = "post">
			<input type="text" placeholder= "seller" name="seller">
			<input type="text" placeholder= "quantity" name="quantity" size="10" maxlength="3">
			<button type="submit" onclick=<%session.setAttribute("cart mode","add");%>>
				<i class="fa fa-search"></i>
			</button>
</form>
</p>

<%
}
%>
</body>
</html>