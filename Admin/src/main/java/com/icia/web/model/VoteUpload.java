package com.icia.web.model;

import java.io.Serializable;

public class VoteUpload implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private long vrSeq;					//투표글 번호
	private String userId;				//회원아이디
	private int categoryNo;				//카테고리 번호
	private String vrTitle;				//작품명
	private String vrContent;			//작품 내용
	private long vrTotalCnt;			//총 투표수
	private long vrStartPrice;			//시작가(희망가)
	private String status;				//투표상태
	private String regDate;				//투표 시작일
	private String vrStartDate;			//투표 시작일
	private String vrEndDate;			//투표 종료일
	
	private long aucSeq;
	private String aucStatus;
	private String userName;
	private String userNick;			//회원닉네임 - 회원테이블
	private String categoryName;		//카테고리명 - 카테고리테이블
	
	private long startRow;			//시작 rownum
	private long endRow;			//끝 rownum
	private String searchType;
	private String searchValue;
	private String searchDate;
	
	private String vlUserId;

	public VoteUpload()
	{
		vrSeq =0;
		userId ="";
		categoryNo =0;
		vrTitle ="";
		vrContent ="";
		vrTotalCnt =0;
		vrStartPrice =0;
		status ="";
		regDate = "";
		vrStartDate ="";
		vrEndDate ="";
		
		aucSeq = 0;
		aucStatus = "";
		categoryName = "";
		userNick = "";
		userName = "";
		
		startRow = 0;
		endRow = 0;
		searchType = "";
		searchValue= "";
		searchDate = "";
		
		vlUserId = "";
	}

	public String getVlUserId() {
		return vlUserId;
	}

	public void setVlUserId(String vlUserId) {
		this.vlUserId = vlUserId;
	}
	

	public String getSearchType() {
		return searchType;
	}

	public void setSearchType(String searchType) {
		this.searchType = searchType;
	}

	public String getSearchValue() {
		return searchValue;
	}

	public void setSearchValue(String searchValue) {
		this.searchValue = searchValue;
	}

	public String getAucStatus() {
		return aucStatus;
	}

	public void setAucStatus(String aucStatus) {
		this.aucStatus = aucStatus;
	}

	public long getAucSeq() {
		return aucSeq;
	}

	public void setAucSeq(long aucSeq) {
		this.aucSeq = aucSeq;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUserNick() {
		return userNick;
	}

	public void setUserNick(String userNick) {
		this.userNick = userNick;
	}

	public String getCategoryName() {
		return categoryName;
	}

	public void setCategoryName(String categoryName) {
		this.categoryName = categoryName;
	}

	public long getStartRow() {
		return startRow;
	}

	public void setStartRow(long startRow) {
		this.startRow = startRow;
	}

	public long getEndRow() {
		return endRow;
	}

	public void setEndRow(long endRow) {
		this.endRow = endRow;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}

	public long getVrSeq() {
		return vrSeq;
	}

	public void setVrSeq(long vrSeq) {
		this.vrSeq = vrSeq;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public int getCategoryNo() {
		return categoryNo;
	}

	public void setCategoryNo(int categoryNo) {
		this.categoryNo = categoryNo;
	}

	public String getVrTitle() {
		return vrTitle;
	}

	public void setVrTitle(String vrTitle) {
		this.vrTitle = vrTitle;
	}

	public String getVrContent() {
		return vrContent;
	}

	public void setVrContent(String vrContent) {
		this.vrContent = vrContent;
	}

	public long getVrTotalCnt() {
		return vrTotalCnt;
	}

	public void setVrTotalCnt(long vrTotalCnt) {
		this.vrTotalCnt = vrTotalCnt;
	}

	public long getVrStartPrice() {
		return vrStartPrice;
	}

	public void setVrStartPrice(long vrStartPrice) {
		this.vrStartPrice = vrStartPrice;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getVrStartDate() {
		return vrStartDate;
	}

	public void setVrStartDate(String vrStartDate) {
		this.vrStartDate = vrStartDate;
	}

	public String getVrEndDate() {
		return vrEndDate;
	}

	public void setVrEndDate(String vrEndDate) {
		this.vrEndDate = vrEndDate;
	}

	public String getSearchDate() {
		return searchDate;
	}

	public void setSearchDate(String searchDate) {
		this.searchDate = searchDate;
	}
	
	
	
}
