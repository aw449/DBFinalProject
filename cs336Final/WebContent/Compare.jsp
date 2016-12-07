<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ page import="java.io.*,java.util.*,java.sql.*, java.text.NumberFormat"%>
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
<title>Major Results</title>
</head>
<body>
<div class="container-fluid">
<h1>Results</h1>
<%
String url = "jdbc:mysql://masters.cqxrbwnqjcdx.us-east-1.rds.amazonaws.com:3306/innodb";
Class.forName("com.mysql.jdbc.Driver");
Connection con = DriverManager.getConnection(url, "woleng", "analmaDB");

String major1 = request.getParameter("Majors1");
String major2 = request.getParameter("Majors2");
String Lifetime_Earnings = "";
String Limit = "";
String add_limit = "";
String add_lte = "";
String fos1 = "";
String fos2 = "";
String q1 = "SELECT Earns.Field_of_Study, MajorGroup.Major_Subgroup FROM Earns, (SELECT m1.Major_Group, m1.Major_Subgroup FROM Major m1 WHERE m1.Major_Subgroup = '" + major1 + "' OR m1.Major_Subgroup = '" + major2 + "') as MajorGroup WHERE Earns.Major_Group = MajorGroup.Major_Group"; 
String Order = request.getParameter("Order");
String add_Order= " ORDER BY o1.Masters_Earnings1, o2.Masters_Earnings2, o1.Bachelors_Earnings1, o2.Bachelors_Earnings2 " + Order;

if (request.getParameter("Limit").isEmpty()){
	add_limit = "";
}
else{
	Limit = request.getParameter("Limit");
	add_limit = " LIMIT " + Limit;
}

if (request.getParameter("Lifetime_Earnings").isEmpty()){
	add_lte = "";
}
else{
	Lifetime_Earnings = request.getParameter("Lifetime_Earnings");
	float temp = Float.parseFloat(Lifetime_Earnings);
	NumberFormat fmt = NumberFormat.getCurrencyInstance();
	String Earnings = fmt.format(temp);
	Earnings = Earnings.substring(0, Earnings.length()-3);
	Earnings = "\'"+Earnings+"\'";
	add_lte = " and STRCMP(o1.Bachelors_Earnings1, " + Earnings + ") >=0" +
			" and STRCMP(o2.Bachelors_Earnings2, " + Earnings +  ") >=0" +
			" and STRCMP(o1.Masters_Earnings1, " + Earnings +  ") >=0" +
			" and STRCMP(o2.Masters_Earnings2, " + Earnings +  ") >=0 ";
}

Statement stmt = con.createStatement();
PreparedStatement the_statement = con.prepareStatement(q1);
ResultSet rs1 = the_statement.executeQuery();

while(rs1.next()){
	if (major1.equals(major2)){
		fos1 = rs1.getString("Field_of_Study");
		fos2 = rs1.getString("Field_of_Study");
	}
	else if(rs1.getString("Major_Subgroup").equals(major1)){
		fos1 = rs1.getString("Field_of_Study");
	}
	
	else{
		fos2 = rs1.getString("Field_of_Study");
	}
}

rs1.close();

String q2 = "SELECT o1.Occupation, o1.Bachelors_Earnings1, o2.Bachelors_Earnings2, o1.Masters_Earnings1, o2.Masters_Earnings2 FROM (SELECT Occupation, B_SWE AS Bachelors_Earnings1, M_SWE AS Masters_Earnings1 FROM "+ fos1 + ") AS o1, (SELECT Occupation, B_SWE AS Bachelors_Earnings2, M_SWE AS Masters_Earnings2 FROM " + fos2 + ") AS o2 WHERE o1.Occupation = o2.Occupation " + add_lte +  add_Order + add_limit +";";
the_statement.clearBatch();
the_statement = con.prepareStatement(q2);
ResultSet rs2 = the_statement.executeQuery();

String q3 = "SELECT DISTINCT * FROM Major WHERE Major_Subgroup = '" + major1 + "' OR Major_Subgroup = '" + major2 + "'";
the_statement.clearBatch();
the_statement = con.prepareStatement(q3);
ResultSet rs3 = the_statement.executeQuery();

%>
<h4>Basic Information Regarding the Selected Majors: </h4>
	<table class="table table-striped table-responsive">
		<tr>
			<td>Major Group</td>
			<td>Major</td>
			<td>Graduate Degree Wage Premium</td>
			<td>Median Annual Wage</td>
			<td>Graduate Degree Attainment</td>
		</tr>
		<%
		while(rs3.next()){
			out.print("<tr>");
			out.print("<td>");
			out.print(rs3.getString("Major_Group"));
			out.print("</td>");
			out.print("<td>");
			out.print(rs3.getString("Major_Subgroup"));
			out.print("</td>");
			out.print("<td>");
			out.print(rs3.getString("Graduate_Degree_Wage_Premium"));
			out.print("</td>");
			out.print("<td>");
			out.print(rs3.getString("Graduate_Degree_Attainment"));
			out.print("</td>");
			out.print("<td>");
			out.print(rs3.getString("Median_Annual_Wages"));
			out.print("</td>");
			out.print("</tr>");	
		}
		%>
	</table>


<h4>Comparison of Wages for Occupations with Either a Degree in <b><%=major1 %></b> or <b><%=major2 %></b></h4>
<h6>Note1: (1 Corresponds to Major 1 and 2 Corresponds to Major 2)</h6>
<h6>Note2: (Columns with a (B) indicates that less than 10,000 people were sampled for that Occupation, so no value is given)</h6>
<table class="table table-striped table-responsive">
	<tr>
		<th>Occupations</th>
		<th>Bachelors Lifetime Earnings 1</th>
		<th>Bachelors Lifetime Earnings 2</th>
		<th>Masters Lifetime Earnings 1</th>
		<th>Masters Lifetime Earnings 2</th>
	</tr>
	<%
	while(rs2.next()){
		out.print("<tr>");
		out.print("<td>");
		out.print(rs2.getString("Occupation"));
		out.print("</td>");
		out.print("<td>");
		out.print(rs2.getString("Bachelors_Earnings1"));
		out.print("</td>");
		out.print("<td>");
		out.print(rs2.getString("Bachelors_Earnings2"));
		out.print("</td>");
		out.print("<td>");
		out.print(rs2.getString("Masters_Earnings1"));
		out.print("</td>");
		out.print("<td>");
		out.print(rs2.getString("Masters_Earnings2"));
		out.print("</td>");
		out.print("</tr>");
	}
	rs2.close();
	%>
</table>

<%
con.close();
%>
</div>
</body>