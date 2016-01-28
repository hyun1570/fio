<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/base/include/ArchJsp.jspf" %>
<html>
<head>
<title>DAFrame - Dongbu CNI J2EE Application Framework</title>
</head>
<frameset frameborder="NO" border="0" framespacing="0" name="main">
	<frame id="console" name="console" src="<%= request.getContextPath() %>/base/ADM000.A01.cmd" >
</frameset>
</html>
