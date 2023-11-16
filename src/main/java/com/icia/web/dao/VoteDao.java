package com.icia.web.dao;

import java.util.List;
import org.apache.ibatis.annotations.Param;

import org.springframework.stereotype.Repository;

import com.icia.web.model.DateManage;
import com.icia.web.model.VoteList;
import com.icia.web.model.VoteUpload;

@Repository("voteDao")
public interface VoteDao {
	//작품 리스트 조회
	public List<VoteUpload> voteUploadList(VoteUpload voteUpload);	
	//작품 총 개수 조회
	public long voteUploadListCount(VoteUpload voteUpload);	
	//투표날짜 조회
	public DateManage dateSelect(DateManage date);	
	//투표기간 삽입
	public int voteInsert(DateManage date);	
	//작품 업로드
	public int voteUploadInsert(VoteUpload voteUpload);	
	//시퀀스 증가
	public long vrSeqSelect();	
	//작품 상세설명 조회
	public VoteUpload voteDetail(long vrSeq);
	
	public List<VoteUpload> voteResultList(VoteUpload voteUpload);
	
	public long voteResultListCount(VoteUpload voteUpload);
	
	public VoteList voteListSelect(@Param("vrSeq") long seq, @Param("vlUserId")String userId);
	
	//투표 후 중복방지위한 데이터 추가
	public int voteListInsert(VoteList votelist); 

	public int voteCntUpdate(VoteList votelist);
}
