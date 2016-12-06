<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.awt.*"%>
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

public double intersectx(double Slope1,double Slope2, double b1, double b2){
	double year = (b2 - b1)/(Slope1-Slope2);
	return year;
}



public Map<String, String> getLineChart(double Slope1, double Slope2, double Start){
	JSONObject ChartElements = new JSONObject();
	
    ChartElements.put("paletteColors", "#0075c2,#1aaf5d");
    ChartElements.put("bgcolor", "#ffffff");
    ChartElements.put("showBorder", "0");
    ChartElements.put("showShadow", "0");
    ChartElements.put("showCanvasBorder", "0");
    ChartElements.put("usePlotGradientColor", "0");
    ChartElements.put("legendBorderAlpha", "0");
    ChartElements.put( "legendShadow", "0");
    ChartElements.put("showAxisLines", "0");
    ChartElements.put("showAlternateHGridColor", "0");
    ChartElements.put("divlineThickness", "1");
    ChartElements.put("divLineIsDashed", "1");
    ChartElements.put("divLineDashLen", "1");
    ChartElements.put("divLineGapLen", "1");
    ChartElements.put("xAxisName", "Years");
    ChartElements.put("yAxisMinValue", "-1000000");
    ChartElements.put("showValues", "0");
   
    
    JSONObject CategoryElements1 = new JSONObject();
    CategoryElements1.put("label", "0");   
    JSONObject CategoryElements2 = new JSONObject();
    CategoryElements2.put("label", "2"); 
    JSONObject CategoryElements3 = new JSONObject();
    CategoryElements3.put("label", "4"); 
    JSONObject CategoryElements4 = new JSONObject();
    CategoryElements4.put("label", "6");    
    JSONObject CategoryElements5 = new JSONObject();
    CategoryElements5.put("label", "8");
    JSONObject CategoryElements6 = new JSONObject();
    CategoryElements6.put("label", "10");
    JSONObject CategoryElements7 = new JSONObject();
    CategoryElements7.put("label", "12");
    JSONObject CategoryElements8 = new JSONObject();
    CategoryElements8.put("label", "14");
 
    
    JSONArray CategoryArray = new JSONArray();
    CategoryArray.add(CategoryElements1);
    CategoryArray.add(CategoryElements2);
    CategoryArray.add(CategoryElements3);
    CategoryArray.add(CategoryElements4);
    CategoryArray.add(CategoryElements5);
    CategoryArray.add(CategoryElements6);
    CategoryArray.add(CategoryElements7);
    CategoryArray.add(CategoryElements8);
    
    JSONObject CategoryObject = new JSONObject();
    CategoryObject.put("category",CategoryArray);
    
   JSONArray CategoriesArray = new JSONArray();
   CategoriesArray.add(CategoryObject);
   
   JSONObject data1 = new JSONObject();
   data1.put("value","0");
   JSONObject data2 = new JSONObject();
   data2.put("value",Double.toString(Slope1*2));
   JSONObject data3 = new JSONObject();
   data3.put("value",Double.toString(Slope1*4));
   JSONObject data4 = new JSONObject();
   data4.put("value",Double.toString(Slope1*6));
   JSONObject data5 = new JSONObject();
   data5.put("value",Double.toString(Slope1*8));
   JSONObject data6 = new JSONObject();
   data6.put("value",Double.toString(Slope1*10));
   JSONObject data7 = new JSONObject();
   data7.put("value",Double.toString(Slope1*12));
   JSONObject data8 = new JSONObject();
   data8.put("value",Double.toString(Slope1*14));
 
   //Grad
   JSONObject data9 = new JSONObject();
   data9.put("value",0);
   JSONObject data10 = new JSONObject();
   data10.put("value",Double.toString(Start*2));
   JSONObject data11 = new JSONObject();
   data11.put("value",Double.toString(Start*2 + Slope2*2));
   JSONObject data12 = new JSONObject();
   data12.put("value",Double.toString(Start*2 + Slope2*4));
   JSONObject data13 = new JSONObject();
   data13.put("value",Double.toString(Start*2 + Slope2*6));
   JSONObject data14 = new JSONObject();
   data14.put("value",Double.toString(Start*2 + Slope2*8));
   JSONObject data15 = new JSONObject();
   data15.put("value",Double.toString(Start*2 + Slope2*10));
   JSONObject data16 = new JSONObject();
   data16.put("value",Double.toString(Start*2 + Slope2*12));
   
  
   
   JSONArray dataArr1 = new JSONArray();
   
   dataArr1.add(data1);
   dataArr1.add(data2);
   dataArr1.add(data3);
   dataArr1.add(data4);
   dataArr1.add(data5);
   dataArr1.add(data6);
   dataArr1.add(data7);
   dataArr1.add(data8);
  
   JSONArray dataArr2 = new JSONArray();
   dataArr2.add(data9);
   dataArr2.add(data10);
   dataArr2.add(data11);
   dataArr2.add(data12);
   dataArr2.add(data13);
   dataArr2.add(data14);
   dataArr2.add(data15);
   dataArr2.add(data16);
   
   JSONObject DataSet1 = new JSONObject();
   DataSet1.put("seriesname","Undergraduate Net Worth");
   DataSet1.put("data",dataArr1);
   JSONObject DataSet2 = new JSONObject();
   DataSet2.put("seriesname","Graduate Net Worth");
   DataSet2.put("data",dataArr2);
   
   JSONArray DataSetArr = new JSONArray();
   DataSetArr.add(DataSet1);
   DataSetArr.add(DataSet2);
   
   Map<String, String> dataMap = new LinkedHashMap<String, String>();
   dataMap.put("chart",ChartElements.toString());
   dataMap.put("categories",CategoriesArray.toString());
   dataMap.put("dataset",DataSetArr.toString());
	 return dataMap;
}
%>