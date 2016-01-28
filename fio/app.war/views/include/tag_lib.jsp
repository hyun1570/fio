<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page extends="com.cni.fw.arch.ArchJsp"%>
<%@ page import="com.cni.fw.ff.dto.*"%>
<%@ page import="com.cni.fw.ff.dto.entity.*"%>
<%@ page import="com.cni.fw.ff.util.maker.*"%>
<%@ page import="com.cni.fw.ff.dto.support.*"%>
<%@ page import="com.cni.fw.ff.util.*"%>
<%@ page import="com.cni.fw.id.*"%>
<%@ page import="com.cni.fw.web.util.*"%>
<%@ page import="com.cni.fw.web.session.so.CommonSession"%>
<%@ page import="com.ddta.base.menu.pageSupport"%>
<%
    CauseDTO input = getCauseDTO(request);
    EffectDTO output = getEffectDTO(request);
    CommonSession cs = null;
    
    if (input != null) {
        cs = input.getCommonSession();
    }
    
    pageSupport _mm = new pageSupport(this.getClass());
    
    _mm.setCurrent(request.getParameter("current"));
    
    _mm.setParameters(request.getParameter("param")==null?"":request.getParameter("param"));
    
    _mm.set_command(input.getCommand().getCommand());
    
    _mm.set_cs(cs);
    
    String _menu = _mm.getTemplate(input);
    
    pageContext.setAttribute("TOP_MENU",_menu);
    
    pageContext.setAttribute("PAGE_TITLE", _mm.getPageTitle());
    
    pageContext.setAttribute("MENU_NAME",_mm.getMenuName());
    
    //pageContext.setAttribute("GRANT",_mm.getGrant());
        
    if (request.getParameter("current")== null)
        pageContext.setAttribute("GRIDLIST",_mm.getGridList());
    else
        pageContext.setAttribute("GRIDLIST2",_mm.getGridList());
    
    
    if (request.getParameter("param")!= null)
    {
        LTO resList = _mm.getListOfElements();
        
        if (resList!=null)
        {
            for(int i =0; i<resList.size();i++)
            {
                MTO _k = resList.get(i);
                Object[] _ar =  _k.keySet().toArray();
                
                for (int j=0; j<_ar.length;j++)
                {
                    pageContext.setAttribute(_ar[j].toString(), _k.get(_ar[j].toString()));
                }                
            }
        }
    }
%>                  