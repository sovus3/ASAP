/**
 * <pre>
 * 프로젝트명 : HiBoard
 * 패키지명   : com.icia.web.controller
 * 파일명     : IndexController.java
 * 작성일     : 2021. 1. 21.
 * 작성자     : daekk
 * </pre>
 */
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

import com.icia.web.model.AucEvent;
import com.icia.web.model.Product;
import com.icia.web.model.User;
import com.icia.web.model.VoteUpload;
import com.icia.web.service.IndexService;
import com.icia.web.service.UserService;
import com.icia.web.util.CookieUtil;
import com.icia.web.util.HttpUtil;


@Controller("indexController")
public class IndexController
{
	private static Logger logger = LoggerFactory.getLogger(IndexController.class);

	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	@Autowired
	IndexService indexService;
	
	@Autowired
	UserService userService;

	@RequestMapping(value = "/index", method=RequestMethod.GET)
	public String index(ModelMap model, HttpServletRequest request, HttpServletResponse response){

		List<VoteUpload> aucList = null;
		List<VoteUpload> voteList  = null;
		List<AucEvent> aucEvent = null;
		List<Product> product = null;
		String isUser = "N";
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		User user = userService.userSelect(cookieUserId);
		
		if(user != null) {
			isUser = "Y";
		}
				
		aucList = indexService.indexAucList();
		if(aucList != null) {
			model.addAttribute("aucList", aucList);
		}
		
		voteList = indexService.indexVoteList();
		
		if(voteList != null) {
			model.addAttribute("voteList", voteList);
		}
		
		aucEvent = indexService.indexAucEventList();
		if(aucEvent != null) {
			model.addAttribute("aucEvent", aucEvent);
		}
		
		product = indexService.indexProcutList();
		if(product != null) {
			model.addAttribute("product", product);
		}
		
		model.addAttribute("isUser", isUser);
		
		return "/index";
	}
	
}
