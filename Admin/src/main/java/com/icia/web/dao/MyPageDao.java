package com.icia.web.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.icia.web.model.MyPage;
import com.icia.web.model.OrderDetail;
import com.icia.web.model.Pay;
import com.icia.web.model.QnaBoard;
import com.icia.web.model.VoteList;
import com.icia.web.model.VoteUpload;

@Repository("MyPageDao")
public interface MyPageDao {
	//주문 상세, 추후 위치 변경 예정
	public List<OrderDetail> orderDSelect(OrderDetail orderDetail);	
	//주문 상세 총 개수
	public long orderDCount(long orderNo);	
	//리뷰 작성시 리뷰 상태 업데이트
	public int orderDUpdate(OrderDetail orderDetail);	
	//결제내역
	public List<Pay> payList(Pay pay);	
	//결제내역 총 개수
	public long payListCount(String userId);	
	//리뷰 상품명 가져오기
	public String reviewPName(long productSeq);
	//투표업로드 내역
	public List<VoteUpload> voteUpload(VoteUpload voteUpload);	
	//투표업로드카운트 
	public long voteUploadCount(String userId);	
	//투표리스트 조회
	public List<VoteUpload> voteList(VoteUpload voteUpload);

	public long voteListCount(VoteList voteList);
	//문의 내역
	public List<QnaBoard> myPageQnaBoardSelect(QnaBoard qnaBoard);
	
	public long myPageQnaTotalCount(String userId);
	
	public QnaBoard myPageQnaDetail(long qaSeq);
	//입찰 내역
	public List<MyPage> mpAucCurList(MyPage myPage);

	public long mpAucCurListCount(String userId);	

	public List<MyPage> mpAucEventList(MyPage myPage);		

	public long mpAucEventListCount(String userId);
	
	public List<MyPage> mpAucResultList(MyPage myPage);
	
	public long mpAucResultListCount(String userId);

	

}
