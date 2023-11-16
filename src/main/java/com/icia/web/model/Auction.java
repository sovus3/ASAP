package com.icia.web.model;

import java.io.Serializable;

public class Auction implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private long aucSeq;				//경매번호
	private int categoryNo;				//카테고리 번호
	private long vrSeq;					//투표글 번호
	private String userId;				//참여자 아이디
	private String status;				//경매상태
	private String aucStartTime;		//경매 시작 시간
	private String aucEndTime;			//갱며 종료 시간
	private long aucBuyPrice;			//경매 최종 낙찰가 
	
	private long startRow;
	private long endRow;
	private String searchType;
	private String searchValue;
	private String searchDate;
	
	private long vrStartPrice;
	private String userName;
	private String artUserId;
	private String vrTitle;
	
	
	
	public Auction()
	{
		aucSeq =0;
		categoryNo =0;
		vrSeq =0;
		userId ="";
		status ="";
		aucStartTime ="";
		aucEndTime ="";
		aucBuyPrice = 0;
		
		startRow = 0;
		endRow = 0;
		searchType ="";
		searchValue ="";
		searchDate = "";
		
		vrStartPrice = 0;
		userName = "";
		artUserId = "";
		vrTitle = "";
	}

	public String getSearchDate() {
		return searchDate;
	}

	public void setSearchDate(String searchDate) {
		this.searchDate = searchDate;
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

	public long getVrStartPrice() {
		return vrStartPrice;
	}

	public void setVrStartPrice(long vrStartPrice) {
		this.vrStartPrice = vrStartPrice;
	}

	public String getArtUserId() {
		return artUserId;
	}

	public void setArtUserId(String artUserId) {
		this.artUserId = artUserId;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getVrTitle() {
		return vrTitle;
	}

	public void setVrTitle(String vrTitle) {
		this.vrTitle = vrTitle;
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

	public long getAucSeq() {
		return aucSeq;
	}

	public void setAucSeq(long aucSeq) {
		this.aucSeq = aucSeq;
	}

	public int getCategoryNo() {
		return categoryNo;
	}

	public void setCategoryNo(int categoryNo) {
		this.categoryNo = categoryNo;
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

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getAucStartTime() {
		return aucStartTime;
	}

	public void setAucStartTime(String aucStartTime) {
		this.aucStartTime = aucStartTime;
	}

	public String getAucEndTime() {
		return aucEndTime;
	}

	public void setAucEndTime(String aucEndTime) {
		this.aucEndTime = aucEndTime;
	}

	public long getAucBuyPrice() {
		return aucBuyPrice;
	}

	public void setAucBuyPrice(long aucBuyPrice) {
		this.aucBuyPrice = aucBuyPrice;
	}
	
}
