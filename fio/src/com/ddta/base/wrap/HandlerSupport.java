package com.ddta.base.wrap;

import java.lang.annotation.ElementType;
import java.lang.annotation.Target;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cni.fw.arch.smb.cc.WebOutControl;
import com.cni.fw.ff.dto.impl.ImplCauseDTO;
import com.cni.fw.ff.dto.impl.ImplEffectDTO;
import com.cni.fw.ff.exception.FrameException;
import com.cni.fw.ff.exception.ServiceException;

public class HandlerSupport extends WebOutControl
{

    public HandlerSupport(Class clazz)
    {
        super(clazz);
    }

    @Target(ElementType.METHOD)
    public @interface INPUT_CHANNEL { 
    	String userId();
    }
    @Override
    public void process(ImplCauseDTO input, ImplEffectDTO output, HttpServletRequest request, HttpServletResponse response) throws FrameException, ServiceException
    {
        // 메뉴 핸들러에서 접근할수 있도록 input request를 저장 한다.
        request.setAttribute("WEB_INPUT_DTO", input);
        
    }

    @Override
    public void errorProcess(ImplCauseDTO input, ImplEffectDTO output, HttpServletRequest request, HttpServletResponse response) throws FrameException, ServiceException
    {
        // 예외처리도 정상처리시와 동일한 로직으로 처리한다.
        process(input, output, request, response);
    }
}
