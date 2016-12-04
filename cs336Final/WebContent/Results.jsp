<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="fusioncharts.FusionCharts" %>
<%@ page import="com.google.gson.*" %>
<%@ include file="dataMapFunction.jsp"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<script type="text/javascript" src="http://static.fusioncharts.com/code/latest/fusioncharts.js"></script>
<script type="text/javascript" src="http://static.fusioncharts.com/code/latest/fusioncharts.charts.js"></script>
<script type="text/javascript" src="http://static.fusioncharts.com/code/latest/themes/fusioncharts.theme.ocean.js"></script>
<title>Query Results</title>
</head>
<body>
<%
String url = "jdbc:mysql://masters.cqxrbwnqjcdx.us-east-1.rds.amazonaws.com:3306/innodb";
Class.forName("com.mysql.jdbc.Driver");
Connection con = DriverManager.getConnection(url, "woleng", "analmaDB");

String major = request.getParameter("Majors");
String state = request.getParameter("States");
//Use session to pass parameters between jsp pages
session.setAttribute("Major", major);
session.setAttribute("State", state);
//session.setAttribute("Connection", con);

%>

<!-- Start adding charts here -->
<div id="chart2"></div>
<%
String str = "SELECT maj.Major_Group, avg(maj.Median_Annual_Wages) as Wages FROM Major maj GROUP BY maj.Major_Group ORDER BY avg(maj.Median_Annual_Wages) DESC";
Map<String, String> dataMap = getDataMap(con,str,"Major_Group","Wages");
Gson gson = new Gson();

FusionCharts lineChart = new FusionCharts(
        "column2d",// chartType
        "ex1",// chartId
        "600","400",// chartWidth, chartHeight
        "chart2",// chartContainer
        "json",// dataFormat
        // dataSource
		gson.toJson(dataMap)
		);

%>
<%= lineChart.render()%>
<div id="chart3"></div>
<% 
	String q = "SELECT DISTINCT maj.Major_Subgroup, maj.Median_Annual_Wages FROM Major maj WHERE maj.Major_Group in (SELECT m.Major_Group FROM Major m WHERE m.Major_Subgroup = \"" + major + "\")";
	
	Map<String, String> dataMap1 = getDataMap(con,q,"Major_Subgroup","Median_Annual_Wages");
	FusionCharts nextChart = new FusionCharts(
	        "column2d",// chartType
	        "ex3",// chartId
	        "600","400",// chartWidth, chartHeight
	        "chart3",// chartContainer
	        "json",// dataFormat
	        // dataSource
			gson.toJson(dataMap1)
			);
	out.print(gson.toJson(dataMap1).toString());
%>
<%= nextChart.render()%>
<%
con.close();
%>
</body>
</html>