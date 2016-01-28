<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/views/include/css.jsp"%>
<%@ include file="/views/include/common.jsp"%>
<script src="<%=request.getContextPath()%>/resources/js/jquery-1.8.3.js"></script>
<script src="<%=request.getContextPath()%>/resources/js/jquery-ui.js"></script>

<script language="javascript">

var autoTexts;
var _frmNM;

//초기화
$(window).load(function()
{
	getAutoCompleteTexts();
});

function getAutoCompleteTexts(){
	var jsonObj={};
    jsonObj.sqlid      = "Common.VIST_COMP_POP";
    
	$.ajax({
        type       : "POST",
        url        : "DDTA.BASE.SERVICE.R00.cmd",
        dataType   : "json",
        data       : {"param" : JSON.stringify(jsonObj)},
        async      : false,
        beforeSend : function(xhr)
        {
            // 전송 전 Code
        },
        success    : function(result)
        {
            
        	console.log(JSON.stringify(result));
        	
            autoTexts = new Array(result.length);
            for(var i = 0; i < result.length; i++){
            	autoTexts[i] = result[i].vsitCompName;
            	console.log(result[i].vsitCompName);
            }
            
            setAutoComplete();
            
        },
        error      : function(e)
        {
            alert(e.responseText);
        }
    });
}

function setAutoComplete(){
	$("#test").autocomplete({source:autoTexts});
}



</script>
</head>
<body id="popupbody">

<div id="popcontent">
<form id="frm" name="frm">

	<!-- Hidden 객체 Include -->
	<jsp:include page="/views/include/hidden.jsp" flush="false" />
	<jsp:include page="/views/include/session.jsp" flush="false" />

    <div class="titlearea">
        <div class="contitle">
            <h2 id="codeTitle">업체명</h2>
        </div>
    </div>
    <div class="trbtn">
        <a class="rbtn"  href="javascript:getPopUpPageAction(3)"><span>닫기</span></a>
    </div>
    <div class="search mt4">
        <table>
            <colgroup>
                <col width="10%" />
                <col width="*" />
            </colgroup>
            <tr>
            	<td>
                <div class="ui-widget">
					<input id="test" name="test" type="text"/>
                </div>
                </td>
            </tr>
        </table>
    </div>
</form>
</div>
</body>
</html>
