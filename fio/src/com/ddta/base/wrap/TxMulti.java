package com.ddta.base.wrap;

import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.cni.fw.arch.smb.cc.WebOutControl;
import com.cni.fw.arch.tx.MasterTx;
import com.cni.fw.db.cdq.tactics.query.Tactics;
import com.cni.fw.db.cdq.tactics.query.TacticsFactory;
import com.cni.fw.db.core.connect.ConnectionManager;
import com.cni.fw.ff.dto.entity.LTO;
import com.cni.fw.ff.dto.entity.MTO;
import com.cni.fw.ff.dto.impl.ImplCauseDTO;
import com.cni.fw.ff.dto.impl.ImplEffectDTO;
import com.cni.fw.ff.exception.FrameException;
import com.cni.fw.ff.exception.ServiceException;
import com.ddta.base.model.FileInfo;
import com.ddta.base.util.JsonUtil;
import com.ddta.base.util.SendMail;

/**
 * <pre>
 *  Sql Execute Login (DDTA000.M05)
 *
 *  개발자              : 이태종
 *
 *  작성날짜            : 20140417
 *
 *  유스케이스 명       : Sql executer
 *  유스케이스 아이디   : DDTA000
 *  이벤트 명           : Sql executer
 *  이벤트 아이디       : M05
 *  설계자              : 이태종
 *
 *  업무 유형           : Page
 *  입력 채널 유형      : AJAX
 *  출력 채널 유형      : TXM
 *  출력 URL            :
 *
 *  비고                : 파라메터 배열로 들어온 Sql Id를 실행 한다.
 *                        에러가 발생하면 전체 RollBack
 *                        command : C=Create U:Update D:Delete 
 *                        sqlId   : namespace.Tsql 
 * </pre>
 */

public class TxMulti extends WebOutControl{

    
    public TxMulti(Class clazz) 
    {
        super(clazz);
    }
   
    @Override
    public void process(ImplCauseDTO input, ImplEffectDTO output, HttpServletRequest request, HttpServletResponse response) throws FrameException, ServiceException
    {
        PrintWriter writer = null;
        
        if (output.getSecondUrl() != null)
        {
            debug("[SKIP] 동작중 대체 URL이 설정되면 JSON 출력 처리를 생략함");
            return;
        }
        
        // 웹 Json파라메터를 Map으로 변환        
        JSONArray param = null;
        
        // 메인 데이타베이스로 설정된 커넥션을 얻을 경우
        MasterTx  mTx = null;
        
        
        try {
        	mTx = new MasterTx(ConnectionManager.getInstance().getConnection());
            //자동 commit을 중지하고 직접 제어한다.
            mTx.setAutoCommit(false);
        
            // 웹 Json파라메터를 Map으로 변환
            param = new JSONArray(input.get("param"));
            
            //masterTx에서 tactice값을 가져온다.
            Tactics tactics = TacticsFactory.getInstance(mTx);
            
            for (int i =0;i < param.length();i++)
            {
                try {
                    JSONObject obj = param.getJSONObject(i);

                    //tactics로 전송할 MTO 변수를 생성한다.
                    MTO _m = new MTO();
                    //json객체를 MTO의 map으로 저장한다.
                    _m.setMap((HashMap) JsonUtil.JsonToMap(obj.toString()));
                    
                    
                    //Insert
                    if ("C".equals(obj.get("command").toString()))
                    {
                        tactics.insert(obj.get("sqlId").toString(), _m);
                    }
                    
                    //Update
                    if ("U".equals(obj.get("command").toString()))
                    {
                        tactics.update(obj.get("sqlId").toString(), _m);
                    }
                    
                    //Delete
                    if ("D".equals(obj.get("command").toString()))
                    {
                        tactics.delete(obj.get("sqlId").toString(), _m);
                    }
                    // Mail -- 첨부파일은 지원 하지 않음
                    if("Mail".equals(obj.get("command").toString())){
                    	
                    	//tactics.select(_seq.get("seq").toString(), null).get(_seq.get("seqId").toString()).toString();
                    	                    	
                    	//메일 발송 객체 선언
                		SendMail _mail = new SendMail();
                		
                		//메일 제목 누락
                		if (obj.get("subject") == null) {
                			output.put("result",JsonUtil.OneStringToJson("Subject missing!"));
                			return;
                		}
                		//발송자 누락
                		if (obj.get("from") == null) {
                			output.put("result",JsonUtil.OneStringToJson("mail sender missing!"));
                			return;
                		}
                		//수신자 누락
                		if (obj.get("to") == null) {
                			output.put("result",JsonUtil.OneStringToJson("mail receiver missing!"));
                			return;
                		}
                		
                		//내용 누락
                		if (obj.get("contents") == null) {
                			output.put("result",JsonUtil.OneStringToJson("mail contens missing!"));
                			return;
                		}
                		
                		// 메일 내용에 추가 부분이 있을 경우 내용을 채워서 다시 넣어준다.
                		if(obj.get("mergeSqlId") != null && !obj.get("mergeSqlId").equals("")){
                			obj.put("contents", meargeContent(tactics, obj));
                		}
                		
                		
                		//메일 제목
                		_mail.setMSubject(obj.get("subject").toString());
                		//메일 발송자
                		_mail.setFrom(obj.get("from").toString());
                		//메일 수신자
                		_mail.setTo(obj.get("to").toString());
                		
                		//메일 참조
                		if (obj.get("ccm") != null){
                			_mail.setCcm(obj.get("ccm").toString());
                		}
                		                		
                		//메일 내용
                		_mail.setContents(obj.get("contents").toString());

                		//메일 발송
                		_mail.send();
                    }
                    		
                    		
                    
                } catch (Exception e) {
                    
                    try {
                        e.printStackTrace();
                        mTx.rollback();
                        errorProcess( input,  output,  request,  response);
                        break;
                    } catch (SQLException e1) {
                        // TODO Auto-generated catch block
                        errorProcess( input,  output,  request,  response);
                        break;
                    }
    
                }
            }
            
            mTx.commit();
            
        } catch (JSONException je) {
        	try{
        		mTx.close();
        	}catch(Exception e){
        		mTx = null;
        	}
            errorProcess( input,  output,  request,  response);
            
        }catch (SQLException e) {
           try {
                mTx.rollback();
                mTx.close();
            } catch (SQLException e1) {
            	mTx = null;
                // TODO Auto-generated catch block
                e1.printStackTrace();
                errorProcess( input,  output,  request,  response);
            }
                    
        }catch(Exception e){
        	try{
        		mTx.close();
        	}catch(Exception e1){
        		mTx = null;
        	}
        	e.printStackTrace();
        }
        
        response.setCharacterEncoding("UTF-8");
        try
        {
            writer = response.getWriter();

            writer.write(JsonUtil.OneStringToJson("SUCCESS"));
        }
        catch (Exception e)
        {
            errorProcess( input,  output,  request,  response);
        }
        finally
        {
            if (writer != null)
            {
                writer.close();
            }
            try {
                mTx.close();
            } catch (SQLException e2) {
            	mTx = null;
                // TODO Auto-generated catch block
                e2.printStackTrace();
            }
        }
    }
    
    @Override
    public void errorProcess(ImplCauseDTO input, ImplEffectDTO output, HttpServletRequest request, HttpServletResponse response)
            throws FrameException, ServiceException
    {
        //process(input, output, request, response);

        PrintWriter writer = null;
        
        response.setCharacterEncoding("UTF-8");
        try
        {
            writer = response.getWriter();

            writer.write(JsonUtil.OneStringToJson("FAILED"));
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

    // Merge Content;
    public String meargeContent(Tactics t, JSONObject obj) throws Exception{
    	String content = "";
    	try{
    		content = obj.get("contents").toString();
    		
    		//tactics로 전송할 MTO 변수를 생성한다.
            MTO _m = new MTO();
            //json객체를 MTO의 map으로 저장한다.
            _m.setMap((HashMap) JsonUtil.JsonToMap(obj.toString()));
    		
    		MTO r = t.select(obj.getString("mergeSqlId"), _m);
    		
    		JSONObject keys = (JSONObject)obj.get("mergeTarget");
    		for(int i = 0 ; i < keys.names().length(); i++){
    			String key = String.valueOf(keys.names().get(i));
    			content = content.replaceAll(("§" + key + "§"), r.get(key).toString());
    		}
    	
    	}catch(Exception e){
    		throw e;
    	}
    	return content;
    
    }
    
}
