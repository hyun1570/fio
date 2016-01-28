<%@ page contentType="text/html; charset=UTF-8" %>
<html>
<head>
<script type="text/javascript" src="<%= request.getContextPath() %>/base/js/prototype.js"></script>
<script type="text/javascript">
function LeftSlide(){
	if (document.getElementById("fw_left").width == "0"){
		document.getElementById("fw_frame").cols = "470,*";
	}else{
		document.getElementById("fw_frame").cols = "0,*";
	}
}
</script>
</head>
<frameset rows="76,*" frameborder="NO" border="0" framespacing="0" marginwidth="0" marginheight="0" name="main">
	<frame id="fw_top" src="ADM000.A02.cmd" name="top">
	<frameset id="fw_frame" cols="470,*" frameborder="YES" border="0" framespacing="0" marginwidth="0" marginheight="0" >
		<frame id="fw_left" src="AC_LIST_GRP.cmd" name="left" scrolling="yes">
		<frame id="fw_right" src="ADM000.A03.cmd" name="right" scrolling="yes">
	</frameset>
</frameset>

</html>