package com.icia.web.model;

import java.io.Serializable;

public class QnaBoard implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private long qaSeq;						//문의글 번호
	private String userId;					//회원 아이디
	private String admId;					//관리자 아이디
	private String qaTitle;					//제목
	private String qaContent;				//내용
	private long qaGroup;					//그룹 번호
	private long qaOrder;					//그룹 내 순서
	private long qaIndent;					//그룹 내 들여쓰기
	private long qaParent;					//부모글 번호
	private String regDate;					//등록일자
	private String status;					//삭제 여부 
	
	private String userNick;
	
	private long startRow;
	private long endRow;
	
	private String searchType;
	private String searchValue;
	

	public QnaBoard()
	{
		qaSeq =0;
		userId ="";
		admId ="";
		qaTitle ="";
		qaContent ="";
		qaGroup =0;
		qaOrder =0;
		qaIndent =0;
		qaParent =0;
		regDate ="";
		status ="";
		
		userNick ="";
		
		startRow =0;
		endRow =0;
		
		searchType ="";
		searchValue ="";
		
	}

	public long getQaSeq() {
		return qaSeq;
	}

	public void setQaSeq(long qaSeq) {
		this.qaSeq = qaSeq;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getAdmId() {
		return admId;
	}

	public void setAdmId(String admId) {
		this.admId = admId;
	}

	public String getQaTitle() {
		return qaTitle;
	}

	public void setQaTitle(String qaTitle) {
		this.qaTitle = qaTitle;
	}

	public String getQaContent() {
		return qaContent;
	}

	public void setQaContent(String qaContent) {
		this.qaContent = qaContent;
	}

	public long getQaGroup() {
		return qaGroup;
	}

	public void setQaGroup(long qaGroup) {
		this.qaGroup = qaGroup;
	}

	public long getQaOrder() {
		return qaOrder;
	}

	public void setQaOrder(long qaOrder) {
		this.qaOrder = qaOrder;
	}

	public long getQaIndent() {
		return qaIndent;
	}

	public void setQaIndent(long qaIndent) {
		this.qaIndent = qaIndent;
	}

	public long getQaParent() {
		return qaParent;
	}

	public void setQaParent(long qaParent) {
		this.qaParent = qaParent;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}

	public String getUserNick() {
		return userNick;
	}

	public void setUserNick(String userNick) {
		this.userNick = userNick;
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

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
	
}
