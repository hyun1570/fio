<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/base/include/ArchJsp.jspf" %>
<%@page import="com.cni.fw.meta.util.CmdMetaUtil"%>
<%@page import="com.cni.fw.meta.cmd.base.CommandMeta"%>
<%@page import="xlib.cmc.GridData"%>
<%@page import="xlib.cmc.OperateGridData"%>
<%
	if (cs != null) {
        CommandMeta cmdMeta = input.getCommand();
        String cmdStr = cmdMeta.getCommand();
        //아래는 각종 CMD 관련 메타를 득하기 위한 예시.
        //debug("현재진행중인CMD:"+cmdStr);  // 현재 진행중인 CMD는 최초에 요청한 CMD와 다를수도 있다 (CHAINED 등의 사유로 인해..)
        //debug("UC-ID:"+StrUtil.leftGetOff(cmdStr, ".", false));
        //debug("EV-ID:"+StrUtil.rightGetOff(cmdStr, ".", false));
        //debug("입력채널유형(진행중):"+cmdMeta.getIpType());
        //debug("출력채널유형(진행중):"+cmdMeta.getOpType());
        //debug("현재진행중인요청에대한최초CMD:"+cs.getFirstCommand()); // CHAINED 등으로 연쇄된 이벤트의 경우 최초CMD를 찾으려면 이와 같이 해야한다.
        //debug("입력채널유형(최초):"+CmdMetaUtil.getCommand(cs.getFirstCommand()).getIpType()); 
        //debug("출력채널유형(최종):"+CmdMetaUtil.findLastOpType(cmdStr)); // CHAINED 등으로 연쇄된 이벤트의 경우 최종 CMD의 출력채널유형을 찾으려면 이와 같이 해야한다.
  
        String UC_ID = StrUtil.leftGetOff(cmdStr, ".", false);
        String lastOpType = CmdMetaUtil.findLastOpType(cs.getFirstCommand());
		
		// 최종 출력 채널의 종류가 XML 인 요청에 대한 세션타임아웃 처리
		if (lastOpType.equals("XML")) {
	    	String msg = "세션이 존재하지 않습니다.";
	        String code = "NOSESSION";

	        response.setContentType("text/xml");
	        response.setHeader("Cache-Control", "no-cache");
	        response.setHeader("pragma","no-cache");
	        out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
	        out.println("<EffectDTO>");
	        out.println("<Summary>");
	        out.println("<Success>false</Success>");
	        out.println("<Code>" + code + "</Code>");
	        out.println("<Message>" + msg + "</Message>");
	        out.println("<TX>" + output.getTxId() +"</TX>");
	        out.println("</Summary>");
	        out.println("</EffectDTO>");
	            
	        return; 
	    // 최종 출력 채널의 종류가 WISE 인 요청에 대한 세션타임아웃 처리
		} else if (lastOpType.equals("WISE")) {
			
			response.setContentType("text/html;charset=UTF-8");
			GridData gdObj = new GridData();
			gdObj.setMessage("세션이 존재하지 않습니다.");
			gdObj.setStatus("NOSESSION");
			try {
				OperateGridData.write(gdObj, response.getWriter());
			} catch (Exception e) {
				e.printStackTrace();
			}
			return;
		}
	}
%>
<link href="<%= request.getContextPath() %>/base/css/cni.css" rel="stylesheet" type="text/css">
<br>
<br>
<b>로그인한 상태가 아니면 수행할 수 없는 기능입니다. </b>
<br>
<br>
<font color="red">로그인을 수행하십시요.</font>
