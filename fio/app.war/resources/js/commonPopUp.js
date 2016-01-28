/*
//  파일  명   : commonPopUp.js
//  파일설명   : 공통 PopUp JavaScript
//  최초작성일 : 2014-04-11
//  최종수정일 : 2014-04-11
//  Programmer : 박상민
*/


/**
 * 함수명   : getCommonBasePopUp()
 * FuncDesc : 공용 PopUp
 * Param    : width  : 윈도우 너비
 *            height : 윈도우 높이
 *            title  : 윈도우 제목
 *            action : 실행 Action
 * Return   :
 * Author   : 박상민
 * History  : 2014-04-11
 */
function getCommonBasePopUp(width, height, title, action)
{
    var x = (document.body.clientWidth)  ? (document.body.clientWidth  - width ) / 2 : 0;
    var y = (document.body.clientHeight) ? (document.body.clientHeight - height) / 2 : 0;

    /* Ie 호환성 보기에서 Iframe 생성시 name을 주지 않으면 새로운 Window를 생성하므로 IE 일경우 생성시 이름을 주고 
    	다른 부라우저에서는 에러를 발생 하니 Catch에서 정상정인 iframe을 생성 한다.
     */
    var iframe;
	try {
		iframe = document.createElement('<iframe name="ifr">');
	} catch (ex) {
		iframe = document.createElement('iframe');
	}
    
    iframe.frameBorder = 0;
    iframe.width  = "100%";
    iframe.height = "100%";
    iframe.id     = "ifr";
    iframe.name   = "ifr";

    document.body.appendChild(iframe);

    dhxWins = new dhtmlXWindows();
    

    winId = dhxWins.createWindow("winId", x, y, width, height);
    winId.setText(title);
    winId.attachObject("ifr");
    winId.setModal(true);
    winId.button("minmax1").hide(); // max button hide
    winId.denyResize(); // disable resize
    
    //윈도우를 최상위로 Open
    dhxWins.w["winId"].win.style.zIndex = 9999;
    // modal cover Index를 윈도우 바로 이전으로 설정
    $(".dhxwins_mcover").zIndex(9998);
        
    $("input[name=param]").val("");

    $("#frm").attr({
        action : action,
        target : "ifr",
        method : "POST"
    });

    $("#frm").submit();
}


/**
 * 함수명   : getCommonCodePopUp()
 * FuncDesc : 공통코드 PopUp
 * Param    : masterCode : 조회할 Code의 MasterCode
            : codeType   : 조회할 Code의 참조상위 코드
            : popTitle   : PopUp창 Title
            : popCode    : 리턴할 코드
            : popName    : 리턴할 코드명
 * Return   :
 * Author   : 박상민
 * History  : 2014-04-11
 */
function getCommonCodePopUp(masterCode, codeType, popTitle, popCode, popName)
{
    var width  = 700;
    var height = 450;

    var x = (document.body.clientWidth)  ? (document.body.clientWidth  - width ) / 2 : 0;
    var y = (document.body.clientHeight) ? (document.body.clientHeight - height) / 2 : 0;

    /* Ie 호환성 보기에서 Iframe 생성시 name을 주지 않으면 새로운 Window를 생성하므로 IE 일경우 생성시 이름을 주고 
		다른 부라우저에서는 에러를 발생 하니 Catch에서 정상정인 iframe을 생성 한다.
	 */
	var iframe;
	try {
		iframe = document.createElement('<iframe name="ifr">');
	} catch (ex) {
		iframe = document.createElement('iframe');
	}

    iframe.frameBorder = 0;
    iframe.width  = "100%";
    iframe.height = "100%";
    iframe.id     = "ifr";
    iframe.name   = "ifr";

    document.body.appendChild(iframe);

    dhxWins = new dhtmlXWindows();


    winId = dhxWins.createWindow("winId", x, y, width, height);
    winId.setText(popTitle);
    winId.attachObject("ifr");
    winId.setModal(true);
    winId.button("minmax1").hide(); // max button hide
    winId.denyResize(); // disable resize


    //윈도우를 최상위로 Open
    dhxWins.w["winId"].win.style.zIndex = 9999;
    // modal cover Index를 윈도우 바로 이전으로 설정
    $(".dhxwins_mcover").zIndex(9998);
    
    var jsonObj = {};

    jsonObj.masterCode = masterCode;
    jsonObj.codeType   = codeType;
    jsonObj.popTitle   = popTitle;
    jsonObj.popCode    = popCode;
    jsonObj.popName    = popName;

    frm.param.value = JSON.stringify(jsonObj);

    $("#frm").attr({
        action : "DDWS.ADMIN.COMMONCODE.POPUP.L01.cmd",
        target : "ifr",
        method : "POST"
    });

    $("#frm").submit();
}

/**
* 함수명   : getCommonPopUpWithParam()
* FuncDesc : 공통코드 PopUp
* Param    : _width : Width
           : _height : Height
           : _title : Title
           : _url   : Address
           : _object : Parameter Object
           : _winId  : Window Handle 
* Return   : Window handle
* Author   : 이태종
* History  : 2014-04-23
*/
function getCommonPopUpWithParam(_width,_height,_title,_url,_object,_winId)
{
    var width  = _width;
    var height = _height;

    if(_winId == "" || _winId == null){
    	_winId = "winId";
    }   
    
    var x = (document.body.clientWidth)  ? (document.body.clientWidth  - width ) / 2 : 0;
    var y = (document.body.clientHeight) ? (document.body.clientHeight - height) / 2 : 0;

    var objBody = document.getElementsByTagName("body").item(0);
    var iframe;
    /* Ie 호환성 보기에서 Iframe 생성시 name을 주지 않으면 새로운 Window를 생성하므로 IE 일경우 생성시 이름을 주고 
            다른 부라우저에서는 에러를 발생 하니 Catch에서 정상정인 iframe을 생성 한다.
     */
    try {
      iframe = document.createElement('<iframe name="ifr">');
    } catch (ex) {
      iframe = document.createElement('iframe');
    }

    iframe.id = 'ifr';
    iframe.name = 'ifr';
    iframe.width = "100%";
    iframe.height = "100%";
    iframe.marginHeight = 0;
    iframe.marginWidth = 0;
    iframe.frameBorder = 0;

    objBody.insertBefore(iframe, objBody.firstChild);

    dhxWins = new dhtmlXWindows();

    wd = dhxWins.createWindow(_winId, x, y, width, height);
    wd.setText(_title);
    wd.attachObject("ifr");
    wd.setModal(true);
    wd.button("minmax1").hide(); // max button hide
    wd.denyResize(); //disable resize

    //윈도우를 최상위로 Open
    dhxWins.w[_winId].win.style.zIndex = 9999;
    // modal cover Index를 윈도우 바로 이전으로 설정
    $(".dhxwins_mcover").zIndex(9998);    
    
    if(_object != null || _object != ""){
    	url = (_url+"?param="+JSON.stringify(_object));
    }else{
    	url = _url + "?param=null";
    }
    
    $("#frm").attr({
        action : url,
        target : "ifr",
        method : "POST"
    });

    $("#frm").submit();
    
    return wd;
}