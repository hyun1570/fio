<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
var _gridList = '${GRIDLIST}';
var _grant = '${GRANT}';
var _lv_2_cnt = 0;

// Log Out
function getLogOut()
{
    if (confirm("로그아웃 하시겠습니까?")) {
        window.open('', '_self', ''); window.close();
    } 
}

// 개인정보 수정
function getUserModify()
{
    
}

// Main 화면
function getMainMove()
{
    $("input[name=param]").val("");
    $("input[name=path]").val("/DDTA000.M03.cmd");

    $("#frmTop").attr({
        action : "DDTA000.M03.cmd",
        target : "_self",
        method : "POST"
    });

    $("#frmTop").submit();
}
var _ct ='';

$(document).ready(function(){
    $( ".main_nav li" ).hover(function() {  

        var _n = $(this);
        
        if (_ct!=="")
        {
            _ct.find("div").each(function (){
                $(this).css("visibility", "hidden");
                $(this).css("opacity", "0");
              });
        } else {
            $('.main_nav li').find("div").each(function (){
                $(this).css("visibility", "hidden");
                $(this).css("opacity", "0");
              });
        } 
        _ct = _n;
        
        if(_lv_2_cnt != 0){
            $(".dropdown_area").fadeIn(00,function(){
                _n.find("div").each(function (){
                  $(this).css("visibility", "visible");
                  $(this).css("opacity", "1");
                });
            });
        }

    });

});

//메뉴의 
$(document).mousemove(function(e) {

     if ( document.readyState === "complete" ) 
     {
        if ($(".dropdown_area").css("display")!=="none")
        {
            if ($(".main_nav").offset().top>e.pageY)
            {
                if (_ct!=="") {
                    $('.main_nav li').find("div").each(function (){
                        $(this).css("visibility", "hidden");
                        $(this).css("opacity", "0");
                      });
                    
                   $(".dropdown_area").hide();;
                } else {
                        $('.main_nav li').find("div").each(function (){
                            $(this).css("visibility", "hidden");
                            $(this).css("opacity", "0");
                          });
                        
                       $(".dropdown_area").hide();;
                }
            }
            if ($(".dropdown_area").offset().top+$(".dropdown_area").height()<e.pageY)
            {
                if (_ct!=="") {
                    _ct.find("div").each(function (){
                        $(this).css("visibility", "hidden");
                        $(this).css("opacity", "0");
                      });
                   $(".dropdown_area").hide();;                   
                } else {
                    $('.main_nav li').find("div").each(function (){
                        $(this).css("visibility", "hidden");
                        $(this).css("opacity", "0");
                      });
                    
                   $(".dropdown_area").hide();;
               }
            }
        } else {
        	$('.main_nav li').find("div").each(function (){
                $(this).css("visibility", "hidden");
                $(this).css("opacity", "0");
              });
        }
 }
}).mouseover();
        
</script>

<div class="header">
    <div class="site_title">출입관리</div>
     <div class="user_menu">
         <div class="user_name">${SESSION_USER_NAME}</div>
         <span class="text_black12">&nbsp;님, 환영합니다! 최종 로그인 : <strong>${SESSION_LAST_LOGIN_DATE} / ${SESSION_LAST_LOGIN_TIME}</strong></span>
         <a href="javascript:getLogOut()" class="btn_orange"><span class="btn_orange_left">로그아웃</span></a>
     </div>
</div>
${TOP_MENU}
<form id="frmTop" name="frmTop" method="post">
    <input type="hidden" id="sessionUserId" name="sessionUserId" value="<%= session.getAttribute("SESSION_USER_ID") %>" />
    <input type="hidden" id="mcategory"     name="mcategory" />
    <input type="hidden" id="param"         name="param" />
    <input type="hidden" id="path"          name="path" />
</form>

