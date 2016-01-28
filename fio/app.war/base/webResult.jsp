<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/base/include/ArchJsp.jspf" %>

<link href="<%= request.getContextPath() %>/base/css/cni.css" rel="stylesheet" type="text/css">
<b>[결과코드]:</b> 
<br>
<%= com.cni.fw.web.util.HtmlUtil.normalize(getResultCode(request)) %>
<br>
<br>
<b>[결과메시지]: </b> 
<br>
<%= com.cni.fw.web.util.HtmlUtil.normalize(getResultMessage(request)) %>
<br>
<br>
<b>[결과데이타]:</b> 
<br>
<%= com.cni.fw.web.util.HtmlUtil.normalize(getEffectDTO(request)) %>
<br>
<br>
<b>[입력데이타]:</b> 
<br>
<%= com.cni.fw.web.util.HtmlUtil.normalize(getCauseDTO(request)) %>
<br>
<br>
<%
	debug("=== Nexter 1");
	EffectDTO effect = getEffectDTO(request);
	Nexter nx = effect.getNexterMTO();
	while (nx.hasNext()) {
		String mtoName = nx.next();
		debug(mtoName);
		debug(effect.getMTO(mtoName));
	}
	
	debug("=== Nexter 2");
	
	nx = effect.getSortedNexterMTO();
	while (nx.hasNext()) {
		String mtoName = nx.next();
		debug(mtoName);
		debug(effect.getMTO(mtoName));
	}
%>
 