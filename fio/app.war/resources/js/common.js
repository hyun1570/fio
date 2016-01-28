
/*
//  파일  명   : common.js
//  파일설명   : 공통 JavaScript
//  최초작성일 : 2014-04-11
//  최종수정일 : 2014-04-11
//  Programmer : 박상민
*/

// SKIN
var GRID_SKIN_SKY_BLUE="dhx_skyblue";

// undefined 체크
function isType(sTemp)
{
	if (typeof(sTemp) == "undefined")
	{
		return "";
	}
	else
	{
		return sTemp;
	}
}

// json Null 체크
function jsonNull(jsonObj)
{
	for (i in jsonObj)
	{
		if (jsonObj[i] == null)
		{
			jsonObj[i] = "";
		}
	}
	
	return jsonObj;
}

/**
 * 함수명   : getCommonFromToDateCheck()
 * FuncDesc : 시작일자 종료일자 체크
 * Param    : sDate : 시작일자
 *            eDate : 종료일자
 * Return   :
 * Author   : 박상민
 * History  : 2013-01-07
 */
function getCommonFromToDateCheck(sDate, eDate)
{
    if (sDate == "" && eDate == "")
    {
        return true;
    }

    if (sDate == "" && eDate != "")
    {
        alert("'시작일자'를 입력하여 주십시오.");

        return false;
    }

    if (eDate == "" && sDate != "")
    {
        alert("'종료일자'를 입력하여 주십시오.");

        return false;
    }

    var sDateStr = sDate.replace(/\-/g, '');
    var eDateStr = eDate.replace(/\-/g, '');

    if (sDateStr.length != 8)
    {
        alert("'시작일자'를 확인하여 주십시오.");

        return false;
    }

    if (eDateStr.length != 8)
    {
        alert("'종료일자'를 확인하여 주십시오.");

        return false;
    }

    if (sDateStr > eDateStr)
    {
        alert("'시작일자'와 '종료일자'를 확인하여 주십시오.");

        return false;
    }

    return true;
}


/**
 * 함수명   : setCommonFormatSetting()
 * FuncDesc : 문자열을 원하는 포맷 형태로 반환
 * Param    : sData : 원본문자열
 *            sMask : 지정포맷
 * Return   :
 * Author   : 박상민
 * History  : 2013-01-07
 */
function setCommonFormatSetting(sData, sMask)
{
    var resData = "";
    var i = 0;
    var j = 0;

    if (sData == "") return sData;

    for (i=0; i<sData.length; i++)
    {
        resData = resData + sData.charAt(i);
        j++;

        if (j<sMask.length && sMask.charAt(j) != "#")
        {
            resData = resData + sMask.charAt(j++);
        }
    }

    return resData;
}


/**
 * 함수명   : setCommonCheckAlphaNum()
 * FuncDesc : 영문자, 숫자 입력 체크 
 * Param    :
 * Return   :
 * Author   : 박상민
 * History  : 2013-01-07
 */
function setOnlyAlphaNum(obj)
{
	if (!(event.keyCode >=37 && event.keyCode<=40))
    {
    	obj.value = obj.value.replace(/[^a-z0-9]/gi,'');
    }
}


// 현재 年을 YYYY형식으로 리턴
function getYear()
{
    var nDate = new Date();

    var _year  = nDate.getFullYear();
        
    return String(_year);
}


// 현재 月을 MM형식으로 리턴
function getMonth()
{
    var nDate = new Date();

    var _month = nDate.getMonth() + 1;

    if (String(_month).length == 1)
    {
        _month = "0" + String(_month);
    }

    return String(_month);
}


// 현재 日을 DD형식으로 리턴
function getDay()
{
    var nDate = new Date();

    var _date  = nDate.getDate();

    if (String(_date).length == 1)
    {
        _date  = "0" + String(_date);
    }

    return String(_date);
}

// 현재 시간을 HH형식으로 리턴
function getTimeH()
{
    var nDate = new Date();

    var _date  = nDate.getHours();

    if (String(_date).length == 1)
    {
        _date  = "0" + String(_date);
    }

    return String(_date);
}

// 현재 시간을 MM형식으로 리턴
function getTimeM()
{
    var nDate = new Date();

    var _date  = nDate.getMinutes();

    if (String(_date).length == 1)
    {
        _date  = "0" + String(_date);
    }

    return String(_date);
}

// 현재 시간을 SS형식으로 리턴
function getTimeS()
{
    var nDate = new Date();

    var _date  = nDate.getSeconds();

    if (String(_date).length == 1)
    {
        _date  = "0" + String(_date);
    }

    return String(_date);
}

// 오늘日을 YYYYMMDD형식으로 리턴
function getCommonToDay()
{
    var nDate = new Date();

    var _year  = nDate.getFullYear();
    var _month = nDate.getMonth() + 1;
    var _date  = nDate.getDate();

    if (String(_month).length == 1)
    {
        _month = "0" + String(_month);
    }

    if (String(_date).length == 1)
    {
        _date  = "0" + String(_date);
    }

    return String(_year) + String(_month) + String(_date);
}


// 오늘日을 기준으로 몇일의 전후 날짜 구하기
function getCommonCalcDate(pDate)
{
    var nDate = new Date();
    var rDate = new Date(Date.parse(nDate) + (pDate * 1000 * 60 * 60 * 24));

    var _year  = rDate.getFullYear();
    var _month = rDate.getMonth() + 1;
    var _date  = rDate.getDate();

    if (String(_month).length == 1)
    {
        _month = "0" + String(_month);
    }

    if (String(_date).length == 1)
    {
        _date  = "0" + String(_date);
    }

    return String(_year) + String(_month) + String(_date);
}


// 지정日을 기준으로 몇일의 전후 날짜 구하기
function getCommonAddDate(cDate, pDate)
{
    var sailingTime = pDate;

    var yy = parseInt(cDate.replace(/\-/g, '').substring(0, 4));
    var mm = parseInt(cDate.replace(/\-/g, '').substring(4, 6));
    var dd = parseInt(cDate.replace(/\-/g, '').substring(6, 8));

    d = new Date(yy, mm - 1, parseInt(dd) + parseInt(sailingTime));

    yy = d.getFullYear();
    mm = d.getMonth() + 1;
    mm = (mm < 10) ? '0' + mm : mm;
    dd = d.getDate();
    dd = (dd < 10) ? '0' + dd : dd;

    var sDate = String(yy) + String(mm) + String(dd);

    return sDate;
}

//현재월의 첫번째 일자 구하기
//오늘日을 YYYYMMDD형식으로 리턴
function getCurrFirstDay()
{
  var nDate = new Date();

  var _year  = nDate.getFullYear();
  var _month = nDate.getMonth() + 1;

  if (String(_month).length == 1)
  {
      _month = "0" + String(_month);
  }

  return String(_year) + String(_month) + "01";
}


// 날자범위내의 Week Day를 Count 한다.
function getWeekDays(startDate, endDate)
{
    var result = 0;

    var currentDate = startDate;

    while (currentDate <= endDate)
    {
        var weekDay = currentDate.getDay();

        if(weekDay == 0 || weekDay == 6)
        {
           result++;
        }

        currentDate.setDate(currentDate.getDate()+1);
   }

   return result;
}

/**
 * 시간비교 및 CHECK
 * getCheckStEdDate(시작 시간, 종료 시간)
 * 시작시간 HH:MM
 * 종료시간 HH:MM
 *  
 */

function getCheckStEdDate(sT, eT){

	sT = sT.replace(/\:/g, '');
	eT = eT.replace(/\:/g, '');
	
	if(sT == ""){
		alert("시작시간을 입력하여 주십시오.");
		return false;
	}
	if(eT == ""){
		alert("종료시간을 입력하여 주십시오.");
		return false;
	}

	if(Number(sT) > 2359){
		alert("시작시간 입력이 잘못 되었습니다.");
		return false;
	}
	
	if(Number(eT) > 2359){
		alert("종료시간 입력이 잘못 되었습니다.");
		return false;
	}

	
	if(Number(sT) >= Number(eT) ){
		alert("시작시간이 종료시간보다 크거나 같을 수 없습니다.");
		return false;
	}
	
	return true;
}


// 문자열을 바이트 단위로 계산
String.prototype.byteLength = function()
{
    var l= 0;
    for( var idx=0; idx < this.length; idx++)
    {
        var c = escape(this.charAt(idx));
        if( c.length==1 ) l ++;
        else if( c.indexOf("%u")!=-1 ) l += 2;
        else if( c.indexOf("%")!=-1 ) l += c.length/3;
    }
    return l;
};


// 값을 받아와 FLOOR연산 no가 양수이면 해당하는 소수점 자리수만큼 보여주고 나머지는 버림 no가 음수이면 10^no 에 해당하는 자리수 만큼 보여주고 나머지는 0으로 만듬
String.prototype.floor = function(no)
{
    var mN;

    // 입력된 숫자가 없거나 숫자가 아니면 0을 반환한다.
    if (this == "" || isNaN(this))
    {
        return 0;
    }
    else
    {
        // 차수가 숫자가 아니거나 없으면 소수점자리에서 절삭한다.(0.111 --> 0)
        if(isNaN(no))
        {
            return Math.floor(this);
        }
        else
        {
            mN = 1;
            if(no < 0)
            {
                for(var i = 0 ; i < (no*-1) ; i++)
                {
                   mN = mN * 10;
                }

                return (Math.floor(this / mN))*mN;
            }
            else
            {
                if(this.indexOf(".") > -1)
                {
                    var target = this.split(".");

                    if(target[1] == "")
                    {
                        return target[0];
                    }
                    else
                    {
                        return target[0]+"."+target[1].substring(0,no);
                    }
                }
                else
                {
                    return this;
                }
            }
        }
    }
};


// 값을 받아와 ROUND연산 no가 양수이면 해당하는 소수점 자리수에서 반올림하고 나머지는 버림 no가 음수이면 10^no 에 해당하는 자리수 에서 반올림하고 나머지는 0으로 만듬
String.prototype.round = function(no)
{
    var mN;

    // 입력된 숫자가 없거나 숫자가 아니면 0을 반환한다.
    if (this == "" || isNaN(this))
    {
        return 0;
    }
    else
    {
        mN = 1;

        if (no < 0)
        {
            for(var i = 0 ; i < (no*-1) ; i++)
            {
               mN = mN * 10;
            }

            return (Math.round(this / mN))*mN;
        }
        else
        {
            if (this.indexOf(".") > -1)
            {
                for(var i = 0 ; i < no ; i++)
                {
                   mN = mN * 10;
                }
                return Math.round(eval(this * mN)) / mN;
            }
            else
            {
                return this;
            }
        }
    }
};


// 문자열 숫자를 넘버 포멧으로 변환 String Object에 추가
String.prototype.format = function(l)
{
    var v = this.replace(/\,/g, '');
    var pfix =  v.indexOf(".");
    
    if (pfix > -1)
    {
        var dec = this.split(".");
        var a = dec[0].replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,");
        if (a.length==0) a="0";
        
        if (dec[1].length>l)
        {
            return a + "." + dec[1].substring(0,l);
        }
        else
        {
            return a + "." + dec[1];
        }
    }
    else
    {
        return this.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,");
    }
};


// 문자열 날자를 날자 포멧으로 변환 String Object에 추가
String.prototype.toDate = function()
{
    if (this.toString() == "") return "";
    var d = this.match (/^(\d{4})(0[1-9]|1[0-2])(0[1-9]|[12]\d|3[01])$/);
    return d[1]+"-"+d[2]+"-"+d[3];
};


// 문자열의 특수문자를 제거한다. String Object에 추가
String.prototype.regReplace=function()
{
    var p = /[`~!@#$%^&*_|+=?;:'"<>\{\}\[\]]/gi;
    return this.replace(p,'');
};


//문자를 undefined 나 null 이나 null로 문자가 들어오면 ""으로 반환한다.
function isNullStr(temp){
	if(temp == "undefined" || temp == null || temp == "null" || temp == "NULL"){
		return "";
	}else{
		return temp;
	}
}


/*
 * DDTA000.M05.cmd 멀티 실행 쿼리로 Ajax를 통해 데이타를 전송한다.
 * parameter : Array(Json), callback
 * return : callback
 */
var doAjax = function(jsonArray, callBack)
{
    $.ajax({
        type      : "POST",
        url       : "DDTA000.M05.cmd",
        dataType  : "json",
        data      : {"param" : JSON.stringify(jsonArray)},
        async     : false,
        beforeSend: function(xhr)
        {
            // 전송 전 Code
        },
        success   : function(result)
        {
            if (result == "SUCCESS"){
                alert("명령이 성공적으로 수행 되었습니다.");
            	callBack(2);
            }else{
                alert("명령 수행중 오류가 발생하였습니다.");
            }
        },
        error     : function(e)
        {
            console.log(e);
        }
    });
}


/*
 * DDTA000.M05.cmd 멀티 실행 쿼리로 Ajax를 통해 데이타를 전송한다.
 * parameter : Array(Json), callback
 * return : callback
 */
var doAjax2 = function(jsonArray, callBack)
{
    $.ajax({
        type      : "POST",
        url       : "DDTA000.M05.cmd",
        dataType  : "json",
        data      : {"param" : JSON.stringify(jsonArray)},
        async     : false,
        beforeSend: function(xhr)
        {
            // 전송 전 Code
        },
        success   : function(result)
        {
            callBack(result);
        },
        error     : function(e)
        {
        	callBack(-1);
        }
    });
}


/*
 * 리얼그리드 Cell 렌더링 이미지 리스트
 * 파라메터 : 그리드
 * 
 */
function createImageList(grid) {
    var imgs = new RealGrids.ImageList("images1");
    imgs.rootUrl = "resources/css/themes/icons/";
    imgs.images = [
        "filesave.png",
        "search.png",
        "cancel.png",
        "help.png",
        "print.png",
        "sum.png",
        "icon_Doc.png"
    ];
 
    grid.addImageList(imgs);
};

$(function()
{
	// Html elements외의 Document에서 백스페이스키를 방지한다.
    var rx = /INPUT|SELECT|TEXTAREA/i;

//    $(document).bind("keydown keypress", function(e){
//        if( e.which == 8 ) // 8 == backspace
//        {
//            if(!rx.test(e.target.tagName) || e.target.disabled || e.target.readOnly)
//            {
//                e.preventDefault();
//            }
//        }
//    });
    
	//set date mask to all calendar classes
	$(".calendar").mask("9999-99-99", {completed:function(){
	    var dateMatch = $(this).val();
	
	    if(!dateMatch.match(/^[0-9]{4}\-(0[1-9]|1[012])\-(0[1-9]|[12][0-9]|3[01])/))
	    {
	        alert('올바른 날자 형태가 아닙니다.');
	        $(this).val("");
	        return false;
	    }
	
	    myCalendar.hide();
	
	    }
	});
	
	// When leave textbox occur
	$(".calendar").blur(function(e){
	
	    var dateMatch = $(this).val();
	
	    if (dateMatch.length < 12)
	    {
	        if (!dateMatch.match(/^[0-9]{4}\-(0[1-9]|1[012])\-(0[1-9]|[12][0-9]|3[01])/))
	        {
	          e.preventDefault();
	          // alert('올바른 날자 형태가 아닙니다.');
	          $(this).val("");
	          // $(this).focus();
	          // return false;
	        }
	    }
	});
	
	// 달력 속성을 클릭하면 포지션 설정을 Auto 로 바꿔서 페이지에 맞춰서 나타나도록 처리. 시간 속성 제거
	$(".calendar").click(function(e){
	   myCalendar.setPosition('auto');
	   myCalendar.hideTime();
	});
	/* DHtmlx Window의 경우 팝업을 띄우면 모 윈도우의 스크롤바가 사라지는 현상 발생
	 * Body의 overflow 속성을 Auto 로 변경
	 */
	$('body').css('overflow','auto');
	
	
	
	// 시간 마스크
	
	//set date mask to all calendar classes
	$("._time").mask("99:99", {completed:function(){
			var dateMatch = $(this).val();
	
		    if(!dateMatch.match(/^([0-2][0-9])\:([0-5][0-9])/))
		    {
		    	console.log(dateMatch);
		        alert('올바른 시간 형태가 아닙니다.');
		        $(this).val("");
		        return false;
		    }
	    }
	});
	
	// When leave textbox occur
	$("._time").blur(function(e){
	
	    var dateMatch = $(this).val();
	
	    if (dateMatch.length < 5)
	    {
	    	if(!dateMatch.match(/^([0-2][0-9])\:([0-5][0-9])/))
	        {
	          e.preventDefault();
	          $(this).val("");
	        }
	    }
	});

});



//년도 콤보 셋팅
function setYearCombo(stYear, objName){
	var dt = new Date();
    for(var y = stYear; y <= dt.getFullYear(); y++){
    	if(y == dt.getFullYear()){
    		$("#"+objName).append("<option value='"+y+"' selected='selected'>"+y+"</option>");
    	}else{
    		$("#"+objName).append("<option value='"+y+"'>"+y+"</option>");
    	}
    }
}

// 월 콤보 셋팅
function setMonthCombo(objName){
    var dt = new Date();
    var _m = "";
    for(var m = 1; m <= 12; m++){
        
    	if(m < 10){
    		_m = "0"+m;
    	}else{
    		_m = m;
    	}
    	if(m == (dt.getMonth()+1)){
            
        	$("#"+objName).append("<option value='"+_m+"' selected='selected'>"+_m+"</option>");
        
        }else{
        
        	$("#"+objName).append("<option value='"+_m+"'>"+_m+"</option>");
        }
        
    }
    
}

//Date타입을 String으로 YYYYMMDD로 변경
function getStrFromDate(dt){
	if(dt != null && dt != "null" && dt !=""){
		var nDate = dt;
	
	    var _year  = nDate.getFullYear();
	    var _month = nDate.getMonth() + 1;
	    var _date  = nDate.getDate();
	
	    if (String(_month).length == 1)
	    {
	        _month = "0" + String(_month);
	    }
	
	    if (String(_date).length == 1)
	    {
	        _date  = "0" + String(_date);
	    }
	    return String(_year) + String(_month) + String(_date);
	}else{
		return "";
	}
}



//Date타입을 시간 String으로 HHMISS로 변경
function getTimeStrFromDate(dt){
	
	if(dt != null && dt != "null" && dt !=""){
		var nDate = dt;
		var _h  = nDate.getHours();
	    var _m = nDate.getMinutes();
	    var _s  = nDate.getSeconds();
	
	    if (String(_h).length == 1)
	    {
	        _h = "0" + String(_h);
	    }
	    if (String(_m).length == 1)
	    {
	        _m = "0" + String(_m);
	    }
	
	    if (String(_s).length == 1)
	    {
	        _s  = "0" + String(_s);
	    }

    	return String(_h) + String(_m) + String(_s);
	}else{
		return "";
	}
}

//현재달의 첫째날(일자) 구하기 
function getFirstDay(yyyymmdd, kind){
   var d,d2, s = "";           
   d = new Date(yyyymmdd);             
   d2 = new Date(d.getFullYear(),d.getMonth());                      
   s += d2.getFullYear()+ kind;                       
   s += ((d2.getMonth()+1) < 10 ? '0'+(d2.getMonth()+1):(d2.getMonth()+1)) + kind;    //여기에 꼭 +1이 있어야됨 생략하고 위에다가 +1하면 1월이 0으로 나옴        
   s += d2.getDate() < 10 ? '0'+d2.getDate() : d2.getDate();                   
   return(s);                             
}

//현재달의 마지막날(일자) 구하기
function getLastDay(yyyymmdd, kind){
   var d,d2, s = "";           
   d = new Date(yyyymmdd);             
   d2 = new Date(d.getFullYear(),d.getMonth()+1,"");                      
   s += d2.getFullYear()+ kind;                       
   s += ((d2.getMonth()+1) < 10 ? '0'+(d2.getMonth()+1):(d2.getMonth()+1)) + kind;    //여기에 꼭 +1이 있어야됨 생략하고 위에다가 +1하면 1월이 0으로 나옴        
   s += d2.getDate() < 10 ? '0'+d2.getDate() : d2.getDate();   
   return(s);                             
}


/**
 * Console.log IE8 오류 패치 
 */
var console = window.console || {log:function(a){}};