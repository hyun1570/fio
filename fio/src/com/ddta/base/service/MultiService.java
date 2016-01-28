package com.ddta.base.service;

import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;

import com.cni.fw.arch.smb.cc.WebOutControl;
import com.cni.fw.arch.tx.MasterTx;
import com.cni.fw.db.cdq.tactics.query.Tactics;
import com.cni.fw.db.cdq.tactics.query.TacticsFactory;
import com.cni.fw.db.core.connect.ConnectionManager;
import com.cni.fw.ff.dto.entity.MTO;
import com.cni.fw.ff.dto.impl.ImplCauseDTO;
import com.cni.fw.ff.dto.impl.ImplEffectDTO;
import com.cni.fw.ff.exception.FrameException;
import com.cni.fw.ff.exception.ServiceException;
import com.ddta.base.util.JsonUtil;

/**
 * <pre>
 *  멀티 공통 멀티 공통 (DDTA.BASE.SERVICE.X00)
 *
 *  개발자              : 박상민
 *
 *  작성날짜            : 20140409
 *
 *  유스케이스 명       : 멀티 공통
 *  유스케이스 아이디   : DDTA.BASE.SERVICE
 *  이벤트 명           : 멀티 공통
 *  이벤트 아이디       : X00
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
public class MultiService extends WebOutControl
{
    public MultiService(Class clazz)
    {
        super(clazz);
    }

    @Override
    public void process(ImplCauseDTO input, ImplEffectDTO output, HttpServletRequest request, HttpServletResponse response) throws FrameException, ServiceException
    {
        int iResult  = 0;

        PrintWriter writer = null;
        MasterTx  mTx  = null;
        try
        {
            System.out.println("---------------- MultiService Start -------------------");


            JSONArray jsonArray1 = new JSONArray(input.get("param1").toString());
            //System.out.println("MultiTransaction jsonArray1 Length = [" + jsonArray1.length() + "]");
            JSONArray jsonArray2 = new JSONArray(input.get("param2").toString());
            //System.out.println("MultiTransaction jsonArray2 Length = [" + jsonArray2.length() + "]");
            JSONArray jsonArray3 = new JSONArray(input.get("param3").toString());
            //System.out.println("MultiTransaction jsonArray3 Length = [" + jsonArray3.length() + "]");
            JSONArray jsonArray4 = new JSONArray(input.get("param4").toString());
            //System.out.println("MultiTransaction jsonArray4 Length = [" + jsonArray4.length() + "]");

            int iLength1 = jsonArray1.length();
            int iLength2 = jsonArray2.length();
            int iLength3 = jsonArray3.length();
            int iLength4 = jsonArray4.length();

            // 메인 데이타베이스로 설정된 커넥션을 얻을 경우
            mTx = new MasterTx(ConnectionManager.getInstance().getConnection());

            // 자동 Commit을 중지하고 직접 제어한다.
            mTx.setAutoCommit(false);

            try
            {
                //masterTx에서 tactice값을 가져온다.
                Tactics tactics = TacticsFactory.getInstance(mTx);

                // 첫번째 처리
                for (int i=0; i<iLength1; i++)
                {
                    JSONObject jsonObject1 = jsonArray1.getJSONObject(i);

                    Map<String, Object> param1 = JsonUtil.JsonToMap(jsonObject1.toString());

                    MTO mto = new MTO();

//                    // Parameter 값 체크 확인
//                    System.out.println("--------------- Key Start ---------------");
//                    for (Map.Entry<String, Object> keyValue : param1.entrySet())
//                    {
//                        mto.put(keyValue.getKey(), keyValue.getValue().toString());
//                        System.out.println("Key  =[" + keyValue.getKey() + "]");
//                        System.out.println("Value=[" + keyValue.getValue() + "]");
//                        System.out.println("---------------------------------");
//                    }
//                    System.out.println("--------------- Key End ---------------");

                    if (param1.get("rowStatus").toString().equals("C") == true) // Insert
                    {
                        iResult = tactics.insert(mto.get("sqlid"), mto);
                    }
                    else if (param1.get("rowStatus").toString().equals("U") == true) // Update
                    {
                        iResult = tactics.update(mto.get("sqlid"), mto);
                    }
                    else if (param1.get("rowStatus").toString().equals("D") == true) // Delete
                    {
                        iResult = tactics.delete(mto.get("sqlid"), mto);
                    }

                    iResult++;
                }

                // 두번째 처리
                for (int i=0; i<iLength2; i++)
                {
                    JSONObject jsonObject2 = jsonArray2.getJSONObject(i);

                    Map<String, Object> param2 = JsonUtil.JsonToMap(jsonObject2.toString());

                    MTO mto = new MTO();

//                    // Parameter 값 체크 확인
//                    System.out.println("--------------- Key Start ---------------");
//                    for (Map.Entry<String, Object> keyValue : param2.entrySet())
//                    {
//                        mto.put(keyValue.getKey(), keyValue.getValue().toString());
//                        System.out.println("Key  =[" + keyValue.getKey() + "]");
//                        System.out.println("Value=[" + keyValue.getValue() + "]");
//                        System.out.println("---------------------------------");
//                    }
//                    System.out.println("--------------- Key End ---------------");

                    if (param2.get("rowStatus").toString().equals("C") == true) // Insert
                    {
                        iResult = tactics.insert(mto.get("sqlid"), mto);
                    }
                    else if (param2.get("rowStatus").toString().equals("U") == true) // Update
                    {
                        iResult = tactics.update(mto.get("sqlid"), mto);
                    }
                    else if (param2.get("rowStatus").toString().equals("D") == true) // Delete
                    {
                        iResult = tactics.delete(mto.get("sqlid"), mto);
                    }

                    iResult++;
                }

                // 세번째 처리
                for (int i=0; i<iLength3; i++)
                {
                    JSONObject jsonObject3 = jsonArray3.getJSONObject(i);

                    Map<String, Object> param3 = JsonUtil.JsonToMap(jsonObject3.toString());

                    MTO mto = new MTO();

//                    // Parameter 값 체크 확인
//                    System.out.println("--------------- Key Start ---------------");
//                    for (Map.Entry<String, Object> keyValue : param3.entrySet())
//                    {
//                        mto.put(keyValue.getKey(), keyValue.getValue().toString());
//                        System.out.println("Key  =[" + keyValue.getKey() + "]");
//                        System.out.println("Value=[" + keyValue.getValue() + "]");
//                        System.out.println("---------------------------------");
//                    }
//                    System.out.println("--------------- Key End ---------------");

                    if (param3.get("rowStatus").toString().equals("C") == true) // Insert
                    {
                        iResult = tactics.insert(mto.get("sqlid"), mto);
                    }
                    else if (param3.get("rowStatus").toString().equals("U") == true) // Update
                    {
                        iResult = tactics.update(mto.get("sqlid"), mto);
                    }
                    else if (param3.get("rowStatus").toString().equals("D") == true) // Delete
                    {
                        iResult = tactics.delete(mto.get("sqlid"), mto);
                    }

                    iResult++;
                }

                // 네번째 처리
                for (int i=0; i<iLength4; i++)
                {
                    JSONObject jsonObject4 = jsonArray4.getJSONObject(i);

                    Map<String, Object> param4 = JsonUtil.JsonToMap(jsonObject4.toString());

                    MTO mto = new MTO();

                    // Parameter 값 체크 확인
//                    System.out.println("--------------- Key Start ---------------");
//                    for (Map.Entry<String, Object> keyValue : param4.entrySet())
//                    {
//                        mto.put(keyValue.getKey(), keyValue.getValue().toString());
//                        System.out.println("Key  =[" + keyValue.getKey() + "]");
//                        System.out.println("Value=[" + keyValue.getValue() + "]");
//                        System.out.println("---------------------------------");
//                    }
//                    System.out.println("--------------- Key End ---------------");

                    if (param4.get("rowStatus").toString().equals("C") == true) // Insert
                    {
                        iResult = tactics.insert(mto.get("sqlid"), mto);
                    }
                    else if (param4.get("rowStatus").toString().equals("U") == true) // Update
                    {
                        iResult = tactics.update(mto.get("sqlid"), mto);
                    }
                    else if (param4.get("rowStatus").toString().equals("D") == true) // Delete
                    {
                        iResult = tactics.delete(mto.get("sqlid"), mto);
                    }

                    iResult++;
                }
            }
            catch (Exception e)
            {
                try
                {
                	e.printStackTrace();
                    mTx.rollback(); // RollBack
                    errorProcess(input, output, request, response);
            
                }
                catch (SQLException e1)
                {
                    // TODO Auto-generated catch block
                    errorProcess(input, output, request, response);
                }
            }

            mTx.commit(); // Commit
                        
        }
        catch (Exception e)
        {
            logger.error(e.toString());
            
        }finally{
        	try{
        		mTx.close();
        	}catch(Exception e){
        		mTx  =  null;
        	}
        }

        response.setCharacterEncoding("UTF-8");

        try
        {
            writer = response.getWriter();

            if (iResult > 0)
            {
                writer.write(JsonUtil.OneStringToJson("SUCCESS"));
            }
            else
            {
                writer.write(JsonUtil.OneStringToJson("FAIL"));
            }
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
        }
    }

    @Override
    public void errorProcess(ImplCauseDTO arg0, ImplEffectDTO arg1, HttpServletRequest arg2, HttpServletResponse arg3)
            throws FrameException, ServiceException
    {
        // TODO Auto-generated method stub

    }
}
