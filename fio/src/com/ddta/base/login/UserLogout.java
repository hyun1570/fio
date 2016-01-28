package com.ddta.base.login;

import java.sql.SQLException;

import com.cni.fw.arch.smb.ac.BasicService;
import com.cni.fw.arch.tx.MasterTx;
import com.cni.fw.db.cdq.tactics.query.Tactics;
import com.cni.fw.db.cdq.tactics.query.TacticsFactory;
import com.cni.fw.db.core.connect.ConnectionManager;
import com.cni.fw.ff.dto.CauseDTO;
import com.cni.fw.ff.dto.EffectDTO;
import com.cni.fw.ff.dto.entity.MTO;
import com.cni.fw.ff.exception.FrameException;
import com.cni.fw.ff.exception.ServiceException;
import com.cni.fw.web.session.so.CommonSession;

/**
 * <pre>
 *  로그아웃 Login (DDWS000.M06)
 *
 *  개발자              : 이태종
 *
 *  작성날짜            : 20140408
 *
 *  유스케이스 명       : 로그아웃
 *  유스케이스 아이디   : DDWS000
 *  이벤트 명           : Login
 *  이벤트 아이디       : M07
 *  설계자              : 이태종
 *
 *  업무 유형           : Page
 *  입력 채널 유형      : WEB
 *  출력 채널 유형      : JSP
 *  출력 URL            :
 *
 *  비고                : 로그아웃
 * </pre>
 */
public class UserLogout extends BasicService
{
    public UserLogout(Class clazz) throws FrameException
    {
        super(clazz);
    }

    @Override
    protected void process(CauseDTO input, EffectDTO output) throws FrameException, ServiceException, SQLException
    {
        // 세션 개체 생성
        CommonSession cs = input.getCommonSession();

//        MasterTx  mTx = new MasterTx(ConnectionManager.getInstance().getConnection());
//
//        Tactics tactics = TacticsFactory.getInstance(mTx);

        MTO clauseMto = new MTO();
        clauseMto.put("userId", cs.getUserId());

        // 최종 로그인 일자 Update
//        tactics.insert("Login.LoginUpdate", clauseMto);

        // 로그 아웃 된것으로 설정한다.
        cs.setLogOut(true);
    }
}
