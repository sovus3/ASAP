/**
 * <pre>
 * 프로젝트명 : BasicBoard
 * 패키지명   : com.icia.web.model
 * 파일명     : User.java
 * 작성일     : 2021. 1. 12.
 * 작성자     : daekk
 * </pre>
 */
package com.icia.web.model;

import java.io.Serializable;

/**
 * <pre>
 * 패키지명   : com.icia.web.model
 * 파일명     : User.java
 * 작성일     : 2021. 1. 12.
 * 작성자     : daekk
 * 설명       : 사용자 모델
 * </pre>
 */
public class User implements Serializable
{
	private static final long serialVersionUID = 8638989512396268543L;
	
	private String userId;			//회원 아이디
	private String userPwd;			//비밀번호 
	private String userNick;		//닉네임 
	private String userName;		//이름 
	private String userPhone;		//전화번호 
	private String userAddr;		//주소 
	private String userEmail;		//이메일 
	private String userCode;		//회원 구분 코드 
	private String status;			//회원상태 
	private String userFee;			//회원비 입금 여부 
	private long userCharge;		//충전금/포인트 
	private String userPostcode;
	
	private String searchType;
	private String searchValue;
	private long startRow;		
	private long endRow;	

	public User()
	{
		 userId="";		
		 userPwd="";		
		 userNick="";	
		 userName="";	
		 userPhone="";	
		 userAddr="";	 
		 userEmail="";	
		 userCode="";	
		 status="";		
		 userFee="";		
		 userCharge=0;		 
		 userPostcode="";
		 
		searchType ="";
		searchValue ="";
		startRow = 0;
		endRow = 0;
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

	public String getUserPostcode() {
		return userPostcode;
	}

	public void setUserPostcode(String userPostcode) {
		this.userPostcode = userPostcode;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUserPwd() {
		return userPwd;
	}

	public void setUserPwd(String userPwd) {
		this.userPwd = userPwd;
	}

	public String getUserNick() {
		return userNick;
	}

	public void setUserNick(String userNick) {
		this.userNick = userNick;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUserPhone() {
		return userPhone;
	}

	public void setUserPhone(String userPhone) {
		this.userPhone = userPhone;
	}

	public String getUserAddr() {
		return userAddr;
	}

	public void setUserAddr(String userAddr) {
		this.userAddr = userAddr;
	}

	public String getUserEmail() {
		return userEmail;
	}

	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}

	public String getUserCode() {
		return userCode;
	}

	public void setUserCode(String userCode) {
		this.userCode = userCode;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getUserFee() {
		return userFee;
	}

	public void setUserFee(String userFee) {
		this.userFee = userFee;
	}

	public long getUserCharge() {
		return userCharge;
	}

	public void setUserCharge(long userCharge) {
		this.userCharge = userCharge;
	}

}
