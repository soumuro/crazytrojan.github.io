<%@ page session="false" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.regex.*" %>

<HTML>
<head>
<meta charset="UTF-8">
<title>短信验证</title>
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
String captcha= new String(request.getParameter("captcha").getBytes("ISO-8859-1"),"UTF-8");

Pattern pattern1 = Pattern.compile("[\u4e00-\u9fa5a-zA-Z0-9]{3,10}",Pattern.CASE_INSENSITIVE);
Matcher matcher1 = pattern1.matcher(username);
Pattern pattern2 = Pattern.compile("[a-zA-Z0-9]{6,20}",Pattern.CASE_INSENSITIVE);
Matcher matcher2 = pattern2.matcher(password);
Pattern pattern3 = Pattern.compile("[0-9]{3,6}",Pattern.CASE_INSENSITIVE);
Matcher matcher3 = pattern3.matcher(captcha);
boolean b=matcher1.matches();
boolean a=matcher2.matches();
boolean c=matcher3.matches();
if(c)out.print("验证码正确<br/>");else out.print("验证码出错<br/>");
if(b)out.print("账号格式正确<br/>");else out.print("账号格式错误<br/>");
if(a)out.print("密码格式正确<br/>");else out.print("密码格式错误<br/>");


try{
Class.forName(driver);
}
catch(Exception e){
out.println(" 无法载入 "+driver+" 驱动程序 !");
e.printStackTrace();
}


try {
if(a&b&c){
Connection con=DriverManager.getConnection(url,userid,passwd);
String sql = "select * from accounts where captcha='"+captcha+"'";
Statement stmt = con.createStatement();
ResultSet rs = stmt.executeQuery(sql);
if(rs.next()){
    String captcha1=rs.getString("captcha");
    if(captcha1.equals(captcha)){
    String sql2 = "update accounts set accounts='"+username+"',password='"+password+"',captcha='NULL' where captcha='"+captcha+"'";
    stmt.executeUpdate(sql2);
    out.println("<script>alert(\"注册成功！请登录！\");</script>");
    out.println("<script>location.replace(\"login.html \")</script>");
    }
    else{
    out.println("<script>alert(\"验证码错误，请重新填写！\");</script>");
    out.println("<script>location.replace(\"register.jsp \")</script>");}
}
else{
     out.println("<script>alert(\"验证码错误，请重新填写！\");</script>");
    out.println("<script>location.replace(\"register.jsp \")</script>");}

stmt.close();
con.close();
}
else{
     out.println("<script>alert(\"请输入满足条件的验证码、账号与密码！\");</script>");
    out.println("<script>location.replace(\"register.jsp \")</script>");}
}
catch(SQLException SQLe){out.println(" 无法连接数据库 !");}

}
catch(Exception e){
out.println("<script>location.replace(\"register.jsp \")</script>");
}
%>
</BODY>
</HTML>
