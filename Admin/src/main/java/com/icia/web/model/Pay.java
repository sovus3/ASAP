package com.icia.web.model;

import java.io.Serializable;

public class Pay implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private long orderNo;				//주문번호
	private String userId;				//회원 아이디
	private long payRealPrice;			//실 결제금액
	private long payPointPrice;			//포인트 결제금액
	private long payTotalPrice;			//총 결제금액 
	private String status;
	private String regDate;				//결제일
	
	private long startRow;				//시작 rownum
	private long endRow;				//끝 rownum
	
	private long productSeq;					//상품번호
	private String productName;				//상품이름
	
	private String searchType;
	private String searchValue;
	
	private int cnt;
	
	public Pay(){
		orderNo =0;
		userId ="";
		payRealPrice =0;
		payPointPrice =0;
		payTotalPrice =0;
		status="";
		
		startRow = 0;
		endRow = 0;
		
		regDate="";
		productSeq =0;
		productName="";
		
		searchType ="";
		searchValue ="";
		
		cnt=0;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}

	public long getProductSeq() {
		return productSeq;
	}

	public void setProductSeq(long productSeq) {
		this.productSeq = productSeq;
	}

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
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

	public int getCnt() {
		return cnt;
	}

	public void setCnt(int cnt) {
		this.cnt = cnt;
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

	public long getOrderNo() {
		return orderNo;
	}

	public void setOrderNo(long orderNo) {
		this.orderNo = orderNo;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public long getPayRealPrice() {
		return payRealPrice;
	}

	public void setPayRealPrice(long payRealPrice) {
		this.payRealPrice = payRealPrice;
	}

	public long getPayPointPrice() {
		return payPointPrice;
	}

	public void setPayPointPrice(long payPointPrice) {
		this.payPointPrice = payPointPrice;
	}

	public long getPayTotalPrice() {
		return payTotalPrice;
	}

	public void setPayTotalPrice(long payTotalPrice) {
		this.payTotalPrice = payTotalPrice;
	}
	
}
