package com.icia.web.model;

import java.io.Serializable;
import java.util.Date;

public class KakaoPayReady implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private String tid;								//결제 고유 번호 
	private String next_redirect_app_url;
	private String next_redirect_mobile_url;
	
	private String next_redirect_pc_url;
	
	private String android_app_scheme;
	private String ios_app_scheme;					//함수를 호출하고 값을 반환하는 대신 주어진 환경에서 
													//메모리 주소를 점프하며 함수만 갈아끼우는 
													//획기적인 방식을 구현하기 위한 프로토타입 언어
	private Date created_at;						//결제 준비 요청 시간
	
	private String gubunCheck;
	
	public KakaoPayReady()
	{
		tid="";							
		next_redirect_app_url="";		
		next_redirect_mobile_url="";								
		next_redirect_pc_url="";		
		android_app_scheme="";		
		ios_app_scheme="";			
		created_at=null;
		gubunCheck="";
	}

	public String getTid() {
		return tid;
	}

	public void setTid(String tid) {
		this.tid = tid;
	}

	public String getNext_redirect_app_url() {
		return next_redirect_app_url;
	}

	public void setNext_redirect_app_url(String next_redirect_app_url) {
		this.next_redirect_app_url = next_redirect_app_url;
	}

	public String getNext_redirect_mobile_url() {
		return next_redirect_mobile_url;
	}

	public void setNext_redirect_mobile_url(String next_redirect_mobile_url) {
		this.next_redirect_mobile_url = next_redirect_mobile_url;
	}

	public String getNext_redirect_pc_url() {
		return next_redirect_pc_url;
	}

	public void setNext_redirect_pc_url(String next_redirect_pc_url) {
		this.next_redirect_pc_url = next_redirect_pc_url;
	}

	public String getAndroid_app_scheme() {
		return android_app_scheme;
	}

	public void setAndroid_app_scheme(String android_app_scheme) {
		this.android_app_scheme = android_app_scheme;
	}

	public String getIos_app_scheme() {
		return ios_app_scheme;
	}

	public void setIos_app_scheme(String ios_app_scheme) {
		this.ios_app_scheme = ios_app_scheme;
	}

	public Date getCreated_at() {
		return created_at;
	}

	public void setCreated_at(Date created_at) {
		this.created_at = created_at;
	}

	public String getGubunCheck() {
		return gubunCheck;
	}

	public void setGubunCheck(String gubunCheck) {
		this.gubunCheck = gubunCheck;
	}
	
	
}
