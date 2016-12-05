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
<script type="text/javascript" src="http://static.fusioncharts.com/code/latest/themes/fusioncharts.theme.fint.js"></script>
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
<!-- Optional theme -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp" crossorigin="anonymous">
<!-- Latest compiled and minified JavaScript -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
<title>Query Results</title>
</head>
<body>
<h1>Results</h1>
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
<%
String q1 = "SELECT maj.Major_Group, avg(maj.Median_Annual_Wages) as Wages FROM Major maj GROUP BY maj.Major_Group ORDER BY avg(maj.Median_Annual_Wages) DESC";
Map<String, String> dataMap = getDataMap(con,q1,"Major_Group","Wages");
Gson gson = new Gson();

FusionCharts lineChart0 = new FusionCharts(
        "column2d",// chartType
        "ex1",// chartId
        "600","400",// chartWidth, chartHeight
        "chart2",// chartContainer
        "json",// dataFormat
        // dataSource
		gson.toJson(dataMap)
		);

%>
<%= lineChart0.render()%>
<% 
	String q2 = "SELECT DISTINCT maj.Major_Subgroup, maj.Median_Annual_Wages FROM Major maj WHERE maj.Major_Group in (SELECT m.Major_Group FROM Major m WHERE m.Major_Subgroup = \"" + major + "\")";
	
	Map<String, String> dataMap1 = getDataMap(con,q2,"Major_Subgroup","Median_Annual_Wages");
	FusionCharts lineChart1 = new FusionCharts(
	        "column2d",// chartType
	        "ex3",// chartId
	        "600","400",// chartWidth, chartHeight
	        "chart3",// chartContainer
	        "json",// dataFormat
	        // dataSource
			gson.toJson(dataMap1)
			);
%>
<%= lineChart1.render()%>


<%
String q3 = "SELECT occ.ST, ROUND(AVG(occ.A_MEAN),2) as StateWage FROM StateOccupations occ WHERE occ.OCC_CODE in (SELECT wor.SOC2010Code FROM WorksIn wor WHERE wor.CIP2010Code  LIKE CONCAT('%',(SELECT maj.CIPCode FROM Major maj WHERE maj.Major_Subgroup = \"" + major + "\" ORDER BY maj.CIPCODE ASC LIMIT 1),'%')) GROUP BY occ.ST ORDER BY AVG(occ.A_MEAN) DESC;";

Map<String, String> dataMap2 = getStateMap(con,q3,"ST","StateWage");
FusionCharts lineChart2 = new FusionCharts(
        "maps/usa",// chartType
        "ex4",// chartId
        "600","400",// chartWidth, chartHeight
        "chart4",// chartContainer
        "json",// dataFormat
        // dataSource
		gson.toJson(dataMap2)
		);

%>
<%= lineChart2.render()%>
<!-- Start table formatting -->
<div class="panel panel-default">

</div>
<div class="container-fluid">
	<div class="row">
		<div class="col-md-6">
			<h4>Median Annual Wages for Similar Majors</h4>
			<div id="chart3"></div>
		</div>
		<div class="col-md-6">
			<h4>Median Annual Wages for Major Groups</h4>
			<div id="chart2"></div>	
		</div>
	<div class="row">
		<div class="col-md-6">
			<h4>Average Annual Wages by State</h4>
			<div id="chart4"></div>	
		</div>
	</div>
</div>
</div>

<%
con.close();
%>
</div>
</body>
</html>