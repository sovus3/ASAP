package com.icia.web.model;

import java.io.Serializable;

public class MyPage implements Serializable 
{
	private static final long serialVersionUID = 1L;
	
	/* 입찰 조회를 위한 데이터 */
	private long aeSeq;
	private long vrSeq;
	private long aucCurSeq;
	private String vrTitle; //입찰한 경매 제목
	private String aeTitle;
	private int categoryNo; // 카테고리번호 
	private String userId;
    private String aucCurBuyTime; // 입찰 시간
    private long aucCurPrice; // 입찰한 가격
    private String aeCurBuyTime;
    private long aeCurPrice;
    
    private String aucCurStatus; // 입찰 상태 구분 
    private String aeStatus;
    
    private String aucStartTime;
    private long aucBuyPrice;
    
    private long startRow;
    private long endRow;
    
    public MyPage()
    {
    	aeSeq = 0;
    	vrSeq = 0;
    	aucCurSeq = 0;
    	vrTitle = "";
    	aeTitle = "";
    	categoryNo = 0;
    	userId = "";
    	aucCurBuyTime = "";
    	aucCurPrice = 0;
    	aeCurBuyTime = "";
    	aeCurPrice = 0;
    	
    	aucCurStatus = "";
    	aeStatus ="";
    	
    	aucStartTime = "";
    	aucBuyPrice = 0;
    	
    	startRow = 0;
    	endRow = 0;
    }

	public long getAeSeq() {
		return aeSeq;
	}

	public void setAeSeq(long aeSeq) {
		this.aeSeq = aeSeq;
	}

	public long getVrSeq() {
		return vrSeq;
	}

	public void setVrSeq(long vrSeq) {
		this.vrSeq = vrSeq;
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

	public String getAeStatus() {
		return aeStatus;
	}

	public void setAeStatus(String aeStatus) {
		this.aeStatus = aeStatus;
	}

	public String getAeTitle() {
		return aeTitle;
	}

	public void setAeTitle(String aeTitle) {
		this.aeTitle = aeTitle;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public long getAucCurSeq() {
		return aucCurSeq;
	}

	public void setAucCurSeq(long aucCurSeq) {
		this.aucCurSeq = aucCurSeq;
	}

	public String getVrTitle() {
		return vrTitle;
	}

	public void setVrTitle(String vrTitle) {
		this.vrTitle = vrTitle;
	}

	public int getCategoryNo() {
		return categoryNo;
	}

	public void setCategoryNo(int categoryNo) {
		this.categoryNo = categoryNo;
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

	public String getAucCurStatus() {
		return aucCurStatus;
	}

	public void setAucCurStatus(String aucCurStatus) {
		this.aucCurStatus = aucCurStatus;
	}

	public String getAucStartTime() {
		return aucStartTime;
	}

	public void setAucStartTime(String aucStartTime) {
		this.aucStartTime = aucStartTime;
	}

	public long getAucBuyPrice() {
		return aucBuyPrice;
	}

	public void setAucBuyPrice(long aucBuyPrice) {
		this.aucBuyPrice = aucBuyPrice;
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

    
    

    
    
    
    
}
