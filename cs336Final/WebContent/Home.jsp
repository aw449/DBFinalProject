<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Masters or Job?</title>
</head>
<body>
<h1>Masters or Job</h1>
<h3>Should I get a masters degree or go straight into industry?</h3>
<form method="get" action="test.jsp" enctype=text/plain>
<p>
I graduated with a degree in <jsp:include page="majordropdown.jsp"/> and went to school in <jsp:include page="statedropdown.jsp"/> 
<input type="submit" value="submit"/>
</p>
</form>
</body>
</html>