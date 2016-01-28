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
	setComboYears();
	
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
    
    mainGrid.onDataCellDblClicked  = function (grid, column) {
    	
    	if(column.fieldName.substr(-3) == "Cnt"){
    		var no = column.fieldName.substring(1, 3).replace('C', '');
    		no = Number(no) < 10 ? "0"+no : no;
    		sdate = frm.sYear.value+"/"+no+"/01";
    		var d = new Date(sdate);
    	    var param = "?param=";
    	    param += "&sFromDate="+getFirstDay(sdate, "-");
    	    param += "&sToDate="+getLastDay(sdate, "-");
    	    param += "&factCode="+mainProvider.getRow(column.dataRow).factCode;
    	    param += "&vsitCode="+mainProvider.getRow(column.dataRow).vsitCode;
    	    param += "&inGate="+mainProvider.getRow(column.dataRow).inGate;
    		
    	    //console.log(mainProvider.getRow(column.dataRow).factCode);

    	    
    		$("#frm").attr({
                action : "DDTA.IORPT.L01.cmd"+param,
                target : "_self",
                method : "POST"
            });

            $("#frm").submit();
    		
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
   
    //setVisitorInOutImgList(grdMain);

    var c = []; 

    var g = JSON.parse(_gridList);
    
    for (var i=0; i<g.length; i++)
    {
        var obj = {};
        
        
        obj.fieldName = g[i].a.mappingId;
        
        if(frm.sSearchType.value == "C"){
            if(obj.fieldName == "factCode" || obj.fieldName == "factName" ){
            	obj.visible   = true;     // 그리드 Visible
            }else if(obj.fieldName == "vsitCodeNm" || obj.fieldName == "vsitCode"){
            	obj.visible   = false;     // 그리드 Visible
            }else if(obj.fieldName == "inGate" || obj.fieldName == "inGateNm"){
                obj.visible   = false;     // 그리드 Visible            	
            }else{
            	obj.visible   = g[i].a.visible == "Y" ? true : false;     // 그리드 Visible
            }
        }else if(frm.sSearchType.value == "V"){ 
        	if(obj.fieldName == "factCode" || obj.fieldName == "factName" ){
                obj.visible   = false;     // 그리드 Visible
            }else if(obj.fieldName == "vsitCodeNm" || obj.fieldName == "vsitCode"){
                obj.visible   = true;     // 그리드 Visible
            }else if(obj.fieldName == "inGate" || obj.fieldName == "inGateNm"){
                obj.visible   = false;     // 그리드 Visible               
            }else{
                obj.visible   = g[i].a.visible == "Y" ? true : false;     // 그리드 Visible
            }
        }else if(frm.sSearchType.value == "G"){
        	if(obj.fieldName == "factCode" || obj.fieldName == "factName" ){
                obj.visible   = false;     // 그리드 Visible
            }else if(obj.fieldName == "vsitCodeNm" ){
                obj.visible   = false;     // 그리드 Visible
            }else if(obj.fieldName == "inGate" || obj.fieldName == "inGateNm"){
                obj.visible   = true;     // 그리드 Visible               
            }else{
                obj.visible   = g[i].a.visible == "Y" ? true : false;     // 그리드 Visible
            }
        }
        
        var leng = obj.fieldName.length - 3;
        
        if(obj.fieldName.substr(leng) == "Cnt"){

        	obj.baseField = String(obj.fieldName.split("Cnt")[0]+"Stat");
        	
            obj.dynamicStyles = [
        	                     {criteria: "base = 'N'", styles:"background=#ffffff"},
        	                     {criteria: "base = 'Y'", styles:"fontBold=true;foreground=#ffff0000;background=#fee1e1"}
        	                     ];
        	
        }
        
        //숫자
        if(g[i].a.columnType == "no" || g[i].a.columnType == "rono"){
            obj.dataType = "numeric";
            obj.styles={
                     "textAlignment": "far",
                     "numberFormat": "#,###"
            };
            obj.editor = {"type":"number", maxLength : g[i].a.maxLength=='undefined'?300:g[i].a.maxLength, positiveOnly:true, integerOnly:true};
            
            if(g[i].a.columnType == "rono"){
                obj.readOnly = true;
                obj.editalbe = false;
            }
        }else{
        	obj.editor = {"type":"number", maxLength : g[i].a.maxLength=='undefined'?300:g[i].a.maxLength, positiveOnly:true, integerOnly:true};
        }
        


        obj.width     = g[i].a.width;
        obj.height    = g[i].a.height;
        obj.header    = {text : g[i].a.headerText};
        obj.styles    = {textAlignment : g[i].a.align};            // 그리드 정렬
        
        obj.readOnly  = g[i].a.columnType == "ro" ? true : false; // 그리드 Edit Mode
        //obj.editable  = !obj.readOnly
        
        if(obj.fieldName == "factCode" || obj.fieldName == "vsitCode" || obj.fieldName == "inGate"){
            obj.footer = {
                    "text": "합계",
                    styles:{
                    	textAlignment: "center",
                    	font: "굴림,12"
                    }
                    };
            
        }else if(obj.fieldName == "factName" || obj.fieldName == "vsitCodeNm" || obj.fieldName == "inGateNm"){
            obj.footer = {
                    "text": ""
                    };
        }else{
            obj.footer = {
                    styles: {
                        textAlignment: "far",
                        numberFormat: "0,000",
                        font: "굴림,12"
                        },
                    text: "합계",
                    expression: "sum"
                };
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
            visible: true,
            height:"30"
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
            style: RealGrids.SelectionStyle.NONE
        },
        footer:{
        	height:"30"
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
           
    	   setColumns(mainProvider,mainGrid);
    	   
    	   //Edit mode 해제
           mainGrid.commit(true);
           
           var jsonObj = {};
           jsonObj.sqlid = "inOutRpt.GET_IO_RSVTN_RPT_YEAR";
           jsonObj.sYear = $("#sYear").val();
           jsonObj.sSearchType = frm.sSearchType.value;
           jsonObj.sBpCode	= $('input[name=sBpCode]:radio:checked').val();
			
           //alert(JSON.stringify(jsonObj));
           
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


function setComboYears(){
	var _year_date = new Date();
	var _yyyy  = _year_date.getFullYear();
	var combo = $('#sYear');
	
	$('option', combo).remove(); // 콤보 Remove
	
	for(var y = 2010; y <= Number(_yyyy); y++){
		if(y == _yyyy){
			combo.append("<option vlaue='"+y+"' selected='selected'>"+y+"</option>");
		}else{
			combo.append("<option vlaue='"+y+"'>"+y+"</option>");
		}
	}
	
	
}

function setRptType(type){
    if(type == "Y"){
        getPageAction(2);
    }else if(type == "D"){
        $("#frm").attr({
            action : "DDTA.IORPT.L01.cmd",
            target : "_self",
            method : "POST"
        });

        $("#frm").submit();
        return;
    }
}

function changeGridType(code){
	getPageAction(2);
}

$(window).ready(function(){
    $("#sYear").change(function(){
        getPageAction(2);
    });
    
    $("#sSearchType").change(function(){
    	changeGridType( $(this).val());
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
			
				<form id="frm" name="frm">
					
					<div class="subtitle_all">
						<div class="subtitle_title">${MENU_NAME}</div>
						<div class="subtitle_btngroup">
							<a href="javascript:void(0)" class="btn_search" onclick="getPageAction(2)"><span class="btn_search_left">조회</span></a>
							<a href="javascript:void(0)" class="btn_download" onclick="getExcelExport()"><span class="btn_download_left">Excel Download</span></a>    
						</div>
					</div>
					
					<table class="tbl_search" style="table-layout:fixed;">
						<colgroup>
							<col width="7%"/><col width="20%"/>
							<col width="7%"/><col width="12%"/>
							<col width="7%"/><col width="20%"/>
							<col width="7%"/><col width="20%"/>
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
							<td class="tbl_search_title">조회년도</td>
							<td>
								<select id="sYear" name="sYear" class="selectbox_search w80"></select>
							</td>
							<td class="tbl_search_title">현황구분</td>
							<td>
								<input type="radio" name="sRptType" id="sRptType01" value="D" 
										class="radiobox_search" onclick="setRptType(this.value)"/> 
									<label for="sRptType01">일별현황</label> 
								<input type="radio" name="sRptType" id="sRptType02" value="Y" 
										checked="checked"  class="radiobox_search" onclick="setRptType(this.value)"/> 
									<label for="sRptType02">연간현황</label>
							</td>
							<td class="tbl_search_title">조회구분</td>
							<td>
								<select id="sSearchType" name="sSearchType" class="selectbox_search w150"><!--  onchange="changeGridType(this.value)"> -->
									<option value="C" selected="selected">공장별</option>
									<option value="V">출입목적별</option>
									<option value="G">출입문별</option>
								</select>
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