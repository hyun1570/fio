<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/base/include/ArchJsp.jspf" %>

<!-- ###### stylesheet area ###### -->
<%@page import="com.cni.fw.ff.util.maker.StringMaker"%>
<%@page import="com.cni.fw.ff.util.StrUtil"%>
<%@page import="com.cni.fw.meta.util.CmdMetaUtil"%>
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



<!-- ###### script area ###### -->
<script type="text/javascript" src="<%= request.getContextPath() %>/base/js/prototype.js"></script>
<script type="text/javascript" src="<%= request.getContextPath() %>/base/js/scriptaculous.js"></script>
<script type="text/javascript">
var preUrl;
var mx;
var my;
var totalParameter = 3;

function mouseAxis(e) {		
	if(e) {
		mx = e.clientX;
		my = e.clientY;
	}
	else {
		mx = event.clientX;
		my = event.clientY;
	}
}

/*
function onKeyHandler(e) {
	if($('popupMenuDiv').style.display == "block")
		return true;
		
	if(e) {
		if(e.keyCode == 13)
			searchForm.submit();
	}
	else {
		if(window.event.keyCode == 13)
			searchForm.submit();
	}	
}
*/

function openPopup(url,cmd) {
	if(preUrl == url)
		closePopup();
	else {
		preUrl = url;
		$('urlStr').value = url;
		$("popupMenuDiv").style.top = my - 40 + document.body.scrollTop + 'px';
		$("popupMenuDiv").style.display = "block";
	}
}

function closePopup() {
	$("popupMenuDiv").style.display = "none";
	preUrl = null;
}

function relocateParameterFrame() {
	var top = parseInt($("popupMenuDiv").style.top.substring(0, $("popupMenuDiv").style.top.length - 2)) + 'px';
	var height = parseInt($("popupMenuDiv").style.height.substring(0, $("popupMenuDiv").style.height.length - 2)) + 'px';
	if(top + height > $("left").height + document.body.scrollTop) {
		$("popupMenuDiv").style.top = $("left").height - height + document.body.scrollTop;
	}
}

function clickFormButton() {
	var form = $('popupForm');
	for(var i = 0 ; i <= totalParameter ; i++) {	
		if(($("value" + i).value).trim != "") {
			$("value" + i).name = $("name" + i).value;
		}
	}
	form.action = $("urlStr").value;
	form.submit();
	closePopup();
}

function addParameter() {
	totalParameter++;

 	var element = Builder.node('tr', {id:'popupTr'+totalParameter}, [
 		Builder.node('td', [
 			Builder.node('input', {id:'name'+totalParameter, type:'text', size:'12'})
 		]),
 		Builder.node('td', [
 			Builder.node('input', {id:'value'+totalParameter, type:'text', size:'22'})
 		])
 	]);
 	 
	$('popupTable').firstDescendant().appendChild(element);
}

function removeParameter() {
	if(totalParameter >= 4) {
		$('popupTr' + totalParameter--).remove();
	}
}

function resetParameter() {
	for(var i = 0 ; i <= totalParameter ; i++) {	
		$('value' + i).value = '';
		$('name' + i).value = '';
	}
}

function trim(str){ 
	str = str.replace(/(^\s*)|(\s*$)/g,""); 
	return str; 
} 

function lpad(input, len, ch){
 input = ''+input;
 var strlen = input.length;
 var ret = "";
 var plen = len - strlen;
 var pstr = ""; 
 
 for (i=0; i<plen; ++i)
 {
  pstr = pstr + ch;
 }
 ret = pstr + input; 

 return ret;
}

document.onmousemove = mouseAxis;
// 아래 이벤트 리스너 영역에서 처리하는 것으로 바꿈
//document.onkeypress = onKeyHandler;

window.onload = function() {
	// Event Listener Code
	Event.observe('logSearchArea', 'keypress', function(e) { if(e.keyCode == 13) $('trackForm').submit(); });
	Event.observe('searchKeyArea', 'keypress', function(e) { if(e.keyCode == 13) $('searchForm').submit(); });
}

/// 이벤트 핸들러 (소스 생성기)

function genSrc() {
	var form = $('searchForm');
	var target = $('searchGrp').options[$('searchGrp').selectedIndex].text;
	if (target == "* ALL *") {
			alert("전체에 대해서 소스를 생성할 수는 없습니다.");
	} else {
		var temp = confirm("["+target+"] 소스를 생성하겠습니까?");
		if (temp == true) {
			form.option.value = target;
			form.submit();
		}
	}
}

</script>
<!-- ####### script area ###### -->



<!-- ####### html area ###### -->
<div id="popupMenuDiv">
<center>
	<form id="popupForm" name="urlForm" target="right" action="#" method='post'>
	<input type="hidden" id="urlStr" value="" />
	<span id="popupTitle" style="font-size: 15px;"></span>
	
	<div>
	<img class="popupMenuButton" src="<%= request.getContextPath() %>/base/img/button01.jpg" onclick="clickFormButton();" />
	<img class="popupMenuButton" src="<%= request.getContextPath() %>/base/img/button02.jpg" onclick="addParameter();" />
	<img class="popupMenuButton" src="<%= request.getContextPath() %>/base/img/button03.jpg" onclick="removeParameter();" />
	<img class="popupMenuButton" src="<%= request.getContextPath() %>/base/img/button04.jpg" onclick="resetParameter();" />
	<img class="popupMenuButton" src="<%= request.getContextPath() %>/base/img/button05.jpg" onclick="closePopup();" />
	</div>
	
	<table id='popupTable' bgcolor='EAF3F8' bordercolor='#dddddd'>
		<tr style='font-size: 15px; background-color: #B5D5E2;'>
			<th align='center'>Name</th>
			<th align='center'>Value</th>
		</tr>
		<tr id='popupTr0'>
			<td><input id='name0' type='text' size='12'/></td>
			<td><input id='value0' type='text' size='22'/></td>
		</tr>	
		<tr id='popupTr1'>
			<td><input id='name1' type='text' size='12'/></td>
			<td><input id='value1' type='text' size='22'/></td>
		</tr>
		<tr id='popupTr2'>
			<td><input id='name2' type='text' size='12'/></td>
			<td><input id='value2' type='text' size='22'/></td>
		</tr>
		<tr id='popupTr3'>
			<td><input id='name3' type='text' size='12'/></td>
			<td><input id='value3' type='text' size='22'/></td>
		</tr>
	</table>
	</form>
</center>
</div>

<%
	if (output != null) {
		if (output.getCode().equals("GEN-OK")) {
%>
<script>
		alert("소스생성을 완료하였습니다.");
</script>
<%			
		}
	}
%>

<form id='searchForm' name='searchForm' action='<%= request.getContextPath() %>/AC_LIST_GRP.cmd' method='post' onsubmit='return false' target='left'>
<input id='option' name='option' type='hidden' value='' />
<table width='95%' border='0' cellpadding='0' cellspacing='0'>
	<tr>
		<td align='right'>
			<b>* META 선택</b> : &nbsp;  
		</td>
		<td align='left'>
			<SELECT id="searchGrp" name="searchGrp" style="width:187px;" >
			<% 
				ATO grpList = output.getATO("metaList");
				for (int i=0;i<grpList.size();i++) {
					String grpName = grpList.get(i);
			%>
				<OPTION <% if (grpName.equals(input.get("searchGrp"))) {out.print("selected");} %>><%= grpName %></OPTION>
			<%   } %>
			</SELECT>
		</td>
		<td align="left">
			<input type="button" value="메타 조회" onClick='searchForm.submit();' />
		</td>
	</tr>
	<tr>
		<td align='right'>
			<b>* EVENT 검색</b> : &nbsp; 
		</td>
		<td align='left'>
			<input id="searchKeyArea" name='searchKey' type='text' size='25' value="<%= StringMaker.make(input.get("searchKey")) %>" />
		</td>
		<td align="left">
			<input type="button" value="소스 생성"  onClick='genSrc();' />
		</td>
	</tr>
</form>
<form id="trackForm" name="trackForm" action="ADM001.A05.cmd" method="post"  onsubmit="return false"	target=right>	
	<tr>
		<td align='right'>
			<font color=red><b>* LOG Tracking</b></font> : &nbsp; 
		</td>
		<td align='left'>
			<input id="logSearchArea" name='txId' type='text' size='25' />
		</td>
		<td align="left">
			<input type="button" value="로그 검색"  onClick='trackForm.submit();' />
		</td>
	</tr>
</table>
</form>
■ 총 <b><font color=blue><%= output.getDefault("eventTotal") %></font></b> 건이 조회되었습니다. <% if (CalUtil.compare(output.get("scoreAllTotal"),">","0")) { %> (전체 FP : <b><%= output.get("scoreAllTotal")  %></b>, 전체 SCREEN : <b><%= output.get("screenCount") %></b>) <% } %>
<br>
<br>

<%
	Nexter nx = output.getSortedNexterLTO();
	
	String fpTotal = "0";
	while (nx.hasNext()) {
		String ucId = nx.next();
		LTO ucLto = output.getLTO(ucId);
		String fpUc = ucLto.getInfo("scoreUcTotal");
		fpTotal = CalUtil.math(fpTotal,'+',fpUc);
%>


UC ID : <%= ucId %>, <%= ucLto.getInfo("ucName") %> <% if (CalUtil.compare(fpUc,">","0")) { %>(FP: <b><%= fpUc %></b>) <% } %>
<table width="100%" border="0" cellpadding="2" cellspacing="1" bgcolor="#B5D5E2">

<%
	for (int i = 0; i < ucLto.size(); i++) {
		MTO ucMto = ucLto.get(i);
		String toolTipDev = "설계자 : "+ucMto.get("desName") +", 개발자 : " + ucMto.get("devName");
		String toolTipIO = "입출력 : "+ucMto.get("ipType") + " (" + ucMto.get("chkSession")+") → " + ucMto.get("opType");
		if (!StrUtil.isEmpty(ucMto.get("opUrl"))) {
			toolTipIO += " ("+ucMto.get("opUrl")+")";
		}
		
		String bgColor="#FFFFFF";
		String fgColor="#000000";
		String fgWord = "";
		String toolTip= ucMto.get("component");
		if (BooleanMaker.make(ucMto.get("reuse"))) {
			bgColor="#646464";
			fgColor="#FFFFFF";
			fgWord="R";
			toolTip=toolTip+" (*REUSE*)";
		} else if (StrUtil.isEmpty(toolTip)) {
			bgColor="#949494";
			fgColor="#FFFFFF";
			fgWord="X";
			toolTip="*NO CLASS*";
		} else {
			bgColor="#FFFFFF";
			fgColor="#000000";
			fgWord="";
		}
			
			if (StrUtil.isEmpty(ucMto.get("ipType")) || ucMto.get("ipType").equalsIgnoreCase("X")) {
%>
	<td width="100" bgcolor="EAF3F8" title="<%= toolTip %>">-&nbsp;<%= ucMto.get("cmd") %></td>
	<td width="15" bgcolor="EAF3F8"align="center">
		<div id="tableMenuButton" title="<%= toolTipIO %>"/>
	</td>
<% 
			} else {
%>
		<tr>
	<td width="100" bgcolor="EAF3F8" title="<%= toolTip %>">*&nbsp;<a href=<%= request.getContextPath() %><%=ucMto.get("activePath")%>/<%= ucMto.get("cmd") %>.cmd target=right><%= ucMto.get("cmd") %></a></td>
	<td width="15" bgcolor="EAF3F8"align="center">
		<div id="tableMenuButton" title="<%= toolTipIO %>" onclick="openPopup('<%= request.getContextPath() %><%=ucMto.get("activePath")%>/<%= ucMto.get("cmd") %>.cmd','<%= ucMto.get("cmd") %>')" />
		<!-- <img style="cursor:pointer;width:20px;height:15px;" src="<%= request.getContextPath() %>/base/img/param.gif" onclick="openPopup('<%= request.getContextPath() %><%=ucMto.get("activePath")%>/<%= ucMto.get("cmd") %>.cmd','<%= ucMto.get("cmd") %>')" /> -->
	</td>
<%	}  
	String fpColor="#FFFFFF";
	if (ucMto.get("fpType").equals("EQ")) {
		fpColor="#FFFFFF";
	} else if (ucMto.get("fpType").equals("EI")) {
		fpColor="#FFFFA0";
	} else {
		fpColor="#E0FFA0";
	}

%>
	<td bgColor="#FFFFFF"  title="<%= toolTipDev %>"><%= ucMto.get("evName") %></td>
	<td width="10" bgcolor="<%= bgColor %>" title="<%= toolTip %>"><font color="<%= fgColor %>"><%= fgWord %></font></td>
<%
	bgColor="#FFFFFF";
	fgColor="#000000";
	fgWord = "";
	toolTip= ucMto.get("opType");

	if (toolTip.equalsIgnoreCase("CHAINED") || toolTip.equalsIgnoreCase("CHAINED-TX")) {
		bgColor="#949494";
		fgColor="#FFFFFF";
		fgWord="C";
		toolTip +=" ("+ucMto.get("opUrl")+")";
	} else if (toolTip.equalsIgnoreCase("BRANCH") || toolTip.equalsIgnoreCase("BRANCH-TX")) {
		bgColor="#FF8080";
		fgColor="#FFFFFF";
		fgWord="B";
		toolTip +=" ("+ucMto.get("opUrl")+")";
	} else if (ucMto.getDefault("isScreen").equals("Y")) {
		bgColor="#AC58FA";
		fgColor="#FFFFFF";
		fgWord="U";
		toolTip +=" ("+ucMto.get("opUrl")+")";
	} else {
		bgColor="#FFFFFF";
		fgColor="#000000";
		fgWord=""; // StrUtil.left(toolTip,1);
	}
%>	
	<td width="10" bgcolor="<%= bgColor %>" title="<%= toolTip %>"><font color="<%= fgColor %>"><%= fgWord %></font></td>
	<td width="15" bgcolor="<%= fpColor %>"><%= ucMto.get("fpType") %></td>
	<td width="15" bgcolor="<%= fpColor %>"><%= ucMto.get("score") %></td>
	</tr>

<%
		}
%>
</table>
<br />
<%
	}
%>


<!-- ####### html area ###### -->