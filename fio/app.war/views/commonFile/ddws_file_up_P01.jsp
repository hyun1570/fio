<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>동부대우전자</title>

<%@ include file="/views/include/css.jsp"%>
<%@ include file="/views/include/common.jsp"%>

<script language="javascript" charset="utf-8">

var myForm;
var formData;

function doOnLoad()
{
    dhtmlx.skin = "dhx_web";
    
    var width = document.body.clientWidth;
    
    var jsonObj = {};
    
    jsonObj.boardId = parent.boardId;           // 공지사항ID
    jsonObj.regId   = frm.sessionUserId.value;  // 사용자ID
    
    formData = [
                {
                    type  : "fieldset",
                    label : "Uploader",
                    list  : [
                             {
                              type        : "upload",
                              name        : "myFiles",
                              method      : "post",
                              inputWidth  : (width - 90),
                              inputHeight : 80,
                              url         : "DDWS.BASE.SERVICE.X01.cmd?param=" + JSON.stringify(jsonObj),
                              _swfLogs    : "enabled",
                              swfPath     : "<%=request.getContextPath()%>/resources/dhtmlx/dhtmlxForm/codebase/ext/uploader.swf",
                              swfUrl      : "DDWS.BASE.SERVICE.X01.cmd" + param
                             }
                            ]
                }
               ];

    myForm = new dhtmlXForm("myForm", formData);
    
    //parent.fileUpLaodList(); // 파일 업로드 리스트 조회
}
</script>
</head>

<body id="popupbody" onload="doOnLoad()">
<div id="popcontent">
<form id="frm" name="frm">

    <!-- Hidden 객체 Include -->
    <jsp:include page="/views/include/hidden.jsp"  flush="false" />
    <jsp:include page="/views/include/session.jsp" flush="false" />

    <div class="titlearea">
        <div class="contitle">
            <h2>파일 업로드</h2>
        </div>
    </div>
    <div id="myForm" style="wdith:100%;margin-bottom:10px"></div>
</form>
</div>
</body>
</html>
