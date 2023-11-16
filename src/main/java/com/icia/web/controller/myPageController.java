package com.icia.web.controller;

import java.util.List;

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
import com.icia.web.model.MyPage;
import com.icia.web.model.NoticeBoard;
import com.icia.web.model.OrderDetail;
import com.icia.web.model.Paging;
import com.icia.web.model.Pay;
import com.icia.web.model.QnaBoard;
import com.icia.web.model.Response;
import com.icia.web.model.Review;
import com.icia.web.model.User;
import com.icia.web.model.VoteList;
import com.icia.web.model.VoteUpload;
import com.icia.web.service.AdminService;
import com.icia.web.service.MyPageService;
import com.icia.web.service.OrderService;
import com.icia.web.service.ProductService;
import com.icia.web.service.UserService;
import com.icia.web.util.CookieUtil;
import com.icia.web.util.HttpUtil;
import com.icia.web.util.JsonUtil;

@Controller("myPageController")
public class myPageController {
	
	private static final Logger logger = LoggerFactory.getLogger(myPageController.class);
	
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	@Autowired
	UserService userService;
	
	@Autowired
	MyPageService mpService;
	
	@Autowired
	ProductService productService;
	
	@Autowired
	AdminService adminService;
	
	@Autowired
	private OrderService orderService;
	
	private static final int LIST_COUNT = 10;	//한페이지의 게시물 수 
	private static final int PAGE_COUNT = 5; 	//페이징 수 
	
	//마이페이지 메인
	@RequestMapping(value = "/myPage/myPageMain")
	public String myPageMain(ModelMap model, HttpServletRequest request, HttpServletResponse response) 
	{
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		User user = userService.userSelect(cookieUserId);
		
		model.addAttribute("user", user);
		
		return "/myPage/myPageMain";
	}

	// 회원정보수정 폼
	@RequestMapping(value = "/myPage/userUpdate")
	public String updateForm(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		User user = userService.userSelect(cookieUserId);
	
		model.addAttribute("user", user);
	
		return "/myPage/userUpdate";
	}

	//회원정보 수정
	@RequestMapping(value = "/myPage/updateProc")
	@ResponseBody
	public Response<Object> updateProc(HttpServletRequest request, HttpServletResponse response) {
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
	
		String userPwd = HttpUtil.get(request, "userPwd");
		String userName = HttpUtil.get(request, "userName");
		String userPhone = HttpUtil.get(request, "userPhone");
		String userAddr = HttpUtil.get(request, "userAddr");
		String userEmail = HttpUtil.get(request, "userEmail");
		String userPostcode = HttpUtil.get(request, "userPostcode");
	
		Response<Object> ajaxResponse = new Response<Object>();
	
		if (!StringUtil.isEmpty(cookieUserId)) {
			User user = userService.userSelect(cookieUserId);
	
			if (user != null) {
				if (!StringUtil.isEmpty(userPwd) && !StringUtil.isEmpty(userName) && !StringUtil.isEmpty(userPhone)
						&& !StringUtil.isEmpty(userAddr) && !StringUtil.isEmpty(userEmail)) {
					user.setUserPwd(userPwd);
					user.setUserName(userName);
					user.setUserPhone(userPhone);
					user.setUserAddr(userAddr);
					user.setUserEmail(userEmail);
					user.setUserPostcode(userPostcode);
	
					if (userService.userUpdate(user) > 0) {
						ajaxResponse.setResponse(0, "success");
					} else {
						ajaxResponse.setResponse(500, "Server error");
					}
				} else {
	
					ajaxResponse.setResponse(400, "Bad Request");
				}
			} else {
	
				CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
				ajaxResponse.setResponse(404, "Not Found");
			}
		} else {
			ajaxResponse.setResponse(400, "Bad Request");
		}
	
		if (logger.isDebugEnabled()) {
			logger.debug("[UserController]/user/updateProc response\n" + JsonUtil.toJsonPretty(ajaxResponse));
		}
	
		return ajaxResponse;
	}
	
	//주문 상세 내역 테스트
	   @RequestMapping(value = "/myPage/myPageOrderDetail")
	   public String myPageOrderDetail(ModelMap model, HttpServletRequest request, HttpServletResponse response) 
	   {
	      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
	      User user = userService.userSelect(cookieUserId);
	      
	      List<OrderDetail> list = null;
	      OrderDetail orderDetail = new OrderDetail();
	      //현재 페이지
	      long curPage = HttpUtil.get(request, "curPage", (long)1);
	      long totalCount = 0;
	      //페이징 객체
	      Paging paging = null;
	      long reviewSeq = HttpUtil.get(request, "reviewSeq", (long)0);
	      long orderNo = HttpUtil.get(request, "orderNo", (long)0);
	      
	      Review review = productService.reviewSelect(reviewSeq);
	      
	      orderDetail.setUserId(cookieUserId);
	      
	      totalCount = mpService.orderDCount(orderNo);
	      
	      logger.debug("totalCount : " + totalCount);
	      
	      if(totalCount > 0) 
	      {
	         paging = new Paging("/myPage/myPageOrderDetail", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");
	         
	         orderDetail.setOrderNo(orderNo);
	         orderDetail.setStartRow(paging.getStartRow());
	         orderDetail.setEndRow(paging.getEndRow());
	         
	         if(StringUtil.equals(cookieUserId, orderDetail.getUserId())) 
	         {
	            list = mpService.orderDSelect(orderDetail);
	         }
	      }
	      
	      model.addAttribute("orderNo", orderNo);
	      model.addAttribute("review", review);
	      model.addAttribute("list", list);
	      model.addAttribute("orderDetail", orderDetail);
	      model.addAttribute("curPage", curPage);
	      model.addAttribute("paging", paging);
	      model.addAttribute("user", user);
	      
	      return "/myPage/myPageOrderDetail";
	   }
	   
	   //결제 내역
	   @RequestMapping(value = "/myPage/myPagePay")
	   public String myPagePay(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
	      //현재 페이지
	      long curPage = HttpUtil.get(request, "curPage", (long)1);
	      List<Pay> list = null;
	      Pay pay = new Pay();
	      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
	      long totalCount = 0;
	      //페이징 객체
	      Paging paging = null; 
	      pay.setUserId(cookieUserId);
	      
	      User user = userService.userSelect(cookieUserId);
	  
	      logger.debug("totalCount : " + totalCount);  
	      totalCount = mpService.payListCount(cookieUserId);  
	      logger.debug("totalCount : " + totalCount);
	  
	      if(totalCount > 0) {
	         paging = new Paging("/myPage/myPagePay", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");
	 
	         pay.setStartRow(paging.getStartRow());
	         pay.setEndRow(paging.getEndRow());
	 
	         if(StringUtil.equals(cookieUserId, pay.getUserId())) {
	            list = mpService.payList(pay);
	         }
	 
	         logger.debug("totalCount : " + pay.getEndRow());
	         logger.debug("totalCount : " + pay.getStartRow());
	      }
	  
	      model.addAttribute("user", user);
	      model.addAttribute("list", list);
	      model.addAttribute("pay", pay);
	      model.addAttribute("curPage", curPage);
	      model.addAttribute("paging", paging);
	  
	      return "/myPage/myPagePay";
	   }
	//투표
	@RequestMapping(value = "/myPage/myPageVote")
	public String myPageVote(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		User user = userService.userSelect(cookieUserId);
		List<VoteUpload> list = null;
		List<VoteUpload> list1 = null;
		VoteUpload voteUpload =new VoteUpload();
		VoteUpload voteUpload1 =new VoteUpload();
		VoteList voteList = new VoteList();
		//조회항목(1:미술, 2:사진, 3:도예)
		int searchType = HttpUtil.get(request, "searchType",0);
		
		voteList.setVlUserId(user.getUserId());
		if(!StringUtil.isEmpty(searchType))
		{
			voteUpload1.setCategoryNo(searchType);
			voteList.setCategoryNo(searchType);
		}
		
		if(user != null)
		{
			voteUpload1.setUserId(user.getUserId());
			voteUpload1.setStartRow(1);
			voteUpload1.setEndRow(5);
			
			list1 = mpService.voteList(voteUpload1);
			logger.debug(user.getUserCode());
			if(StringUtil.equals(user.getUserCode(), "A"))
			{
				voteUpload.setUserId(user.getUserId());
				voteUpload.setStartRow(1);
				voteUpload.setEndRow(2);
				
				list = mpService.voteUpload(voteUpload);					
			}
		}
		
		model.addAttribute("user", user);
		model.addAttribute("list", list);
		model.addAttribute("list1", list1);
		return "/myPage/myPageVote";
	}
	
	@RequestMapping(value = "/myPage/myPageVoteUpload")
	public String myPageVoteUpload(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		User user = userService.userSelect(cookieUserId);
		List<VoteUpload> list = null;
		VoteUpload voteUpload = new VoteUpload();
		Paging paging = null;
		long totalCount = 0;
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		
		totalCount = mpService.voteUploadCount(user.getUserId());
		if(user != null)
		{
			if(totalCount > 0) {
				paging = new Paging("/vote/voteList", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");
				voteUpload.setUserId(user.getUserId());
				voteUpload.setStartRow(paging.getStartRow());
				voteUpload.setEndRow(paging.getEndRow());
				
				list = mpService.voteUpload(voteUpload);
			}					
		}

		model.addAttribute("paging",paging);
		model.addAttribute("user", user);
		model.addAttribute("list", list);
		return "/myPage/myPageVoteUpload";
	}
	
	@RequestMapping(value = "/myPage/myPageVoteList")
	public String myPageVoteList(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		User user = userService.userSelect(cookieUserId);
		List<VoteUpload> list1 = null;
		VoteUpload voteUpload1 =new VoteUpload();
		VoteList voteList = new VoteList();
		Paging paging1 = null;
		//조회항목(1:미술, 2:사진, 3:도예)
		int searchType = HttpUtil.get(request, "searchType",0);
		int gubun = HttpUtil.get(request, "searchType",0);
		long totalCount1 = 0;
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		
		voteList.setVlUserId(user.getUserId());
		if(!StringUtil.isEmpty(searchType))
		{
			voteUpload1.setCategoryNo(searchType);
			voteList.setCategoryNo(searchType);
		}
		totalCount1 = mpService.voteListCount(voteList);
		
		if(user != null) {
			if(totalCount1 > 0){

			paging1 = new Paging("/vote/voteList", totalCount1, LIST_COUNT, PAGE_COUNT, curPage, "curPage");
			voteUpload1.setUserId(user.getUserId());
			voteUpload1.setStartRow(paging1.getStartRow());
			voteUpload1.setEndRow(paging1.getEndRow());
			
			list1 = mpService.voteList(voteUpload1);
			}
		}

		model.addAttribute("paging1",paging1);
		model.addAttribute("gubun",gubun);
		model.addAttribute("user", user);
		model.addAttribute("list1", list1);
		model.addAttribute("curPage",curPage);
		return "/myPage/myPageVoteList";
	}
	
	//문의 내역
	@RequestMapping(value="myPage/myPageQna")
	public String myPageQna(ModelMap model, HttpServletRequest reqeust, HttpServletResponse Response) {
		
		long curPage = HttpUtil.get(reqeust, "curPage", (long)1);
		String cookieUserId = CookieUtil.getHexValue(reqeust, AUTH_COOKIE_NAME);
		long totalCount = 0;
		Paging paging = null;
		QnaBoard qnaBoard = new QnaBoard();
		List<QnaBoard> list = null;
		
		User user = userService.userSelect(cookieUserId);
		String userId = "";
		
		if(user != null) {
			userId = user.getUserId();

			totalCount = mpService.myPageQnaTotalCount(userId);
			
			if(totalCount > 0){
				paging = new Paging("/myPage/myPageQnaBoard", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");
				
				qnaBoard.setUserId(userId);
				qnaBoard.setStartRow(paging.getStartRow());
				qnaBoard.setEndRow(paging.getEndRow());
				
				list = mpService.myPageQnaBoardSelect(qnaBoard);			
			}
		}
			
		model.addAttribute("user", user);
		model.addAttribute("curPage",curPage);
		model.addAttribute("list", list);
		model.addAttribute("paging", paging);
		
		return "/myPage/myPageQna";
	}
	
	@RequestMapping(value="/myPage/myPageQnaDetail")
	public String myPageQnaDetail(ModelMap model, HttpServletRequest reqeust, HttpServletResponse Response) {
		
		String cookieUserId = CookieUtil.getHexValue(reqeust, AUTH_COOKIE_NAME);
		String boardMe ="N";
		
		User user = userService.userSelect(cookieUserId);
		Admin admin = adminService.adminSelect(cookieUserId);

		long qaSeq = HttpUtil.get(reqeust, "qaSeq", (long)0);
		QnaBoard qnaBoard = null;
		
		if(qaSeq != 0) {
			qnaBoard = mpService.myPageQnaDetail(qaSeq);
			
			if(qnaBoard != null && user != null) {
				if(StringUtil.equals(qnaBoard.getUserId(), user.getUserId())) {
					boardMe = "Y";
				}
			}
			else if(qnaBoard != null && admin != null) {
				if(StringUtil.equals(qnaBoard.getAdmId(), admin.getAdmId()))
					boardMe = "A";
			}
		}
		model.addAttribute("boardMe", boardMe);
		model.addAttribute("qnaBoard", qnaBoard);
		model.addAttribute("user", user);
		
		return "/myPage/myPageQnaDetail";
	}
	
	@RequestMapping(value="/myPage/myPageQnaUpdate")
	public String qnaUpdateForm(ModelMap model,HttpServletRequest request, HttpServletResponse response){
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long qaSeq = HttpUtil.get(request, "qaSeq", (long)0);
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		
		QnaBoard qnaBoard = null;
		User user = null;
		
		if(qaSeq > 0){
			qnaBoard = mpService.myPageQnaDetail(qaSeq);

			model.addAttribute("curPage", curPage);
			model.addAttribute("qnaBoard", qnaBoard);
			model.addAttribute("user", user);
		}
		return "/myPage/myPageQnaUpdate";
	}
	
	// 회원 입찰 내역 ( 일반, 이벤트 ) 
	@RequestMapping(value="/myPage/myPageAucCur")
	public String myPageAucCur(ModelMap model, HttpServletRequest request, HttpServletResponse response){
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		long aucCurPage = HttpUtil.get(request, "aucCurPage", (long)1);
		long eventCurPage = HttpUtil.get(request, "eventCurPage", (long)1);
		
		List<MyPage> listAuc = null; // 내가 입찰한 리스트
		List<MyPage> listEvent = null;
		
		MyPage aucCur = new MyPage();
		MyPage eventCur = new MyPage();
		
		User user = null;
	
		Paging aucPage = null;
		Paging eventPage = null;
		
		long aucTotalCnt = 0;
		long eventTotalCnt = 0;
		
		aucTotalCnt = mpService.mpAucCurListCount(cookieUserId);
		eventTotalCnt = mpService.mpAucEventListCount(cookieUserId);
		
		user = userService.userSelect(cookieUserId);
		
		model.addAttribute("user",user);
		
		if(aucTotalCnt > 0){
			aucPage = new Paging("/myPage/aucCur", aucTotalCnt, LIST_COUNT, PAGE_COUNT, aucCurPage, "aucCurPage");
			
			aucCur.setStartRow(aucPage.getStartRow());
			aucCur.setEndRow(aucPage.getEndRow());
			aucCur.setUserId(cookieUserId);
			
			model.addAttribute("aucPage",aucPage);
			
			if(user != null){
				listAuc = mpService.mpAucCurList(aucCur);

				model.addAttribute("listAuc", listAuc);		
			}
		}
		
		if(eventTotalCnt > 0){
			eventPage = new Paging("/myPage/aucCur", eventTotalCnt, LIST_COUNT, PAGE_COUNT, eventCurPage, "eventCurPage");
			eventCur.setStartRow(eventPage.getStartRow());
			eventCur.setEndRow(eventPage.getEndRow());
			eventCur.setUserId(cookieUserId);
			
			model.addAttribute("eventPage", eventPage);
			
			if(user != null){
				listEvent = mpService.mpAucEventList(eventCur);
				
				model.addAttribute("listEvent", listEvent);
			}
		}
	
		return "/myPage/myPageAucCur";
	}
	
	// 작가 마이페이지 경매 내역
	@RequestMapping(value="/myPage/artAucResult")
	public String aucResult(ModelMap model, HttpServletRequest request, HttpServletResponse response){
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);		
		long curPage = HttpUtil.get(request, "curPage", (long)1);		
		List<MyPage> list = null;		
		MyPage myPage = new MyPage();		
		User user = null;		
		Paging paging = null;		
		long totalCount = 0;
		
		totalCount = mpService.mpAucResultListCount(cookieUserId);		
		user = userService.userSelect(cookieUserId);
		
		model.addAttribute("user",user);
		
		if(totalCount > 0){
			paging = new Paging("/myPage/aucResult", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");
			
			myPage.setStartRow(paging.getStartRow());
			myPage.setEndRow(paging.getEndRow());
			myPage.setUserId(cookieUserId);
			
			model.addAttribute("paging",paging);
		
			if(user != null){
				list = mpService.mpAucResultList(myPage);

				model.addAttribute("list", list);	
			}
		}
		
		return "/myPage/artAucResult";
	}

}
