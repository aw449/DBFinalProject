<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="fusioncharts.FusionCharts" %>
<%@ page import="com.google.gson.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<script type="text/javascript" src="http://static.fusioncharts.com/code/latest/fusioncharts.js"></script>
<script type="text/javascript" src="http://static.fusioncharts.com/code/latest/fusioncharts.charts.js"></script>
<script type="text/javascript" src="http://static.fusioncharts.com/code/latest/themes/fusioncharts.theme.ocean.js"></script>
<title>TEST PAGE</title>
</head>
<body>
<div id="chart"></div>

<%
	String url = "jdbc:mysql://masters.cqxrbwnqjcdx.us-east-1.rds.amazonaws.com:3306/innodb";
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection(url, "woleng", "analmaDB");
	Statement stmt = con.createStatement();
	
	String major = request.getParameter("Majors");
	String state = request.getParameter("States");
	out.println("Major: " + major);
	out.println("State: " + state);
	
	String query = "SELECT Major_Subgroup, avg(Median_Annual_Wages) as Median_Annual_Wages FROM Major GROUP BY Major_Subgroup ORDER BY Median_Annual_Wages ASC LIMIT 5";
	
	 Gson gson = new Gson();
	 PreparedStatement the_statement = con.prepareStatement(query);
	 ResultSet result = the_statement.executeQuery();
	 
	 Map<String, String> chartobj = new HashMap<String, String>();
     
     chartobj.put("caption" , "Top 5 Majors with Highest Median Annual Wages");
     chartobj.put("paletteColors" , "#0075c2");
     chartobj.put("bgColor" , "#ffffff");
     chartobj.put("borderAlpha", "20");
     chartobj.put("canvasBorderAlpha", "0");
     chartobj.put("usePlotGradientColor", "0");
     chartobj.put("plotBorderAlpha", "10");
     chartobj.put("showXAxisLine", "1");
     chartobj.put("xAxisLineColor" , "#999999");
     chartobj.put("showValues" , "0");
     chartobj.put("divlineColor" , "#999999");
     chartobj.put("divLineIsDashed" , "1");
     chartobj.put("showAlternateHGridColor" , "0");

     ArrayList data = new ArrayList();
     
     while(result.next()){
    	 Map<String, String> lv = new HashMap<String, String>();
    	  lv.put("label", result.getString("Major_Subgroup"));
          lv.put("value", result.getString("Median_Annual_Wages"));
          data.add(lv);      
     }
     
     result.close();
     
     Map<String, String> dataMap = new LinkedHashMap<String, String>();  
     
     dataMap.put("chart", gson.toJson(chartobj));
     dataMap.put("data", gson.toJson(data));
     
     FusionCharts bar2DChart = new FusionCharts(
             "bar2d",// chartType
             "chart1",// chartId
             "600","400",// chartWidth, chartHeight
             "chart",// chartContainer
             "json",// dataFormat
             gson.toJson(dataMap) //dataSource
         );
%>
       <%=bar2DChart.render()%>
</body>
</html>