<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/base/include/ArchJsp.jspf" %>
<%@page import="com.cni.fw.ff.common.SystemInfo"%>

<%@page import="java.util.Iterator"%>
<link href="<%= request.getContextPath() %>/base/css/cni.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="<%= request.getContextPath() %>/base/js/daf.js"></script>

<%
	LTO StatLTO = output.getLTO("StatLTO");
	LTO CpuLTO = output.getLTO("CpuLTO");
	MTO svInfo = output.getMTO("SystemInfo");
	MTO mmInfo = output.getMTO("MemInfo");
	MTO txInfo = output.getMTO("RunInfo");
	LTO userInfo = output.getLTO("UserInfo");
	LTO eventInfo = output.getLTO("EventInfo");
%>

<form id="trackForm" name="trackForm" action="ADM001.A05.cmd" method="post" target="_blank" >	
	<input id="txId" name="txId" type='hidden' size='25' />
</form>

<form id="downloadForm" name="downloadForm" action="ADM001.A06.cmd" method="post">	
</form>

<form id="clearStatForm" name="clearStatForm"  action="ADM001.A02.cmd" method="post" >	
	<input id="config" name="config" type='hidden' size='25' value='stat' />
</form>

<form id="gcForm" name="gcForm"  action="ADM001.A08.cmd" method="post" >	
	<input id="cmd" name="cmd" type='hidden' size='25' value='gc' />
</form>

<script>

/// 이벤트 핸들러

function viewLog(tx) {
	trackForm.txId.value = tx;
	trackForm.submit();
}

function downloadList() {
	if (confirm('대량의 로그가 쌓인 경우 시스템에 부하를 줄수 있습니다. 이용 집중 시간에는 실행을 권장할지 않습니다. 계속 진행하시겠습니까?') == true) {
		downloadForm.submit();
	}
}

function clearStat() {
	if (confirm('Event 처리 통계 및 Exception 발생 통계를 모두 초기화합니다. 계속 진행하시겠습니까?') == true) {
	 	clearStatForm.submit();
 	}
}

function forceGC() {
	if (confirm('강제로 GC(Gabage Collection)을 실시합니다. 운영시 때때로 장애를 유발할 수 있어 주의하시기 바랍니다. 아울러 WAS 특성이나 설정에 따라 강제GC가 실행되지 않을 수도 있습니다. 계속 진행하시겠습니까?') == true) {
		gcForm.submit();
 	}
}
	
</script>
<b>&nbsp;* DAFrame Version : <font color=blue><%= SystemInfo.getVersion() %></font> </b>[Server Time : <b><%= svInfo.get("ServerTime") %></b>] 
<br>
<br>
<table border="0" cellpadding="2" cellspacing="1" bgcolor="B5D5E2">
	<tr>
		<td><input id="downBtn" type="button" value="예외내역 다운로드"  title="예외 발생 발생 현황 및 관련 로그를 다운로드합니다." onclick="downloadList();" /></td>
		<td><input type="button" value="통계정보 클리어" title="현재까지 수집된 예외 현황 및 통계정보를 모두 초기화 합니다."  onclick="clearStat();" /></td>
		<td><input type="button" value="강제 GC" title="강제로 GC(Gabage Collection)을 실시합니다."  onclick="forceGC();" /></td>
	</tr>
</table>
<br>
&nbsp;예외내역 전체 다운로드 및 통계정보 클리어, 강제 GC 등을 수행할 수 있습니다.
<br>
<!-- 재시작 정보 파트 -->
<hr>
<b>&nbsp;* 재시작 정보 및 HOT-Deploy 실행 정보 
<table width="610" border="0" cellpadding="2" cellspacing="1" bgcolor="B5D5E2" >
	<tr width="100%">
		<td bgcolor="EAF3F8">서버 재시작 시간</td>
		<td bgcolor="EAF3F8">최종 FULL HOT-Deploy 실시 시간</td>
	</tr>
	<tr>
		<td bgcolor="FFFFFF" align=left><b><font color=blue><%= SystemInfo.getRestartTime() %></font></b></td>
		<td bgcolor="FFFFFF" align=left><b><font color=red><%= SystemInfo.getHotDeployTime() %></font></b></td>
	</tr>
</table>
<br>

<!-- 익셉션 발생 내역 -->
<%
	if (eventInfo != null) {
%>
<hr>
<b>&nbsp;* Exception 발생 통계</b> <LABEL style='cursor : hand' onClick='funcToggleView("tblErrStat");' ><font color=blue>[-]</font></LABEL>
<table id="tblErrStat" name="tblErrStat" width="660" border="0" cellpadding="2" cellspacing="1" bgcolor="B5D5E2" >
	<tr width="100%">
		<td bgcolor="EAF3F8">CMD (1차)<LABEL style='cursor : hand' onClick='funcSort("S")'    order='DESC'>▲</LABEL></td>
		<td bgcolor="EAF3F8" align=right>발생 #<LABEL style='cursor : hand' onClick='funcSort("N")'    order='DESC'>▲</LABEL></td>
		<td bgcolor="EAF3F8" align=right>최종발생 User<LABEL style='cursor : hand' onClick='funcSort("S")'    order='DESC'>▲</LABEL></td>
		<td bgcolor="EAF3F8" align=right>최종발생 IP<LABEL style='cursor : hand' onClick='funcSort("S")'    order='DESC'>▲</LABEL></td>
		<td bgcolor="EAF3F8" align=right>최종발생 Time<LABEL style='cursor : hand' onClick='funcSort("N")'    order='DESC'>▲</LABEL></td>
		<td bgcolor="EAF3F8" align=left><b>최종발생 Tx<LABEL style='cursor : hand' onClick='funcSort("S")'    order='DESC'>▲</LABEL></b></td>
	</tr>
<%

	Iterator it = eventInfo.getIterator();
	int cnt = 0;

	while (it.hasNext()) {
		MTO eventUnit = (MTO) it.next();
		
		if (!StringMaker.make(eventUnit.get("lastErrorTxId")).equals("")) {
%>
	<tr>
		<td bgcolor="FFFFFF"><b><font color=red><%= eventUnit.get("command") %></td>
		<td bgcolor="FFFFFF" align=right><b><font color=red><%= eventUnit.get("totCntError") %></font></b></td>
		<td bgcolor="FFFFFF" align=right><%= StringMaker.make(eventUnit.get("lastErrorUser")) %></td>
		<td bgcolor="FFFFFF" align=right><%= StringMaker.make(eventUnit.get("lastErrorIp")) %></td>
		<td bgcolor="FFFFFF" align=right><%= StringMaker.make(eventUnit.get("lastErrorTime")) %></td>
		<td bgcolor="FFFFFF" align=left><b><font color=red><a href="#" onclick="viewLog('<%=StringMaker.make(eventUnit.get("lastErrorTxId")) %>');"><%= StringMaker.make(eventUnit.get("lastErrorTxId")) %></a></font></b></td>
	</tr>
<%
		cnt++;
		}
	}
	
	if (cnt == 0) {
%>
	<tr>
		<td colspan="6" bgcolor="FFFFFF">시스템 Exception 내역이 존재하지 않습니다.</td>
	</tr>
	</table>
	<script type="text/javascript">
		document.getElementById("downBtn").disabled = true;
	</script>
<%
	} else {
%>
	</table>
<%
	}
	}
%>

<!-- 이벤트 통계 파트 -->
<%
	if (eventInfo != null) {
%>
<hr>
<b>&nbsp;* Event 처리 통계 (Total <font color=blue><%= eventInfo.size() %></font> Event)</b> <LABEL style='cursor : hand' onClick='funcToggleView("tblEvtStat");' ><font color=blue>[+]</font></LABEL>
<table id="tblEvtStat" name="tblEvtStat" width="660" border="0" cellpadding="2" cellspacing="1" bgcolor="B5D5E2"  style='display:none;'>
	<tr width="100%">
		<td bgcolor="EAF3F8">CMD (1차)<LABEL style='cursor : hand' onClick='funcSort("S")'    order='DESC'>▲</LABEL></td>
		<td bgcolor="EAF3F8" align=right>평균<LABEL style='cursor : hand' onClick='funcSort("N")'    order='DESC'>▲</LABEL></td>
		<td bgcolor="EAF3F8" align=right>최장 (ms)<LABEL style='cursor : hand' onClick='funcSort("N")'    order='DESC'>▲</LABEL></td>
		<td bgcolor="EAF3F8" align=right>전체<LABEL style='cursor : hand' onClick='funcSort("N")'    order='DESC'>▲</LABEL></td>
		<td bgcolor="EAF3F8" align=right>에러<LABEL style='cursor : hand' onClick='funcSort("N")'    order='DESC'>▲</LABEL></td>
		<td bgcolor="EAF3F8" align=right>최종사용자<LABEL style='cursor : hand' onClick='funcSort("S")'    order='DESC'>▲</LABEL></td>
		<td bgcolor="EAF3F8" align=right>최종IP<LABEL style='cursor : hand' onClick='funcSort("S")'    order='DESC'>▲</LABEL></td>
		<td bgcolor="EAF3F8" align=right>최종사용시간<LABEL style='cursor : hand' onClick='funcSort("N")'    order='DESC'>▲</LABEL></td>
	</tr>
<%

	Iterator it = eventInfo.getIterator();
	int cnt = 1;

	while (it.hasNext()) {
		MTO eventUnit = (MTO) it.next();
%>
	<tr>
		<td bgcolor="FFFFFF"><%= eventUnit.get("command") %></td>
		<td bgcolor="FFFFFF" align=right><%= eventUnit.get("avgElapTime") %></td>
		<td bgcolor="FFFFFF" align=right><font color=red><%= eventUnit.get("maxElapTime") %> </font>
<% 
	if (!StringMaker.make(eventUnit.get("maxElapTxId")).equals("N/A")) { 
%>
		<a href="#" onclick="viewLog('<%=eventUnit.get("maxElapTxId") %>');"><b>[Log]</b></a>
<%
	}
%>		
		</td>
		<td bgcolor="FFFFFF" align=right><%= eventUnit.get("totCntAll") %></td>
		<td bgcolor="FFFFFF" align=right><b><font color=red><%= eventUnit.get("totCntError") %></font></b></td>
		<td bgcolor="FFFFFF" align=right><%= StringMaker.make(eventUnit.get("userId")) %></td>
		<td bgcolor="FFFFFF" align=right><%= StringMaker.make(eventUnit.get("userIp")) %></td>
		<td bgcolor="FFFFFF" align=right><%= StringMaker.make(eventUnit.get("lastFinish")) %> <a href="#" onclick="viewLog('<%=eventUnit.get("lastTxId") %>');"><b>[Log]</b></td>
	</tr>
<%
		cnt++;
	}
%>
</table>
<br>
<%
	}
%>


<!-- 세션 정보 파트 -->
<hr>
<%
	if (userInfo != null) {
%>
<b>&nbsp;* User 세션 현황 (Total <font color=blue><%= userInfo.size() %></font> Session)</b> <LABEL style='cursor : hand' onClick='funcToggleView("tblSessionStat");' ><font color=blue>[+]</font></LABEL>
<table id="tblSessionStat" name="tblSessionStat" width="660" border="0" cellpadding="2" cellspacing="1" bgcolor="B5D5E2" style='display:none;'>
	<tr width="100%">
		<td bgcolor="EAF3F8">User ID<LABEL style='cursor : hand' onClick='funcSort("S")'    order='DESC'>▲</LABEL></td>
		<td bgcolor="EAF3F8" align=right>User IP<LABEL style='cursor : hand' onClick='funcSort("S")'    order='DESC'>▲</LABEL></td>
		<td bgcolor="EAF3F8" align=right>Session Key<LABEL style='cursor : hand' onClick='funcSort("S")'    order='DESC'>▲</LABEL></td>
		<td bgcolor="EAF3F8" align=right>First Access<LABEL style='cursor : hand' onClick='funcSort("N")'    order='DESC'>▲</LABEL></td>
		<td bgcolor="EAF3F8" align=right>Last Access<LABEL style='cursor : hand' onClick='funcSort("N")'    order='DESC'>▲</LABEL></td>
		<td bgcolor="EAF3F8" align=right>Last Command<LABEL style='cursor : hand' onClick='funcSort("S")'    order='DESC'>▲</LABEL></td>
	</tr>
<%

	Iterator it = userInfo.getIterator();

	while (it.hasNext()) {
		MTO userUnit = (MTO) it.next();
%>
	<tr>
		<td bgcolor="FFFFFF"><%= userUnit.get("userId") %></td>
		<td bgcolor="FFFFFF" align=right><%= userUnit.get("userIp") %></td>
		<td bgcolor="FFFFFF" align=right><%= userUnit.get("sessionId") %></td>
		<td bgcolor="FFFFFF" align=right><%= userUnit.get("firstAccess") %></td>
		<td bgcolor="FFFFFF" align=right><%= userUnit.get("lastAccess") %></td>
		<td bgcolor="FFFFFF" align=right><%= userUnit.get("lastCommand") %></td>
	</tr>
<%
	}
	}
%>
</table>
<br>

<!-- 시스템 정보파트 -->

<hr>
<table width="640" border="0" cellpadding="2" cellspacing="2"  >
<tr>
<td width="400" align="left" valign="top">
<%
	if (svInfo != null) {
		String shortPathJDK = null;
		if (SystemInfo.JAVA_HOME.length() > 30) {
			shortPathJDK = StrUtil.left(SystemInfo.JAVA_HOME,30) + "..";
		} else {
			shortPathJDK = SystemInfo.JAVA_HOME;
		}
		
		String shortPathHome = null;
		if (SystemInfo.getHomePath().length() > 30) {
			shortPathHome = StrUtil.left(SystemInfo.getHomePath(),30) + "..";
		} else {
			shortPathHome = SystemInfo.getHomePath();
		}
%>
<b>* 서버 시스템 정보</u></b>
<table width="100%" border="0" cellpadding="2" cellspacing="1" bgcolor="B5D5E2">
	<tr>
		<td bgcolor="EAF3F8" align=left width=35%>Server Name (IP)</td>
		<td bgcolor="FFFFFF" align=right><%= SystemInfo.getSystemHostName() %> (<%= SystemInfo.getSystemIP() %>)</td>
	</tr>
	<tr>
		<td bgcolor="EAF3F8" align=left>Server OS</td>
		<td bgcolor="FFFFFF" align=right><%= SystemInfo.OS_NAME + " (" + SystemInfo.OS_VERSION +")" %></td>
	</tr>
	<tr>
		<td bgcolor="EAF3F8" align=left>WAS Name</td>
		<td bgcolor="FFFFFF" align=right><%= application.getServerInfo() %></td>
	</tr>
	<tr>
		<td bgcolor="EAF3F8" align=left>Java Version</td>
		<td bgcolor="FFFFFF" align=right><%= SystemInfo.JAVA_VM_VERSION + " (" +SystemInfo.JAVA_VM_VENDOR+")" %></td>
	</tr>
	<tr>
		<td bgcolor="EAF3F8" align=left>Java Home Path</td>
		<td bgcolor="FFFFFF" align=right title="<%= SystemInfo.JAVA_HOME %>"><%= shortPathJDK %></td>
	</tr>
	<tr>
		<td bgcolor="EAF3F8" align=left>Application Home Path</td>
		<td bgcolor="FFFFFF" align=right title="<%= SystemInfo.getHomePath() %>"><%= shortPathHome %></td>
	</tr>
</table>
</td>
<td width="220" align="left" valign="top">
<%
	}

	if (mmInfo != null) {
		String usePer = CalUtil.math("100",'-',mmInfo.get("FreeHeapPercent"));
		String colorStr = "black";
		if (CalUtil.compare(usePer,">","90")) {
			colorStr = "red";
		} else if (CalUtil.compare(usePer,">","60")) {
			colorStr = "blue";
		} else if (CalUtil.compare(usePer,">","30")) {
			colorStr = "green";
		} else {
			colorStr = "black";
		}
		
%>
<b>* HEAP 메모리 정보</b> 
<table width="100%" border="0" cellpadding="2" cellspacing="1" bgcolor="B5D5E2">
	<tr>
		<td width="60%" bgcolor="EAF3F8"><font color=<%= colorStr %>>현재 USE HEAP</font></td>
		<td  bgcolor="FFFFFF" align=right><font color=<%= colorStr %>><%= CalUtil.math("100",'-',mmInfo.get("FreeHeapPercent")) %> %</font></td>
	</tr>
	<tr>
		<td  bgcolor="EAF3F8" ></td>
		<td  bgcolor="FFFFFF" align=right><font color=<%= colorStr %>><%= CalUtil.math(mmInfo.get("TotalHealMemory"),'-',mmInfo.get("FreeHeapMemory")) %> MB</font></td>
	</tr>
	<tr>
		<td  bgcolor="EAF3F8">현재 FREE HEAP </td>
		<td  bgcolor="FFFFFF" align=right><%= mmInfo.get("FreeHeapPercent") %> %</td>
	</tr>
	<tr>
		<td bgcolor="EAF3F8"></td>
		<td bgcolor="FFFFFF" align=right><%= mmInfo.get("FreeHeapMemory") %> MB</td>
	</tr>
	<tr>
		<td bgcolor="AAF3F8">현재 MAX HEAP </td>
		<td bgcolor="EEEEEE" align=right><%= mmInfo.get("TotalHealMemory") %> MB</td>
	</tr>
	<tr>
		<td bgcolor="AAF3F8">확장 MAX HEAP </td>
		<td bgcolor="EEEEEE" align=right><%= mmInfo.get("MaxHeapMemory") %> MB</td>
	</tr>
</table>
</td>
</tr>
</table>
<br>

<%
	}
%>
<hr>

<!-- FMB 및 실시간 이용 정보 파트 -->
<table width="660" border="0" cellpadding="2" cellspacing="2"  >
<tr>
<td width="350" valign="top">

<%
	if (StatLTO != null) {
%>


<b>* FMB 처리 통계</b>
<table width="100%" border="0" cellpadding="2" cellspacing="1" bgcolor="B5D5E2">
	<tr>
		<td bgcolor="EAF3F8">FMB</td>
		<td bgcolor="EAF3F8">전체 #</td>
		<td bgcolor="EAF3F8">실패 #</td>
		<td bgcolor="EAF3F8">평균 (msec.)</td>
		<td bgcolor="EAF3F8">최장 (msec.)</td>
	</tr>
<%
	for (int i=0;i<StatLTO.size();i++) {
		MTO mto = StatLTO.get(i);
%>
	<tr>
		<td bgcolor="FFFFFF"><%= mto.get("id") %> (<%= mto.get("name") %>)</td>
		<td bgcolor="FFFFFF" align=right><%= mto.get("totAll") %></td>
		<td bgcolor="FFFFFF" align=right><%= mto.get("totError") %></td>
		<td bgcolor="FFFFFF" align=right><%= mto.get("avg") %></td>
		<td bgcolor="FFFFFF" align=right><font color=red><%= StringMaker.make(mto.get("max")) %> <a href="#" onclick="viewLog('<%=StringMaker.make(mto.get("maxTxId")) %>');"><b>[Log]</b></a></font></b></td>
	</tr>

<%
	}
%>

</table>
</td>
<td width="290" valign="top">

<%
	}
	
	if (txInfo != null) {
%>

<b>* 실시간 서비스 처리 상태</b>
<table width="100%" border="0" cellpadding="2" cellspacing="1" bgcolor="B5D5E2">
	<tr>
		<td bgcolor="EAF3F8">#</td>
		<td bgcolor="EAF3F8">TX ID</td>
		<td bgcolor="EAF3F8">ElapTime</td>
	</tr>
<%
	Nexter nx = txInfo.getSortedNexter();
	int cnt = 1;
	
	//debug(txInfo);
	
	while (nx.hasNext()) {
		String key = nx.next();
%>
	<tr>
		<td bgcolor="FFFFFF" align=left width=10%><%= cnt %></td>
		<td bgcolor="FFFFFF" align=left><a href="#" onclick="viewLog('<%= key %>');"><b><%= key %></b></a></td>
		<td bgcolor="FFFFFF" align=right width=20%><%= txInfo.get(key) %></td>
	</tr>

<%
		cnt++;
	}
%>
</table>
</td>
</tr>
</table>
<%
	}
%>

