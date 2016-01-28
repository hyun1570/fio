package com.ddta.base.service;

import java.io.File;
import java.sql.SQLException;
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
import com.ddta.base.util.JsonUtil;

public class FileService extends NormalTxService {

	public FileService(Class clazz) throws FrameException {
		super(clazz);

	}

	@Override
	protected void process(CauseDTO input, EffectDTO output)throws FrameException, ServiceException, SQLException {
		
        Tactics tactics = TacticsFactory.getInstance(input.getTx());

        MTO _mto = new MTO();
        _mto.put("fileAttachId", input.get("fileAttachId").toString());

       //그리드 목록이 있는지 확인 하고 gridSet에 정의해서 Client로 넘긴다.
        LTO resList = tactics.selectList("CommonFile.FILE_LIST", _mto);
        
        String _df = resList.get(0).get("filePath") + "\\"+resList.get(0).get("saveFileName");
        
        File _f = new File(_df);
        
        tactics.delete("CommonFile.FILE_DELETE", _mto);
        
        _f.delete();
        
        output.put("result", JsonUtil.OneStringToJson("SUCCESS"));
	}

}
