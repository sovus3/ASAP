package com.icia.web.model;

import java.io.Serializable;

public class DateManage implements Serializable {

	private static final long serialVersionUID = 1L;
	   
	private String uploadStartDate;
	private String uploadEndDate;
	
	public DateManage()
	{
		uploadStartDate="";
		uploadEndDate="";
	}

	public String getUploadStartDate() {
		return uploadStartDate;
	}

	public void setUploadStartDate(String uploadStartDate) {
		this.uploadStartDate = uploadStartDate;
	}

	public String getUploadEndDate() {
		return uploadEndDate;
	}

	public void setUploadEndDate(String uploadEndDate) {
		this.uploadEndDate = uploadEndDate;
	}
	
}
