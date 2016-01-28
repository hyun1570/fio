<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@ include file="/views/include/tag_lib.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>:::::::::::::: ${PAGE_TITLE} ::::::::::::::</title>

<%@ include file="/views/include/css.jsp"%>
<%@ include file="/views/include/common.jsp"%>

<script language="javascript">
var mainGrid;
var mainProvider;

//초기화
$(window).load(function()
{
	var sc_height = document.body.clientHeight;
	var div_top = document.getElementById("grdMain").offsetTop;
	
	// 그리드 Object 셋팅
	setGridObject("grdMain", "100%", (sc_height - div_top - 150)+"px");
});

//컬럼별 속성 지정
function setCellStyles(grid,id,fields) {
	grid.addCellStyle("style01", {
		"foreground": "#ff000000",
		"background": "#ffffffcc",
		"fontSize": 13,
		"readOnly": false
	});

	// 스타일 지정 [rows],[field],style
	grid.setCellStyles([id],fields, "style01");
}

//Excel Export
function getExcelExport()
{
	mainGrid.exportGrid({
		type: "excel",
		target: "local",
		url: "출입관리(출입예약).xls",
		indicator: 'hidden',
		header: 'visible',
		footer: 'hidden'
	});
}

RealGrids.onload = function (id)
{
	mainGrid     = new RealGrids.GridView(id);
	mainProvider = new RealGrids.LocalDataProvider();
	
	mainGrid.setStyles(_grid_style);
	
	mainGrid.setDataProvider(mainProvider);

	setColumns(mainProvider,mainGrid);
	setOptions(mainGrid);
	
	// 이미지 리스트 호출
	createImageList(mainGrid);
	
	mainGrid.onDataCellClicked = function (grid, column) {
		 
		if (column.fieldName == "ioStat") {
			
			if("${SESSION_USER_ID}".indexOf("GATE") > -1){
			
				var r = mainProvider.getRow(column.dataRow);
				
				// 입문 처리
				if(r.ioStat == "N"){
					if(!confirm("입문 처리 하시겠습니까?")) return;
					setInVisitor('I', column);
					
				// 출문처리
				}else if(r.ioStat == "I"){
					if(!confirm("출문 처리 하시겠습니까?")) return;
					setInVisitor('O', column);
					
				// 이미 완료
				}else if(r.ioStat == "O"){
					//alert("처리가 완료 되었습니다.");
					
				// 잘못된 접근
				}else{
					alert("잘못된 접근 입니다.");
				}
			}else{
				alert("입/출 처리는 경비 담당자만 가능합니다.");
				return;
			}
		}
	};
	
	// Validation 정의
	getPageAction(2);
};

function setGridObject(tagid, width, height, onload)
{
	var flashvars = { id: tagid };
	
	if (onload && typeof(onload) === "function")
	{
		flashvars.onload = onload;
		console && console.log(flashvars);
	}
	
	var params = {};
	params.quality = "high";
	params.wmode = "opaque";
	params.allowscriptaccess = "always";
	params.allowfullscreen = "true";
	
	var attributes = {};
	attributes.id = tagid;
	attributes.name = tagid;
	attributes.align = "middle";
	
	/* SWFObject v2.2 <http://code.google.com/p/swfobject/> */
	var swfUrl = "<%=request.getContextPath()%>/resources/objects/RealGridWeb.swf";
	swfobject.embedSWF(swfUrl, tagid, width, height, "11.1.0", "<%=request.getContextPath()%>/resources/objects/expressInstall.swf", flashvars, params, attributes);
	
};

function setColumns(provider,grid)
{
	
	setVisitorInOutImgList(mainGrid);
	
	var c = []; 

	var g = JSON.parse(_gridList);

	for (var i=0; i<g.length; i++)
	{
		var obj = {};
		obj.fieldName = g[i].a.mappingId;
		obj.width     = g[i].a.width;
		obj.height    = g[i].a.height;
		obj.header    = {text : g[i].a.headerText};
		obj.styles    = {textAlignment : g[i].a.align};            // 그리드 정렬
		obj.visible   = g[i].a.visible == "Y" ? true : false;     // 그리드 Visible
		obj.readOnly  = g[i].a.columnType == "ro" ? true : false; // 그리드 Edit Mode
		//obj.editable  = !obj.readOnly    
		
		//콤보박스 설정
		if (g[i].a.columnType=="dropDown")
		{   
			// dropDown 처리
		}
		//check box 설정
		else if (g[i].a.columnType == "ch")
		{
			// checkbox 처리
		}
		// 시간
		else if(g[i].a.columnType == "tm" || g[i].a.columnType == "rotm"){
			obj.dataType = "datetime";
			obj.datetimeFormat = "HHmmss";
			obj.styles = {"textAlignment" : g[i].a.align,
					"datetimeFormat" : "HH:mm:ss"};
			obj.editor = {"datetimeFormat" : "HHmmss"};
			if(g[i].a.columnType == "rotm"){
				obj.readOnly = true;
			}
		}
		else if (g[i].a.columnType == "button"){
			obj.imageList = "vsitIO_Imgs";
			obj.width     = g[i].a.width;
			obj.renderer  = {
								"type": "icon",
								editable: true,
								startEditOnClick: true
							},
			//obj.dynamicStyles = iconStyles,
			
			obj.dynamicStyles = [
									{
										"criteria":"value = 'N'",
										"styles":"iconIndex=0"
									},
									{
										"criteria":"value = 'I'",
										"styles":"iconIndex=1"
									},
									{
										"criteria":"value = 'O'",
										"styles":"iconIndex=2"
									}
								],
			
			obj.styles = {
				"fontSize":"0",
				"textAlignment": "center",
				"iconIndex": 0,
				"iconLocation": "middle",
				"iconAlignment": "center",
				"iconOffset": 2,
				"iconPadding": 1,
				"foreground":"#ffffff"
			}, 
			obj.editable = false;
		}
		else 
		{
			//셀의 Max 값을 지정
			obj.editor = {type : "line", maxLength : g[i].a.maxLength=='undefined'?300:g[i].a.maxLength};
		}
		
		c.push(obj);
	}
	
	//Field Id를 그리드에 정의 한다.
	if (provider == mainProvider) {
		provider.setFields(c);
	}
	
	//그리드에 컬럼셋을 설정한다.
	if (grid == mainGrid)
	{
		grid.setColumns(c);
	}
	// If there's more grid then add else if code
}    

function setOptions(grid,editable)
{
	grid.setOptions({
		header:{
			height:"30"
		},
		display:{
			rowHeight:"30"
		},
		panel: {
			visible: false
		},
		footer: {
			visible: false
		},
		checkBar: {
			visible: true
		},
		statesBar: {
			visible: true
		},
		edit: {
			insertable: true,
			appendable: true,
			updatable: true,
			deletable: true,
			deleteRowsConfirm: true,
			deleteRowsMessage: "Are you sure?"
		},
		select:
		{
			style: RealGrids.SelectionStyle.ROWS
		}
	});
}

//Key Up
function keyUp(event)
{
	if (event.keyCode == 13) getPageAction(2);
}


// 페이지 Action
function getPageAction(action){
	switch(action){
		
		
		case 1:
			break;
		
		// 페이지 조회
		case 2:
			
			//Edit mode 해제
			mainGrid.commit(true);
			
			var jsonObj = {};
			jsonObj.sqlid = "inOutMng.GET_VSIT_MNG_RSVTN";
			jsonObj.sType = frm.sType.value;
			jsonObj.sTypeNm = frm.sTypeNm.value;
			if(frm.procEndYn.checked){
				jsonObj.procEndYn = "Y";
			}else{
				jsonObj.procEndYn = "N";
			}
			if('${SESSION_USER_ID}' != "GATE11" ) {
				jsonObj.bpCode = "CC";
			} else {
				jsonObj.bpCode = "BD";
			}
	
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
					mainProvider.setRows(result);
				},
				error      : function(e)
				{
					alert(e.responseText);
				}
			});
			 
			break;
		
		//등록        
		case 3:
			// 등록 소스는 여기에...      
			
		//취소
		case 4:
			
			//Edit mode 해제
			mainGrid.commit(true);
		
			//서버로 전송할 Json Array Object 선언
			var jsonArray = [];
			
			var rows = mainGrid.getCheckedRows();
			
			if (rows.length == 0)
			{
				alert("'취소'할 행을 선택하여 주십시오.");
				return;
			}
			
			if (confirm("'입/출 처리'를 '취소' 하시겠습니까?") == false) return;
			for( r in rows){
					
				var obj = mainProvider.getRow(rows[r]);
				
				if(obj.ioStat == "N"){
					
					alert("'입문/출문 처리' 하지 않은 건은 취소할 수 없습니다.\n다시한번 확인 후 실행해 주십시오.");
					return;
					
				}else if(obj.ioStat == "I"){
					
					var jsonObj = {};
					
					jsonObj.command    = "D";
					jsonObj.sqlId      = "inOutMng.DEL_VSIT_MNG_RSVTN";
					jsonObj.vsitMngRId = isNullStr(obj.vsitMngRId);
					
					jsonArray.push(jsonObj);
					
				}else if(obj.ioStat == "O"){
					
					var jsonObj = {};
					
					jsonObj.command    = "U";
					jsonObj.sqlId      = "inOutMng.UPT_VSIT_MNG_RSVTN";
					jsonObj.vsitMngRId = isNullStr(obj.vsitMngRId);
					jsonObj.outGate    = "";
					jsonObj.outTime    = "";
					jsonObj.etc        = isNullStr(obj.etc);
					jsonObj.ioStat     = "I";
					
					jsonArray.push(jsonObj);
					
				}else{
				
				}
			}
			
			doAjax2(jsonArray, function(ret){
				if(ret == "SUCCESS"){
					alert("정상적으로 취소하였습니다.");
					getPageAction(2);
				}else{
					alert("처리에 실패하였습니다.");
				}
				
			});
			
			
			break;
			
	}
}

// 이미지 변경 리스트
function setVisitorInOutImgList(grid){
	var imgs = new RealGrids.ImageList("vsitIO_Imgs");
	imgs.rootUrl = "resources/css/images/";
	imgs.images = [
		"btn_enter.gif",
		"btn_comeout.gif",
		"btn_done.gif"
	];
	
	grid.addImageList(imgs);
}

//입문처리 로직
function setInVisitor(stat, col){
	
	// Edit mode 해제 
	mainGrid.commit(true);
	
	mainGrid.checkRow(col.dataRow, true, true); // 그리드 선택
	
	var obj = mainProvider.getRow(col.dataRow); 
	
	var jsonArray = [];
	
	if(stat == "I"){
		var jsonObj = {};
		jsonObj.sqlId          = "inOutMng.INS_VSIT_MNG_RSVTN";
		jsonObj.vsitRsvtnMId   = isNullStr(obj.vsitRsvtnMId);
		jsonObj.vsitRsvtnDId   = isNullStr(obj.vsitRsvtnDId);
		jsonObj.inGate         = "${SESSION_USER_ID}";
		jsonObj.strgNo         = isNullStr(obj.strgNo);
		jsonObj.etc            = isNullStr(obj.etc);
		jsonObj.ioStat         = stat;
		jsonObj.command        = "C";
		
		jsonArray.push(jsonObj);
		
	}else if(stat == "O"){
		var jsonObj = {};
		jsonObj.sqlId          = "inOutMng.UPT_VSIT_MNG_RSVTN";
		jsonObj.vsitMngRId     = isNullStr(obj.vsitMngRId);
		jsonObj.outGate        = "${SESSION_USER_ID}";
		jsonObj.etc            = isNullStr(obj.etc);
		jsonObj.ioStat         = stat;
		jsonObj.command        = "U";
		
		jsonArray.push(jsonObj);
	}

	//실행쿼리 호출
	doAjax2(jsonArray, function(ret){
		if(ret == "SUCCESS"){
			alert("정상 처리 하였습니다.");
			getPageAction(2);
		}else{
			alert("처리에 실패하였습니다.");
		}
	});
	
}

function goPage(action){
	
	var url = "";
	
	switch(action){
		case 1 :
			url = "DDTA.IOMNG.L01.cmd";
			break;
		case 2:
			url = "DDTA.IOMNG.L02.cmd";
			break;
	}

	$("#frm").attr({
		action : url,
		target : "_self",
		method : "POST"
	});

	$("#frm").submit();
	
}

// 내부사용자 등록 팝업
function innerEmpReg(){
	getCommonPopUpWithParam(600, 500, "방문 사내직원 등록", "DDTA.IOMNG.P01.cmd", {});
}

$(window).ready(function(){
	
});


</script>

</head>

<body>
<div class="wrap">
	
	<%@ include file="/views/include/top.jsp"%>
	
	<div class="container">
		
		<div class="sub_nav">홈 > ${MENU_NAME}</div>
		
		<div class="content">
			
			<div class="subtitle">${MENU_NAME}</div>
			
			<div class="content_tab">
				<ul>
					<li><a href="javascript:void(0)" onclick="goPage(1)" class="content_tab_active"><span class="content_tab_active_left">예약출입자</span></a></li>
					<li><span class="content_tab_space"></span></li>
					<li><a href="javascript:void(0)" onclick="goPage(2)" class="content_tab_anchor"><span class="content_tab_anchor_left">상시출입자</span></a></li>
				</ul>
			</div>
			
			<div class="hspace10"></div> 
			
			<form id="frm" name="frm">
				
				<table class="search_area">
					<colgroup>
						<col width="100"/>
						<col width="100"/>
						<col width="*"/>
					</colgroup>
					<tr>
						<td>
							<select id="sType" name="sType" class="selectbox_search w100">
								<option value="sVsitUserNm">출입자명</option>
								<option value="sVsitRegNo">예약번호</option>
							</select>
						</td>
						<td>
							<input type="text" class="textbox_search_lmargin" id="sTypeNm" name="sTypeNm" onkeydown="keyUp(event)"/>
						</td>
						<td>
							<input type="checkbox" id="procEndYn" name="procEndYn" class="checkbox_search"/> 처리완료 제외
						</td>
						<td class="tar">
							<a href="javascript:void(0)" class="btn_search" onclick="getPageAction(2)"><span class="btn_search_left">조회</span></a>
							<a href="javascript:void(0)" class="btn_delete" onclick="getPageAction(4)"><span class="btn_delete_left">취소</span></a>
							<a href="javascript:void(0)" class="btn_add" onclick="innerEmpReg()"><span class="btn_add_left">방문 사내직원</span></a>
							<a href="javascript:void(0)" class="btn_download" onclick="getExcelExport()"><span class="btn_download_left">Excel Download</span></a>
						</td>
					</tr>
				</table>
				
				<div id="grdMain"></div>
				
				<input type="text" id="x" name="x" style="width:0px;height:0px;border:0px"/>
				
			</form>
			
		</div>
		
	</div>
	
</div>

<%@ include file="/views/include/bottom.jsp"%>

</body>
</html>    