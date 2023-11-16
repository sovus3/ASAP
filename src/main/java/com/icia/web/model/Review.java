package com.icia.web.model;

import java.io.Serializable;

public class Review implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private long reviewSeq;					//리뷰번호
	private String userId;					//회원 아이디
	private long orderNo;					//주문번호
	private String reviewContent;			//리뷰내용
	private String regDate;					//작성일
	private long productSeq;				//상품 번호
	private String productName;   
	
	private long startRow;			//시작 rownum
	private long endRow;			//끝 rownum
	
	public Review()
	{
		reviewSeq = 0;
		userId = "";
		orderNo = 0;
		reviewContent = "";
		regDate = "";
		productSeq = 0;
	    productName = "";
		
		startRow = 0;
		endRow = 0;
	}

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
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

	public long getProductSeq() {
		return productSeq;
	}

	public void setProductSeq(long productSeq) {
		this.productSeq = productSeq;
	}

	public long getReviewSeq() {
		return reviewSeq;
	}

	public void setReviewSeq(long reviewSeq) {
		this.reviewSeq = reviewSeq;
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

	public String getReviewContent() {
		return reviewContent;
	}

	public void setReviewContent(String reviewContent) {
		this.reviewContent = reviewContent;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}
	
}
