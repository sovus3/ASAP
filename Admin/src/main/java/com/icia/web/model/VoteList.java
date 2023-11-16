package com.icia.web.model;

import java.io.Serializable;

public class VoteList implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private long vrSeq;				//투표글 번호
	private String vlUserId;		//투표자 아이디
	
	private long categoryNo;		
	private String voteDate;
	/* 추가 231006 */
	private String vlSearchType;
	private String vlSearchValue;
	/* 추가 끝 231006 */
	private long startRow;
	private long endRow;

	
	public VoteList()
	{
		vrSeq =0;
		vlUserId ="";
		
		categoryNo =0;
		voteDate = "";
		
		/* 추가 231006 */
		vlSearchType = "";
		vlSearchValue = "";
		/* 추가 끝 231006 */
		
		startRow = 0;
		endRow = 0; 

	}

	public String getVoteDate() {
		return voteDate;
	}

	public void setVoteDate(String voteDate) {
		this.voteDate = voteDate;
	}

	/* 추가 231006 */

	public String getVlSearchType() {
		return vlSearchType;
	}

	public void setVlSearchType(String vlSearchType) {
		this.vlSearchType = vlSearchType;
	}

	public String getVlSearchValue() {
		return vlSearchValue;
	}

	public void setVlSearchValue(String vlSearchValue) {
		this.vlSearchValue = vlSearchValue;
	}

	/* 추가 끝 231006 */
	
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

	public long getVrSeq() {
		return vrSeq;
	}

	public void setVrSeq(long vrSeq) {
		this.vrSeq = vrSeq;
	}

	public String getVlUserId() {
		return vlUserId;
	}

	public void setVlUserId(String vlUserId) {
		this.vlUserId = vlUserId;
	}

	public long getCategoryNo() {
		return categoryNo;
	}

	public void setCategoryNo(long categoryNo) {
		this.categoryNo = categoryNo;
	}
	

}
