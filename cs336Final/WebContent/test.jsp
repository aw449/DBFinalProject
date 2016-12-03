<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,javax.sql.*,javax.sql.rowset.*,com.sun.rowset.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="fusioncharts.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<!-- <script type="text/javascript" src="FusionCharts/js/fusioncharts.js"></script>
	<script type="text/javascript" src="FusionCharts/jsfusioncharts.charts.js"></script>
	<script type="text/javascript" src="FusionCharts/js/themes/fusioncharts.theme.ocean.js"></script>
	 -->
	 <script type="text/javascript" src="http://static.fusioncharts.com/code/latest/fusioncharts.js"></script>
        <script type="text/javascript" src="http://static.fusioncharts.com/code/latest/fusioncharts.charts.js"></script>
        <script type="text/javascript" src="http://static.fusioncharts.com/code/latest/themes/fusioncharts.theme.ocean.js"></script>
    <script type="text/javascript" src="jquery-3.1.1.min.js"></script>
	
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
	
	String query = "SELECT MAJOR_SUBGROUP,MEDIAN_ANNUAL_WAGES FROM Majors limit 5";
	
	 PreparedStatement the_statement = con.prepareStatement(query);
	 ResultSet result = the_statement.executeQuery();
	 WebRowSet xmlConvert = new WebRowSetImpl();
	 java.io.FileWriter writer =
			    new java.io.FileWriter("xmlConvert.xml");
	 xmlConvert.writeXml(result, writer);
	writer.flush();	 
	out.println(writer.toString());
	
	BufferedReader br = new BufferedReader(new FileReader(new File("xmlConvert.xml")));
	String line;
	StringBuilder sb = new StringBuilder();

	while((line=br.readLine())!= null){
	    sb.append(line.trim());
	}
	
	FusionCharts lineChart = new FusionCharts(
            "column2d",// chartType
            "ex1",// chartId
            "600","400",// chartWidth, chartHeight
            "chart2",// chartContainer
            "xmlurl",// dataFormat
            // dataSource
			"xmlConvert.xml"
			);
	    
	%>
	<%=lineChart.render() %>
	<div id="chart2"></div>
	
<%
	br.close();	
	xmlConvert.close();
	writer.close();
	con.close();	 
%>
</body>
</html>