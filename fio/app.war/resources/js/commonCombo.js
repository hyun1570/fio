
/*
//  파일  명   : commonCombo.js
//  파일설명   : 공통 Combo JavaScript
//  최초작성일 : 2014-04-11
//  최종수정일 : 2014-04-11
//  Programmer : 이태종
*/

// 지정한 Sql idfh Combo 의 Element 값을 설정 한다.

function setComboBySqlId(comboId, object, blankYn)
{
    $.ajax({
        type      : "POST",
        url       : "DDTA.BASE.SERVICE.R00.cmd",
        dataType  : "json",
        data      : {"param" : JSON.stringify(object)},
        async     : false,        
        success   : function(result)
        {   
            var combo = $('#' + comboId);

            $('option', combo).remove(); // 콤보 Remove
            if(blankYn == "Y"){
            	combo.append('<option value="">선택</option>');
            }
            
            for (var i=0; i<result.length; i++)
            {  
            	//옵션이 없을 경우 Code로 정의된 부분만 리턴
            	if (object.ex==='undefined') 
            	{
	                // 콤보 Append
	                combo.append('<option value="' + result[i][object.code] + '">' + result[i][object.value] +'</option>');
            	}
            	else 
            	{
            		// ex로 정의 된 element 포함 attribute : extra
	                combo.append('<option value="' + result[i][object.code] + '" extra="'+result[i][object.ex]+'">' + result[i][object.value] +'</option>');
            	}
                
            }
        },
        error     : function()
        {
            // Error 발생 Code
        }
    });    
}

//지정한 Sql id로 Combo 의 Element 값을 설정 한다.
function setComboBySqlIdNonAll(comboId, object)
{
    $.ajax({
        type      : "POST",
        url       : "DDTA.BASE.SERVICE.R00.cmd",
        dataType  : "json",
        data      : {"param" : JSON.stringify(object)},
        async     : false,        
        success   : function(result)
        {   
            var combo = $('#' + comboId);

            $('option', combo).remove(); // 콤보 Remove
  
            for (var i=0; i<result.length; i++)
            {  
            	//옵션이 없을 경우 Code로 정의된 부분만 리턴
            	if (object.ex==='undefined') 
            	{
	                // 콤보 Append
	                combo.append('<option value="' + result[i][object.code] + '">' + result[i][object.value] +'</option>');
            	}
            	else 
            	{
            		// ex로 정의 된 element 포함 attribute : extra
	                combo.append('<option value="' + result[i][object.code] + '" extra="'+result[i][object.ex]+'">' + result[i][object.value] +'</option>');
            	}
                
            }
        },
        error     : function()
        {
            // Error 발생 Code
        }
    });    
}

//지정한 Sql id로 Combo 의 Element 값을 설정 한다. 전체 선택여부 
function setComboBySqlIdOptionAll(comboId, object, allName)
{
    $.ajax({
        type      : "POST",
        url       : "DDTA.BASE.SERVICE.R00.cmd",
        dataType  : "json",
        data      : {"param" : JSON.stringify(object)},
        async     : false,        
        success   : function(result)
        {   
        	var combo = $('#' + comboId);

            $('option', combo).remove(); // 콤보 Remove
            
            if(isNullStr(allName) != ""){
            	combo.append("<option value=''>"+allName+"</option>");
            }
            
  
            for (var i=0; i<result.length; i++)
            {  
            	//옵션이 없을 경우 Code로 정의된 부분만 리턴
            	if (object.ex==='undefined') 
            	{
	                // 콤보 Append
	                combo.append('<option value="' + result[i][object.code] + '">' + result[i][object.value] +'</option>');
            	}
            	else 
            	{
            		// ex로 정의 된 element 포함 attribute : extra
	                combo.append('<option value="' + result[i][object.code] + '" extra="'+result[i][object.ex]+'">' + result[i][object.value] +'</option>');
            	}
                
            }
        },
        error     : function()
        {
            // Error 발생 Code
        }
    });    
}

/*
   멀티컬럼 콤보 생성
   ID    : elements Id
   data : Json Data Object
   obj   : 개체 매핑 데이타 Object
            value             : 콤보의 Value 지정 컬럼
            text               : 콤보의 Text 지정 컬럼
            label(optional)  : 첫번째 컬럼에 나타날 데이타 Value 값과 다름 
*/
function setMultiColumnCombo(id,data,obj)
{
	var _cb = $("#"+id);
	_cb.css({"width":obj.width});
	
	$.each(data, function() {

		
		_cb.addClass('s-hidden');
		_cb.wrap('<div class="select"></div>');
		_cb.after('<div class="styledSelect"></div>');
	    
	    var $styledSelect = _cb.next('div.styledSelect');
	    
	    // 이전 콤보 Item 삭제
        $('option', _cb).remove(); // 콤보 Remove
     
        //선택값 표시
        $styledSelect.text(data[0][obj.text]);
        
        // 콤보 ITEM 추가
        _cb.append('<option value="' + data[0][obj.value] + '">' + data[0][obj.text] +'</option>');
        
        var $list = $('<ul />', {
	        'class': 'options'
	    }).insertAfter($styledSelect);
	    
	   
	    for (var i = 0; i < data.length; i++) {
	    	var _t = "<table  style='border:0px solid #98bf21;width: 100%;border-collapse: collapse;'>";
	    	_t += "<tr style='border:0px'>";
	    	_t += "<td width='"+obj.width /3 +"px' style='border-bottom: 0px dotted;border-right: 1px dotted #666'>"+(data[i][obj.label]===undefined?data[i][obj.value]:data[i][obj.label])+"</td>";
	    	_t += "<td style='border-bottom: 0px dotted;border-right: 1px dotted #666'>"+data[i][obj.text]+"</td>";
	    	_t += "</tr>";
	    	_t += "</table>";
	    	$list.append("<li rel='"+data[i][obj.value]+"' text='"+data[i][obj.text]+"'>"+_t+"</li>");
	    }
        
	    var $listItems = $list.children('li');

	    //콤보 클릭시 처리
	    $styledSelect.click(function (e) {
	    	/* 사용자 이벤트 방지
	    	     하위 객체의 이벤트를 방지하고 선택된  DIV이벤트만 발생
	    	     콤보 객체및 기타 레이어의 곂쳐 있으므로 사용
	    	*/
	        e.stopPropagation();
	    	
	        $('div.styledSelect.active').each(function () {
	            $(this).removeClass('active').next('ul.options').hide();
	        });
	        $(this).toggleClass('active').next('ul.options').toggle();
	    });
	    
	    //콤보 아이템을 선택시 값을 Value에 세팅
	    $listItems.click(function (e) {
	        e.stopPropagation();
	        // 이전 콤보 Item 삭제
	        $('option', _cb).remove(); // 콤보 Remove
	     
	        //선택값 표시
	        $styledSelect.text($(this).attr('text')).removeClass('active');
	        // 콤보 ITEM 추가
	        _cb.append('<option value="' + $(this).attr('rel') + '">' + $(this).attr('text') +'</option>');
	        
            // 리스트 레이어 숨김
	        $list.hide();
	        
	        //Change 트리거 실행(change event 발생)
	        _cb.change();
	    });

	    //콤보외의 역역을 클릭시 콤보 레이어를 감춘다	    
	    $(document).click(function () {
	        $styledSelect.removeClass('active');
	    	// 리스트 레이어 숨김
            $list.hide();
	    });
	 });
}
