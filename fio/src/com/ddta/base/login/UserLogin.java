package com.ddta.base.login;

import java.sql.SQLException;
import java.util.Map;

import org.apache.commons.codec.binary.Base64;

import com.cni.fw.arch.smb.ac.NormalTxService;
import com.cni.fw.db.cdq.tactics.query.Tactics;
import com.cni.fw.db.cdq.tactics.query.TacticsFactory;
import com.cni.fw.ff.dto.CauseDTO;
import com.cni.fw.ff.dto.EffectDTO;
import com.cni.fw.ff.dto.entity.MTO;
import com.cni.fw.ff.exception.FrameException;
import com.cni.fw.ff.exception.ServiceException;
import com.cni.fw.ff.util.DateUtil;
import com.cni.fw.web.session.so.CommonSession;
import com.ddta.base.util.JsonUtil;

/**
 * <pre>
 *  로그인 Login (DDWS000.M02)
 *
 *  개발자              : 이태종
 *
 *  작성날짜            : 20140408
 *
 *  유스케이스 명       : 로그인
 *  유스케이스 아이디   : DDWS000
 *  이벤트 명           : Login
 *  이벤트 아이디       : M02
 *  설계자              : 이태종
 *
 *  업무 유형           : Tx
 *  입력 채널 유형      : AJAX
 *  출력 채널 유형      : WBSL
 *  출력 URL            :
 *
 *  비고                : 로그인후 Session 관리를 위해 SMLoginWebBase를 통해 Web Session설정
 * </pre>
 */
public class UserLogin extends NormalTxService
{
    public UserLogin(Class clazz) throws FrameException
    {
        super(clazz);
    }

    @Override
    protected void process(CauseDTO input, EffectDTO output) throws FrameException, ServiceException, SQLException
    {
        // 웹 Json파라메터를 Map으로 변환
        Map<String, Object> param = JsonUtil.JsonToMap(input.get("param"));

        Tactics tactics = TacticsFactory.getInstance(input.getTx());

        // 세션 개체 생성
        CommonSession cs = input.getCommonSession();
       
        MTO clauseMto = new MTO();
        
        //유저 아이디
        String _userId = input.get("userId");
        
        //언어 설정
        String _lang = input.get("lang");
        
        //사이트를 통한 로그인일 경우
        if (_userId==null)
        {
	        // BASE 64 Encoding
	        String password = new String(Base64.encodeBase64(param.get("userPassword").toString().trim().getBytes()));
	
	        clauseMto.put("userId", param.get("userId").toString());
	        clauseMto.put("password", password);
	
	        // 패스워드 일치여부를 확인한다.
	        MTO resList = tactics.select("Login.Login", clauseMto);
	
	        if (resList.size() == 0)
	        {
	            output.setMessage("'id' 와 'Password'가 일치하지 않습니다.");
	            output.setLogin(false);
	            clauseMto.put("password", "");
	            cs.setDataMap(clauseMto);
	        }
	        else
	        {
	        	//언어값이 없을경우 기본 한국어
	        	if (_lang==null || "".equals(_lang)) _lang = "KOR";
	        	
	        	//언어설정을 MTO 에 저장
		        resList.put("lang", _lang);
		        
	            // 로그인 성공
	            cs.put("USERID", param.get("userId").toString()); // 실제 사용할 USERID
	            cs.put("DATE", DateUtil.getToday());
	            cs.setDataMap(resList);
	
	            cs.setUserId(param.get("userId").toString()); // 로그상 혹은 통계상 USERID를 FW가 인식할수 있도록 세팅해준다.
	            cs.setLogIn(true); // 로그인 된것으로 설정한다.
	
	            // 최종 로그인 일자 Update
	            tactics.insert("Login.LoginUpdate", clauseMto);
	
	            output.setLogin(true);
	            output.setMessage(param.get("userId").toString() + "님 환영합니다.");
	        }
        }
	    else 
	    {
	        
	    	 // 로그인 성공
            cs.put("USERID", _userId); // 실제 사용할 USERID
            cs.put("DATE", DateUtil.getToday());

            cs.setUserId(_userId); // 로그상 혹은 통계상 USERID를 FW가 인식할수 있도록 세팅해준다.
            cs.setLogIn(true); // 로그인 된것으로 설정한다.

            //로그인 정보를 가져오기위한 유저 아이디 MTO
	    	clauseMto.put("userId", _userId);
	    	
            // 포털 로그인
	        MTO resList = tactics.select("Login.PortalLogin", clauseMto);
	        
	        //언어설정을 MTO 에 저장
	        resList.put("lang", _lang);
	        
	        //유저 데이타를 DataMap에 저장
	    	cs.setDataMap(resList);
	    	
            // 최종 로그인 일자 Update
            tactics.insert("Login.LoginUpdate", clauseMto);
            
            // 로그인 히스토리
            clauseMto.put("siteCode","10008");	// 사이트코드
            clauseMto.put("userIp",cs.getUserIp());	// Ip Address
            tactics.update("Login.AddLoginHistory", clauseMto);
            
            //Redirect Url 지정
            output.put("url", input.getCommand().getOpUrl());
            
            output.setLogin(true);
            output.setMessage(input.get("userId").toString() + "님 환영합니다.");
            
	      }
    }
}
