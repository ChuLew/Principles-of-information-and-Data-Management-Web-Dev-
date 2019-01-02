<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>

<html>
<head>
<meta charset="UTF-8">
<title>Cart</title>
</head>
<body>
<%@ page import="java.sql.*"%>
	<%@ page import="javax.sql.*"%>
	<%
  	
   //get user
	Cookie user= null;
	Cookie[] cookies = null;
	cookies = request.getCookies();
	boolean userlogin = false;
	String username="";
	if( cookies != null && cookies.length>1 ) {
	       for (int i = 0; i < cookies.length; i++) {
	    	   user = cookies[i];
     		if((user.getName( )).compareTo("user") == 0 ) {
     			username=user.getValue();
     			userlogin = true;
     			break;
     		}
	       }
	}
	if(userlogin == true){
	//determine request 
	int qt=0;
	int row=0;
	boolean validSeller=true;
	String cartFlag=(String)session.getAttribute("cart mode"); 
	if(cartFlag.equals("add")){
	
	
	//parse seller and quantity
	String seller=request.getParameter("seller");
	String quantity=request.getParameter("quantity");
	qt=Integer.parseInt(request.getParameter("quantity"));
	
	
	//calculate price
	String sql="Select SB.price, SB.stock From Sold_By SB Where SB.item_id='"+session.getAttribute("item_id")+"'and SB.seller_id='"+seller+"';";	
	Class.forName("com.mysql.jdbc.Driver");
	java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://mitchlewdbinstance.cgkdmmiwqxzv.us-east-2.rds.amazonaws.com/MitchLew", "Chu_Lew","Mountainboy");
	Statement st = con.createStatement();
	ResultSet priceRes=st.executeQuery(sql);
	
	if(priceRes.next()){
	
	if( qt>Integer.parseInt(priceRes.getString("stock"))){
		//too large of quantity
		session.setAttribute("errno", 9);
		response.sendRedirect("error.jsp");
	}
	if(qt<0){
		session.setAttribute("errno", 10);
		response.sendRedirect("error.jsp");
	}
	double price=Double.parseDouble(priceRes.getString("price"));
	

	//create query
	sql = "insert into Carts(username, cc_num, seller_id, item_id, quantity,price,cart_num) values ('"+username+"', null, '"+seller+"','"+ session.getAttribute("item_id") + "', "+quantity+" ,"+price+", null) ON DUPLICATE KEY UPDATE QUANTITY=QUANTITY+"+quantity+";";

	//insert into db
	Statement st2= con.createStatement();
	st2.executeUpdate(sql);
	Statement st3= con.createStatement();
	st3.executeUpdate("CREATE OR REPLACE VIEW  `"+username+"_cart` AS SELECT `C`.`item_id` AS `item_id`,`C`.`seller_id` AS `seller_id`, `I`.`name` AS `item`, `S`.`name` AS `seller`, `C`.`quantity` AS `quantity`, `C`.`price` AS `price` FROM ((`Items` `I` JOIN `Sellers` `S`) JOIN `Carts` `C`) WHERE ((`I`.`item_id` = `C`.`item_id`) AND (`S`.`seller_id` = `C`.`seller_id`) AND (`C`.`username` = '"+username+"')) ORDER BY `C`.`item_id` , `C`.`seller_id` ASC;");
	//end case:add to cart 
	}else{ //sellerid does not match
		validSeller=false;
	}
%> 
<h2>Success!</h2> <% 

}else if(cartFlag.equals("update")){//case:updated quantity
	qt=Integer.parseInt(request.getParameter("quantity"));
	row=Integer.parseInt(request.getParameter("row"))-1;
	
	
	Class.forName("com.mysql.jdbc.Driver");
	java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://mitchlewdbinstance.cgkdmmiwqxzv.us-east-2.rds.amazonaws.com/MitchLew", "Chu_Lew","Mountainboy");
	Statement st = con.createStatement(ResultSet.TYPE_FORWARD_ONLY,ResultSet.CONCUR_UPDATABLE);
	
	
	if(qt>0 && row>=0){
	st.executeUpdate("UPDATE Carts C inner join (Select C2.username, C2.item_id, C2.seller_id From Carts C2 Where C2.username='"+username+"' ORDER BY C2.item_id, C2.seller_id LIMIT 1 OFFSET "+row+") as QI on (C.username=QI.username and C.item_id=QI.item_id and C.seller_id=QI.seller_id) SET quantity= '"+qt+"' Where C.username ='"+username+"';");
	}else if(qt==0 &&row>=0){
	ResultSet rs = st.executeQuery("SELECT C.username, C.item_id, C.seller_id FROM Carts C WHERE C.username = '"+username+"' ORDER BY C.item_id , C.seller_id;");
	
	rs.absolute(row+1);
	rs.deleteRow();
	
	}
}
if(qt >=0 &&row>=0){
%>
<br/>
<h2>Your cart:</h2>
<table style="width:80%">
<tr><th>row<th>item</th><th>seller</th><th>quantity</th><th>price</th> </tr>

<% 

if(validSeller){
Class.forName("com.mysql.jdbc.Driver");
java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://mitchlewdbinstance.cgkdmmiwqxzv.us-east-2.rds.amazonaws.com/MitchLew", "Chu_Lew","Mountainboy");
Statement st = con.createStatement();
ResultSet rs=st.executeQuery("SELECT C.item, C.seller, C.quantity, C.price From ( SELECT * From "+username+"_cart C1 ORDER BY C1.item_id, C1.seller_id )as C ;");
int count =1;

while(rs.next()){%> 
<tr> 
<td align="center"> <% out.println(count); %> </td>
<td align="center"><%out.println(rs.getString("item"));%></td> 
<td align="center"><%out.println(rs.getString("seller"));%></td> 
<td align="center"> <%out.println(rs.getString("quantity"));%></td>
<td><%out.println(rs.getString("price"));%></td> 
</tr>
<%count++;
}
con.close();
%>
</table>
<p> Update quantity: 
<form  action="cart.jsp">
  <input type="text" placeholder="row number" name="row" size="10" maxlength="3">
  <input type="text" placeholder="quantity" name="quantity" size="10" maxlength="3">
  <input type="submit" value="update" 
  onclick=<%session.setAttribute("cart mode","update");%>
  >
</form>
</p>


<%
	}else{
		if(qt<0) {session.setAttribute("errno", 5);}
		else{ session.setAttribute("errno", 6);}
	} 
}else{
	session.setAttribute("errno", 8);
	session.setAttribute("cart mode","view");
}
}
	else{
		//user not logged in. Future feature to log in here(?) Error handle  
		session.setAttribute("errno", 1);
		response.sendRedirect("error.jsp");
	}
 %> 
<form action="index.jsp">
	<input type="submit" id="home" name="home" value="Return Home"/>
</form>
</body>
</html>
