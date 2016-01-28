<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Admin</title>
<%@ include file="/views/include/common2.jsp"%>
<link rel="STYLESHEET" type="text/css" href="resources/css/base.css" >
<link rel="STYLESHEET" type="text/css" href="resources/css/login.css" >
<%@ include file="views/include/common.jsp"%>

<script>
var ccnt = 0;
var maxtime = 30;
function closeWindow(){
	//console.log("closeWindow == >"+ccnt);
	if(ccnt < maxtime){
		ccnt += 1;
		setTimeout(setTextTimeOut, 1000);
		clearTimeout();
		
	}else{
		alert("웹포탈로 이동합니다.");
		document.location.href="http://webportal.dwe.co.kr";
	}
}
function setTextTimeOut(){
	//console.log("setTextTimeOut == >"+ccnt);
	$("#xxx").html((maxtime-ccnt)+"초 후 자동으로 웹포탈로 이동합니다.");
	closeWindow();
}
$(window).load(function(){
	closeWindow();
});
</script>
<body>
<div style="width:100%;height:500px;text-align:center;border:0px solid red;padding-top:200px" >
<img src="/fio/resources/css/images/noenter.png"  style="width:100px;height:100px"/><br/>
<span style="font-size:20px;font-weight:bold">※ 잘못된 URL접근입니다.<br/></span>
<span id="xxx" style="color:red">30초 후 자동으로 웹포탈로 이동합니다.</span>
</div>

</body> 
</html>
