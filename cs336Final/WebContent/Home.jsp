<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
<!-- Optional theme -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp" crossorigin="anonymous">
<!-- Latest compiled and minified JavaScript -->
<script type="text/javascript" src="jquery-3.1.1.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
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
<div class = "container-fluid">
	<ul class="nav nav-tabs">
	  <li class="active"><a data-toggle="tab" href="#home">Basic Search</a></li>
	  <li><a data-toggle="tab" href="#comparemaj">Compare Majors</a></li>
	  <li><a data-toggle="tab" href="#compareschool">Compare School</a></li>
	  
	</ul>

	<div class="tab-content">
		<div id="home" class="tab-pane fade in active">
			<div class = "jumbotron">
				<h1>Masters or Job</h1>
				<h3>Should I get a masters degree or go straight into industry?</h3>
				<form id="submit_button" method="get" action="Results.jsp" enctype=text/plain >
				<p>
				I graduated with a degree in <jsp:include page="majordropdown.jsp"/> and live in <jsp:include page="statedropdown.jsp"/> 
				<input type="submit" class="btn btn-default" value="submit"/>
				</p>
				<button type="button" class="btn btn-info" id="advanced_options_button">Advanced Options</button>
				<div style="display:none" id ="advanced_options">
					<jsp:include page="advancedoptions.jsp"></jsp:include>
				</div>
				</form>
			</div>
		</div>


		<div id="comparemaj" class="tab-pane fade">
			<div class ="jumbotron">
				
				<h1>Compare Majors</h1>
				<h3>Not All Majors are Created Equal</h3>
				<form id="submit_button2" method="get" action="Compare.jsp" enctype=text/plain>
				
				<div class="container-fluid" style="margin:auto">
					<div class="row">
						<div class="col-md-6">
							<h4>Major 1</h4> <jsp:include page="major1dropdown.jsp"/>
						</div>
						<div class="col-md-6">
							<h4>Major 2</h4> <jsp:include page="major2dropdown.jsp"/> 
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<h5>Desired Lifetime Earnings: <input type="number" name="Lifetime_Earnings" value=""><br></h5>
						</div>
					</div>
					<div class="row">
						<div class="col-md-6">
							<h5>Limit Results: <input type="number" name="Limit" value=""></h5>
						</div>
						<div class="col-md-6">
							<h5>Order: 
							<select name="Order">
								<option value="DESC">Descending</option>
								<option value="ASC">Ascending</option>
							</select>
							</h5>
						</div>
					</div>
				</div>
				<br>
				<input type="submit" value="submit" class="btn btn-default" />
				</form>
			</div>
		</div>
		
		<div id="compareschool" class="tab-pane fade">
			<div class ="jumbotron">
				
				<h1>Compare School</h1>
				<h3>My School is Better than Yours</h3>
				<form id="submit_button3" method="get" action="CompareSchoolsRes.jsp" enctype=text/plain>
				
				<div class="container-fluid" style="margin:auto">
					<div class="row">
						<div class="col-md-6">
							<h4>School 1</h4> <jsp:include page="school1dropdown.jsp"/>
						</div>
						<div class="col-md-6">
							<h4>School 2</h4> <jsp:include page="school2dropdown.jsp"/> 
						</div>
					</div>
					<br>
					
				</div>
				<br>
				<input type="submit" value="submit" class="btn btn-default" />
				</form>
			</div>
		</div>
	</div>
</div>
</body>
</html>