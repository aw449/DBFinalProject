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
Warning: If you enter an advanced query, execution will be slow.
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
String YearsToJob = request.getParameter("YearsToJob");
String YearsToGrad = request.getParameter("YearsToGrad");
String Scholarship = request.getParameter("Scholarship");
String YearEarnings = request.getParameter("YearEarnings");
String YearsDebt = request.getParameter("YearsDebt");
String YesOrNo;
if(YearsToJob == ""){
	YearsToJob = "0";
}
if(YearsToGrad == ""){
	YearsToGrad = "2";
}
if(Scholarship == ""){
	Scholarship = "0";
}
if(YearEarnings == ""){
	YearEarnings = "5"; 
if(College != ""){
	//Query for the state that this college is in
	String q0 = "SELECT STABBR FROM innodb.College where INSTNM = \'"+College+"\'";
	PreparedStatement the_statement = con.prepareStatement(q0);
	ResultSet rs1 = the_statement.executeQuery();
	CollegeState = rs1.getString("STABBR");
}
	//User wants to maximize YearEarnings year earnings
}
if(YearsDebt == ""){
	YearsDebt = "1.5"; 
	// One and a half years is pretty long already
}
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

//Add the very large query, with customizable options depending on what the user does or does not select.

StringBuilder LargeQuery = new StringBuilder();
LargeQuery.append("SELECT ROUND((sub3.G*4 / sub4.GradWages)*100)/100 as YearsToPayOffDebt, ");
LargeQuery.append("ROUND((sub4.UgradWages*2 + sub3.G*4)*100)/100 as OC, ");
LargeQuery.append("ROUND((sub4.UgradWages*2 + sub3.G*4)/sub4.GradWages*100)/100 as YearsToMakeUpOC ");
LargeQuery.append("from(( ");
if(College != ""){
	if(CollegeState.equals(state)){
		//Get instate tuitions
		LargeQuery.append("SELECT STABBR as ST, InStateUgradTut as U, InStateGradTut as G ");
	}
	else{
		LargeQuery.append("SELECT STABBR as ST, OutStateUgradTut as U, OutStateGradTut as G ");
	}
	LargeQuery.append("from innodb.College ");
	LargeQuery.append("where INSTNM = \'" + College + "\')sub3, ");
}
else if(CollegeState != ""){//We don't have the college field, but we have the college state. 
	//Compare against state user lives in
	if(CollegeState.equals(state)){
		//Get instate tuitions
		LargeQuery.append("SELECT avg(InStateUgradTut) as U, avg(InStateGradTut) as G ");
		LargeQuery.append("from ( ");
		LargeQuery.append("(SELECT UNITID, STABBR, InStateUgradTut as UgradTutIn FROM innodb.College  ");
		LargeQuery.append("where InStateUgradTut <> 0 and STABBR = \'" +state + "\')a, " );
		LargeQuery.append("(SELECT UNITID, STABBR, InStateGradTut as GradTutIn FROM innodb.College  ");
		LargeQuery.append("where InStateGradTut <> 0 and STABBR = \'" +state + "\'b ");
		LargeQuery.append(") ");
	}
	else{
		LargeQuery.append("SELECT avg(OutStateUgradTut) as U, avg(OutStateGradTut) as G ");
	}
	LargeQuery.append("where STABBR = \'" + CollegeState + "\')sub3, ");
}
else{ // We know nothing, Jon Snow. Except where you live.
	LargeQuery.append("(SELECT sub1.ST as ST, (sub1.InStateU + sub2.OutStateU)/2 as U, (sub1.InStateG + sub2.OutStateG)/2 as G ");
	LargeQuery.append("from( ");
	LargeQuery.append("( ");
	LargeQuery.append("SELECT a.STABBR as ST, avg(a.UgradTutIn) as InStateU, avg(b.GradTutIn) as InStateG ");
	LargeQuery.append("from ( ");
	LargeQuery.append("(SELECT UNITID, STABBR, InStateUgradTut as UgradTutIn FROM innodb.College  ");
	LargeQuery.append("where InStateUgradTut <> 0 and STABBR = \'" +state + "\')a, " );
	LargeQuery.append("(SELECT UNITID, STABBR, InStateGradTut as GradTutIn FROM innodb.College  ");
	LargeQuery.append("where InStateGradTut <> 0 and STABBR = \'" +state + "\'b ");
	LargeQuery.append(") ");
	LargeQuery.append("where a.UNITID = b.UNITID and a.STABBR = b.STABBR ");
	LargeQuery.append("group by ST ");
	LargeQuery.append(")sub1, ");
	LargeQuery.append("( ");
	LargeQuery.append("SELECT c.STABBR as ST, avg(c.UgradTutOut) as OutStateU, avg(d.GradTutOut) as OutStateG ");
	LargeQuery.append("from ( ");
	LargeQuery.append("(SELECT UNITID, STABBR, OutStateUgradTut as UgradTutOut FROM innodb.College  ");
	LargeQuery.append("where OutStateUgradTut <> 0 and STABBR = \'" +state + "\')c, ");
	LargeQuery.append("(SELECT UNITID, STABBR, OutStateGradTut as GradTutOut FROM innodb.College  ");
	LargeQuery.append("where OutStateGradTut <> 0 and STABBR = \'" +state + "\')d ");
	LargeQuery.append(") ");
	LargeQuery.append("where c.UNITID = d.UNITID and c.STABBR = d.STABBR ");
	LargeQuery.append("   #and c.UNITID = 'College ID here' //If you want to select a specific college ");
	LargeQuery.append("group by ST ");
	LargeQuery.append("   )sub2 ");
	LargeQuery.append("	) ");
	LargeQuery.append("where sub1.ST = sub2.ST ");
	LargeQuery.append(")sub3, ");
}

LargeQuery.append("( ");
LargeQuery.append("SELECT MAJOR_SUBGROUP, MEDIAN_ANNUAL_WAGES as UgradWages, (MEDIAN_ANNUAL_WAGES * (1+(GRADUATE_DEGREE_WAGE_PREMIUM/100))) as GradWages  ");
LargeQuery.append("from innodb.Majors ");
LargeQuery.append("#where MAJOR_SUBGROUP = 'Major Subgroup here' // If you wish to add a major subgroup ");
LargeQuery.append("#and  ");
LargeQuery.append(")sub4 ");
LargeQuery.append("); ");



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