package com.ddta.base.service;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import com.cni.fw.arch.smb.ac.NormalTxService;
import com.cni.fw.db.cdq.tactics.query.Tactics;
import com.cni.fw.db.cdq.tactics.query.TacticsFactory;
import com.cni.fw.ff.dto.CauseDTO;
import com.cni.fw.ff.dto.EffectDTO;
import com.cni.fw.ff.dto.entity.ATO;
import com.cni.fw.ff.dto.entity.MTO;
import com.cni.fw.ff.exception.FrameException;
import com.cni.fw.ff.exception.ServiceException;
import com.cni.fw.web.data.file.FileData;
import com.ddta.base.util.JsonUtil;

/**
 * <pre>
 *  파일업로드 공통 (DDWS.BASE.SERVICE.R00)
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
public class FileUpLoadService extends NormalTxService
{
    /**
     * FuncName : SelectService()
     * FuncDesc : 생성자
     * Param    :
     * Return   :
     * Author   : 박상민
     * History  : 2014-04-10
    */
    public FileUpLoadService(Class clazz) throws FrameException
    {
        super(clazz);
    }


    /**
     * FuncName : process()
     * FuncDesc : 파일업로드 공통
     * Param    : param : Parameter
     * Return   :
     * Author   : 박상민
     * History  : 2014-04-10
    */
    @Override
    protected void process(CauseDTO input, EffectDTO output) throws FrameException, ServiceException, SQLException
    {
        int index   = 1;
        int iResult = 0;
        String sFilePath = "";
        String sFileName = "";
        String sFileOrgi = "";
        String sFileSize = "";

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

        ATO fileAto = input.getATO("file");

        debug("boardId = [" + input.get("param") + "]");

        if (fileAto != null)
        {
            for (int i=0; i<fileAto.size(); i++)
            {
                FileData fileData = (FileData) fileAto.getObject(i);

                if ((fileData != null) && (fileData.getName() != null) && (fileData.getName().length() > 0))
                {
                    long time = System.currentTimeMillis();
                    SimpleDateFormat datePath = new SimpleDateFormat("yyyy-MM-dd");
                    SimpleDateFormat dateTime = new SimpleDateFormat("yyyy-MM-dd-HH-mm-ss");

                    // 원본파일명
                    sFileOrgi = fileData.getName();

                    // 파일 저장 경로
                    sFilePath = "c:\\temp\\" + datePath.format(new Date()) + "\\";

                    // 파일 저장 명
                    sFileName = dateTime.format(new Date(time)) + index + fileData.getName();

                    sFileSize = String.valueOf(fileData.getSize());

                    debug("파일명 = [" + fileData.getName() + "]");

                    // 파일 저장
                    fileData.write(sFilePath + sFileName, false);
                }
            }
        }

        mto.put("filePath",         sFilePath);
        mto.put("origFileName",     sFileOrgi);
        mto.put("saveFileName",     sFileName);
        mto.put("fileSize",         sFileSize);
        mto.put("downloadCount",    "0");

        iResult = tactics.insert("CommonFile.ddws_commonfile_E01", mto); // 파일 UpLoad 정보 저장

        if (iResult > 0)
        {
            output.put("result", iResult);
        }
        else
        {
            output.put("result", iResult);
        }
    }
}
