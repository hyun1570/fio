<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/base/include/ArchJsp.jspf" %>

<!-- ###### stylesheet area ###### -->
<link href="<%= request.getContextPath() %>/base/css/cni.css" rel="stylesheet" type="text/css" />
<!-- ###### stylesheet area ###### -->

<script type="text/javascript" src="<%= request.getContextPath() %>/base/js/prototype.js"></script>
<script type="text/javascript" src="<%= request.getContextPath() %>/base/js/scriptaculous.js"></script>
<script type="text/javascript">

window.onload = function() {
	// Event Listener Code
	Event.observe('adminPass', 'keypress', function(e) { if(e.keyCode == 13) $('loginForm').submit(); });
}

</script>

<center>

<br>
<br>

<img src="img/DAFrameLogo1.jpg" >

<br>

<!-- ####### html area ###### -->
<form id='loginForm' name='loginForm' action='<%= request.getContextPath() %>/base/ADM000.A06.cmd' method='post'>
<table border='0' cellpadding='0' cellspacing='0'>
	<tr>
		<td align='right'>
			<b>아이디</b> : &nbsp; 
		</td>
		<td align='left'>
			<input id='adminId' name='adminId' type='text'  size="13" />
		</td>
	</tr>
	<tr>
		<td align='right'>
			<b>패스워드</b> : &nbsp; 
		</td>
		<td align='left'>
			<input id='adminPass' name='adminPass' type='password' size="13"/>
		</td>
	</tr>
	<tr>
		<td align='center' colspan="2">
			&nbsp;
		</td>
	</tr>
	<tr>
		<td align='center' colspan="2">
			<input type='button' value='* CONSOLE LOGIN *' onClick='loginForm.submit();' />
		</td>
	</tr>
	
	
</table>
</form>

본 콘솔을 사용하시기 위해서는 관리자 계정으로 로그인이 필요합니다.

</center>
<!-- ####### html area ###### -->