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
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.icia.common.model.FileData;
import com.icia.common.util.StringUtil;
import com.icia.web.model.Admin;
import com.icia.web.model.NoticeBoard;
import com.icia.web.model.Paging;
import com.icia.web.model.QnaBoard;
import com.icia.web.model.Response;
import com.icia.web.model.User;
import com.icia.web.service.AdminService;
import com.icia.web.service.BoardService;
import com.icia.web.service.UserService;
import com.icia.web.util.CookieUtil;
import com.icia.web.util.HttpUtil;

@Controller("boardController")
public class BoardController {
	private static Logger logger = LoggerFactory.getLogger(BoardController.class);
	
	//쿠키명
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	@Autowired
	private BoardService boardService;

	@Autowired
	private AdminService adminService;
	
	@Autowired
	private UserService userService;
	
	private static final int LIST_COUNT = 10;	//한페이지의 게시물 수 
	private static final int PAGE_COUNT = 5; 	//페이징 수 
	
	@RequestMapping("/board/noticeBoard")
	public String noticeList(ModelMap model, HttpServletRequest request, HttpServletResponse response)
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
			paging = new Paging("/board/noticeBoard", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");
			
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
		
		return "/board/noticeBoard";

	}
	//게시물 조회
	@RequestMapping(value="/board/noticeView")
	public String view(ModelMap model,HttpServletRequest request, HttpServletResponse response)
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
		
		return "/board/noticeView";
	}
	//게시물 수정 
	@RequestMapping(value="/board/noticeUpdate")
	public String updateForm(ModelMap model,HttpServletRequest request, HttpServletResponse response)
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
		return "/board/noticeUpdate";
	}
	@RequestMapping(value="/board/noticeUpdateProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> updateProc(HttpServletRequest request, HttpServletResponse response)
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
						logger.error("[BoardController] NoticeUpdateProc Exception",e);
						
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
	//게시물 삭제
	@RequestMapping(value="/board/noticeDelete", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> delete(HttpServletRequest request, HttpServletResponse response)
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
	@RequestMapping(value="/board/noticeWrite")  
	public String writeForm(ModelMap model,HttpServletRequest request, HttpServletResponse response)
	{	; 
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
		return "/board/noticeWrite";
	}
	//게시물 등록(ajax)
	@RequestMapping(value="/board/noticeWriteProc",method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> writeProc(HttpServletRequest request, HttpServletResponse response)
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

	//qna게시판
	@RequestMapping("/board/qnaBoard")
	public String qnaList(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		//조회항목(1:제목, 2:내용)
		String searchType = HttpUtil.get(request, "searchType","");
		//조회값 
		String searchValue = HttpUtil.get(request, "searchValue","");
		//현재페이지
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		//게시물 리스트 
		List<QnaBoard> list = null;
		//조회 객체
		QnaBoard search = new QnaBoard();
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
		
		totalCount = boardService.QnaBoardListCount(search);
		
		if(totalCount > 0)
		{
			paging = new Paging("/board/qnaBoard", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");
			
			search.setStartRow(paging.getStartRow());
			search.setEndRow(paging.getEndRow());
			
			list = boardService.QnaBoardList(search);
			
		}
		model.addAttribute("boardMe",boardMe);
		model.addAttribute("list",list);
		model.addAttribute("searchType",searchType);
		model.addAttribute("searchValue",searchValue);
		model.addAttribute("curPage",curPage);
		model.addAttribute("paging", paging);
		
		return "/board/qnaBoard";
	}
	//게시물 조회
	@RequestMapping(value="/board/qnaView")
	public String qnaView(ModelMap model,HttpServletRequest request, HttpServletResponse response)
	{
		//쿠키값
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		//게시물 번호
		long qaSeq = HttpUtil.get(request, "qaSeq", (long)0);		
		//조회항목(1.제목, 2.내용)
		String searchType = HttpUtil.get(request,"searchType","");
		//조회 값
		String searchValue = HttpUtil.get(request,"searchValue", "");
		//현재 페이지
		long curPage = HttpUtil.get(request,"curPage",(long)1);
		
		User user = userService.userSelect(cookieUserId);
		Admin admin = adminService.adminSelect(cookieUserId);
		
		//본인 글 여부
		String boardMe1 ="N";	//수정, 삭제
		String boardMe2 ="N";	//답글 
		
		logger.info("#############################");
		logger.info("boardMe1: ", boardMe1);
		logger.info("boardMe2: ", boardMe2);
		logger.info("#############################");
		
		QnaBoard qnaBoard = null;
		
		if(qaSeq >0) 		
		{
			qnaBoard = boardService.QnaBoardView(qaSeq);
			
			if(qnaBoard != null && StringUtil.equals(qnaBoard.getUserId(), cookieUserId))
			{
				boardMe1="Y";
			}
			if(qnaBoard != null && admin != null)
			{
				boardMe2="Y";
			}
		}
		
		logger.info("#############################");
		logger.info("boardMe1: ", boardMe1);
		logger.info("boardMe2: ", boardMe2);
		logger.info("#############################");
		
		model.addAttribute("boardMe1",boardMe1);
		model.addAttribute("boardMe2",boardMe2);
		model.addAttribute("qaSeq", qaSeq);
		model.addAttribute("qnaBoard", qnaBoard);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("curPage", curPage);
		
		return "/board/qnaView";
	}
	@RequestMapping(value="/board/qnaWrite")
	public String qnaWrite(ModelMap model,HttpServletRequest request, HttpServletResponse response)
	{	
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long qaSeq = HttpUtil.get(request, "qaSeq", 0);
		String searchType = HttpUtil.get(request, "searchType","");
		String searchValue = HttpUtil.get(request,"searchValue","");
		long curPage = HttpUtil.get(request,"curPage",(long)1);
		
		User user = userService.userSelect(cookieUserId);	
		
		model.addAttribute("searchType",searchType);
		model.addAttribute("searchValue",searchValue);
		model.addAttribute("curPage", curPage);
		model.addAttribute("qaSeq", qaSeq);
		
	    model.addAttribute("user",user); 
		return "/board/qnaWrite";
	}
	//게시물 등록(ajax)
	@RequestMapping(value="/board/qnaWriteProc",method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> qnaWriteProc(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String userId = HttpUtil.get(request, "userId", "");
		String userNick = HttpUtil.get(request, "userNick", "");
		String qaTitle = HttpUtil.get(request, "qaTitle", "");
		String qaContent = HttpUtil.get(request, "qaContent","");
		if(!StringUtil.isEmpty(qaTitle) && !StringUtil.isEmpty(qaContent))
		{
			QnaBoard qnaBoard = new QnaBoard();
			
			qnaBoard.setUserId(userId);
			qnaBoard.setUserNick(userNick);
			qnaBoard.setQaTitle(qaTitle);
			qnaBoard.setQaContent(qaContent);
			
			//서비스 호출
			try 
			{
				if(boardService.QnaBoardInsert(qnaBoard) >=0)
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
	//게시물 삭제
	@RequestMapping(value="/board/qnaDelete", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> qnaDelete(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long qaSeq = HttpUtil.get(request, "qaSeq", (long)0);
		
		if(qaSeq > 0)
		{
			QnaBoard qnaBoard = boardService.QnaBoardSelect(qaSeq);
			
			if(qnaBoard != null)
			{
				if(StringUtil.equals(cookieUserId, qnaBoard.getUserId()))
				{
					try
					{
						if(boardService.QnaBoardDelete(qnaBoard)>0)
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
						logger.error("[HiBoardControll] boardDelete Exception",e);
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
	@RequestMapping(value="/board/qnaUpdate")
	public String qnaUpdateForm(ModelMap model,HttpServletRequest request, HttpServletResponse response)
	{
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long qaSeq = HttpUtil.get(request, "qaSeq", (long)0);
		String searchType = HttpUtil.get(request, "searchType","");
		String searchValue = HttpUtil.get(request, "searchValue","");
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		
		QnaBoard qnaBoard = null;
		User user = null;
		
		if(qaSeq > 0)
		{
			qnaBoard = boardService.QnaBoardViewUpdate(qaSeq);
			if(qnaBoard != null)
			{
				if(StringUtil.equals(qnaBoard.getUserId(), cookieUserId))
				{
					user=userService.userSelect(cookieUserId);
				}
				else
				{
					qnaBoard = null;
				}
			}
			model.addAttribute("searchType", searchType);		//jsp에서 사용할 이름 , 오브젝트 타입 : 어떤객체가 다 와도 된다. 
			model.addAttribute("searchValue", searchValue);
			model.addAttribute("curPage", curPage);
			model.addAttribute("qnaBoard", qnaBoard);
			model.addAttribute("user", user);
			
		
		}
		return "/board/qnaUpdate";
	}
	//게시물 수정 
	@RequestMapping(value="/board/qnaUpdateProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> qnaUpdateProc(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long qaSeq = HttpUtil.get(request, "qaSeq", (long)0);
		String qaTitle = HttpUtil.get(request, "qaTitle","");
		String qaContent = HttpUtil.get(request, "qaContent","");
		
		if(qaSeq > 0 && !StringUtil.isEmpty(qaTitle) && !StringUtil.isEmpty(qaContent))
		{
			QnaBoard qnaBoard = boardService.QnaBoardSelect(qaSeq);
			if(qnaBoard != null)
			{
				if(StringUtil.equals(qnaBoard.getUserId(), cookieUserId))
				{
					qnaBoard.setQaTitle(qaTitle);
					qnaBoard.setQaContent(qaContent);
					
					try 
					{
						if(boardService.QnaBoardUpdate(qnaBoard) > 0)
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
	//게시물 답변 화면
	@RequestMapping(value="/board/qnaReply", method=RequestMethod.POST)
	public String qnaReply(ModelMap model,HttpServletRequest request, HttpServletResponse response)
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

		return "/board/qnaReply";
	}
	//게시물 답변 
	@RequestMapping(value="/board/qnaReplyProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> replyProc(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long qaSeq = HttpUtil.get(request, "qaSeq",0);		
		String userNick = HttpUtil.get(request,"userNick","");
		String qaTitle = HttpUtil.get(request,"qaTitle","");
		String qaContent = HttpUtil.get(request,"qaContent","");
		
		if(qaSeq > 0 && !StringUtil.isEmpty(qaTitle)			 
				&&!StringUtil.isEmpty(qaContent))
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
					if(boardService.QnaBoardReplyInsert(qnaBoard)>=0)	//처리건수를 리턴하고 있어서 >=0 안쓰면 오류남 왜냐면 if는 true,false니까
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
	//게시물 답글삭제
		@RequestMapping(value="/board/qnaDelete2", method=RequestMethod.POST)
		@ResponseBody
		public Response<Object> qnaDelete2(HttpServletRequest request, HttpServletResponse response)
		{
			Response<Object> ajaxResponse = new Response<Object>();
			String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
			long qaSeq = HttpUtil.get(request, "qaSeq", (long)0);
			
			if(qaSeq > 0)
			{
				QnaBoard qnaBoard = boardService.QnaBoardSelect(qaSeq);
				
				if(qnaBoard != null)
				{
					if(StringUtil.equals(cookieUserId, qnaBoard.getAdmId()))
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
}
