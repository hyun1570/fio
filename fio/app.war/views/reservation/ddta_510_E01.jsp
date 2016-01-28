<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@ include file="/views/include/tag_lib.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<%@ include file="/views/include/css.jsp"%>
<%@ include file="/views/include/common2.jsp"%>

<script language="javascript">
	//모바일 브라우져 여부
	var isMobile	= false;
	var ua = window.navigator.userAgent.toLowerCase(); 
	if ( /iphone/.test(ua) || /android/.test(ua) || /opera/.test(ua) || /bada/.test(ua) ) { 
	    isMobile	= true;
	} 

	var autoTexts;
	var popType = "";
	
	//초기화
	$(window).load(function()
	{
		addVisitor("Y");		<%-- 출입자 입력란 추가 --%>
		getReservationNo();		<%-- 출입예약번호 생성 --%>
		getAutoCompleteTexts();	<%-- 업체명 항목에 최근 3개월동안 방문한 업체 자동완성 부여 --%>
		
		//코드성 데이터 조회
		var jsonObj = {sqlid : "Common.COMM_COMBO", masCode: "EPUPS", code : "code", value : "codeName"};
		setComboBySqlId("vsitCode", jsonObj, 'Y');
		
		//달력 초기화
		myCalendar = new dhtmlXCalendarObject(["vsitRsvtnFromDate", "vsitRsvtnToDate"]);
		$("#vsitRsvtnFromDate").val(setCommonFormatSetting(getCommonToDay(),"####-##-##"));
		$("#vsitRsvtnToDate").val(setCommonFormatSetting(getCommonCalcDate(1),"####-##-##"));
		
		var text_area_w = document.getElementById("etc_area").clientWidth;
		
		// 입력제한
		$("._tel").css("ime-mode", "disabled");
		$("._tel").PhoneNumber();
		
		$("._mail").css("ime-mode", "disabled");
		$("._mail").emailAddress();
		
		$("._time").css("ime-mode", "disabled");
		$("._time").NumericOnly();
		
	});

	<%-- 출입예약번호 생성 --%>
	function getReservationNo(){
		var jsonObj = {};
		jsonObj.sqlid = "Reservation.GET_RSVTN_NO";
		
		$.ajax({
			type		: "POST",
			url			: "DDTA.BASE.SERVICE.R00.cmd",
			dataType	: "json",
			data		: {"param" : JSON.stringify(jsonObj)},
			async		: false,
			beforeSend	: function(xhr)
			{
				// 전송 전 Code
			},
			success		: function(result)
			{
				$("#new_VsitRsvtnNo").val(result[0].rsvtnNo);
			},
			error		: function(e)
			{
				alert(e.responseText);
			}
		});
	}
	
	<%-- 업체명 항목에 최근 3개월동안 방문한 업체 자동완성 부여 --%>
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
				if(result != null){
					autoTexts = new Array();
					for(var i = 0; i < result.length; i++){
						autoTexts[i] = result[i].vsitCompName;
					}
					
					setAutoComplete();	<%-- 업체명 항목에 자동완성 부여 --%>
				}
				
			},
			error      : function(e)
			{
			    alert(e.responseText);
			}
		});
		
	}
	<%-- 업체명 항목에 자동완성 부여 --%>
	function setAutoComplete(){
		$("input[name=vsitCompName]").autocomplete({
			autoFocus:true,
			source: autoTexts
		});
	}

	<%-- 출입자 입력란 추가, not_chk	: 최초 출입자(메일발송대상) 여부 --%>
	function addVisitor(not_chk){
		
		var addText = "";
		addText += "<tr>";
		if(not_chk == "Y"){
			addText += "<td rowspan='2' valign='middle' style='text-align:center;marign:0 0 0 0;clear:both;font-weight:bold;background:#e8e8e8'>&nbsp;</td>";
			addText += "<td class='tbl_colored_title text_addstar' style='background:#EEE'>업체명</td>";
			addText += "<td class='cellstyle_textbox' valign='middle'><input type='text' name='vsitCompName' maxlength='100' class='textbox_intd'/></td>";
			addText += "<td class='tbl_colored_title text_addstar' style='background:#EEE'><span>출입자명</span></td>";
			addText += "<td class='cellstyle_textbox' valign='middle'><input type='text' name='vsitUserNm' maxlength='100' class='textbox_intd'/></td>";
			addText += "</tr>";
			addText += "<tr>";
			addText += "<td class='tbl_colored_title text_addstar' style='background:#EEE'><span>연락처</span></td>";
			addText += "<td class='cellstyle_textbox' valign='middle'>";
			addText += "<input type='hidden' name='vsitUserTel' maxlength='100' style='width:40px' class='textbox_intd _tel'/>";
			addText += "<select id='tel1' name='tel1' class='selectbox_search' onchange='setPhnNo()'></select> -";
			addText += "<input type='text' id='tel2' name='tel2' maxlength='4' size=4 class='textbox_intd _tel' onblur='setPhnNo()'/> -";
			addText += "<input type='text' id='tel3' name='tel3' maxlength='4' size=4 class='textbox_intd _tel' onblur='setPhnNo()'/>";
			addText += "</td>";
			addText += "<td class='tbl_colored_title text_addstar' style='background:#EEE'><span>이메일</span></td>";
			addText += "<td class='cellstyle_textbox' valign='middle'><input type='text' name='vsitUserMail' maxlength='100' class='textbox_intd _mail'/></td>";
			
		}else{
			addText += "<td valign='middle' style='text-align:center;marign:0 0 0 0;clear:both;font-weight:bold;background:#e8e8e8'><input type='checkbox' name='vstchk'/></td>";
			addText += "<td class='tbl_colored_title text_addstar' style='background:#EEE'>업체명</td>";
			addText += "<td class='cellstyle_textbox' valign='middle'><input type='text' name='vsitCompName' maxlength='100' class='textbox_intd'/><input type='hidden' name='vsitUserTel' maxlength='100' class='textbox_intd _tel'/></td>";
			addText += "<td class='tbl_colored_title text_addstar' style='background:#EEE'><span>출입자명</span></td>";
			addText += "<td class='cellstyle_textbox' valign='middle'><input type='text' name='vsitUserNm' maxlength='100' class='textbox_intd'/><input type='hidden' name='vsitUserMail' maxlength='100' class='textbox_intd _mail'/></td>";
			
		}

		addText += "</tr>";
		
		$("#vsitorsArea").append(addText);
		
		setAutoComplete();	<%-- 업체명 항목에 자동완성 부여 --%>
		
		if(not_chk == "Y"){
			var _obj = {sqlid : "Common.COMM_COMBO", masCode: "KOR_REG_PHNNUM", code : "code", value : "codeName", sSiteCode:"10008"};
			setComboBySqlId("tel1", _obj, 'Y');
		}
	}
	
	<%-- 출입자 입력란 삭제 --%>
	function removeVisitor(){
		var vstchks = "";
		var tbl = document.getElementById("vsitorsArea");
		
		if(frm.vstchk){
			
			if(frm.vstchk.length){
				for(var i = (frm.vstchk.length-1) ; i >= 0 ; i--){
					if(frm.vstchk[i].checked){
						if(vstchks==""){
							vstchks += ((i+2));
						}else{
							vstchks += "^"+((i+2));
						}
					}
				}
				
				if(vstchks != ""){
					var rows = vstchks.split("^");
					for(var j = 0 ; j < rows.length; j++){
						tbl.deleteRow(rows[j]);
					}
				}
				
			}else{
				if(frm.vstchk.checked){
					tbl.deleteRow(2);
				}
			}
		}
	}
	

	function setPhnNo(){
		if($.trim(frm.tel1.value) != "" && $.trim(frm.tel2.value) != "" && $.trim(frm.tel3.value) != ""){
			if(frm.vsitUserTel.length){
				frm.vsitUserTel[0].value = $.trim(frm.tel1.value)+"-"+$.trim(frm.tel2.value) + "-"+$.trim(frm.tel3.value);	
			}else{
				frm.vsitUserTel.value = $.trim(frm.tel1.value)+"-"+$.trim(frm.tel2.value) + "-"+$.trim(frm.tel3.value);
			}
		}
	}
	
	<%-- 팝업 호출 --%>
	function goPopUp(action, param){
		param = escape(encodeURIComponent(param));
		
		switch(action){
			case 1:
				var sObj = {};
				sObj.sType      = "sDeptName";
				sObj.sTypeNm    = param;
				sObj.sqlid      = "Common.DEPT_Pop";
				sObj.status     = "Y";
				sObj.sBpCode	= $('input[name=bpCode]:radio:checked').val();
				
				var tgtUrl	= "DDTA.COMMON.P01.cmd";
				if( isMobile	== true ) {
					tgtUrl	= "DDTA.COMMON.P11.cmd";
				}
				
				$.ajax({
					type       : "POST",
					url        : "DDTA.BASE.SERVICE.R00.cmd",
					dataType   : "json",
					data       : {"param" : JSON.stringify(sObj)},
					async      : true,
					beforeSend : function(xhr)
					{
						// 전송 전 Code
					},
					success    : function(result)
					{
						if(result.length==1){
							popType = "DEPT";
							_setDataValue(result[0]);
						}else{
							param = escape(encodeURIComponent(param));
							var jsonObj = {
									sTypeNm:param,
									sBpCode:$('input[name=bpCode]:radio:checked').val()
								};
							popType = "DEPT";
							getCommonPopUpWithParam(600, 500,"방문처", tgtUrl, jsonObj);
						}  
						
					},
					error      : function(e)
					{
					    alert(e.responseText);
					}
				});  
				
				break;
			
			case 2:
				// 면담자
				var sObj = {}; 
				sObj.sType      = "userName";
				sObj.sTypeNm    = param;
				sObj.sqlid      = "Common.USER_Pop";
				sObj.status     = "Y";
				sObj.sFactCode  = "";
				
				var tgtUrl	= "DDTA.COMMON.P02.cmd";
				if( isMobile	== true ) {
					tgtUrl	= "DDTA.COMMON.P12.cmd";
				}
				
				$.ajax({
					type       : "POST",
					url        : "DDTA.BASE.SERVICE.R00.cmd",
					dataType   : "json",
					data       : {"param" : JSON.stringify(sObj)},
					async      : true,
					beforeSend : function(xhr)
					{
						// 전송 전 Code
					},
					success    : function(result)
					{
						if(result.length==1){
							popType = "EMP";
							_setDataValue(result[0]);
						}else{
							param = escape(encodeURIComponent(param));
							var jsonObj = {
									sTypeNm:param,
									sBpCode:$('input[name=bpCode]:radio:checked').val()
							};
							popType = "EMP";
							getCommonPopUpWithParam(600, 500, "면담자", tgtUrl, jsonObj);
						}
					},
					error      : function(e)
					{
						alert(e.responseText);
					}
				});
				
				break;
				
		}
	}

	<%-- 팝업값 셋팅 --%>
	function _setDataValue(obj){
		
		if(popType == "DEPT"){
			frm.deptCode.value = (obj.deptCode == undefined  ? "" : obj.deptCode);
			frm.deptName.value = (obj.deptName == undefined  ? "" : obj.deptName);
		}else if( popType == "EMP"){
			frm.deptCode.value = (obj.deptCode == undefined  ? "" : obj.deptCode);
			frm.deptName.value = (obj.deptName == undefined  ? "" : obj.deptName);
			frm.factCode.value  = (obj.factCode == undefined ? "" : obj.factCode);
			frm.intvUserName.value = (obj.kname == undefined  ? "" : obj.kname);
			frm.intvUserTel.value = (obj.officeTel == undefined  ? "" : obj.officeTel);
			frm.intvUserMail.value = (obj.email == undefined  ? "" : obj.email);
			frm.intvUserId.value = (obj.sno == undefined  ? "" : obj.sno);
		}
	}
	

	
	// validation 검색
	function validationCheck(){
		// 출입목적
		if($.trim(frm.vsitCode.value) == ""){
			alert("출입 목적을 선택해 주십시오.");
			frm.vsitCode.focus();
			return false;
		}
		
		// 부서
		if($.trim(frm.deptCode.value)=="" || $.trim(frm.deptName.value)=="" ){
			alert("방문처를 검색해 주십시오.");
			frm.deptName.focus();
			return false;
		}
		
		// 면담자 
		if($.trim(frm.intvUserId.value) == "" || $.trim(frm.intvUserName.value)==""){
			alert("면담자를 검색해 주십시오.");
			frm.intvUserName.focus();
			return false;
		}
		
		// 면담자 연락처
		if($.trim(frm.intvUserTel.value) ==""){
			alert("면담자 연락처를 입력해 주십시오.");
			frm.intvUserTel.focus();
			return false;
		}
		
		// 면담자 메일
		if($.trim(frm.intvUserMail.value) ==""){
			alert("면담자 이메일을 입력해 주십시오.");
			frm.intvUserMail.focus();
			return false;
		}
		
		// 출입기간 
		if($.trim(frm.vsitRsvtnFromDate.value) == ""){
			alert("출입예정일자를 입력해 주십시오.");
			frm.vsitRsvtnFromDate.focus();
			return false;
		}else{
			if($(":input:radio[name=rVsitProdYn]:checked").val() == "Y"){

				// 날짜 체크
				if(!getCommonFromToDateCheck(frm.vsitRsvtnFromDate.value, frm.vsitRsvtnToDate.value)){
					return false;
				}
			}
		}
		
		if(frm.vsitRsvtnStTime.value != "" || frm.vsitRsvtnEdTime.value != ""){
			if(!getCheckStEdDate($.trim(frm.vsitRsvtnStTime.value), $.trim(frm.vsitRsvtnEdTime.value))){
				frm.vsitRsvtnStTime.focus();
				return false;
			}
		}
		
		// 출입자 체크
		if(frm.vsitCompName.length){
			for(var i = 0; i< frm.vsitCompName.length; i++){
				if(frm.vsitCompName[i].value == ""){
					alert("업체명을 입력해 주십시오.");
					frm.vsitCompName[i].focus();
					return false;
				}
				if(frm.vsitUserNm[i].value == ""){
					alert("출입자명을 입력해 주십시오.");
					frm.vsitUserNm[i].focus();
					return false;
				}
				if(frm.vsitUserTel[0].value == ""){
					alert("연락처를 입력해 주십시오.");
					frm.vsitUserTel[i].focus();
					return false;
				}
				if(frm.vsitUserMail[0].value == ""){
					alert("이메일을 입력해 주십시오.");
					frm.vsitUserMail[i].focus();
					return false;
				}
			}
		}else{
			if(frm.vsitCompName.value == ""){
				alert("업체명을 입력해 주십시오.");
				frm.vsitCompName.focus();
				return false;
			}
			if(frm.vsitUserNm.value == ""){
				alert("츨입자명을 입력해 주십시오.");
				frm.vsitUserNm.focus();
				return false;
			}
			if(frm.vsitUserTel.value == ""){
				alert("연락처를 입력해 주십시오.");
				frm.vsitUserTel.focus();
				return false;
			}
			if(frm.vsitUserMail.value == ""){
				alert("이메일을 입력해 주십시오.");
				frm.vsitUserMail.focus();
				return false;
			}
		}
		
		if(frm.etc.value == ""){
			alert("출입목적 상세를 입력해 주십시오.");
			frm.etc.focus();
			return false;
		}
		
		return true;
	}
	
	
	function getPageAction(action){
		switch(action){
			case 1:
				break;
				
			case 2:	//조회
				
				if(frm.vsitRsvtnNo.value == ""){
					alert("조회할 출입예약 번호를 입력해 주십시오.");
					frm.vsitRsvtnNo.focus();
					return;
				}
				
				$("#frm").attr({
					action : "DDTA.RSVTN.M01.cmd",
					target : "_self",
					method : "POST"
				});
		
				$("#frm").submit();
				break;
			
			case 3:	//저장
				
				var pCnt = -1;
				
				if(validationCheck()){
					var jsonArray = [];
					
					// Header 등록
					var jsonObj = {};
					jsonObj.command	= "C";
					jsonObj.sqlId	= "Reservation.INS_RSVTN_M";
					
					
					var bpCode	= $('input[name=bpCode]:radio:checked').val();
					jsonObj.vsitRsvtnNo			= $.trim(frm.new_VsitRsvtnNo.value);
					jsonObj.bpCode				= bpCode;
					jsonObj.deptCode			= $.trim(frm.deptCode.value);
					jsonObj.factCode			= bpCode == "BD" ? "BD" : $.trim(frm.factCode.value);
					jsonObj.intvUserId			= $.trim(frm.intvUserId.value);
					jsonObj.intvUserTel			= $.trim(frm.intvUserTel.value);
					jsonObj.intvUserMail		= $.trim(frm.intvUserMail.value);
					jsonObj.vsitCode			= $.trim(frm.vsitCode.value);
					jsonObj.vsitRsvtnFromDate	= $.trim(frm.vsitRsvtnFromDate.value).replace(/\-/g, '');
					jsonObj.vsitRsvtnToDate		= $.trim(frm.vsitRsvtnToDate.value).replace(/\-/g, '');
					jsonObj.vsitRsvtnStTime		= $.trim(frm.vsitRsvtnStTime.value).replace(/\:/g, '');
					jsonObj.vsitRsvtnEdTime		= $.trim(frm.vsitRsvtnEdTime.value).replace(/\:/g, '');
					jsonObj.etc					= $.trim(frm.etc.value);
					jsonObj.vsitProdYn			= $(":input:radio[name=rVsitProdYn]:checked").val();
					jsonObj.vsitGrupYn			= $(":input:radio[name=rVsitGrupYn]:checked").val();
					
					if(jsonObj.vsitProdYn == "N"){
						jsonObj.vsitRsvtnToDate = jsonObj.vsitRsvtnFromDate;
					}
					
					
					jsonArray.push(jsonObj);
					
					frm.vsitRsvtnNo.value = jsonObj.vsitRsvtnNo; 
					
					
					if(frm.vsitCompName.length){
					
						for(var i = 0 ; i < frm.vsitCompName.length; i++){
							var jsonD = {};
							jsonD.command 		= "C";
							jsonD.sqlId   		= "Reservation.INS_RSVTN_D";
							jsonD.vnum          = new String((i+1));
							jsonD.vsitCompName  = $.trim(frm.vsitCompName[i].value);
							jsonD.vsitUserNm    = $.trim(frm.vsitUserNm[i].value);
							jsonD.vsitUserTel   = $.trim(frm.vsitUserTel[i].value);
							jsonD.vsitUserMail  = $.trim(frm.vsitUserMail[i].value);
							jsonD.vsitRsvtnNo 	= $.trim(frm.new_VsitRsvtnNo.value);
							jsonArray.push(jsonD);
							pCnt += 1;
						}
					}else{
						var jsonD = {};
						jsonD.command 		= "C";
						jsonD.sqlId   		= "Reservation.INS_RSVTN_D";
						jsonD.vnum          = "1";
						jsonD.vsitCompName  = $.trim(frm.vsitCompName.value);
						jsonD.vsitUserNm    = $.trim(frm.vsitUserNm.value);
						jsonD.vsitUserTel   = $.trim(frm.vsitUserTel.value);
						jsonD.vsitUserMail  = $.trim(frm.vsitUserMail.value);
						jsonD.vsitRsvtnNo 	= $.trim(frm.new_VsitRsvtnNo.value);
						jsonArray.push(jsonD);
						
					}
					
					//메일발송 부분
					var mailContent = "";
					mailContent += "<H1>출입 예약 승인 요청</H1><BR/>";
					mailContent += "<TABLE WIDTH='500PX' CELLSPACING='0' CELLPADDING='3' BORDER='1' BORDERCOLOR='#CDCDCD'>";
					mailContent += "    <COLGROUP>";
					mailContent += "        <COL WIDTH='30%'/>";
					mailContent += "        <COL WIDTH='70%'/>";
					mailContent += "    </COLGROUP>";
					mailContent += "    <TR height='30px'>";
					mailContent += "        <TH STYLE='BACKGROUND:#EFEFEF'>예약번호</TH>";
					mailContent += "        <TD>"+$.trim(frm.new_VsitRsvtnNo.value)+"</TD>";
					mailContent += "    </TR>";
					mailContent += "    <TR height='30px'>";
					mailContent += "        <TH STYLE='BACKGROUND:#EFEFEF'>인증번호</TH>";
					mailContent += "        <TD>§acceptCode§</TD>";
					mailContent += "    </TR>";
					mailContent += "    <TR height='30px'>";
					mailContent += "        <TH STYLE='BACKGROUND:#EFEFEF'>출입 예약일</TH>";
					mailContent += "        <TD>"+($.trim(frm.vsitRsvtnFromDate.value) + ($.trim(frm.vsitRsvtnToDate.value == $.trim(frm.vsitRsvtnFromDate.value))?"":" ~ "+$.trim(frm.vsitRsvtnFromDate.value)))+"</TD>";
					mailContent += "    </TR>";
					mailContent += "    <TR height='30px'>";
					mailContent += "        <TH STYLE='BACKGROUND:#EFEFEF'>출입자</TH>";
					mailContent += "        <TD>"+( pCnt == -1 ? $.trim(frm.vsitCompName.value) + " " + $.trim(frm.vsitUserNm.value) : $.trim(frm.vsitCompName[0].value) + " " + $.trim(frm.vsitUserNm[0].value) + " 외 "+pCnt+"명")+"</TD>";
					mailContent += "    </TR>";
					mailContent += "    <TR height='30px'>";
					mailContent += "        <TH STYLE='BACKGROUND:#EFEFEF'>비 고</TH>";
					mailContent += "        <TD>"+$.trim(frm.etc.value)+"</TD>";
					mailContent += "    </TR>";
					mailContent += "</TABLE>";
					mailContent += "<BR/>";
					mailContent += "위 내용의 출입예약을 승인 요청합니다.";
					mailContent += "<a href='http://webportal.dwe.co.kr/fio/DDTA.RSVTN.P01.cmd?param="+JSON.stringify({vsitRsvtnNo:$.trim(frm.new_VsitRsvtnNo.value), acceptCode:"§acceptCode§"})+"' target='_blank' style='font-size:12px;font-weight:bold;color:red'>승인하러 가기</a>";
					
					
					var jsonMail = {};
					// 내용 처리용
					jsonMail.mergeSqlId = "Reservation.GET_RSVTN_M";
					jsonMail.mergeTarget = {
							acceptCode : "acceptCode"
					};
					jsonMail.contents = mailContent;
					
					jsonMail.vsitRsvtnNo = $.trim(frm.new_VsitRsvtnNo.value);
					
					jsonMail.subject = "[출입관리]출입예약 승인요청입니다.";
					if(pCnt != -1){
						jsonMail.from=$.trim(frm.vsitUserMail[0].value); // From mail
					}else{
						jsonMail.from=$.trim(frm.vsitUserMail.value); // From mail
					}
					jsonMail.to=$.trim(frm.intvUserMail.value);    // To Mail
					jsonMail.ccm=""; // CC
					
					jsonMail.command = "Mail";
					jsonArray.push(jsonMail);

					doAjax2(jsonArray, function(ret){
						if(ret == "SUCCESS"){
							alert("저장하였습니다.");
						    $("#frm").attr({
						        action : location.href,
						        target : "_self",
						        method : "POST"
						    });
						    $("#frm").submit();
							
						}else{
							alert("저장에 실패하였습니다.");
						}
						
					});
					
				}
				break;
			
			case 5:
				alert("승인 및 반려");
				break;
				
			case 9:
				window.close();
				break;
		}
	}
	
	$(window).ready(function()
	{
		$("input[name=rVsitGrupYn]").click(function(event){
			if(this.value=="Y"){
				document.getElementById("visiotrBtnArea").style.display="inline-block";
				document.getElementById("visiotrNoBtnArea").style.display="none";
			}else{
				document.getElementById("visiotrBtnArea").style.display="none";
				document.getElementById("visiotrNoBtnArea").style.display="block";
			}
			
			if(frm.vstchk){
				if(frm.vstchk.length){
				
					for(var i = 0 ; i < frm.vstchk.length; i++){
						frm.vstchk[i].checked = true;	
					}
				}else{
					frm.vstchk.checked = true;
				}
				removeVisitor();
			}

			$("#vsitRsvtnNo").keydown(function(event){
				if(event.keyCode == 13){
					getPageAction(2);
				}
			});	
		});
		
		$("input[name=rVsitProdYn]").click(function(event){
			if(this.value == "Y"){
				document.getElementById("toDateArea").style.display="inline-block";
			}else{
				document.getElementById("toDateArea").style.display="none";
			}
		});
		
		$("#vsitRsvtnNo").keydown(function(event){
			if(event.keyCode == 13){
				getPageAction(2);
			}
		});
		

		$("#intvType").change(function(){
			if(frm.intvType.value == "I"){
				$("#intvBtnArea").css("display", "inline-block");
				$("#intvUserName").val("");
				$("#intvUserId").val("");
				$("#intvUserTel").val("");
				$("#intvUserMail").val("");
				$("#deptCode").val("");
				$("#factCode").val("");
				$("#deptName").attr("readonly", "readonly");
// 				$("#intvUserTel").attr("readonly", "readonly");
				$("#intvUserTel").removeAttr("readonly");
				$("#deptBtnArea").css("display", "none");
				
			}else{
				$("#intvBtnArea").css("display", "none");
				$("#intvUserName").val("");
				$("#intvUserId").val("Outter");
				$("#intvUserTel").val("");
				$("#intvUserMail").val("");
				$("#deptCode").val("");
				$("#factCode").val("");
				$("#deptName").removeAttr("readonly");
				$("#intvUserTel").removeAttr("readonly");
				$("#deptBtnArea").css("display", "inline-block");
			}
		});

	});
</script>
</head>

<body>
<div class="wrap">

	<%@ include file="/views/include/top.jsp"%>
	
	<div class="container">
		
		<div class="sub_nav">홈 > ${MENU_NAME}</div>
		
		<div class="hspace6"></div>
		
		<div class="content">
			
			<form id="frm" name="frm">
				
				<div class="subtitle_all">
					<div class="subtitle_title">${MENU_NAME}</div>
					<div class="subtitle_btngroup">
						<a class="btn_check" href="javascript:getPageAction(3)"><span class="btn_check_left">저장</span></a>
					</div>
				</div>

				<table class="tbl_colored" style="left:0px">
					<colgroup>
						<col width="15%" />
						<col width="35%" />
						<col width="15%" />
						<col width="35%" />
					</colgroup>
					<tr>
						<td class="tbl_colored_title">출입 예약번호</td>
						<td class="cellstyle_textbox" colspan="3">
							<input type="hidden" id="new_VsitRsvtnNo" name="new_VsitRsvtnNo" size="20"/>
							<input type="text" id="vsitRsvtnNo" name="vsitRsvtnNo" maxlength="20" value="" class="textbox_intd"/>
							<input type="button" class="btn_intd_search" onclick="getPageAction(2)"/>
							<input type="button" class="btn_intd_cancel" onclick="$('#vsitRsvtnNo').val('');"/>
							<span style="padding-left:15px;color:red">
								※ 예약 내용 조회는 출입 예약번호를 입력 후 조회 버튼을 클릭하여 주십시오.
							</span>
						</td>
					</tr>
					<tr>
						<td class="tbl_colored_title text_addstar">출입목적</td>
						<td class="cellstyle_textbox">
							<select id="vsitCode" name="vsitCode" class="selectbox_search">
								<option>=선택=</option>
							</select>
						</td>
						<td class="tbl_colored_title">예약상태</td>
						<td class="cellstyle_textbox"><span class="ml2">미등록</span></td>
					</tr>
				</table>
				
				<div class="hspace6"></div>
				
				<table class="tbl_colored" style="left:0px">
					<colgroup>
						<col width="15%" />
						<col width="35%" />
						<col width="15%" />
						<col width="35%" />
					</colgroup>
					<tr>
						<td class="tbl_colored_title text_addstar">방문사업장</td>
						<td colspan="3" class="cellstyle_textbox">
							<input type="radio" name="bpCode" id="bpCode01" 
									value="CC" checked="checked" class="radiobox_search ml2"/> <label for="bpCode01">광주공장</label>
							<input type="radio" name="bpCode" id="bpCode02" 
									value="BD" class="radiobox_search"/> <label for="bpCode02">부평연구소</label>
						</td>
					</tr>
					<tr>
						<td class="tbl_colored_title text_addstar">면담자</td>
						<td class="cellstyle_textbox">
							<select id="intvType" name="intvType" class="selectbox_search">
								<option value="I">검색입력</option>
								<option value="O">직접입력</option>
							</select>
							<input type="hidden" id="intvUserId" name="intvUserId"/>
							<input type="text" id="intvUserName" name="intvUserName" maxlength="30" class="textbox_intd" style='width:60px'/>
							<span id="intvBtnArea">
								<input type="button" class="btn_intd_search" onclick="goPopUp(2, $('#intvUserName').val())"/>
								<input type="button" class="btn_intd_cancel" />
							</span>
						</td>
						<td class="tbl_colored_title text_addstar">방문처</td>
						<td class="cellstyle_textbox">
							<input type="hidden" id="deptCode" name="deptCode"/>
							<input type="hidden" id="factCode" name="factCode"/>
							<input type="text" id="deptName" class="textbox_intd" maxlength="30" name="deptName" readonly="readonly"/>
							<span id="deptBtnArea" style="display:none">
								<input type="button" class="btn_intd_search" onclick="goPopUp(1, $('#deptName').val())"/>
								<input type="button" class="btn_intd_cancel" />
							</span>
						</td>
					</tr>
					<tr>
						<td class="tbl_colored_title text_addstar">면담자 연락처</td>
<!-- 						<td class="cellstyle_textbox"><input type="text" id="intvUserTel" name="intvUserTel" maxlength="100" class="textbox_intd _tel" readonly="readonly" title="면담자를 조회해 주세요"/></td> -->
<td class="cellstyle_textbox"><input type="text" id="intvUserTel" name="intvUserTel" maxlength="100" class="textbox_intd _tel" title="면담자를 조회해 주세요"/></td>
						<td class="tbl_colored_title text_addstar">면담자 이메일</td>
						<td class="cellstyle_textbox"><input type="text" id="intvUserMail" name="intvUserMail" maxlength="100" class="textbox_intd _mail" title="면담자를 조회해 주세요"/></td>
					</tr>
					<tr>
						<td class="tbl_colored_title text_addstar">출입자 구분</td>
						<td class="cellstyle_textbox">
							<input type="radio" name="rVsitGrupYn" id="rVsitGrupYn01" 
									value="N" checked="checked" class="radiobox_search ml2"/> <label for="rVsitGrupYn01">1명</label>
							<input type="radio" name="rVsitGrupYn" id="rVsitGrupYn02"
									value="Y" class="radiobox_search"/> <label for="rVsitGrupYn02">단체</label>
							<input type="hidden" name="vsitGrupYn" id="rVsitGrupYn"/>
						</td>
						<td class="tbl_colored_title text_addstar">출입기간 구분</td>
						<td class="cellstyle_textbox">
							<input type="radio" name="rVsitProdYn" id="rVsitProdYn01" 
									value="N" checked="checked" class="radiobox_search ml2"/> <label for="rVsitProdYn01">당일</label>
							<input type="radio" name="rVsitProdYn" id="rVsitProdYn02"
									value="Y" class="radiobox_search"/> <label for="rVsitProdYn02">장기간(2일 이상)</label>
							<input type="hidden" name="vsitProdYn" id="rVsitProdYn"/>
						</td>
					</tr>
					<tr>
						<td class="tbl_colored_title text_addstar">출입 예정일</td>
						<td class="cellstyle_textbox">
							<input type="text" id="vsitRsvtnFromDate" name="vsitRsvtnFromDate" size="13" maxlength="10" class="calendar_intd calendar"/>
							<span id="toDateArea" style="display:none">&nbsp;~&nbsp;<input type="text" id="vsitRsvtnToDate" name="vsitRsvtnToDate" size="13" maxlength="10" class="calendar_intd"/></span>
						</td>
						<td class="tbl_colored_title">출입 예정시간</td>
						<td class="cellstyle_textbox">
							<input type="text" id="vsitRsvtnStTime" name="vsitRsvtnStTime" size="6" maxlength="6" class="textbox_intd _time tac"/>
							&nbsp;~&nbsp;<input type="text" id="vsitRsvtnEdTime" name="vsitRsvtnEdTime" size="6" maxlength="6" class="textbox_intd _time tac"/>
						</td>
					</tr>
					<tr>
						<td class="tbl_colored_title text_addstar" style="border-right:1px #E6F1F1 solid">출입자</td>
						<td colspan="3" class="tbl_colored_title" style="text-align:left !important">
							<span id="visiotrNoBtnArea" style="text-align:left;display:block">
								<font style="color:red;padding-right:20px;font-weight:normal;margin-left:10px">※ 응답메일 발송되오니 출입자의 이메일 반드시 입력해 주십시오.</font>
							</span>
							<span id="visiotrBtnArea" style="text-align:left;display:none">
								<a href="javascript:addVisitor()" class="btn_intd"><span class="btn_intd_left">추가</span></a>
								<a href="javascript:removeVisitor()" class="btn_intd"><span class="btn_intd_left">출입자 삭제</span></a>
								<font style="color:red;padding-right:20px;font-weight:normal;margin-left:10px">※ 응답 메일은 첫번째 출입자에게 발송되오니 발송 받으실 분의 정보를 입력해 주십시오.</font>
							</span>
						</td>
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
						<td class="tbl_colored_title text_addstar">출입목적 상세</td>
						<td class="cellstyle_textbox" colspan="3" id="etc_area">
							<textarea id="etc" name="etc" rows="3" class="mb2 mt2 ml2 mr2" cols="100" maxlength="300" style="width:99.6%;border:1px #CCC solid"></textarea>
						</td>
					</tr>
				</table>
				
			</form>
			
		</div>
		
	</div>
	
</div>

<%@ include file="/views/include/bottom.jsp"%>

</body>
</html>
