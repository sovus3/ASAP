package com.icia.web.dao;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.icia.web.model.AucCur;
import com.icia.web.model.AucEvent;
import com.icia.web.model.AucEventCur;
import com.icia.web.model.Auction;
import com.icia.web.model.Comment;
import com.icia.web.model.MyPageNmailSend;
import com.icia.web.model.User;
import com.icia.web.model.VoteUpload;
import com.icia.web.service.AuctionService;
import com.icia.web.service.BoardService;

@Repository("ActionDao")
public interface AuctionDao {
	//경매 list 
	public List<VoteUpload> auctionListSelect();
	//경매 detail
	public VoteUpload auctionDetail(long aucSeq);
	//입찰가 내역
	public List<AucCur> aucCurListSelect(long aucSeq);
	//Auction select
	public Auction auctionSelect(long aucSeq);
	//이벤트 cur insert
	public int aucCurPriceInsert(AucCur aucCur);
	//이벤트 cur delete
	public int aucCurPriceDelete(AucCur aucCur);
	//이벤트cur select
	public AucCur aucCurSelect(AucCur aucCur);
	//userCharge update(경매)
	public int userChargeUpdate(AucCur aucCur);
	// 댓글 리스트 조회
	public List<Comment> commentList(long aucSeq);
	// 댓글 등록
	public int commentInsert(Comment comment);
	//aucCur 입찰 여부 상태 변경
	public int aucCurChangeToY(String date);
	//마이페이지 메일 송신을 위한 select
	public List<MyPageNmailSend> myPageNmailSendSelect(String date);
	//최종 낙찰가 update를 위한 aucCur select
	public List<AucCur> aucCurSelectForAuctionPriceUpdate(String date);
	//auction aucBuyPrice update
	public int aucBuyPriceUpdate(AucCur aucCur);
	//auction 경매 상태 변경(R->Y)
	public int auctionStatusToY();
	//auction 경매 상태 변경(Y->N)
	public int auctionStatusToN();
	//auction 입찰 실패한 인간들 조회
	public List<AucCur> chargeReturnSelect(String date);
	//auction 돈 돌려주기
	public int chargeReturnUpdate(AucCur aucCur);
	//auction 환불 후 상태 변경
	public int aucCurStatusUpdate(String date);
	//경매 결과 리스트 조회
	public List<Auction> aucResultList(Auction auction);
	//경매 결과 건수
	public long aucResultListCount(Auction auction);
	//이벤트 경매 LIST
	public List<AucEvent> aucEventList(AucEvent aucEvent);
	//이벤트 경매 Detail
	public AucEvent aucEventDetail(long aeSeq);
	//이벤트 경매 총 건수
	public long aucEventListCount(AucEvent aucEvent);
	//이벤트 경매cur select
	public AucEventCur aeCurSelect(AucEventCur aucEventCur);
	//이벤트 경매cur delete
	public int aeCurPriceDelete(AucEventCur aucEventCur);
	//이벤트 경매cur insert
	public int aeCurPriceInsert(AucEventCur aucEventCur);
	//userCharge update(이벤트 경매)
	public int userChargeUpdateAeVer(AucEventCur aucEventCur);
	//입찰 실패한 인간들 조회(이벤트 경매 결과)
	public List<AucEventCur> aeRefundSelect(long aeSeq);
	//돈 돌려주기(이벤트 경매 결과)
	public int aeRefundUpdate(AucEventCur aucEventCur); 
	

}
