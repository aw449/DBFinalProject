<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.google.gson.*" %>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
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

public Map<String, String> getStateMap(Connection con, String query, String xlabel, String ylabel){
	try{
 		
		//Map<String, String> chartobj = new HashMap<String, String>();
		Statement stmt = con.createStatement();
		PreparedStatement the_statement = con.prepareStatement(query);
		ResultSet rs = the_statement.executeQuery();
        Gson gson = new Gson();
     
       
        JSONObject chartobj = new JSONObject();

        
        JSONObject ChartElements = new JSONObject();
        ChartElements.put("entityFillHoverColor", "#cccccc");
        ChartElements.put("numberPrefix", "$");
        ChartElements.put("showLabels", "1");
        
        
        
        JSONObject ColorRangeElements = new JSONObject();
      //  ColorRangeElements.put("minvalue", "0");
        ColorRangeElements.put("startlabel", "Low");
        ColorRangeElements.put("endlabel", "High");
        ColorRangeElements.put("code", "#FB8FFB");
        ColorRangeElements.put("gradient", "1");
       // ColorRangeElements.put("endlabel", "High");
        
 		
        // chartobj.put("chart", ChartElements);
        //chartobj.put("colorrange",ColorRangeElements);
        
       
      
        ArrayList arrData = new ArrayList();
        while(rs.next())
        {
            Map<String, String> lv = new HashMap<String, String>();
            lv.put("id", rs.getString(xlabel));
            lv.put("value", rs.getString(ylabel));
            arrData.add(lv);             
        }
        rs.close();
        Map<String, String> dataMap = new LinkedHashMap<String, String>();         
        dataMap.put("chart", ChartElements.toString() );
        dataMap.put("colorrange", ColorRangeElements.toString() );
        dataMap.put("data", gson.toJson(arrData));
		return dataMap;
	} catch (Exception e){
		System.out.println("Could not retrieve dataMap - Exception: "+ e);
		return null;
		}
}

%>