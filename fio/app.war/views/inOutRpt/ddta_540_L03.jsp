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

//초기화
$(window).load(function()
{
    
    myCalendar = new dhtmlXCalendarObject(["sFromDate", "sToDate"]);
    
    var st = isNullStr("<%=request.getParameter("sFromDate")%>");
    var ed = isNullStr("<%=request.getParameter("sToDate")%>");
    
    
    if(st == "" || ed == ""){
        $("#sFromDate").val(setCommonFormatSetting(getCurrFirstDay(),"####-##-##"));
        $("#sToDate").val(setCommonFormatSetting(getCommonToDay(),"####-##-##"));
        $("#vsitRegNo").val("");
    }else{
        $("#sFromDate").val(st);
        $("#sToDate").val(ed);
        $("#vsitRegNo").val("<%=request.getParameter("vsitRegNo")%>");
    }
    
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
   
    //setVisitorInOutImgList(mainGrid);
    
    
    var c = []; 
    var f = [];
    var gArr = [];
    
    var g = JSON.parse(_gridList);
    
    for (var i=0; i<g.length; i++)
    {
    	var obj = {};
        
    	obj = {};
        obj.fieldName = g[i].a.mappingId;
        obj.width     = g[i].a.width;
        obj.height    = g[i].a.height;
        obj.header    = {text : g[i].a.headerText};
        obj.styles    = {textAlignment : g[i].a.align};            // 그리드 정렬
        obj.visible   = g[i].a.visible == "Y" ? true : false;     // 그리드 Visible
        obj.readOnly  = g[i].a.columnType == "ro" ? true : false; // 그리드 Edit Mode
        obj.editable  = !obj.readOnly;   

        obj.baseField = "ioStat";
    
        obj.dynamicStyles = [
                         {criteria: "base = 'O'", styles:"background=#ffffff"},
                         {criteria: "base = 'E'", styles:"background=#ffffff"},
                         {criteria: "base = 'I'", styles:"fontBold=true;background=#fee1e1"}
                        ];
        
        // 데이트형
        if(g[i].a.columnType == "dt" || g[i].a.columnType == "rodt"){
            obj.dataType = "datetime";
            obj.datetimeFormat = "yyyyMMdd";
            obj.styles = {"textAlignment" : g[i].a.align,
                    "datetimeFormat" : "yyyy-MM-dd"};
            obj.editor = {"datetimeFormat" : "yyyyMMdd",maxLength : g[i].a.maxLength=='undefined'?300:g[i].a.maxLength};
            if(g[i].a.columnType == "rodt"){
                obj.readOnly = true;
            }
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
        }else{
        	
        }
        
        if(g[i].a.mappingId.length > 6 && (g[i].a.mappingId.substr(-7, 4) == "Gate" || g[i].a.mappingId.substr(-5, 4) == "Time")){
        
        	if(g[i].a.mappingId.substr(-7, 4) == "Gate"){
  	    
        		gArr = [];
        		gArr.push(obj);
        	    
        	}else if(g[i].a.mappingId.substr(-5, 4) == "Time"){
        		
        		
        		gArr.push(obj);
        		
        		var gObj = {};
        		gObj.type         = "group";
        		gObj.orientation  = "vertical";
        		gObj.width        = "80";
        		gObj.header       = { visible:false };
        		gObj.columns      = gArr;
        		
        		c.push(gObj);

        	}
        }else{
	        c.push(obj);
        }
        
        f.push(obj);
     }
    
//     console.log(c);
    
//     return;
    
    //Field Id를 그리드에 정의 한다.
    if (provider == mainProvider) {
        provider.setFields(f);
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
            height:"50"
        },
        display:{
            rowHeight:"50"
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
           jsonObj.sqlid     = "inOutRpt.GET_IO_EVRY_RPT_DAY";
           jsonObj.sFromDate = frm.sFromDate.value.replace(/-/g, '');
           jsonObj.sToDate   = frm.sToDate.value.replace(/-/g, '');
           jsonObj.sType     = frm.sType.value;
           jsonObj.sTypeNm   = $.trim(frm.sTypeNm.value);
           jsonObj.vsitRegNo = frm.vsitRegNo.value;

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
            action : "DDTA.IORPT.L04.cmd",
            target : "_self",
            method : "POST"
        });

        $("#frm").submit();
        return;
    }
}    

</script>

</head>

<body>
<div class="wrap">
    <%@ include file="/views/include/top.jsp"%>
    <div class="container">
        <div class="sub_nav">홈 > 출입현황 > ${MENU_NAME}</div>
        <div class="content">
            <form id="frm" name="frm">
                <input type="hidden" id="vsitRegNo" name="vsitRegNo"/>
                <div class="subtitle_all">
                    <div class="subtitle_title">${MENU_NAME}</div>
                    <div class="subtitle_btngroup">
                        <a href="javascript:void(0)" class="btn_search" onclick="getPageAction(2)"><span class="btn_search_left">조회</span></a>
                        <a href="javascript:void(0)" class="btn_download" onclick="getExcelExport()"><span class="btn_download_left">Excel Download</span></a>
                    </div>
                </div>
                <table class="tbl_search">
                    <colgroup>
                        <col width="10%"/>
                        <col width="25%"/>
                        <col width="10%"/>
                        <col width="20%"/>
                        <col width="10%"/>
                        <col width="*"/>
                    </colgroup>
                    <tr>
                        <td class="tbl_search_title wp10">
                            조회일자
                        </td>
                        <td>
                            <input type="text" id="sFromDate" name="sFromDate" size="13" maxlength="10" class="calendar_intd"/>
                            &nbsp;~&nbsp;<input type="text" id="sToDate" name="sToDate" size="13" maxlength="10" class="calendar_intd"/>
                        </td>
                        <td class="tbl_search_title wp10">
                            현황구분
                        </td>
                        <td>
                           <input type="radio" name="sRptType" value="D" checked="checked" class="radiobox_search" onclick="setRptType(this.value)"/> 일별현황 
                           <input type="radio" name="sRptType" value="Y" class="radiobox_search" onclick="setRptType(this.value)"/> 연간현황
                        </td>
                        <td class="tbl_search_title wp10">
                            조회구분
                        </td>
                        <td>
                            <select id="sType" name="sType" class="selectbox_search">
                                <option value="sRegNo">출입번호</option>
                                <option value="sUserNm">출입자</option>
                            </select> 
                            <input type="text" id="sTypeNm" name="sTypeNm" class="textbox_search" onkeyup="keyUp(event)"/>
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