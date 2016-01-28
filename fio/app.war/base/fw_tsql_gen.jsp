<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/base/include/ArchJsp.jspf" %>

<link href="<%= request.getContextPath() %>/base/css/cni.css" rel="stylesheet" type="text/css">

<%
	if (output != null) {
		if (output.getCode().equals("GEN-OK")) {
%>
<script>
		alert("TSQL 소스생성을 완료하였습니다.");
</script>
<%			
		}
	}
%>

<pre>
<%= output.get("TSQL-Sample") %>
</pre>
