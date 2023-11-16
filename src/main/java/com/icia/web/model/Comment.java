package com.icia.web.model;

import java.io.Serializable;

public class Comment implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private long cmtSeq;				//댓글 번호(SEQ)
	private String userId;				//회원 아이디
	private long aucSeq;				//경매 번호
	private long cmtGroup;				//그룹 번호
	private long cmtOrder;				//그룹 내 순서
	private long cmtIndent;				//그룹 내 들여쓰기
	private String cmtContent;			//댓글 내용
	private long cmtParent;				//부모글 번호
	private String regDate;				//등록일
	
	private String userNick; // 회원 닉네임
	
	public Comment()
	{
		cmtSeq =0;
		userId ="";
		aucSeq =0;
		cmtGroup =0;
		cmtOrder =0;
		cmtIndent =0;
		cmtContent ="";
		cmtParent =0;
		regDate ="";
		
		userNick = "";
	}

	public String getUserNick() {
		return userNick;
	}

	public void setUserNick(String userNick) {
		this.userNick = userNick;
	}

	public long getCmtSeq() {
		return cmtSeq;
	}

	public void setCmtSeq(long cmtSeq) {
		this.cmtSeq = cmtSeq;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public long getAucSeq() {
		return aucSeq;
	}

	public void setAucSeq(long aucSeq) {
		this.aucSeq = aucSeq;
	}

	public long getCmtGroup() {
		return cmtGroup;
	}

	public void setCmtGroup(long cmtGroup) {
		this.cmtGroup = cmtGroup;
	}

	public long getCmtOrder() {
		return cmtOrder;
	}

	public void setCmtOrder(long cmtOrder) {
		this.cmtOrder = cmtOrder;
	}

	public long getCmtIndent() {
		return cmtIndent;
	}

	public void setCmtIndent(long cmtIndent) {
		this.cmtIndent = cmtIndent;
	}

	public String getCmtContent() {
		return cmtContent;
	}

	public void setCmtContent(String cmtContent) {
		this.cmtContent = cmtContent;
	}

	public long getCmtParent() {
		return cmtParent;
	}

	public void setCmtParent(long cmtParent) {
		this.cmtParent = cmtParent;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}
}
