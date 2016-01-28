package com.ddta.base.service;

import java.sql.SQLException;
import java.util.Map;

import com.cni.fw.arch.smb.ac.NormalTxService;
import com.cni.fw.db.cdq.tactics.query.Tactics;
import com.cni.fw.db.cdq.tactics.query.TacticsFactory;
import com.cni.fw.ff.dto.CauseDTO;
import com.cni.fw.ff.dto.EffectDTO;
import com.cni.fw.ff.dto.entity.MTO;
import com.cni.fw.ff.exception.FrameException;
import com.cni.fw.ff.exception.ServiceException;
import com.ddta.base.util.JsonUtil;

/**
 * <pre>
 *  등록 공통 등록 공통 (DDTA.BASE.SERVICE.C00)
 *
 *  개발자              : 박상민
 *
 *  작성날짜            : 20140409
 *
 *  유스케이스 명       : 등록 공통
 *  유스케이스 아이디   : DDTA.BASE.SERVICE
 *  이벤트 명           : 등록 공통
 *  이벤트 아이디       : C00
 *  설계자              : 박상민
 *
 *  업무 유형           : Tx
 *  입력 채널 유형      : AJAX
 *  출력 채널 유형      : JSON
 *  출력 URL            :
 *
 *  비고                : Econet
 * </pre>
 */
public class InsertService extends NormalTxService
{
    /**
     * FuncName : InsertService()
     * FuncDesc : 생성자
     * Param    :
     * Return   :
     * Author   : 박상민
     * History  : 2014-04-10
    */
    public InsertService(Class clazz) throws FrameException
    {
        super(clazz);
    }


    /**
     * FuncName : process()
     * FuncDesc : 등록 공통
     * Param    : param : Parameter
     * Return   :
     * Author   : 박상민
     * History  : 2014-04-10
    */
    @Override
    protected void process(CauseDTO input, EffectDTO output) throws FrameException, ServiceException, SQLException
    {
        int iResult = 0;

        Map<String, Object> param = JsonUtil.JsonToMap(input.get("param"));

        Tactics tactics = TacticsFactory.getInstance(input.getTx());

        MTO mto = new MTO();

        // Parameter 값 체크 확인
        System.out.println("--------------- Key Start ---------------");
        for (Map.Entry<String, Object> keyValue : param.entrySet())
        {
            mto.put(keyValue.getKey(), keyValue.getValue().toString());
            System.out.println("Key  =[" + keyValue.getKey() + "]");
            System.out.println("Value=[" + keyValue.getValue() + "]");
            System.out.println("---------------------------------");
        }
        System.out.println("--------------- Key End ---------------");

        iResult = tactics.insert(mto.get("sqlid"), mto);

        if (iResult > 0)
        {
            output.put("result", JsonUtil.OneStringToJson("SUCCESS"));
        }
        else
        {
            output.put("result", JsonUtil.OneStringToJson("FAIL"));
        }
    }
}
