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

var jsonObj;


//초기화
$(window).load(function() {
	var param = <%=URLDecoder.decode(request.getParameter("param"), "UTF-8")%>;
	if(param.sTypeNm){
// 		frm.sTypeNm.value =  decodeURI(param.sTypeNm);
	}
	frm.sTypeNm.focus();
});


//페이지 Action
function getPopUpPageAction(action) {
	switch(action) {
		case 2 : // 조회
		
			$("#tblList tbody tr").remove();

		
			var jsonObj	= {}; 
			jsonObj.sType	= frm.sType.value;
			jsonObj.sTypeNm	= frm.sTypeNm.value;
			jsonObj.sqlid	= "Common.DEPT_Pop";
			jsonObj.siteCode= frm.sessionSiteCode.value;
			jsonObj.status	= "Y";
			jsonObj.sBpCode		= param.sBpCode;

			$.ajax({
				type		: "POST",
				url			: "DDTA.BASE.SERVICE.R00.cmd",
				dataType	: "json",
				data		: {"param" : JSON.stringify(jsonObj)},
				async		: false,
				beforeSend	: function(xhr) {
					// 전송 전 Code
				},
				success		: function(result) {
					if( result.length > 0 ) {
						for( i = 0; i < result.length; i++ ) {
					    	items	= result[i];
					    	
					    	var chkVal	= items.deptName+"!@$"+items.deptCode+"!@$"+items.bussCode+"!@$"+items.nodeCode;
					    	var newRow	= ""
					    	+ "<tr>"
					    	+ "<td style='background: #505050;color:#ffffff;font-weight:bold;'>" + ( i + 1 ) + "</td>"
					    	+ "<td><input type='radio' name='chk' value='" + chkVal + "'></td>"
					    	+ "<td class='tal'>&nbsp;" + items.deptName + "</td>"
					    	+ "</tr>";
							
					    	$("#tblList tbody").append(newRow);
						}
						$("input[name=chk]:radio:first").prop("checked", true);
						
						if( result.length == 1 ) {
							getPopUpPageAction(3);
						}
						
					} else {
						var newRow	= ""
					    	+ "<tr>"
					    	+ "<td colspan='3' style='color:#FECA6B;font-size:font-weight:bold;'>No data found.</td>"
					    	+ "</tr>";
							
					    	$("#tblList tbody").append(newRow);
					}
					
				},
				error		: function(e) {
					alert(e.responseText);
				}
			});

			break;

		case 3 : // 적용
			var selVal	= $("input[name=chk]:radio:checked").val();   
			var vals	= selVal.split("!@$");
			
			var row	= {
					deptName:vals[0],
					deptCode:vals[1],
					bussCode:vals[2],
					nodeCode:vals[3]
			};
			
			// Data 전송
			setCommonCodePopUpData(row);

			break;

		case 9 : // 닫기
			parent.wd.close();        
			break;
	}
}


//Key Up
function keyUp(event) {
	if(event.keyCode == 13){
		getPopUpPageAction(2);
	}
}

//Data 전송
function setCommonCodePopUpData(obj) {
	parent._setDataValue(obj);
	getPopUpPageAction(9);
}

</script>
</head>
<body>
	<div class="popup_header">방문처</div>
	
	<div class="hspace10"></div>
	
	<div class="popup_content">
		<form id="frm" name="frm">        
		
		<!-- Hidden 객체 Include -->
		<jsp:include page="/views/include/hidden.jsp" flush="false" />
		<jsp:include page="/views/include/session.jsp" flush="false" />
		
		<table class="search_area">
			<tr>
				<td align="left" width="65%"> 
					<span>
						<select name="sType" class="selectbox_search" style="width:100px">
							<option value="sDeptName">방문처명</option>
						</select>
					</span>
				<span>	                
				<input type="text" id="sTypeNm" name="sTypeNm" class="textbox_search_lmargin" onkeyup="keyUp(event)"/>
				</td>
				<td align="right" width="35%">               
					<a href="javascript:void(0)" onclick="getPopUpPageAction(2)" class="btn_search"><span class="btn_search_left">조회</span></a>
					<a href="javascript:void(0)" onclick="getPopUpPageAction(3)" class="btn_check"><span class="btn_check_left">적용</span></a>
				</td>
			</tr>
		</table>
		
		<div style="width:100%; background: #f7f7f7; text-align:center;">
			
			<table class="tbl_colored">
				<colgroup>
					<col width="8%"/>
					<col width="5%"/>
					<col width="*"/>
				</colgroup>
				<tbody>
					<tr>
						<td class="tbl_colored_title"></td>
						<td class="tbl_colored_title"></td>
						<td class="tbl_colored_title tac">부서명</td>
					</tr>
				</tbody>
			</table>
			
		</div>
		
		<div style="width:100%; height:350px; background: #ffffff; text-align:center;overflow-x:none; overflow-y:auto;">
			
			<table id="tblList" class="tbl_colored">
				<colgroup>
					<col width="8%"/>
					<col width="5%"/>
					<col width="*"/>
				</colgroup>
				<tbody>
					<tr>
						<td colspan='3'></td>
					</tr>
				</tbody>
			</table>
			
		</div>
		
		<input type="text" id="x" name="x" style="width:0px;height:0px;border:0px"/>
		
		</form>
			
		<div class="hspace10 cl"> </div>
		
	</div>
</body>
</html>
