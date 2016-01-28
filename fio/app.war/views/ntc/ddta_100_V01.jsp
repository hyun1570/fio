<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@ include file="/views/include/tag_lib.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>:::::::::::::: ${PAGE_TITLE} ::::::::::::::</title>
<%@ include file="/views/include/css.jsp"%>
<%@ include file="/views/include/common.jsp"%>
<style>
    input[disabled="disabled"]{background:#ffffff;border:none}
    textarea[disabled="disabled"]{background:#ffffff;border:none}
</style>

<script language="javascript">
var mainGrid;
var mainProvider;

//초기화
$(window).load(function()
{
    var jsonObj = {};

    jsonObj.boardId = "<%= request.getParameter("boardId") %>"; // 전달받은 param 값
    jsonObj.sqlid   = "Notice.GET_NOTICE_INFO";
    
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
            frm.boardId.value      = isType(result[0].boardId);         // 게시판ID
            //frm.noticeType.value   = isType(result[0].noticeType);      // 게시판유형
            //frm.languageType.value = isType(result[0].languageType);    // 언어설정
            frm.siteCode.value     = isType(result[0].siteCode);        // 사이트유형
            //frm.status.value       = isType(result[0].status);          // 상태
            frm.title.value        = isType(result[0].title);           // 제목
            frm.contents.value     = isType(result[0].contents);        // 내용
            frm.eMail.value        = isType(result[0].eMail);           // 작성자 이메일
            frm.telNo.value        = isType(result[0].telNo);           // 작성자 전화번호
            frm.regName.value      = isType(result[0].regName);         // 등록자명
            frm.regId.value        = isType(result[0].regId);           // 작성자ID
            
            setHitCount(); // 조회수 Update
        },
        error      : function(e)
        {
            alert("'조회 Error'");
        }
    });
    
    // 그리드 Object 생성
    setGridObject("grdMain", "100%", 120);
    
});

//조회수 Update
function setHitCount()
{
    // 본인 작성글 확인
    if ('${SESSION_USER_ID}' != frm.regId.value)
    {
        var jsonObj = {};
        
        jsonObj.boardId = frm.boardId.value;   // 게시판ID
        jsonObj.sqlid   = "Notice.UPT_NOTICE_HIT_CNT";
        
        $.ajax({
            type       : "POST",
            url        : "DDTA.BASE.SERVICE.U00.cmd",
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
                    
                }
            },
            error      : function(e)
            {
                alert("'카운트 Error'");
            }
        });
    }
}


function getPageAction(action){
	
	switch (action)
    {
    
    	   case 1: // 목록 이동
    	   
    		   $("#frm").attr({
                   action : "DDTA.NTC.L01.cmd",
                   target : "_self",
                   method : "POST"
               });

               $("#frm").submit();
               
    		   break;
    	   
    	   case 2: //첨부파일 조회
    		   var jsonObj = {};

               jsonObj.boardId = frm.boardId.value; // 전달받은 param 값
               jsonObj.sqlid   = "CommonFile.FILE_LIST";
               
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
               
    }
}

//그리드 On Load
RealGrids.onload = function (id)
{
    mainGrid     = new RealGrids.GridView(id);
    mainProvider = new RealGrids.LocalDataProvider();

    mainGrid.setStyles(_notice_grid_style);
    mainGrid.setDataProvider(mainProvider);

    setFields(mainProvider);
    setColumns(mainGrid);
    setOptions(mainGrid);

    
    
    // 그리드 더블클릭 이벤트
    mainGrid.onDataCellDblClicked = function (grid, index)
    {
        if (index.itemIndex < 0) return;

        $("#frm").attr({
            action : "DDTAS00.S02.cmd?fileAttachId="+mainProvider.getRow(index.itemIndex).fileAttachId,
            target : "_self",
            method : "POST"
        });

        $("#frm").submit();
    };

    getPageAction(2); // 파일업로드 조회
};

//그리드 Set Object
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
    swfobject.embedSWF(swfUrl, tagid, width, height, "11.1.0", "/DDEWebShop/resources/objects/expressInstall.swf", flashvars, params, attributes);
};

//그리드 Data 필드 설정
function setFields(provider)
{
    var fields = [
                    {fieldName : "chk"},
                    {fieldName : "fileAttachId"},
                    {fieldName : "boardId"},
                    {fieldName : "origFileName"}
                 ];

    // Field Id를 그리드에 정의 한다.
    if (provider == mainProvider)
    {
        provider.setFields(fields);
    }
}

// 그리드 컬럼 Setting
function setColumns(grid)
{
    var columns = [
                    {
                        fieldName : "chk",
                        width     : 30,
                        header    : { text: " " },
                        styles    : { textAlignment: "center"},
                        renderer  : { type: "check", falseValues: "" },
                        visible   : false,
                        sortable  : false,
                        movable   : false
                    },
                    {
                        fieldName : "fileAttachId",
                        width     : 100,
                        header    : { text: "fileAttachId" },
                        styles    : { textAlignment: "center" },
                        visible   : false
                    },
                    {
                        fieldName : "boardId",
                        width     : 100,
                        header    : { text: "boardId" },
                        styles    : { textAlignment: "center" },
                        visible   : false
                    },
                    {
                        fieldName : "origFileName",
                        width     : 850,
                        header    : { text: "파일명" },
                        styles    : { textAlignment: "left" },
                        visible   : true
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
            visible: false
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
                <input type="hidden" id="boardId" name="boardId"/>
                <input type="hidden" id="siteCode" name="siteCode"/>
                <input type="hidden" id="regId" name="regId"/>
                <div class="subtitle">${MENU_NAME}</div>
                <table class="notice_read">
                    <tr class="underline">
                        <td width="60" class="pl10 text_black12b">작성자</td>
                        <td width="250">
                            <input type="text" id="regName" name="regName" class="notice_noborder" style="width:154px;" disabled="disabled"/>
                        </td>
                        <td width="60" class="pl10 text_black12b">이메일</td>
                        <td width="250">
                            <input type="text" id="eMail" name="eMail" class="notice_noborder" style="width: 154px;" disabled="disabled"/>
                        </td>
                        <td width="60" class="pl10 text_black12b" >전화번호</td>
                        <td width="250">
                            <input type="text" id="telNo" name="telNo" class="notice_noborder" style="width: 154px;" disabled="disabled"/>
                        </td>
                    </tr>
                    <tr  class="underline">
                        <td width="60" class="pl10 text_black12b">제목</td>
                        <td colspan="5">
                            <input type="text"  id="title" name="title"  class="notice_noborder" style="width: 560px;" disabled="disabled"/>
                        </td>
                    </tr>
                    <tr  class="underline">
                        <td width="60" class="pl10 vat text_black12b">본문</td>
                        <td colspan="5">
                            <textarea name="textarea" id="contents" name="contents" class="notice_contents" disabled="disabled"></textarea>
                        </td>
                    </tr>
                    <tr class="hspace6">
                        <td colspan="6"></td>
                    </tr>
                    <tr>
                        <td width="60" class="pl10 vat text_black12b">첨부파일</td>
                        <td colspan="5" style="background: #f5f5f5;">
                            <div id="grdMain" style="width:100%;height:120px"></div>
                        </td>
                    </tr>
                    <tr class="hspace6">
                        <td colspan="6"></td>
                    </tr> 
                </table>
                <table class="form_summit_area">
                    <tr>
                        <td>                
                            <a href="javascript:void(0)" class="btn_gray" onclick="getPageAction(1)"><span class="btn_gray_left">목록</span></a>         
                        </td>
                    </tr>
                </table>            
            </form>               
<!-- 컨텐츠 영역 끝 -->              
        </div>
    </div>
</div>
<%@ include file="/views/include/bottom.jsp"%>
</body>
</html>            