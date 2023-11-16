package com.icia.web.model;

import java.io.Serializable;

public class Cart implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private long cartNo;
	private String userId;
	private long productSeq;
	private String productName;
	private long cartQuantity;
	private long cartPrice;	
	private int productQuantity;
	private long productPrice; 
	
	public Cart()
	{
		cartNo = 0;
		userId ="";
		productSeq = 0;
		productName="";
		cartQuantity = 0;
		cartPrice = 0;	
		productQuantity = 0;
		productPrice=0;
	}

	public long getProductPrice() {
		return productPrice;
	}

	public void setProductPrice(long productPrice) {
		this.productPrice = productPrice;
	}

	public long getCartNo() {
		return cartNo;
	}

	public void setCartNo(long cartNo) {
		this.cartNo = cartNo;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
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

	public long getCartQuantity() {
		return cartQuantity;
	}

	public void setCartQuantity(long cartQuantity) {
		this.cartQuantity = cartQuantity;
	}

	public long getCartPrice() {
		return cartPrice;
	}

	public void setCartPrice(long cartPrice) {
		this.cartPrice = cartPrice;
	}

	public int getProductQuantity() {
		return productQuantity;
	}

	public void setProductQuantity(int productQuantity) {
		this.productQuantity = productQuantity;
	}

	
}
