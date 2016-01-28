package com.ddta.base.util;


import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.google.gson.Gson;

/*
//  클래스  명 : JsonUtil
//  클래스설명 : JsonUtil 클래스
//  최초작성일 : 2012-11-12
//  최종수정일 : 2012-12-26
//  Programmer : 박상민
*/
public class JsonUtil
{
    public JsonUtil()
    {
        // 생성자 Code
    }


    /**
     * 함수명   : JsonToMap()
     * FuncDesc : Json String Map 형태 변환
     * Param    : param : Json String
     * Return   : Map<String, Object>
     * Author   :
     * History  : 2012-11-12
    */
    @SuppressWarnings("unchecked")
    public static Map<String, Object> JsonToMap(String param)
    {
        Gson gson = new Gson();

        // 테스트 코드
        /*
        Map<String, Object> map = gson.fromJson(param, new HashMap<String,Object>().getClass());

        Set<Entry<String, Object>> ms = map.entrySet();


        for (Entry<String, Object> e:ms)
        {
            System.out.println(e.getKey() + " : " + e.getValue());
        }
        */

        return gson.fromJson(param, new HashMap<String,Object>().getClass());
    }


    /**
     * 함수명   : ListToJson()
     * FuncDesc : Json List Map 형태 변환
     * Param    : res : Json String
     * Return   : Json String
     * Author   :
     * History  : 2012-11-12
    */
    @SuppressWarnings("unchecked")
    public static String ListToJson(List<Map<String, Object>> res)
    {
        Gson gson = new Gson();

        // 테스트 코드
        /*
        Map<String, Object> param = gson.fromJson(param, new HashMap<String,Object>().getClass());

        Set<Entry<String, Object>> ms = param.entrySet();

        for (Entry<String, Object> e:ms)
        {
            System.out.println(e.getKey() + " : " + e.getValue());
        }
        */

        return gson.toJson(res);
    }
    
    /**
     * 함수명   : ListToJson()
     * FuncDesc : Json List Map 형태 변환
     * Param    : res : Json String
     * Return   : Json String
     * Author   :
     * History  : 2012-11-12
    */
    @SuppressWarnings("unchecked")
    public static String ListToJson(HashMap res)
    {
        Gson gson = new Gson();

        // 테스트 코드
        /*
        Map<String, Object> param = gson.fromJson(param, new HashMap<String,Object>().getClass());

        Set<Entry<String, Object>> ms = param.entrySet();

        for (Entry<String, Object> e:ms)
        {
            System.out.println(e.getKey() + " : " + e.getValue());
        }
        */

        return gson.toJson(res);
    }

    public static void print(Map<String, Object> _m)
    {
    	System.out.println("---------------------------------");
		for (Map.Entry<String, Object> keyValue : _m.entrySet())
        {
			System.out.println("Key  =[" + keyValue.getKey() + "]");
			System.out.println("Value=[" + keyValue.getValue() + "]");
        }
		System.out.println("---------------------------------");
    }

    /**
     * 함수명   : OneStringToJson()
     * FuncDesc : Json 형태 변환
     * Param    : sData : String
     * Return   : String
     * Author   :
     * History  : 2012-12-26
    */
    @SuppressWarnings("unchecked")
    public static String OneStringToJson(String sData)
    {
        Gson gson = new Gson();

        return gson.toJson(sData);
    }
    
    /*
	 * 엑셀 파일을 JSON 으로 변환
	 *           _f : 파일이름(String)
	 *          _si : 시작 Sheet Index
	 *          _sr : 시작할 Row
	 * _objArray : Excell Cell에 데이타를 처리하기위한 구조체
	 */
	public static String excelToJson(String _f,int _si,int _sr,JSONArray _objArray)
	{
		HSSFRow  row;

		HSSFCell  cell;
		
		JSONArray _jr = new JSONArray();
		
		try {
			//POI 가 파일 핸들을 물고 있는걸 방지하기위해서 INPUT STREAM을 따로 생성하고 처리후STREAM을 닫는다.
			FileInputStream _is = new FileInputStream(_f);
			
		    POIFSFileSystem fs = new POIFSFileSystem(_is); 
			  
			HSSFWorkbook  _wb =  new HSSFWorkbook(fs);
			
			//지정된 Sheet 반환
			HSSFSheet   sheet  = _wb.getSheetAt(_si);
			
			
			//sheet에서  ROW 수 반환
			int rows = sheet.getLastRowNum();
			
			//Row만큼 반복 한다.
			for (int r = _sr; r < rows; r++) 
			{
				// 출력용 구조체
				JSONObject _out = new JSONObject();

				row = sheet.getRow(r); // row 가져오기
				
				for(int i=0;i<_objArray.length();i++)
				{
					JSONObject _j = _objArray.getJSONObject(i);
					
					// 파라메터로부터 컬럼 인덱스를 가져와 해당 Cell 을 가져온다.
					cell = row.getCell(Integer.valueOf(_j.get("colIndex").toString()));
					
					//Cell Value를 MAP에 저장한다.
					if (cell != null) {
						switch (cell.getCellType()) {
							case XSSFCell.CELL_TYPE_FORMULA:
								_out.put(_j.get("colId").toString(), cell.getCellFormula());
								break;
						case XSSFCell.CELL_TYPE_NUMERIC:
								_out.put(_j.get("colId").toString(), cell.getNumericCellValue());
								break;
						case XSSFCell.CELL_TYPE_STRING:
								_out.put(_j.get("colId").toString(),cell.getStringCellValue());
								break;
						case XSSFCell.CELL_TYPE_BLANK:
							   _out.put(_j.get("colId").toString(),"");
								break;
						case XSSFCell.CELL_TYPE_ERROR:
								_out.put(_j.get("colId").toString(), cell.getErrorCellValue());
								break;
						default:
						}
					}
					else
						//Cell값이 공백일 경우의 처리
						_out.put(_j.get("colId").toString(),"");
				}
				_jr.put(_out);
			}
			
			//File Inputm Stream 핸들을 닫는다.
			_is.close();
			
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (NumberFormatException e) {
			e.printStackTrace();
		} catch (JSONException e) {
			e.printStackTrace();
		}
		
		return _jr.toString();
	}	
    
    
}
