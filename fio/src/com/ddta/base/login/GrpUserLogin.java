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
 *  로그인 Login (DBDW000.M02)
 *
 *  개발자              : 이태종
 *
 *  작성날짜            : 20140917
 *
 *  유스케이스 명       : 로그인
 *  유스케이스 아이디   : DBDW000
 *  이벤트 명           : Login
 *  이벤트 아이디       : M02
 *  설계자              : 홍성인
 *
 *  업무 유형           : Tx
 *  입력 채널 유형      : AJAX
 *  출력 채널 유형      : WBSL
 *  출력 URL            :
 *
 *  비고                : 로그인후 Session 관리를 위해 SMLoginWebBase를 통해 Web Session설정
 * </pre>
 */

public class GrpUserLogin extends NormalTxService{
	 public GrpUserLogin(Class clazz) throws FrameException
	{
	    super(clazz);
	}
	 
	@Override
    protected void process(CauseDTO input, EffectDTO output) throws FrameException, ServiceException, SQLException
    {
        // 웹 Json파라메터를 Map으로 변환
        Map<String, Object> param = JsonUtil.JsonToMap(input.get("param"));

        Tactics tactics = TacticsFactory.getInstance(input.getTx());

        MTO clauseMto = new MTO();
        clauseMto.put("userId", param.get("userId").toString());

        // 세션 개체 생성
        CommonSession cs = input.getCommonSession();

        // 패스워드 일치여부를 확인한다.
        MTO resList = tactics.select("Login.GrpLogin", clauseMto);

        if (resList.size() == 0)
        {
            output.setMessage("'id' 와 'Password'가 일치하지 않습니다.");
            output.setLogin(false);
            clauseMto.put("password", "");
            cs.setDataMap(clauseMto);
        }
        else
        {
            // 로그인 성공
            cs.put("USERID", param.get("userId").toString()); // 실제 사용할 USERID
            cs.put("DATE", DateUtil.getToday());
            cs.setDataMap(resList);
            
            cs.setUserId(param.get("userId").toString()); // 로그상 혹은 통계상 USERID를 FW가 인식할수 있도록 세팅해준다.
            cs.setLogIn(true); // 로그인 된것으로 설정한다.

            // 최종 로그인 일자 Update
            tactics.insert("Login.LoginUpdate", clauseMto);
            
            // 로그인 히스토리
            clauseMto.put("siteCode","10008");	// 사이트코드
            clauseMto.put("userIp",cs.getUserIp());	// Ip Address
            tactics.update("Login.AddLoginHistory", clauseMto);

            output.setLogin(true);
            output.setMessage(param.get("userId").toString() + "님 환영합니다.");
        }
    }
}
