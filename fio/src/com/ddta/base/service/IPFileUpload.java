package com.ddta.base.service;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.FilenameUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.cni.fw.arch.smb.cc.WebControl;
import com.cni.fw.arch.tx.MasterTx;
import com.cni.fw.db.cdq.tactics.query.Tactics;
import com.cni.fw.db.cdq.tactics.query.TacticsFactory;
import com.cni.fw.db.core.connect.ConnectionManager;
import com.cni.fw.ff.dto.entity.LTO;
import com.cni.fw.ff.dto.entity.MTO;
import com.cni.fw.ff.dto.impl.ImplCauseDTO;
import com.cni.fw.ff.dto.impl.ImplEffectDTO;
import com.cni.fw.ff.exception.FrameException;
import com.cni.fw.ff.exception.ServiceException;
import com.cni.fw.extra.excel.ExcelReader;
import com.ddta.base.util.JsonUtil;

public class IPFileUpload extends WebControl {

	public IPFileUpload(Class clazz) {
		super(clazz);
		// TODO Auto-generated constructor stub
	}

	@Override
	public void process(ImplCauseDTO input, ImplEffectDTO output, HttpServletRequest request, HttpServletResponse response) throws FrameException, ServiceException {
		
		try {
			// Encoding Type을 UTF-8로 지정
			response.setCharacterEncoding("UTF-8");
	        
	        response.setContentType("text/html; charset=UTF-8");
	        
			ServletFileUpload uploader = new ServletFileUpload(new DiskFileItemFactory());
			List<FileItem> items = uploader.parseRequest(request);

			//프로포티 객체 선언
	        Properties prop = new Properties();

	        /*템플릿 프로퍼티 파일 로드
	           DAFRAME 루트 는 CNI.HOME Properties에서 가져옴 
	        */
	        InputStreamReader  _pr = new InputStreamReader(new FileInputStream(System.getProperty("CNI.HOME", ".")+"\\WEB-INF\\conf\\templates.conf"),"UTF-8");
			prop.load(_pr);
			
			//베이스 파일 폴더
			String _base_folder = prop.getProperty("file.path").toString(); 
			
			// 업로드 모드
			String mode = request.getParameter("mode");
			
			//파라메터에 폴더가 있을경유 폴더를 타켓으로 설정
			String _targetFolder = request.getParameter("folder");
			
			//보드 ID
			String _boardId = request.getParameter("boardId");
			
			//레퍼런스1
			String _ref1 = request.getParameter("ref1");
			//레퍼런스2
			String _ref2 = request.getParameter("ref2");
			//레퍼런스3
			String _ref3 = request.getParameter("ref3");
			//레퍼런스4
			String _ref4 = request.getParameter("ref4");
			
			//Extra 데이타
			String _extra = request.getParameter("extra");
			
			//시작 Row
			String _si = request.getParameter("pRow");
			
			//Extra Result
			String _extraResult = "";
			
			String action = "";
			
			PrintWriter writer = null;
			writer = response.getWriter();
			
			if (mode == null) {
				for (FileItem item : items) {
					
					if (item.getFieldName().equals("mode")) {
						InputStream is = item.getInputStream();
						BufferedReader br = new BufferedReader(new InputStreamReader(is));
						StringBuilder sb = new StringBuilder();
				    	String line;
						while ((line = br.readLine()) != null) {
							sb.append(line);
				    	}
						mode = sb.toString();
					}

					if (item.getFieldName().equals("action")) {
						InputStream is = item.getInputStream();
						BufferedReader br = new BufferedReader(new InputStreamReader(is));
						StringBuilder sb = new StringBuilder();
				    	String line;
						while ((line = br.readLine()) != null) {
							sb.append(line);
				    	}
						action = sb.toString();
					}
				}
			}

			// 업로드 취소 처리
			if (action.equals("cancel"))
				writer.print("{state:'cancelled'}");
			else {
				String _filename = "";
				Integer _filesize = 0;
				
				for (FileItem item : items) {
					if (!item.isFormField()) {
						// 파일 처리						
						_filename = FilenameUtils.getName(item.getName());
						InputStream filecontent = item.getInputStream();
						
						//베이스 폴더가 없을경우 베이스 폴더 생성
				        File dir=new File(_base_folder);
				        if(!dir.exists()){
				            dir.mkdir();
				        }
				        
						//대상 폴더가 없을경우 대상폴더 생성
				        dir=new File(_base_folder+"\\"+_targetFolder);
				        if(!dir.exists()){
				            dir.mkdir();
				        }
				        
				        // 대상파일 이름
				        String _df = getUniqueName(_base_folder+"\\"+_targetFolder+"\\",_filename);
						// 파일 저장
						File f=new File(_df);
						
						OutputStream fout=new FileOutputStream(f);
						byte buf[]=new byte[1024];
						int len;
						while((len=filecontent.read(buf))>0) {
							fout.write(buf,0,len);
							_filesize+=len;
						}
						fout.close();
						
						MTO _fi = new MTO();
						
						_fi.put("boardId", _boardId);
						_fi.put("filePath", _base_folder+"\\"+_targetFolder+"\\");
						_fi.put("origFileName", _filename);
						_fi.put("saveFileName", f.getName());
						
						_fi.put("fileSize", _filesize);
						_fi.put("regId", input.getCommonSession().getUserId());
						
						_fi.put("ref1", _ref1);
						_fi.put("ref2", _ref2);
						_fi.put("ref3", _ref3);
						_fi.put("ref4", _ref4);
						
						//Extra가 아닐경우 DB 에 저장
						if (_extra == null || _extra == "")
					   {
							try {
								saveFileInfo(_fi);
							} catch (Exception e) {
								e.printStackTrace();
							}
					    }
						else {
							//Excel 데이타를 Json형태로 변환한다.
							_extraResult = JsonUtil.excelToJson(_df,0,Integer.valueOf(_si),new JSONArray(request.getParameter("pCols").toString()));
							
							output.put("result", "{state: true, name:'" + f.getName() + "', size: " + _filesize +",extra: "+_extraResult+"}");
							writer.print("{state: true, name:'" + _filename.replace("'","\\'") + "', size: " + _filesize + "}");
						}
					}
				}

				if (_extra == null || _extra == ""){
					writer.print("{state: true, name:'" + _filename.replace("'","\\'") + "', size: " + _filesize +"}");
					output.put("result", "{state: true, name:'" + _filename.replace("'","\\'") + "', size: " + _filesize +"}");
				}
			}
		} catch (FileUploadException e) {
			try {
				throw new ServletException("업로드 요청 오류", e);
			} catch (ServletException e1) {
				e1.printStackTrace();
			}
		} catch (IOException e) {
			e.printStackTrace();
		} catch (JSONException e) {
			e.printStackTrace();
		}
		
	}

	/*
	 * 대상 경로의 파일이 중복될경우 Unique이름을 생성한다.
	 * parameter : Path, FileName
	 * Return      : Path + FileName
	 * Author      : TJ
	 */
	private String getUniqueName(String _p,String _f)
	{
		//파일이름 버퍼
		String m_f = _f;
		
		//파일 반복수
		int m_fileCount = 1;
		
		while(new File(_p+m_f).exists()){
			
			//파일이름을 확장자와 분리한다.
			String[] _sf = m_f.split("\\.");
			
			// 이미 파일 이름에 카운트가 있을경우 파일이름만 분리한다.
			if (_sf[0].indexOf("(")>0)
			{
				_sf[0] = _sf[0].substring(0, _sf[0].indexOf("("));
			}
			
			/*중복이되지 않도록 파일개수를 카운트 하여 더해준다. 
				확장자가 없을경우 확장자를 공백으로 치환
			*/
			
			m_f = _sf[0]+"("+String.valueOf(m_fileCount)+")."+(_sf.length>1?_sf[1]:"");
			
			//파일 중복 카운트
			m_fileCount++;
		}
		
		return _p+m_f;
	}
	/*
	 * 파일정보를 DB에 저장한다.
	 * Parameter : MTO 파일정보
	 *                 Size, 경로(dp)원파일이름(of),저장파일이름(df),
	 * Return      : void
	 * Author      : TJ                
	 */
	private void saveFileInfo(MTO _fi) throws Exception
	{
		// 메인 데이타베이스로 설정된 커낵션을 얻을 경우
        MasterTx  mTx = null;
        try{
        mTx =new MasterTx(ConnectionManager.getInstance().getConnection());
        
        Tactics tactics = TacticsFactory.getInstance(mTx);
		
        tactics.insert("CommonFile.FILE_INSERT", _fi);
        
        mTx.commit();
        mTx.close();
        }catch(Exception e){
        	try{
        		mTx.close();
        	}catch(Exception e1){
        		mTx = null;
        	}
        	throw e;
        }
        
	}
}
