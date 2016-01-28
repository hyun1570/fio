<%@page import="javax.mail.Session"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ include file="/views/include/tag_lib.jsp"%>
<%

   DecimalFormat df = new DecimalFormat("00");
   Calendar calendar = Calendar.getInstance();

   //날자
   String year = Integer.toString(calendar.get(Calendar.YEAR)); //년도를 구한다
   String month = df.format(calendar.get(Calendar.MONTH) + 1); //달을 구한다
   String day = df.format(calendar.get(Calendar.DATE)); //날짜를 구한다
  

   int iDayOfWeek = calendar.get(Calendar.DAY_OF_WEEK); //요일을 구한다

   String strDayOfWeek = "";
   switch(iDayOfWeek){
      case 1:
         strDayOfWeek = "일요일";
         break;
      case 2:
         strDayOfWeek = "월요일";
         break;
      case 3:
         strDayOfWeek = "화요일";
         break;
      case 4:
         strDayOfWeek = "수요일";
         break;
      case 5:
         strDayOfWeek = "목요일";
         break;
      case 6:
         strDayOfWeek = "금요일";
         break;
      case 7:
         strDayOfWeek = "토요일";
         break;

      }
   
   //시간
    String formattedTime = new SimpleDateFormat("a HH:mm").format(Calendar.getInstance().getTime());
   
   // 일반 사용자 강제 로그인 후 메인화면으로 올 시 출입예약 화면으로 이동시킨다.
   if(session.getAttribute("SESSION_USER_ID").equals("GUEST")){
	   response.sendRedirect("DDTA.RSVTN.E01.cmd");
   }else if(session.getAttribute("SESSION_USER_ID").toString().indexOf("GATE") > -1){
       response.sendRedirect("DDTA.IOMNG.L01.cmd");
   }
   

 %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${PAGE_TITLE}</title>
<%@ include file="/views/include/css.jsp"%>
<%@ include file="/views/include/common.jsp"%>

<script>



// <tr>
// <td class='main_table_body'>압축기</td>
// <td class='main_table_body text_orange12b'>9</td>
// <td class='main_table_body text_orange12b'>7</td>
// <td class='main_table_body text_orange12b'>6</td>                
// </tr>

$(window).load(function(){
	getRsvtnStatus();
});

function getRsvtnStatus(){
	var jsonObj = {};
    jsonObj.sqlid = "Main.GET_MAIN_STAT";

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
        	 var tbl = $("#rsvtnTbl");
        	 var srcT = "";
             for(var i in result){
            	 if(result[i].factCode == undefined){
            		 srcT+=("<tr>");
                     srcT+=("<td class='main_table_foot'>합계</td>");
                     srcT+=("<td class='main_table_foot text_orange12b'>"+result[i].rsvtnCnt+"</td>");
                     srcT+=("<td class='main_table_foot text_orange12b'>"+result[i].acceptCnt+"</td>");
                     srcT+=("<td class='main_table_foot text_orange12b'>"+result[i].waitCnt+"</td>");
                     srcT+=("</tr>");
            	 }else if(i == (result.length -2)){
            		 srcT+=("<tr>");
                     srcT+=("<td class='main_table_foot'>"+result[i].factName+"</td>");
                     srcT+=("<td class='main_table_foot text_orange12b'>"+result[i].rsvtnCnt+"</td>");
                     srcT+=("<td class='main_table_foot text_orange12b'>"+result[i].acceptCnt+"</td>");
                     srcT+=("<td class='main_table_foot text_orange12b'>"+result[i].waitCnt+"</td>");
                     srcT+=("</tr>");
            	 }else{
	            	 srcT+=("<tr>");
	            	 srcT+=("<td class='main_table_body'>"+result[i].factName+"</td>");
	            	 srcT+=("<td class='main_table_body text_orange12b'>"+result[i].rsvtnCnt+"</td>");
	            	 srcT+=("<td class='main_table_body text_orange12b'>"+result[i].acceptCnt+"</td>");
	            	 srcT+=("<td class='main_table_body text_orange12b'>"+result[i].waitCnt+"</td>");
	            	 srcT+=("</tr>");
            	 }
             }
             tbl.append(srcT);
         },
         error      : function(e)
         {
             alert(e.responseText);
         }
    });
}


</script>
</head>
<body>
<div class="wrap">
    <%@ include file="/views/include/top.jsp"%>
        <div class="container_main">
        <div class="main_area bg_factory">
            <div class="main_title">
            <table width="560" style="border-spacing:0; border-collapse:collapse; border:0;">
              <tr>
                <td style="vertical-align:top; height: 54px;"><img src="<%=request.getContextPath()%>/resources/css/images/img_title_access.gif" alt="출입관리" /></td>
              </tr>
              <tr>
                <td class="blackline"></td>
              </tr>
              <tr>
                <td style="padding-top:16px;"><span class="text_orange16b"><%=year + "년 "+month+"월 "+day+"일 "+strDayOfWeek %></span><br />
                <span class="text_gray16b"><%=formattedTime %></span></td>
              </tr>
              <tr>
                <td style="padding-top:20px;font-size:15px">
                    <table cellpadding="0" cellsapacing="0" border="0" width="200" style="font-size:15px">
                        <colgroup>
                            <col width="40px"/>
                            <col width="100px"/>
                            <col width="*"/>
                        </colgroup>
                        <tr>
                            <th>담당자</th>
                            <td align="center">안정선 차장</td>
                            <td align="left">64)8131</td>
                        </tr>
                    </table>
                </td>
              </tr>
            </table>
            </div>
            <div class="main_content1">
	            <table width="560" id="rsvtnTbl" style="border-spacing:0; border-collapse:collapse; border:0;">
	              <tr style="height:38px">
	                <td class="main_subtitle" colspan="4">출입 예약 현황</td>
	              </tr>
	              <tr>
	                <td class="main_table_head wp40">공장명</td>
	                <td class="main_table_head wp20">예약건수</td>
	                <td class="main_table_head wp20">승인건수</td>
	                <td class="main_table_head wp20">미승인건수</td>                
	              </tr>
	            </table>
            </div>
        </div>
    </div> <!-- container_main -->
</div>
<%@ include file="/views/include/bottom.jsp"%>
</body>
</html>             