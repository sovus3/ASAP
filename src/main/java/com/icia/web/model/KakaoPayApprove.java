package com.icia.web.model;

import java.io.Serializable;
import java.util.Date;

public class KakaoPayApprove implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private String aid;						//요청고유번호
	private String tid;						//결제고유번호
	private String cid;						//가맹점 코드
	private String sid;						//정기결제용ID, 
	private String partner_order_id;		//가맹점 주문번호
	private String partner_user_id;			//가맹점 회원 아이디 
	private String payment_method_type;		//결제수단
	private Amount amount;					//결제 금액 정보 
	private CardInfo card_info;				//결제 상세 정보
	private String item_name;				//상품 이름
	private String item_code;				//상품 코드
	private int quantity;					//상품 수량
	private Date created_at;				//결제 준비 요청 시각
	private Date approved_at;				//결제 승인 시각
	private String payload;					//결제 승인 요청에 대한 저장한 값 
	private String gubunCheck;
		
	public KakaoPayApprove()
	{
		aid="";
		tid="";
		cid="";
		sid="";
		partner_order_id="";
		partner_user_id="";
		payment_method_type="";
		amount=null;
		card_info=null;
		item_name="";
		item_code="";
		quantity=0;
		created_at=null;
		approved_at=null;
		payload="";		
		gubunCheck="";
	}

	public String getAid() {
		return aid;
	}

	public void setAid(String aid) {
		this.aid = aid;
	}

	public String getTid() {
		return tid;
	}

	public void setTid(String tid) {
		this.tid = tid;
	}

	public String getCid() {
		return cid;
	}

	public void setCid(String cid) {
		this.cid = cid;
	}

	public String getSid() {
		return sid;
	}

	public void setSid(String sid) {
		this.sid = sid;
	}

	public String getPartner_order_id() {
		return partner_order_id;
	}

	public void setPartner_order_id(String partner_order_id) {
		this.partner_order_id = partner_order_id;
	}

	public String getPartner_user_id() {
		return partner_user_id;
	}

	public void setPartner_user_id(String partner_user_id) {
		this.partner_user_id = partner_user_id;
	}

	public String getPayment_method_type() {
		return payment_method_type;
	}

	public void setPayment_method_type(String payment_method_type) {
		this.payment_method_type = payment_method_type;
	}

	public Amount getAmount() {
		return amount;
	}

	public void setAmount(Amount amount) {
		this.amount = amount;
	}

	public CardInfo getCard_info() {
		return card_info;
	}

	public void setCard_info(CardInfo card_info) {
		this.card_info = card_info;
	}

	public String getItem_name() {
		return item_name;
	}

	public void setItem_name(String item_name) {
		this.item_name = item_name;
	}

	public String getItem_code() {
		return item_code;
	}

	public void setItem_code(String item_code) {
		this.item_code = item_code;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	public Date getCreated_at() {
		return created_at;
	}

	public void setCreated_at(Date created_at) {
		this.created_at = created_at;
	}

	public Date getApproved_at() {
		return approved_at;
	}

	public void setApproved_at(Date approved_at) {
		this.approved_at = approved_at;
	}

	public String getPayload() {
		return payload;
	}

	public void setPayload(String payload) {
		this.payload = payload;
	}
	
	public String getGubunCheck() {
		return gubunCheck;
	}

	public void setGubunCheck(String gubunCheck) {
		this.gubunCheck = gubunCheck;
	}

}
