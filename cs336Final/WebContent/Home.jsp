<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
<!-- Optional theme -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp" crossorigin="anonymous">
<!-- Latest compiled and minified JavaScript -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
<script type="text/javascript" src="jquery-3.1.1.min.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		$('#advanced_options_button').click(function(){
			$('#advanced_options').toggle();
			
			if($('#advanced_options').is(':visible')){
				$('#submit_button').attr('action','advResults.jsp');
			}
			else{
				$('#submit_button').attr('action','Results.jsp');
			}
		});
	});
</script>
<title>Masters or Job?</title>
</head>
<body>
<ul class="nav nav-tabs">
  <li class="active"><a data-toggle="tab" href="#home">Basic Search</a></li>
  <li><a data-toggle="tab" href="#Compare">Compare Schools</a></li>
  <li><a href="javascript:void(0)">Compare Majors</a></li>
  <li><a href="javascript:void(0)">Job Search</a></li>
</ul>

<div class="tab-content">
<div id="home" class="tab-pane fade in active">
<div class = "jumbotron">
<h1>Masters or Job</h1>
<h3>Should I get a masters degree or go straight into industry?</h3>
<form id="submit_button" method="get" action="Results.jsp" enctype=text/plain>
<p>
I graduated with a degree in <jsp:include page="majordropdown.jsp"/> and went to school in <jsp:include page="statedropdown.jsp"/> 
<input type="submit" value="submit"/>
</p>
<button type="button" id="advanced_options_button">Advanced Options</button>
<div style="display:none" id ="advanced_options">
	<jsp:include page="advancedoptions.jsp"></jsp:include>
</div>
</form>
</div>
</div>


<div id="Compare" class="tab-pane fade">
<div class ="jumbotron">
<h1>Masters or Job</h1>
<h3>Should I get a masters degree or go straight into industry?</h3>
<form id="submit_button" method="get" action="Results.jsp" enctype=text/plain>
<p>
I graduated with a degree in <jsp:include page="majordropdown.jsp"/> and went to school in <jsp:include page="statedropdown.jsp"/> 
<input type="submit" value="submit"/>
</p>
<button type="button" id="advanced_options_button">Advanced Options</button>
<div style="display:none" id ="advanced_options">
	<jsp:include page="advancedoptions.jsp"></jsp:include>
</div>
</div>
</form>
</div>

</div>

</body>
</html>