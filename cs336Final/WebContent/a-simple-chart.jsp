<%-- 
    Document   : a-simple-chart
    Author     : sguha
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>A Simple Chart</title>
<!-- Step 1: Include the `fusioncharts.js` file. This file is needed to
        render the chart. Ensure that the path to this JS file is correct.
        Otherwise, it may lead to JavaScript errors.
-->
        </head>
    <body>
        <div id="chart"></div>
<!--    Step 2: Include the `FusionCharts.java` file as a package in your 
        project.
-->        
        <%@page import="fusioncharts.FusionCharts" %>
        
<!--    Step 3:Include the package in the file where you want to show 
        FusionCharts as follows.
        
        Step 4: Create a chart object using the FusionCharts JAVA class 
        constructor. Syntax for the constructor: 
        `FusionCharts("type of chart", "unique chart id", "width of chart",
                        "height of chart", "div id to render the chart", 
                        "data format", "data source")`   
-->        
        <% 
            
            FusionCharts lineChart = new FusionCharts(
                        "column2d",// chartType
                        "ex1",// chartId
                        "600","400",// chartWidth, chartHeight
                        "chart",// chartContainer
                        "json",// dataFormat
                        // dataSource
                        "{\"chart\":{\"caption\":\"Harry\'sSuperMart\",\"subCaption\":\"Top5storesinlastmonthbyrevenue\",\"numberPrefix\":\"$\",\"theme\":\"ocean\"			},			\"data\":			[{\"label\":\"BakersfieldCentral\",\"value\":\"880000\"				},				{\"label\":\"GardenGrooveharbour\",\"value\":\"730000\"				},				{\"label\":\"LosAngelesTopanga\",\"value\":\"590000\"				},				{\"label\":\"Compton-RanchoDom\",\"value\":\"520000\"	},	{\"label\":\"DalyCitySerramonte\",\"value\":\"330000\"	}]}"
                    );
        %>
<!--    Step 5: Render the chart    -->        
        <%=lineChart.render()%>
    </body>
</html>
