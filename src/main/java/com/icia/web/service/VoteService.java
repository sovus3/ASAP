package com.icia.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.icia.web.dao.VoteDao;
import com.icia.web.model.DateManage;
import com.icia.web.model.VoteList;
import com.icia.web.model.VoteUpload;

@Service("voteService")
public class VoteService {
	private static Logger logger = LoggerFactory.getLogger(UserService.class);
	
	@Autowired
	private VoteDao voteDao;
	
	//작품 리스트 조회
	public List<VoteUpload> voteUploadList(VoteUpload voteUpload)
	{
		List<VoteUpload> list = null;
		
		try 
		{
			list = voteDao.voteUploadList(voteUpload);
		}
		catch(Exception e) 
		{
			logger.error("[VoteService] voteUploadList Exception", e);
		}
		
		return list;
	}
	
	//작풍 총 개수 조회
	public long voteUploadListCount(VoteUpload voteUpload) 
	{
		long count = 0;
		
		try 
		{
			count = voteDao.voteUploadListCount(voteUpload);
		}
		catch(Exception e) 
		{
			logger.error("[VoteService] voteUploadListCount Exception", e);
		}
		
		return count;
	}
	
	//2번
	public DateManage dateSelect(DateManage d)
	{
		DateManage date = null;
				
		try
		{
			date = voteDao.dateSelect(date);
		}
		catch(Exception e)
		{
			logger.error("[VoteService] dataSelect Exception",e);
		}
		
		return date;
	}
	
	// 1번 데이터 집어넣기
	public int voteInsert(DateManage date)
	{
		int count = 0;
		
		try
		{
			count = voteDao.voteInsert(date);
		}
		catch(Exception e)
		{
			logger.error("[VoteService]voteInsert Exception", e);
		}
		
		return count;
	}
	
	//작품 업로드
	public int voteUploadInsert(VoteUpload voteUpload) {
		int cnt = 0;
		
		try {
			cnt = voteDao.voteUploadInsert(voteUpload);
		}
		catch(Exception e) {
			logger.error("[VoteService] voteUploadInsert Exception: " + e);
		}
		
		return cnt;
	}
	
	//시퀀스 증가
	public long vrSeqSelect() {
		long seq = 0;
		
		try {
			seq = voteDao.vrSeqSelect();
		}
		catch(Exception e) {
			logger.error("[VoteService] vrSeqSelect Exception: " + e);
		}
		
		return seq;
	}
	
	//작품 상세설명 조회
	public VoteUpload voteDetail(long vrSeq) 
	{
		VoteUpload voteUpload = null;
		
		try 
		{
			voteUpload = voteDao.voteDetail(vrSeq);
		}
		catch(Exception e)
		{
			logger.error("[VoteService] voteDetail Exception", e);
		}
		
		return voteUpload;
	}
	
	public List<VoteUpload> voteResultList(VoteUpload voteUpload)
	{
		List<VoteUpload> list = null;
		
		try 
		{
			list=voteDao.voteResultList(voteUpload);
		}
		catch(Exception e)
		{
			logger.error("[BoardService] NoticeBoardList Exception", e);
		}
		return list;
	}
	//작풍 총 개수 조회
	public long voteResultListCount(VoteUpload voteUpload) 
	{
		long count = 0;
		
		try 
		{
			count = voteDao.voteResultListCount(voteUpload);
		}
		catch(Exception e) 
		{
			logger.error("[VoteService] voteResultListCount Exception", e);
		}
		
		return count;
	}

	public VoteList voteListSelect(long vrSeq, String userId)
	{
		VoteList voteList = null;

		try
		{
			voteList = voteDao.voteListSelect(vrSeq, userId);
		}
		catch(Exception e)
		{
			logger.error("[VoteService] voteListSelect Exception",e );
		}
	
		return voteList;
	}
	//투표 후 중복방지위한 데이터 추가
	public int voteListInsert(VoteList votelist)
	{
		int count = 0;
		
		try
		{
			count = voteDao.voteListInsert(votelist); 
		}
		catch(Exception e)
		{
			logger.error("[VoteService] voteListInsert Exception", e);
		}

		return count;
	}
	public int voteCntUpdate(VoteList votelist)
	{
		int count = 0;
		
		try
		{
			count = voteDao.voteCntUpdate(votelist);
		}
		catch(Exception e)
		{
			logger.error("[VoteService] voteListInsert Exception", e);
		}
	
		return count;
	}
}
