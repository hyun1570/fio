<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/base/include/ArchJsp.jspf" %>
<%@page import="com.cni.fw.ff.common.SystemInfo"%>

<%@page import="java.util.Iterator"%>
<link href="<%= request.getContextPath() %>/base/css/cni.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="<%= request.getContextPath() %>/base/js/daf.js"></script>

<script type="text/javascript">
	function reset1() {
		if (confirm('Framework.conf 및 Application.conf를 리로드합니다. 계속 진행하시겠습니까?') == true) {
		 	window.document.hotForm.action = "ADM001.A02.cmd";
		 	window.document.hotForm.config.value = "conf";
		 	window.document.hotForm.submit();
	 	}
	}
	
	function reset2() {
		if (confirm('Log.conf를 리로드합니다. 계속 진행하시겠습니까?') == true) {
		 	window.document.hotForm.action = "ADM001.A02.cmd";
		 	window.document.hotForm.config.value = "log";
		 	window.document.hotForm.submit();
	 	}
	}
	
	function reset3() {
		if (confirm('Message.conf를 리로드합니다. 계속 진행하시겠습니까?') == true) {
		 	window.document.hotForm.action = "ADM001.A02.cmd";
		 	window.document.hotForm.config.value = "msg";
		 	window.document.hotForm.submit();
	 	}
	}
	
	function reset4() {
		if (confirm('CommonCacheManager를 통해 캐쉬한 정보를 리로드합니다. 계속 진행하시겠습니까?') == true) {
		 	window.document.hotForm.action = "ADM001.A02.cmd";
		 	window.document.hotForm.config.value = "cache";
		 	window.document.hotForm.submit();
	 	}
	}
	
	function reset5() {
		if (confirm('메타데이타를 리로드합니다. 계속 진행하시겠습니까?') == true) {
		 	window.document.hotForm.action = "ADM001.A02.cmd";
		 	window.document.hotForm.config.value = "meta";
		 	window.document.hotForm.submit();
	 	}
	}
	
	function reset6() {
		if (confirm('JAVA CLASS를 리로드합니다. 계속 진행하시겠습니까?') == true) {
		 	window.document.hotForm.action = "ADM001.A02.cmd";
		 	window.document.hotForm.config.value = "class";
		 	window.document.hotForm.submit();
	 	}
	}
	
	function reset7() {
		if (confirm('핫디플로이 가능한 모든 요소를 리로드합니다. 계속 진행하시겠습니까?') == true) {
		 	window.document.hotForm.action = "ADM001.A02.cmd";
		 	window.document.hotForm.config.value = "all";
		 	window.document.hotForm.submit();
	 	}
	}
</script>

<form id="hotForm" name="hotForm" action="ADM001.A02.cmd" method="POST">
	<input id="config"  name="config" type="hidden" />
</form>

<%
	MTO fwConf = output.getMTO("FW_CONF");
	MTO apConf = output.getMTO("AP_CONF");
%>
<b>* DAFrame Hot-Deploy <font color=red>[운영중에는 주의해서 사용하십시요]</font></u></b>
<br>
<br>
<table border="0" cellpadding="2" cellspacing="1" bgcolor="B5D5E2">
	<tr>
		<td><input type="button" value="CONF"  title="Framework.conf 및 Application.conf를 리로드합니다." onclick="reset1();" /></td>
		<td><input type="button" value="LOG" title="Log.conf를 리로드합니다."  onclick="reset2();" /></td>
		<td><input type="button" value="MSG" title="Message.conf를 리로드합니다."  onclick="reset3();" /></td>
		<td><input type="button" value="CACHE" title="CommonCacheManager를 통해 캐쉬한 정보를 리로드합니다."  onclick="reset4();" /></td>
		<td><input type="button" value="META" title="메타데이타를 리로드합니다." onclick="reset5();" /></td>
		<td><input type="button" value="CLASS" title="JAVA CLASS를 리로드합니다."  onclick="reset6();" /></td>
		<td><input type="button" value="*FULL*"  title="핫디플로이 가능한 모든 요소를 리로드합니다." onclick="reset7();" /></td>
	</tr>
</table>
<br>
<br>
&nbsp;상황에 따라 선택적으로 핫디플로이를 실행할 수 있습니다. 필요시 상기의 버튼을 눌러 진행하십시요.
<br>
<hr>
<b>* DAFrame Configuration 정보 (Framework.conf)</u></b>
<table width="500" border="0" cellpadding="2" cellspacing="1" bgcolor="B5D5E2">
<% 
	Nexter nx = fwConf.getSortedNexter();

	String key = null;
	String value = null;
	while (nx.hasNext()) {
		key = nx.next();
		value = fwConf.get(key);
%>
	<tr>
		<td bgcolor="EAF3F8" align=left width=40%><%= key %></td>
		<td bgcolor="FFFFFF" align=left><%= HtmlUtil.normalize(value) %></td>
	</tr>
<%
	}
%>
</table>
<br>
<hr>
<b>* 사용자 지정 Properties 정보 (Application.conf)</u></b>
<table width="500" border="0" cellpadding="2" cellspacing="1" bgcolor="B5D5E2">
<% 
	nx = apConf.getSortedNexter();

	while (nx.hasNext()) {
		key = nx.next();
		value = apConf.get(key);
%>
	<tr>
		<td bgcolor="EAF3F8" align=left width=40%><%= key %></td>
		<td bgcolor="FFFFFF" align=left><%= HtmlUtil.normalize(value) %></td>
	</tr>
<%
	}
%>
</table>
<br>