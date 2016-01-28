package com.ddta.base.wrap;

import java.io.PrintWriter;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.cni.fw.arch.smb.cc.WebOutControl;
import com.cni.fw.ff.dto.entity.MTO;
import com.cni.fw.ff.dto.impl.ImplCauseDTO;
import com.cni.fw.ff.dto.impl.ImplEffectDTO;
import com.cni.fw.ff.exception.FrameException;
import com.cni.fw.ff.exception.ServiceException;
import com.cni.fw.web.session.so.CommonSession;
import com.ddta.base.util.JsonUtil;

/**
 * <pre>
 *  로그인 Login (SMLoginWebBase)
 *
 *  개발자              : 이태종
 *
 *  작성날짜            : 20140410
 *
 *  유스케이스 명       : 로그인
 *  유스케이스 아이디   :
 *  이벤트 명           : Login
 *  이벤트 아이디       :
 *  설계자              : 이태종
 *
 *  업무 유형           : Tx
 *  입력 채널 유형      : UserLoginAC
 *  출력 채널 유형      : WBSL
 *  출력 URL            :
 *
 *  비고                : Web base Session 관리를 한다.
 * </pre>
 */
public class LoginSession extends WebOutControl
{
    public LoginSession(Class clazz)
    {
        super(clazz);
    }

    @Override
    public void process(ImplCauseDTO input, ImplEffectDTO output, HttpServletRequest request, HttpServletResponse response) throws FrameException, ServiceException
    {
        if (output.getSecondUrl() != null)
        {
            debug("[SKIP] 동작중 대체 URL이 설정되면 JSON 출력 처리를 생략함");
            return;
        }

        PrintWriter writer = null;

        // 세션 개체 선언
        CommonSession cs = input.getCommonSession();

        // 로그인시 저장한 MTO 개체를 받는다.
        MTO _so = cs.getDataMap();

        // 출력용 json용 Map
        HashMap _mp = _so.getMap();

        HttpSession session = request.getSession(true);

        session.setMaxInactiveInterval(60 * 60); // Session 시간 설정 (60 * 60 = 1시간)

        session.setAttribute("SESSION_USER_ID",         _so.get("userId"));         				// 사용자ID
        session.setAttribute("SESSION_USER_NAME",       _so.get("userName"));       		// 사용자이름
        session.setAttribute("SESSION_USER_TYPE",       _so.get("userType"));       		// 사용자구분
        session.setAttribute("SESSION_USER_CLASS",      _so.get("userClass"));      		// 사용자분류
        session.setAttribute("SESSION_TEL_NO",          _so.get("officeTel"));          			// 전화번호
        session.setAttribute("SESSION_EMAIL",           _so.get("email"));          					// 이메일
        session.setAttribute("SESSION_LAST_LOGIN_DATE", _so.get("lastLoginDate"));  	// 최종로그인일자
        session.setAttribute("SESSION_LAST_LOGIN_TIME", _so.get("lastLoginTime"));  	// 최종로그인시간
        session.setAttribute("SESSION_USER_NODE_CODE", _so.get("nodeCode"));		// 사업장코드
        session.setAttribute("SESSION_USER_ROLE_CODES", _so.get("roleCodes"));		// 사용자 롤명
        session.setAttribute("SESSION_SITE_CODE",       "10008");                   					// 사이트코드(임시)
        session.setAttribute("SESSION_ADMIN_YN",        _so.get("adminYn"));		//관리자 여부

        // 로그인 실패 성공 유무 체크
        _mp.put("status", output.isLogin());

        response.setCharacterEncoding("UTF-8");
        try
        {
            writer = response.getWriter();

            writer.write(JsonUtil.ListToJson(_mp));
        }
        catch (Exception e)
        {

            throw new FrameException(e);
        }
        finally
        {
            if (writer != null)
            {
                writer.close();
            }
        }
    }

    @Override
    public void errorProcess(ImplCauseDTO input, ImplEffectDTO output, HttpServletRequest request, HttpServletResponse response)
            throws FrameException, ServiceException
    {

        // 예외처리도 정상처리시와 동일한 로직으로 처리한다.
        process(input, output, request, response);
    }
}
