<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Advanced Results</title>
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
<!-- Optional theme -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp" crossorigin="anonymous">
<!-- Latest compiled and minified JavaScript -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>

</head>
<body>
<h1>Which School is Right for me</h1>
<%
String url = "jdbc:mysql://masters.cqxrbwnqjcdx.us-east-1.rds.amazonaws.com:3306/innodb";
Class.forName("com.mysql.jdbc.Driver");
Connection con = DriverManager.getConnection(url, "woleng", "analmaDB");

String College1 = request.getParameter("Colleges1");
String College2 = request.getParameter("Colleges2");

//Use session to pass parameters between jsp pages

//session.setAttribute("Connection", con);

%>

<div class="container-fluid" style="margin:auto">
	<div class="row">
		<div class="col-md-12">

		<%
		String compSchoolq1 = "SELECT c.INSTNM,c.InStateGradTut,c.OutStateGradTut FROM College c WHERE c.INSTNM = \"" + College1 + "\" or c.INSTNM = \"" + College2 + "\"ORDER BY c.INSTNM ASC";
		PreparedStatement the_statement = con.prepareStatement(compSchoolq1);
		ResultSet rs1 = the_statement.executeQuery();
		
		out.print("<h4>A Quick Overview of Each College</h4>");
		out.print("<table class=\"table table-striped\">");
		//make a row
		out.print("<tr>");
		//make a column
		out.print("<td>");
		//print out column header
		out.print("College");
		out.print("</td>");
		//make a column
		out.print("<td>");
		out.print("In State Graduate Tuition");
		out.print("</td>");
		//make a column
		out.print("<td>");
		out.print("Out of State Graduate Tuition");
		out.print("</td>");
		out.print("</tr>");
		while(rs1.next()){
			out.print("<tr>");
			//make a column
			out.print("<td>");
			//print out column header
			out.print(rs1.getString("INSTNM"));
			out.print("</td>");
			//make a column
			out.print("<td>");
			out.print(rs1.getString("InStateGradTut"));
			out.print("</td>");
			//make a column
			out.print("<td>");
			out.print(rs1.getString("OutStateGradTut"));
			out.print("</td>");
			out.print("</tr>");
		}
		out.print("</table>");
		rs1.close();
		%>
		</div>
	</div>
	<div class="row">
		<div class="col-md-12">
		<%
		String compSchoolq2 ="";
		if(College1.compareTo(College2) < 0){
		compSchoolq2 = "SELECT (c1.InStateGradTut - c2.InStateGradTut) as sub1, (c1.OutStateGradTut - c2.OutStateGradTut) as sub2 FROM College c1 CROSS JOIN College c2 WHERE c1.INSTNM = \"" + College1 +"\" and c2.INSTNM = \""+College2 +"\";";
		}
		else
			compSchoolq2 = "SELECT (c1.InStateGradTut - c2.InStateGradTut) as sub1, (c1.OutStateGradTut - c2.OutStateGradTut) as sub2 FROM College c1 CROSS JOIN College c2 WHERE c1.INSTNM = \"" + College2 +"\" and c2.INSTNM = \""+College1 +"\";";
			
		the_statement.clearBatch();
		the_statement = con.prepareStatement(compSchoolq2);
		ResultSet rs2 = the_statement.executeQuery();
		
		out.print("<h4>Difference</h4>");
		out.print("<table class=\"table table-striped\">");
		//make a row
				out.print("<tr>");
				//make a column
				out.print("<td>");
				//print out column header
				
				out.print("</td>");
				//make a column
				out.print("<td>");
				out.print("In State Graduate Tuition");
				out.print("</td>");
				//make a column
				out.print("<td>");
				out.print("Out of State Graduate Tuition");
				out.print("</td>");
				out.print("</tr>");
		while(rs2.next()){
			out.print("<tr>");
			//make a column
			out.print("<td>");
			//print out column header
		
			out.print("</td>");
			//make a column
			out.print("<td>");
			if(rs2.getDouble("sub1") < 0){
				out.print("<font color= \"green\">");
			}
			else
				out.print("<font color= \"red\">");
			out.print(rs2.getString("sub1"));
			out.print("</font>");
			out.print("</td>");
			//make a column
			out.print("<td>");
			if(rs2.getDouble("sub2") < 0){
				out.print("<font color= \"green\">");
			}
			else
				out.print("<font color = \"red\">");
			out.print(rs2.getString("sub2"));
			out.print("</font>");
			out.print("</td>");
			out.print("</tr>");
		}
		out.print("</table>");
		rs2.close();
		%>
		</div>
	</div>
	<div class="row">
		<div class="col-md-6">
			<%
		String compSchoolq3 = "SELECT maj.Major_Subgroup, maj.Median_Annual_Wages FROM Major maj WHERE maj.CIPCode in (SELECT Off.CIPCODE FROM Offers Off WHERE Off.UNITID = (SELECT c.UNITID FROM College c WHERE c.INSTNM = \"" + College1 + "\")) ORDER BY maj.Median_Annual_Wages DESC LIMIT 10;";

		the_statement.clearBatch();
		the_statement = con.prepareStatement(compSchoolq3);
		ResultSet rs3 = the_statement.executeQuery();
		
		out.print("<h4>Top Paying Majors Offered at "+ College1 +"</h4>");
		out.print("<table class=\"table table-striped\">");
		//make a row
				out.print("<tr>");
				//make a column
				
				//make a column
				out.print("<td>");
				out.print("Major");
				out.print("</td>");
				//make a column
				out.print("<td>");
				out.print("Salary");
				out.print("</td>");
				out.print("</tr>");
		while(rs3.next()){
			out.print("<tr>");
			//make a column
		
			//make a column
			out.print("<td>");
			out.print(rs3.getString("Major_Subgroup"));
			out.print("</td>");
			//make a column
			out.print("<td>");
			
			out.print(rs3.getString("Median_Annual_Wages"));
		
			out.print("</td>");
			out.print("</tr>");
		}
		out.print("</table>");
		rs3.close();
		%>
		</div>
			<div class="col-md-6">
			<%
		String compSchoolq4 = "SELECT maj.Major_Subgroup, maj.Median_Annual_Wages FROM Major maj WHERE maj.CIPCode in (SELECT Off.CIPCODE FROM Offers Off WHERE Off.UNITID = (SELECT c.UNITID FROM College c WHERE c.INSTNM = \"" + College2 + "\")) ORDER BY maj.Median_Annual_Wages DESC LIMIT 10;";

		the_statement.clearBatch();
		the_statement = con.prepareStatement(compSchoolq4);
		ResultSet rs4 = the_statement.executeQuery();
		
		out.print("<h4>Top Paying Majors Offered at "+ College2 +"</h4>");
		out.print("<table class=\"table table-striped\">");
		//make a row
				out.print("<tr>");
				//make a column
				
				//make a column
				out.print("<td>");
				out.print("Major");
				out.print("</td>");
				//make a column
				out.print("<td>");
				out.print("Salary");
				out.print("</td>");
				out.print("</tr>");
		while(rs4.next()){
			out.print("<tr>");
			//make a column
		
			//make a column
			out.print("<td>");
			out.print(rs4.getString("Major_Subgroup"));
			out.print("</td>");
			//make a column
			out.print("<td>");
			
			out.print(rs4.getString("Median_Annual_Wages"));
		
			out.print("</td>");
			out.print("</tr>");
		}
		out.print("</table>");
		rs4.close();
		%>
		</div>
	
	
	
	</div>
<% 
con.close();
%>
	
</div>