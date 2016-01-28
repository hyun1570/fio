<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>


<head>
    <title>출입관리</title>
</head>

<%@ include file="views/include/common.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script>

$(window).load(function(){
	goLogin();
});

function goLogin(){
	var jsonObj = {};
	
	jsonObj.userId       = "GUEST";
	jsonObj.userPassword = "GUEST";
	
	
	
	$.ajax({
	    type      : "POST",
	    url       : "DDTA000.M02.cmd",
	    dataType  : "json",
	    data      : {"param" : JSON.stringify(jsonObj)},
	    async     : false,
	    beforeSend: function(xhr)
	    {
	        // 전송 전 Code
	    },
	    success   : function(result)
	    {
	        //console.log(result);
	        var  p = window.location.pathname;
	        var frm = document.frm;
	        frm.action = "<%=request.getContextPath()%>/DDTA.RSVTN.PE1.cmd";
	        frm.method ="POST";
	        frm.target = "_self";
	        frm.submit();
	    },
	    error     : function(e)
	    {
	        console.log(e);
	    }
	});
}

</script>
<jsp:include page="views/include/hidden.jsp" flush="false"/>
</head>
<body style="margin:0px">
<form id="frm" name="frm" method="post">
</form>
</body>
</html>