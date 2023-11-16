package com.icia.web.model;

import java.io.Serializable;

public class AucEvent implements Serializable{

	private static final long serialVersionUID = 1L;
	
	private long aeSeq;						//이벤트 경매번호
	private String admId;					//관리자 아이디
	private String aeStartTime;				//경매 시작 시간
	private String aeEndTime;				//경매 종료 시간
	private long aeBuyPrice;				//경매 최종 낙찰가
	private String aeTitle;					//경매글 제목
	private String status;					//경매글 상태
	private long aeStartPrice;				//시작가
	private String aeProductTitle;			//이벤트 경매 상품명
	
	private long startRow;
	private long endRow;
	private String searchType;
	private String searchValue;

	public AucEvent()
	{
		aeSeq =0;
		admId ="";
		aeStartTime ="";
		aeEndTime ="";
		aeBuyPrice =0;
		aeTitle ="";
		status ="";
		aeStartPrice =0;
		aeProductTitle ="";
		
		startRow = 0;
		endRow = 0;
		searchType="";
		searchValue="";
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

	public long getAeSeq() {
		return aeSeq;
	}

	public void setAeSeq(long aeSeq) {
		this.aeSeq = aeSeq;
	}

	public String getAdmId() {
		return admId;
	}

	public void setAdmId(String admId) {
		this.admId = admId;
	}

	public String getAeStartTime() {
		return aeStartTime;
	}

	public void setAeStartTime(String aeStartTime) {
		this.aeStartTime = aeStartTime;
	}

	public String getAeEndTime() {
		return aeEndTime;
	}

	public void setAeEndTime(String aeEndTime) {
		this.aeEndTime = aeEndTime;
	}

	public long getAeBuyPrice() {
		return aeBuyPrice;
	}

	public void setAeBuyPrice(long aeBuyPrice) {
		this.aeBuyPrice = aeBuyPrice;
	}

	public String getAeTitle() {
		return aeTitle;
	}

	public void setAeTitle(String aeTitle) {
		this.aeTitle = aeTitle;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public long getAeStartPrice() {
		return aeStartPrice;
	}

	public void setAeStartPrice(long aeStartPrice) {
		this.aeStartPrice = aeStartPrice;
	}

}
