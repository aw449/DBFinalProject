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
<%
String url = "jdbc:mysql://masters.cqxrbwnqjcdx.us-east-1.rds.amazonaws.com:3306/innodb";
Class.forName("com.mysql.jdbc.Driver");
Connection con = DriverManager.getConnection(url, "woleng", "analmaDB");

String College = request.getParameter("Colleges");
String GradMajor = request.getParameter("GradMajors");
String CollegeState = request.getParameter("CollegeStates");
String Occupation= request.getParameter("Occupations");
String JobState= request.getParameter("JobStates");
String major = request.getParameter("Majors");
String state = request.getParameter("States");
String MaxTuition = request.getParameter("MaxTuition");
String major_group;
String fos;
//Use session to pass parameters between jsp pages
session.setAttribute("Major", major);
session.setAttribute("State", state);
//session.setAttribute("Connection", con);

%>

<div class="container-fuild" style="margin:auto">
	<div class="row">
		<div class="col-md-12">
			
	

<!-- Start adding charts here -->

<%
//Send Query if not null
if(CollegeState != "" && MaxTuition !=""){
	String tuitiontype = "OutState";
	if(CollegeState.equals(state)){
		tuitiontype = "InState";
	}
	
	String q1 = "SELECT c.INSTNM,c."+tuitiontype+"GradTut as Tuition From College c WHERE c.STABBR = \""+ state + "\" and c.InStateGradTut <= " + MaxTuition +" and c."+tuitiontype+"GradTut <> 0 ORDER BY c."+tuitiontype+"GradTut ASC LIMIT 10;";
	PreparedStatement the_statement = con.prepareStatement(q1);
	ResultSet rs1 = the_statement.executeQuery();
	rs1.next();
	out.print("<h4>Something About Tuition</h4>");
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
	out.print("Tuition");
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
		out.print(rs1.getString("Tuition"));
		out.print("</td>");
		out.print("</tr>");
	}
	out.print("</table>");
	con.close();	
}

%>
	<hr>
	</div>
	</div>
	
	
</div>
</body>
</html>