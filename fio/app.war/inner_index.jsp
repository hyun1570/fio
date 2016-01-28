<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ include file="views/include/common.jsp"%>
<%
String userId = request.getParameter("userId");
if(userId == null || userId.equals("")){
%>
    <script>
    alert("잘못된 접근입니다.");
    </script>
<%  
}else{
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script>
$(window).load(function(){
    var jsonObj = {};

    jsonObj.userId       = "<%=request.getParameter("userId")%>";
    
    $.ajax({
        type      : "POST",
        url       : "DDTA000.MI2.cmd",
        dataType  : "json",
        data      : {"param" : JSON.stringify(jsonObj)},
        async     : false,
        beforeSend: function(xhr)
        {
            // 전송 전 Code
        },
        success   : function(result)
        {
            location.href="<%=request.getContextPath()%>/DDTA000.M03.cmd";
        },
        error     : function(e)
        {
            console.log(e);
        }

    });
});

</script>
<%
}
%>
</head>
</html>