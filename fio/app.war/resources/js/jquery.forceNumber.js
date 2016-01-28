/**
 * Elements 에 숫자만 입력 가능하도록 한다.
 * 
 * 사용방법 : $("Elemens").NumericOnly()
 * 
 * FireFox의 경우 한글입력 문제로 인해 Style에서  ime-mode: disabled 설정 필요
 */

jQuery.fn.NumericOnly =
function()
{
    return this.each(function()
    {
    	var ctrkey = false;
    	
        $(this).keydown(function(e)
        {
        	
        	if(key == 17 ) ctrkey = true;
        	
            var key = e.charCode || e.keyCode || 0;
            
            // 백스페이스,텝,delete,enter,화살표,숫자,키패드 숫자
            // home, end, 돗트, and 숫자패드
            return (
                key == 8 || 
                key == 9 ||
                key == 13 ||
                key == 46 ||
                key == 110 ||
                key == 190 ||
                key == 116 ||
                (key >= 35 && key <= 40) ||
                (key >= 48 && key <= 57) ||
                (ctrkey && key == 86) ||
                (key >= 96 && key <= 105));
        });
        
        $(this).keyup(function(e){
			ctrkey = false;
		});
        
        
    });
};

jQuery.fn.PhoneNumber = function(){
	return this.each(function(){
		
		var ctrkey = false;

			$(this).keydown(function(e){
				
				var key = e.charCode || e.keyCode || 0;
				
				// Ctrl key 조합 체크
				if(key == 17 ) ctrkey = true;

				return (
		                key == 8 || 
		                key == 9 ||
		                key == 13 ||
		                key == 16 ||
		                key == 46 ||
		                key == 109 ||
		                key == 173 ||
		                key == 116 ||
		                key == 189 ||
		                key == 36 ||
		                (key >= 35 && key <= 40) ||
		                (key >= 48 && key <= 57) ||
		                (ctrkey && key == 86) ||
		                (ctrkey && key == 67) ||
		                (key >= 96 && key <= 105));
				
			});
			
			$(this).keyup(function(e){
				ctrkey = false;
				var key = e.charCode || e.keyCode || 0;
				if(key != 36 && key != 35 && key != 16 && key != 17 && key != 37 && key != 39){
					var str = $(this).val();
					var p = /[`~!$@%^&*_|+=?;:\'\"<>\{\}\[\]]/gi;
				    $(this).val(str.replace(p,''));
				}
				
			});
	});
};
