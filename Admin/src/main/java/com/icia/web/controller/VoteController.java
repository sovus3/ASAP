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
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.icia.common.model.FileData;
import com.icia.common.util.StringUtil;
import com.icia.web.model.DateManage;
import com.icia.web.model.Paging;
import com.icia.web.model.Response;
import com.icia.web.model.User;
import com.icia.web.model.VoteList;
import com.icia.web.model.VoteUpload;
import com.icia.web.service.UserService;
import com.icia.web.service.VoteService;
import com.icia.web.util.CookieUtil;
import com.icia.web.util.HttpUtil;
import com.icia.web.util.JsonUtil;

@Controller("voteController")
public class VoteController {
	private static Logger logger = LoggerFactory.getLogger(UserController.class);

	//쿠키명
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	@Value("#{env['upload.vote.dir']}")
	private String UPLOAD_VOTE_DIR;
	
	@Autowired
	private VoteService voteService;
	
	@Autowired
	private UserService userService;
	
	private static final int LIST_COUNT = 12; //한 페이지에 게시물 수
	private static final int PAGE_COUNT = 5; //페이징 수
	
	//투표 작품 업로드
	@RequestMapping(value="/vote/voteUpload", method=RequestMethod.GET)
	public String voteUpload(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		User user = userService.userSelect(cookieUserId);
		
		model.addAttribute("user", user);
		
		return "/vote/voteUpload";
	}
	
	@RequestMapping(value="/vote/voteUploadProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> voteUploadProc(MultipartHttpServletRequest request, HttpServletResponse response){
		Response<Object> res = new Response<Object>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String vrTitle = HttpUtil.get(request, "vrTitle", "");
		String vrContent = HttpUtil.get(request, "vrContent", "");
		long vrStartPrice = HttpUtil.get(request, "vrStartPrice", (long)0);
		int categoryNo = HttpUtil.get(request, "categoryNo", (int)01);
		String vrStartDate = HttpUtil.get(request, "vrStartDate");
		String vrEndDate = HttpUtil.get(request, "vrEndDate");
		
		long voteSeq = voteService.vrSeqSelect();
		
		FileData fileData = HttpUtil.getFile(request, "vrFile", UPLOAD_VOTE_DIR, voteSeq); 
		
		//다이렉트 작가인지 확인
		if(!StringUtil.isEmpty(cookieUserId) && !StringUtil.isEmpty(vrTitle) && !StringUtil.isEmpty(vrContent) && !StringUtil.isEmpty(categoryNo) && !StringUtil.isEmpty(vrStartPrice)
				&& !StringUtil.isEmpty(vrStartDate) && !StringUtil.isEmpty(vrEndDate)) {
			VoteUpload voteUpload = new VoteUpload();
			
			voteUpload.setVrSeq(voteSeq);
			voteUpload.setUserId(cookieUserId);
			voteUpload.setVrTitle(vrTitle);
			voteUpload.setVrContent(vrContent);
			voteUpload.setVrStartPrice(vrStartPrice);
			voteUpload.setCategoryNo(categoryNo);
			voteUpload.setVrStartDate(vrStartDate);
			voteUpload.setVrEndDate(vrEndDate);
			
			if(voteService.voteUploadInsert(voteUpload) > 0) 
			{
				res.setResponse(1, "작품 등록 성공");
			}
			else 
			{
				res.setResponse(0, "작품 등록 오류");
			}
		}
		else 
		{
			res.setResponse(400, "파라미터 부족");
		}
		
		return res;
	}
	
	//투표 리스트 조회
	@RequestMapping(value="/vote/voteList")
	public String voteList(ModelMap model,HttpServletRequest request, HttpServletResponse response) 
	{
		//현재 페이지
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		//게시물 리스트
		List<VoteUpload> list = null;
		VoteUpload voteUpload = new VoteUpload();
		//총 게시물 수
		long totalCount = 0;
		//페이징 객체
		Paging paging = null;
		voteUpload.setStatus("Y");
		int searchType = HttpUtil.get(request, "searchType",0);
		int gubun = HttpUtil.get(request, "searchType",0);
		
		if(!StringUtil.isEmpty(searchType) )
		{
			voteUpload.setCategoryNo(searchType);
		}

		totalCount = voteService.voteUploadListCount(voteUpload);
		logger.debug("========================================");
		logger.debug("totalCount : " + totalCount);
		logger.debug("========================================");
		
		//토탈 카운트 0보다 클 때 조회
		if(totalCount > 0) 
		{
			paging = new Paging("/board/list", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");
			
			voteUpload.setStartRow(paging.getStartRow());
			voteUpload.setEndRow(paging.getEndRow());
			
			list = voteService.voteUploadList(voteUpload);
		}
		list = voteService.voteUploadList(voteUpload);
		
		model.addAttribute("list", list);
		model.addAttribute("curPage", curPage);
		model.addAttribute("paging", paging);
		model.addAttribute("gubun", gubun);
				
		return "/vote/voteList";
	}
	
	@RequestMapping(value="/vote/voteList2")
	public String voteList2(ModelMap model,HttpServletRequest request, HttpServletResponse response) 
	{
		//현재 페이지
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		//게시물 리스트
		List<VoteUpload> list = null;
		VoteUpload voteUpload = new VoteUpload();
		//총 게시물 수
		long totalCount = 0;
		//페이징 객체
		Paging paging = null;
		voteUpload.setStatus("Y");
		int searchType = HttpUtil.get(request, "searchType",0);
		int gubun = HttpUtil.get(request, "searchType",0);
		
		if(!StringUtil.isEmpty(searchType) )
		{
			voteUpload.setCategoryNo(searchType);
		}

		totalCount = voteService.voteUploadListCount(voteUpload);
		logger.debug("========================================");
		logger.debug("totalCount : " + totalCount);
		logger.debug("========================================");
		
		//토탈 카운트 0보다 클 때 조회
		if(totalCount > 0) 
		{
			paging = new Paging("/board/list", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");
			
			voteUpload.setStartRow(paging.getStartRow());
			voteUpload.setEndRow(paging.getEndRow());
			
			list = voteService.voteUploadList(voteUpload);
		}
		list = voteService.voteUploadList(voteUpload);
		
		model.addAttribute("list", list);
		model.addAttribute("curPage", curPage);
		model.addAttribute("paging", paging);
		model.addAttribute("gubun", gubun);
				
		return "/vote/voteList";
	}
		
	// 업로드 버튼 클릭 체크 (2) 
	@RequestMapping(value="/vote/voteProc")
	@ResponseBody
	public Response<Object> voteProc(HttpServletRequest request, HttpServletResponse response) throws NumberFormatException
	{
		Response<Object> res = new Response<Object>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String curDate = HttpUtil.get(request, "curDate"); // 클릭했을 때 현재 날짜
		  
		User user = null;
		DateManage date = null;
		  
		user = userService.userSelect(cookieUserId);
		  
		if(user != null)
		{         
		logger.debug("///////////////////////////////////");
		logger.debug("user.getUserCode() : "+user.getUserCode());
		logger.debug("///////////////////////////////////");
		 
		boolean codeCheck = user.getUserCode().equals("A");
		 
		logger.debug("/////////////////////////");
		logger.debug("codeCheck :"+codeCheck);
		logger.debug("/////////////////////////");
		 
		if(codeCheck == true)
		{      
		       
		date = voteService.dateSelect(date);  
		       
		String startDate = date.getUploadStartDate(); // 시작 날짜
		String endDate = date.getUploadEndDate(); // 종료 날짜
		   
		logger.debug("======================================");
		logger.debug("startDate : "+date.getUploadStartDate());
		logger.debug("endDate : "+date.getUploadEndDate());
		logger.debug("======================================");
		     
		String startDatePart = startDate.split("\\s")[0]; //공백 기준 첫 번째 요소부터 다 자름.
		String formatSd = startDatePart.replaceAll("-", ""); // "- 날짜 다 자른다" 
		    
		String endDatePart = endDate.split("\\s")[0];
		String formatEd = endDatePart.replaceAll("-", ""); // 20230901 
		
		logger.debug("======================================");
		logger.debug("curDate : "+curDate);
		logger.debug("curDate 길이 : "+curDate.length());
		logger.debug("======================================");
		 
		logger.debug("======================================");
		logger.debug("시작일 : "+formatSd);
		logger.debug("시작일 길이 : "+formatSd.length());
		logger.debug("======================================");
		    
		logger.debug("======================================");
		logger.debug("종료일 : "+formatEd);
		logger.debug("종료일 길이: "+formatEd.length());
		logger.debug("======================================");
		        
		int cd = Integer.parseInt(curDate);
		int sd =  Integer.parseInt(formatSd);
		int ed = Integer.parseInt(formatEd);
		   
		if(cd >= sd && cd <= ed)
		{      
		res.setResponse(0, "success");
		}
		else
		{
		res.setResponse(300, "Not Vote Date");
		}
		}
		else
		{
		res.setResponse(200, "not Artist");
		}
		}
		else
		{
		res.setResponse(400, "no user"); // 로그인 상태가 아닐 때
		}
		   
		return res;
	}
	
	// 날짜 삽입 (1)
	@RequestMapping(value="/vote/insertProc")
	@ResponseBody
	public Response<Object> insertProc(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> res = new Response<Object>();
		
		String uploadStartDate = HttpUtil.get(request, "uploadStartDate");
		String uploadEndDate = HttpUtil.get(request, "uploadEndDate");
		
		DateManage date = new DateManage();
		
		date.setUploadStartDate(uploadStartDate);
		date.setUploadEndDate(uploadEndDate);
		
		if(voteService.voteInsert(date) > 0)
		{
			res.setResponse(0, "Success");
		}
		else
		{
			res.setResponse(400, "Bad Request");
		}

		if(logger.isDebugEnabled())
		{
			logger.debug("[VoteDao]/vote/insertProc response\n" + JsonUtil.toJsonPretty(res));
		}

		return res;
	}
	
	//작품 상세페이지
	@RequestMapping(value="/vote/voteDetail", method=RequestMethod.POST)
	public String voteDetail(ModelMap model, HttpServletRequest request, HttpServletResponse response) 
	{
		//게시물 번호 가져옴
		long vrSeq = HttpUtil.get(request, "vrSeq", (long)0); 
		//현재 페이지
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		
		VoteUpload voteUpload = null;
		
		if(vrSeq > 0) {
			voteUpload = voteService.voteDetail(vrSeq);
		}
		
		model.addAttribute("vrSeq", vrSeq);
		model.addAttribute("voteUpload", voteUpload);
		model.addAttribute("curPage", curPage);
		
		return "/vote/voteDetail";
	}
	
	@RequestMapping("/vote/voteResult")
	public String voteResultList(ModelMap model,HttpServletRequest request, HttpServletResponse response) 
	{
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		//현재 페이지
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		//게시물 리스트
		List<VoteUpload> list = null;
		VoteUpload voteUpload = new VoteUpload();
		//조회항목(1:미술, 2:사진, 3:도예)
		int searchType = HttpUtil.get(request, "searchType",0);
		String searchDate = HttpUtil.get(request, "searchDate", "");
		int gubun = HttpUtil.get(request, "searchType",0);
		//총 게시물 수
		long totalCount = 0;
		//페이징 객체
		Paging paging = null;
		
		voteUpload.setStatus("N");
		User user = null;
		DateManage date = null;
		
		
		
		if(!StringUtil.isEmpty(searchType))
		{
			voteUpload.setCategoryNo(searchType);
		}
		if(!StringUtil.isEmpty(searchDate))
		{
			voteUpload.setSearchDate(searchDate);
	    }
		

		totalCount = voteService.voteResultListCount(voteUpload);
		logger.debug("========================================");
		logger.debug("totalCount : " + totalCount);
		logger.debug("========================================");
		//토탈 카운트 0보다 클 때 조회
		if(totalCount > 0) 
		{
			paging = new Paging("/vote/voteResult", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");
			
			voteUpload.setCategoryNo(searchType);
			voteUpload.setStartRow(paging.getStartRow());
			voteUpload.setEndRow(paging.getEndRow());
			
			list = voteService.voteResultList(voteUpload);
		}
		
		model.addAttribute("searchDate",searchDate);
		model.addAttribute("searchType",searchType);
		model.addAttribute("list", list);
		model.addAttribute("curPage", curPage);
		model.addAttribute("paging", paging);
		model.addAttribute("user", user);
		model.addAttribute("gubun", gubun);
				
		return "/vote/voteResult";
	}
	@RequestMapping("/vote/voteResult2")
	public String voteResultList2(ModelMap model,HttpServletRequest request, HttpServletResponse response) 
	{
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		//현재 페이지
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		//게시물 리스트
		List<VoteUpload> list = null;
		VoteUpload voteUpload = new VoteUpload();
		//조회항목(1:미술, 2:사진, 3:도예)
		int searchType = HttpUtil.get(request, "searchType",0);
		String searchDate = HttpUtil.get(request, "searchDate", "");
		int gubun = HttpUtil.get(request, "searchType",0);
		//총 게시물 수
		long totalCount = 0;
		//페이징 객체
		Paging paging = null;
		
		voteUpload.setStatus("N");
		User user = null;
		DateManage date = null;
		
		
		
		if(!StringUtil.isEmpty(searchType))
		{
			voteUpload.setCategoryNo(searchType);
		}
		if(!StringUtil.isEmpty(searchDate))
		{
			voteUpload.setSearchDate(searchDate);
	    }
		

		totalCount = voteService.voteResultListCount(voteUpload);
		logger.debug("========================================");
		logger.debug("totalCount : " + totalCount);
		logger.debug("========================================");
		//토탈 카운트 0보다 클 때 조회
		if(totalCount > 0) 
		{
			paging = new Paging("/vote/voteResult", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");
			
			voteUpload.setCategoryNo(searchType);
			voteUpload.setStartRow(paging.getStartRow());
			voteUpload.setEndRow(paging.getEndRow());
			
			list = voteService.voteResultList(voteUpload);
		}
		
		model.addAttribute("searchDate",searchDate);
		model.addAttribute("searchType",searchType);
		model.addAttribute("list", list);
		model.addAttribute("curPage", curPage);
		model.addAttribute("paging", paging);
		model.addAttribute("user", user);
		model.addAttribute("gubun", gubun);
				
		return "/vote/voteResult";
	}
	
	@RequestMapping(value="/vote/voteListDetail")
	public String voteListDetail(ModelMap model, HttpServletRequest request, HttpServletResponse response) 
	{
		//게시물 번호 가져옴
		long vrSeq = HttpUtil.get(request, "vrSeq", (long)0); 
		//현재 페이지
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		String gubun = HttpUtil.get(request, "gubun", "");
		VoteUpload voteUpload = null;
		logger.debug("gubun"+gubun);
		if(vrSeq > 0) 
		{
			voteUpload = voteService.voteDetail(vrSeq);
		}
		
		model.addAttribute("gubun",gubun);
		model.addAttribute("vrSeq", vrSeq);
		model.addAttribute("voteUpload", voteUpload);
		model.addAttribute("curPage", curPage);
		
		return "/vote/voteListDetail";
	}
	@RequestMapping(value="/vote/voteResultDetail")
	public String voteResultDetail(ModelMap model, HttpServletRequest request, HttpServletResponse response) 
	{
		//게시물 번호 가져옴
		long vrSeq = HttpUtil.get(request, "vrSeq", (long)0); 
		//현재 페이지
		long curPage = HttpUtil.get(request, "curPage", (long)1);

		String gubun = HttpUtil.get(request, "gubun", "");
		
		String searchDate = HttpUtil.get(request, "searchDate", "");
		
		
		VoteUpload voteUpload = null;
		
		
		if(vrSeq > 0) 
		{
			voteUpload = voteService.voteDetail(vrSeq);
			
		}
		
		model.addAttribute("vrSeq", vrSeq);
		model.addAttribute("voteUpload", voteUpload);
		model.addAttribute("curPage", curPage);
		model.addAttribute("gubun",gubun);
		model.addAttribute("searchDate",searchDate);
		
		return "/vote/voteResultDetail";
	}
	
	@RequestMapping(value="vote/doVoteProc")
	   @ResponseBody
	   public Response<Object> doVoteProc(HttpServletResponse response, HttpServletRequest request)
	   {
	      Response<Object> res = new Response<Object>();
	      
	      String string = HttpUtil.get(request, "string"); //ajax를 통해 받은 문자열 "1, 2, 3, 4, 5, 6, 7
	      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
	      String[] strVrSeq = string.split(", "); // ", "을 자르고 배열 요소 하나하나 저장
	   
	      long[] vrSeq = new long[strVrSeq.length]; // long 타입 배열 객체 생성

	      for(int i = 0; i < strVrSeq.length; i++) // 배열요소 0 ~ n 까지 long타입으로 변환
	      {
	         vrSeq[i] = Long.parseLong(strVrSeq[i]);
	      }
	      // ???? 수정할 부분 ( 어떤 작품이 중복됬을 때 alert를 뿌려주고 아예 막아버리거나 ... 그외 생각 )

	      User user = userService.userSelect(cookieUserId);
	      
	      if(user != null)
	      {
	         for(int i=0; i<vrSeq.length; i++)
	         {
	            VoteList vl = voteService.voteListSelect(vrSeq[i], cookieUserId);
	         
	            if(vl != null)
	            {
	               res.setResponse(200, "Duplicated."); // 여러개 선택해서 중복되는 넘이 있으면 바로 취소
	               return res;
	            }   
	         }                                 
	         
	         for(int i=0; i<vrSeq.length; i++)
	         {
	            VoteList voteList = new VoteList();
	            
	            voteList.setVrSeq(vrSeq[i]);
	            voteList.setVlUserId(cookieUserId);
	            
	            if(voteService.voteListInsert(voteList) > 0)
	            {
	               voteService.voteCntUpdate(voteList);
	               
	               if(vrSeq[i] == vrSeq[vrSeq.length-1])
	               {
	                  res.setResponse(0, "success");
	                  
	               }
	            }
	            else
	            {
	               res.setResponse(100, "fail");
	            }
	         }
	         
	      }
	      else
	      {
	         res.setResponse(400, "not login");
	      }
	   
	      return res;
	      
	      
	   }
	
}
