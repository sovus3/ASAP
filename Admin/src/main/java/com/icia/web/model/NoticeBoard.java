package com.icia.web.model;

import java.io.Serializable;

public class NoticeBoard implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private long nbSeq;					//공지글 번호
	private String admId;				//관리자 아이디
	private String nbTitle;				//제목
	private String nbContent;			//내용
	private String regDate;				//등록일
	
	private long startRow;
	private long endRow;
	
	private String searchType;
	private String searchValue;

	public NoticeBoard()
	{
		nbSeq =0;
		admId ="";
		nbTitle ="";
		nbContent ="";
		regDate ="";
		searchType ="";
		searchValue ="";
	}

	public long getNbSeq() {
		return nbSeq;
	}

	public void setNbSeq(long nbSeq) {
		this.nbSeq = nbSeq;
	}

	public String getAdmId() {
		return admId;
	}

	public void setAdmId(String admId) {
		this.admId = admId;
	}

	public String getNbTitle() {
		return nbTitle;
	}

	public void setNbTitle(String nbTitle) {
		this.nbTitle = nbTitle;
	}

	public String getNbContent() {
		return nbContent;
	}

	public void setNbContent(String nbContent) {
		this.nbContent = nbContent;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
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
	
	
}
