package com.ddta.base.wrap;
/**
 * <pre>
 *  Output 을 Json으로 변환 해준다.
 *
 *  개발자              : 박상민
 *
 *  작성날짜            : 2014-04-16
 *
 *  유스케이스 명       : Json2
 *  유스케이스 아이디   : com.ddws.base.wrap.OPCustomJson
 *  이벤트 명           : Json2
 *  이벤트 아이디       : 
 *  설계자              : 이태종
 *
 *  업무 유형           : Tx
 *  입력 채널 유형      : AJAX
 *  출력 채널 유형      : JSON2
 *  출력 URL            :
 *
 *  비고                : 
 * </pre>
 */
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import com.cni.fw.arch.smb.cc.WebOutControl;

import com.cni.fw.ff.dto.impl.ImplCauseDTO;
import com.cni.fw.ff.dto.impl.ImplEffectDTO;

import com.cni.fw.ff.exception.FrameException;
import com.cni.fw.ff.exception.ServiceException;


public class OPCustomJson extends WebOutControl 
{

   
    public OPCustomJson(Class clazz) {
        super(clazz);
        // TODO Auto-generated constructor stub
    }

    @Override
    public void process(ImplCauseDTO input, ImplEffectDTO output, HttpServletRequest request, HttpServletResponse response) throws FrameException, ServiceException 
    {
        PrintWriter writer = null;
        
        //DAFrame에서 Map을 가져올경우 LTO 의 프로퍼티까지 같이 가져오므로 해당 문자열을 제거하고 
        // Json배열만 생성한다.
        String s_return = output.getMaster().get("result").replace("{\"a\":","").replace(",\"b\":\"R\"}","");
        
        
        response.setCharacterEncoding("UTF-8");
        try
        {
            writer = response.getWriter();

            writer.write(s_return);
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
            output.setSkipNextStep(true);
        }
        
    }

    @Override
    public void errorProcess(ImplCauseDTO arg0, ImplEffectDTO arg1,
            HttpServletRequest arg2, HttpServletResponse arg3)
            throws FrameException, ServiceException {
        // TODO Auto-generated method stub
        
    }
}
