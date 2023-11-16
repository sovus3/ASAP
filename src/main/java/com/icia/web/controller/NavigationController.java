package com.icia.web.controller;

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
import com.icia.web.model.Cart;
import com.icia.web.model.Response;
import com.icia.web.model.User;
import com.icia.web.service.AdminService;
import com.icia.web.service.ProductService;
import com.icia.web.service.UserService;
import com.icia.web.util.CookieUtil;
import com.icia.web.util.HttpUtil;

@Controller("navigationController")
public class NavigationController {
	private static Logger logger = LoggerFactory.getLogger(NavigationController.class);
	
	//쿠키명
		@Value("#{env['auth.cookie.name']}")
		private String AUTH_COOKIE_NAME;
		
		@Value("#{env['upload.vote.dir']}")
		private String UPLOAD_VOTE_DIR;
		
		@Autowired
		UserService userService;
		
		@Autowired
		AdminService adminService;
		
		@Autowired
		ProductService productService;
		
		private static final int LIST_COUNT = 9; //한 페이지에 게시물 수
		private static final int PAGE_COUNT = 5; //페이징 수
		
	@RequestMapping(value="/include/navigation")
	@ResponseBody
	public Response<Object> cartTotalCount(ModelMap model, HttpServletRequest request, HttpServletResponse response){
		Response<Object> ajaxResponse = new Response<Object>();
				
		String userId = HttpUtil.get(request, "userId","");
		 
		Cart cart = new Cart();
		cart.setUserId(userId);
			
		  //총 게시물 수
		long totalCount = 0;
		
		totalCount = productService.cartListCount(cart);
		  
		logger.debug("========================================");
		logger.debug("totalCount : " + totalCount);
		logger.debug("========================================");
		
		//토탈 카운트 0보다 클 때 조회
		if(totalCount >= 0) {
			model.addAttribute("totalCount", totalCount);
			ajaxResponse.setResponse(0, "totalCount",totalCount);
			logger.debug("========================================");
			logger.debug("totalCount11111 : " + totalCount);
			logger.debug("========================================");
		}
		else {
			ajaxResponse.setResponse(404, "totalCount fail");
		}	
			
		return ajaxResponse;
	}
}
