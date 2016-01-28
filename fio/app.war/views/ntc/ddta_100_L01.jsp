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

$(function () {
    $("#btnPage").click(btnPageClickHandler);
    $("#btnFirst").click(btnFirstClickHandler);
    $("#btnPrev").click(btnPrevClickHandler);
    $("#btnNext").click(btnNextClickHandler);
    $("#btnLast").click(btnLastClickHandler);
});

//초기화
$(window).load(function()
{
    // 그리드 Object 생성
    var sc_height = document.body.clientHeight;
    var div_top = document.getElementById("grdMain").offsetTop;
    // 그리드 Object 셋팅
    setGridObject("grdMain", 940, (sc_height - div_top - 200)+"px");

    frm.sTypeNm.focus();
});

//페이지 Action
function getPageAction(action)
{
    switch (action)
    {
        case 2 : // 조회

            var jsonObj = {};
        
            jsonObj.sqlid      = "Notice.GET_NOTICE_LIST";
            jsonObj.status     = "Y";
            jsonObj.sType      = frm.sType.value;
            jsonObj.sTypeNm    = frm.sTypeNm.value;
            jsonObj.noticeType = '${SESSION_USER_TYPE}';
            jsonObj.userClass  = '${SESSION_USER_CLASS}';
            jsonObj.bbsType    = 'NOTICE';
            jsonObj.siteCode   = '${SESSION_SITE_CODE}';

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

        case 3 : // 등록

            $("#frm").attr({
                action : "DDTA.NTC.E01.cmd",
                target : "_self",
                method : "POST"
            });

            $("#frm").submit();

            break;

        case 4 : // 삭제

            var rows = mainGrid.getCheckedRows();
            rows = String(rows);

            if (rows.length == 0)
            {
                alert("삭제할 '공지사항'을 선택하여 주십시오.");
                return;
            }

            if (confirm("'공지사항'을 '삭제' 하시겠습니까?") == false) return;

            var rowsData = rows.split(",");
            var iLength = rowsData.length;
            var rtn = "F";

            for (var i=0; i<iLength; i++)
            {
                var jsonObj = {};
                
                jsonObj.boardId = mainProvider.getRow(rowsData[i]).bbsId;
                jsonObj.sqlid   = "Notice.DEL_NOTICE";

                $.ajax({
                    type       : "POST",
                    url        : "DDTA.BASE.SERVICE.D00.cmd",
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
                            rtn = "S";
                        }
                    },
                    error      : function(e)
                    {
                        rtn = "F";                      
                    }
                });
                
                delNoticeFile(mainProvider.getRow(rowsData[i]).bbsId);    // 파일 삭제
            }
            
            if(rtn == "S")
            {   
                alert("정상적으로 '삭제' 되었습니다.");
                
                getPageAction(2); // 조회
            }
            else 
            {
                alert("'삭제 Error'");
            }

            break;
    }
}

//파일 삭제
function delNoticeFile(boardId)
{   
    $.ajax({
        type       : "POST",
        url        : "DDTA.BASE.SERVICE.S04.cmd",
        dataType   : "json",
        data       : {"boardId" : boardId},
        async      : false,
        beforeSend : function(xhr)
        {
            // 전송 전 Code
        },
        success    : function(result)
        {
            if (result == "SUCCESS")
            {
                
            }
        },
        error      : function(e)
        {
                                  
        }
    });    
}

// Key Up
function keyUp()
{
    if (event.keyCode == 13) getPageAction(2);
}

// 그리드 On Load
RealGrids.onload = function (id)
{
    mainGrid     = new RealGrids.GridView(id);
    mainProvider = new RealGrids.LocalDataProvider();
    
    mainGrid.setStyles(_notice_grid_style);
    
    mainGrid.setDataProvider(mainProvider);

    setColumns(mainProvider, mainGrid);
    setOptions(mainGrid);

    // 그리드 더블클릭 이벤트
    mainGrid.onDataCellDblClicked = function (grid, index)
    {
        frm.boardId.value = mainProvider.getRow(index.dataRow).bbsId;
        
        //일반용
        //var url = "DDTA.NTC.V01.cmd";
        //관리자용
        var url = "DDTA.NTC.M01.cmd";
        
        $("#frm").attr({
            action : url,
            target : "_self",
            method : "POST"
        });

        $("#frm").submit();
    };

    //getPageAction(2); // 조회
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

// 그리드 컬럼 Setting
function setColumns(provider, grid)
{
    var columnArray = [];
    var g    = JSON.parse(_gridList);
    
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

        // 데이트형
        if(g[i].a.columnType == "dt" || g[i].a.columnType == "rodt"){
        	obj.dataType = "datetime";
            obj.datetimeFormat = "yyyyMMdd";
            obj.styles = {"textAlignment" : g[i].a.align,
                    "datetimeFormat" : "yyyy-MM-dd"};
            obj.editor = {"datetimeFormat" : "yyyy-MM-dd",maxLength : g[i].a.maxLength=='undefined'?300:g[i].a.maxLength};
            if(g[i].a.columnType == "rodt"){
                obj.readOnly = true;
            }
        }
        // 시간
        else if(g[i].a.columnType == "tm" || g[i].a.columnType == "rotm"){
        	obj.dataType = "datetime";
            obj.datetimeFormat = "HHmm";
            obj.styles = {"textAlignment" : g[i].a.align,"datetimeFormat" : "HH:mm:ss"};
            obj.editor = {"datetimeFormat" : "HHmmss",maxLength : g[i].a.maxLength=='undefined'?300:g[i].a.maxLength};

            if(g[i].a.columnType == "rotm"){
                obj.readOnly = true;
            }
        }
        //숫자
        else if(g[i].a.columnType == "no" || g[i].a.columnType == "rono"){
            obj.dataType = "numeric";
            obj.styles={
                     "textAlignment": g[i].a.align,
                     "numberFormat": "#,###"
            };
            obj.editor = {"type":"number", maxLength : g[i].a.maxLength=='undefined'?300:g[i].a.maxLength, positiveOnly:true, integerOnly:true};
            
            if(g[i].a.columnType == "rono"){
                obj.readOnly = true;
            }
        }

        columnArray.push(obj);
    }

    // Field Id를 그리드에 정의 한다.
    if (provider == mainProvider)
    {
        provider.setFields(columnArray);
    }

    // 그리드에 컬럼셋을 설정한다.
    if (grid == mainGrid)
    {
        grid.setColumns(columnArray);
    }
}

//그리드 Option 설정
function setOptions(grid)
{
    grid.setOptions(
    {
    	header:{
            height:"30"
        },
        display:{
            rowHeight:"30"
        },
        panel :
        {
            visible : false
        },
        footer :
        {
            visible : false
        },
        checkBar :
        {
            visible : true
        },
        statusBar :
        {
            visible : false
        },
        edit :
        {
            insertable : false,
            appendable : false,
            updatable  : false,
            deletable  : false,
            deleteRowsConfirm : false,
            deleteRowsMessage : "Are you sure?"
        },
        select :
        {
            style : RealGrids.SelectionStyle.ROWS
        }
    });
    
    initPaging();
}

function initPaging() { 
	
	getPageAction(2); // 조회
 
    // paging initialization
    var paging = true;  // Paging 여부
    var pageSize = 13;  // 한페이지에 들어갈 데이터의 양
    var count = mainProvider.getRowCount(); // 총 데이터 갯수
    var pageCount = Math.floor(count / 13) + 1; // 페이지 갯수
    mainGrid.setPaging(paging, pageSize, pageCount);
    
    setPage(0);
}

function setPage(page) {
	
	getPageAction(2);
	
	//grid page setting
    var count = mainGrid.getPageCount();    
    page = Math.max(0, Math.min(page, count - 1));     
    mainGrid.setPage(page);    
    
    // page number show 
    var pageNumbers = 13; // 보여질 페이지의 갯수 1~10
    var displayPage = parseInt(page) + 1;
    var startPage = Math.floor(page / pageNumbers) * pageNumbers + 1;    
    var endPage = startPage + 9;
    endPage = Math.min(endPage, mainGrid.getPageCount());    
    
    $("#pageNumbers").empty();
    for (var i = startPage; i <= endPage; i++) {
        if (i == displayPage) { //current page
            $("#pageNumbers").append("<span class='pg_currentpage ml10'>" + i + "</span>");
        } else {
            $("#pageNumbers").append("<span class='pg_pagenumber ml10' onclick='btnPageNumClickHandler(this)'  style='cursor:pointer;'>" + i + "</span>");
        }
    }
}

function btnPageNumClickHandler(obj) {
    var page = parseInt($(obj).text())-1;
    setPage(page);
}
 
function btnPageClickHandler(e) {
    var page = parseInt($("#txtPage").val())-1;
    setPage(page);
}
 
function btnFirstClickHandler(e) {
    setPage(0);
}
 
function btnPrevClickHandler(e) {

    var page = mainGrid.getPage();
    setPage(page - 1);
}
 
function btnNextClickHandler(e) {
    var page = mainGrid.getPage();
    setPage(page + 1);
}
 
function btnLastClickHandler(e) {
    var count = mainGrid.getPageCount();
    setPage(count - 1);
}

</script>

</head>

<body>
<div class="wrap">
    <%@ include file="/views/include/top.jsp"%>
    <div class="container">
        <div class="sub_nav">홈 > ${MENU_NAME}</div>
        <div class="content">
<!-- 컨텐츠 영역 시작 -->
            <form id="frm" name="frm">
                <input type="hidden" id="boardId"  name="boardId"/>
                <div class="subtitle_all" style="width:940px">
                    <div class="subtitle_title">${MENU_NAME}</div>
                    <div class="subtitle_btngroup">
                        <a href="javascript:void(0)" class="btn_search" onclick="getPageAction(2)"><span class="btn_search_left">조회</span></a>
                        <a href="javascript:void(0)" class="btn_add" onclick="getPageAction(3)"><span class="btn_add_left" onclick="">등록</span></a>
                        <a href="javascript:void(0)" class="btn_delete"><span class="btn_delete_left" onclick="getPageAction(4)">삭제</span></a>
                    </div>
                </div>
                <div style="width:940px">
	                <table class="tbl_search">
		                <tr>
		                    <td width="10%" class="tbl_search_title">
		                        <select name="sType" class="selectbox_search wp85" onchange="focusMove()">
		                            <option value="title">제목</option>
		                            <option value="content">내용</option>
		                            <option value="regName">작성자명</option>
		                        </select>
		                    </td>
		                    <td width="90%">
		                        <input type="text" id="sTypeNm" name="sTypeNm" class="textbox_search w200" onkeyup="keyUp()" />
		                    </td>
		                </tr>
	                </table>
                </div>
                <div id="grdMain"></div>
            </form>    
                <div style="width:940px;margin-top:10px;text-align:center">
	                <input id="txtPageSize" type="hidden" style="text-align:right" value="10"></input>          
	                <input id="btnFirst" class="btn_align" type="image" src="<%=request.getContextPath()%>/resources/css/images/btn_paging_first.gif" alt="First"></input>
	                <input id="btnPrev" class="btn_align" type="image" src="<%=request.getContextPath()%>/resources/css/images/btn_paging_prev.gif" alt="<"></input>
                    <div id="pageNumbers" style="display: inline-block; white-space: nowrap;"></div>                
	                <input class="textbox_paging" id="txtPage" type="text" size="4" maxlength="4" style="text-align:right" value="1"></input>
	                <input id="btnPage" class="btn_align" type="image" src="<%=request.getContextPath()%>/resources/css/images/btn_paging_go.gif" alt="Go"></input>
	                <input id="btnNext" class="btn_align" type="image" src="<%=request.getContextPath()%>/resources/css/images/btn_paging_next.gif" alt=">"></input>
	                <input id="btnLast" class="btn_align" type="image" src="<%=request.getContextPath()%>/resources/css/images/btn_paging_last.gif" alt="Last"></input>
                </div>
                
            
<!-- 컨텐츠 영역 끝 -->              
        </div>
    </div>
</div>
<%@ include file="/views/include/bottom.jsp"%>
</body>
</html>   