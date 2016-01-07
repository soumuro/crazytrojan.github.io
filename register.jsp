<%@ page session="false" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.regex.*" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.util.Random" %>
<html lang="en" class="no-js">
    <head>
        <meta charset="utf-8">
        <title>注册</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="">
        <meta name="author" content="">

        <!-- CSS -->
        <link rel="stylesheet" href="assets/css/reset.css">
        <link rel="stylesheet" href="assets/css/supersized.css">
        <link rel="stylesheet" href="assets/css/style.css">

        <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
        <!--[if lt IE 9]>
            <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
        <![endif]-->

    </head>

    <body>
        <div id="backtoindex"><a href="index.html"><img id="back" src="assets/img/left.png"/></a><a href="index.html" id="back2index"><h1>回到主页</h1></a></div>
        <div class="page-container">
            <h1>欢迎注册</h1><br/>
    <h2>
   <%

   String driver="com.mysql.jdbc.Driver";
   String url="jdbc:mysql://localhost:3306/tomcat"; // 连接到 school 数据库
   String userid="mysql账号"; // 用户
   String passwd="mysql密码"; // 密码

   try{
   String telephone= new String(request.getParameter("phone").getBytes("ISO-8859-1"),"UTF-8");
   Pattern pattern = Pattern.compile("^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$",Pattern.CASE_INSENSITIVE);
   Matcher matcher = pattern.matcher(telephone);
   boolean b=matcher.matches();


   if(b){

try {
Connection con=DriverManager.getConnection(url,userid,passwd);
//if(!con.isClosed())out.println(" 成功连接数据库 !<br/>");
String sql = "select * from accounts where telephone='"+telephone+"'";
Statement stmt = con.createStatement();
ResultSet rs = stmt.executeQuery(sql);
if(rs.next()){
    String telephone2=rs.getString("telephone");
    if(telephone2.equals(telephone)){
    b = false;
    out.println("<script>alert(\"该手机号码已被注册，请重新输入\");</script>");
    out.println("<script>location.replace(\"telephone.html \")</script>");
    }
}
stmt.close();
con.close();
}
catch(SQLException SQLe){}}

if(b){
   out.print("请查看手机号+86 <font color=\"blue\">"+telephone+"</font>收到的验证码");
   String httpUrl = "http://apis.baidu.com/baidu_communication/sms_verification_code/smsverifycode";
String httpArg = null;
Random r = new Random();
double randomNumber = r.nextDouble()*1000000;
String randomString = null;
if(randomNumber<100000) {randomString="0"+(int)randomNumber;}
else if(randomNumber>=100000){randomString=""+(int)randomNumber;}

httpArg  = "phone="+telephone+"&content="+randomString;

BufferedReader reader = null;
String result = null;
StringBuffer sbf = new StringBuffer();
httpUrl = httpUrl + "?" + httpArg;

try {
        URL url2 = new URL(httpUrl);
        HttpURLConnection connection = (HttpURLConnection) url2
                .openConnection();
        connection.setRequestMethod("GET");
        // 填入apikey到HTTP header
        connection.setRequestProperty("apikey",  "此处填入你的apikey");
        connection.connect();
        java.io.InputStream is = connection.getInputStream();
        reader = new BufferedReader(new InputStreamReader(is, "UTF-8"));
        String strRead = null;
        while ((strRead = reader.readLine()) != null) {
            sbf.append(strRead);
            sbf.append("\r\n");
        }
        reader.close();
        result = sbf.toString();
        //out.print(result);
    } catch (Exception e) {
        e.printStackTrace();
    }


try{Class.forName(driver);}
catch(Exception e){out.println(" 无法载入 "+driver+" 驱动程序 !");
e.printStackTrace();
}

try {
    Connection con=DriverManager.getConnection(url,userid,passwd);
//if(!con.isClosed())out.println(" 成功连接数据库 !<br/>");
    String sql = "insert accounts(telephone,captcha) values('"+telephone+"','"+randomString+"')";
    Statement stmt = con.createStatement();
    stmt.executeUpdate(sql);
    stmt.close();
    con.close();
   }
catch(SQLException SQLe){out.println(" 无法连接数据库 !");}

}
   else{
     out.println("<script>alert(\"请输入正确的手机号码！\");</script>");
    out.println("<script>location.replace(\"telephone.html \")</script>");}
      }
   catch(Exception e){
     out.println("抱歉！您没有提交手机号码。");
     out.println("<a href=\"telephone.html\">点击这里提交</a>");
 }
   %>
    </h2>
       <script>alert("注册须知\n1.所有数据均未采取加密措施，且站点已知存在sql注入漏洞风险，请您知晓，请勿填写您在其他网站常用的帐号与密码。\n2.站点仅作Java综设作品展示平台，请勿恶意攻击，感激不尽");</script>
            <form action="logup.jsp" method="post">
                <input type="text" name="captcha" class="username" placeholder="输入手机验证码"/>
                <input type="text" name="username" class="username" placeholder="用户名(4到10位汉字、字母、数字)"/>
                <input type="password" name="password" class="password" placeholder="请输入6—20位字母数字组合的密码"/>
                <button type="submit">提交</button>
                <div class="error"><span>+</span></div>
            </form>
            <p>已有账号？请登录&nbsp&nbsp&nbsp&nbsp<a href="login.html"><button id="register">马上登录</button></a></p>
        </div>

        <!-- Javascript -->
        <script src="assets/js/jquery-1.8.2.min.js"></script>
        <script src="assets/js/supersized.3.2.7.min.js"></script>
        <script src="assets/js/supersized-init.js"></script>
        <script src="assets/js/scripts.js"></script>

    </body>

</html>


