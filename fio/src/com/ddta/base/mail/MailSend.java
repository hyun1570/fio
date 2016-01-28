package com.ddta.base.mail;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.cni.fw.arch.smb.ac.NormalTxService;
import com.cni.fw.db.cdq.tactics.query.Tactics;
import com.cni.fw.db.cdq.tactics.query.TacticsFactory;
import com.cni.fw.ff.dto.CauseDTO;
import com.cni.fw.ff.dto.EffectDTO;
import com.cni.fw.ff.dto.entity.LTO;
import com.cni.fw.ff.dto.entity.MTO;
import com.cni.fw.ff.exception.FrameException;
import com.cni.fw.ff.exception.ServiceException;
import com.ddta.base.model.FileInfo;
import com.ddta.base.util.JsonUtil;
import com.ddta.base.util.SendMail;

public class MailSend extends NormalTxService{

	public MailSend(Class clazz) throws FrameException {
		super(clazz);
	}

	@Override
	protected void process(CauseDTO input, EffectDTO output) throws FrameException, ServiceException, SQLException {

		//메일 발송 객체 선언
		SendMail _mail = new SendMail();
		
		//메일 제목 누락
		if (input.get("subject") == null) {
			output.put("result",JsonUtil.OneStringToJson("Subject missing!"));
			return;
		}
		//발송자 누락
		if (input.get("from") == null) {
			output.put("result",JsonUtil.OneStringToJson("mail sender missing!"));
			return;
		}
		//수신자 누락
		if (input.get("to") == null) {
			output.put("result",JsonUtil.OneStringToJson("mail receiver missing!"));
			return;
		}
		
		//내용 누락
		if (input.get("contents") == null) {
			output.put("result",JsonUtil.OneStringToJson("mail contens missing!"));
			return;
		}
		
		//메일 제목
		_mail.setMSubject(input.get("subject").toString());
		//메일 발송자
		_mail.setFrom(input.get("from").toString());
		//메일 수신자
		_mail.setTo(input.get("to").toString());
		
		//메일 참조
		if (input.get("ccm") != null)
			_mail.setCcm(input.get("ccm").toString());
		
		//메일 내용
		_mail.setContents(input.get("contents").toString());
		
		//파일 첨부가 있을경우
		if (input.get("attach")!=null)
		{
			
			// Tactics 선언 파일 목록을 가져오기 위함
			Tactics tactics = TacticsFactory.getInstance(input.getTx());
	
			//selectList 파라메터 선언
			MTO _m = new MTO();
			
			//파일 첨부 조건을 Json Object로 변환한다
			Map<String, Object> param = JsonUtil.JsonToMap(input.get("attach"));
			
			for (Map.Entry<String, Object> keyValue : param.entrySet())
	        {
				//파일 목록의 조건을 MTO로 만든다.
				_m.put(keyValue.getKey(), keyValue.getValue().toString());
	        }
			
			LTO resList = tactics.selectList("CommonFile.FILE_LIST", _m);
			
			//파일 정보 배역
			List<FileInfo> _f = new ArrayList( );
	
			//게시판에 첨부파일이 있을경우
			for (int i=0;i<resList.size();i++)
			{
				FileInfo _t = new FileInfo();
				
				MTO _mm = resList.get(i);
						
				_t.setFileLocation(_mm.get("filePath")+_mm.get("saveFileName")); //파일경로
				
				_t.setFileName(_mm.get("origFileName"));                                 // 원본파일 이름
				
				_t.setFileSize(_mm.get("fileSize"));                                          //파일 사이즈
				
				// 파일 목록 추가
				_f.add(_t);
				
				// 파일 목록을 메일에 지정
				_mail.setFileList(_f);
			}
		}
		
		//메일 발송
		_mail.send();
		
		output.put("result",JsonUtil.OneStringToJson("SUCCESS"));
	}

}
