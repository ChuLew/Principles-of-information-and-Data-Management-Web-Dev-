<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<style>
.button {
    -webkit-transition-duration: 0.4s; /* Safari */
    transition-duration: 0.4s;
}

.button:hover {
    background-color: grey;
    color: white;
}
</style>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<title>Search</title>
</head>
<style></style>
<body>
	<%@ page import="java.sql.*"%>
	<%@ page import="javax.sql.*"%>
	<%@ page import="java.util.LinkedList"%>
	<%@ page import="java.util.ListIterator"%>
	<%@ page import="java.awt.List"%>
	<%
	String search = request.getParameter("search2");
	String []terms = search.split(" ");
	
	
	//no param
	if(search.equals("")||terms.length==0){
	session.setAttribute("errno", 2);
	String redirectURL = "error.jsp";
	response.sendRedirect(redirectURL);
	}else{
	
	//elim duplicates
	int lastWord=0;
	for(int i=0; i<terms.length; i++){
		if(terms[i]!="") {
			lastWord=i;
			for(int j=i+1; j<terms.length; j++){
				if(terms[i].equalsIgnoreCase(terms[j])){
				terms[j]="";
				}
			}		
		}
	}
	
	//build query
	String sql = "select distinct I.name, I.item_id from Items I, Keywords_Desc k where I.item_id = k.item_id and (k.word=";
	for(int i=0; i<terms.length; i++){
		if(!terms[i].equals("")){
			sql=sql+"'"+terms[i]+"'";	
			if(i!=terms.length-1) sql=sql+" or ";
		}
	}
	sql=sql+")";
	
	//get db results
	Class.forName("com.mysql.jdbc.Driver");
	java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://mitchlewdbinstance.cgkdmmiwqxzv.us-east-2.rds.amazonaws.com/MitchLew", "Chu_Lew","Mountainboy");
	Statement st = con.createStatement();
	ResultSet rs = st.executeQuery(sql);
	
	//generate results
	%>
	<ul>
	<% 
	while(rs.next()){
		%><li><%
		out.println(rs.getString("name"));
		out.println("Item number:"+rs.getString("item_id"));
		%>
		</li>
		<%
	}
	%>
	</ul> 
	<%
		con.close();
	}
	%>
	<form class="example" action="item.jsp" method = "post"
			style="max-width: 500px">
			<input type="text" placeholder="copy item number here..." name="item">
			<button type="submit">
				<i class="fa fa-search"></i>
			</button>
		</form>
	<a href="index.html" style="font-size: 50px; text-decoration: none">HOME PAGE</a>
</body>
</html>