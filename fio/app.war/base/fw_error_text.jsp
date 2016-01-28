<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/base/include/ArchJsp.jspf" %>
<link href="<%= request.getContextPath() %>/base/css/cni.css" rel="stylesheet" type="text/css">
<font color=red>처리중 오류가 발생했습니다.</font>
<br>
<% 
	debug(input.getCommand());
	
	String tx = null;
	String code = null;
	String msg = null;
	String detailMsg = null;
	
	if (output != null) {
		tx = output.getTxId();
		code = getResultCode(request);
		msg = HtmlUtil.normalize(getResultMessage(request)); 
		detailMsg =	HtmlUtil.normalize(output.getStackTrace());
	} else {
			code = "E001";
			msg = "내부 오류가 발생하였습니다.";
			detailMsg = "콘솔 로그를 확인해주십시요.";
	}
%>
<br>
<b>트랜잭션ID :</b> <%= tx %>
<br>
<b>에러코드 :</b><font color=red> <%= code %></font>
<br>
<b>에러메시지 :</b><%= msg %>
<br>
<b>상세메시지 :</b>
<br>
<%= detailMsg %>

