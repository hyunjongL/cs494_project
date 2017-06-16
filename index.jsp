<%--
  Created by IntelliJ IDEA.
  User: hyunjong
  Date: 2017. 6. 1.
  Time: 오후 9:04
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import = "java.sql.*"%>
<%@ page import="java.util.concurrent.Future" %>

<%@ page import="net.spy.memcached.ArcusClient" %>
<%@ page import="net.spy.memcached.ConnectionFactoryBuilder" %>
<%@ page import="java.util.concurrent.TimeUnit" %>

<%
  Connection conn=null;
  Statement stmt=null;
  ResultSet rs=null;
  try{
    String url="jdbc:mysql://localhost:3306/db1";
    String id="mysql";
    String pw="mysql";
    Class.forName("com.mysql.jdbc.Driver");
    conn=DriverManager.getConnection(url,id,pw);
    System.out.println("hihi.");
    stmt=conn.createStatement();
    rs=stmt.executeQuery("select * from thoughts where writer in\n" +
            "  (select account2 from relationship where account1=\n" +
            "    (select account_num from profile where account='hj')\n" +
            "  and follows='true')\n" +
            "order by time desc limit 10");
    System.setProperty("net.spy.log.LoggerImpl", "net.spy.memcached.compat.log.Log4JLogger");
    ArcusClient ac=null;
    ac=ArcusClient.createArcusClient("localhost:2181","cloud",new ConnectionFactoryBuilder());
    Future<Boolean> future;
    boolean setSuccess = false;
    future=ac.set("test:hello",600,"Hello, Arcus!");
    try{
        setSuccess=future.get(700L, TimeUnit.MILLISECONDS);
    }catch (Exception e) {
      if (future != null) future.cancel(true);
      e.printStackTrace();
    }

    if(setSuccess){
        System.out.println("setSuccess=true");
    }else{
      System.out.println("setSuccess=false");
    }

    Future<Object> future2=null;
    future2=ac.asyncGet("test:hello");
    String result="Not OK.";
    try {
      result = (String)future2.get(700L, TimeUnit.MILLISECONDS);
    } catch (Exception e) {
      if (future2 != null) future2.cancel(false);
      e.printStackTrace();
    }
    System.out.println(result);


  }
catch(Exception e){
      System.out.println("error while connecting to the mysql server");
    e.printStackTrace();
  }
%>
<html>
  <head>
    <title>Tomcat Page</title>
  </head>
  <body>
  <%

  while(rs.next()){
      String acc=rs.getString("writer");
      String name=rs.getString("writing");
      //int accnum=rs.getInt("account_num");
  %>
  <tr height="25" align="center">
    <td>&nbsp;</td>
    <td><%=acc %></td>
    <td align="left"><%=name %></td>

    <td>&nbsp;</td>
  </tr>

  <%}%>
  </body>
</html>
