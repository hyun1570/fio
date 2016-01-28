<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%
try{
String errorCode = request.getParameter("errorCode");
String msg = "";
if(errorCode.equals("NPA")){
	msg = "잘못된 페이지 접근입니다.";
}else{
	throw new Exception("Error");
}

%>

<html>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<body>
    
    <div style="border-bottom:3px solid blue;font-size:36px;font-weight:bold;margin-bottom:15px">Error Page</div>
    <strong style="color:red;font-size:20px"><%=msg%></strong>
</body>
</html>
<%
}catch(Exception e){
%>
<html>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<body>
    
    <div style="border-bottom:3px solid blue;font-size:36px;font-weight:bold;margin-bottom:15px">Error Page</div>
    <strong style="color:red;font-size:20px">PAGE Load에 실패하였습니다.</strong>
</body>
</html>    
<%    
}
%>