<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/base/include/ArchJsp.jspf" %>
<%@page import="com.cni.fw.ff.conf.BaseConfig"%>
<html>
<head>
<title>CNI Framework Example</title>
<link href="./css/cni.css" rel="stylesheet" type="text/css">

<script>
	function chkStat() {
		//if (confirm('현재 시스템에 대한 통계정보를 조회합니다. 계속 진행하시겠습니까?') == true) {
			window.parent.frames[2].location = "ADM001.A01.cmd";
			//parent.document.frames["right"].location = "ADM001.A02.cmd?config=all";
		//}
	}


	function chkReboot() {
		if (confirm('[주의!!] 프레임워크를 재기동 합니다. 계속 진행하시겠습니까?') == true) {
			window.parent.frames[2].location = "ADM001.A04.cmd";
			//parent.document.frames["right"].location = "ADM001.A04.cmd";
		}
	}
</script>

<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td align=left>
				<a href="fw_right.jsp" target=right><img src="img/Strategy.jpg" alt="개발자를 우선으로 생각하는 Framework"></a>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<a href="javascript:parent.LeftSlide();"><img src="img/leftFrame.jpg" alt="좌측패널여닫기"></a>
			</td>
			<td align=right>
				<a href="AC_LIST_GRP.cmd" target=left ><img src="img/TestIcon.jpg" alt="UC목록을 출력 및 테스트"></a>
				<a href="DB_TABLE_LIST.cmd" target=left ><img src="img/DBTsql.jpg" alt="TSQL 템플릿 제너레이터"></a>
				<a href="doc/index.html" target=right ><img src="img/ApiIcon.jpg" alt="프레임워크 API 확인"></a>
				<!--  <a href="#" onclick="window.open('http://daframe.dongbucni.co.kr/cms/');return false;" ><img src="img/bbs.jpg" alt="공식커뮤니티방문"></a> -->
				<a href="#" onclick="chkStat();"><img src="img/MonIcon.jpg" alt="프레임워크 상태 모니터링"></a>
				<a href="ADM001.A07.cmd"  target=right><img src="img/ReloadIcon.jpg" alt="프레임워크 환경 구성"></a>
<%
	if (BaseConfig.isDevMode()) {
%>
				<a href="#" onclick="chkReboot();"><img src="img/RebootIcon.jpg" alt="프레임워크 재기동"></a>
<%
	}
%>
				&nbsp;
				&nbsp;
			</td>
		</tr>
	</table>
</body>
</html>
