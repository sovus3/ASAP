package com.icia.web.service;

import java.util.List;

import javax.annotation.PostConstruct;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.icia.web.dao.AuctionDao;
import com.icia.web.model.AucCur;
import com.icia.web.model.AucEvent;
import com.icia.web.model.AucEventCur;
import com.icia.web.model.Auction;
import com.icia.web.model.Comment;
import com.icia.web.model.MyPageNmailSend;
import com.icia.web.model.VoteUpload;

@Service("AuctionService")
public class AuctionService {

	private static Logger logger = LoggerFactory.getLogger(AuctionService.class);
	
	@Autowired
	AuctionDao auctionDao;
	
	//경매 list
	public List<VoteUpload> auctionListSelect() {
		List<VoteUpload> list = null;
		
		try{
			list = auctionDao.auctionListSelect();
		}
		catch(Exception e){
			logger.error("[AuctionService] auctionListSelect Exception", e);
		}
		
		return list;
	}
	
	//경매 detail
	public VoteUpload auctionDetail(long aucSeq) {
		VoteUpload voteUpload = null;
		
		try{
			voteUpload = auctionDao.auctionDetail(aucSeq);
		}
		catch(Exception e){
			logger.error("[AuctionService] auctionDetail Exception", e);
		}
		
		
		return voteUpload;
	}
	
	//입찰가 내역
	public List<AucCur> aucCurListSelect(long aucSeq) {
		List<AucCur> aucCur = null;
		
		try{
			aucCur = auctionDao.aucCurListSelect(aucSeq);
		}
		catch(Exception e){
			logger.error("[AuctionService] aucCurSelect Exception", e);
		}
		
		return aucCur;
	}
	
	public Auction auctionSelect(long aucSeq) {
		Auction auction = null;
		
		try{
			auction = auctionDao.auctionSelect(aucSeq);
		}
		catch(Exception e){
			logger.error("[AuctionService] auctionSelect Exception", e);
		}
		
		return auction;
	}
	
	public AucCur aucCurSelect(AucCur aucCur) {
		AucCur aucCur1 = null;
		
		try{
			aucCur1 = auctionDao.aucCurSelect(aucCur);
		}
		catch(Exception e){
			logger.error("[AuctionService] aucCurPriceInsert Exception", e);
		}
		
		return aucCur1;
	}
	
	//aucCur조회가 안됐을 떄
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public int aucCurPriceInsert(AucCur aucCurSelect) throws Exception {
		int cnt = 0;
		
		if(auctionDao.aucCurPriceInsert(aucCurSelect) > 0) {
			cnt = auctionDao.userChargeUpdate(aucCurSelect);
		}
		
		return cnt;
	}
	
	//aucCur조회가 됐을 때
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public int aucCurPriceDeleteNinsert(AucCur aucCur) throws Exception  {
		int cnt = 0;
		
		if(auctionDao.aucCurPriceDelete(aucCur) > 0) {
			if(auctionDao.userChargeUpdate(aucCur) > 0) {
				cnt = auctionDao.aucCurPriceInsert(aucCur);
			}
		}
		
		return cnt;
	}
	
	public List<Comment> commentList(long aucSeq){
		List<Comment> comm = null;
		
		try {
			comm = auctionDao.commentList(aucSeq);
		}
		catch(Exception e){
			logger.error("[AuctionService] commentList Exception", e);
		}
	
		return comm;
	
	}

	public int commentInsert(Comment comment){
		int count = 0;
		
		try{
			count = auctionDao.commentInsert(comment);
		}
		catch(Exception e){
			logger.error("[AuctionService] commentInsert Exception",e);
		}
		
		return count;
	}
	//메일 발송
	public List<MyPageNmailSend> myPageNmailSendSelect(String date) {
		
		List<MyPageNmailSend> myPageNmailSend = null;
		
		try{
			myPageNmailSend = auctionDao.myPageNmailSendSelect(date);
		}
		catch(Exception e){
			logger.error("[AuctionService] myPageNmailSendSelect Exception",e);
		}
		
		return myPageNmailSend;
	}
	//경매 상태를 R -> Y로 변경(경매 시작)
	public int auctionStatusToY() {
		int cnt = 0;
		
		try{
			cnt = auctionDao.auctionStatusToY();
		}
		catch(Exception e){
			logger.error("[AuctionService] auctionStatusToY Exception",e);
		}
		
		return cnt;
	}
	/*
	public int aucCurChangeToY(String date) {
		int cnt = 0;
		
		try{
			cnt = auctionDao.aucCurChangeToY(date);
		}
		catch(Exception e){
			logger.error("[AuctionService] auctionStatusToY Exception",e);
		}
		
		return cnt;
	}*/
	
	//경매 상태를 Y -> N로 변경(경매 종료)
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public int auctionStatusToN(String date) throws Exception {
		int cnt = 0;
		
		if(auctionDao.auctionStatusToN() > 0) {
			cnt = auctionDao.aucCurChangeToY(date);
		}
		
		return cnt;
	}
	
	public List<Auction> aucResultList(Auction auction){
	      List<Auction> list = null;
	      
	      try{
	         list = auctionDao.aucResultList(auction);
	      }
	      catch(Exception e){
	         logger.error("[AuctionService] aucResultList Exception",e);
	      }
	      return list;
	   }

	
	public long aucResultListCount(Auction auction){
	      long count = 0;
	      
	      try{
	         count = auctionDao.aucResultListCount(auction);
	      }
	      catch(Exception e){
	         logger.error("[AuctionService] aucResultListCount Exception",e);
	      }
	      
	      return count;
	   }


	
	public List<AucEvent> aucEventList(AucEvent aucEvent){
		List<AucEvent> list = null;
		
		try{
			list = auctionDao.aucEventList(aucEvent);
		}
		catch(Exception e){
			logger.error("[AuctionService] aucEventList Exception",e);
		}

		return list;
	}
	
	public AucEvent aucEventDetail(long aeSeq){
		AucEvent aucEvent = null;
	
		try{
			aucEvent = auctionDao.aucEventDetail(aeSeq);
		}
		catch(Exception e){
			logger.error("[AuctionService] aucEventDetail Exception",e);
		}
		
		return aucEvent;
	}
	
	public long aucEventListCount(AucEvent aucEvent){
		long count = 0;
		
		try{
			count = auctionDao.aucEventListCount(aucEvent);
		}
		catch(Exception e){
			logger.error("[AuctionService] aucEventListCount Exception",e);
		}
		
		return count;
	}

	// 충전금
	public List<AucCur> chargeReturnSelect(String date){
		List<AucCur> list = null;
		
		try{
			list = auctionDao.chargeReturnSelect(date);
		}
		catch(Exception e){
			logger.error("[auctionService] aucRefundSelect Exception",e);
		}
		
		return list;		
	}
	
	
	public int chargeReturnUpdate(AucCur aucCur){
		int count = 0;
		
		try{
			count = auctionDao.chargeReturnUpdate(aucCur);

		}
		catch(Exception e){
			logger.error("[auctionService] aucRefundUpdate Exception",e);
		}
		
		return count;
	}
	
	//환불 후 상태 'N'인 사람들 환불완료 'C' 상태로 바꿔주기
	public int aucCurStatusUpdate(String date){
		int count = 0;
		
		try{
			count = auctionDao.aucCurStatusUpdate(date);
		}
		catch(Exception e){
			logger.error("[AuctionService] aucCurStatusUpdate Exception",e);
		}
		
		return count;
	}
	
	public AucEventCur aeCurSelect(AucEventCur aucEventCur1) {
		AucEventCur aucEventCur = null;
		
		try{
			aucEventCur = auctionDao.aeCurSelect(aucEventCur1);
		}
		catch(Exception e){
			logger.error("[AuctionService] aucCurPriceInsert Exception", e);
		}
		
		return aucEventCur;
	}
	
	//aeCur조회가 안됐을 떄
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public int aeCurPriceInsert(AucEventCur aucEventCur) throws Exception {
		int cnt = 0;
		
		if(auctionDao.aeCurPriceInsert(aucEventCur) > 0) {
			cnt = auctionDao.userChargeUpdateAeVer(aucEventCur);
		}
		
		return cnt;
	}
	
	//aeCur조회가 됐을 때
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public int aeCurPriceDeleteNinsert(AucEventCur aucEventCur) throws Exception  {
		int cnt = 0;
		
		if(auctionDao.aeCurPriceDelete(aucEventCur) > 0) {
			if(auctionDao.userChargeUpdateAeVer(aucEventCur) > 0) {
				cnt = auctionDao.aeCurPriceInsert(aucEventCur);
			}
		}
		
		return cnt;
	}
	
	public List<AucCur> aucCurSelectForAuctionPriceUpdate(String date){
		List<AucCur> aucCur = null;
		
		try{
			aucCur = auctionDao.aucCurSelectForAuctionPriceUpdate(date);
		}
		catch(Exception e){
			logger.error("[AuctionService] aucCurSelectForAuctionPriceUpdate Exception", e);
		}
		
		return aucCur;
	}
	//auction aucBuyPrice update
	public int aucBuyPriceUpdate(AucCur aucCur) {
		int cnt = 0;
		
		try{
			cnt = auctionDao.aucBuyPriceUpdate(aucCur);
		}
		catch(Exception e){
			logger.error("[AuctionService] aucBuyPriceUpdate Exception", e);
		}
		
		return cnt;
	}

	//이벤트 경매 입찰내역 환불
	public List<AucEventCur> aeRefundSelect(long aeSeq){
		List<AucEventCur> list = null;
		
		try{
			list = auctionDao.aeRefundSelect(aeSeq);
		}
		catch(Exception e){
			logger.error("[AuctionService] aeRefundSelect Exception",e);
		}
		
		return list;
		
	}
	
	public int aeRefundUpdate(AucEventCur aucEventCur){
		int count = 0;
		
		try{
			count = auctionDao.aeRefundUpdate(aucEventCur);
		}
		catch(Exception e){
			logger.error("[AuctionService] aeRefundUpdate Exception",e);
		}
		
		return count;
	}
	
	
	
	
}
