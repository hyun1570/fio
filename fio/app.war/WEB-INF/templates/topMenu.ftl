<script language="javascript">
// 페이지 Action
function getTopMenuAction(action)
{
    /*
    if (url == "")
    {
        alert("해당하는 주소가 없습니다. 다시한번 '로그인' 하여 주십시오.");
        return;
    }
    */
    switch (action)
    {
     <#assign lv2Cnt = 0>
     <#list menus as menuValue>
         <#if menuValue.menuType == '20'>
         <#assign lv2Cnt = lv2Cnt + 1>
         </#if>
         
         case ${menuValue_index + 1} : //${menuValue.menuName}
    
        <#if menuValue.menuCommand == "">
            alert("해당 메뉴의 링크가 없습니다.");
        <#else>
    
            $("#frmTop").attr({
                action : "${menuValue.menuCommand}.cmd",
                target : "_self",
                method : "POST"
            });
    
            $("#frmTop").submit();
        </#if>
            break;
        
    </#list>
    }
}

_lv_2_cnt = ${lv2Cnt};

var _ct ='';

$(document).ready(function(){
    $( ".main_nav li" ).hover(function() {  

        var _n = $(this);
        
        if (_ct!=="")
        {
            $('.main_nav li').find("div").each(function (){
                $(this).css("visibility", "hidden");
                $(this).css("opacity", "0");
              });
        } else {
            $('.main_nav li').find("div").each(function (){
                $(this).css("visibility", "hidden");
                $(this).css("opacity", "0");
              });
            
            $('.main_nav li').find("div").each(function (){
                $(this).css("visibility", "hidden");
                $(this).css("opacity", "0");
              });
        } 
        _ct = _n;

        if( $( this ).find("a").attr('class') != "home" )
            {
                    $(".dropdown_area").fadeIn(00,function(){
                    _n.find("div").each(function (){
                      $(this).css("visibility", "visible");
                      $(this).css("opacity", "1");
                    });
                });         
            }else
            {
                $('.main_nav li').find("div").each(function (){
                        $(this).css("visibility", "hidden");
                        $(this).css("opacity", "0");
                      });
                    
                   //$(".dropdown_area").fadeOut(100);
                    $(".dropdown_area").hide();
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
                    
                   //$(".dropdown_area").fadeOut(100);
                    $(".dropdown_area").hide();
                } else {
                        $('.main_nav li').find("div").each(function (){
                            $(this).css("visibility", "hidden");
                            $(this).css("opacity", "0");
                          });
                        $(".dropdown_area").hide();
                  //     $(".dropdown_area").fadeOut(100);
                }
            }
            if ($(".dropdown_area").offset().top+$(".dropdown_area").height()<e.pageY)
            {
                if (_ct!=="") {
                    $('.main_nav li').find("div").each(function (){
                        $(this).css("visibility", "hidden");
                        $(this).css("opacity", "0");
                      });
                    $(".dropdown_area").hide();
               //    $(".dropdown_area").fadeOut(100);                 
                } else {
                    $('.main_nav li').find("div").each(function (){
                        $(this).css("visibility", "hidden");
                        $(this).css("opacity", "0");
                      });
                    $(".dropdown_area").hide();
              //     $(".dropdown_area").fadeOut(100);
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
<div class="space30">
    <ul class="main_nav">
       <li><a href="javascript:void(0)" onclick="getMainMove()" class="home"></a></li>
       <#assign menuCount = 0>
       <#assign thisLv = "0">
       <#assign l3Cnt = 0>
       <#list menus as menuValue>
            <#if menuValue.menuType == "10">
                <#assign l3Cnt = 0>
                <#if thisLv != "0" && (thisLv?number >= menuValue.menuType?number) >
                    <#if thisLv == "10">
                        </li>
                    <#elseif thisLv == "20">
                        </ul></div></li>
                    <#elseif thisLv == "30">
                        </ul></div></li>
                    </#if>
                    <#assign menuCount = 0>
                </#if>
                <li>
                    
                    <#if menuValue.menuCommand == "">
                    <a href="javascript:void(0)" >${menuValue.menuName}</a>
                    <#else>
                    <a href="javascript:getTopMenuAction(${menuValue_index + 1})" >${menuValue.menuName}</a>
                    </#if>
                    
                    
                <div class="nav_column_title">${menuValue.menuName}</div>
                <#assign thisLv = menuValue.menuType>
            </#if>
            <#if menuValue.menuType == "20">
                <#assign l3Cnt = 0>
                <#assign menuCount = menuCount + 1>
                <#if thisLv != "0" && (thisLv?number >= menuValue.menuType?number)  >
                    </ul></div>
                </#if>
                <div class="nav_column0${menuCount}">
                    <span class="menu_category">
                    <#if menuValue.menuCommand == "">
                        <#if menuValue.menuName == " ">
                            &nbsp;
                        <#else>
                            ${menuValue.menuName}
                        </#if>
                    <#else>
                        <a href="javascript:getTopMenuAction(${menuValue_index + 1})" >${menuValue.menuName}</a>
                    </#if>
                    </span>
                <ul>
                <#assign thisLv = menuValue.menuType>
            </#if>
            <#if menuValue.menuType == "30">
                <#if l3Cnt == 3>
                    <#assign menuCount = menuCount + 1>
                    </ul></div>
                    <div class="nav_column0${menuCount}">
                        <span class="menu_category">&nbsp;</span>
                        <ul>
                    <#assign l3Cnt = 0>
                </#if>
                <li><a href="javascript:getTopMenuAction(${menuValue_index + 1})">${menuValue.menuName}</a></li>
                
                <#assign l3Cnt = l3Cnt +1 >
                <#assign thisLv = menuValue.menuType>
                
                
            </#if>
       </#list>
       
       
       <#if thisLv != "0">
            <#if thisLv == "10">
                </li>
            <#elseif thisLv == "20">
                </div></li>
            <#elseif thisLv == "30">
                </ul></div></li>
            </#if>
        </#if>        
    </ul>
    <div class="dropdown_area"></div>
</div>




