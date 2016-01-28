<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/base/include/ArchJsp.jspf" %>
<link href="<%= request.getContextPath() %>/base/css/cni.css" rel="stylesheet" type="text/css">
<html>
<script>
window.onload = function() {
(document.body.scrollHeight) ? window.scrollTo(0, document.body.scrollHeight) : window.scrollTo(0, document.body.height);
}
</script>
<body>
<%
	String txId = input.get("txId");
%>
<pre>
<%= HtmlUtil.convertLT(output.get("logTracking")) %>
</pre>
<b>■■■■■■■■■■■■■■■■■■■■■■■■ 로그 추적 완료 ■■■■■■■■■■■■■■■■■■■■■■■■</b> 
<br>
<br>
<% 
	if (LongMaker.make(txId,0) == 0) {
%>
<b>TX-ID : <font color=red><%= txId %></font></b> 
<%
	} else {
%>
<b>Last Log : <font color=red><%= txId %> </font> Byte</b> 
<%  } %>
<br>
</body>
</html>