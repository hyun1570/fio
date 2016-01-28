<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@ include file="/views/include/tag_lib.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>:::::::::::::: ${PAGE_TITLE} ::::::::::::::</title>

<%@ include file="/views/include/css.jsp"%>
<%@ include file="/views/include/common.jsp"%>

<script type="text/javascript">
var mainGrid;
var mainProvider;
var myCalendar;

//초기화
$(window).load(function()
{
    
    myCalendar = new dhtmlXCalendarObject(["sFromDate", "sToDate"]);
    
    var st = isNullStr("<%=request.getParameter("sFromDate")%>");
    var ed = isNullStr("<%=request.getParameter("sToDate")%>");
    
    if(st == "" || ed == ""){
	    $("#sFromDate").val(setCommonFormatSetting(getCurrFirstDay(),"####-##-##"));
	    $("#sToDate").val(setCommonFormatSetting(getCommonToDay(),"####-##-##"));
	    $("#factCode").val("");
	    $("#vsitCode").val("");
	    $("#inGate").val("");
    }else{
    	$("#sFromDate").val(st);
        $("#sToDate").val(ed);
        $("#factCode").val("<%=request.getParameter("factCode")%>");
        $("#vsitCode").val("<%=request.getParameter("vsitCode")%>");
        $("#inGate").val("<%=request.getParameter("inGate")%>");
    }
	
	// 그리드 Object 셋팅
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
        url: "realgrid.xls",
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
   
    //setVisitorInOutImgList(grdMain);
    
    
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
        
        obj.baseField = "ioStat";
            
        obj.dynamicStyles = [
                             {criteria: "base = 'O'", styles:"background=#ffffff"},
                             {criteria: "base = 'I'", styles:"fontBold=true;background=#fee1e1"}
                            ];
        
        // 데이트형
        if(g[i].a.columnType == "dt" || g[i].a.columnType == "rodt"){
            obj.dataType = "datetime";
            obj.datetimeFormat = "yyyyMMdd";
            obj.styles = {"textAlignment" : g[i].a.align,
                    "datetimeFormat" : "yyyy-MM-dd"};
            obj.editor = {"datetimeFormat" : "yyyyMMdd",maxLength : 8};
            if(g[i].a.columnType == "rodt"){
                obj.readOnly = true;
            }
        }
        // 시간
        else if(g[i].a.columnType == "tm" || g[i].a.columnType == "rotm"){
            obj.dataType = "datetime";
            obj.datetimeFormat = "HHmmss";
            if(g[i].a.mappingId == "modTime"){
                obj.styles = {"textAlignment" : g[i].a.align,
                        "datetimeFormat" : "HH:mm:ss"};
                obj.editor = {"datetimeFormat" : "HHmmss",maxLength :6};
            }else{
                obj.styles = {"textAlignment" : g[i].a.align,
                        "datetimeFormat" : "HH:mm:ss"};
                obj.editor = {"datetimeFormat" : "HHmmss",maxLength : 4};
            }
            
            if(g[i].a.columnType == "rotm"){
                obj.readOnly = true;
            }
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
            visible: false
        },
        statesBar: {
            visible: false
        },
        edit: {
            insertable: false,
            appendable: false,
            updatable: false,
            deletable: false,
            deleteRowsConfirm: false,
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
           jsonObj.sqlid = "inOutRpt.GET_IO_RSVTN_RPT_DAY";
           jsonObj.sFromDate = frm.sFromDate.value.replace(/-/g, '');
           jsonObj.sToDate = frm.sToDate.value.replace(/-/g, '');
           jsonObj.factCode = isNullStr(frm.factCode.value);
           jsonObj.vsitCode = isNullStr(frm.vsitCode.value);
           jsonObj.inGate = isNullStr(frm.inGate.value);
           jsonObj.sBpCode	= $('input[name=sBpCode]:radio:checked').val();

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

           
           break;
    }

}
    
function setRptType(type){
	if(type == "D"){
		getPageAction(2);
	}else if(type == "Y"){
		$("#frm").attr({
	        action : "DDTA.IORPT.L02.cmd",
	        target : "_self",
	        method : "POST"
	    });

	    $("#frm").submit();
		return;
	}
}    

$(window).ready(function(){
    $(".btn_search").click(function(){
        $("#factCode").val("");
        $("#vsitCode").val("");
        $("#inGate").val("");
    	getPageAction(2);
    });
});

</script>

</head>

<body>
	
<div class="wrap">
	
	<%@ include file="/views/include/top.jsp"%>
	
	<div class="container">
		
		<div class="sub_nav">홈 > 출입현황 > ${MENU_NAME}</div>
		
		<div class="content">
			
			<div class="subtitle_all">
				<div class="subtitle_title">${MENU_NAME}</div>
				<div class="subtitle_btngroup">
					<a href="javascript:void(0)" class="btn_search" onclick="getPageAction(2)"><span class="btn_search_left">조회</span></a>
					<a href="javascript:void(0)" class="btn_download" onclick="getExcelExport()"><span class="btn_download_left">Excel Download</span></a>
				</div>
			</div>
			
			<form id="frm" name="frm">
				
				<input type="hidden" id="factCode" name="factCode"/>
				<input type="hidden" id="vsitCode" name="vsitCode"/>
				<input type="hidden" id="inGate" name="inGate"/>
			
				<table class="tbl_search" style="table-layout:fixed;">
					<colgroup>
						<col width="7%"/><col width="16%"/>
						<col width="7%"/><col width="24%"/>
						<col width="7%"/><col width="39%"/>
					</colgroup>
					<tr>
						<td class="tbl_search_title wp10">사업장구분</td>
						<td>
							<input type="radio" name="sBpCode" id="sBpCode01" value="CC" 
									checked="checked" class="radiobox_search"/>
								<label for="sBpCode01">광주공장</label>
							<input type="radio" name="sBpCode" id="sBpCode02" value="BD" 
									class="radiobox_search"/>
								<label for="sBpCode02">부평연구소</label>
						</td>
						<td class="tbl_search_title wp10">조회일자</td>
						<td>
							<input type="text" id="sFromDate" name="sFromDate" size="13" maxlength="10" class="calendar_intd"/>
							&nbsp;~&nbsp;<input type="text" id="sToDate" name="sToDate" size="13" maxlength="10" class="calendar_intd"/>
						</td>
						<td class="tbl_search_title wp10">현황구분</td>
						<td>
							<input type="radio" name="sRptType" id="sRptType01" value="D" 
									checked="checked" class="radiobox_search" onclick="setRptType(this.value)"/> 
								<label for="sRptType01">일별현황</label>
							<input type="radio" name="sRptType" id="sRptType02" value="Y" 
									class="radiobox_search" onclick="setRptType(this.value)"/> 
								<label for="sRptType02">연간현황</label>
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