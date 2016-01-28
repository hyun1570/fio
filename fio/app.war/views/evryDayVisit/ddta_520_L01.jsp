<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@ include file="/views/include/tag_lib.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>:::::::::::::: ${PAGE_TITLE} ::::::::::::::</title>

<%@ include file="/views/include/css.jsp"%>
<%@ include file="/views/include/common2.jsp"%>

<script language="javascript">
var mainGrid;
var mainProvider;
var idx;
var popType;

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
    
    //Cell 의 버튼 클릭이 있을경우
    mainGrid.onDataCellClicked = function (grid, column) {
        if (column.fieldName == "deptName") {
            idx = column.itemIndex;
            popType = "DEPT";
        	getCommonPopUpWithParam(600, 400,"방문처","DDTA.COMMON.P01.cmd", {grid : column.itemIndex}, "winId");
        }
        
        if (column.fieldName == "intvUserName") {
        	idx = column.itemIndex;
        	popType="EMP";
            getCommonPopUpWithParam(600, 400, "면담자", "DDTA.COMMON.P02.cmd",  {grid : column.itemIndex}, "winId2");
        }
    };
    
    // 이미지 리스트 호출
    createImageList(mainGrid);
    
    // Validation 정의
//     mainProvider.addDataValidation('deptName','empty');
    mainProvider.addDataValidation('vsitCode', 'empty');
    mainProvider.addDataValidation('deptName','empty');
    mainProvider.addDataValidation('vsitCompNm','empty');
    mainProvider.addDataValidation('vsitUserNm','empty');
    mainProvider.addDataValidation('vsitUserTel','empty');
    mainProvider.addDataValidation('vsitUserMail','empty');
    
//     mainProvider.addDataValidation('intvUserName','empty');
//     mainProvider.addDataValidation('intvUserTel','empty');
//     mainProvider.addDataValidation('intvUserMail','empty');
    
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
        //obj.editable  = !obj.readOnly                              // 그리드 Edit Mode
        
        if (g[i].a.columnType=="button"){
        	
        	if(g[i].a.mappingId == "deptName"){
	        	obj.imageList =  "images1";
	            obj.renderer = {
	                                    "type": "icon",
	                                    editable: true,
	                                    startEditOnClick: true
	                                },
	            //obj.dynamicStyles = iconStyles,
	            obj.styles = {
	                "textAlignment": "left",
	                "iconIndex": 1,
	                "iconLocation": "right",
	                "iconAlignment": "right",
	                "iconOffset": 2,
	                "iconPadding": 1
	            },
	            obj.editable = false;
        	}
        	if(g[i].a.mappingId == "intvUserName"){
                obj.imageList =  "images1";
                obj.renderer = {
                                        "type": "icon",
                                        editable: true,
                                        startEditOnClick: true
                                    },
                //obj.dynamicStyles = iconStyles,
                obj.styles = {
                    "textAlignment": "left",
                    "iconIndex": 1,
                    "iconLocation": "right",
                    "iconAlignment": "right",
                    "iconOffset": 2,
                    "iconPadding": 1
                },
                obj.editable = false;
            }
        }
        
        // 데이트형
        if(g[i].a.columnType == "dt" || g[i].a.columnType == "rodt"){
            obj.dataType = "datetime";
            obj.datetimeFormat = "yyyyMMdd";
            obj.styles = {"textAlignment" : g[i].a.align,
                    "datetimeFormat" : "yyyy-MM-dd"};
            obj.editor = {"datetimeFormat" : "yyyyMMdd"};
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
        }
        
        //콤보박스 설정
        else if (g[i].a.columnType=="dropDown")
        {   
        	if(g[i].a.mappingId == "vsitCode"){
        	
	            //TypeValue에 지정한  Common Master Code에 해당하는 공통코드를 콤보로 가져온다
	            var _t = getCommonCodeToGridCombo(g[i].a.typeValue);
	            obj.lookupDisplay = true;
	            obj.values = _t.values;
	            obj.labels = _t.labels,
	            obj.editor = {type : _t.type}; //, dropDownCount : _t.dropDownCount
        	}
        	
        	if(g[i].a.mappingId == "inOutStop"){
        		var _t  = {
        		           
        		           type   : 'dropDown', 
        		           values : ['N','Y'], 
        		           labels : ['출입허용','출입정지']
        		};
        		obj.dynamicStyles = [
                                     {
                                         "criteria":"value = 'N'",
                                         "styles":"background=#ffffff"
                                     },
                                     {
                                         "criteria":"value = 'Y'",
                                          "styles":"background=#fee1e1;fontBold=true"
                                      }
                                     ];
                obj.lookupDisplay = true;
                obj.values = _t.values;
                obj.labels = _t.labels,
                obj.editor = {type : _t.type}; //, dropDownCount : _t.dropDownCount
        		
        	}
        }
        //check box 설정
        else if (g[i].a.columnType == "ch")
        {
            obj.editable = false;
            obj.renderer = {
                 type: "check",
                 editable: true,
                 startEditOnClick: true,
                 trueValues: "Y",
                 falseValues: "N",
                 labelPosition: "hidden"
             };
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

//마스터코드에 해당하는 공통코드를 가져오고,
//Parameter : master code
//Return    : Json Combo Object (RealGrid Combo) 
function getCommonCodeToGridCombo(_masterCode)
{
   //조회 파라메터 Object
   var jsonObj = {
           sqlid      : 'Common.COMM_COMBO_GRID',
           masterCode : _masterCode,
           siteCode   : '10008'
   };

   //Return Object(Realgrid Combo)
   var ret  = {
           type   : 'dropDown', 
           values : [], 
           labels : []  
   };
   
   $.ajax({
       type      : "POST",
       url       : "DDTA.BASE.SERVICE.R00.cmd?param="+JSON.stringify(jsonObj),
       dataType  : "json",
       data      : {"param" : JSON.stringify(jsonObj)},
       async     : false,
       beforeSend: function(xhr)
       {
           
       },
       success   : function(r)
       {
    	   ret.dropDownCount = r.length;
           
           for (i in r)
           {
               ret.values.push(r[i].code);
               ret.labels.push(r[i].codeName);
                   
           }
       },
       error     : function()
       {
           // Error 발생 Code
       }
   });
   
   return ret;
}

//Key Up
function keyUp(event)
{
    if (event.keyCode == 13) getPageAction(2);
}

function addVisitor(){
    // Edit mode 해제 
    mainGrid.commit();

    var dataRow = mainGrid.getItemCount();

    var row =
    {
    		regId : "${SESSION_USER_ID}",
    		modId : "${SESSION_USER_ID}",
    		inOutStop:"N"
    };

    mainProvider.insertRow(0, row);
    
    setCellStyles(mainGrid, dataRow, "masterCode");
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
		   jsonObj.sqlid = "evryDayVisit.GET_EVRY_DAY_VSIT";
		   jsonObj.sType = frm.sType.value;
		   jsonObj.sTypeNm = frm.sTypeNm.value;
		   jsonObj.sInOutStop = frm.sInOutStop.checked ?"Y":"N";

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
		   
		  //Edit mode 해제
           mainGrid.commit(true);
       
           //서버로 전송할 Json Array Object 선언
           var jsonArray = [];

           //State가 변경된 Rows를 반환한다. Created,Updated,Deleted
           var m_rows = mainProvider.getAllStateRows();
           
           
           //신규 데이타
           if (m_rows.created.length > 0)
           {
        	   
        	   
               for( r in m_rows.created)
               {   //해당 Row Data를 Json개체로 받는다.
                   var j = mainProvider.getRow(m_rows.created[r]);
                   if (!mainProvider.getDataValidation(j)) return;
                   j.intvUserId = isNullStr(j.intvUserId);
                   j.intvUserTel = isNullStr(j.intvUserTel);
                   j.intvUserMail = isNullStr(j.intvUserMail);
                   j.bpCode = isNullStr(j.bpCode);
                   j.etc = isNullStr(j.etc);
                   j.command = "C";
                   j.sqlId   = "evryDayVisit.INS_EVRY_DAY_VSIT";
                   jsonArray.push(j);
               }
           }
           
           //수정 데이타
           if (m_rows.updated.length > 0)
           {
               for( r in m_rows.updated)
               {   //해당 Row Data를 Json개체로 받는다.
                   var j = mainProvider.getRow(m_rows.updated[r]);
                   j.etc = isNullStr(j.etc);
                   j.bpCode = isNullStr(j.bpCode);
               
                   if (!mainProvider.getDataValidation(j)) return;
                   
                   j.command = "U";
                   j.sqlId   = "evryDayVisit.UPT_EVRY_DAY_VSIT";
                   j.modId   = '${SESSION_USER_ID}';
                   jsonArray.push(j);
               }
           }
	   
           if (jsonArray.length<=0) return;
           
           //셀스타일 초기화
           mainGrid.clearCellStyles();
           
           if(!confirm("저장 하시겠습니까?")) return;
           
           //실행쿼리 호출
           doAjax2(jsonArray, function(ret){
        	   if(ret == "SUCCESS"){
        		   alert("상시출입자를 저장하였습니다.");
        		   getPageAction(2);
        	   }else{
        		   alert("처리에 실폐하였습니다.");
        	   }
              
           });
           
           break;
       
           
       //삭제
	   case 4:
		   //Edit mode 해제
           mainGrid.commit(true);
       
           //서버로 전송할 Json Array Object 선언
           var jsonArray = [];
       
           var rows = mainGrid.getCheckedRows();
           
           
           if (rows.length == 0)
           {
               alert("삭제할 '상시출입자'를 선택하여 주십시오.");
               return;
           }
           
           if (confirm("'상시출입자'를 '삭제' 하시겠습니까?") == false) return;
           
            //삭제 데이타
            for( r in rows)
            {   
                if (mainProvider.getRowState(rows[r])=="created")
                {
                    mainProvider.setRowState(rows[r],"deleted", true); 
                }
                else
                {
                    //해당 Row Data를 Json개체로 받는다.
                    var j = mainProvider.getRow(rows[r]);
					j.command = "D";
					j.sqlId   = "evryDayVisit.DEL_EVRY_DAY_VSIT";
					jsonArray.push(j);
                }
            }
           
            //Rows State가 Deleted로 설정된 Row 삭제
            mainProvider.clearRowStates(true,false);
          
            //실행쿼리 호출
            doAjax2(jsonArray, function(ret){
            	if(ret == "SUCCESS"){
            		alert("정상적으로 삭제하였습니다.");
            	    getPageAction(2);
            	}else{
            		alert("삭제에 실패하였습니다.");
            	}
            });
		   
		   
		   break;
		  }

}

function _setDataValue(obj){
	
	if(popType=="DEPT"){
        mainGrid.setValue(idx, mainProvider.getFieldIndex("bpCode"), obj.nodeCode);
        mainGrid.setValue(idx, mainProvider.getFieldIndex("deptName"), obj.deptName);
        mainGrid.setValue(idx, mainProvider.getFieldIndex("deptCode"), obj.deptCode);
    }else if(popType=="EMP"){
		mainGrid.setValue(idx, mainProvider.getFieldIndex("bpCode"), obj.nodeCode);
		mainGrid.setValue(idx, mainProvider.getFieldIndex("intvUserName"), obj.kname);
		mainGrid.setValue(idx, mainProvider.getFieldIndex("deptName"), obj.deptName);
		mainGrid.setValue(idx, mainProvider.getFieldIndex("deptCode"), obj.deptCode);
		mainGrid.setValue(idx, mainProvider.getFieldIndex("intvUserId"), obj.sno);
		mainGrid.setValue(idx, mainProvider.getFieldIndex("intvUserMail"), obj.email);
		mainGrid.setValue(idx, mainProvider.getFieldIndex("intvUserTel"), obj.officeTel);
	}
}

</script>
</head>

<body>
<div class="wrap">
    <%@ include file="/views/include/top.jsp"%>
    <div class="container">
        <div class="sub_nav">홈 > ${MENU_NAME}</div>
        <div class="content">
            <div class="subtitle_all">
                <div class="subtitle_title">${MENU_NAME}</div>
                <div class="subtitle_btngroup">
                    <a href="javascript:void(0)" class="btn_search" onclick="getPageAction(2)"><span class="btn_search_left">조회</span></a>
                    <a href="javascript:void(0)" class="btn_add"><span class="btn_add_left" onclick="addVisitor()">추가</span></a>
                    <a href="javascript:void(0)" class="btn_delete"><span class="btn_delete_left" onclick="getPageAction(4)">삭제</span></a>
                    <a href="javascript:void(0)" class="btn_check" onclick="getPageAction(3)"><span class="btn_check_left">저장</span></a>
                    <a href="javascript:void(0)" class="btn_download" onclick="getExcelExport()"><span class="btn_download_left">Excel Download</span></a>                                            
                </div>                
            </div>            
            <form id="frm" name="frm">

                <table class="tbl_search">
                    <tr>
                        <td class="tbl_search_title wp10">
                            <select id="sType" name="sType" class="selectbox_search wp90">
                                <option value="sVsitUserNm">출입자명</option>
                                <option value="sVsitRegNo">출입번호</option>
                            </select>
                        </td>
                        <td>
                            <input type="text" id="sTypeNm" name="sTypeNm" class="textbox_search" onkeydown="keyUp(event)"/>
                            <span style="padding-left:20px">
                                <input type="checkbox" id="sInOutStop" name="sInOutStop" class="radiobox_search" onclick="getPageAction(2)"/> 출입정지자 포함
                            </span>
                        </td>
                    </tr>
                </table>
                <div id="grdMain"></div>
                <input type="text" id="x" name="x" style="width:0px;border:0px"/>
            </form>
        </div>
    </div>
</div> 
<%@ include file="/views/include/bottom.jsp"%>
</body>
</html>                   