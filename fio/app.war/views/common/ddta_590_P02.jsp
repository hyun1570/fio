<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="java.net.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<%@ include file="/views/include/css.jsp"%>
<%@ include file="/views/include/common.jsp"%>

<script language="javascript">

var jsonObj;
var mainGrid;
var mainProvider;

var param = <%=URLDecoder.decode(request.getParameter("param"), "UTF-8")%>;

//초기화
$(window).load(function()
{
    if(param.sTypeNm){
    	frm.sTypeNm.value = decodeURI(param.sTypeNm);
    }
    
    var sc_height = document.body.clientHeight;
    var div_top = document.getElementById("grdMain").offsetTop;

    // 그리드 Object 셋팅
    setGridObject("grdMain", "100%", (sc_height - div_top - 10)+"px");
    
    jsonObj = {};
    jsonObj.sqlid = "Common.GET_COMM_CODE_INFO";
    jsonObj.hcode = "H140"; //공장코드
//     jsonObj.sNodeCode = "CC";
    jsonObj.sBpCode	= param.sBpCode;
    jsonObj.code = "dcode";
    jsonObj.value = "dname";
    
    // 공장코드 콤보 셋팅
    setComboBySqlIdOptionAll("sFactCode", jsonObj, "전체");
    
    frm.sTypeNm.focus();
});

//페이지 Action
function getPopUpPageAction(action)
{
    switch (action)
    {
        case 2 : // 조회
        	var jsonObj = {}; 
            jsonObj.sType		= frm.sType.value;
            jsonObj.sTypeNm		= frm.sTypeNm.value;
            jsonObj.sqlid		= "Common.USER_Pop";
            jsonObj.status		= "Y";
            jsonObj.sFactCode	= frm.sFactCode.value;
            jsonObj.sBpCode		= param.sBpCode;
            
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
            
            mainGrid.checkRow(0, true, true); // 그리드 선택
            
            if(mainProvider.getRowCount() == 1){
            	getPopUpPageAction(3);
            }
            
            break;
            
        case 3 : // 적용
            
        	var idx = mainGrid.getCheckedRows();
            var row = mainProvider.getRow(idx);    
        
            // Data 전송
            setCommonCodePopUpData(row);
            
            break;
            
        case 9 : // 닫기
        
        	parent.wd.close();
        
            break;
    }
}



// 그리드 On Load
RealGrids.onload = function (id)
{
    mainGrid     = new RealGrids.GridView(id);
    mainProvider = new RealGrids.LocalDataProvider();
    
    mainGrid.setStyles(_grid_style);
    
    mainGrid.setDataProvider(mainProvider); 
    
    setFields(mainProvider);
    setColumns(mainGrid);
    setOptions(mainGrid);
    
    // 그리드 더블클릭 이벤트
    mainGrid.onDataCellDblClicked = function (grid, index)
    {
    	if (index.itemIndex < 0) return;
    	
    	setCommonCodePopUpData(mainProvider.getRow(index.itemIndex));
    };
    
    // 그리드 클릭 이벤트
    mainGrid.onDataCellClicked = function(grid, index)
    {
    	mainGrid.checkRow(index.itemIndex, true, true);
    };
    if($.trim(frm.sTypeNm.value) != ""){
        getPopUpPageAction(2); // 조회
    }
};

// 그리드 Set Object
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
    params.wmode   = "opaque";
    params.allowscriptaccess = "always";
    params.allowfullscreen   = "true";

    var attributes = {};
    
    attributes.id    = tagid;
    attributes.name  = tagid;
    attributes.align = "middle";

    var swfUrl = "resources/objects/RealGridWeb.swf";
    swfobject.embedSWF(swfUrl, tagid, width, height, "11.1.0", "/DDESysAdmin/resources/objects/expressInstall.swf", flashvars, params, attributes);
};

//그리드 Data 필드 설정 
function setFields(provider)
{
    var fields = [
                    {fieldName : "deptName"},
					{fieldName : "kname"},
					{fieldName : "dutyRankName"},
					{fieldName : "email"},
					{fieldName : "officeTel"},
					{fieldName : "mobilTel"},
                    {fieldName : "deptCode"},
                    {fieldName : "sno"},
                    {fieldName : "nodeCode"},
                    {fieldName : "factCode"}
                 ];

    // Field Id를 그리드에 정의 한다.
    if (provider == mainProvider)
    {
        provider.setFields(fields);
    }
}

//그리드 컬럼 Setting
function setColumns(grid)
{
	var columns = [
                   {
                       fieldName : "deptName",
                       width     : 100,
                       header    : { text: "부서" },
                       styles    : { textAlignment: "left" },
                       visible   : true
                   },
                   {
                       fieldName : "kname",
                       width     : 80,
                       header    : { text: "면담자" },
                       styles    : { textAlignment: "left" },
                       visible   : true
                   },
                   {
                       fieldName : "dutyRankName",
                       width     : 100,
                       header    : { text: "직위" },
                       styles    : { textAlignment: "center" },
                       visible   : true
                   },
                   {
                       fieldName : "email",
                       width     : 150,
                       header    : { text: "EMAIL" },
                       styles    : { textAlignment: "left" },
                       visible   : true
                   },
                   {
                       fieldName : "officeTel",
                       width     : 100,
                       header    : { text: "연락처" },
                       styles    : { textAlignment: "center" },
                       visible   : true
                   },
                   {
                       fieldName : "mobilTel",
                       width     : 100,
                       header    : { text: "휴대전화" },
                       styles    : { textAlignment: "center" },
                       visible   : false
                   },
                   {
                       fieldName : "deptCode",
                       width     : 100,
                       header    : { text: "deptCode" },
                       styles    : { textAlignment: "center" },
                       visible   : false
                   },
                   {
                       fieldName : "sno",
                       width     : 100,
                       header    : { text: "sno" },
                       styles    : { textAlignment: "center" },
                       visible   : false
                   },
                   {
                       fieldName : "nodeCode",
                       width     : 100,
                       header    : { text: "nodeCode" },
                       styles    : { textAlignment: "center" },
                       visible   : false
                   },
                   {
                       fieldName : "factCode",
                       width     : 100,
                       header    : { text: "factCode" },
                       styles    : { textAlignment: "center" },
                       visible   : false
                   }
                 ];
    
    if (grid == mainGrid)
    {
        grid.setColumns(columns);
    }
}       

// 그리드 Option 설정
function setOptions(grid)
{
    grid.setOptions(
    {
        panel:
        {
            visible: false
        },
        footer:
        {
            visible: false
        },
        checkBar:
        {
        	visible: false,
            exclusive:false
        },
        statusBar:
        {
            visible: false
        },
        edit:
        {
            insertable : false,
            appendable : false,
            updatable  : false,
            deletable  : false,
            deleteRowsConfirm : false,
            deleteRowsMessage : "Are you sure?"          
        },
        select:
        {
            style: RealGrids.SelectionStyle.ROWS
        }
    });
}

//Data 전송
function setCommonCodePopUpData(obj)
{

    parent._setDataValue(obj);
    
    
    getPopUpPageAction(9);
}

$(document).ready(function(event){
	$("#sTypeNm").keydown(function(event){
		if(event.keyCode == 13){
			getPopUpPageAction(2);
		}
	});
})

</script>
</head>
<body>
    <!-- Hidden 객체 Include -->
    <jsp:include page="/views/include/hidden.jsp" flush="false" />
    <jsp:include page="/views/include/session.jsp" flush="false" />
    
    <div class="popup_header">면담자</div>
    <div class="hspace10"></div>
    <div class="popup_content">
        <form id="frm" name="frm">
        <table class="search_area">
            <tr>
                <td>
                    공장명
                </td>
                <td>
                    <select id="sFactCode" name="sFactCode">
                        <option value=""></option>
                    </select> 
                </td>
	            <td class="text_addstar">
	               <input type="hidden" id="sType" name="sType" value="userName"/> 
	               면담자명
                </td>
                <td>	                
	                <input type="text" id="sTypeNm" name="sTypeNm" class="textbox_search_lmargin w80"/>
	            </td>
	            <td align="right">               
                    <a href="javascript:void(0)" onclick="getPopUpPageAction(2)" class="btn_search"><span class="btn_search_left">조회</span></a>
                    <a href="javascript:void(0)" onclick="getPopUpPageAction(3)" class="btn_check"><span class="btn_check_left">적용</span></a>
                </td>
            </tr>
        </table>
        <div style="width:100%; height:200px; background: #f7f7f7; text-align:center">
            <div id="grdMain"></div>
        </div>
        <input type="text" id="x" name="x" style="width:0px;height:0px;border:0px"/>
        </form>        
    </div>
</body>
</html>
