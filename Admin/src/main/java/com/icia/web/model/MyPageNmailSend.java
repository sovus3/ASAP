package com.icia.web.model;

import java.io.Serializable;

public class MyPageNmailSend implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private String vrTitle;  		//작품명
	private String artUserName; 		//작가명

	private long aucCurSeq;  		//입찰 내역 번호
	private long aucSeq;	 		//경매 번호
	private long aucCurPrice;		//입찰 가격
	private String aucCurBuyTime;	//입찰 시간
	private String acUserId; 		//입찰자
	private String acUserEmail; 	//입찰자 이메일
	
	public MyPageNmailSend() {
		vrTitle = "";
		artUserName = "";

		aucCurSeq = 0;
		aucSeq = 0;
		aucCurPrice = 0;
		aucCurBuyTime = "";
		acUserId = "";
		acUserEmail = "";
	}

	public String getAcUserEmail() {
		return acUserEmail;
	}

	public void setAcUserEmail(String acUserEmail) {
		this.acUserEmail = acUserEmail;
	}

	public String getVrTitle() {
		return vrTitle;
	}

	public void setVrTitle(String vrTitle) {
		this.vrTitle = vrTitle;
	}

	public String getArtUserName() {
		return artUserName;
	}

	public void setArtUserName(String artUserName) {
		this.artUserName = artUserName;
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

	public long getAucCurPrice() {
		return aucCurPrice;
	}

	public void setAucCurPrice(long aucCurPrice) {
		this.aucCurPrice = aucCurPrice;
	}

	public String getAucCurBuyTime() {
		return aucCurBuyTime;
	}

	public void setAucCurBuyTime(String aucCurBuyTime) {
		this.aucCurBuyTime = aucCurBuyTime;
	}

	public String getAcUserId() {
		return acUserId;
	}

	public void setAcUserId(String acUserId) {
		this.acUserId = acUserId;
	}
	
	

}
