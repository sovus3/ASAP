package com.icia.web.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
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
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.icia.common.model.FileData;
import com.icia.common.util.StringUtil;
import com.icia.web.model.Admin;
import com.icia.web.model.AucCur;
import com.icia.web.model.AucEvent;
import com.icia.web.model.AucEventCur;
import com.icia.web.model.Auction;
import com.icia.web.model.NoticeBoard;
import com.icia.web.model.OrderDetail;
import com.icia.web.model.Paging;
import com.icia.web.model.Pay;
import com.icia.web.model.Product;
import com.icia.web.model.QnaBoard;
import com.icia.web.model.Response;
import com.icia.web.model.User;
import com.icia.web.model.VoteList;
import com.icia.web.model.VoteUpload;
import com.icia.web.service.AdminService;
import com.icia.web.service.BoardService;
import com.icia.web.service.ProductService;
import com.icia.web.service.UserService;
import com.icia.web.util.CookieUtil;
import com.icia.web.util.HttpUtil;
import com.icia.web.util.JsonUtil;

@Controller("adminController")
public class AdminController {
private static Logger logger = LoggerFactory.getLogger(UserController.class);
	
	// 쿠키명
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	   
	@Value("#{env['upload.banner.dir']}")
	private String UPLOAD_BANNER_DIR;
	   
	@Value("#{env['upload.main.dir']}")
	private String UPLOAD_MAIN_DIR;
	   
	@Value("#{env['upload.detail.dir']}")
	private String UPLOAD_DETAIL_DIR;
	
	@Value("#{env['upload.product.dir']}")
	private String UPLOAD_PRODUCT_DIR;
		
	@Autowired
	private AdminService adminService;
		
	@Autowired
	private BoardService boardService;
	
	@Autowired
	ProductService productService;
	
	@Autowired
	UserService userService;
		
	private static final int LIST_COUNT = 10;	//한페이지의 게시물 수 
	private static final int PAGE_COUNT = 5; 	//페이징 수 
	
	//관리자 로그인
	@RequestMapping(value="/admin/adminProc", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> adminProc(HttpServletRequest request, HttpServletResponse response){
		String admId = HttpUtil.get(request, "admId");
		String admPwd = HttpUtil.get(request, "admPwd");
		Response<Object> ajaxResponse = new Response<Object>();
		
		if(!StringUtil.isEmpty(admId) && !StringUtil.isEmpty(admPwd)){
			Admin admin = adminService.adminSelect(admId);
			
			if(admin != null) {
				if(StringUtil.equals(admin.getAdmPwd(), admPwd)) {
					CookieUtil.addCookie(response, "/", -1, AUTH_COOKIE_NAME, CookieUtil.stringToHex(admId));
					ajaxResponse.setResponse(0, "Success"); // 로그인 성공
				}
				else {
					ajaxResponse.setResponse(-1, "Passwords do not match"); // 비밀번호 불일치
				}
			}
			else {
				ajaxResponse.setResponse(404, "Not Found"); //사용자 정보 없음 (Not Found)
			}
		}
		else{
			ajaxResponse.setResponse(400, "Bad Request"); // 파라미터가 올바르지 않음 (Bad Request)
		}
		
		if(logger.isDebugEnabled()){
			logger.debug("[adminController] /user/login response\n" + JsonUtil.toJsonPretty(ajaxResponse));
		}
		
		return ajaxResponse;
	}
	
	
	@RequestMapping(value="/admin/adminAuction")
	public String adminAuction(ModelMap model, HttpServletRequest request, HttpServletResponse response){
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String searchDate = HttpUtil.get(request, "searchDate", "");
		String yearValue = HttpUtil.get(request, "yearValue", "");
		String monthValue = HttpUtil.get(request, "monthValue", "");
		long curPage = HttpUtil.get(request, "curPage", (long)1);
	
		Admin admin = null;	
		long totalCount = 0;
		Paging paging = null;
		VoteUpload voteUpload = new VoteUpload();
		List<VoteUpload> list = null;	

		
		if(!StringUtil.isEmpty(cookieUserId)) {
			admin = adminService.adminSelect(cookieUserId);
			
			if(admin != null) {		
				voteUpload.setVrStartDate(searchDate);

				totalCount = adminService.voteUploadToAucTotalCnt(voteUpload);

				if(totalCount > 0) {
					paging = new Paging("/admin/adminAuction", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");
					
					voteUpload.setStartRow(paging.getStartRow());
					voteUpload.setEndRow(paging.getEndRow());
					
					list = adminService.voteUploadToAucSelect(voteUpload);
				}
				else {
					logger.info("=========================");
					logger.info("totalCount is 0");
					logger.info("=========================");
				}
			}
			else {
				logger.info("=========================");
				logger.info("Not admin");
				logger.info("=========================");
			}
		}
		
		model.addAttribute("paging", paging);
		model.addAttribute("list", list);
		model.addAttribute("monthValue", monthValue);
		model.addAttribute("yearValue", yearValue);
		model.addAttribute("curPage", curPage);
		
		return "/admin/adminAuction";
	}
	
	@RequestMapping(value="/admin/aucInsertProc", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> aucInsertProc(ModelMap model, HttpServletRequest request, HttpServletResponse response){

		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long vrSeq = HttpUtil.get(request, "vrSeq", (long)0);
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		
		Response<Object> res = new Response<Object>();
		Auction auction = new Auction();
		VoteUpload voteUpload = null;
		Admin admin = null;
		
		if(!StringUtil.isEmpty(cookieUserId)) {
			admin = adminService.adminSelect(cookieUserId);
			
			if(admin != null && vrSeq > 0) {
				voteUpload = adminService.voteUploadToAucInsert(vrSeq);
				
				if(voteUpload != null) {
					
			        String startDate = voteUpload.getVrStartDate();
			        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
			        Date formatDate = null;
			        
					try {
						formatDate = formatter.parse(startDate);
					} 
					catch (ParseException e) {
						e.printStackTrace();
					}
					
					Calendar cal = Calendar.getInstance();
					cal.setTime(formatDate);					
					cal.add(Calendar.MONTH, 1);
					startDate = formatter.format(cal.getTime());
					
					String year = startDate.substring(0, 4);
					String month = startDate.substring(4, 6);
					String day = "15";
					startDate = year + month + day;

					auction.setUserId(voteUpload.getUserId());
					auction.setCategoryNo(voteUpload.getCategoryNo());
					auction.setVrSeq(vrSeq);
					auction.setAucStartTime(startDate);
					auction.setAucEndTime(startDate);
					
					if(adminService.auctionInsertToR(auction) > 0) {
						res.setResponse(1, "경매 업로드 완료.");
					}
					else {
						res.setResponse(0, "경매 업로드 실패");
					}
				}
				else {
					res.setResponse(401, "작품이 존재하지 않음");
				}
			}
			else {
				res.setResponse(400, "관리자가 아님.");
			}
		}
		else {
			res.setResponse(404, "파라미터 값 부족");
		}

		model.addAttribute("curPage", curPage);
		
		return res;
	}
	
	@RequestMapping(value="/admin/adminAucCurList")
	public String adminAucCurList(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String searchType = HttpUtil.get(request, "searchType", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");
		String searchDate = HttpUtil.get(request, "searchDate", "");
		String yearValue = HttpUtil.get(request, "yearValue", "");
		String monthValue = HttpUtil.get(request, "monthValue", "");
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		
		Admin admin = null;
		Paging paging = null;
		List<AucCur> list = null;
		AucCur aucCur = new AucCur();
		long totalCount = 0;
		
		if(!StringUtil.isEmpty(cookieUserId)) {
			admin = adminService.adminSelect(cookieUserId);
			
			if(admin != null) {
				aucCur.setSearchType(searchType);
				aucCur.setSearchValue(searchValue);
				aucCur.setAucStartTime(searchDate);
				
				logger.info("============================================");
				logger.info("aucStartTime: " + aucCur.getAucStartTime());
				logger.info("============================================");
				
				totalCount = adminService.aucCurTotalCount(aucCur);
				
				if(totalCount > 0) {
					paging = new Paging("/admin/adminAucCurList", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");
					
					aucCur.setStartRow(paging.getStartRow());
					aucCur.setEndRow(paging.getEndRow());
					
					list = adminService.aucCurListSelect(aucCur);
					
					logger.info("==================================");
					logger.info("paging.startPage: " + paging.getStartPage());
					logger.info("paging.getEndPage: " + paging.getEndPage());
					logger.info("==================================");
				}
			}
		}
		
		model.addAttribute("paging", paging);
		model.addAttribute("list", list);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("monthValue", monthValue);
		model.addAttribute("yearValue", yearValue);
		model.addAttribute("curPage", curPage);
		
		return "/admin/adminAucCurList";
	}
	
	@RequestMapping(value="/admin/adminAucBuyPriceList")
	public String adminAucBuyPriceList(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String searchType = HttpUtil.get(request, "searchType", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");
		String searchDate = HttpUtil.get(request, "searchDate", "");
		String yearValue = HttpUtil.get(request, "yearValue", "");
		String monthValue = HttpUtil.get(request, "monthValue", "");
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		
		Admin admin = null;
		Paging paging = null;
		List<Auction> list = null;
		Auction auction = new Auction();
		long totalCount = 0;
		
		if(!StringUtil.isEmpty(cookieUserId)) {
			admin = adminService.adminSelect(cookieUserId);
			
			if(admin != null) {
				auction.setAucStartTime(searchDate);
				auction.setSearchType(searchType);
				auction.setSearchValue(searchValue);
				
				totalCount = adminService.auctionTotalCount(auction);
				
				logger.info("##################################");
				logger.info("totalCount: " + totalCount);
				logger.info("##################################");
				
				if(totalCount > 0) {
					paging = new Paging("/admin/adminAucBuyPriceList", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");
					
					auction.setStartRow(paging.getStartRow());
					auction.setEndRow(paging.getEndRow());
					
					list = adminService.auctionListSelect(auction);
					
				}
			}
		}
		
		model.addAttribute("paging", paging);
		model.addAttribute("list", list);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("monthValue", monthValue);
		model.addAttribute("yearValue", yearValue);
		model.addAttribute("curPage", curPage);
		
		return "/admin/adminAucBuyPriceList";
	}

	//관리자 공지사항 게시판 리스트
	@RequestMapping(value="/admin/adminNoticeBoard")
   public String adminNoticeBoard(ModelMap model, HttpServletRequest request, HttpServletResponse response) 
   {
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
      //조회항목(1:제목, 2:내용)
      String searchType = HttpUtil.get(request, "searchType","");
      //조회값 
      String searchValue = HttpUtil.get(request, "searchValue","");
      //현재페이지
      long curPage = HttpUtil.get(request, "curPage", (long)1);
      //게시물 리스트 
      List<NoticeBoard> list = null;
      //조회 객체
      NoticeBoard search = new NoticeBoard();
      Admin admin = adminService.adminSelect(cookieUserId);
      //총 게시물 수
      long totalCount = 0;
      //페이징 객체
      Paging paging = null;
      
      String boardMe = "N";      
   
      if(admin != null)
      {
         boardMe ="Y";
      }
      
      if(!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue))
      {
         search.setSearchType(searchType);
         search.setSearchValue(searchValue);
      }
      
      totalCount = boardService.NoticeBoardListCount(search);
      
      if(totalCount > 0)
      {
         paging = new Paging("/admin/adminNoticeBoard", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");
         
         search.setStartRow(paging.getStartRow());
         search.setEndRow(paging.getEndRow());
         
         list = boardService.NoticeBoardList(search);
                  
      }
      model.addAttribute("boardMe",boardMe);
      model.addAttribute("list",list);
      model.addAttribute("searchType",searchType);
      model.addAttribute("searchValue",searchValue);
      model.addAttribute("curPage",curPage);
      model.addAttribute("paging", paging);
      
      return "/admin/adminNoticeBoard";
   }

	
	//관리자 공지사항 상세
   @RequestMapping(value="/admin/adminNoticeView")
   public String adminNoticeView(ModelMap model,HttpServletRequest request, HttpServletResponse response)
   {
      //쿠키값
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
      //게시물 번호
      long nbSeq = HttpUtil.get(request, "nbSeq", (long)0);      
      //조회항목(1.제목, 2.내용)
      String searchType = HttpUtil.get(request,"searchType","");
      //조회 값
      String searchValue = HttpUtil.get(request,"searchValue", "");
      //현재 페이지
      long curPage = HttpUtil.get(request,"curPage",(long)1);
      //본인 글 여부
      String boardMe ="N";
      
      NoticeBoard noticeBoard = null;         
      
      if(nbSeq >0)       
      {
         noticeBoard = boardService.NoticeBoardView(nbSeq);
         
         if(noticeBoard != null && StringUtil.equals(noticeBoard.getAdmId(), cookieUserId))
         {
            boardMe="Y";
         }
      }
      
      model.addAttribute("boardMe",boardMe);
      model.addAttribute("nbSeq", nbSeq);
      model.addAttribute("noticeBoard", noticeBoard);
      model.addAttribute("searchType", searchType);
      model.addAttribute("searchValue", searchValue);
      model.addAttribute("curPage", curPage);
      
      return "/admin/adminNoticeView";
   }
	   
   //관리자 공지사항 수정
   @RequestMapping(value="/admin/adminNoticeUpdate")
   public String adminNoticeUpdate(ModelMap model,HttpServletRequest request, HttpServletResponse response)
   {
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
      long nbSeq = HttpUtil.get(request, "nbSeq", (long)0);
      String searchType = HttpUtil.get(request, "searchType","");
      String searchValue = HttpUtil.get(request, "searchValue","");
      long curPage = HttpUtil.get(request, "curPage", (long)1);

      NoticeBoard noticeBoard = null;
      Admin admin = null;
      
      
      if(nbSeq > 0)
      {
         noticeBoard = boardService.NoticeBoardViewUpdate(nbSeq);
         if(noticeBoard != null)
         {
            if(StringUtil.equals(noticeBoard.getAdmId(), cookieUserId))
            {
               admin=adminService.adminSelect(cookieUserId);
            }
            else
            {
               noticeBoard = null;
            }
         }
         model.addAttribute("searchType", searchType);      
         model.addAttribute("searchValue", searchValue);
         model.addAttribute("curPage", curPage);
         model.addAttribute("noticeBoard", noticeBoard);
         model.addAttribute("admin", admin);
         
      }
      return "/admin/adminNoticeUpdate";
   }
	
	//관리자 공지사항 수정proc
   //관리자 공지사항 수정proc
   @RequestMapping(value="/admin/adminNoticeUpdateProc", method=RequestMethod.POST)
   @ResponseBody
   public Response<Object> adminNoticeUpdateProc(HttpServletRequest request, HttpServletResponse response)
   {
      Response<Object> ajaxResponse = new Response<Object>();
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
      long nbSeq = HttpUtil.get(request, "nbSeq", (long)0);
      String nbTitle = HttpUtil.get(request, "nbTitle", "");
      String nbContent = HttpUtil.get(request,"nbContent","");
      NoticeBoard noticeBoard = null;
      
      if(nbSeq>0 && !StringUtil.isEmpty(nbTitle) && !StringUtil.isEmpty(nbContent))
      {
         noticeBoard = boardService.NoticeBoardView(nbSeq);
         if(noticeBoard != null)
         {
            if(StringUtil.equals(noticeBoard.getAdmId(), cookieUserId))
            {
               noticeBoard.setNbTitle(nbTitle);
               noticeBoard.setNbContent(nbContent);
               
               try
               {      
                  if(boardService.NoticeBoardUpdate(noticeBoard) >= 0)
                  {
                     ajaxResponse.setResponse(0, "Success");
                  }
                  else
                  {
                     ajaxResponse.setResponse(500,"internal server error2222222");
                  }
               }
               catch(Exception e)
               {
                  logger.error("[adminController] adminNoticeUpdateProc Exception",e);
                  
                  ajaxResponse.setResponse(500,"internal server error");
               }
            }
            else
            {
               ajaxResponse.setResponse(403, "Server error");
            }
         }
         else
         {
            ajaxResponse.setResponse(404, "Not Found");
         }
      }
      else
      {
         ajaxResponse.setResponse(400,"Bad request");
      }
      
      return ajaxResponse;      
   }

	
   //관리자 공지사항 삭제
   @RequestMapping(value="/admin/adminNoticeDelete", method=RequestMethod.POST)
   @ResponseBody
   public Response<Object> adminNoticeDelete(HttpServletRequest request, HttpServletResponse response)
   {
      Response<Object> ajaxResponse = new Response<Object>();
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
      long nbSeq = HttpUtil.get(request, "nbSeq", (long)0);
      
      if(nbSeq > 0)
      {
         NoticeBoard noticeBoard = boardService.NoticeBoardView(nbSeq);
         
         if(noticeBoard != null)
         {
            if(StringUtil.equals(cookieUserId, noticeBoard.getAdmId()))
            {
               try
               {
                  if(boardService.NoticeBoardDelete(nbSeq)>0)
                  {
                     ajaxResponse.setResponse(0,"success");
                  }
                  else
                  {
                     ajaxResponse.setResponse(500, "server error22222");
                  }
                  
               }
               catch(Exception e)
               {
                  logger.error("[BoardControll] NoticeBoardDelete Exception",e);
                  ajaxResponse.setResponse(500, "server error");
               }
            }
            else
            {
               ajaxResponse.setResponse(403, "server error");
            }
         }
         else
         {
            ajaxResponse.setResponse(404, "Not found");
         }
      }
      else 
      {
         ajaxResponse.setResponse(400,"Bad Request");
      }
            
      return ajaxResponse;
   }

	
	//관리자 공지사항 글쓰기
	@RequestMapping(value="/admin/adminNoticeWrite") 
	public String adminNoticeWrite(ModelMap model,HttpServletRequest request, HttpServletResponse response)
	{    
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long nbSeq = HttpUtil.get(request, "nbSeq", 0);
		String searchType = HttpUtil.get(request, "searchType","");
		String searchValue = HttpUtil.get(request,"searchValue","");
		long curPage = HttpUtil.get(request,"curPage",(long)1);
  
		Admin admin=adminService.adminSelect(cookieUserId);   
  
		model.addAttribute("searchType",searchType);
		model.addAttribute("searchValue",searchValue);
		model.addAttribute("curPage", curPage);
		model.addAttribute("nbSeq", nbSeq);
   
		model.addAttribute("admin",admin); 
		return "/admin/adminNoticeWrite";
	}

	
	//관리자 공지사항 글쓰기 proc
   @RequestMapping(value="/admin/adminNoticeWriteProc",method=RequestMethod.POST)
   @ResponseBody
   public Response<Object> adminNoticeWriteProc(HttpServletRequest request, HttpServletResponse response)
   {
      Response<Object> ajaxResponse = new Response<Object>();
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
      String admId = HttpUtil.get(request, "admId", "");
      String nbTitle = HttpUtil.get(request, "nbTitle", "");
      String nbContent = HttpUtil.get(request, "nbContent","");
      if(!StringUtil.isEmpty(nbTitle) && !StringUtil.isEmpty(nbContent))
      {
         NoticeBoard noticeBoard = new NoticeBoard();
         
         noticeBoard.setAdmId(admId);
         noticeBoard.setNbTitle(nbTitle);
         noticeBoard.setNbContent(nbContent);
         
         //서비스 호출
         try 
         {
            if(boardService.NoticeBoardInsert(noticeBoard) >=0)
            {
               ajaxResponse.setResponse(0,"success");
            }
            else
            {
               ajaxResponse.setResponse(500, "Internal server error");
            }
         }
         catch(Exception e)
         {
            logger.error("[NoticeBoardController]writeProc Exception",e);
            ajaxResponse.setResponse(500, "Internal server error");
         }
      }
      else
      {
         ajaxResponse.setResponse(400,"Bad Request");
      }
      
      return ajaxResponse;
   }

	
 //관리자 문의사항 게시판(답변 없는 게시물만 보이게)
   @RequestMapping(value="/admin/adminQnaBoard")
   public String adminQnaBoard(ModelMap model, HttpServletRequest request, HttpServletResponse response)
   {
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
      //조회항목(1:제목, 2:내용)
      String searchType = HttpUtil.get(request, "searchType","");
      //조회값 
      String searchValue = HttpUtil.get(request, "searchValue","");
      
      //현재페이지(답변x)
      long curPage = HttpUtil.get(request, "curPage", (long)1);
      //현재페이지(답변o)
      long curPage2 = HttpUtil.get(request, "curPage2", (long)1);
      
      logger.debug("=================================================");
      logger.debug("curPage : " + curPage);
      logger.debug("curPage2 : " + curPage2);
      logger.debug("=================================================");
      
      //게시물 리스트 (답변x)
      List<QnaBoard> list = null;
      //게시물 리스트 (답변o)
      List<QnaBoard> list2 = null;
      
      //조회 객체
      QnaBoard search = new QnaBoard();
      Admin admin = adminService.adminSelect(cookieUserId);
      
      //총 게시물 수(답변x)
      long totalCount = 0;
      //총 게시물 수(답변o)
      long totalCount2 = 0;
      
      //페이징 객체(답변x)
      Paging paging = null;
      //페이징 객체(답변o)
      Paging paging2 = null;
      
      String boardMe = "N";
      
      if(admin != null)
      {
         boardMe ="Y";
      }
      
      if(!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue))
      {
         search.setSearchType(searchType);
         search.setSearchValue(searchValue);
      }
      
      totalCount = adminService.AdminQnaNoCnt(search);
      totalCount2 = adminService.AdminQnaYesCnt(search);
      
      //답변x
      if(totalCount > 0)
      {
         paging = new Paging("/admin/adminQnaBoard", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");
         
         search.setStartRow(paging.getStartRow());
         search.setEndRow(paging.getEndRow());
         
         list = adminService.AdminQnaNo(search);
      }
      
      //답변o
      if(totalCount2 > 0)
      {
         paging2 = new Paging("/admin/adminQnaBoard", totalCount2, LIST_COUNT, PAGE_COUNT, curPage2, "curPage2");
         
         search.setStartRow(paging2.getStartRow());
         search.setEndRow(paging2.getEndRow());
         
         list2 = adminService.AdminQnaYes(search);
      }
      
      model.addAttribute("boardMe",boardMe);
      model.addAttribute("list",list);
      model.addAttribute("list2",list2);
      model.addAttribute("searchType",searchType);
      model.addAttribute("searchValue",searchValue);
      model.addAttribute("curPage",curPage);
      model.addAttribute("curPage2",curPage2);
      model.addAttribute("paging", paging);
      model.addAttribute("paging2", paging2);
      
      return "/admin/adminQnaBoard";
   }
   
   //관리자 문의사항 상세보기
   @RequestMapping(value="/admin/adminQnaView")
   public String adminQnaView(ModelMap model,HttpServletRequest request, HttpServletResponse response)
   {
      //쿠키값
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
      Admin admin = adminService.adminSelect(cookieUserId);
      
      //게시물 번호
      long qaSeq = HttpUtil.get(request, "qaSeq", (long)0);      
      //조회항목(1.제목, 2.내용)
      String searchType = HttpUtil.get(request,"searchType","");
      //조회 값
      String searchValue = HttpUtil.get(request,"searchValue", "");
      //현재 페이지(답변x)
      long curPage = HttpUtil.get(request,"curPage",(long)1);
      //현재 페이지(답변o)
      long curPage2 = HttpUtil.get(request,"curPage2",(long)1);
      //본인 글 여부
      String boardMe ="N";
      
      QnaBoard qnaBoard = null;
      
      if(qaSeq >0)       
      {
         qnaBoard = boardService.QnaBoardView(qaSeq);
         
         if(qnaBoard != null && admin != null) 
         {
            boardMe="Y";
         }
      }
      
      model.addAttribute("boardMe",boardMe);
      model.addAttribute("qaSeq", qaSeq);
      model.addAttribute("qnaBoard", qnaBoard);
      model.addAttribute("searchType", searchType);
      model.addAttribute("searchValue", searchValue);
      model.addAttribute("curPage", curPage);
      model.addAttribute("curPage2", curPage2);
      
      return "/admin/adminQnaView";
   }
   
   //관리자 문의사항, 답변 삭제
   @RequestMapping(value="/admin/adminQnaDelete")
   @ResponseBody
   public Response<Object> adminQnaDelete(HttpServletRequest request, HttpServletResponse response)
   {
      Response<Object> ajaxResponse = new Response<Object>();
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
      long qaSeq = HttpUtil.get(request, "qaSeq", (long)0);
      
      if(qaSeq > 0)
      {
         QnaBoard qnaBoard = boardService.QnaBoardSelect(qaSeq);
         
         if(qnaBoard != null)
         {
            try
            {
               if(boardService.QnaBoardDelete2(qaSeq)>0)
               {
                  ajaxResponse.setResponse(0,"success");
               }
               else
               {
                  ajaxResponse.setResponse(500, "server error22222");
               }
               
            }
            catch(Exception e)
            {
               logger.error("[BoardControll] boardDelete2 Exception",e);
               ajaxResponse.setResponse(500, "server error");
            }
         }
         else
         {
            ajaxResponse.setResponse(404, "Not found");
         }
      }
      else 
      {
         ajaxResponse.setResponse(400,"Bad Request");
      }
            
      return ajaxResponse;
   }
   
   //게시물 답변 화면
   @RequestMapping(value="/admin/adminQnaReply")
   public String adminQnaReply(ModelMap model,HttpServletRequest request, HttpServletResponse response)
   {
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
      long qaSeq = HttpUtil.get(request, "qaSeq", 0);   //부모글을 알아야하니까
      String searchType = HttpUtil.get(request, "searchType","");
      String searchValue = HttpUtil.get(request,"searchValue","");
      long curPage = HttpUtil.get(request,"curPage",(long)1);
      Admin admin = adminService.adminSelect(cookieUserId);
      String boardMe = "N";
      
      if(admin != null)
      {
         boardMe ="Y";
      }
      QnaBoard qnaBoard = null;      
      
      if(qaSeq > 0)
      {
         qnaBoard = boardService.QnaBoardSelect(qaSeq);                  
      }
      model.addAttribute("boardMe",boardMe);
      model.addAttribute("searchType",searchType);
      model.addAttribute("searchValue",searchValue);
      model.addAttribute("curPage", curPage);
      model.addAttribute("qnaBoard",qnaBoard);

      return "/admin/adminQnaReply";
   }
   
   //게시물 답변 
   @RequestMapping(value="/admin/adminQnaReplyProc")
   @ResponseBody
   public Response<Object> adminQnaReplyProc(HttpServletRequest request, HttpServletResponse response)
   {
      Response<Object> ajaxResponse = new Response<Object>();
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
      long qaSeq = HttpUtil.get(request, "qaSeq",0);      
      String userNick = HttpUtil.get(request,"userNick","");
      String qaTitle = HttpUtil.get(request,"qaTitle","");
      String qaContent = HttpUtil.get(request,"qaContent","");
      
      if(qaSeq > 0 && !StringUtil.isEmpty(qaTitle) && !StringUtil.isEmpty(qaContent))
      {
         QnaBoard parentQnaBoard = boardService.QnaBoardSelect(qaSeq);   
         if(parentQnaBoard != null )
         {
            QnaBoard qnaBoard = new QnaBoard(); 
            
            qnaBoard.setAdmId(cookieUserId);
            qnaBoard.setUserNick(userNick);
            qnaBoard.setQaTitle(qaTitle);
            qnaBoard.setQaContent(qaContent);
            qnaBoard.setQaGroup(parentQnaBoard.getQaGroup());   
            qnaBoard.setQaOrder(parentQnaBoard.getQaOrder()+1);   
            qnaBoard.setQaIndent(parentQnaBoard.getQaIndent()+1);   
            qnaBoard.setQaParent(qaSeq);
            
            try
            {
               if(boardService.QnaBoardReplyInsert(qnaBoard)>=0)   //처리건수를 리턴하고 있어서 >=0 안쓰면 오류남 왜냐면 if는 true,false니까
               {
                  ajaxResponse.setResponse(0,"success");
               }
               else
               {
                  ajaxResponse.setResponse(500,"Internal server error22222222");
               }
               
            }
            catch(Exception e)
            {
               logger.error("[HiBoardController] replyProc Exception",e);
               ajaxResponse.setResponse(500,  "Internal server error");
            }
         }
         else
         {
            //부모글이 없을때
            ajaxResponse.setResponse(404, "not found");
         }
      }
      else
      {
         ajaxResponse.setResponse(400, "bad request");
      }
      
      
      return ajaxResponse;
   }
	
 //상품
 	@RequestMapping(value = "/admin/payList")
 	public String payList(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
 		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
 		
 		Admin admin = adminService.adminSelect(cookieUserId);
 		List<Pay> list = null;
 		Pay pay = new Pay();
 		Paging paging = null;
 		//조회항목
 		String searchType = HttpUtil.get(request, "searchType","");
 		String searchType1 = HttpUtil.get(request, "_searchType","");
 		//조회값 
 		String searchValue = HttpUtil.get(request, "searchValue","");
 		String searchValue1 = HttpUtil.get(request, "_searchValue","");
 		long totalCount = 0;
 		long curPage = HttpUtil.get(request, "curPage", (long)1);
 		
 		String enterSearchValue = "";
         try {
         	enterSearchValue = URLDecoder.decode(searchValue1, "UTF-8");
         } 
         catch (UnsupportedEncodingException e) {// 디코딩 실패 처리
             e.printStackTrace();
         }
         
 		if((!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue))
 				|| (!StringUtil.isEmpty(searchType1) && !StringUtil.isEmpty(searchValue1))){
 			
 			if(!StringUtil.isEmpty(enterSearchValue)){
 				searchValue = enterSearchValue;
 				searchType = searchType1;
 			}
 			pay.setSearchType(searchType);
 			pay.setSearchValue(searchValue);
 		}
 		logger.debug(searchType);
 		logger.debug(searchValue);
 		
 		totalCount = adminService.payListCount(pay);
 		
 		if(admin != null){
 			
 			paging = new Paging("/admin/payList", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");
 			
 			pay.setStartRow(paging.getStartRow());
 			pay.setEndRow(paging.getEndRow());
 			
 			list = adminService.payList(pay);					
 		}
 		model.addAttribute("curPage",curPage);
 		model.addAttribute("admin", admin);
 		model.addAttribute("list", list);
 		model.addAttribute("paging",paging);
 		model.addAttribute("searchType",searchType);
 		model.addAttribute("searchValue",searchValue);
 		
 		return "/admin/payList";
 	}
 	
 	@RequestMapping(value = "/admin/payDetail",produces = "text/html; charset=UTF-8")
 	public String payDetail(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
 		
 		List<OrderDetail> list = null;
 		OrderDetail orderDetail = new OrderDetail();
 		//현재 페이지
 		long curPage = HttpUtil.get(request, "curPage", (long)1);
 		long curPage2 = HttpUtil.get(request, "curPage2", (long)1);
 		long totalCount = 0;
 		//페이징 객체
 		Paging paging = null;
 		long orderNo = HttpUtil.get(request, "orderNo", (long)0);		
 		
 		totalCount = adminService.orderDCount(orderNo);
 		logger.debug("totalCount : " + totalCount);
 		
 		if(totalCount > 0) {
 			paging = new Paging("/admin/payDetail", totalCount, LIST_COUNT, PAGE_COUNT, curPage2, "curPage2");
 			
 			orderDetail.setOrderNo(orderNo);
 			orderDetail.setStartRow(paging.getStartRow());
 			orderDetail.setEndRow(paging.getEndRow());
 			
 			list = adminService.orderDSelect(orderDetail);
 		}
 		
 		model.addAttribute("orderNo", orderNo);
 		model.addAttribute("list", list);
 		model.addAttribute("orderDetail", orderDetail);
 		model.addAttribute("curPage", curPage);
 		model.addAttribute("curPage2", curPage2);
 		model.addAttribute("paging", paging);
 		
 		return "/admin/payDetail";
 	}
 	
 	@RequestMapping(value = "/admin/product")
 	public String productList(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
 		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
 		
 		Admin admin = adminService.adminSelect(cookieUserId);
 		List<Product> list = null;
 		Product product = new Product();
 		Paging paging = null;
 		//조회항목
 		String searchType = HttpUtil.get(request, "searchType","");
 		String searchType1 = HttpUtil.get(request, "_searchType","");
 		//조회값 
 		String searchValue = HttpUtil.get(request, "searchValue","");
 		String searchValue1 = HttpUtil.get(request, "_searchValue","");
 		
 		long totalCount = 0;
 		long curPage = HttpUtil.get(request, "curPage", (long)1);
 		
 		String enterSearchValue = "";
         try {
         	enterSearchValue = URLDecoder.decode(searchValue1, "UTF-8");
         } 
         catch (UnsupportedEncodingException e) {// 디코딩 실패 처리
             e.printStackTrace();
         }
         
 		if((!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue))
 				|| (!StringUtil.isEmpty(searchType1) && !StringUtil.isEmpty(searchValue1))){
 			
 			if(!StringUtil.isEmpty(enterSearchValue)){
 				searchValue = enterSearchValue;
 				searchType = searchType1;
 			}
 			product.setSearchType(searchType);
 			product.setSearchValue(searchValue);
 		}
 		
 		totalCount = adminService.productListCount(product);
 		
 		if(admin != null){
 			
 			paging = new Paging("/admin/product", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");
 			
 			product.setStartRow(paging.getStartRow());
 			product.setEndRow(paging.getEndRow());
 			
 			list = adminService.productList(product);					
 		}
 		
 		model.addAttribute("admin", admin);
 		model.addAttribute("list", list);
 		model.addAttribute("paging",paging);
 		model.addAttribute("curPage",curPage);
 		model.addAttribute("searchType",searchType);
 		model.addAttribute("searchValue",searchValue);
 		
 		return "/admin/product";
 	}
 	@RequestMapping(value="/admin/productUpload", method = RequestMethod.POST)
 	public String productUpload(HttpServletRequest request, HttpServletResponse response) {
 		
 		return "/admin/productUpload";
 	}
 	@RequestMapping(value = "/admin/productUploadProc")
 	@ResponseBody
 	public Response<Object> productUploadProc(MultipartHttpServletRequest request, HttpServletResponse response){
 		Response<Object> ajaxResponse = new Response<Object>();
 		
 		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
 		String productName = HttpUtil.get(request, "productName", "");
 		int productPrice = HttpUtil.get(request, "productPrice", 0);
 		int productQuantity = HttpUtil.get(request, "productQuantity", 0);
 		String status = HttpUtil.get(request, "status", "");
 		String productStartDate = HttpUtil.get(request, "productStartDate", "");
 		String productEndDate = HttpUtil.get(request, "productEndDate", "");
 		String productDetail = HttpUtil.get(request, "productDetail", "");
 		
 		String productSDate = productStartDate.replace("-", "");
 		String productEDate = productEndDate.replace("-", "");
 		
 		long productSeq = adminService.productSeqSelect();
 		
 		FileData fileData = HttpUtil.getFile(request, "productFile", UPLOAD_PRODUCT_DIR, productSeq); 
 		
 		//다이렉트 작가인지 확인
 		if(!StringUtil.isEmpty(cookieUserId) && !StringUtil.isEmpty(productName) && !StringUtil.isEmpty(productPrice) && !StringUtil.isEmpty(productQuantity) && !StringUtil.isEmpty(status)
 				&& !StringUtil.isEmpty(productStartDate) && !StringUtil.isEmpty(productEndDate) && !StringUtil.isEmpty(productDetail)) {
 			Product product = new Product();
 			
 			product.setProductSeq(productSeq);
 			product.setProductName(productName);
 			product.setProductPrice(productPrice);
 			product.setProductQuantity(productQuantity);
 			product.setStatus(status);
 			product.setProductStartDate(productSDate);
 			product.setProductEndDate(productEDate);
 			product.setProductDetail(productDetail);
 			
 			if(adminService.productInsert(product) > 0) {
 				ajaxResponse.setResponse(1, "작품 등록 성공");
 			}
 			else {
 				ajaxResponse.setResponse(0, "작품 등록 오류");
 			}
 			
 		}
 		else {
 			ajaxResponse.setResponse(400, "파라미터 부족");
 		}
 		
 		return ajaxResponse;
 	}
 	@RequestMapping(value="/admin/productUpdate")
 	public String productDetail(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
 		//상품 번호 가져옴
 		long productSeq = HttpUtil.get(request, "productSeq", (long)0); 
 		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
 		int curPage = HttpUtil.get(request, "curPage", 0);
 		Product product = null;
 		Admin admin = null;
 		
 		if(productSeq > 0) {
 			product = productService.productDetail(productSeq);
 			admin = adminService.adminSelect(cookieUserId);
 		}
 		
 		model.addAttribute("productSeq", productSeq);
 		model.addAttribute("product", product);
 		model.addAttribute("admin", admin);
 		model.addAttribute("curPage",curPage);
 		
 		return "/admin/productUpdate";
 	}
 	
 	@RequestMapping(value = "/admin/productUpdatedProc")
 	@ResponseBody
 	public Response<Object> productUpdatedProc(MultipartHttpServletRequest request, HttpServletResponse response){
 		Response<Object> ajaxResponse = new Response<Object>();
 		
 		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
 		int productSeq = HttpUtil.get(request, "productSeq", 0);
 		String productName = HttpUtil.get(request, "productName", "");
 		int productPrice = HttpUtil.get(request, "productPrice", 0);
 		int productQuantity = HttpUtil.get(request, "productQuantity", 0);
 		String status = HttpUtil.get(request, "status", "");
 		String productStartDate = HttpUtil.get(request, "productStartDate", "");
 		String productEndDate = HttpUtil.get(request, "productEndDate", "");
 		String productDetail = HttpUtil.get(request, "productDetail", "");
 		
 		String formattedDateStr = productStartDate.replace(" 00:00:00", "");
 		String formattedDateStr1 = productEndDate.replace(" 00:00:00", "");
 		String productSDate = formattedDateStr.replace("-", "");
 		String productEDate = formattedDateStr1.replace("-", "");
 		
 		if(!StringUtil.isEmpty(cookieUserId)){
 			Admin admin = adminService.adminSelect(cookieUserId);
 			
 			if(admin != null){
 				logger.debug("2222222222222222222222222222");
 				
 				if(!StringUtil.isEmpty(cookieUserId) && !StringUtil.isEmpty(productName) && !StringUtil.isEmpty(productPrice) && !StringUtil.isEmpty(productQuantity) && !StringUtil.isEmpty(status)
 						&& !StringUtil.isEmpty(productStartDate) && !StringUtil.isEmpty(productEndDate) && !StringUtil.isEmpty(productDetail)) {
 					logger.debug("!!!11111111111111111111111");
 					Product product = new Product();
 					
 					product.setProductSeq(productSeq);
 					product.setProductName(productName);
 					product.setProductPrice(productPrice);
 					product.setProductQuantity(productQuantity);
 					product.setStatus(status);
 					product.setProductStartDate(productSDate);
 					product.setProductEndDate(productEDate);
 					product.setProductDetail(productDetail);
 					
 					if(adminService.productUpdate(product) > 0) {
 						ajaxResponse.setResponse(1, "작품 수정 성공");
 					}
 					else {
 						ajaxResponse.setResponse(0, "작품 수정 오류");
 					}
 					
 				}
 				else {
 					ajaxResponse.setResponse(200, "파라미터 부족");
 				}
 			}
 			else{
 				CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
 				ajaxResponse.setResponse(404, "관리자가 아님");
 			}
 		}
 		else
 		{
 			ajaxResponse.setResponse(400, "회원 및 관리자가 아님");
 		}
 		
 		return ajaxResponse;
 	}
 	
 	@RequestMapping(value="/admin/productDelete", method=RequestMethod.POST)
 	@ResponseBody
 	public Response<Object> productDelete(HttpServletRequest request, HttpServletResponse response){
 		Response<Object> ajaxResponse = new Response<Object>();
 		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
 		long productSeq = HttpUtil.get(request, "productSeq", (long)0);
 		
 		Admin admin = adminService.adminSelect(cookieUserId);
 		if(admin != null && productSeq > 0){			
 			if(adminService.productDelete(productSeq)>0){
 				ajaxResponse.setResponse(0,"success");
 			}
 			else{
 				ajaxResponse.setResponse(500, "failed delete");
 			}	
 		}
 		else{
 			ajaxResponse.setResponse(403, "server error");
 		}
 		
 		return ajaxResponse;
 	}
	
	@RequestMapping(value="/admin/userList")
	public String userList(ModelMap model, HttpServletRequest request, HttpServletResponse Response) {
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String status = HttpUtil.get(request, "status", "");
		String userCode = HttpUtil.get(request, "userCode", "");
		String userIdSeacrch = HttpUtil.get(request, "userIdSeacrch");
		long curPage = HttpUtil.get(request, "curPage", (long)1);	

		User user = new User();
		List<User> list = null;
		Paging paging = null;	
		long totalCount = 0;

		user.setStatus(status);
		user.setUserCode(userCode);
		user.setUserId(userIdSeacrch);
		
		totalCount = adminService.userListTotalCount(user);
		
		logger.info("#############################");
		logger.info("totalCount: " + totalCount);
		logger.info("#############################");
		
		if(totalCount > 0) {
			paging = new Paging("/admin/userList", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");
			
			user.setStartRow(paging.getStartRow());
			user.setEndRow(paging.getEndRow());
			
			list = adminService.userListSelect(user);
		}
		
		model.addAttribute("list", list);
		model.addAttribute("paging", paging);
		model.addAttribute("curPage", curPage);
		model.addAttribute("userCode", userCode);
		model.addAttribute("status", status);
		model.addAttribute("userIdSeacrch", userIdSeacrch);

		
		return "/admin/userList";
	}
	
	@RequestMapping(value="/admin/userUpdate")
	public String userUpdate(ModelMap model, HttpServletRequest request, HttpServletResponse Response) {
		
		String status = HttpUtil.get(request, "status", "");
		String userCode = HttpUtil.get(request, "userCode", "");
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		String userIdSeacrch = HttpUtil.get(request, "userIdSeacrch");
		
		String userId = HttpUtil.get(request, "userId2");	
		User user = userService.userSelect(userId);
		
		model.addAttribute("user", user);
		model.addAttribute("status", status);
		model.addAttribute("userCode", userCode);
		model.addAttribute("curPage", curPage);
		model.addAttribute("userIdSeacrch", userIdSeacrch);
		
		return "/admin/userUpdate";
	}

	
	@RequestMapping(value="/admin/userUpdateProc")
	@ResponseBody
	public Response<Object> userUpdateProc(HttpServletRequest request, HttpServletResponse Response) {
		
		Response<Object> res = new Response<Object>();
		User user = new User();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		String userId = HttpUtil.get(request, "userId");
		String userPwd = HttpUtil.get(request, "userPwd");
		String userName = HttpUtil.get(request, "userName");
		String userPhone = HttpUtil.get(request, "userPhone");
		String userAddr = HttpUtil.get(request, "userAddr");
		String userEmail = HttpUtil.get(request, "userEmail");
		String userPostcode = HttpUtil.get(request, "userPostcode");
		String status = HttpUtil.get(request, "userStatus");
		
		if (!StringUtil.isEmpty(cookieUserId)) {
			Admin admin = adminService.adminSelect(cookieUserId);
	
			if (admin != null) {
				if (!StringUtil.isEmpty(userPwd) && !StringUtil.isEmpty(userName) && !StringUtil.isEmpty(userPhone)
						&& !StringUtil.isEmpty(userAddr) && !StringUtil.isEmpty(userEmail) && !StringUtil.isEmpty(userPostcode)) {
					
					user.setUserId(userId);
					user.setUserPwd(userPwd);
					user.setUserName(userName);
					user.setUserPhone(userPhone);
					user.setUserAddr(userAddr);
					user.setUserEmail(userEmail);
					user.setUserPostcode(userPostcode);
					user.setStatus(status);
	
					if (adminService.userUpdateAdmin(user) > 0) {
						res.setResponse(1, "success");
					} 
					else {
						res.setResponse(0, "failed");
					}
				} 
				else {
					res.setResponse(400, "Bad Request");
				}
			} 
			else {
				res.setResponse(404, "Not Found");
			}
		} 
		else {
			res.setResponse(400, "Bad Request");
		}
	
		if (logger.isDebugEnabled()) {
			logger.debug("[AdminController]/admin/userUpdateProc response\n" + JsonUtil.toJsonPretty(res));
		}
		
		
		return res;
	}

	
	@RequestMapping(value="/admin/userCodeUpdate", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> userCodeUpdate(HttpServletRequest request, HttpServletResponse Response){
		Response<Object> res = new Response<Object>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String userId = HttpUtil.get(request, "userId", "");
		
		logger.info("##########################");		
		logger.info("userId: " + userId);
		logger.info("##########################");
		
		int cnt = 0;
		Admin admin = adminService.adminSelect(cookieUserId);

		if(admin != null) {
			
			try {
				if(adminService.userCodeUpdate(userId) > 0){
					res.setResponse(1, "success");
				}
				else {
					res.setResponse(0, "failed");
				}
			}
			catch(Exception e) {
				logger.error("[AdminController] userCodeUpdate Exception", e);
				res.setResponse(0, "failed");
			}
		}
		else {
			res.setResponse(400, "Not Admin");
		}
		
		return res;
	}
	
	@RequestMapping(value="/admin/userChargeProc")
	@ResponseBody
	public Response<Object> userChargeProc(HttpServletRequest request, HttpServletResponse Response){
		
		Response<Object> res = new Response<Object>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String userId = HttpUtil.get(request, "userId", "");		
		long userChargePlus = HttpUtil.get(request, "userChargePlus", (long)0);
		
		User user = new User();
		Admin admin = adminService.adminSelect(cookieUserId);
				
		if(admin != null) {
			user.setUserId(userId);
			user.setUserCharge(userChargePlus);
			
			if(adminService.userChargePlus(user) > 0) {
				res.setResponse(1, "success");
			}
			else {
				res.setResponse(0, "failed");
			}
		}
		else {
			res.setResponse(400, "Not Admin");
		}
			
		return res;
	}
	
	
	// 투표할 작품 조회
	@RequestMapping(value="/admin/voteUpload")
	public String adminVote(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		String cookieAdminId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		
		String searchType = HttpUtil.get(request, "searchType", "");
		
		String searchValue = HttpUtil.get(request, "searchValue", "");
		
		
		Admin admin = null;
		
		List<VoteUpload> list = null;
		
		Paging paging = null;
		
		long totalCount = 0;
		
		VoteUpload voteUpload = new VoteUpload();
		
		
		if(!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue))
		{
			voteUpload.setSearchType(searchType);
			voteUpload.setSearchValue(searchValue);
		}		
		

		totalCount = adminService.admVoteUploadListCount(voteUpload);
		
		admin = adminService.adminSelect(cookieAdminId);
		
		if(admin != null)
		{
			if(totalCount > 0)
			{
				paging = new Paging("/admin/voteUpload", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");
				
				voteUpload.setStartRow(paging.getStartRow());
				voteUpload.setEndRow(paging.getEndRow());
			
				list = adminService.admVoteUploadList(voteUpload);

			}	
			
		}
		
		model.addAttribute("searchType",searchType);
		model.addAttribute("searchValue",searchValue);		
		model.addAttribute("list", list);
		model.addAttribute("paging",paging);
		model.addAttribute("curPage",curPage);

		return "/admin/voteUpload";
	}
	
	// P -> R 상태 변경
	@RequestMapping(value="/admin/statusProc",method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> statusProc(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> rs = new Response<Object>();
		
		String cookieAdminId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long vrSeq = HttpUtil.get(request, "vrSeq", (long)0);
		int cnt = 0;
		
		Admin admin = adminService.adminSelect(cookieAdminId);
		
		if(admin != null)
		{
			cnt = adminService.vuStatusUpdate(vrSeq);
			
			if(cnt > 0)
			{
				rs.setResponse(0, "success");
			}
			else
			{
				rs.setResponse(200,"fail");
			}
			
		}
		else
		{
			rs.setResponse(300, "not Admin");
		}
			
		return rs;
		
	}

	
	// 투표 한 사람 조회
	@RequestMapping(value="/admin/voteList")
	   public String voteList(ModelMap model, HttpServletRequest request, HttpServletResponse response){
	      String cookieAdmId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
	            
	      long listPage = HttpUtil.get(request, "listPage", (long)1);
	      long curPage = HttpUtil.get(request, "curPage", (long)1);
	      long vrSeq = HttpUtil.get(request, "vrSeq", (long)0); 
	      String searchType = HttpUtil.get(request, "searchType", "");
	      String searchValue = HttpUtil.get(request, "searchValue", "");
	      /* 추가 시작 231006 */
	      String vlSearchType = HttpUtil.get(request, "vlSearchType", "");   
	      String vlSearchValue = HttpUtil.get(request, "vlSearchValue", "");   
	      /*추가 끝 231006*/
	      Paging paging = null;
	      
	      long totalCount = 0;
	      
	      List<VoteList> list = null;
	         
	      VoteList voteList = new VoteList();
	      
	         if(!StringUtil.isEmpty(vlSearchType) && !StringUtil.isEmpty(vlSearchValue)){
	            voteList.setVlSearchType(vlSearchType);
	            voteList.setVlSearchValue(vlSearchValue);
	         }      
	      
	      voteList.setVrSeq(vrSeq);
	      
	      totalCount = adminService.admVoteListCount(voteList);
	      
	      Admin admin = adminService.adminSelect(cookieAdmId);
	      
	         if(admin != null){
	            if(totalCount > 0){
	               paging = new Paging("/admin/voteList", totalCount, LIST_COUNT, PAGE_COUNT, listPage, "listPage");
	            
	               voteList.setStartRow(paging.getStartRow());
	               voteList.setEndRow(paging.getEndRow());
	               
	               list = adminService.admVoteList(voteList);
	               
	            
	            }
	         }
	         
	         model.addAttribute("list", list);
	         model.addAttribute("vrSeq", vrSeq);
	         model.addAttribute("listPage",listPage);
	         model.addAttribute("curPage",curPage);
	         model.addAttribute("paging",paging);
	         model.addAttribute("searchType",searchType);
	         model.addAttribute("searchValue",searchValue);
	         /* 추가 시작 231006 */
	         model.addAttribute("vlSearchType",vlSearchType);
	         model.addAttribute("vlSearchValue",vlSearchValue);
	         /* 추가 끝 231006 */
	      
	      return "/admin/voteList";
	   }

	// 이벤트경매 입낙찰 내역 조회
	@RequestMapping(value="/admin/aeCur")
	public String adAucEvent(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		String cookieAdmId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		List<AucEventCur> list = null;
		
		Admin admin = null;
		
		String searchType = HttpUtil.get(request, "searchType", "");
		
		String searchValue = HttpUtil.get(request, "searchValue", "");

		Paging paging = null;
		
		long totalCount = 0;
		
		AucEventCur aucEventCur = new AucEventCur();

		admin = adminService.adminSelect(cookieAdmId);
		
		if(admin != null)
		{
			aucEventCur.setSearchType(searchType);
			aucEventCur.setSearchValue(searchValue);
			
		
			totalCount = adminService.admAucEventListCurCount(aucEventCur);
			
			
			if(totalCount > 0)
			{
				paging = new Paging("/admin/aeCur", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");
				
				aucEventCur.setStartRow(paging.getStartRow());
				aucEventCur.setEndRow(paging.getEndRow());
				
				list = adminService.admAucEventCurList(aucEventCur);
				
			}				
		}	
		
		model.addAttribute("searchType",searchType);
		model.addAttribute("searchValue",searchValue);
		model.addAttribute("paging", paging);
		model.addAttribute("list", list);
		model.addAttribute("curPage", curPage);
		
		
		
		return "/admin/aeCur";
		
	}	
	
	// 이벤트 경매 상태 조회
	@RequestMapping(value="/admin/aucEvent")
	public String adminAucEvent(ModelMap model,HttpServletRequest request, HttpServletResponse response)
	{
		String cookieAdmId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		Admin admin = null;
		
		String searchType = HttpUtil.get(request, "searchType", "");
	
		String searchValue = HttpUtil.get(request, "searchValue", "");
		
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		
		List<AucEvent> list = null;
		
		AucEvent aucEvent = new AucEvent();
		
		long totalCount = 0;
		
		Paging paging = null;
		
		admin = adminService.adminSelect(cookieAdmId);
		
		
		
		if(!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue))
		{
			aucEvent.setSearchType(searchType);
			aucEvent.setSearchValue(searchValue);
		}		
		
		totalCount = adminService.admAucEventListCount(aucEvent);
		
		if(admin != null)
		{
			if(totalCount > 0)
			{	
				paging = new Paging("/admin/aucEvent", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");
			
				aucEvent.setStartRow(paging.getStartRow());
				aucEvent.setEndRow(paging.getEndRow());
			
				list = adminService.admAucEventList(aucEvent);
		
				
			}			
		}
		

		model.addAttribute("searchType",searchType);
		model.addAttribute("searchValue",searchValue);
		model.addAttribute("paging", paging);
		model.addAttribute("list", list);
		model.addAttribute("curPage", curPage);
		return "/admin/aucEvent";	
	}
	
	
	
	// 낙찰 실패한 사람들 돈 돌려주기
	@RequestMapping(value="/admin/chargeProc")
	@ResponseBody
	public Response<Object> chargeProc(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> rs = new Response<Object>();
		
		String cookieAdmId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long aeSeq = HttpUtil.get(request, "aeSeq", (long)0);
		
		List<AucEventCur> list = null;
		
		AucEventCur aec = null;
		
		Admin admin = adminService.adminSelect(cookieAdmId);
		
		int cnt = 0;
		
		if(admin != null)
		{
			list = adminService.admAeReturnSelect(aeSeq);
		
			for(int i=0; i<list.size(); i++)
			{
				aec = list.get(i);
				
				cnt = adminService.admAeReturnUpdate(aec);
				
				if(cnt < 0)
				{
					rs.setResponse(300, "charge fail");
				}		
			}
			
			if(adminService.admAeStatusUpdate(aeSeq) > 0)
			{
				rs.setResponse(0, "success");
			}
			else
			{
				rs.setResponse(400, "status fail");
			}
		}
		else
		{
			rs.setResponse(200, "not admin");
		}
		return rs;
		
	}
	
	
		
	
	
	/*  이벤트 경매 업로드 */ 	
	@RequestMapping(value="/admin/aeRegForm")
	public String aeRegForm(HttpServletRequest request, HttpServletResponse response)
	{
		return "/admin/aeRegForm";
	}
	
	@RequestMapping(value="/admin/aeRegFormProc")
	@ResponseBody
	public Response<Object> aeRegFormProc(MultipartHttpServletRequest request, HttpServletResponse response)
	{	
		Response<Object> rs = new Response<Object>();
		
		String cookieAdmId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String aeTitle = HttpUtil.get(request, "aeTitle", "");
		String aeProductTitle = HttpUtil.get(request, "aeProductTitle", "");
		long aeStartPrice = HttpUtil.get(request, "aeStartPrice", (long)0);
		String aeStartTime = HttpUtil.get(request, "aeStartTime", "");
		String aeEndTime = HttpUtil.get(request, "aeEndTime", "");
	
		long aeSeq = adminService.aeSeqSelect();
		
		FileData bannerData = HttpUtil.getFile(request, "bannerFile", UPLOAD_BANNER_DIR, aeSeq);
		FileData mainData = HttpUtil.getFile(request, "mainFile", UPLOAD_MAIN_DIR, aeSeq);
		FileData detailData = HttpUtil.getFile(request, "detailFile", UPLOAD_DETAIL_DIR, aeSeq);
		
			if(!StringUtil.isEmpty(cookieAdmId) && !StringUtil.isEmpty(aeTitle)
				&& !StringUtil.isEmpty(aeProductTitle) &&!StringUtil.isEmpty(aeStartPrice)
				&&!StringUtil.isEmpty(aeStartTime) &&!StringUtil.isEmpty(aeEndTime))
			{
				AucEvent aec = new AucEvent();
				
				aec.setAeSeq(aeSeq);
				aec.setAdmId(cookieAdmId);
				aec.setAeTitle(aeTitle);
				aec.setAeProductTitle(aeProductTitle);
				aec.setAeStartPrice(aeStartPrice);
				aec.setAeStartTime(aeStartTime);
				aec.setAeEndTime(aeEndTime);
			
				if(adminService.admAeInsert(aec) > 0)
				{
					rs.setResponse(0, "success");
				}
				else
				{
					rs.setResponse(100, "fail");
				}
				
			}
			else
			{
				rs.setResponse(400, "parameter error");
			}
	
			
		return rs;
	}
	
	// 이벤트 경매 예정 -> 시작 변경
	
	@RequestMapping(value="/admin/yStatusProc")
	@ResponseBody
	public Response<Object> yStatusProc(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> rs = new Response<Object>();
		
		String cookAdmId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long aeSeq = HttpUtil.get(request, "aeSeq", (long)0);

		
		if(!StringUtil.isEmpty(cookAdmId) && !StringUtil.isEmpty(aeSeq))
		{
			if(adminService.admAeStatusUpdateY(aeSeq) > 0)
			{
				rs.setResponse(0, "success");
			}
			else
			{
				rs.setResponse(1, "error");
			}
		}
		else
		{
			rs.setResponse(400, "parameter error");
		}
		
		return rs;
		
		
	}	
	
	// 진행중인 경매 -> 종료로 변경
	@RequestMapping(value="/admin/nStatusProc")
	@ResponseBody
	public Response<Object> nStatusProc(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> rs = new Response<Object>();
		
		String cookAdmId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long aeSeq = HttpUtil.get(request, "aeSeq", (long)0);

		
		if(!StringUtil.isEmpty(cookAdmId) && !StringUtil.isEmpty(aeSeq))
		{
			if(adminService.admAeStatusUpdateN(aeSeq) > 0)
			{
				rs.setResponse(0, "success");
			}
			else
			{
				rs.setResponse(1, "error");
			}
		}
		else
		{
			rs.setResponse(400, "parameter error");
		}
		
		return rs;
		
		
	}
	
	// 경매 종료 후 가장 높은 금액 입찰자 'Y'로 변경 
	
	@RequestMapping(value="/admin/bidUpdateProc",method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> bidUpdateProc(HttpServletRequest request, HttpServletResponse response)
	{
		 Response<Object> rs = new Response<Object>();
		
			String cookAdmId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
			long aeSeq = HttpUtil.get(request, "aeSeq", (long)0);
		 
			if(!StringUtil.isEmpty(cookAdmId) && !StringUtil.isEmpty(aeSeq))
			{	
				if(adminService.admBidUpdateY(aeSeq) > 0)
				{
					rs.setResponse(0, "success");
				}
				else
				{
					rs.setResponse(1, "error");
				}
			}
			else
			{
				rs.setResponse(400, "parameter error");
			}

		return rs;
	}
	
	
		



}
