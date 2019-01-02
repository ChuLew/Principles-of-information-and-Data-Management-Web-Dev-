<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%@ page import="java.sql.*"%>
	<%@ page import="javax.sql.*"%>
	<%
	Cookie user= null;
	Cookie[] cookies = null;
	cookies = request.getCookies();
	String usern="";
	boolean userLoggedIn=false;
	if( cookies != null && cookies.length>1 ) {
		userLoggedIn=true;
	    for (int i = 0; i < cookies.length; i++) {
	    user = cookies[i];
	 		if((user.getName( )).compareTo("user") == 0 ) {
	 			usern=user.getValue();
	 			break;
	 		}
		}
	}
	if(!userLoggedIn){
		//session.setAttribute("errno", 3);
	}else{
	String credit=request.getParameter("cc"); 
	String csce=request.getParameter("csc"); 
	String expd=request.getParameter("exp");  
	String holda=request.getParameter("holder"); 

Class.forName("com.mysql.jdbc.Driver"); 
java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://mitchlewdbinstance.cgkdmmiwqxzv.us-east-2.rds.amazonaws.com/MitchLew",
"Chu_Lew","Mountainboy"); 
Statement st = con.createStatement();
ResultSet resultset = st.executeQuery("select * from Wallet where user='"+usern+"' and cc_num='"+credit+"';"); 
if(!resultset.next()){ //not in wallet yet
	Statement state3 = con.createStatement();
	ResultSet res3; 
	int q = state3.executeUpdate("insert into Credit_Card values('"+credit+"','"+csce+"','"+expd+"','"+holda+"') ON DUPLICATE KEY UPDATE cc_num=cc_num;");
	Statement state2 = con.createStatement();
	ResultSet res2;
	int k = state2.executeUpdate("insert into Wallet values('"+usern+"','"+credit+"')");
}// already in wallet
session.setAttribute("errno", 4);
}
%>
	<a href="index.html">home</a>
</body>
</html>