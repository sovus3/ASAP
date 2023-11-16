package com.icia.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.icia.web.dao.MyPageDao;
import com.icia.web.model.MyPage;
import com.icia.web.model.OrderDetail;
import com.icia.web.model.Pay;
import com.icia.web.model.QnaBoard;
import com.icia.web.model.VoteList;
import com.icia.web.model.VoteUpload;

@Service("MyPageService")
public class MyPageService {
	private static Logger logger = LoggerFactory.getLogger(MyPageService.class);
	
	@Autowired
	MyPageDao mpDao;
	
	public List<OrderDetail> orderDSelect(OrderDetail orderDetail){
		List<OrderDetail> list = null;
		
		try {
			list = mpDao.orderDSelect(orderDetail);
		}
		catch(Exception e) {
			logger.error("[myPageService] orderDSelect Exception", e);
		}
		
		return list;
	}
	
	//주문 상세 총 개수
	public long orderDCount(long orderNo) {
		long count = 0;
		
		try {
			count = mpDao.orderDCount(orderNo);
		}
		catch(Exception e) {
			logger.error("[myPageService] orderDCount Exception", e);
		}
		return count;
	}
	
	//리뷰 작성시 리뷰 상태 업데이트
	public int orderDUpdate(OrderDetail orderDetail) {
		int count = 0;
		
		try {
			count = mpDao.orderDUpdate(orderDetail);
		}
		catch(Exception e) {
			logger.error("[myPageService] orderDUpdate Exception", e);
		}
		return count;
	}
	
	//결제내역
	public List<Pay> payList(Pay pay){
		List<Pay> list = null;
		
		try {
			list = mpDao.payList(pay);
		}
		catch(Exception e) {
			logger.error("[myPageService] payList Exception", e);
		}
		return list;
	}
	
	//결제내역 총 개수
	public long payListCount(String userId) {
		long count = 0;
		
		try {
			count = mpDao.payListCount(userId);
		}
		catch(Exception e) {
			logger.error("[myPageService] payListCount Exception", e);
		}
		return count;
	}
	
	//리뷰 상품명 가져오기
	public String reviewPName(long productSeq) {
		String product = null;
		
		try {
			product = mpDao.reviewPName(productSeq);
		}
		catch(Exception e) {
			logger.error("[myPageService] reviewPName Exception", e);
		}
		
		return product;
	}
	
	//투표
	public List<VoteUpload> voteUpload(VoteUpload voteUpload) {
		List<VoteUpload> list = null;
		
		try {
			list = mpDao.voteUpload(voteUpload);
		}
		catch(Exception e) {
			logger.error("[myPageService] voteUpload Exception", e);
		}
		return list;
	}

	public long voteUploadCount(String userId) {
		long count = 0;
		
		try {
			count = mpDao.voteUploadCount(userId);
		}
		catch(Exception e) {
			logger.error("[myPageService] voteUploadCount Exception", e);
		}
		return count;
	}
	//결제내역 총 개수
	public List<VoteUpload> voteList(VoteUpload voteUpload){
		List<VoteUpload> list = null;
		
		try {
			list = mpDao.voteList(voteUpload);
		}
		catch(Exception e) {
			logger.error("[myPageService] voteList Exception", e);
		}
		return list;
	}
	public long voteListCount(VoteList voteList){
		long count = 0;
		
		try {
			count = mpDao.voteListCount(voteList);
		}
		catch(Exception e) {
			logger.error("[myPageService] voteListCount Exception", e);
		}
		return count;
	}
	
	//문의 내역
	public List<QnaBoard> myPageQnaBoardSelect(QnaBoard qnaBoardParam) {
		List<QnaBoard> qnaBoard = null;
		
		try {
			qnaBoard = mpDao.myPageQnaBoardSelect(qnaBoardParam);
		}
		catch(Exception e) {
			logger.error("[MyPageService] myPageQnaBoardSelect Exception", e);
		}
		
		return qnaBoard;
	}
	
	public long myPageQnaTotalCount(String userId) {
		long totalCnt = 0;
		
		try {
			totalCnt = mpDao.myPageQnaTotalCount(userId);
		}
		catch(Exception e) {
			logger.error("[MyPageService] myPageQnaTotalCount Exception", e);
		}
		
		return totalCnt;
	}
	
	public QnaBoard myPageQnaDetail(long qaSeq) {
		QnaBoard qnaBoard = null;
		
		try {
			qnaBoard = mpDao.myPageQnaDetail(qaSeq);
		}
		catch(Exception e) {
			logger.error("[MyPageService] myPageQnaDetail Exception", e);
		}
		
		return qnaBoard;
	}
	//입찰 내역
	public List<MyPage> mpAucCurList(MyPage myPage){
		
		List<MyPage> list = null;
	
		try{
			list = mpDao.mpAucCurList(myPage);
		}
		catch(Exception e){
			logger.error("[MyPageService] mpAucCurSelect Exception",e);
		}
		
		return list;
	}
	
	public long mpAucCurListCount(String userId){
		long count = 0;
		
		try{
			count = mpDao.mpAucCurListCount(userId);
		}
		catch(Exception e){
			logger.error("[MyPageService] mpAucCurListCount Exception",e);
		}
	
		return count;		
	}
	
	public List<MyPage> mpAucResultList(MyPage myPage){
		List<MyPage> list = null;
		
		try{
			list = mpDao.mpAucResultList(myPage);
		}
		catch(Exception e){
			logger.error("[MyPageService] mpAucResultList Exception",e);
		}
	
		return list;
					
	}
	
	public long mpAucResultListCount(String userId){
		long cnt = 0;
		
		try{
			cnt = mpDao.mpAucResultListCount(userId);
		}
		catch(Exception e){
			logger.error("[MyPageService] mpAucResultListCount Exception",e);
		}
		
		return cnt;
	}
	
	public List<MyPage> mpAucEventList(MyPage myPage){
		List<MyPage> list = null;
		
		try{
			list = mpDao.mpAucEventList(myPage);
		}
		catch(Exception e){
			logger.error("[MyPageService] mpAucEventList Exception",e);
		}
		
		return list;
	}
	
	public long mpAucEventListCount(String userId){
		long cnt = 0;
		
		try{
			cnt = mpDao.mpAucEventListCount(userId);
		}
		catch(Exception e){
			logger.error("[MyPageService] mpAucEventListCount Exception",e);
		}

		return cnt;
	}
}
