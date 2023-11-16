package com.icia.web.model;

import java.io.Serializable;

public class Order implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private long orderNo;					//주문번호 
	private String userId;					//회원 아이디
	private String orderDate;				//결제날짜
	private String status;					//주문상태
	private long orderTotalPrice;			//결제 총 금액
	private long orderTotalQuantity;		//결제 총 수량

	public Order()
	{
		orderNo =0;
		userId ="";
		orderDate ="";
		status ="";
		orderTotalPrice =0;
		orderTotalQuantity =0;
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

	public String getOrderDate() {
		return orderDate;
	}

	public void setOrderDate(String orderDate) {
		this.orderDate = orderDate;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public long getOrderTotalPrice() {
		return orderTotalPrice;
	}

	public void setOrderTotalPrice(long orderTotalPrice) {
		this.orderTotalPrice = orderTotalPrice;
	}

	public long getOrderTotalQuantity() {
		return orderTotalQuantity;
	}

	public void setOrderTotalQuantity(long orderTotalQuantity) {
		this.orderTotalQuantity = orderTotalQuantity;
	}

}
