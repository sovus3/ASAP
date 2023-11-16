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
import org.springframework.web.bind.annotation.ResponseBody;

import com.icia.common.util.StringUtil;
import com.icia.web.model.Admin;
import com.icia.web.model.AucEvent;
import com.icia.web.model.Product;
import com.icia.web.model.Response;
import com.icia.web.model.VoteUpload;
import com.icia.web.service.AdminService;
import com.icia.web.service.IndexService;
import com.icia.web.util.CookieUtil;
import com.icia.web.util.HttpUtil;
import com.icia.web.util.JsonUtil;


@Controller("indexController")
public class IndexController
{
	private static Logger logger = LoggerFactory.getLogger(IndexController.class);

	@Autowired
	IndexService indexService;
	// 쿠키명
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
		
	@Autowired
	private AdminService adminService;

	@RequestMapping(value = "/index", method=RequestMethod.GET)
	public String index(ModelMap model, HttpServletRequest request, HttpServletResponse response){

		List<VoteUpload> aucList = null;
		List<VoteUpload> voteList  = null;
		List<AucEvent> aucEvent = null;
		List<Product> product = null;
		
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
		
		return "/index";
	}
	//관리자 로그인
		@RequestMapping(value="/index/adminProc", method = RequestMethod.POST)
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
	
}
