package com.icia.web.model;

import java.io.Serializable;

public class Admin implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private String admId;				//관리자 아이디
	private String admPwd;				//관리자 비밀번호
	private String admLevel;			//관리자 등급
	private String admLevelName;		//관리자 등급명
	
	public Admin()
	{
		admId ="";
		admPwd ="";
		admLevel ="";
		admLevelName ="";
	}

	public String getAdmId() {
		return admId;
	}

	public void setAdmId(String admId) {
		this.admId = admId;
	}

	public String getAdmPwd() {
		return admPwd;
	}

	public void setAdmPwd(String admPwd) {
		this.admPwd = admPwd;
	}

	public String getAdmLevel() {
		return admLevel;
	}

	public void setAdmLevel(String admLevel) {
		this.admLevel = admLevel;
	}

	public String getAdmLevelName() {
		return admLevelName;
	}

	public void setAdmLevelName(String admLevelName) {
		this.admLevelName = admLevelName;
	}
	
}
