<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/base/include/ArchJsp.jspf" %>

<html>
<link href="<%= request.getContextPath() %>/base/css/cni.css" rel="stylesheet" type="text/css" />
<style tyoe="text/css">
#tableMenuButton {
	cursor: pointer;
	width: 15px;
	height: 15px;
	background-image: url('<%= request.getContextPath() %>/base/img/param.gif');
	background-repeat: no-repeat;
}

#popupMenuDiv {
	border: 4px #ccccff solid;
	background-color: #ffffff;
	position: absolute;
	left: 135px;
	width: 310px;
	display: none;
}

.popupMenuButton {
	width: 55px;
	height: 30px;
	cursor: pointer;
}
</style>
<!-- ###### stylesheet area ###### -->

<%
	//debug(input);
	//debug(output);
	
	String tableName = input.get("tableTarget");
	
	// 직접 쿼리처리했을 경우
	if (output.getLTO("RESULT") != null) {
		tableName = "RESULT";
	}
	
	LTO result = output.getLTO(tableName);
	// Tactics 처리시 저장되어 있는 컬럼이름의 순서가 담긴 ATO
	ATO colNames = (ATO) result.getInfoMap().getObject(LtoInfoC.COL_NAMES_ATO);
	String rowTot = result.getInfo(LtoInfoC.ROW_TOT_STR);
	MTO row = null;
%>

<h2><%= tableName %> [전체건수:<%= rowTot %>] </h2> 

<table width="100%" border="0" cellpadding="2" cellspacing="1" bgcolor="#B5D5E2">

<tr>
<%	
	// capName 및 capSize를 사용해 tsql에서 $caption을 사용할 수 있다.
	for (int i=0;i<colNames.size();i++) {
%>
	<td bgcolor="#EAF3F8">
		<%= colNames.get(i) %>
	</td>
<%
	}
%>	
</tr>
	
<%	
	for (int i=0;i<result.size();i++) {
%>
<tr>
<%		
		row = result.get(i);

		Nexter nexter = colNames.getNexter(); 
		
		while (nexter.hasNext()) {
			String colValue = row.get(nexter.next());
		%>
			<td bgcolor="#FFFFFF">
				<%= colValue %>
			</td>
		<%
		}
		%>
</tr>
		<%
	}
%>
</table>

<center>
<%=PageNavi.getInstance().printPageNavi(IntMaker.make(result.getInfo(LtoInfoC.PG_NUM_STR)), IntMaker.make(result.getInfo(LtoInfoC.PG_TOT_STR)))%>
</center>

<form id="goPageForm" name="goPageForm" action="<%= input.getSystem().get(SystemC.WEB_REQUEST_URI) %>" method="POST">
	<input id="tableTarget" name="tableTarget" type="hidden">
	<input id="queryTarget" name="queryTarget" type="hidden">
	<input id="pgNum" name="pgNum" type="hidden">
	<input id="pgSize" name="pgSize" type="hidden">
</form>

<SCRIPT LANGUAGE="JavaScript">
function goPage(pageNum)
{
	window.document.goPageForm.tableTarget.value = "<%= StrUtil.nullToStr(input.get("tableTarget")) %>";
	window.document.goPageForm.queryTarget.value = "<%= StrUtil.nullToStr(input.get("queryTarget")) %>";
	window.document.goPageForm.pgSize.value = "<%= input.get("pgSize") %>";
	window.document.goPageForm.pgNum.value = pageNum;
	window.document.goPageForm.submit();
}
</SCRIPT>

</html>


