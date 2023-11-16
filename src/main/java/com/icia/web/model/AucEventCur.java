package com.icia.web.model;

import java.io.Serializable;

public class AucEventCur implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private long aeCurSeq;				//이벤트경매 입찰번호
	private long aeSeq;					//이벤트 경매 번호
	private String userId;				//참여자 아이디
	private String aeCurBuyTime;		//입찰 시간
	private long aeCurPrice;			//입찰 금액 
	private String status;
	
	private long userCharge;
	private String aeTitle;
	private String aeProductTitle;
	
	private long startRow;
	private long endRow;	
	private String searchType;
	private String searchValue;

	public AucEventCur()
	{
		aeCurSeq =0;
		aeSeq =0;
		userId ="";
		aeCurBuyTime ="";
		aeCurPrice =0;
		status = "";
		
		userCharge = 0;
		aeTitle="";
		aeProductTitle="";
		
		startRow = 0;
		endRow = 0;		
		searchType="";
		searchValue="";
	}

	public String getAeTitle() {
		return aeTitle;
	}

	public void setAeTitle(String aeTitle) {
		this.aeTitle = aeTitle;
	}

	public String getAeProductTitle() {
		return aeProductTitle;
	}

	public void setAeProductTitle(String aeProductTitle) {
		this.aeProductTitle = aeProductTitle;
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

	public long getAeCurSeq() {
		return aeCurSeq;
	}

	public void setAeCurSeq(long aeCurSeq) {
		this.aeCurSeq = aeCurSeq;
	}

	public long getAeSeq() {
		return aeSeq;
	}

	public void setAeSeq(long aeSeq) {
		this.aeSeq = aeSeq;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getAeCurBuyTime() {
		return aeCurBuyTime;
	}

	public void setAeCurBuyTime(String aeCurBuyTime) {
		this.aeCurBuyTime = aeCurBuyTime;
	}

	public long getAeCurPrice() {
		return aeCurPrice;
	}

	public void setAeCurPrice(long aeCurPrice) {
		this.aeCurPrice = aeCurPrice;
	}
	
}
