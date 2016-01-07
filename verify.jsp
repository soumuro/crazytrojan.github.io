<%@ page session="false" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.regex.*" %>

<HTML>
<head>
<meta charset="UTF-8">
<title>身份验证</title>
</head>
<BODY>
<%

String driver="com.mysql.jdbc.Driver";
String url="jdbc:mysql://localhost:3306/tomcat"; // 连接到 school 数据库

String userid="mysql账号"; // 用户
String passwd="mysql密码"; // 密码
try{
String username= new String(request.getParameter("username").getBytes("ISO-8859-1"),"UTF-8");
String password= new String(request.getParameter("password").getBytes("ISO-8859-1"),"UTF-8");

Pattern pattern = Pattern.compile("[\u4e00-\u9fa5a-zA-Z0-9]{3,10}",Pattern.CASE_INSENSITIVE);
Matcher matcher = pattern.matcher(username);
boolean b=matcher.matches();
//out.println(b);


try{
Class.forName(driver);
}
catch(Exception e){
out.println(" 无法载入 "+driver+" 驱动程序 !");
e.printStackTrace();
}


try {
if(b){
Connection con=DriverManager.getConnection(url,userid,passwd);
//if(!con.isClosed())out.println(" 成功连接数据库 !<br/>");
String sql = "select * from accounts where accounts='"+username+"'";
Statement stmt = con.createStatement();
ResultSet rs = stmt.executeQuery(sql);
if(rs.next()){
    String s2=rs.getString("password");
    String s3=rs.getString("telephone");
    if(s2.equals(password)){out.println("登录成功！<br/>"+username+"，欢迎您！");}
    else{
    out.println("<script>alert(\"账号或密码错误，请重新登录！\");</script>");
    out.println("<script>location.replace(\"login.html \")</script>");}
}
else{
     out.println("<script>alert(\"账号或密码错误，请重新登录！\");</script>");
    out.println("<script>location.replace(\"login.html \")</script>");}

stmt.close();
con.close();
}
else{
     out.println("<script>alert(\"账号或密码错误，请重新登录！\");</script>");
    out.println("<script>location.replace(\"login.html \")</script>");}
}
catch(SQLException SQLe){
out.println(" 无法连接数据库 !");
}

}
catch(Exception e){
out.println("<script>location.replace(\"login.html \")</script>");
}

%>
</BODY>
</HTML>
