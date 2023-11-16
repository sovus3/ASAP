package com.icia.web.model;

import java.io.Serializable;

public class OrderDetail implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String userId; // 회원 아이디
	private long orderNo; // 주문번호
	private long productSeq; // 상품번호
	private long orderDetailQuantity; // 주문 수량
	private long orderDetailPrice; // 주문 가격
	private String status;	//리뷰상태
	private String regDate;	//결제일
	
	private String productName; // 상품명
	private long reviewSeq;	//리뷰번호
	
	private long startRow;
	private long endRow;

	public OrderDetail() {
		userId = "";
		orderNo = 0;
		productSeq = 0;
		orderDetailQuantity = 0;
		orderDetailPrice = 0;
		status = "";
		regDate = "";
		
		productName = "";
		reviewSeq = 0;
		
		startRow = 0;
		endRow = 0;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
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

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public long getReviewSeq() {
		return reviewSeq;
	}

	public void setReviewSeq(long reviewSeq) {
		this.reviewSeq = reviewSeq;
	}

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}

	public long getOrderDetailPrice() {
		return orderDetailPrice;
	}

	public void setOrderDetailPrice(long orderDetailPrice) {
		this.orderDetailPrice = orderDetailPrice;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public long getOrderNo() {
		return orderNo;
	}

	public void setOrderNo(long orderNo) {
		this.orderNo = orderNo;
	}

	public long getProductSeq() {
		return productSeq;
	}

	public void setProductSeq(long productSeq) {
		this.productSeq = productSeq;
	}

	public long getOrderDetailQuantity() {
		return orderDetailQuantity;
	}

	public void setOrderDetailQuantity(long orderDetailQuantity) {
		this.orderDetailQuantity = orderDetailQuantity;
	}

}
