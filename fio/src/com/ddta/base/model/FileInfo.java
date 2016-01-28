package com.ddta.base.model;

/*
 //  클래스 명  : FileInfo
 //  클래스설명 : FileInfo 클래스 (파일정보)
 //  최초작성일 : 2013-01-10
 //  최종수정일 : 2013-08-05
 //  Programmer : 박상민
 //  Modifier	: 홍성인
 */
public class FileInfo {
	private String docAttachId;	// 파일ID
	private String offerNo; 		// 딜번호
	private String docId; 			// 문서ID
	private String docName; 		// 문서명
	private String fileLocation; 	// 파일위치
	private String fileName; 		// 파일명
	private String fileSize; 		// 파일사이즈
	private String downloadCount; 	// 다운로드수
	private String regId; 			// 등록자ID
	private String regDate; 		// 등록일자
	private String regTime; 		// 등록시간
	private String modId; 			// 수정자ID
	private String modDate; 		// 수정일자
	private String modTime; 		// 수정시간

	public String getDocAttachId() {
		return docAttachId;
	}

	public void setDocAttachId(String docAttachId) {
		this.docAttachId = docAttachId;
	}

	public String getOfferNo() {
		return offerNo;
	}

	public void setOfferNo(String offerNo) {
		this.offerNo = offerNo;
	}

	public String getDocId() {
		return docId;
	}

	public void setDocId(String docId) {
		this.docId = docId;
	}

	public String getDocName() {
		return docName;
	}

	public void setDocName(String docName) {
		this.docName = docName;
	}

	public String getFileLocation() {
		return fileLocation;
	}

	public void setFileLocation(String fileLocation) {
		this.fileLocation = fileLocation;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getFileSize() {
		return fileSize;
	}

	public void setFileSize(String fileSize) {
		this.fileSize = fileSize;
	}

	public String getDownloadCount() {
		return downloadCount;
	}

	public void setDownloadCount(String downloadCount) {
		this.downloadCount = downloadCount;
	}

	public String getRegId() {
		return regId;
	}

	public void setRegId(String regId) {
		this.regId = regId;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}

	public String getRegTime() {
		return regTime;
	}

	public void setRegTime(String regTime) {
		this.regTime = regTime;
	}

	public String getModId() {
		return modId;
	}

	public void setModId(String modId) {
		this.modId = modId;
	}

	public String getModDate() {
		return modDate;
	}

	public void setModDate(String modDate) {
		this.modDate = modDate;
	}

	public String getModTime() {
		return modTime;
	}

	public void setModTime(String modTime) {
		this.modTime = modTime;
	}

}
