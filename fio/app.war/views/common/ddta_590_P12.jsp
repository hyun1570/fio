<%@	page language="java" contentType="text/html; charset=utf-8"	pageEncoding="UTF-8"%>
<%@	taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page	import="java.net.*"	%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>

<meta http-equiv="Content-Type"	content="text/html;	charset=utf-8" />

<%@	include	file="/views/include/css.jsp"%>
<%@	include	file="/views/include/common.jsp"%>

<script	language="javascript">

var	jsonObj;
var param = <%=URLDecoder.decode(request.getParameter("param"), "UTF-8")%>;

//초기화
$(window).load(function() {
	if(param.sTypeNm){
// 		frm.sTypeNm.value = decodeURI(param.sTypeNm);
	}
	frm.sTypeNm.focus();
	
	jsonObj	= {};
	jsonObj.sqlid	= "Common.GET_COMM_CODE_INFO";
	jsonObj.hcode	= "H140";	//공장코드
	jsonObj.sBpCode	= param.sBpCode;
	jsonObj.code	= "dcode";
	jsonObj.value	= "dname";

	// 공장코드	콤보 셋팅
	setComboBySqlIdOptionAll("sFactCode", jsonObj, "전체");
});


//페이지 Action
function getPopUpPageAction(action) {
	switch(action) {
		case 2 :	//조회
			$("#tblList tbody tr").remove();
		
			var	jsonObj	= {};
			jsonObj.sType		= frm.sType.value;
			jsonObj.sTypeNm		= frm.sTypeNm.value;
			jsonObj.sqlid		= "Common.USER_Pop";
			jsonObj.status		= "Y";
			jsonObj.sFactCode	= frm.sFactCode.value;
			jsonObj.sBpCode		= param.sBpCode;
		
			$.ajax({
				type		: "POST",
				url			: "DDTA.BASE.SERVICE.R00.cmd",
				dataType	: "json",
				data		: {"param" :	JSON.stringify(jsonObj)},
				async		: false,
				beforeSend	: function(xhr) {},
				success	   : function(result) {
					if( result.length > 0 ) {
						for( i = 0; i < result.length; i++ ) {
					    	items	= result[i];
					    	
					    	var deptName     = (items.deptName    == undefined ? '' : items.deptName     ); 
					    	var kname        = (items.kname       == undefined ? '' : items.kname        );
					    	var dutyRankName = (items.dutyRankName== undefined ? '' : items.dutyRankName );
					    	var email        = (items.email       == undefined ? '' : items.email        );
					    	var officeTel    = (items.officeTel   == undefined ? '' : items.officeTel    );

					    	var chkVal	= (items.deptCode  == undefined ? '' : items.deptCode  )
					    				+ "!@$" + (items.deptName  == undefined ? '' : items.deptName  )
					    				+ "!@$" + (items.factCode  == undefined ? '' : items.factCode  )
					    				+ "!@$" + (items.kname     == undefined ? '' : items.kname     )
					    				+ "!@$" + (items.officeTel == undefined ? '' : items.officeTel )
					    				+ "!@$" + (items.email     == undefined ? '' : items.email     )
					    				+ "!@$" + (items.sno       == undefined ? '' : items.sno       );
					    	
					    	var newRow	= ""
					    	+ "<tr onclick=''>"
					    	+ "<td style='background: #505050;color:#ffffff;font-weight:bold;'>" + ( i + 1 ) + "</td>"
					    	+ "<td><input type='radio' name='chk' value='" + chkVal + "'></td>"
					    	+ "<td class='tal'>&nbsp;" + deptName     + "</td>"
					    	+ "<td class='tal'>&nbsp;" + kname        + "</td>"
					    	+ "<td>" + dutyRankName + "</td>"
					    	+ "<td class='tal'>&nbsp;" + email        + "</td>"
					    	+ "<td>" + officeTel    + "</td>"
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
					    	+ "<td colspan='7' style='color:#FECA6B;font-size:font-weight:bold;'>No data found.</td>"
					    	+ "</tr>";
							
					    	$("#tblList tbody").append(newRow);
					}
				},
				error	   : function(e) {
					alert(e.responseText);
				}
			});

	break;

		case 3 : // 적용
			var selVal	= $("input[name=chk]:radio:checked").val();   
			var vals	= selVal.split("!@$");
			
			var row	= {
					deptCode	: vals[0],
					deptName	: vals[1],
					factCode	: vals[2],
					kname		: vals[3],
					officeTel	: vals[4],
					email		: vals[5],
					sno			: vals[6]
			};
			
			// Data 전송
			setCommonCodePopUpData(row);

			break;

		case 9 : //	닫기
			parent.wd.close();
			break;
	}
}


//Data 전송
function setCommonCodePopUpData(obj) {
	parent._setDataValue(obj);
	getPopUpPageAction(9);
}


$(document).ready(function(event){
	$("#sTypeNm").keydown(function(event){
		if(event.keyCode ==	13){
			getPopUpPageAction(2);
		}
	});
})

</script>
</head>
<body>
	<!-- Hidden	객체 Include -->
	<jsp:include page="/views/include/hidden.jsp" flush="false"	/>
	<jsp:include page="/views/include/session.jsp" flush="false" />

	<div class="popup_header">면담자</div>
	
	<div class="hspace10"></div>
	
	<div class="popup_content">
	
		<form id="frm" name="frm">
		
		<table class="search_area">
			<tr>
				<td>공장명</td>
				<td>
					<select	id="sFactCode" name="sFactCode">
						<option	value=""></option>
					</select>
				</td>
				<td	class="text_addstar">
					면담자명
					<input type="hidden"	id="sType" name="sType"	value="userName"/>
				</td>
				<td>
					<input type="text" id="sTypeNm"	name="sTypeNm" class="textbox_search_lmargin w80"/>
				</td>
				<td	align="right">
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
					<col width="20%"/>
					<col width="13%"/>
					<col width="16%"/>
					<col width="20%"/>
					<col width="18%"/>
				</colgroup>
				<tbody>
					<tr>
						<td class="tbl_colored_title"></td>
						<td class="tbl_colored_title"></td>
						<td class="tbl_colored_title tac">부서</td>
						<td class="tbl_colored_title tac">면담자</td>
						<td class="tbl_colored_title tac">직위</td>
						<td class="tbl_colored_title tac">EMAIL</td>
						<td class="tbl_colored_title tac">연락처</td>
					</tr>
				</tbody>
			</table>
			
		</div>
		<div style="width:100%; height:350px; background: #ffffff; text-align:center;overflow-x:none; overflow-y:auto;">
			
			<table id="tblList" class="tbl_colored">
				<colgroup>
					<col width="8%"/>
					<col width="5%"/>
					<col width="20%"/>
					<col width="13%"/>
					<col width="16%"/>
					<col width="20%"/>
					<col width="18%"/>
				</colgroup>
				<tbody>
					<tr>
						<td colspan='7'></td>
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
