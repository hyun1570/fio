<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/base/include/ArchJsp.jspf" %>

<SCRIPT LANGUAGE="JavaScript">
	alert("<%= getResultMessage(request) %> ");
	history.go(-1);
</SCRIPT>

