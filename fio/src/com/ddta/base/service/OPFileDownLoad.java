package com.ddta.base.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.SQLException;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cni.fw.arch.smb.cc.WebOutControl;
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

public class OPFileDownLoad extends WebOutControl {

	public OPFileDownLoad(Class clazz) { 
		super(clazz);
	}

	@SuppressWarnings("deprecation")
	@Override
	public void process(ImplCauseDTO input, ImplEffectDTO output, HttpServletRequest request, HttpServletResponse response) throws FrameException, ServiceException 
	{
		MasterTx  mTx  = null;
		
		Tactics tactics = null;
		
		MTO _mto = null;
		
		ServletOutputStream outStream = null;
		
		FileInputStream inputStream = null;
		try {	
				// 메인 데이타베이스로 설정된 커낵션을 얻을 경우
		        mTx = new MasterTx(ConnectionManager.getInstance().getConnection());
		        
		        tactics = TacticsFactory.getInstance(mTx);
		        
		        //레퍼런스1
				String _fileAttachId = request.getParameter("fileAttachId");
				
				_mto = new MTO();
				
		        //유저 ID를 mto에 설정한다.
		        _mto.put("fileAttachId", _fileAttachId);
		        
		        //그리드 목록이 있는지 확인 하고 gridSet에 정의해서 Client로 넘긴다.
		        LTO resList = tactics.selectList("CommonFile.FILE_LIST", _mto);
		        
		        String _df = resList.get(0).get("filePath") + "\\"+resList.get(0).get("saveFileName");
		        
				File downfile = new File(_df);
		
				if(!downfile.exists()) {
				        try {
							throw new FileNotFoundException();
						} catch (FileNotFoundException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
				}
	
					
				String userAgent = request.getHeader("User-Agent");
				boolean ie = userAgent.indexOf("MSIE") > -1;
		       

				String _downloadFileName = "";// new String(resList.get(0).get("origFileName").getBytes("euc-kr"),"8859_1");
				
		        if(ie)
		        {
		        	_downloadFileName = URLEncoder.encode(resList.get(0).get("origFileName"), "UTF-8");
		        }
		        else
		        {
		        	_downloadFileName = new String((resList.get(0).get("origFileName")).getBytes("UTF-8"), "ISO-8859-1");
		        }
				
		        outStream = response.getOutputStream();
		        
		        inputStream = new FileInputStream(downfile);               

		        response.setHeader("Content-Disposition","attachment;filename=\""+_downloadFileName+"\"");
		        response.setHeader("Content-Transfer-Encoding", "binary");
		        
		        byte[] outByte = new byte[4096];

		        while(inputStream.read(outByte, 0, 4096) != -1)
		        {
		          outStream.write(outByte, 0, 4096);
		        }

		} catch (Exception e) {

		        try {
					throw new IOException();
				} catch (IOException e1) {
					e1.printStackTrace();
				}

		} finally {

		        try {
		        	tactics.update("CommonFile.FILE_INC_CNT", _mto);
		        	mTx.commit();
					inputStream.close();
					outStream.flush();
					outStream.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
		        
		        try {
					mTx.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					mTx = null;
				}
		}		
	}
	
	@Override
	public void errorProcess(ImplCauseDTO arg0, ImplEffectDTO arg1,HttpServletRequest arg2, HttpServletResponse arg3) throws FrameException, ServiceException {
		
	}

}
