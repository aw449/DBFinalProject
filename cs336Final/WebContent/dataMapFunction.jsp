<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.google.gson.*" %>

<%!

public Map<String, String> getDataMap(Connection con, String query, String xlabel, String ylabel){
	try{
 		Map<String, String> chartobj = new HashMap<String, String>();
        
		Statement stmt = con.createStatement();
		PreparedStatement the_statement = con.prepareStatement(query);
		ResultSet rs = the_statement.executeQuery();
        Gson gson = new Gson();
        
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
        ArrayList arrData = new ArrayList();
        while(rs.next())
        {
            Map<String, String> lv = new HashMap<String, String>();
            lv.put("label", rs.getString(xlabel));
            lv.put("value", rs.getString(ylabel));
            arrData.add(lv);             
        }
        rs.close();
        Map<String, String> dataMap = new LinkedHashMap<String, String>();         
        dataMap.put("chart", gson.toJson(chartobj));
        dataMap.put("data", gson.toJson(arrData));
		return dataMap;
	} catch (Exception e){
		System.out.println("Could not retrieve dataMap - Exception: "+ e);
		return null;
		}
}

%>