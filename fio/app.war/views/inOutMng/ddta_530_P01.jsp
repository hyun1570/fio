<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
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

//초기화
$(window).load(function()
{
    var param = <%=URLDecoder.decode(request.getParameter("param"), "UTF-8")%>;
    if(param.sTypeNm){
        frm.sTypeNm.value = decodeURI(param.sTypeNm);
    }
    
    var sc_height = document.body.clientHeight;
    var div_top = document.getElementById("grdMain").offsetTop;

    // 그리드 Object 셋팅
    setGridObject("grdMain", "100%", (sc_height - div_top - 10)+"px");
    frm.sTypeNm.focus();
});

//페이지 Action
function getPopUpPageAction(action)
{
    switch (action)
    {
        case 2 : // 조회
            var jsonObj = {}; 
            jsonObj.sType      = frm.sType.value;
            jsonObj.sTypeNm    = frm.sTypeNm.value;
            jsonObj.sqlid      = "inOutMng.GET_ALL_EMP_LIST";
            //jsonObj.siteCode   = frm.sessionSiteCode.value;
            jsonObj.status     = "Y";
            
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
            
//             if(mainProvider.getRowCount() == 1){
//                 getPopUpPageAction(3);
//             }
            
            break;
            
        case 3 : // 적용
            
            var idx = mainGrid.getCheckedRows();
            var row = mainProvider.getRow(idx);    
        
            // Data 전송
            setEmpReservation(row);
            
            break;
            
        case 9 : // 닫기
        
            parent.wd.close();
        
            break;
    }
}


//Key Up
function keyUp(event)
{
    if (event.keyCode == 13) getPopUpPageAction(2);
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
        
        setEmpReservation(mainProvider.getRow(index.itemIndex));
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
                    {fieldName : "nodeName"},
                    {fieldName : "deptName"},
                    {fieldName : "sno"},
                    {fieldName : "kname"},
                    {fieldName : "dutyRankName"},
                    {fieldName : "email"},
                    {fieldName : "officeTel"},
                    {fieldName : "mobilTel"},
                    {fieldName : "deptCode"},
                    {fieldName : "nodeCode"},
                    {fieldName : "factCode"},
                    {fieldName : "rsvtnNo"}
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
					    fieldName : "nodeName",
					    width     : 100,
					    header    : { text: "사업부" },
					    styles    : { textAlignment: "center" },
					    visible   : true
				   },
                   {
                       fieldName : "deptName",
                       width     : 100,
                       header    : { text: "부서" },
                       styles    : { textAlignment: "center" },
                       visible   : true
                   },
                   {
                       fieldName : "sno",
                       width     : 100,
                       header    : { text: "사원번호" },
                       styles    : { textAlignment: "center" },
                       visible   : false
                   },
                   {
                       fieldName : "kname",
                       width     : 80,
                       header    : { text: "직원명" },
                       styles    : { textAlignment: "center" },
                       visible   : true
                   },
                   {
                       fieldName : "dutyRankName",
                       width     : 60,
                       header    : { text: "직위" },
                       styles    : { textAlignment: "center" },
                       visible   : true
                   },
                   {
                       fieldName : "email",
                       width     : 150,
                       header    : { text: "EMAIL" },
                       styles    : { textAlignment: "center" },
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
                   },
                   {
                       fieldName : "rsvtnNo",
                       width     : 100,
                       header    : { text: "rsvtnNo" },
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
function setEmpReservation(obj)
{
	var jsonArray = [];
	
    var jsonObj = {};
    jsonObj.command	= "C";
    jsonObj.sqlId	= "inOutMng.INS_EMP_VSIT_RSVTN_M";
    
    jsonObj.vsitRsvtnNo = obj.rsvtnNo;

	if('${SESSION_USER_ID}' != "GATE11" ) {
	    jsonObj.bpCode		= 'CC';
	    jsonObj.deptCode	= 'ZH400';
	    jsonObj.deptName	= '광주지원팀';
	    jsonObj.factCode	= 'KF';
	    jsonObj.intvUserId	= '9572950';
	    jsonObj.intvUserTel	= '062-950-8131';
	    jsonObj.intvUserMail= 'jsahn@dwe.co.kr';
	} else {
		//임시
	    jsonObj.bpCode		= 'BD';
	    jsonObj.deptCode	= 'ZH510';
	    jsonObj.deptName	= '부평지원파트';
	    jsonObj.factCode	= 'BD';	
	    jsonObj.intvUserId	= '5130023';
	    jsonObj.intvUserTel	= '032-510-7103';
	    jsonObj.intvUserMail= 'hykim2@dwe.co.kr';

	}
    jsonArray.push(jsonObj);
    
    var jsonD = {};
    jsonD.command       = "C";
    jsonD.sqlId         = "inOutMng.INS_EMP_VSIT_RSVTN_D";
    jsonD.vnum          = '1';
    jsonD.vsitCompName  = obj.nodeName;
    jsonD.vsitUserNm    = obj.kname;
    jsonD.vsitUserTel   = isNullStr(obj.officeTel);
    jsonD.vsitUserMail  = isNullStr(obj.email);
    jsonD.vsitRsvtnNo   = obj.rsvtnNo;
    jsonArray.push(jsonD);
    
    doAjax2(jsonArray, function(ret){
    	if(ret == "SUCCESS"){
	    	parent.getPageAction(2);
	    	alert("정상적으로 저장되었습니다.");
	        getPopUpPageAction(9);
    	}else{
    		alert("저장에 실패하였습니다.");
    	}
    });
}

</script>
</head>
<body>
    <!-- Hidden 객체 Include -->
    <jsp:include page="/views/include/hidden.jsp" flush="false" />
    <jsp:include page="/views/include/session.jsp" flush="false" />
    
    <div class="popup_header">방문 사내직원 등록</div>
    <div class="hspace10"></div>
    <div class="popup_content">
        <form id="frm" name="frm">
        <table class="search_area">
            <tr>
                <td align="left" width="55%"> 
                    <span>
                        <select name="sType" class="selectbox_search" style="width:100px">
                            <option value="userName">사내직원 명</option>
                        </select>
                    </span>
                    <input type="text" id="sTypeNm" name="sTypeNm" class="textbox_search_lmargin" onkeyup="keyUp(event)"/>
                </td>
                <td align="right" width="45%">               
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
