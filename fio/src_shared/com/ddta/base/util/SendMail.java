package com.ddta.base.util;

import java.io.File;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.mail.Address;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.internet.MimeUtility;

import com.ddta.base.model.FileInfo;
import com.cni.fw.ff.conf.AppConfig;


public class SendMail {

	//SMTP Host
	private String m_smtp_host;
	
	//Smtp Port
	private  int m_smtp_port;
	
	//메일 제목
	private  String m_subject;
	
	//메일 발송자
    private  String m_from;
    
    //메일 수신자
    private  String m_to;
    
    //참조
    private String m_ccm = "";
    
    //내용
    private String m_contents;
    
    //첨부파일
    private List<FileInfo>  m_file_list;
    
	public String getMSubject() {
		return m_subject;
	}

	//메일 제목 지정
	public void setMSubject(String _subject) {
		this.m_subject = _subject;
	}
	
	//메일 발송자 지정
	public void setFrom(String _from) {
		this.m_from = _from;
	}
	
	//메일 수신자 지정
	public void setTo(String _to) {
		this.m_to = _to;
	}
	
	//메일 수신자 지정
	public void setCcm(String _ccm) {
		this.m_ccm = _ccm;
	}
	
	//메일 내용 지정
	public void setContents(String _contents) {
		this.m_contents = _contents;
	}

	//파일 목록 추가
	public void setFileList(List<FileInfo> _f)
	{
		this.m_file_list = _f;
	}
	
	//SendMail 컨스트럭트
	public SendMail ()
	{
		//SMTP Host
		m_smtp_host = AppConfig.get("mail.smtp.host");
		
		//Smtp Port
		m_smtp_port = Integer.valueOf(AppConfig.get("mail.smtp.port"));
	}
	
	// 메일 발송 메서트
	public void send()
	{
		//MimeMessage 설정 프로퍼티 개체 선언
		Properties props = System.getProperties();
       
		//호스트
        props.put("mail.smtp.host", this.m_smtp_host);
        //포트
        props.put("mail.smtp.port", this.m_smtp_port);

    //  props.put("mail.smtp.auth", "true");
    //  props.put("mail.smtp.ssl.enable", "true");
    //  props.put("mail.smtp.ssl.trust", host);

        try {
        	
	        Session session = Session.getDefaultInstance(props);
	        
	        //true 일경우 메일 전송 메세지 확인 콘솔
	        session.setDebug(true); //for debug
	        
			MimeMessage msg = new MimeMessage(session); // MineMessage 셋팅
			
		    msg.setSubject(this.m_subject); // 제목 셋팅
		    
		    msg.setSentDate(new Date()); // 발송일자 셋팅
		
		    //발신자
		    Address fromAddr = new InternetAddress(this.m_from); // 발송자 이메일
		    //Address fromAddr = new InternetAddress("ddw@dongbudawoo.xx.com"); // 발송자 이메일
		    
		    msg.setFrom(fromAddr);
		
		    //송신자
		    Address toAddr = new InternetAddress(this.m_to); // 송신자 이메일
		    //Address toAddr = new InternetAddress("sung2n@gmail.com"); // 송신자 이메일
		
		    //참조자가 있을경우 참조 추가
		    if(this.m_ccm.equals("") || this.m_ccm == null)
		    {
		        msg.setRecipient(Message.RecipientType.TO, toAddr);
		    }
		    else
		    {
		        //참조자
		        String[] ccMs  = this.m_ccm.split(";");
		        Address[] ccAddr = new Address[(ccMs.length)+1];
		        ccAddr[0] = toAddr;
		        for (int i = 1; i < (ccMs.length)+1; i++)
		        {
		            ccAddr[i] = new InternetAddress(ccMs[i-1]);
		        }
		        msg.setRecipients(Message.RecipientType.TO, ccAddr);
		    }
		
		    Multipart multipart = new MimeMultipart();
		
		    MimeBodyPart msgBodyPart = null;
		
		    // Create the message part
		    msgBodyPart = new MimeBodyPart();
		    //msgBodyPart.setText(String.valueOf(jsonObjM.get("contents")));
		    msgBodyPart.setContent(this.m_contents, "text/html;charset=utf-8");
	    
			multipart.addBodyPart(msgBodyPart);
			
			String files = "";


			if (this.m_file_list!=null)
			{
	            // 첨부파일
	            FileInfo fileInfo = null;
	            for (int i = 0; i < this.m_file_list.size(); i++)
	            {
	                fileInfo = this.m_file_list.get(i);
	
	                File file = new File(String.valueOf(fileInfo.getFileLocation()));
	                FileDataSource fds = new FileDataSource(file);
	
	                msgBodyPart = new MimeBodyPart();
	                msgBodyPart.setDataHandler(new DataHandler(fds));
	                // fileInfo.getFileName()
	                msgBodyPart.setFileName(MimeUtility.encodeText(String.valueOf(fileInfo.getFileName()), "utf-8", "B"));
	
	                multipart.addBodyPart(msgBodyPart);
	
	            }

			}
			msg.setContent(multipart);
            Transport.send(msg);


            System.out.println("SMTP서버를 이용한 메일보내기 성공");
		} catch (MessagingException e) {
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
	}
}
