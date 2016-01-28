<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@ include file="/views/include/tag_lib.jsp"%>
<%String preUrl = request.getHeader("referer"); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<%@ include file="/views/include/css.jsp"%>
<%@ include file="/views/include/common.jsp"%>

<style>
.pl2{padding-left:2px}
.mr2{padding-right:2px}
</style>

<script>

var currPageYn = "N";

$(window).load(function(){
    if($("#vsitRsvtnNo").val() != ""){
        getPageAction(2);
    }
    $(".cellstyle_textbox").css("paddingLeft","2px");

    
});

function getPageAction(action){
    
    switch(action){
        case 1:
            
            $("#frm").attr({
                action : "DDTA.RSVTN.PE1.cmd",
                target : "_self",
                method : "POST"
            });
    
            $("#frm").submit();
            
            break;
        case 2:
            
            if($.trim(frm.vsitRsvtnNo.value) != ""){
                var jsonObj ={};
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

                        if(result == null || result.length==0){
//                         	console.log(location.href);
<%--                             console.log("<%=preUrl%>"); --%>
                        	
                            alert("해당하는 출입예약건이 없습니다.");
                            $("#vsitCodeName").text("");
                            $("#apprStatusName").text("");
							
							$("#bpCodeNm").text("");
                            $("#deptName").text("");
                            $("#intvUserName").text("");
                            $("#intvUserTel").text("");
                            $("#intvUserMail").text("");
                            $("#vsitGrupName").text("");
                            $("#visitProdName").text("");
                            $("#vsitRsvtnDate").text("");
                            $("#vsitRsvtnTime").text("");
                            $("#etc").val("");
                            $("#apprRemark").val("");
                            $("._appr_btn").css("display", "none");

                            
                            if(currPageYn != "Y"){
                            	history.go(-1);
                            }
                            
                        
                        }else{

                            $("#vsitCodeName").text(isNullStr(result[0].vsitCodeName));
                            $("#apprStatusName").text(isNullStr(result[0].apprStatusName));
							
							var bpCodeNm	= isNullStr(result[0].bpCode) == "CC" ? "광주공장" : "부평연구소";
							$("#bpCodeNm").text(bpCodeNm);
                            $("#deptName").text(isNullStr(result[0].deptName));
                            $("#intvUserName").text(isNullStr(result[0].intvUserName));
                            $("#intvUserTel").text(isNullStr(result[0].intvUserTel));
                            $("#intvUserMail").text(isNullStr(result[0].intvUserMail));
                            $("#vsitGrupName").text(isNullStr(result[0].vsitGrupName));
                            $("#visitProdName").text(isNullStr(result[0].visitProdName));
                            $("#vsitRsvtnDate").text(isNullStr(result[0].vsitRsvtnDate));
                            $("#vsitRsvtnTime").text(isNullStr(result[0].vsitRsvtnTime));
                            $("#etc").val(isNullStr(result[0].etc));
                            $("#apprRemark").val(isNullStr(result[0].apprRemark));
                            $("._appr_btn").css("display", "none");

                            setVisitors(result[0].vsitRsvtnMId);
                            
                            if(result[0].apprStatus == "N" ){
                                $("._appr_btn").css("display", "inline-block");
                            }else{
                                $("._appr_btn").css("display", "none");
                            }
                            
                        }
                        
                    },
                    error      : function(e)
                    {
                        alert(e.responseText);
                    }
                });
            }else{
                alert("출입 예약번호를 입력해 주십시오.");
                return;
            }
            
            break;
            
  
        // 승인 및 반려 팝업   
        case 5:
            var jsonObj = {};
            jsonObj.vsitRsvtnNo  = $("#vsitRsvtnNo").val();

            getCommonPopUpWithParam(500, 430,"승인 및 반려","DDTA.RSVTN.P01.cmd", jsonObj, "appWin");
            break;
    }
}

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
            //console.log(result);
            var tbl = document.getElementById("vsitorsArea");
            if(tbl.rows.length){
                for(var r = tbl.rows.length; r > 0; r--){
                    tbl.deleteRow(r-1);
                }
            }
            
            for(var i = 0 ; i < result.length; i++){
/*                
                var tr1 = document.createElement("TR");
                var td_m = document.createElement("TD");
                td_m.setAttribute("class", "tac");
                td_m.setAttribute("rowspan", "2");
                td_m.setAttribute("valign", "middle");
                td_m.setAttribute("style", "text-align:center;marign:0 0 0 0;clear:both;font-weight:bold;background:#e8e8e8;");
                td_m.innerHTML = $.trim(result[i].vnum);
                
                var td1_1 = document.createElement("TD");
                td1_1.setAttribute("class", "tbl_colored_title");
                td1_1.setAttribute("style", "background:#EEE");
                td1_1.innerHTML = "업체명";
                var td1_2 = document.createElement("TD");
                td1_2.setAttribute("class", "cellstyle_textbox pl2");
                td1_2.innerHTML = isNullStr(result[i].vsitCompName);
                
                var td1_3 = document.createElement("TD");
                td1_3.setAttribute("class", "tbl_colored_title");
                td1_3.setAttribute("style", "background:#EEE");
                td1_3.innerHTML = "출입자명";
                var td1_4 = document.createElement("TD");
                td1_4.setAttribute("class", "cellstyle_textbox pl2");
                td1_4.innerHTML = isNullStr(result[i].vsitUserNm);
                
                tr1.appendChild(td_m);
                tr1.appendChild(td1_1);
                tr1.appendChild(td1_2);
                tr1.appendChild(td1_3);
                tr1.appendChild(td1_4);
                
                tbl.appendChild(tr1);
                
                var tr2 = document.createElement("TR");
                var td2_1 = document.createElement("TD");
                td2_1.setAttribute("class", "tbl_colored_title");
                td2_1.setAttribute("style", "background:#EEE");
                td2_1.innerHTML = "연락처";
                var td2_2 = document.createElement("TD");
                td2_2.setAttribute("class", "cellstyle_textbox pl2");
                td2_2.innerHTML = isNullStr(result[i].vsitUserTel);
                
                var td2_3 = document.createElement("TD");
                td2_3.setAttribute("class", "tbl_colored_title");
                td2_3.setAttribute("style", "background:#EEE");
                td2_3.innerHTML = "이메일";
                var td2_4 = document.createElement("TD");
                td2_4.setAttribute("class", "cellstyle_textbox pl2");
                td2_4.innerHTML = isNullStr(result[i].vsitUserMail);
                
                tr2.appendChild(td2_1);
                tr2.appendChild(td2_2);
                tr2.appendChild(td2_3);
                tr2.appendChild(td2_4);
                
                tbl.appendChild(tr2);
                
*/


                var addText = "";
                if(result[i].vnum == 1){
                	addText += ("<tr>");
                    addText += ("<td class='tac' rowspan='2' valign='middle' style='text-align:center;marign:0 0 0 0;clear:both;font-weight:bold;background:#e8e8e8;'>"+isNullStr(result[i].vnum)+"</td>");
                    addText += ("<td class='tbl_colored_title' style='background:#EEE'>업체명</td>");
                    addText += ("<td class='cellstyle_textbox pl2'>"+isNullStr(result[i].vsitCompName)+"</td>");
                    addText += ("<td class='tbl_colored_title' style='background:#EEE'>출입자명</td>");
                    addText += ("<td class='cellstyle_textbox pl2'>"+isNullStr(result[i].vsitUserNm)+"</td>");
                    addText += ("</tr>");
                    addText += ("<tr>");
                    addText += ("<td class='tbl_colored_title' style='background:#EEE'>연락처</td>");
                    addText += ("<td class='cellstyle_textbox pl2'>"+isNullStr(result[i].vsitUserTel)+"</td>");
                    addText += ("<td class='tbl_colored_title' style='background:#EEE'>이메일</td>");
                    addText += ("<td class='cellstyle_textbox pl2'>"+isNullStr(result[i].vsitUserMail)+"</td>");
                    addText += ("</tr>");
                }else{
                	addText += ("<tr>");
                	addText += ("<td class='tac' valign='middle' style='text-align:center;marign:0 0 0 0;clear:both;font-weight:bold;background:#e8e8e8;'>");
                	addText += (isNullStr(result[i].vnum)+"</td>");
                    addText += ("<td class='tbl_colored_title' style='background:#EEE'>업체명</td>");
                    addText += ("<td class='cellstyle_textbox pl2'>"+isNullStr(result[i].vsitCompName)+"</td>");
                    addText += ("<td class='tbl_colored_title' style='background:#EEE'>출입자명</td>");
                    addText += ("<td class='cellstyle_textbox pl2'>"+isNullStr(result[i].vsitUserNm)+"</td>");
                    addText += ("</tr>");
                }
                $("#vsitorsArea").append(addText);

                
                
            }
        
        },
        error      : function(e)
        {
            alert(e.responseText);
        }
    });
}

$(window).ready(function(){
	$("#vsitRsvtnNo").keydown(function(event){
		if(event.keyCode == 13){
			currPageYn = "Y";
			getPageAction(2);
		}
	});
});

</script>
</head>
<body>
<div class="popup_header">출입관리</div>

	<div class="popup_content mt10">
		
		<form id="frm" name="frm">
			
			<table cellpadding="0" cellspacing="0" border="0" style="width:100%">
				<tr>
					<td align="left"><div class="popup_subtitle mb10">출입예약 상세</div></td>
					<td align="right">
						<span class="_appr_btn" style="display:none">
							<a class="btn_check" href="javascript:getPageAction(5)"><span class="btn_check_left">승인 및 반려</span></a>
						</span>
					</td>
				</tr>
			</table>
			
			<div style="width:100%; height:100%; background: #f7f7f7; text-align:center">
				
				<table class="tbl_colored">
					<colgroup>
						<col width="15%"/>
						<col width="35%"/>
						<col width="15%"/>
						<col width="35%"/>
					</colgroup>
					<tr>
						<td class="tbl_colored_title">출입 예약번호</td>
						<td class="cellstyle_textbox" colspan="3">
							<input type="text" id="vsitRsvtnNo" name="vsitRsvtnNo" value="${param.vsitRsvtnNo}" maxlength="20" class="textbox_intd"/>
							<input type="button" class="btn_intd_search" onclick="currPageYn = 'Y'; getPageAction(2)" title="조회"/>
							<input type="button" class="btn_intd_cancel" onclick="$('#vsitRsvtnNo').val('');" title="입력 취소"/>
						</td>
					</tr>
					<tr>
						<td class="tbl_colored_title">출입목적</td>
						<td class="cellstyle_textbox">
							<span id="vsitCodeName"></span>
						</td>
						<td class="tbl_colored_title">예약상태</td>
						<td class="cellstyle_textbox">
							<span id="apprStatusName" style="color:red;font-weight:bold"></span>
						</td>
					</tr>
				</table>
				
				<div class="hspace6"></div>
				
				<table class="tbl_colored">
					<colgroup>
						<col width="15%"/>
						<col width="35%"/>
						<col width="15%"/>
						<col width="35%"/>
					</colgroup>
					<tr>
						<td class="tbl_colored_title text_addstar">방문사업장</td>
						<td colspan="3" class="cellstyle_textbox">
							<span id="bpCodeNm"></span>
						</td>
					</tr>
					<tr>
						<td class="tbl_colored_title">면담자</td>
						<td class="cellstyle_textbox">
							<span id="intvUserName"></span>
						</td>
						<td class="tbl_colored_title">방문처</td>
						<td class="cellstyle_textbox">
							<span id="deptName"></span>
						</td>
					</tr>
					<tr>
						<td class="tbl_colored_title">면담자 연락처</td>
						<td class="cellstyle_textbox">
							<span id="intvUserTel"></span>
						</td>
						<td class="tbl_colored_title">면담자 이메일</td>
						<td class="cellstyle_textbox">
							<span id="intvUserMail"></span>
						</td>
					</tr>
					<tr>
						<td class="tbl_colored_title">출입자 구분</td>
						<td class="cellstyle_textbox">
							<span id="vsitGrupName"></span>
						</td>
						<td class="tbl_colored_title">출입기간 구분</td>
						<td class="cellstyle_textbox">
							<span id="visitProdName"></span>
						</td>
					</tr>
					<tr>
						<td class="tbl_colored_title">출입 예정일</td>
						<td class="cellstyle_textbox">
							<span id="vsitRsvtnDate"></span>
						</td>
						<td class="tbl_colored_title">출입 예정시간</td>
						<td class="cellstyle_textbox">
							<span id="vsitRsvtnTime"></span>
						</td>
					</tr>
					<tr>
						<td class="tbl_colored_title" style="border-right:1px #E6F1F1 solid">출입자</td>
						<td colspan="3" class="tbl_colored_title">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="4" style="padding:0 0 0 0;margin:0 0 0 0">
							
							<table style="width:100%" cellpadding="0" cellspacing="0" id="vsitorsArea">
								<colgroup>
									<col width="2%"/>                                
									<col width="13%"/>
									<col width="35%"/>
									<col width="15%"/>
									<col width="35%"/>
								</colgroup>
							</table>
							
						</td>
					</tr>
					<tr>
						<td class="tbl_colored_title">출입목적 상세</td>
						<td class="cellstyle_textbox" colspan="3" id="etc_area">
							<textarea id="etc" name="etc" rows="3" maxlength="300" readonly="readonly" class="ml2 mb2 mt2 mr2" style="width:99.5%;border:0px #CCC solid"></textarea>
						</td>
					</tr>
					<tr>
						<td class="tbl_colored_title">사유</td>
						<td class="cellstyle_textbox" colspan="3">
							<textarea id="apprRemark" name="apprRemark" style="width:99.5%;border:0px #CCC solid" rows="5" maxlength="300" readonly="readonly" class="ml2 mb2 mt2 mr2"></textarea>
						</td>
					</tr>
				</table>
				
			</div>
			
		</form>
		
	</div>
	
</body>
</html>
