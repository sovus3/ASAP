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

import com.icia.common.util.StringUtil;
import com.icia.web.model.Admin;
import com.icia.web.model.Paging;
import com.icia.web.model.VoteUpload;
import com.icia.web.service.AdminService;
import com.icia.web.util.CookieUtil;
import com.icia.web.util.HttpUtil;

@Controller("pageController")
public class PageController {
	
	private static final int LIST_COUNT = 10;	//한페이지의 게시물 수 
	private static final int PAGE_COUNT = 5; 	//페이징 수 

	
	
	@Autowired
	private AdminService adminService;

	private static Logger logger = LoggerFactory.getLogger(IndexController.class);

	@RequestMapping(value = "/pages/tables/basic-table", method = RequestMethod.GET)
	public String basicTable(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

		return "/pages/tables/basic-table";
	}

	@RequestMapping(value = "/pages/tables/table2", method = RequestMethod.GET)
	public String table2(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

		
		String searchDate = HttpUtil.get(request, "searchDate", "");
		String yearValue = HttpUtil.get(request, "yearValue", "");
		String monthValue = HttpUtil.get(request, "monthValue", "");
		long curPage = HttpUtil.get(request, "curPage", (long) 1);

		Admin admin = null;
		long totalCount = 0;
		Paging paging = null;
		VoteUpload voteUpload = new VoteUpload();
		List<VoteUpload> list = null;

		

			
				voteUpload.setVrStartDate(searchDate);

				totalCount = adminService.voteUploadToAucTotalCnt(voteUpload);

				if (totalCount > 0) {
					paging = new Paging("/admin/adminAuction", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");

					voteUpload.setStartRow(paging.getStartRow());
					voteUpload.setEndRow(paging.getEndRow());

					list = adminService.voteUploadToAucSelect(voteUpload);
				} 
			
		

		model.addAttribute("paging", paging);
		model.addAttribute("list", list);
		model.addAttribute("monthValue", monthValue);
		model.addAttribute("yearValue", yearValue);
		model.addAttribute("curPage", curPage);

		return "/pages/tables/table2";
	}

}
