package com.ddta.base.service;

import java.sql.SQLException;

import com.cni.fw.arch.smb.ac.BasicService;
import com.cni.fw.ff.conf.AppConfig;
import com.cni.fw.ff.dto.CauseDTO;
import com.cni.fw.ff.dto.EffectDTO;
import com.cni.fw.ff.exception.FrameException;
import com.cni.fw.ff.exception.ServiceException;
/*
 * 세션 만료시 페이지를 redirection.url 프로퍼티에 정의된 Url롤 이동시킨다. 
 * application.conf 파일에 기록
 */
public class SessionExpired extends BasicService{

	public SessionExpired(Class clazz) throws FrameException {
		super(clazz);
		// TODO Auto-generated constructor stub
	}

	@Override
	protected void process(CauseDTO input, EffectDTO output)throws FrameException, ServiceException, SQLException {

		output.put("url", AppConfig.get("redirection.url"));
	}

}
