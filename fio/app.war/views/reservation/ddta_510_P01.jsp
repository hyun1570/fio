<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="java.net.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/views/include/css.jsp"%>
<%@ include file="/views/include/common.jsp"%>
<script>
$(window).load(function(){
	var param = <%=request.getParameter("param")%>;
	frm.vsitRsvtnNo.value = isNullStr(param.vsitRsvtnNo);
	frm.acceptCode.value = isNullStr(param.acceptCode);
	document.getElementById("vsitReqNo").innerHTML = isNullStr(param.vsitRsvtnNo);
	getPopPageAction(2);
});

function getPopPageAction(action){
	  switch(action){
	      case 2:
	    	  var jsonObj = {};
	    	  jsonObj.vsitRsvtnNo = $("#vsitRsvtnNo").val();
              jsonObj.sqlid = "Reservation.GET_RSVTN_M";

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

                	  document.getElementById("vsitRsvtnDate").innerHTML = isNullStr(result[0].vsitRsvtnDate);
                	  frm.confirmYn.value = "N";
// console.log("인증번호 ==>"+result[0].acceptCode);                	  
                	  frm.vsitRsvtnMId.value = isNullStr(result[0].vsitRsvtnMId);
                	  frm.intvUserMail.value = isNullStr(result[0].intvUserMail);
                	  frm.deptName.value = isNullStr(result[0].deptName);
                	  frm.intvUserName.value = isNullStr(result[0].intvUserName);
                	  frm.apprStatus.value = isNullStr(result[0].apprStatus);
                	  setVisitors(result[0].vsitRsvtnMId);
                  },
                  error      : function(e)
                  {
//                 	  console.log(result.length);
                	  alert(e.responseText);
                  }
              });
	    	  
	    	  break;
	    	  
	      case 9 : // 닫기
	            parent.wd.close();        
	            break;
	  
	  }
	
}

var mail_vsitor = "";

function setVisitors(mid){

	var jsonObj ={};
    jsonObj.vsitRsvtnMId = mid;
    jsonObj.sqlid = "Reservation.GET_RSVTN_D";
    
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
        	var visitors_txt = "";

        	frm.vsitUserMail.value = isNullStr(result[0].vsitUserMail);
        	
        	mail_vsitor = "";
            if(result.length > 2){
                mail_vsitor = " 외 "+(result.length - 1)+"명";
            }
        	for(var i = 0 ; i < result.length; i++){
        		
        		if(i == 0){
        			visitors_txt += isNullStr(result[i].vnum) + ") "+ isNullStr(result[i].vsitCompName) + " " + isNullStr(result[i].vsitUserNm);
        			mail_vsitor = isNullStr(result[i].vsitCompName) + " " + isNullStr(result[i].vsitUserNm) + mail_vsitor;
        		}else{
        			visitors_txt += "<br/>"+ isNullStr(result[i].vnum) + ") "+ isNullStr(result[i].vsitCompName) + " " + isNullStr(result[i].vsitUserNm);
        		}
        	}
        	document.getElementById("visitors").innerHTML = visitors_txt;
        	
        	
        },
        error      : function(e)
        {
            alert(e.responseText);
        }
    });
}

//인증번호 확인
function confirmAcceptCode(){
	var jsonObj = {};
    jsonObj.vsitRsvtnNo = $("#vsitRsvtnNo").val();
    jsonObj.sqlid = "Reservation.GET_RSVTN_M";

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
            if(frm.acceptCode.value == isNullStr(result[0].acceptCode)){
            	alert("인증번호가 확인 되었습니다.");
                frm.confirmYn.value = "Y";
                frm.acceptCode.setAttribute("readonly", "readonly");
                $("#confirm_btn").css("display", "none");
            }else{
            	alert("인증번호가 맞지 않았습니다.\n다시 확인해 주십시오.");
                frm.acceptCode.focus();
                $("#confirm_btn").css("display", "inline-block");
            }
        },
        error      : function(e)
        {
//             console.log(result.length);
            alert(e.responseText);
        }
    });
	
	
	
	
}


// 승인 및 반려
function reservationAppr(action){
	var actionTxt = "";
	var jsonArray = [];
	
    if(action == "A"){
        actionTxt = "승인";
    }else{
    	actionTxt = "반려";
    }
	
	if(frm.confirmYn.value == "N"){
		alert("인증번호를 확인해 주십시오.");
		frm.acceptCode.focus();
		return;
	}
	
	if(frm.apprStatus.value == "A" || frm.apprStatus.value == "R"){
		alert("이미 처리한 건 입니다.");
		return;
	}
	
	if(!confirm(actionTxt+"하시겠습니까?")) return;
	
	
    var jsonObj = {};
    jsonObj.sqlId        = "Reservation.UPT_RSVTN_APPR";
    jsonObj.command      = "U";
    jsonObj.apprStatus   = action;
    jsonObj.vsitRsvtnMId = $.trim(frm.vsitRsvtnMId.value);
    jsonObj.apprRemark   = $.trim(frm.apprRemark.value);
    
    jsonArray.push(jsonObj);
    
    var mailContent = "";
    mailContent += "<h1>출입예약 승인/반려</h1><br/>";
    mailContent += "<table width='500px' cellpadding='3' cellspacing='0' border='1' bordercolor='#cdcdcd'>";
    mailContent += "    <COLGROUP>";
    mailContent += "        <COL WIDTH='30%'/>";
    mailContent += "        <COL WIDTH='70%'/>";
    mailContent += "    </COLGROUP>";
    mailContent += "<tr style='height:30px'>";
    mailContent += "<th style='background:#efefef'>출입 예약번호</th>";
    mailContent += "<td>"+$.trim(frm.vsitRsvtnNo.value)+"</td>";
    mailContent += "</tr>";
    mailContent += "<tr style='height:30px'>";
    mailContent += "<th style='background:#efefef'>출입 예정일</th>";
    mailContent += "<td>"+$("#vsitRsvtnDate").text()+"</td>";
    mailContent += "</tr>";
    mailContent += "<tr style='height:30px'>";
    mailContent += "<th style='background:#efefef'>방문처</th>";
    mailContent += "<td>"+$.trim(frm.deptName.value)+"</td>";
    mailContent += "</tr>";
    mailContent += "<tr style='height:30px'>";
    mailContent += "<th style='background:#efefef'>면담자</th>";
    mailContent += "<td>"+$.trim(frm.intvUserName.value)+"</td>";
    mailContent += "</tr>";
    mailContent += "<tr style='height:30px'>";
    mailContent += "<th style='background:#efefef'>출입자</th>";
    mailContent += "<td>"+mail_vsitor+"</td>";
    mailContent += "</tr>";
    mailContent += "<tr height='50px'>";
    mailContent += "<th style='background:#efefef'>사유</th>";
    mailContent += "<td>"+$("#apprRemark").text()+"</td>";
    mailContent += "</tr>";
    mailContent += "</table><br/>";
    mailContent += "상기 출입예약이 "+actionTxt+" 되었습니다.";
    
    // 메일처리
    var jsonMail = {};
    // 내용 처리용
    jsonMail.contents = mailContent;
    jsonMail.mergeSqlId = "";
    
    jsonMail.vsitRsvtnNo = $.trim(frm.vsitRsvtnNo.value);
    
    jsonMail.subject = "[출입관리]출입예약 요청이 "+actionTxt+" 되었습니다.";
    
    jsonMail.from=$.trim(frm.intvUserMail.value); // From mail
    
    jsonMail.to=$.trim(frm.vsitUserMail.value);    // To Mail
    jsonMail.ccm=""; // CC
    
    jsonMail.command = "Mail";
    jsonArray.push(jsonMail);

    doAjax2(jsonArray, function(ret){
    	if(ret == "SUCCESS"){
    		frm.apprStatus.value = action;
	    	alert("출입예약이 "+actionTxt+" 되었습니다.");
	    	if(parent){
		    	parent.getPageAction(2);
		        getPopPageAction(9);
	    	}
    	}else{
    		alert("처리에 실패하였습니다.");
    	}
    });
	
/*	
	var jsonObj = {};
	jsonObj.sqlid        = "Reservation.UPT_RSVTN_APPR";
	jsonObj.apprStatus   = action;
	jsonObj.vsitRsvtnMId = frm.vsitRsvtnMId.value.trim();
	jsonObj.apprRemark   = frm.apprRemark.value.trim();
	
	
    $.ajax({
        type       : "POST",
        url        : "DDTA.BASE.SERVICE.U00.cmd",
        dataType   : "json",
        data       : {"param" : JSON.stringify(jsonObj)},
        async      : false,
        beforeSend : function(xhr)
        {
            // 전송 전 Code
        },
        success    : function(result)
        {

            if (result == "SUCCESS")
            {
                alert("정상적으로 '"+actionTxt+"' 되었습니다.");
                parent.getPageAction(2);
                getPopPageAction(9);
                
            }else{
                alert("'처리'에 실패하였습니다.");
            }
        },
        error      : function(e)
        {
            alert("에러" + e.responseText);
        }
    });
*/

    



}

</script>
</head>

<body>
    <div class="popup_header">출입 예약 승인/반려</div>
	<div class="hspace10"></div>
	<div class="popup_content">
	    <form id="frm" name="frm">
	       <!-- Hidden 객체 Include -->
            <jsp:include page="/views/include/hidden.jsp" flush="false" />
            <jsp:include page="/views/include/session.jsp" flush="false" />
    
		    <input type="hidden" id="intvUserMail" name="intvUserMail" />
		    <input type="hidden" id="vsitUserMail" name="vsitUserMail" />
		    <input type="hidden" id="deptName" name="deptName" />
		    <input type="hidden" id="intvUserName" name="intvUserName" />
		    <input type="hidden" id="apprStatus" name="apprStatus"/>
		    
		    <table cellpadding="0" cellspacing="0" border="0" style="width:100%">
                <tr>
                    <td align="left"><div class="popup_subtitle mb10">출입예약 정보</div></td>
                    <td align="right">
	                    <a href="#" onclick="reservationAppr('A')" class="btn_check"><span class="btn_check_left">승인</span></a>
	                    <a href="#" onclick="reservationAppr('R')" class="btn_reset"><span class="btn_reset_left">반려</span></a>
                    </td>
                </tr>
            </table>

		    <div style="width:100%; background: #f7f7f7; text-align:center">
				<table class="tbl_colored">
	                <colgroup>
	                    <col width="100px"/>
	                    <col width="*"/>
	                </colgroup>
					<tr>
					    <td class="tbl_colored_title tar" >인증번호</td>
					    <td class="textbox_intd tal">
<!-- 							<input type="hidden" id="rAcceptCode" name="rAcceptCode"/> -->
							<input type="hidden" id="confirmYn" name="confirmYn"/>
							<input type="text" id="acceptCode" name="acceptCode" class="textbox_intd"/>
							<a href="#" onclick="confirmAcceptCode()" class="btn_intd" id="confirm_btn"><span class="btn_intd_left">인증번호 확인</span></a>
					    </td>
					</tr>
					<tr>
						<td class="tbl_colored_title tar">출입 예약번호</td>
						<td class="textbox_intd  tal">
	                        <input type="hidden" id="vsitRsvtnMId" name="vsitRsvtnMId"/>
	                        <input type="hidden" id="vsitRsvtnNo" name="vsitRsvtnNo" class="textbox_intd_noborder wp90" readonly="readonly"/>
					        <span id="vsitReqNo"></span>
					    </td>
					</tr>
					<tr>
						<td class="tbl_colored_title tar">출입 예정일</td>
						<td class="textbox_intd  tal">
						   <span id="vsitRsvtnDate"></span>
						</td>
					</tr>
					<tr>
						<td class="tbl_colored_title tar">출입자</td>
						<td class="textbox_intd  tal">
							<div id="visitors" style="width:100%;height:80px;overflow-y:scroll;text-align:left"></div>
					    </td>
					</tr>
				</table>
		    </div>

		    
	        <div class="popup_subtitle mt10 mb5">사유</div>
	        <div style="width:100%;background: #f7f7f7; text-align:center">
	            <table class="tbl_colored" width="100%">
	                <colgroup>
	                    <col width="100px"/>
	                    <col width="*"/>
	                </colgroup>
	                <tr>
	                    <td class="tbl_colored_title tar">내용</td>
	                    <td class="textbox_intd  tal">
	                        <textarea id="apprRemark" name="apprRemark" style="width:99%;border:1px #CCC solid" rows="6" maxlength="1000" class="mb2 mt2 mr2"></textarea>
	                    </td>
	                </tr>
	            </table>
	        </div>
	        <div class="cl hspace10"></div>
        </form>
    </div>
</body>
</html>    