/*
 * 폼Element를 Json 개체로생성하고 Validation 항목이 있으면 항목을 체크 한다
 * Jquery Plugin으로 생성 
 * 
 */
(function($){
    $.fn.serializeJSON = function(){
        var json = {}
        var form = $(this);
        json._success = true;
        form.find('input, select').each(function(){
              var val
            if (!this.name) return;
            if ('radio' === this.type) {
                  if (json[this.name]) { return; }
                  
                  json[this.name] = this.checked ? this.value : '';
            } else if ('checkbox' === this.type) {
                  val = json[this.name];
             
                  if (!this.checked) {
                      if (!val) { json[this.name] = ''; }
                  } else {
                      json[this.name] =
                          typeof val === 'string' ? [val, this.value] :
                              $.isArray(val) ? $.merge(val, [this.value]) :
                                  this.value;
                 }
            } else {
                  //element 속성에 메시지가 있을경우 Validation 체크한다.
                  if ($(this).attr("message")===undefined)
                      json[this.name] = this.value;
                  else {
                      if ($(this).val()=="")
                      {
                          alert($(this).attr("message")+'입력 하셔야 합니다');
                          $(this).focus();
                          json._success = false;
                          return false;
                      }
                      else
                    	  json[this.name] = this.value;
                  }
            }
        })
        
        return json;
        }
    })(jQuery);