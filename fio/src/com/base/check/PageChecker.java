package com.base.check;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Properties;

import javax.servlet.Servlet;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cni.fw.arch.fmb.WebFrame;
import com.cni.fw.ff.dto.impl.ImplCauseDTO;
import com.cni.fw.ff.dto.impl.ImplEffectDTO;
import com.cni.fw.ff.exception.FrameException;


public class PageChecker extends WebFrame implements Servlet{

	public PageChecker(String name) {
		super(name);
		// TODO Auto-generated constructor stub
	}

	@Override
	public void execute(ImplCauseDTO arg0, ImplEffectDTO arg1,
			HttpServletRequest req, HttpServletResponse res)
			throws FrameException {
		// TODO Auto-generated method stub
		
		try{
	        //프로포티 객체 선언
	        Properties prop = new Properties();
			
			//System.out.println("referer===>"+req.getHeader("Referer"));
			
			String referer = req.getHeader("Referer");
			
			/*템플릿 프로퍼티 파일 로드
	        DAFRAME 루트 는 CNI.HOME Properties에서 가져옴
	        */
			InputStreamReader _pr;
			
			_pr = new InputStreamReader(new FileInputStream(System.getProperty("CNI.HOME", ".")+"\\WEB-INF\\conf\\pagechecker.conf"),"UTF-8");
			prop.load(_pr);
			
			String chk_rf = String.valueOf(prop.get("comm_referer"));
/*			
			System.out.println("referer==>"+referer);
			System.out.println(" referer.indexOf(chk_rf)==>"+ referer.indexOf(chk_rf));
*/			
			if(referer != null && referer.indexOf(chk_rf) < 0){
				res.setCharacterEncoding("UTF-8");
				res.setHeader("method","post");
				res.sendRedirect("views/base/error.jsp?errorCode=NPA");
				
			}
			
			
		}catch(Exception e){
			e.printStackTrace();
		}
		
	}

	
	@Override
	public void destroy() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public ServletConfig getServletConfig() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String getServletInfo() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void init(ServletConfig arg0) throws ServletException {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void service(ServletRequest arg0, ServletResponse arg1)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void disuse() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void init() throws FrameException {
		// TODO Auto-generated method stub
		
	}
	

}
