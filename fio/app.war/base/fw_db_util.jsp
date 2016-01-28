<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/base/include/ArchJsp.jspf" %>

<!-- ###### stylesheet area ###### -->
<%@page import="com.cni.fw.ff.util.finder.MtoMtoFinder"%>
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

<script type="text/javascript" src="<%= request.getContextPath() %>/base/js/prototype.js"></script>
<script type="text/javascript" src="<%= request.getContextPath() %>/base/js/scriptaculous.js"></script>

<%
	if (output != null) {
		if (output.getCode().equals("NO-DB")) {
%>
<script>
		alert("<%= output.getMessage() %>");
		history.go(-1);
</script>
<%		
		return;
		}
	}
	
	MTO tblInfo = output.getMTO("tblInfo");
%>

<script type="text/javascript">
window.onload = function() {
	// Event Listener Code
	Event.observe('dbName', 'keypress', function(e) { if(e.keyCode == 13) $('tableListForm').submit(); });
	Event.observe('tablePattern', 'keypress', function(e) { if(e.keyCode == 13) $('tableListForm').submit(); });
<%
	if ( tblInfo !=null) {
%>
	Event.observe('pgSize', 'keypress', function(e) { if(e.keyCode == 13) $('tableViewForm').submit(); });
<%	
	}
%>
}


function searchTableInfo() {
	var tbForm = document.getElementById("tableListForm")
	tbForm.action = 'DB_TABLE_LIST.cmd';
	tbForm.target = 'left';
	tbForm.submit();
}

function searchJdbcInfo() {
	var tbForm = document.getElementById("tableListForm")
	tbForm.action = 'DB_JDBC_INFO.cmd';
	tbForm.target = 'right';
	tbForm.submit();
}
</script>




<table width='100%' border='0' cellpadding='0' cellspacing='0'>
<form id='tableListForm' name='tableListForm' method='post' onsubmit='return false' >
	<tr>
		<td align='right'>
			<b>* DataBase </b> : &nbsp; 
		</td>
		<td align='left'>
			<input id="dbName" name='dbName' type='text' size='25' title='FW에 설정한 DB Alias를 입력하세요. (미입력시에는 MainDB)' value='<%= StringMaker.make(input.get("dbName")) %>'/>
			&nbsp;
			<input type='button' value='DB 연결정보' onClick='searchJdbcInfo();' />
		</td>
	</tr>
	<tr>
		<td align='right'>
			<b>* Table Name </b> : &nbsp; 
		</td>
		<td align='left'>
			<input id="tablePattern" name='tablePattern' type='text' size='25' title='찾고자 하는 Table에 대한 패턴을 입력하세요. (예:EX_)' value='<%= StringMaker.make(input.get("tablePattern")) %>' />
		</td>
	</tr>
	<tr>
		<td align='right'>
			<b>* Table 선택</b> : &nbsp;  
		</td>
		<td align='left'>
			<SELECT id="tableTarget" name="tableTarget" style="width:187px;" onchange='searchTableInfo()'>
			<% 
				LTO tblList = output.getLTO("tblList");
				if (tblList != null) {
					for (int i=0;i<tblList.size();i++) {
						String tblName = tblList.get(i).get("TABLE_NAME");
			%>
				<OPTION <% if (tblName.equals(input.get("tableTarget"))) {out.print("selected");} %>><%= tblName %></OPTION>
			<%  	
					} 
				} 
			%>
			</SELECT>
			&nbsp;
			<input type='button' value='TABLE 검색' onClick='searchTableInfo();' />
		</td>
	</tr>
</form>
</table>
<%
	if ( tblInfo !=null) {
%>

<SCRIPT LANGUAGE="JavaScript">
<!--
 function checkAll() {
  	for(i=0;i<document.getElementsByName("colName").length;i++) {
    	document.getElementsByName("colName")[i].checked=document.getElementsByName("allCheck")[0].checked
    }
    
 }   
//-->
</SCRIPT>
<br>
<br>
<form id='tableViewForm' name='tableViewForm' action='<%= request.getContextPath() %>/DB_TABLE_BASIC_R2.cmd' method='post' onsubmit='return false' target='right'>
TABLE 명 : <b><%= input.get("tableTarget") %></b>
&nbsp;
<input id="dbName" name='dbName' type='hidden' size='25' value='<%= StringMaker.make(input.get("dbName")) %>' />
<input id="tableTarget" name='tableTarget' type='hidden' value='<%= StringMaker.make(input.get("tableTarget")) %>' />
<%
	ATO sortedKey = MtoMtoFinder.sortKeyByInnerOrderKey(tblInfo,"ORDINAL_POSITION",1);
		
	for (int i=0;i<sortedKey.size();i++) {
		String key = sortedKey.get(i);
		MTO colInfo =(MTO) tblInfo.getObject(key);		
%>
<input id="colName" name='colName' type='hidden' value='<%= colInfo.get("COLUMN_NAME") %>' />
<%
	}
%>
<input id="pgSize" name='pgSize' type='input' value='20' size='2' value='<%= StringMaker.make(input.get("pgSize")) %>' />건 &nbsp;
<input type='button' value='Sample 조회' onClick='tableViewForm.submit();' />
</form>
<form id='tsqlGenForm' name='tsqlGenForm' action='<%= request.getContextPath() %>/DB_TABLE_TSQL_GEN.cmd' method='post' onsubmit='return false' target='right'>
<input id="tableName" name='tableName' type='hidden' value='<%= input.get("tableTarget") %>' />
<table width="100%" border="0" cellpadding="2" cellspacing="1" bgcolor="#B5D5E2">
	<tr>
	<td bgcolor="EAF3F8">#</td>
	<td bgcolor="EAF3F8">컬럼명</td>
	<td bgcolor="EAF3F8">타입</td>
	<td bgcolor="EAF3F8">크기</td>
	<td bgcolor="EAF3F8">소수점</td>
	<td bgcolor="EAF3F8">IS PK</td>
	<td bgcolor="EAF3F8">IS NULL</td>
	<td bgcolor="EAF3F8"><input id="allCheck" name='allCheck' type='checkbox' checked onclick='checkAll();'/></td>
	</tr>
<%
		
	for (int i=0;i<sortedKey.size();i++) {
		String key = sortedKey.get(i);
		MTO colInfo =(MTO) tblInfo.getObject(key);		
%>
	<tr>
	<td bgcolor="EAF3F8"><%= colInfo.get("ORDINAL_POSITION") %></td>
	<td bgcolor="EAF3F8"><%= colInfo.get("COLUMN_NAME") %></td>
	<td bgcolor="#FFFFFF"><%= colInfo.get("TYPE_NAME") %></td>
	<td bgcolor="#FFFFFF"><%= colInfo.get("COLUMN_SIZE") %></td>
	<td bgcolor="#FFFFFF"><%= StrUtil.nullToStr(colInfo.get("DECIMAL_DIGITS")) %></td>
	<td bgcolor="#FFFFFF"><%= colInfo.get("IS_PK") %></td>
	<td bgcolor="#FFFFFF"><%= colInfo.get("IS_NULLABLE") %></td>
	<td bgcolor="#FFFFFF"><input id="colName" name='colName' type='checkbox' value='<%= colInfo.get("COLUMN_NAME") %>' checked /></td>
	</tr>

<%
	}
%>
</table>
<br />
<center>
<input type='button' value='   *TSQL/PUT/GET 지원 코드 생성*   ' onClick='tsqlGenForm.submit();' />
</center>
</form>


<%
	} else {
%>
<form id='tableViewForm' name='tableViewForm' action='<%= request.getContextPath() %>/DB_TABLE_BASIC_R2.cmd' method='post' onsubmit='return false' target='right'>
<br>
<br>
<b>======================== 임의 QUERY =======================</b>
<br>
<br>
<b>* DataBase : </b><input id="dbName" name='dbName' type='text' size='25' value='<%= StringMaker.make(input.get("dbName")) %>'/>&nbsp;[DS FW Alias]
<br>
<b>* PageSize : </b><input id="pgSize" name='pgSize' type='input' value='20' size='2' value='<%= StringMaker.make(input.get("pgSize")) %>' />건 &nbsp;&nbsp;&nbsp;
<input type='button' value='Sample 조회' onClick='tableViewForm.submit();' />

<br>
<textarea id="queryTarget" name='queryTarget' rows="20" cols="57"></textarea>
</form>
<SCRIPT>
	function tsqlGen() {
		window.document.tsqlGenForm.dbName.value = window.document.tableViewForm.dbName.value;
		window.document.tsqlGenForm.queryTarget.value  = window.document.tableViewForm.queryTarget.value;
		window.document.tsqlGenForm.submit();
	}
</SCRIPT>
<form id='tsqlGenForm' name='tsqlGenForm' action='<%= request.getContextPath() %>/DB_TABLE_TSQL_GEN.cmd' method='post' onsubmit='return false' target='right'>
<input id="dbName" name='dbName' type='hidden' />
<input id="queryTarget" name='queryTarget' type='hidden' />
<center>
<input type='button' value='   *PUT/GET 지원 코드 생성*   ' onClick='tsqlGen();' />
</center>
<%
	} //<!--//window.document.tsqlGenForm.dbName.value-->
%>


