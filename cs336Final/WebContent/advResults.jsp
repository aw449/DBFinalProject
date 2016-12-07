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
Connection con = DriverManager.getConnection(url, "woleng", "analmaDB"); // for Anthony, Allen, Matthew, DB

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
PreparedStatement the_statement;

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
	the_statement = con.prepareStatement(q0);
	ResultSet rs1 = the_statement.executeQuery();
	rs1.next();
	CollegeState = rs1.getString("STABBR");
	the_statement.clearBatch();
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
LargeQuery.append("SELECT sub3.G as tuition, (ROUND(((sub3.G-"+Scholarship+"* 2 *"+YearsToGrad+ ") / sub4.GradWages)*100)/100) + "+YearsToJob+" as YearsToPayOffDebt, ");
LargeQuery.append("ROUND(sub4.UgradWages*"+YearsToGrad+ " + (sub3.G-"+Scholarship+")*400)/100 as OC, ");
LargeQuery.append("ROUND((sub4.UgradWages*"+YearsToGrad+ " + (sub3.G-"+Scholarship+")*4)/(sub4.GradWages - sub4.UgradWages)*100)/100 + "+YearsToJob+" as YearsToMakeUpOC ");
LargeQuery.append("from(( ");
if(College != ""){
	String miniQuery = "SELECT STABBR as ST from innodb.College where INSTNM = \'" + College + "\';";
	the_statement = con.prepareStatement(miniQuery);
	ResultSet rsm = the_statement.executeQuery();
	rsm.next();
	if(rsm.getString("ST").equals(state)){
		//Get instate tuitions
	LargeQuery.append("SELECT STABBR as ST, InStateUgradTut as U, InStateGradTut as G ");
	}
	else{
	LargeQuery.append("SELECT STABBR as ST, OutStateUgradTut as U, OutStateGradTut as G ");
	}
	LargeQuery.append("from innodb.College ");
	LargeQuery.append("where INSTNM = \'" + College + "\')sub3, ");
	the_statement.clearBatch();
}
else if(CollegeState != ""){//We don't have the college field, but we have the college state. 
	//Compare against state user lives in
	if(CollegeState.equals(state)){
		//Get instate tuitions
		LargeQuery.append("SELECT avg(InStateUgradTut) as U, avg(InStateGradTut) as G ");
		LargeQuery.append("from ( ");
		LargeQuery.append("(SELECT UNITID, STABBR, InStateUgradTut as UgradTutIn FROM innodb.College  ");
		LargeQuery.append("where InStateUgradTut <> 0 and STABBR = \'" +CollegeState + "\')a, " );
		LargeQuery.append("(SELECT UNITID, STABBR, InStateGradTut as GradTutIn FROM innodb.College  ");
		LargeQuery.append("where InStateGradTut <> 0 and STABBR = \'" +CollegeState + "\')b ");
		LargeQuery.append(")) sub3, ");
	}
	else{
		LargeQuery.append("SELECT avg(OutStateUgradTut) as U, avg(OutStateGradTut) as G ");
		LargeQuery.append("from ( ");
		LargeQuery.append("(SELECT UNITID, STABBR, OutStateUgradTut FROM innodb.College  ");
		LargeQuery.append("where OutStateUgradTut <> 0 and STABBR = \'" +CollegeState + "\')a, " );
		LargeQuery.append("(SELECT UNITID, STABBR, OutStateGradTut FROM innodb.College  ");
		LargeQuery.append("where OutStateGradTut <> 0 and STABBR = \'" +CollegeState + "\')b ");
		LargeQuery.append(")) sub3, ");
	}
}
else{ // We know nothing, Jon Snow. Except where you live.
	LargeQuery.append("SELECT sub1.ST as ST, (sub1.InStateU + sub2.OutStateU)/2 as U, (sub1.InStateG + sub2.OutStateG)/2 as G ");
	LargeQuery.append("from( ");
	LargeQuery.append("( ");
	LargeQuery.append("SELECT a.STABBR as ST, avg(a.UgradTutIn) as InStateU, avg(b.GradTutIn) as InStateG ");
	LargeQuery.append("from ");
	LargeQuery.append("(SELECT UNITID, STABBR, InStateUgradTut as UgradTutIn FROM innodb.College  ");
	LargeQuery.append("where InStateUgradTut <> 0 and STABBR = \'" +state + "\')a, " );
	LargeQuery.append("(SELECT UNITID, STABBR, InStateGradTut as GradTutIn FROM innodb.College  ");
	LargeQuery.append("where InStateGradTut <> 0 and STABBR = \'" +state + "\')b ");
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
	LargeQuery.append("group by ST ");
	LargeQuery.append("   )sub2 ");
	LargeQuery.append("	) ");
	LargeQuery.append("where sub1.ST = sub2.ST ");
	LargeQuery.append(")sub3, ");
}

LargeQuery.append("( ");
LargeQuery.append("SELECT MAJOR_SUBGROUP, MEDIAN_ANNUAL_WAGES as UgradWages, (MEDIAN_ANNUAL_WAGES * (1+(GRADUATE_DEGREE_WAGE_PREMIUM/100))) as GradWages  ");
LargeQuery.append("from innodb.Majors ");
LargeQuery.append("where MAJOR_SUBGROUP = \'"+major+"\' ");
LargeQuery.append(")sub4 ");
LargeQuery.append("); ");

//Decision Making:
//	Based on this and the opportunity costs and years until debt free, we determine yes or no
//	I would like to be in debt for no more than __ years.
//
//	I would like to maximize my __ year earnings.
//
//	I would like to pay less than the maximum tuition I set.
	the_statement = con.prepareStatement(LargeQuery.toString());
	System.out.println(LargeQuery.toString());
	ResultSet rsLarge = the_statement.executeQuery();
	rsLarge.next();
	String OC = rsLarge.getString("OC");
	String YOC = rsLarge.getString("YearsToMakeUpOC");
	String YOD= rsLarge.getString("YearsToPayOffDebt");
	String tut = rsLarge.getString("tuition");
	YesOrNo = "Yes";
if(YearsDebt != "" ){
	if(Double.parseDouble(YOD) > Double.parseDouble(YearsDebt))
		YesOrNo = "No";
}
if(YearEarnings != ""){
	if(Double.parseDouble(YOC) > Double.parseDouble(YearEarnings))
		YesOrNo = "No";
}
if(MaxTuition != ""){
	if(Double.parseDouble(tut) > Double.parseDouble(MaxTuition))
		YesOrNo = "No";	
}
//Lifelong here
if(YesOrNo.equals("Yes"))
	YesOrNo = "Yes, you should pursue a Graduate degree!";
else
	YesOrNo = "No, you should not pursue a Graduate degree.";


%>
	<hr>
	</div>
	</div>
	
	
</div>

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
String q3;
if(Occupation != ""){
	q3 = "SELECT occ.ST, occ.A_MEAN as StateWage FROM StateOccupations occ "+
	"WHERE occ.OCC_TITLE = \'"+Occupation+"\';";
}
else{
	q3 = "SELECT occ.ST, ROUND(AVG(occ.A_MEAN),2) as StateWage FROM StateOccupations occ "+
	"WHERE occ.OCC_CODE in (SELECT wor.SOC2010Code FROM WorksIn wor WHERE wor.CIP2010Code  "+
	"LIKE CONCAT('%',(SELECT maj.CIPCode FROM Major maj WHERE maj.Major_Subgroup = \"" + major + 
	"\" ORDER BY maj.CIPCODE ASC LIMIT 1),'%')) GROUP BY occ.ST ORDER BY AVG(occ.A_MEAN) DESC;";
}

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
String q4 = "SELECT maj.Graduate_Degree_Attainment, maj.Median_Annual_Wages, "+
"maj.Graduate_Degree_Wage_Premium FROM Major maj where Major_Subgroup = \"" + major + "\"";
Statement stmt = con.createStatement();
the_statement = con.prepareStatement(q4);
ResultSet rs1 = the_statement.executeQuery();
rs1.next();
%>

<%
String q5 = "SELECT count(distinct m1.Major_Group) as Rank FROM "+
"(SELECT maj.Major_Group, avg(maj.Median_Annual_Wages) as Average_Annual_Wages "+
"FROM Major maj GROUP BY maj.Major_Group ORDER BY avg(maj.Median_Annual_Wages) DESC) m1, "+
"Major m2 WHERE m1.Average_Annual_Wages >= (SELECT avg(m2.Median_Annual_Wages) from Major m2 "+
"where m2.Major_Group = ( SELECT distinct m3.Major_Group from Major m3 where m3.Major_Subgroup = \""
+ major + "\"));";
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
major_group = rs3.getString("Major_Group");
%>

<%
String q7 = "SELECT Round(avg(NULLIF(a.UgradTut,0)),2) as InStateU, Round(avg(NULLIF(b.UgradTut,0)),2) "+
"as OutStateU from (SELECT UNITID, INSTNM, STABBR, InStateUgradTut as UgradTut FROM innodb.College "+
"where STABBR = '" + state + "') a, (SELECT UNITID, INSTNM, STABBR, OutStateUgradTut as UgradTut "+
"FROM innodb.College where STABBR <> '" + state +  "')b;";
the_statement.clearBatch();
the_statement = con.prepareStatement(q7);
ResultSet rs4 = the_statement.executeQuery();
rs4.next();
%>

<%
StringBuilder rs5s = new StringBuilder();
rs5s.append("SELECT Round(MEDIAN_ANNUAL_WAGES,2) as UgradWages, Round((MEDIAN_ANNUAL_WAGES * ");
rs5s.append("(1+(GRADUATE_DEGREE_WAGE_PREMIUM/100))),2) as GradWages  ");
rs5s.append("from innodb.Majors ");
rs5s.append("where MAJOR_SUBGROUP = \'"+major+"\' ");
the_statement.clearBatch();
the_statement = con.prepareStatement(rs5s.toString());
ResultSet rs5 = the_statement.executeQuery();
rs5.next();
double UgradWages = rs5.getDouble("UgradWages");
double GradWages = rs5.getDouble("GradWages");
%>

<%
String q9;
LargeQuery = new StringBuilder();
if(College != ""){
	LargeQuery.append("SELECT STABBR as ST, InStateUgradTut as InStateU, InStateGradTut as InStateG, ");
	LargeQuery.append("OutStateUgradTut as OutStateU, OutStateGradTut as OutStateG ");
	LargeQuery.append("from innodb.College ");
	LargeQuery.append("where INSTNM = \'" + College + "\'");
	q9 = LargeQuery.toString();
}
else if(CollegeState != ""){//We don't have the college field, but we have the college state. 
	//Compare against state user lives in
	//Get instate tuitions
	LargeQuery.append("SELECT avg(a.UgradTutIn) as InStateU, avg(b.GradTutIn) as InStateG, ");
	LargeQuery.append("avg(c.OutStateUgradTut) as OutStateU, avg(d.OutStateGradTut) as OutStateG ");
	LargeQuery.append("from ( ");
	LargeQuery.append("(SELECT UNITID, STABBR, InStateUgradTut as UgradTutIn FROM innodb.College  ");
	LargeQuery.append("where InStateUgradTut <> 0 and STABBR = \'" +state + "\')a, " );
	LargeQuery.append("(SELECT UNITID, STABBR, InStateGradTut as GradTutIn FROM innodb.College  ");
	LargeQuery.append("where InStateGradTut <> 0 and STABBR = \'" +state + "\')b, ");
	LargeQuery.append("(SELECT UNITID, STABBR, OutStateUgradTut FROM innodb.College  ");
	LargeQuery.append("where OutStateUgradTut <> 0 and STABBR = \'" +state + "\')c, " );
	LargeQuery.append("(SELECT UNITID, STABBR, OutStateGradTut FROM innodb.College  ");
	LargeQuery.append("where OutStateGradTut <> 0 and STABBR = \'" +state + "\')d ");
	LargeQuery.append(") ");
	q9 = LargeQuery.toString();
}
else{ // We know nothing, Jon Snow. Except where you live.

	q9 = "SELECT Round(avg(NULLIF(a.GradTut,0)),2) as InStateG, Round(avg(NULLIF(b.GradTut,0)),2)"+
			"as OutStateG from  (SELECT UNITID, INSTNM, STABBR, InStateGradTut as GradTut FROM innodb.College "+
			"where STABBR = '" + state + "') a, (SELECT UNITID, INSTNM, STABBR, OutStateGradTut as GradTut "+
			"FROM innodb.College where STABBR <> '" + state +  "')b;";
	}
the_statement.clearBatch();
System.out.println(q9);
the_statement = con.prepareStatement(q9);
ResultSet rs6 = the_statement.executeQuery();
rs6.next();


%>

<%
String q10 = "SELECT Field_of_Study FROM Earns WHERE Major_Group = '" + major_group + "'";
the_statement.clearBatch();
the_statement = con.prepareStatement(q10);
ResultSet rs7 = the_statement.executeQuery();
rs7.next();
fos = rs7.getString("Field_of_Study");
%>

<%
String q11 = "SELECT B_SWE, M_SWE FROM " + fos + " WHERE Occupation = \"All occupations\"";
the_statement.clearBatch();
the_statement = con.prepareStatement(q11);
ResultSet rs8 = the_statement.executeQuery();
rs8.next();
%>

<%
String q12 = "SELECT Occupation, B_SWE FROM " + fos + " WHERE Occupation <> \"All occupations\" and B_SWE <> \"(B)\" ORDER BY B_SWE DESC LIMIT 3";
the_statement.clearBatch();
the_statement = con.prepareStatement(q12);
ResultSet rs9 = the_statement.executeQuery();
rs9.next();
%>

<%
String q13 = "SELECT Occupation, M_SWE FROM " + fos + " WHERE Occupation <> \"All occupations\" and M_SWE <> \"(B)\" ORDER BY M_SWE DESC LIMIT 3";
the_statement.clearBatch();
the_statement = con.prepareStatement(q13);
ResultSet rs10 = the_statement.executeQuery();
rs10.next();
%>

<%
String q14 = "SELECT * FROM OpportunityCosts WHERE State = '" + state + "' and Major = '" + major + "'";
the_statement.clearBatch();
the_statement = con.prepareStatement(q14);
ResultSet rs11 = the_statement.executeQuery();
rs11.next();
%>

<%
	
	double UgradStart_y = 0;	
	double GradStart_y = -1*rs6.getDouble("InStateG");
	
	double GradintersectCalc = (2*GradStart_y) - (2*GradWages) ;
	double xinter = intersectx(UgradWages,GradWages,UgradStart_y,GradintersectCalc); 
	
	Map<String, String> dataMap3 = getLineChart(UgradWages,GradWages,GradStart_y);
	FusionCharts lineChart3 = new FusionCharts(
	        "msline",// chartType
	        "ex5",// chartId
	        "600","400",// chartWidth, chartHeight
	        "chart5",// chartContainer
	        "json",// dataFormat
	        // dataSource
			gson.toJson(dataMap3)
			);
	
%>
<%= lineChart3.render()%>

<!-- Start text formatting -->

<!-- Section For Major Information -->
<div class="panel panel-default">
<div class="container-fluid" style="text-align:center; margin:auto">
	<div class="row">
		<div class="col-md-12">
		    <h2 style="text-align:center"><%=YesOrNo%></h2>
			<h2 style="text-align:center">Facts about my major: <%=major %></h2>
			<hr>
		</div>
	</div>
	<div class="row">
		<div class="col-md-4">
			<h4>Percentage of People with Graduate Degrees: <b><%=rs1.getString("Graduate_Degree_Attainment") %>%</b></h4>
		</div>
		<div class="col-md-4">
			<h4>Median Annual Wages: <b>$<%=rs1.getString("Median_Annual_Wages") %></b></h4>
		</div>
		<div class="col-md-4">
			<h4>Graduate Wage Premium: <b><%=rs1.getString("Graduate_Degree_Wage_Premium") %>%</b></h4>
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
	<hr>
	<div class="row">
		<div class="col-md-12">
			<h4>Your Major falls under the Field of Study: <b><%= fos %></b></h4>
		</div>
	</div>
	<div class="row">
		<div class="col-md-12">
			<h4>Over your career, your estimated total earnings are <b><%=rs8.getString("M_SWE") %></b> with a Masters degree and <b><%=rs8.getString("B_SWE")%></b> with a Bachelors Degree</h4>
		</div>
	</div>
	<div class="row">
		<div class="col-md-12">
			<hr>
			<h4>Top 3 Highest Paying Occupations for your Field of Study</h4>
			<table class="table table-responsive, table-condensed">
				<thead>
				<tr>
					<th colspan="2">Bachelors</th>
					<th colspan="2">Masters</th>
				</tr>
				</thead>
				<tbody style="text-align:left">
				<tr>
					<th> Occupation </th>
					<th> Lifetime Earnings </th>
					<th> Occupation </th>
					<th> Lifetime Earnings </th>
				</tr>
				<tr>
					<td><%=rs9.getString("Occupation") %></td>
					<td><%=rs9.getString("B_SWE") %></td>
					<td><%=rs10.getString("Occupation") %></td>
					<td><%=rs10.getString("M_SWE") %></td>
				</tr>
				<% rs9.next(); rs10.next();%>
				<tr>
					<td><%=rs9.getString("Occupation") %></td>
					<td><%=rs9.getString("B_SWE") %></td>
					<td><%=rs10.getString("Occupation") %></td>
					<td><%=rs10.getString("M_SWE") %></td>
				</tr>
				<% rs9.next(); rs10.next();%>
				<tr>
					<td><%=rs9.getString("Occupation") %></td>
					<td><%=rs9.getString("B_SWE") %></td>
					<td><%=rs10.getString("Occupation") %></td>
					<td><%=rs10.getString("M_SWE") %></td>
				</tr>
				<% rs9.next(); rs10.next();%>
				</tbody>
			</table>
		</div>
	</div>
</div>
</div>
<%


//Send Query if not null
if(CollegeState != "" && MaxTuition !=""){
	String tuitiontype = "OutState";
	if(CollegeState.equals(state)){
		tuitiontype = "InState";
	}
	
	q12 = "SELECT c.INSTNM,c."+tuitiontype+"GradTut as Tuition From College c WHERE c.STABBR = \""+ 
	state + "\" and c.InStateGradTut <= " + MaxTuition +" and c."+tuitiontype+
	"GradTut <> 0 ORDER BY c."+tuitiontype+"GradTut ASC LIMIT 10;";
	the_statement = con.prepareStatement(q12);
	ResultSet rs12 = the_statement.executeQuery();
	rs1.next();
	out.print("<h4>Cheapest colleges which fit your max tuition request</h4>");
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
	while(rs12.next()){
		out.print("<tr>");
		//make a column
		out.print("<td>");
		//print out column header
		out.print(rs12.getString("INSTNM"));
		out.print("</td>");
		//make a column
		out.print("<td>");
		out.print(rs12.getString("Tuition"));
		out.print("</td>");
		out.print("</tr>");
	}
	out.print("</table>");
}
 %>
<!-- Section For Graduate School Information -->
<div class="panel panel-default">
<div class="container-fuild" style="text-align:center; margin:auto">
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
			<h4>The estimated Opportunity cost for going to Graduate School with your Major and State is <b>$<%=rs11.getString("OC") %></b> which will take on average <b><%=rs11.getString("YearsToMakeUPOC") %></b> years to make up</h4>
		</div>
	</div>
	<div class="row">
		<div class="col-md-12">
			<hr>
			<h4>Average Tuition</h4>
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
<div class="container-fluid" style="text-align:center">
	<div class="row">
		<div class="col-md-6">
			<h4>Median Annual Wages for Similar Majors</h4>
			<div id="chart3"></div>
		</div>
		<div class="col-md-6">
			<h4>Median Annual Wages for Major Groups</h4>
			<div id="chart2"></div>	
		</div>
	</div>
	<div class="row">
		<div class="col-md-6">
			<h4>Average Annual Wages For Occupations with the  Major <%=major %> by State</h4>
			<div id="chart4"></div>	
		</div>
		<div class="col-md-6">
			<h4>Undergraduate versus Graduate Wages for <%=major %> Majors</h4>
			<div id="chart5"></div>	
			<h4>You will break even in <%=xinter%> years</h4>
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