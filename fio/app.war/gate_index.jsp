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
//초기화
$(window).load(function()
{
    var sData = CookieVal("saveId");

    if (sData != "null")
    {
        frm.userId.value = sData;
        //frm.idCheck.checked = true;
        frm.userPassword.focus();
    }
    else
    {
        frm.userId.focus();
    }
    
    
});

// ID 저장
function setSaveId(userId)
{
    var toDay = new Date();
/*
    if (frm.idCheck.checked == true) // 쿠키 설정
    {
        toDay.setDate(toDay.getDate() + 30); // 30 Day

        document.cookie = "saveId=" + escape(userId) + "; path=/; expires=" + toDay.toGMTString();
    }
    else
    {
        // 현재시간으로 설정하여 쿠키를 삭제
        document.cookie = "saveId=" + escape(userId) + ";path=/;expires=" + toDay.getTime();
    }
*/    
}

// 쿠기 ID 가져오기
function CookieVal(cookieName)
{
    var search = cookieName + "=";

    if (document.cookie.length > 0)
    {
        offset = document.cookie.indexOf(search);

        if (offset != -1)
        {
            offset += search.length;
            end = document.cookie.indexOf(";", offset);

            if (end == -1)
            {
                end = document.cookie.length;
            }

            return document.cookie.substring(offset, end); // 쿠키가 있으면 쿠키값 파싱후 리턴
        }
    }

    return "null"; // 쿠키가 없으면 null
}

// Key Down
function keyDown()
{
    if (event.keyCode == 13) login();
}

// 로그인
function login()
{
    if (frm.userId.value == "")
    {
        alert("'사용자 아이디'를 입력하여 주십시오.");
        frm.userId.focus();
        return;
    }

    if (frm.userPassword.value == "")
    {
        alert("'비밀번호'를 입력하여 주십시오.");
        frm.userPassword.focus();
        return;
    }
    
    setSaveId(frm.userId.value); // ID 저장

    var jsonObj = {};

    jsonObj.userId       = frm.userId.value;
    jsonObj.userPassword = frm.userPassword.value;
    
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
            if (result.status == false) 
            {
                alert("'ID', 'Password'를 확인하여 주십시오.");
                return;
            }
            
            goMain();
        },
        error     : function(e)
        {
            console.log(e);
        }
    });
    
}

function goMain()
{
    $("#frm").attr({
        action : "DDTA000.M03.cmd",
        target : "_self",
        method : "POST"
    });

    $("#frm").submit();
}
</script>
<jsp:include page="views/include/hidden.jsp" flush="false"/>
</head>
<body style="margin:0px">
<form id="frm" name="frm" method="post">
<div style="background:url('<%=request.getContextPath()%>/resources/images/gate_login.jpg');width:1366px;height:768px;border:0px solid red">
</div>
<div style="position:absolute;height:35px;width:550px;border:0px solid blue;top:520px;left:165px;" alt="공장 출입요청 화면으로 이동">
    <input type="text" style="width:162px;border:0px;margin-top:7px;margin-left:3px" name="userId"/>
    <input type="password" style="width:162px;border:0px;margin-top:7px;margin-left:4px;" name="userPassword" onKeyPress="keyDown()"/>
    <div style="border:0px solid red;margin-left:110px;width:75px;height:40x;position:relative;display:inline-block;cursor:pointer" onclick="login()">&nbsp;</div>
</div>
</form>
</body>
</html>