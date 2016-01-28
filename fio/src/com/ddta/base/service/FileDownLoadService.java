package com.ddta.base.service;

import java.sql.SQLException;
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
import com.cni.fw.id.SystemC;
import com.cni.fw.web.data.file.SendFileData;
import com.ddta.base.util.JsonUtil;

/**
 * <pre>
 *  파일다운로드 공통 (DDWS.BASE.SERVICE.R00)
 *
 *  개발자              : 박상민
 *
 *  작성날짜            : 2014-04-09
 *
 *  유스케이스 명       : 조회 공통
 *  유스케이스 아이디   : DDWS.BASE.SERVICE
 *  이벤트 명           : 조회 공통
 *  이벤트 아이디       : R00
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
public class FileDownLoadService extends NormalTxService
{
    /**
     * FuncName : SelectService()
     * FuncDesc : 생성자
     * Param    :
     * Return   :
     * Author   : 박상민
     * History  : 2014-04-10
    */
    public FileDownLoadService(Class clazz) throws FrameException
    {
        super(clazz);
    }


    /**
     * FuncName : process()
     * FuncDesc : 파일다운로드 공통
     * Param    : param : Parameter
     * Return   :
     * Author   : 박상민
     * History  : 2014-04-10
    */
    @Override
    protected void process(CauseDTO input, EffectDTO output) throws FrameException, ServiceException, SQLException
    {
        Map<String, Object> param = JsonUtil.JsonToMap(input.get("param"));

        Tactics tactics = TacticsFactory.getInstance(input.getTx());

        MTO mto = new MTO();

        // Parameter 값 체크 확인
        debug("--------------- Key Start ---------------");
        for (Map.Entry<String, Object> keyValue : param.entrySet())
        {
            mto.put(keyValue.getKey(), keyValue.getValue().toString());
            debug("Key  =[" + keyValue.getKey() + "]");
            debug("Value=[" + keyValue.getValue() + "]");
            debug("---------------------------------");
        }
        debug("--------------- Key End ---------------");

        LTO resList = tactics.selectList("CommonFile.ddws_commonfile_M01", mto);

        List<Map<String, Object>> jsonList = resList.getList();

        // 요소가져오기
        for (int i=0; i<resList.size(); i++)
        {
            String sFilePath = resList.get(i).get("filePath").toString();       // 파일경로
            String sFileName = resList.get(i).get("saveFileName").toString();   // 파일저장명
            String sFileOrgi = resList.get(i).get("origFileName").toString();   // 파일실제명

            SendFileData sendFileData = null;

            sendFileData = new SendFileData(sFileOrgi, sFilePath + sFileName);

            output.getSystem().putObject(SystemC.DOWNLOAD_FILE, sendFileData);
        }
    }
}
