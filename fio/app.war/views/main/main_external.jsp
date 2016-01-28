<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>

<%@ include file="/views/include/css.jsp"%>
<%@ include file="/views/include/common.jsp"%>
<script language="javascript">
$(window).load(function(){
    //getCurrencyRate();
    //getMainItemCount();
});

function getMainItemCount()
{
    var jsonObj = {};
    
    jsonObj.docName   = $.trim($("#docName").val());
    jsonObj.fromDate  = getCommonCalcDate(-7);
    
    $.ajax({
        type      : "POST",
        url       : "/grid/select/Main.getMainList.do",
        dataType  : "json",
        data      : {"param" : JSON.stringify(jsonObj)},
        async     : false,
        beforeSend: function(xhr)
        {
            // 전송 전 Code
        },
        success   : function(result)
        {
            $.each(result, function() {
              $.each(this, function(k, v) {
                $("#"+k).text("("+v+")");
              });
            });
         
        },
        error     : function()
        {
            // Error 발생 Code
        }
    });

}


</script>
</head>
<body>
   <div id="wrap" >
        <%@ include file="/views/include/top.jsp"%>
            <div id="content">
                <div id="mainBack"></div>
                <div id="logo"><img src="<%=request.getContextPath()%>/resources/images/common/kyungshin-logo.png" alt="System Login" /></div>
            </div>        
    </div>
    <%@ include file="/views/include/bottom.jsp"%>
</body>
</html>             