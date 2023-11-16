package com.icia.web.controller;

import java.util.List;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.icia.common.util.StringUtil;
import com.icia.web.model.Admin;
import com.icia.web.model.AucCur;
import com.icia.web.model.AucEvent;
import com.icia.web.model.AucEventCur;
import com.icia.web.model.Auction;
import com.icia.web.model.Comment;
import com.icia.web.model.MyPageNmailSend;
import com.icia.web.model.Paging;
import com.icia.web.model.Response;
import com.icia.web.model.User;
import com.icia.web.model.VoteUpload;
import com.icia.web.service.AdminService;
import com.icia.web.service.AuctionService;
import com.icia.web.service.UserService;
import com.icia.web.util.CookieUtil;
import com.icia.web.util.HttpUtil;

@Controller("auctionController")
public class AuctionController {
	private static Logger logger = LoggerFactory.getLogger(UserController.class);
	
	// 쿠키명
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	@Autowired
	private AuctionService auctionService;
	
	@Autowired
	private AdminService adminService;
	
	@Autowired
	private UserService userService;
	
	public static final int LIST_COUNT = 9;		//한페이지에 게시물 수
	public static final int PAGE_COUNT = 5;		//페이징 수
	
	public static final int E_LIST_COUNT = 6;		//페이징 수
	
	//경매 리스트
	@RequestMapping(value = "/auction/auctionList", method=RequestMethod.GET)
	public String auctionList(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{   
	   //게시물 리스트 조회해서 받을 것
	   List<VoteUpload> list = null;
	   Auction auction = null;
	   
	   list = auctionService.auctionListSelect();
	   
	   if(list != null) 
	   {
	      model.addAttribute("list", list);
	   }      
	   
	   return "/auction/auctionList";
	}

	//경매 상세(내용, 입찰가 내역, 댓글)
	@RequestMapping(value="/auction/auctionDetail")
	public String auctionDetail(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

		long aucSeq = HttpUtil.get(request, "aucSeq", (long)0);
		logger.debug("=========================");
		logger.debug("aucSeq: " + aucSeq);
		logger.debug("=========================");
		
		if(aucSeq != 0) {
			VoteUpload vrDetail = auctionService.auctionDetail(aucSeq);
			
			if(vrDetail != null) {
				model.addAttribute("vrDetail", vrDetail);
				model.addAttribute("aucSeq", aucSeq);
				
				logger.debug("=========================");
				logger.info("vrDetail.getAucStatus(): " + vrDetail.getAucStatus());
				logger.debug("=========================");
			}
			
			List<AucCur> aucCur = auctionService.aucCurListSelect(aucSeq);
			
			if(aucCur != null) {
				model.addAttribute("aucCur", aucCur);
			}
		}
		
		// 댓글 리스트를 조회합니다.
		List<Comment> list = auctionService.commentList(aucSeq);
		
		// 댓글 데이터를 보여주기 위해 뷰로 전달
		model.addAttribute("list",list);
		
		return "/auction/auctionDetail";
	}
	
	@RequestMapping(value="/auction/aucCurProc")
	@ResponseBody
	public Response<Object> aucCurProc(HttpServletRequest request, HttpServletResponse response){
		Response<Object> res = new Response<Object>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String aucCurPrice1 = HttpUtil.get(request, "aucCurPrice", "");
		long aucCurPrice = Long.parseLong(aucCurPrice1.replaceAll(",", ""));
		
		long aucSeq = HttpUtil.get(request, "aucSeq", (long)0);
		
		if(!StringUtil.isEmpty(cookieUserId) && aucSeq != 0 && aucCurPrice != 0) {
			User user = userService.userSelect(cookieUserId);
			
			if(user != null) {
				AucCur aucCurSelect = new AucCur();
				
				aucCurSelect.setUserId(user.getUserId());
				aucCurSelect.setAucSeq(aucSeq);
				aucCurSelect.setAucCurPrice(aucCurPrice);
				
				AucCur aucCur = auctionService.aucCurSelect(aucCurSelect);
				
				try {
					if(aucCur != null) {
						long totalCharge = aucCur.getAucCurPrice() + user.getUserCharge();
						
						logger.debug("#####################################");
						logger.info("totalCharge: " + totalCharge);
						logger.info("aucCur.getAucCurPrice(): "+ aucCur.getAucCurPrice());
						logger.info("user.getUserCharge(): " + user.getUserCharge());
						logger.debug("#####################################");
						if(totalCharge >= aucCurPrice) {
							totalCharge -= aucCurPrice;
							logger.debug("#####################################");
							logger.info("totalCharge: " + totalCharge);
							logger.debug("#####################################");
							
							aucCur.setUserCharge(totalCharge);
							aucCur.setAucCurPrice(aucCurPrice);
							
							if(auctionService.aucCurPriceDeleteNinsert(aucCur) > 0) {
								res.setResponse(1, "입찰 성공");
							}
							else {
								res.setResponse(100, "입찰 진행 중 오류");
							}
						}
						else {
							res.setResponse(0, "충전금 부족");
						}
					}
					else {
						if(user.getUserCharge() >= aucCurPrice) {
							long userCharge = user.getUserCharge() - aucCurPrice;
							logger.debug("####################################");
							logger.debug("user.getUserCharge(): " + user.getUserCharge());
							logger.debug("userCharge: " + userCharge);
							logger.debug("####################################");
							
							aucCurSelect.setUserCharge(userCharge);
							
							if(auctionService.aucCurPriceInsert(aucCurSelect) > 0) {
								res.setResponse(1, "입찰 성공");
							}
							else {
								res.setResponse(100, "입찰 진행 중 오류");
							}
						}
						else {
							res.setResponse(0, "충전금 부족");
						}
					}
				}
				catch(Exception e) {
					logger.error("[AuctionController] aucCurProc Exception", e);
					res.setResponse(100, "입찰 진행 중 오류");
				}
			}
			else {
				res.setResponse(404, "사용자가 아님");
			}
		}
		else {
			res.setResponse(400, "파라미터 부족");
		}
		return res;
	}
	
	// 댓글 작성
	@RequestMapping(value="/auction/cmtWriteProc")
	@ResponseBody
	public Response<Object> cmtWrite(ModelMap model, HttpServletRequest request, HttpServletResponse response){
		Response<Object> rs = new Response<Object>();
			
		// 히든값을 받아온다.
		long aucSeq = HttpUtil.get(request, "aucSeq", (long)0);
		// 아이디 ( 회원만 작성할 수 있게 )
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		// 요청한 댓글 내용
		String cmtContent = HttpUtil.get(request, "cmtContent");

		User user = userService.userSelect(cookieUserId);
			
		if(user != null) // 회원이 아닐 때
		{
			if(!StringUtil.isEmpty(cmtContent)) // 댓글이 비어있지 않을 때
			{
				// 해당 경매번호글에 글을 올릴 때 회원정보, 경매번호, 글내용 저장
				Comment comment = new Comment();
				
				comment.setUserId(cookieUserId); 
				comment.setAucSeq(aucSeq);
				comment.setCmtContent(cmtContent);
				
				if(auctionService.commentInsert(comment) >= 0){
					rs.setResponse(0, "success"); // 성공
						
				}
				else{
					rs.setResponse(500, "no insert"); // 실패
				}
			}
			else{
				rs.setResponse(400, "no text");
			}
		}
		else{
			rs.setResponse(404, "not login");
		}
		
		return rs;
	}
	
	@RequestMapping(value="/auction/auctionResult")
	   public String auctionResult(ModelMap model, HttpServletRequest request, HttpServletResponse response){      
	      long curPage = HttpUtil.get(request, "curPage", (long)1);
	      
	      String searchDate = HttpUtil.get(request, "searchDate", "");
	      
	      List<Auction> list = null;
	      
	      Auction auction = new Auction();
	      
	      long totalCount = 0;
	      
	      Paging paging = null;
	         
	      if(!StringUtil.isEmpty(searchDate)){
	         auction.setSearchDate(searchDate);
	      }
	      
	      totalCount = auctionService.aucResultListCount(auction);
	   
	      logger.debug("========================================");
	      logger.debug("totalCount : " + totalCount);
	      logger.debug("========================================");
	      
	      
	      String date = "";
	      
	      if(totalCount > 0){
	         paging = new Paging("/auction/auctionResult", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");
	         
	         auction.setStartRow(paging.getStartRow());
	         auction.setEndRow(paging.getEndRow());
	                  
	         list = auctionService.aucResultList(auction);
	         
	   
	         for(int i = 0; i < list.size(); i++){
	            auction = list.get(i);
	            
	             date = auction.getAucStartTime();
	             
	             String[] parts = date.split("-"); // 문자열을 "-"를 기준으로 분할
	             String month = parts[1];
	             
	             auction.setAucStartTime(month); 
	         }
	            
	      }
	      
	      model.addAttribute("searchDate",searchDate);
	      model.addAttribute("auction",auction);
	      model.addAttribute("list",list);
	      model.addAttribute("curPage",curPage);
	      model.addAttribute("paging", paging);
	      
	      return "/auction/auctionResult";
	   }



	
	//######################이벤트 경매######################//
	@RequestMapping(value="/auction/aucEventList")
	public String aucEventList(ModelMap model, HttpServletRequest request, HttpServletResponse response){
		
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		
		List<AucEvent> list = null;		
		AucEvent aucEvent = new AucEvent();		
		Paging paging = null;
		long totalCount = 0;
		
		totalCount = auctionService.aucEventListCount(aucEvent);
		
		logger.info("##############################");
		logger.info("totalCount: " + totalCount);
		logger.info("##############################");
	
		if(totalCount > 0)
		{
			paging = new Paging("/auction/aucEventList", totalCount, E_LIST_COUNT, PAGE_COUNT, curPage, "curPage");
			
			aucEvent.setStartRow(paging.getStartRow());
			aucEvent.setEndRow(paging.getEndRow());
		
			list = auctionService.aucEventList(aucEvent);
		}
		
		model.addAttribute("aucEvent",aucEvent);
		model.addAttribute("list", list);
		model.addAttribute("paging",paging);
		model.addAttribute("curPage",curPage);
		
		return "/auction/aucEventList";	
	}

	@RequestMapping(value="/auction/aucEventDetail")
	public String aucEventDetail(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{	
		long aeSeq = HttpUtil.get(request, "aeSeq", (long)0);

		AucEvent aucEvent = auctionService.aucEventDetail(aeSeq);
		
		
		logger.debug("############################");
		logger.debug("aucEvent.getStatus(): " + aucEvent.getStatus());
		logger.debug("############################");
			
		model.addAttribute("aucEvent", aucEvent);
	
		
		return "/auction/aucEventDetail";
	}
	
	@RequestMapping(value="/auction/aeCurProc")
	@ResponseBody
	public Response<Object> aeCurProc(HttpServletRequest request, HttpServletResponse response){
		Response<Object> res = new Response<Object>();

		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long aeSeq = HttpUtil.get(request, "aeSeq", (long)0);
		long aeCurPrice = HttpUtil.get(request, "aeCurPrice", (long)0);
		
		if(!StringUtil.isEmpty(cookieUserId) && aeSeq != 0 && aeCurPrice != 0) {
			User user = userService.userSelect(cookieUserId);
			if(user != null) {
				AucEventCur aucEventCurSelect = new AucEventCur();

				aucEventCurSelect.setUserId(user.getUserId());
				aucEventCurSelect.setAeSeq(aeSeq);
				aucEventCurSelect.setAeCurPrice(aeCurPrice);
				
				AucEventCur aucEventCur = auctionService.aeCurSelect(aucEventCurSelect);
				
				try {
					if(aucEventCur != null) {
						long totalCharge = aucEventCur.getAeCurPrice() + user.getUserCharge();
						
						logger.debug("############################");
						logger.debug("aucCur.getAucCurPrice(): "+ aucEventCur.getAeCurPrice());
						logger.debug("user.getUserCharge(): " + user.getUserCharge());
						logger.debug("totalCharge: " + totalCharge);
						logger.debug("############################");
						
						if(totalCharge >= aeCurPrice) {
							totalCharge -= aeCurPrice;
							logger.debug("############################");
							logger.debug("totalCharge: " + totalCharge);
							logger.debug("############################");
							
							aucEventCur.setUserCharge(totalCharge);
							aucEventCur.setAeCurPrice(aeCurPrice);
							
							if(auctionService.aeCurPriceDeleteNinsert(aucEventCur) > 0) {
								res.setResponse(1, "입찰 성공");
							}
							else {
								res.setResponse(100, "입찰 진행 중 오류");
							}
						}
						else {
							res.setResponse(0, "충전금 부족");
						}
					}
					else {
						if(user.getUserCharge() >= aeCurPrice) {
							long userCharge = user.getUserCharge() - aeCurPrice;
							logger.debug("####################################");
							logger.debug("user.getUserCharge(): " + user.getUserCharge());
							logger.debug("userCharge: " + userCharge);
							logger.debug("####################################");
							
							aucEventCurSelect.setUserCharge(userCharge);
							
							if(auctionService.aeCurPriceInsert(aucEventCurSelect) > 0) {
								res.setResponse(1, "입찰 성공");
							}
							else {
								res.setResponse(100, "입찰 진행 중 오류");
							}
						}
						else {
							res.setResponse(0, "충전금 부족");
						}
					}
				}
				catch(Exception e) {
					logger.error("[AuctionController] aeCurProc Exception", e);
					res.setResponse(100, "입찰 진행 중 오류");
				}
			}
			else {
				res.setResponse(404, "사용자가 아님");
			}
		}
		else {
			res.setResponse(400, "파라미터 부족");
		}

		return res;
		
	}
	
	@RequestMapping(value="/mail/auctionPriceUpdate")
	public void auctionPriceUpdate(HttpServletRequest request, HttpServletResponse response) {
		String date = "202309";
		int cnt = 0;
		
		List<AucCur> aucCurList = auctionService.aucCurSelectForAuctionPriceUpdate(date);
		
		if(aucCurList != null) {		
			for(int i = 0; i < aucCurList.size(); i++) {
				
				AucCur aucCur = aucCurList.get(i);	
				cnt = auctionService.aucBuyPriceUpdate(aucCur);
				
				if(cnt > 0) {
					logger.debug("success");
				}
				else {
					logger.debug("failed");
				}
			}
		}
		else {
			logger.debug("aucCur is null");
		}
	}
	
	/*이벤트 경매 돌려주기 */
	@RequestMapping(value="auction/aeRefundProc",method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> aeRefundProc(HttpServletRequest request, HttpServletResponse response){
		Response<Object> rs = new Response<Object>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long aeSeq = HttpUtil.get(request, "aeSeq", (long)1);		
		AucEventCur aec = null;		
		Admin admin = adminService.adminSelect(cookieUserId);		
		List<AucEventCur> list = auctionService.aeRefundSelect(aeSeq);

		int cnt = 0;		
		if(admin != null){
			if(list != null){
				
				for(int i=0; i<list.size(); i++){
					
					aec = list.get(i);				
					cnt = auctionService.aeRefundUpdate(aec);
					
					if(cnt <= 0){
						rs.setResponse(400, "fail");	
					}
				}
				rs.setResponse(0,"success");
			}
			else{
				rs.setResponse(404,"not found");	
			}
		}
		else{
			rs.setResponse(300, "no admin");
		}
		return rs;
		
	}
		
	//충전금 돌려주고 환불완료 표시
	@RequestMapping(value="/auction/returnProc",method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> returnProc(HttpServletRequest request, HttpServletResponse response){
		
		Response<Object> rs = new Response<Object>();	
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String date = HttpUtil.get(request, "month", "202309"); //월  	
		List<AucCur> list = null;		
		Admin admin = adminService.adminSelect(cookieUserId);		
		AucCur aucCur = null;
	
		if(admin != null){
			list = auctionService.chargeReturnSelect(date);
			
				if(list != null){
					for(int i = 0; i < list.size(); i++){
						aucCur = list.get(i);

						if(auctionService.chargeReturnUpdate(aucCur) <= 0){
							rs.setResponse(300,"fail");
						}
					}
					
					if(auctionService.aucCurStatusUpdate(date) > 0){
						rs.setResponse(0, "success");
					}
					else{
						rs.setResponse(200, "fail");
					}
				}
				else{
					rs.setResponse(404, "not Found");
				}
		}
		else{
			rs.setResponse(400,"admin only");
		}
		
		return rs;
	}
	
	@RequestMapping(value="/mail/mailSend")
	public String mailSendPage(HttpServletRequest request, HttpServletResponse response) {

		return "/mail/mailSend";
	}
	
	
	
}
