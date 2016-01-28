<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@ include file="/views/include/tag_lib.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 
<title>:::::::::::: ${PAGE_TITLE} ::::::::::::</title>
<%@ include file="/views/include/css.jsp"%>
<%@ include file="/views/include/common.jsp"%>
<link rel="STYLESHEET" type="text/css" href="<%=request.getContextPath()%>/resources/CLEditor1_4_4/jquery.cleditor.css"/>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/CLEditor1_4_4/jquery.cleditor.min.js"></script>
<script language="javascript">
var boardId = "";
var mainGrid;
var mainProvider;

//초기화
$(window).load(function()
{
    frm.regName.value = '${SESSION_USER_NAME}';
    frm.eMail.value   = '${SESSION_EMAIL}';
    frm.telNo.value   = '${SESSION_TEL_NO}';

    boardId = '${SESSION_USER_ID}' + getYear() + getMonth() + getDay() + getTimeH() + getTimeM() + getTimeS(); // 반입일시(시간)

    setInitCombo(); // 콤보박스 초기화

    $("#contents").cleditor();
    
    // 그리드 Object 생성
    setGridObject("grdMain", "100%", 120);

    $("#eMail").emailAddress();
    $("#telNo").PhoneNumber();
    
    
    frm.title.focus();
});

//Write Lock 설정
function setWriteLock()
{
    // 본인 작성글 확인
    if ('${SESSION_USER_CLASS}' != '10')
    {
        document.getElementById("saveBtn").style.display = "none"; // 저장 버튼 Hidden
        document.getElementById("fileUpBtn").style.display = "none"; // 저장 버튼 Hidden        
    }
}

// 콤보박스 초기화
function setInitCombo()
{
    // 공지유형
    var jsonObj2 = {sqlid : "Common.GET_COMMON_D_LIST", sSiteCode : '10001', masCode : "NOTICE_TYPE", code : "code", value : "codeName", dUseYn:"Y"};

    setComboBySqlId("noticeType", jsonObj2);
    
    // 언어설정
    var jsonObj3 = {sqlid : "Common.GET_COMMON_D_LIST", sSiteCode : '10001', masCode : "LANGUAGE_TYPE", code : "code", value : "codeName", dUseYn:"Y"};

    setComboBySqlId("languageType", jsonObj3);
}

// 페이지 Action
function getPageAction(action)
{
    switch (action)
    {
        case 1 : // 목록

            $("#frm").attr({
                action : "DDTA.NTC.L01.cmd",
                target : "_self",
                method : "POST"
            });

            $("#frm").submit();

            break;

        case 3 : // 등록

            if (getValidation() == false) break;

            if (confirm("'공지사항'을 '등록' 하시겠습니까?") == false) return;

            var jsonObj = {};

            jsonObj.boardId         = boardId;                      // 공지사항ID
            jsonObj.boardType       = "NOTICE";                     // 게시판유형
            jsonObj.siteCode        = frm.siteCode.value;           // 사이트코드
            jsonObj.branchCode      = "";                           // 지점코드
            jsonObj.noticeType      = frm.noticeType.value;         // 공지유형
            jsonObj.languageType    = frm.languageType.value;       // 언어설정
            jsonObj.topViewYn       = "";                           // 상단노출여부
            jsonObj.title           = $.trim(frm.title.value);      // 제목
            jsonObj.contents        = $.trim(frm.contents.value);   // 내용
            jsonObj.hitCount        = "0";                          // 조회수
            jsonObj.eMail           = frm.eMail.value;              // 작성자 이메일
            jsonObj.telNo           = frm.telNo.value;              // 작성자 전화번호
            jsonObj.topViewYn       = "";                           // 상단노출여부
            jsonObj.password        = "";                           // 작성 비밀번호
            jsonObj.replyRefBoardId = "";                           // 답변글 참조ID
            jsonObj.replyDepth      = "";                           // 답변글 깊이
            jsonObj.replyOrder      = "";                           // 답변글 순차번호
            jsonObj.status          = frm.status.value;             // 상태
            jsonObj.regId           = '${SESSION_USER_ID}';
            jsonObj.modId           = '${SESSION_USER_ID}';
            jsonObj.sqlid           = "Notice.INS_NOTICE";

            $.ajax({
                type       : "POST",
                url        : "DDTA.BASE.SERVICE.C00.cmd",
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
                        alert("정상적으로 '등록' 되었습니다.");

                        getPageAction(1); // 목록
                    }
                },
                error      : function(e)
                {
                    alert("'등록 Error'");
                }
            });

            break;
    }
}

function getAttachAction(action){
	
    switch(action){         
            
        case 2 : // 파일 업로드 조회

	        var jsonObj = {};
	
	        jsonObj.boardId = boardId; // 전달받은 param 값
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
	        
	    case 3 : // 파일업로드
	
            //파일 팝업 파라메터
            var obj = {
                    ref1 : '${SESSION_USER_ID}',
                    boardId : boardId
            };
            
            winId = getCommonPopUpWithParam(700,400,'Attach / Download File','DDTAS00.P01.cmd',obj,'winId');

            break;
        
        case 4 : // 파일 삭제
            
            var rows = mainGrid.getCheckedRows();            
            rows = String(rows);
            
            if (rows.length == 0)
            {
                alert("삭제할 '파일'을 선택하여 주십시오.");
                return;
            }

            if (confirm("'파일'을 '삭제' 하시겠습니까?") == false) return;

            var rowsData = rows.split(",");
            var iLength = rowsData.length;
            var rtn = "F";

            for (var i=0; i<iLength; i++)
            {
                $.ajax({
                    type       : "POST",
                    url        : "DDTAS00.S03.cmd",
                    dataType   : "json",
                    data       : {"fileAttachId" : mainProvider.getRow(rowsData[i]).fileAttachId},
                    async      : false,
                    beforeSend : function(xhr)
                    {
                        // 전송 전 Code
                    },
                    success    : function(result)
                    {
                       if(result=="SUCCESS")
                       {
                           rtn = "S";
                       }
                       else 
                       {
                           rtn = "F";
                       }
                    },
                    error      : function(e)
                    {
                        alert(e.responseText);
                    }
                });
            }
            
            if(rtn == "S")
            {
                alert("정상적으로 '삭제' 되었습니다.");

                getAttachAction(2); // 조회
            }
            else 
            {
                alert('파일삭제중 오류가 발생 하였습니다.');   
            }

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

//그리드 컬럼 Setting
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
                        width     : 825,
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

//그리드 Option 설정
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
            visible: true
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

// 필수 입력 체크
function getValidation()
{
    if (frm.eMail.value == "")
    {
        alert("'이메일'을 입력하여 주십시오.");
        frm.eMail.focus();
        return false;
    }
    
    if(getStringByteLen(frm.eMail.value) > 50)
    {
        alert("'이메일'은 50글자를 초과 하여 입력할 수 없습니다.");
        frm.eMail.focus();
        return false;
    }
    
    if (frm.telNo.value == "")
    {
        alert("'전화번호'를 입력하여 주십시오.");
        frm.telNo.focus();
        return false;
    }
    
    if(getStringByteLen(frm.telNo.value) > 20)
    {
        alert("'전화번호'는 20글자를 초과 하여 입력할 수 없습니다.");
        frm.telNo.focus();
        return false;
    }
    
    if (frm.title.value == "")
    {
        alert("'제목'을 입력하여 주십시오.");
        frm.title.focus();
        return false;
    }
    
    if(getStringByteLen(frm.title.value) > 500)
    {
        alert("'제목'은 500글자를 초과 하여 입력할 수 없습니다.");
        frm.title.focus();
        return false;
    }

    if (frm.contents.value == "")
    {
        alert("'본문'을 입력하여 주십시오.");
        frm.contents.focus();
        return false;
    }
    
    if(getStringByteLen(frm.contents.value) > 4000)
    {
        alert("'본문'은 500글자를 초과 하여 입력할 수 없습니다.");
        frm.contents.focus();
        return false;
    }

    return true;
}


//입력 항목 byte check
function getStringByteLen(str)
{
    var stringByteLength = 0;
    stringByteLength = str.replace(/[\0-\x7f]|(0-\u07ff]|(.))/g,"$&$1$2").length;
    
    return stringByteLength; 
}

function getParentFileList()
{
	getAttachAction(2); // 조회
}
</script>

</head>

<body>
<div class="wrap" >
    <%@ include file="/views/include/top.jsp"%>
    <div class="container">
        <div class="sub_nav" class="navigation">홈  >  ${MENU_NAME}</div>        
        <div class="subtitle">${MENU_NAME}</div>        
        <div class="content">
            <form id="frm" name="frm">
            <!-- Hidden 객체 Include -->
                <table class="form_notice">
	                <tr style="height:4px !important;">
	                    <td colspan="6"></td>
	                </tr>
                    <tr>
	                    <td width="60" class="pl10 text_black12b">사이트</td>
	                    <td width="250">
	                       <select id="siteCode" name="siteCode" class="selectbox_form ml2 wp95" style="background:#f7f7f7;">
	                           <option value="${SESSION_SITE_CODE}" selected="selected">근태관리</option>
                           </select>
                        </td>
	                    <td width="60" class="pl10 text_black12b">공지유형</td>
	                    <td width="250">
                            <select id="noticeType" name="noticeType"  class="selectbox_form ml2" style="width:55%"></select>
                            <select name="status" id="status" class="selectbox_form ml5" style="width:40%">
                                <option value="Y">사용</option>
                                <option value="N">미사용</option>
                            </select>
                        </td>                    
                        </td>
                        <td width="60" class="pl10 text_black12b">언어설정</td>
                        <td width="250">
                            <select id="languageType" name="languageType" class="selectbox_form ml2" style="width:97%"></select>
                        </td>
	                </tr>
	                <tr>
	                    <td width="60" class="pl10 text_black12b">작성자</td>
	                    <td width="250">
	                       <input type="hidden" id="regId" name="regId" value="${SESSION_USER_ID}"/>
	                       <input type="hidden" id="modId" name="modId" value="${SESSION_USER_ID}"/>
	                       <input type="text" id="regName" name="regName" class="textbox_intd ml2" style="width:92%" readonly="readonly"/>
	                    </td>
	                    <td width="60" class="pl10 text_black12b">
	                       <span class="text_addstar">이메일</span>
                        </td>
	                    <td width="250">
	                       <input type="text" id="eMail" name="eMail" class="textbox_intd ml2 wp95" />
	                    </td>
	                    <td width="60" class="pl10 text_black12b">
	                       <span class="text_addstar">전화번호</span>
                        </td>
	                    <td width="250">
	                       <input type="text" id="telNo" name="telNo" class="textbox_intd ml2" style="width:93%"/>
                        </td>
	                </tr>
	                <tr>
	                    <td width="60" class="pl10 text_black12b">
	                       <span class="text_addstar">제목</span>
                        </td>
	                    <td colspan="5"><input type="text" id="title" name="title" class="textbox_intd" style="width:98%"/></td>
	                </tr>
	                <tr class="hspace3">
	                    <td colspan="6" ></td>
	                </tr>
	                <tr>
	                    <td width="60" class="pl10 vat text_black12b">
	                       <span class="text_addstar">본문</span>
                        </td>
	                    <td colspan="5" style="padding-left:2px;">
	                       <div style="background:url(css/images/img_ex03.gif); width:888px;height:273px;">
	                       <textarea id="contents" name="contents" style="width:99%;height:270px" ></textarea>
	                       </div>
                        </td>
	                </tr>
	                <tr class="hspace6">
	                    <td colspan="6"></td>
	                </tr>
	                <tr>
	                    <td width="60" class="pl10 vat text_black12b">파일첨부</td>
	                    <td colspan="5" style="padding-left:2px;">
	                        <table class="attachfile" >
	                          <tr>
	                            <td class="attachfile_btn_area">
	                                <a href="javascript:void(0)" class="btn_intd_attach mb4" onclick="getAttachAction(3)"><span class="btn_intd_attach_left">파일업로드</span></a>
	                                <a href="javascript:void(0)" class="btn_intd_deletefile mb4" onclick="getAttachAction(4)"><span class="btn_intd_deletefile_left">파일삭제</span></a></td>
	                          </tr>
	                          <tr>
	                            <td height="73" style="background: #f5f5f5;">
                                    <div style="width:100%;">
                                        <div id="grdMain"></div>
                                    </div>
	                            </td>
	                          </tr>
	                        </table>
	                    </td>
	                </tr>
	                <tr class="hspace6">
	                    <td colspan="6"></td>
	                </tr> 
	            </table>
	            <table class="form_summit_area">
	                <tr><td>                
	                    <a href="javascript:void(0)" class="btn_gray" onclick="getPageAction(1)"><span class="btn_gray_left">목록</span></a>         
	                    <a href="javascript:void(0)" class="btn_gray" onclick="getPageAction(3)"><span class="btn_gray_left">저장</span></a>                                         
	                </td></tr>
	            </table>            
            </form>
        </div> <!-- content -->
    </div> <!-- container -->
</div><!-- wrap -->

<%@ include file="/views/include/bottom.jsp"%>
</body>
</html>
            