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
        "bar2d",// chartType
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
<% 
String q4 = "SELECT maj.Graduate_Degree_Attainment, maj.Median_Annual_Wages, maj.Graduate_Degree_Wage_Premium FROM Major maj where Major_Subgroup = \"" + major + "\"";
Statement stmt = con.createStatement();
PreparedStatement the_statement = con.prepareStatement(q4);
ResultSet rs1 = the_statement.executeQuery();
rs1.next();
%>

<%
String q5 = "SELECT count(distinct m1.Major_Group) as Rank FROM (SELECT maj.Major_Group, avg(maj.Median_Annual_Wages) as Average_Annual_Wages FROM Major maj GROUP BY maj.Major_Group ORDER BY avg(maj.Median_Annual_Wages) DESC) m1, Major m2 WHERE m2.Major_Subgroup = \""+major+"\" and m1.Average_Annual_Wages >= m2.Median_Annual_Wages;";
the_statement.clearBatch();
the_statement = con.prepareStatement(q5);
ResultSet rs2 = the_statement.executeQuery();
rs2.next();
%>

<%
String q6 = "SELECT Major_Group FROM Major where Major_Subgroup = \"" + major + "\"";
the_statement.clearBatch();
the_statement = con.prepareStatement(q6);
ResultSet rs3 = the_statement.executeQuery();
rs3.next();
%>

<%
String q7 = "SELECT Round(avg(NULLIF(a.UgradTut,0)),2) as InStateU, Round(avg(NULLIF(b.UgradTut,0)),2) as OutStateU from (SELECT UNITID, INSTNM, STABBR, InStateUgradTut as UgradTut FROM innodb.College where STABBR = '" + state + "') a, (SELECT UNITID, INSTNM, STABBR, OutStateUgradTut as UgradTut FROM innodb.College where STABBR <> '" + state +  "')b;";
the_statement.clearBatch();
the_statement = con.prepareStatement(q7);
ResultSet rs4 = the_statement.executeQuery();
rs4.next();
%>

<%
String q8 = "SELECT Round(MEDIAN_ANNUAL_WAGES,2) as UgradWages, Round((MEDIAN_ANNUAL_WAGES * (1+(GRADUATE_DEGREE_WAGE_PREMIUM/100))),2) as GradWages from innodb.Majors where MAJOR_SUBGROUP = '" + major + "';";
the_statement.clearBatch();
the_statement = con.prepareStatement(q8);
ResultSet rs5 = the_statement.executeQuery();
rs5.next();
double UgradWages = rs5.getDouble("UgradWages");
double GradWages = rs5.getDouble("GradWages");
%>

<%
String q9 = "SELECT Round(avg(NULLIF(a.GradTut,0)),2) as InStateG, Round(avg(NULLIF(b.GradTut,0)),2) as OutStateG from  (SELECT UNITID, INSTNM, STABBR, InStateGradTut as GradTut FROM innodb.College where STABBR = '" + state + "') a, (SELECT UNITID, INSTNM, STABBR, OutStateGradTut as GradTut FROM innodb.College where STABBR <> '" + state +  "')b;";
the_statement.clearBatch();
the_statement = con.prepareStatement(q9);
ResultSet rs6 = the_statement.executeQuery();
rs6.next();
%>

<!-- Start text formatting -->

<!-- Section For Major Information -->
<div class="panel panel-default">
<div class="container-fluid" style="text-align:center">
	<div class="row">
		<div class="col-md-12">
			<h2 style="text-align:center">Facts about my major: <%=major %></h2>
			<hr>
		</div>
	</div>
	<div class="row">
		<div class="col-md-4">
			<h4>Percentage of People with Graduate Degrees: <%=rs1.getString("Graduate_Degree_Attainment") %>%</h4>
		</div>
		<div class="col-md-4">
			<h4>Median Annual Wages: $<%=rs1.getString("Median_Annual_Wages") %></h4>
		</div>
		<div class="col-md-4">
			<h4>Graduate Wage Premium: <%=rs1.getString("Graduate_Degree_Wage_Premium") %>%</h4>
		</div>
	</div>
	<div class="row">
		<div class="col-md-6">
			<h4>Your Major falls under the Major Group: <%=rs3.getString("Major_Group") %></h4>
		</div>
		<div class="col-md-6">
			<h4>Out of the 14 Major Groups, your Major Group Ranks <b><%=rs2.getString("Rank")%></b> for highest Average Annual Wage </h4>
		</div>
	</div>
</div>
</div>

<!-- Section For Graduate School Information -->
<div class="panel panel-default">
<div class="container-fuild" style="text-align:center">
	<div class="row">
		<div class="col-md-12">
			<h2>Facts About Graduate School</h2>
			<hr>
		</div>
	</div>
	<div class="row">
		<div class="col-md-12">
			<h4>If you go to Graduate School, you will earn, on average, <font color="green">$<%= GradWages%></font> annually versus <font color="red">$<%= UgradWages %></font> annually if you go straight into industry. That's a <b>$<%=GradWages-UgradWages %></b> difference per year!</h4>
			<hr>
		</div>
	</div>
	<div class="row">
		<div class="col-md-12">
			<h4>Average Tuition for My Major</h4>
			<table class="table table-responsive table-condensed" >
				<tr>
					<th style="text-align:center">Undergrad In State</th>
					<th style="text-align:center">Grad In State</th>
					<th style="text-align:center">Undergrad Out State</th>
					<th style="text-align:center">Grad Out State</th>
				</tr>
				<tr>
					<td style="text-align:center">$<%=rs4.getString("InStateU") %></td>
					<td style="text-align:center">$<%=rs6.getString("InStateG") %></td>
					<td style="text-align:center">$<%=rs4.getString("OutStateU") %></td>
					<td style="text-align:center">$<%=rs6.getString("OutStateG") %></td>
				</tr>
			</table>
		</div>
	</div>
</div>
</div>


<!-- Start table formatting -->
<div class="panel panel-default">
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
			<h4>Average Annual Wages For Occupations with the  Major <%=major %> by State</h4>
			<div id="chart4"></div>	
		</div>
	</div>
</div>
</div>
</div>

<%
rs1.close();
rs2.close();
rs3.close();
rs4.close();
con.close();
%>
</body>
</html>