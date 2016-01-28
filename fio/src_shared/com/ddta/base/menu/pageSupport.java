package com.ddta.base.menu;

import java.io.File;
import java.io.IOException;
import java.io.StringWriter;
import java.io.Writer;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.cni.fw.arch.smb.ac.NormalTxService;
import com.cni.fw.arch.tx.MasterTx;
import com.cni.fw.db.cdq.tactics.query.Tactics;
import com.cni.fw.db.cdq.tactics.query.TacticsFactory;
import com.cni.fw.db.core.connect.ConnectionManager;
import com.cni.fw.ff.conf.AppConfig;
import com.cni.fw.ff.dto.CauseDTO;
import com.cni.fw.ff.dto.EffectDTO;
import com.cni.fw.ff.dto.entity.MTO;
import com.cni.fw.web.session.so.CommonSession;
import com.cni.fw.ff.dto.entity.LTO;
import com.cni.fw.ff.exception.FrameException;
import com.cni.fw.ff.exception.ServiceException;
import com.ddta.base.util.JsonUtil;

import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;

/**
 * <pre>
 *  Menu 와 그리드 스트럭쳐, 권한정보를 페이지에 넘겨준다.
 *
 *  개발자              : 이태종
 *
 *  작성날짜            : 20140417
 *
 *  유스케이스 명       : Menu Handler
 *  유스케이스 아이디   : 
 *  이벤트 명           : 
 *  이벤트 아이디       : 
 *  설계자              : 이태종
 *
 *  업무 유형           : 
 *  입력 채널 유형      : PAGE
 *  출력 채널 유형      : PAGE
 *  출력 URL            :
 *
 *  비고                : 해당되는 페이지에 해당하는 권한과 그리드 구조를 가져온다
 *                         
 * </pre>
 */


public class pageSupport extends NormalTxService
{

    private String parameters;

    private String m_command;
    
    private String m_current;
    
    private String m_grant=null;
    
    private String m_gridList;
    
    private CommonSession m_cs;
    
    private MTO m_mto = new MTO();
    
    private LTO m_lto = null;
    
    
    private String m_Page_Title = "";
    private String m_Menu_Name = "";
    
    public void setCurrent(String _c)
    {
    	this.m_current = _c;
    }
    
    public LTO getListOfElements()
    {
    	return this.m_lto;
    }
    
    public String getGridList()
    {
    	return this.m_gridList;
    }
    
    public String getGrant()
    {
    	return this.m_grant;
    }
    
    public String getMenuName()
    {
    	return this.m_Menu_Name;
    }
    
    public String getPageTitle()
    {
    	return m_Page_Title;
    }
	public String get_command() {
		return m_command;
	}
	public void set_command(String m_command) {
		this.m_command = m_command;
	}
	public CommonSession get_cs() {
		return m_cs;
	}
	
	public void set_cs(CommonSession m_cs) {
		this.m_cs = m_cs;
		
        //유저 ID를 mto에 설정한다.
        m_mto.put("userId", this.m_cs.getUserId());
        
        m_mto.put("lang", "KOR");
        //프로그램 이름을 가져온다.
        m_mto.put("menuId",this.m_current==null?m_command:this.m_current);
        
        //출입관리 사이트코드(임시)
        m_mto.put("siteCode", "10008");
	}
	public String getParameters() {
		return parameters;
	}
	public void setParameters(String parameters) {
		this.parameters = parameters;
	}

    public pageSupport(Class clazz) throws FrameException
    {
    	super(clazz);
    }

    /*
     * 메뉴 템플릿을 String으로 리턴한다. 
     */
    public String getTemplate(CauseDTO input) throws FrameException, IOException, SQLException 
    {
    	MasterTx  mTx = null;
    	String _tmp = null;
    	try{
	        // 메인 데이타베이스로 설정된 커낵션을 얻을 경우
	        mTx = new MasterTx(ConnectionManager.getInstance().getConnection());
	        
	        Tactics tactics = TacticsFactory.getInstance(mTx);
	    	
	       //그리드 목록이 있는지 확인 하고 gridSet에 정의해서 Client로 넘긴다.
	        LTO resList = tactics.selectList("Program.ProgramGridSet", m_mto);
	
	        m_gridList= JsonUtil.ListToJson(resList.getList());
	        
	        //프로그램 목록을 가져온다
	    	resList = tactics.selectList("Program.UserProgram", m_mto);
	    	
	        /*
	         * 프로그램 목록이 있을경우만 처리 
	         */
	        if (resList.size()>0)
	        {
		        
		    	//페이지 타이틀 표시
		        m_Page_Title = resList.get(0).get("menuName");
		        
		        //JSP 페이지에 소재목을 표시
		        m_Menu_Name = resList.get(0).get("menuName");
		        /*
		         *인크루드된 페이지가 아닌경우만 메뉴 템플릿 실행 
		         */
			    if(m_current==null)
			    {
			
			        /*템플릿 프로퍼티 파일 로드
			           DAFRAME 루트 는 CNI.HOME Properties에서 가져옴 
			        */
					//템플릿 객체 선언
					Configuration cfg = new Configuration();
			        cfg.setClassForTemplateLoading(pageSupport.class, "src");
			        cfg.setDirectoryForTemplateLoading(new File(System.getProperty("CNI.HOME", ".")+"\\WEB-INF\\"+AppConfig.get("template.path").toString()));
			        
			        cfg.setDefaultEncoding("UTF-8");
			        
			        // 탬플릿에 매핑할 메뉴 MAP
			        Map<String, Object> _ip= new HashMap<String, Object>();
			        
			        List<menuValue> menus = new ArrayList<menuValue>();
			
			        
			        for(int i =0; i<resList.size();i++)
			        {
			        	MTO _k = resList.get(i);
			        	
			        	menus.add(new menuValue(_k.get("programName").toString(), _k.get("menuId")==null?"": _k.get("menuId").toString(),_k.get("menuType")==null?"":_k.get("menuType").toString()));
			        }
			
			        // 템플릿에 메뉴 개체 지정
			        _ip.put("menus", menus);
			        
			        // 템플릿  파일 지정
			        Template template = cfg.getTemplate("topMenu.ftl");
			        
			        Writer _out = new StringWriter(); 
			        
			        //템플릿 설정 실행 
			        try {
						template.process(_ip, _out);
					} catch (TemplateException e1) {
						e1.printStackTrace();
					}
			        
			        
			         _tmp = _out.toString();
			        
			        _out.close();
		        }
		        //프로그램 권한을 가져온다.
		        //resList = tactics.selectList("Permission.GrantList", m_mto);
		        this.m_grant = String.valueOf(tactics.select("Permission.PermList", m_mto).get("grants"));
		        
		        
		        //파라메터가 있을경우 SqlId값을 받아 Page로 반환한다.
		        if (!this.parameters.equals("") && "JSP".equals(input.getCommand().getOpType()))
		        {
		        	// 웹 Json파라메터를 Map으로 변환
		            Map<String, Object> param = JsonUtil.JsonToMap(this.parameters);
		            
		            MTO _dt = new MTO();
		            _dt.setMap((HashMap) param);
		            
		            if (_dt.get("grid")==null)
		            {
			        	if (_dt.get("sqlId")!= null)
			        	{
			        		//Update가 있을경우의 처리
			        		if (_dt.get("ex")!= null) {
			        			tactics.update(_dt.get("ex").toString(), _dt);
			        		}
			        		m_lto = tactics.selectList(_dt.get("sqlId").toString(), _dt);
				            
			        	}
		            }
		        }
	        }
	        mTx.close();
    	}catch(Exception e){
    		mTx.close();
    		mTx = null;
    		e.printStackTrace();
    	}
    	return _tmp;
    }
    
	@Override
	protected void process(CauseDTO arg0, EffectDTO arg1)
			throws FrameException, ServiceException, SQLException {
		// TODO Auto-generated method stub
		
	}
}
