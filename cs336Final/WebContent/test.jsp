<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.fusioncharts.FusionCharts" %>
<%@ page import="com.google.gson.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<script type="text/javascript" src="FusionCharts/js/fusioncharts.js"></script>
	<script type="text/javascript" src="FusionCharts/jsfusioncharts.charts.js"></script>
	<script type="text/javascript" src="FusionCharts/js/themes/fusioncharts.theme.ocean.js"></script>
<title>TEST PAGE</title>
</head>
<body>
<%
	String url = "jdbc:mysql://masters.cqxrbwnqjcdx.us-east-1.rds.amazonaws.com:3306/innodb";
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection(url, "woleng", "analmaDB");
	Statement stmt = con.createStatement();
	
	String major = request.getParameter("Majors");
	String state = request.getParameter("States");
	out.println("Major: " + major);
	out.println("State: " + state);
	
	String query = "SELECT * FROM Majors";
	
	 Gson gson = new Gson();
	 PreparedStatement the_statement = con.prepareStatement(query);
	 ResultSet result = the_statement.executeQuery();
	 
	 Map<String, String> chart = new HashMap<String, String>();
     
     chart.put("caption", "The Majors");
     chart.put("showValues", "0");
     chart.put("theme", "zune");
     
     ArrayList data = new ArrayList();
     ArrayList linkeddata = new ArrayList();
     
     while(result.next()){
    	 out.println("TONY TAKE THE WHEEL");
     }
%>
</body>
</html>