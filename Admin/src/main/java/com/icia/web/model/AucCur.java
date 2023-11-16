package com.icia.web.model;

import java.io.Serializable;

public class AucCur implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private long aucCurSeq;				//입찰가 내역 번호
	private long aucSeq;				//경매번호
	private String userId;				//참여자 아이디
	private String aucCurBuyTime;		//입찰 시간
	private long aucCurPrice;			//입찰 내역 
	private String status;
	
	private String vrTitle;
	private int categoryNo;	
	private String userNick;
	private long userCharge;
	private String aucStartTime;
	
	private String searchType;
	private String searchValue;
	private long startRow;
	private long endRow;

	public AucCur()
	{
		aucCurSeq =0;
		aucSeq =0;
		userId ="";
		aucCurBuyTime ="";
		aucCurPrice =0;
		status = "";
		
		vrTitle = "";
		categoryNo = 0;
		userNick = "";
		userCharge = 0;
		aucStartTime = "";
		
		searchType ="";
		searchValue ="";
		startRow = 0;
		endRow = 0;
	}

	public int getCategoryNo() {
		return categoryNo;
	}

	public void setCategoryNo(int categoryNo) {
		this.categoryNo = categoryNo;
	}

	public String getAucStartTime() {
		return aucStartTime;
	}

	public void setAucStartTime(String aucStartTime) {
		this.aucStartTime = aucStartTime;
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

	public String getVrTitle() {
		return vrTitle;
	}

	public void setVrTitle(String vrTitle) {
		this.vrTitle = vrTitle;
	}

	public long getUserCharge() {
		return userCharge;
	}

	public void setUserCharge(long userCharge) {
		this.userCharge = userCharge;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getUserNick() {
		return userNick;
	}

	public void setUserNick(String userNick) {
		this.userNick = userNick;
	}

	public long getAucCurSeq() {
		return aucCurSeq;
	}

	public void setAucCurSeq(long aucCurSeq) {
		this.aucCurSeq = aucCurSeq;
	}

	public long getAucSeq() {
		return aucSeq;
	}

	public void setAucSeq(long aucSeq) {
		this.aucSeq = aucSeq;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getAucCurBuyTime() {
		return aucCurBuyTime;
	}

	public void setAucCurBuyTime(String aucCurBuyTime) {
		this.aucCurBuyTime = aucCurBuyTime;
	}

	public long getAucCurPrice() {
		return aucCurPrice;
	}

	public void setAucCurPrice(long aucCurPrice) {
		this.aucCurPrice = aucCurPrice;
	}
	
}
