<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/base/include/ArchJsp.jspf" %>

<% setNoCache(response); %>

<%@page import="com.cni.fw.ff.common.SystemInfo"%>
<%@page import="com.cni.fw.ff.conf.BaseConfig"%>
<%@page import="java.util.logging.Logger"%>
<html>

<style tyoe="text/css">
body,td {font-size:9pt; font-family:"맑은 고딕"; text-decoration:none; color:#333333; line-height:14px;}
}
</style>

<SCRIPT type=text/javascript>

function onEnter() {
	if (event.keyCode == 13) {
		if (trackForm.txId.value.length < 1) {
			alert("트래킹 대상 TX를 입력하세요!");
		} else {
			trackForm.txId.value = trim(trackForm.txId.value);
			//alert("["+trackForm.txId.value+"]");
			trackForm.submit();
		}
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

</SCRIPT>

<body bgcolor="#F0F3FA" leftmargin="0" topmargin="0">
<form name=trackForm action="ADM001.A05.cmd" method="post"  onsubmit="return false"	target=right>	
<table width="100%" height="100%"  border="0" cellpadding="0" cellspacing="0" bgcolor="F0F3FA">
  <tr>
    <td align="center" valign="middle" bgcolor="#FFFFFF">
    	<img src="img/DAFrameLogo1.jpg">
    	<u><h4>Welcome to Dongbu CNI Application Framework</h4></u><br>
    	<h1>DAFrame <%= SystemInfo.getVersion() %></h1></b> 
    	<br>
    <font color=green size=5>For Developer !! <font>
    		<br><br>
    		<br><br><br>
    	<font color=blue size=3>
    	WinterMute, TA Team, R&D Center, Dongbu CNI
    	<br><br><br>
    	<font color=black size=2>Q&A : <u><%= Identity.emailContact %></u></font>
    	<br>
    	<font color=black size=2>Homepage : <a href="#" onclick="window.open('http://daframe.dongbucni.co.kr/cms/');return false;" >daframe.dongbucni.co.kr</a></font>
    	<br><br><br>
    	<!--  
    	<font color="red"><b>LOG Tracking</b> &nbsp;Tx Id : </font><input name="txId" type="text" size=16 onKeyDown="onEnter();"/> 
    	<br><font color=gray size=-1>* 참고:Log 설정에서 FileAppender를 지정했을 경우에만 동작합니다.</font>
    	-->
    	<b><font color=black size=2>* Last Update Date : <%= SystemInfo.getLastUpdate() %></font></b><br><br>
    	<b><font color=blue size=2>* LICENSE : <%= SystemInfo.getLicenseInfo()%></font></b><br><br>
    	<b><font color=RED size=2>* CONFIG : MODE=<%= BaseConfig.getInstance().get("fw.mode") %></font></b><br><br>
    </td>
  </tr>
</table>
</form>

</body>
</html>