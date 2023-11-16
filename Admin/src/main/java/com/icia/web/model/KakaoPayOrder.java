package com.icia.web.model;

import java.io.Serializable;

public class KakaoPayOrder implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private String partnerOrderId;			//가맹점 주문번호 
	private String partnerUserId;			//가맹점 회원 아이디 
	private String itemName;				//상품명
	private String itemCode;				//상품코드 
	private int quantity;					//상품 수량 
	private int totalAmount;				//상품 총액 
	private int taxFreeAmount;				//상품 비과세금액 
	private int vatAmount;					//상품 부과세금액
 
	//카카오페이에서 넘겨주는 값 
	private String tid;						//결제 고유번호 
	private String pgToken;					//결제 승인 요청을 인증하는 토큰
	private String gubunCheck;
	
	public KakaoPayOrder()
	{
		partnerOrderId="";
		partnerUserId="";
		itemName="";
		itemCode="";
		quantity=0;
		totalAmount=0;
		vatAmount=0;
		
		tid="";
		pgToken="";
		gubunCheck="";
	}

	public String getPartnerOrderId() {
		return partnerOrderId;
	}

	public void setPartnerOrderId(String partnerOrderId) {
		this.partnerOrderId = partnerOrderId;
	}

	public String getPartnerUserId() {
		return partnerUserId;
	}

	public void setPartnerUserId(String partnerUserId) {
		this.partnerUserId = partnerUserId;
	}

	public String getItemName() {
		return itemName;
	}

	public void setItemName(String itemName) {
		this.itemName = itemName;
	}

	public String getItemCode() {
		return itemCode;
	}

	public void setItemCode(String itemCode) {
		this.itemCode = itemCode;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	public int getTotalAmount() {
		return totalAmount;
	}

	public void setTotalAmount(int totalAmount) {
		this.totalAmount = totalAmount;
	}

	public int getTaxFreeAmount() {
		return taxFreeAmount;
	}

	public void setTaxFreeAmount(int taxFreeAmount) {
		this.taxFreeAmount = taxFreeAmount;
	}

	public int getVatAmount() {
		return vatAmount;
	}

	public void setVatAmount(int vatAmount) {
		this.vatAmount = vatAmount;
	}

	public String getTid() {
		return tid;
	}

	public void setTid(String tid) {
		this.tid = tid;
	}

	public String getPgToken() {
		return pgToken;
	}

	public void setPgToken(String pgToken) {
		this.pgToken = pgToken;
	}

	public String getGubunCheck() {
		return gubunCheck;
	}

	public void setGubunCheck(String gubunCheck) {
		this.gubunCheck = gubunCheck;
	}
	

}
