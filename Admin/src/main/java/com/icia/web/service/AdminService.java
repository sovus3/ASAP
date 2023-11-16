package com.icia.web.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.icia.web.dao.AdminDao;
import com.icia.web.model.AucCur;
import com.icia.web.model.AucEvent;
import com.icia.web.model.AucEventCur;

import java.util.List;
import com.icia.web.model.Admin;
import com.icia.web.model.Auction;
import com.icia.web.model.OrderDetail;
import com.icia.web.model.Pay;
import com.icia.web.model.Product;
import com.icia.web.model.QnaBoard;
import com.icia.web.model.User;
import com.icia.web.model.VoteList;
import com.icia.web.model.VoteUpload;

@Service("adminService")
public class AdminService {
	private static Logger logger = LoggerFactory.getLogger(UserService.class);
	
	@Autowired
	private AdminDao adminDao;
	
	//관리자 조회
	public Admin adminSelect(String admId) {
		Admin admin = null;
		
		try {
			admin = adminDao.adminSelect(admId);
		}
		catch (Exception e) {
			logger.error("[adminService] adminSelect Exception", e);
		}
		
		return admin;
	}
	
	public List<VoteUpload> voteUploadToAucSelect(VoteUpload voteUpload) {
		List<VoteUpload> list = null;
		
		try {
			list = adminDao.voteUploadToAucSelect(voteUpload);
		}
		catch (Exception e) {
			logger.error("[adminService] voteUploadToAucSelect Exception", e);
		}
		
		return list;
	}
	
	public long voteUploadToAucTotalCnt(VoteUpload voteUpload) {
		long cnt = 0;
		
		try {
			cnt = adminDao.voteUploadToAucTotalCnt(voteUpload);
		}
		catch (Exception e) {
			logger.error("[adminService] voteUploadToAucTotalCnt Exception", e);
		}
		
		return cnt;
	}
	
	public VoteUpload voteUploadToAucInsert(long vrSeq) {
		VoteUpload voteUpload = null;
		
		try {
			voteUpload = adminDao.voteUploadToAucInsert(vrSeq);
		}
		catch (Exception e) {
			logger.error("[adminService] voteUploadToAucInsert Exception", e);
		}
		
		return voteUpload;
	}

	public int auctionInsertToR(Auction auction) {
		int cnt = 0;
		
		try {
			cnt = adminDao.auctionInsertToR(auction);
		}
		catch (Exception e) {
			logger.error("[adminService] auctionInsertToR Exception", e);
		}
		
		return cnt;
	}
	
	public List<AucCur> aucCurListSelect(AucCur aucCur){
		List<AucCur> list = null;	
		
		try {
			list = adminDao.aucCurListSelect(aucCur);
		}
		catch (Exception e) {
			logger.error("[adminService] aucCurListSelect Exception", e);
		}		
		
		return list;
	}
	
	public long aucCurTotalCount(AucCur aucCur) {
		long cnt = 0;
		
		try {
			cnt = adminDao.aucCurTotalCount(aucCur);
		}
		catch (Exception e) {
			logger.error("[adminService] aucCurTotalCount Exception", e);
		}	

		return cnt;
		
	}
	
	public List<Auction> auctionListSelect(Auction auction){
		List<Auction> list = null;
		
		try {
			list = adminDao.auctionListSelect(auction);
		}
		catch (Exception e) {
			logger.error("[adminService] aucCurTotalCount Exception", e);
		}
		
		return list;
	}
	
	public long auctionTotalCount(Auction auction) {
		long cnt = 0;
		
		try {
			cnt = adminDao.auctionTotalCount(auction);
		}
		catch (Exception e) {
			logger.error("[adminService] aucCurTotalCount Exception", e);
		}
		
		return cnt;
	}
	//게시판
	//답변 없는 게시물만 보이게
	public List<QnaBoard> AdminQnaNo(QnaBoard qnaBoard){
		List<QnaBoard> list = null;
		
		try {
			list = adminDao.AdminQnaNo(qnaBoard);
		}
		catch(Exception e) {
			logger.error("[BoardService] AdminQnaNo Exception", e);
		}
		
		return list;
	}
	
	//답변 없는 게시물 총 개수
	public int AdminQnaNoCnt(QnaBoard qnaBoard) {
		int count = 0;
		
		try {
			count = adminDao.AdminQnaNoCnt(qnaBoard);
		}
		catch(Exception e) {
			logger.error("[BoardService] AdminQnaNoCnt Exception", e);
		}
		
		return count;
	}
	
	//답변 있는 게시물만 보이게
	public List<QnaBoard> AdminQnaYes(QnaBoard qnaBoard){
		List<QnaBoard> list = null;
		
		try {
			list = adminDao.AdminQnaYes(qnaBoard);
		}
		catch(Exception e) {
			logger.error("[BoardService] AdminQnaNo Exception", e);
		}
		
		return list;
	}
	
	//답변 없는 게시물 총 개수
	public int AdminQnaYesCnt(QnaBoard qnaBoard) {
		int count = 0;
		
		try {
			count = adminDao.AdminQnaYesCnt(qnaBoard);
		}
		catch(Exception e) {
			logger.error("[BoardService] AdminQnaNoCnt Exception", e);
		}
		
		return count;
	}
	
	public List<Pay> payList(Pay pay){
		List<Pay> list = null;
		
		try{
			list = adminDao.payList(pay);
		}
		catch (Exception e){
			logger.error("[AdminService] payList Exception", e);
		}
		
		return list;
	}
	
	public int payListCount(Pay pay){
		int count = 0;
		
		try {
			count = adminDao.payListCount(pay);
		}
		catch(Exception e) {
			logger.error("[AdminService] payListCount Exception", e);
		}
		
		return count;
	}
	
	public List<Product> productList(Product Product){
		List<Product> list = null;
		
		try {
			list = adminDao.productList(Product);
		}
		catch(Exception e) {
			logger.error("[AdminService] productList Exception", e);
		}
		
		return list;
	}
	
	public long productListCount(Product Product){
		long count = 0;
		
		try {
			count = adminDao.productListCount(Product);
		}
		catch(Exception e) {
			logger.error("[AdminService] productListCount Exception", e);
		}
		
		return count;
	}
	
	public Product productDetail(long productSeq) {
		Product product = null;
		
		try {
			product = adminDao.productDetail(productSeq);
		}
		catch(Exception e) {
			logger.error("[ProductService] productDetail Exception", e);
		}
		
		return product;
	}
	
	//주문 상세 내역
	public List<OrderDetail> orderDSelect(OrderDetail orderDetail){
		List<OrderDetail> list = null;
		
		try {
			list = adminDao.orderDSelect(orderDetail);
		}
		catch(Exception e) {
			logger.error("[AdminService] orderDSelect Exception", e);
		}
		
		return list;
	}
	
	//주문 상세 총 개수
	public long orderDCount(long orderNo) {
		long count = 0;
		
		try {
			count = adminDao.orderDCount(orderNo);
		}
		catch(Exception e) {
			logger.error("[AdminService] orderDCount Exception", e);
		}
		return count;
	}
	
	public int productInsert(Product product) {
		int count = 0;
		
		try {
			count = adminDao.productInsert(product);
		}
		catch(Exception e) {
			logger.error("[AdminService] productInsert Exception: " + e);
		}
		
		return count;
	}	
	
	public long productSeqSelect() {
		long count = 0;
		
		try {
			count = adminDao.productSeqSelect();
		}
		catch(Exception e) {
			logger.error("[AdminService] productSeqSelect Exception: " + e);
		}
		
		return count;
	}
	
	public int productUpdate(Product product){
		int count = 0;
		
		try{
			count = adminDao.productUpdate(product);
		}
		catch(Exception e){
			logger.error("[AdminService] productUpdate Exception",e);
		}
		
		return count;
	}
	
	public int productDelete(long productSeq){
		int count = 0;
		
		try {
			count = adminDao.productDelete(productSeq);
		}
		catch(Exception e) {
			logger.error("[AdminService] productDelete Exception", e);
		}
		
		return count;
	}
	
	public List<User> userListSelect(User user){
		List<User> list = null;
		
		try {
			list = adminDao.userListSelect(user);
		}
		catch(Exception e) {
			logger.error("[AdminService] userListSelect Exception", e);
		}
		
		return list;
	}
	
	public long userListTotalCount(User user) {
		long totalCount = 0;
		
		try {
			totalCount = adminDao.userListTotalCount(user);
		}
		catch(Exception e) {
			logger.error("[AdminService] userListSelect Exception", e);
		}
		
		return totalCount;
	}
	
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
	public int userCodeUpdate(String userId) {
		int cnt = 0;
		
		if(adminDao.userFeeUpdate(userId) > 0) {
			cnt = adminDao.userCodeUpdate(userId);
		}
		
		return cnt;
	}
	
	public int userChargePlus(User user) {
		int cnt = 0;
		
		try {
			cnt = adminDao.userChargePlus(user);
		}
		catch(Exception e) {
			logger.error("[AdminService] userChargePlus Exception", e);
		}
		
		return cnt;
		
	}

	public int userUpdateAdmin(User user) {
		int cnt = 0;
		
		try {
			cnt = adminDao.userUpdateAdmin(user);
		}
		catch(Exception e) {
			logger.error("[AdminService] userChargePlus Exception", e);
		}
		
		return cnt;
	}
	

	
	// 투표 작품 조회 
	public List<VoteUpload> admVoteUploadList(VoteUpload voteUpload)
	{
		List<VoteUpload> list = null;
		
		try
		{
			list = adminDao.admVoteUploadList(voteUpload);
		}
		catch(Exception e)
		{
			logger.error("[AdminService] admVoteUploadList Exception",e);	
		}
		
		return list;
	}
	
	
	// 투표 작품 조회 건수 
	public long admVoteUploadListCount(VoteUpload voteUpload)
	{
		long count = 0;
		
		try
		{
			count = adminDao.admVoteUploadListCount( voteUpload);
		}
		catch(Exception e)
		{
			logger.error("[AdminService] admVoteUploadListCount Exception",e);	
		}
		
		
		return count;
	}
	
	// 투표 작품 P - > R 로 변경
	public int vuStatusUpdate(long vrSeq)
	{
		int cnt = 0;
		
		try
		{
			cnt = adminDao.vuStatusUpdate(vrSeq);
		}
		catch(Exception e)
		{
			logger.error("[AdminService] vuStatusUpdate Exception",e);
		}
		
		return cnt;
		
	}
	
	// 누가 투표했는지 조회
	public List<VoteList> admVoteList(VoteList voteList){
	List<VoteList> list = null;
	  
	try{
		list = adminDao.admVoteList(voteList);
	}
	catch(Exception e){
		logger.error("[AdminService] admVoteList Exception",e);
	}
	  
	return list;
		      
	}

	
	// 누가 투표했는지 조회 ( 건수 ) 
	public long admVoteListCount(VoteList votelist){
		
	long cnt = 0;
	   
	try{
		cnt = adminDao.admVoteListCount(votelist);
	}
		catch(Exception e){
			logger.error("[AdminService] admVoteListCount Exception",e);
	}
	 
	return cnt;
	
	}

	
	
	
	// 이벤트 입낙찰자 내역 조회
	public List<AucEventCur> admAucEventCurList(AucEventCur aucEventCur)
	{
		List<AucEventCur> list = null;
		
		try
		{
			list = adminDao.admAucEventCurList(aucEventCur);	
		}
		catch(Exception e)
		{
			logger.error("[AdminService] admAucEventList Exception",e);		
		}
	
	
		return list;
	}
	
	// 건수
	public long admAucEventListCurCount(AucEventCur aucEventCur)
	{
		long cnt = 0;
		
		try
		{
			cnt = adminDao.admAucEventListCurCount(aucEventCur);
		}
		catch(Exception e)
		{
			logger.error("[AdminService]  admAucEventListCount Exception",e);
		}
	
		return cnt;
	}
	
	
	// 이벤트 경매 상태 조회
	public List<AucEvent> admAucEventList(AucEvent aucEvent)
	{
		List<AucEvent> list = null;
		
		try
		{
			list = adminDao.admAucEventList(aucEvent);
		}
		catch(Exception e)
		{
			logger.error("[AdminService] admAucEventList Exception",e);
		}
		
		return list;
	}

	// 건수
	public long admAucEventListCount(AucEvent aucEvent)
	{
		long cnt = 0;
		
		try
		{
			cnt = adminDao.admAucEventListCount(aucEvent);
		}
		catch(Exception e)
		{
			logger.error("[AdminService] admAucEventListCount Exception",e);
		}
		
		return cnt;
		
	}
	
	
	// 상태가 N인 사람들 조회
	public List<AucEventCur> admAeReturnSelect(long aeSeq)
	{
		List<AucEventCur> list = null;
		
		try
		{
			list = adminDao.admAeReturnSelect(aeSeq);
		}
		catch(Exception e)
		{
			logger.error("[AdminService] admAeReturnSelect Exception",e);
		}
		
		return list;
	}
	
	
	// N인 사람들에게 돈 돌려주기 
	public int admAeReturnUpdate(AucEventCur aucEventCur)
	{
		int cnt = 0;
		
		try
		{
			cnt = adminDao.admAeReturnUpdate(aucEventCur);
		}
		catch(Exception e)
		{
			logger.error("[AdminService] admAeReturnUpdate Exception",e);
		}
		
		return cnt;
		
	}
	
	
	
	// 상태 N -> C 환불완료 상태 변경
	public int admAeStatusUpdate(long aeSeq)
	{
		int cnt = 0;
	
		try
		{
			cnt = adminDao.admAeStatusUpdate(aeSeq);
		}
		catch(Exception e)
		{
			logger.error("[AdminService] admAeReturnUpdate Exception",e);
		}
		
		return cnt;
	
	}
	
	
	/* 이벤트 경매  */
	
	// 업로드를 위한 SEQ값 증가
	public long aeSeqSelect()
	{
		long seq = 0;
		
		try
		{
			seq = adminDao.aeSeqSelect();
		}
		catch(Exception e)
		{
			logger.error("[AdminService] aeSeqSelect Exception",e);
		}

		return seq;
	}
	
	// 작품 업로드 INSERT
	public int admAeInsert(AucEvent aucEvent)
	{
		int cnt = 0;
		
		try
		{
			cnt = adminDao.admAeInsert(aucEvent);
		}
		catch(Exception e)
		{
			logger.error("[AdminService] admAeInsert Exception",e);
		}
		
		return cnt;
		
	}
	
	// 이벤트 경매 상태 R -> Y
		public int admAeStatusUpdateY(long aeSeq)
		{
			int cnt = 0;

			try
			{
				cnt = adminDao.admAeStatusUpdateY(aeSeq);
			}
			catch(Exception e)
			{
				logger.error("[AdminService] admAeStatusUpdateY Exception",e);
			}

			return cnt;
		}
		
		// 이벤트 경매 상태 Y -> N
		public int admAeStatusUpdateN(long aeSeq)
		{
			int cnt = 0;
			
			try
			{
				cnt = adminDao.admAeStatusUpdateN(aeSeq);
			}
			catch(Exception e)
			{
				logger.error("[AdminService] admAeStatusUpdateN Exception",e);
			}
			
			
			return cnt;
		}

		// 낙찰자 뽑기 'Y'

		public int admBidUpdateY(long aeSeq)
		{
			int cnt = 0;
			
			try
			{
				cnt = adminDao.admBidUpdateY(aeSeq);
			}
			catch(Exception e)
			{
				logger.error("[AdminService] admBidUpdateY Exception",e);
			}
			
			
			
			return cnt;
			
		}


}
