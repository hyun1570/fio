<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="java.net.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/views/include/css.jsp"%>
<%@ include file="/views/include/common.jsp"%>
<script language="javascript">
//파라메터 생성
var _pm="";
var _j = JSON.parse('${param.param}');

//Json Object를 String 파라메터로 변환
for (a in _j)
{
    _pm += "&"+a+"="+_j[a]; 
}

//업로드 폼
var myForm, formData;

//업로드 폼 생성
function doOnLoad() {
        
    formData = [
        {type: "fieldset", 
         label: "파일", list:[
            {
                type: "upload", 
                name: "myFiles", 
                inputWidth: 500, 
                url: "DDTAS00.S01.cmd?folder=${SESSION_SITE_CODE}"+_pm, 
                _swfLogs: "enabled", 
                swfPath: "<%=request.getContextPath()%>/resources/objects/uploader.swf", 
                titleScreen: true,
                swfUrl: "DDTAS00.S01.cmd"
            }
        ]}
    ];
    myForm = new dhtmlXForm("myForm", formData);
    
    myForm.attachEvent("onUploadComplete",function(count){
    	
        if(count > 0)
        {
            alert("정상적으로 '첨부' 되었습니다.");
            parent.getParentFileList();
        }
     });
}

// 초기화
$(window).load(function()
{ 
    //업로드폼 초기화
    doOnLoad();
});

function closePop(){
	
}
</script>
</head>
<body>
    <div class="popup_header">첨부파일</div>
    <div class="hspace10"></div>
    <div class="popup_content">
        <form id="frm" name="frm">
            <!-- Hidden 객체 Include -->
            <jsp:include page="/views/include/hidden.jsp" flush="false" />
            <jsp:include page="/views/include/session.jsp" flush="false" />
        
            <table>
		        <tr>
		            <td>
		                <div id="myForm" style="width:100%"></div>
		                <form name="frmAtt" id="frmAtt" method="post">
		                </form>
		            </td>
		        </tr>        
            </table>
        </form>
    </div>
</body>
</html>
        