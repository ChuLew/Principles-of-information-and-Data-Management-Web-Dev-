<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
   <head>
      <title>Logout Page</title>
   </head>
   <style>
   body {
	background-image: url(" https://s8.postimg.cc/sjdn3hepx/2_BB24_DDA-_D501-4_C16-_B9_B5-_F5_F27800_C1_BE.gif")
}</style>
 
   <body>
      <center>
         <h1>Logout Page</h1>
      </center>
      <%
         Cookie cookie = null;
         Cookie[] cookies = null;
         
         // Get an array of Cookies associated with the this domain
         cookies = request.getCookies();
       	boolean deleted=false; //flag flip upon successful match of cookies
       	String username="";
        if( cookies != null && cookies.length>1 ) {
   	       for (int i = 0; i < cookies.length; i++) {
   	    	   cookie = cookies[i];
        		if((cookie.getName( )).compareTo("user") == 0 ) {
        			deleted=true;
        			username=cookie.getValue();
               	}
        		cookie.setMaxAge(0);
              	response.addCookie(cookie);
 	       }
         }else{
            out.println(
            "<h2>NO USER LOGGED IN</h2>");
         }
       if(deleted){
       		out.print("<b>Logged out User:</> " + 
            username + "<br/>");
       	}
      %>
      <a href="index.html" style="font-size: 100px; text-decoration: none">HOME PAGE</a>
   </body>
</html>