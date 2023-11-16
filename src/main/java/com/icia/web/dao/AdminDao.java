package com.icia.web.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.icia.web.model.Admin;
import com.icia.web.model.AucCur;
import com.icia.web.model.AucEvent;
import com.icia.web.model.AucEventCur;
import com.icia.web.model.Auction;
import com.icia.web.model.OrderDetail;
import com.icia.web.model.Pay;
import com.icia.web.model.Product;
import com.icia.web.model.QnaBoard;
import com.icia.web.model.User;
import com.icia.web.model.VoteList;
import com.icia.web.model.VoteUpload;

@Repository("adminDao")
public interface AdminDao {
	//관리자 조회
	public Admin adminSelect(String admId);
	//경매
	public List<VoteUpload> voteUploadToAucSelect(VoteUpload voteUpload);
	
	public long voteUploadToAucTotalCnt(VoteUpload voteUpload);
	
	public VoteUpload voteUploadToAucInsert(long vrSeq);
	
	public int auctionInsertToR(Auction auction);
	
	public List<AucCur> aucCurListSelect(AucCur aucCur);
	
	public long aucCurTotalCount(AucCur aucCur);
	
	public List<Auction> auctionListSelect(Auction auction);
	
	public long auctionTotalCount(Auction auction);
	
	//게시판
	//답변 없는 게시물만 보이게
	public List<QnaBoard> AdminQnaNo(QnaBoard qnaBoard);	
	//답변 없는 게시물 총 개수
	public int AdminQnaNoCnt(QnaBoard qnaBoard);	
	//답변 있는 게시물만 보이게
	public List<QnaBoard> AdminQnaYes(QnaBoard qnaBoard);	
	//답변 있는 게시물 총 개수
	public int AdminQnaYesCnt(QnaBoard qnaBoard);
	
	//상품
	public List<Pay> payList(Pay pay);
	
	public int payListCount(Pay pay);
	
	public List<Product> productList(Product product);
	
	public long productListCount(Product product);
	//상품 상세 페이지 조회
	public Product productDetail(long productSeq);	
	//주문 상세, 추후 위치 변경 예정
	public List<OrderDetail> orderDSelect(OrderDetail orderDetail);	
	//주문 상세 총 개수
	public long orderDCount(long orderNo);
	
	public long productSeqSelect();
	
	public int productInsert(Product product);
	
	public int productUpdate(Product product);
	
	public int productDelete(long productSeq);
	
	//회원
	public List<User> userListSelect(User user);
	
	public long userListTotalCount(User user);
	
	public int userCodeUpdate(String userId);
	
	public int userFeeUpdate(String userId);
	
	public int userChargePlus(User user);
	
	public int userUpdateAdmin(User user);
	
	//투표, 이벤트 경매
	// 관리할 작품신청 리스트 조회
	public List<VoteUpload> admVoteUploadList(VoteUpload voteUpload);
	
	public long admVoteUploadListCount(VoteUpload voteUpload);	
	// 투표한 사람 리스트 조회	
	public List<VoteList> admVoteList(VoteList voteList);
	   
	public long admVoteListCount(VoteList voteList);
		
	// 상태 변경 승인 'P'(신청) - > 'R'(예정)
	public int vuStatusUpdate(long vrSeq);
	/* 이벤트 경매 입찰낙찰 내역 */
	public List<AucEventCur> admAucEventCurList(AucEventCur aucEventCur);
	
	public long admAucEventListCurCount(AucEventCur aucEventCur);	
	/* 이벤트 경매 관리 내역 조회 */
	public List<AucEvent> admAucEventList(AucEvent aucEvent);
	
	public long admAucEventListCount(AucEvent aucEvent);	
	/* 입찰 실패한 사람 돈 돌려주고 상태 변경 */	
	public List<AucEventCur> admAeReturnSelect(long aeSeq);
	
	public int admAeReturnUpdate(AucEventCur aucEventCur);
	
	public int admAeStatusUpdate(long aeSeq);

	// 경매 종료 후 낙찰로 상태 변경 
	public int admBidUpdateY(long aeSeq);		
	/* 경매 샐프 시작, 종료 버튼*/		
	public int admAeStatusUpdateY(long aeSeq);
	
	public int admAeStatusUpdateN(long aeSeq);
	/* 이벤트 경매 업로드 */		
	public long aeSeqSelect();
	
	public int admAeInsert(AucEvent aucEvent);

}
