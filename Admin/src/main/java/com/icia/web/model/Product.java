package com.icia.web.model;

import java.io.Serializable;

public class Product implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private long productSeq; // 상품 번호(SEQ)
	private String productName; // 상품명
	private long productPrice; // 상품가격
	private long productQuantity; // 상품재고
	private String status; // 상품상태
	private String productStartDate; // 상품 판매 시작일
	private String productEndDate; // 상품 판매 종료일
	private String productDetail; // 상품 상세설명

	private long orderDetailQuantity; // 결제 상세 수량
	
	private String searchType;
	private String searchValue;
	
	private long startRow;			
	private long endRow;	

	public Product() {
		productSeq = 0;
		productName = "";
		productPrice = 0;
		productQuantity = 0;
		status = "";
		productStartDate = "";
		productEndDate = "";
		productDetail = "";
		orderDetailQuantity = 0;
		
		searchType ="";
		searchValue ="";
		
		startRow = 0;
		endRow = 0;
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

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}

	public long getProductPrice() {
		return productPrice;
	}

	public void setProductPrice(long productPrice) {
		this.productPrice = productPrice;
	}

	public long getProductQuantity() {
		return productQuantity;
	}

	public void setProductQuantity(long productQuantity) {
		this.productQuantity = productQuantity;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getProductStartDate() {
		return productStartDate;
	}

	public void setProductStartDate(String productStartDate) {
		this.productStartDate = productStartDate;
	}

	public String getProductEndDate() {
		return productEndDate;
	}

	public void setProductEndDate(String productEndDate) {
		this.productEndDate = productEndDate;
	}

	public String getProductDetail() {
		return productDetail;
	}

	public void setProductDetail(String productDetail) {
		this.productDetail = productDetail;
	}

	public long getOrderDetailQuantity() {
		return orderDetailQuantity;
	}

	public void setOrderDetailQuantity(long orderDetailQuantity) {
		this.orderDetailQuantity = orderDetailQuantity;
	}

}
