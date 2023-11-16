package com.icia.web.controller;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.icia.common.util.StringUtil;
import com.icia.web.model.Cart;
import com.icia.web.model.Order;
import com.icia.web.model.OrderDetail;
import com.icia.web.model.Paging;
import com.icia.web.model.Pay;
import com.icia.web.model.Product;
import com.icia.web.model.Response;
import com.icia.web.model.Review;
import com.icia.web.model.User;
import com.icia.web.service.AdminService;
import com.icia.web.service.MyPageService;
import com.icia.web.service.ProductService;
import com.icia.web.service.UserService;
import com.icia.web.util.CookieUtil;
import com.icia.web.util.HttpUtil;
import com.icia.web.util.JsonUtil;

@Controller("productController")
public class ProductController {
	private static Logger logger = LoggerFactory.getLogger(UserController.class);

	// 쿠키명
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;

	@Value("#{env['upload.vote.dir']}")
	private String UPLOAD_VOTE_DIR;

	private String realPath = "C:\\project\\webapps\\ASAP\\src\\main\\webapp\\WEB-INF\\views";

	@Autowired
	UserService userService;

	@Autowired
	AdminService adminService;

	@Autowired
	ProductService productService;
	
	@Autowired
	MyPageService myPageService;

	private static final int LIST_COUNT = 9; // 한 페이지에 게시물 수
	private static final int PAGE_COUNT = 5; // 페이징 수

	// 상품 리스트
	@RequestMapping(value = "/product/productList")
	public String productList(ModelMap model, HttpServletRequest request, HttpServletResponse response) 
	{
		// 현재 페이지
		long curPage = HttpUtil.get(request, "curPage", (long) 1);
		// 게시물 리스트
		List<Product> list = null;
		Product product = new Product();
		// 총 게시물 수
		long totalCount = 0;
		// 페이징 객체
		Paging paging = null;
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		User user = null;
		
		if (!StringUtil.isEmpty(cookieUserId)) 
		{
			user = userService.userSelect(cookieUserId);
		}
		product.setStatus("Y");
		
		totalCount = productService.productListCount(product);
		logger.debug("========================================");
		logger.debug("totalCount : " + totalCount);
		logger.debug("========================================");
		// 토탈 카운트 0보다 클 때 조회
		if (totalCount > 0) 
		{
			paging = new Paging("/product/productList", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");
			
			list = productService.productList(product);
		}
		
		model.addAttribute("user", user);
		model.addAttribute("list", list);
		model.addAttribute("curPage", curPage);
		model.addAttribute("paging", paging);
		
		return "/product/productList";
	}
	
	@RequestMapping(value = "/prodcut/cartProc", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> cartProc(HttpServletRequest request, HttpServletResponse response) 
	{
		Response<Object> ajaxResponse = new Response<Object>();
		
		String userId = HttpUtil.get(request, "userId", "");
		long productSeq = HttpUtil.get(request, "productSeq", (long) 0);
		String productName = HttpUtil.get(request, "productName");
		long cartQuantity = HttpUtil.get(request, "cartQuantity", (long) 0);
		long cartPrice = HttpUtil.get(request, "cartPrice", (long) 0);
		
		logger.debug("userId: " + userId);
		logger.debug("productSeq: " + productSeq);
		logger.debug("productName: " + productName);
		logger.debug("cartQuantity: " + cartQuantity);
		logger.debug("cartPrice: " + cartPrice);
		
		Cart cart = new Cart();
		
		cart.setUserId(userId);
		cart.setProductSeq(productSeq);
		cart.setProductName(productName);
		cart.setCartQuantity(cartQuantity);
		cart.setCartPrice(cartPrice);
		
		if (productService.cartInsert(cart) > 0) 
		{
			ajaxResponse.setResponse(0, "insert success");
		} 
		else 
		{
			ajaxResponse.setResponse(404, "insert fail");
		}
		
		
		return ajaxResponse;
	}
	
	@RequestMapping(value = "/prodcut/cartProc1", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> cartProc1(HttpServletRequest request, HttpServletResponse response) 
	{
		Response<Object> ajaxResponse = new Response<Object>();
		
		String userId = HttpUtil.get(request, "userId", "");
		long productSeq = HttpUtil.get(request, "productSeq", (long) 0);
		Product product = null;
		
		product = productService.productDetail(productSeq);
		
		logger.debug("userId: " + userId);
		logger.debug("productSeq: " + productSeq);
		
		Cart cart = new Cart();
		
		cart.setUserId(userId);
		cart.setProductSeq(productSeq);
		cart.setProductName(product.getProductName());
		cart.setCartQuantity(1);
		cart.setCartPrice(product.getProductPrice());
		
		if (productService.cartInsert(cart) > 0) 
		{
			ajaxResponse.setResponse(0, "insert success");
		} 
		else 
		{
			ajaxResponse.setResponse(404, "insert fail");
		}
		
		return ajaxResponse;
	}

	@RequestMapping(value = "/product/cartCheck", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> idCheck(HttpServletRequest request, HttpServletResponse response) 
	{
		Response<Object> ajaxResponse = new Response<Object>();
		
		String userId = HttpUtil.get(request, "userId", "");
		long productSeq = HttpUtil.get(request, "productSeq", (long) 0);
		
		Cart cart = null;
		cart = productService.cartDuplicate(userId, productSeq);
		
		if (cart != null) 
		{
			ajaxResponse.setResponse(100, "duplicate");
		} 
		else 
		{
			ajaxResponse.setResponse(0, "success");
		}
		
		if (logger.isDebugEnabled()) 
		{
			logger.debug("[productController] /product/cartCheck response\n" + JsonUtil.toJsonPretty(ajaxResponse));
		}
		
		return ajaxResponse;
	}
	
	@RequestMapping(value = "/product/cartQuantityUpdate", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> cartQuantityUpdate(HttpServletRequest request, HttpServletResponse response) 
	{
		Response<Object> ajaxResponse = new Response<Object>();
		
		String userId = HttpUtil.get(request, "userId", "");
		long productSeq = HttpUtil.get(request, "productSeq", (long) 0);
		
		Cart cart = null;
		cart = productService.cartDuplicate(userId, productSeq);
		
		if (productService.cartQuantityUpdate(cart) > 0) 
		{
			ajaxResponse.setResponse(0, "success");
		} 
		else 
		{
			ajaxResponse.setResponse(400, "error");
		}
		if (logger.isDebugEnabled()) 
		{
			logger.debug("[ProductController] /product/productQunatityUpdate response\n" + JsonUtil.toJsonPretty(ajaxResponse));
		}
		
		return ajaxResponse;
	}

	@RequestMapping(value = "/product/productCart")
	public String cartList(ModelMap model, HttpServletRequest request, HttpServletResponse response) 
	{
		// 현재 페이지
		long curPage = HttpUtil.get(request, "curPage", (long) 1);
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		//////추가 
		Product product = new Product();
		//////
		List<Cart> list = null;
		Cart cart = new Cart();
		cart.setUserId(cookieUserId);
		
		// 총 게시물 수
		long totalCount = 0;
		// 페이징 객체
		Paging paging = null;
		
		totalCount = productService.cartListCount(cart);
		
		logger.debug("========================================");
		logger.debug("totalCount : " + totalCount);
		logger.debug("========================================");
		
		// 토탈 카운트 0보다 클 때 조회
		if (totalCount > 0) 
		{
			paging = new Paging("/product/cartList", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");
			
			product.setProductSeq(cart.getProductSeq());
			list = productService.cartList(cookieUserId);
		}
		
		model.addAttribute("list", list);
		model.addAttribute("product", product);
		model.addAttribute("cart", cart);
		model.addAttribute("curPage", curPage);
		model.addAttribute("paging", paging);
		model.addAttribute("totalCount", totalCount);
		
		return "/product/productCart";
	}
	
	// 상품 상세 - 결제
	@RequestMapping(value = "/product/productCheckOutDirect")
	public String productCheckOutDirect(ModelMap model, HttpServletRequest request, HttpServletResponse response) 
	{
		// 상품 번호 가져옴
		long productSeq = HttpUtil.get(request, "productSeq", (long) 0);
		long price = HttpUtil.get(request, "price", (long) 0);
		long quantity = HttpUtil.get(request, "quantity", (long) 0);
		long maxProductQuan = (long)0; 
		
		logger.debug("========================================");
		logger.debug("price : " + price);
		logger.debug("quantity : " + quantity);
		logger.debug("maxProductQuan : " + maxProductQuan);
		logger.debug("========================================");
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		Product product = null;
		User user = null;
		
		if (!StringUtil.isEmpty(cookieUserId)) 
		{
			user = userService.userSelect(cookieUserId);
			
			if (user != null && StringUtil.equals(cookieUserId, user.getUserId())) 
			{
				if (productSeq > 0) 
				{
					product = productService.productDetail(productSeq);
					maxProductQuan = product.getProductQuantity();
				}
			}
		}
		model.addAttribute("quantity", quantity);
		model.addAttribute("productSeq", productSeq);
		model.addAttribute("price", price);
		model.addAttribute("product", product);
		model.addAttribute("user", user);
		model.addAttribute("maxProductQuan", maxProductQuan);
		
		return "/product/productCheckOutDirect";
	}

	@RequestMapping(value = "/product/productCheckOut")
	public String productCheckOut(ModelMap model, HttpServletRequest request, HttpServletResponse response) 
	{
		String userId = HttpUtil.get(request, "userId", "");
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String gubunCheck = HttpUtil.get(request, "gubunCheck", "");		
		
		List<Cart> list = null;
		User user = null;
		
		if (!StringUtil.isEmpty(cookieUserId)) 
		{
			user = userService.userSelect(cookieUserId);
			
			if (user != null && StringUtil.equals(cookieUserId, user.getUserId())) 
			{
				logger.debug("========================================");
				logger.debug("userId " + userId);
				logger.debug("cookieUserId: " + cookieUserId);
				logger.debug("========================================");
				list = productService.cartList(userId);
			}
		}
		
		model.addAttribute("gubunCheck", gubunCheck);
		model.addAttribute("list", list);
		model.addAttribute("user", user);
		
		return "/product/productCheckOut";
	}
		
	@RequestMapping(value = "/prodcut/cartUpdateProc", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> cartUpdateProc(HttpServletRequest request, HttpServletResponse response) 
	{
		Response<Object> ajaxResponse = new Response<Object>();
		
		String userId = HttpUtil.get(request, "userId", "");
		long productSeq = HttpUtil.get(request, "productSeq", (long) 0);
		long cartQuantity = HttpUtil.get(request, "cartQuantity", (long) 0);
		
		logger.debug("========================================");
		logger.debug("userId " + userId);
		logger.debug("productSeq: " + productSeq);
		logger.debug("========================================");
		
		Cart cart = new Cart();
		cart = productService.cartDuplicate(userId, productSeq);
		if (cart != null) 
		{
			cart.setUserId(userId);
			cart.setProductSeq(productSeq);
			cart.setCartQuantity(cartQuantity);
			
			if (productService.cartUpdate(cart) > 0) 
			{
				ajaxResponse.setResponse(0, "update success");
			} 
			else 
			{
				ajaxResponse.setResponse(404, "update fail");
			}
		}
		return ajaxResponse;
	}
	
	@RequestMapping(value = "/prodcut/cartDelete", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> cartDelete(HttpServletRequest request, HttpServletResponse response) 
	{
		Response<Object> ajaxResponse = new Response<Object>();
		
		String userId = HttpUtil.get(request, "userId", "");
		long productSeq = HttpUtil.get(request, "productSeq", (long) 0);
		
		logger.debug("========================================");
		logger.debug("userId " + userId);
		logger.debug("productSeq: " + productSeq);
		logger.debug("========================================");
		
		Cart cart = new Cart();
		cart = productService.cartDuplicate(userId, productSeq);
		
		if (cart != null) 
		{
			if (productService.cartDelete(cart) > 0) 
			{
				ajaxResponse.setResponse(0, "update success");
			} 
			else 
			{
				ajaxResponse.setResponse(404, "update fail");
			}
		}
		return ajaxResponse;
	}

	@RequestMapping(value = "/prodcut/cartTotalCount")
	@ResponseBody
	public Response<Object> cartTotalCount(ModelMap model, HttpServletRequest request, HttpServletResponse response) 
	{
		Response<Object> ajaxResponse = new Response<Object>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		Cart cart = new Cart();
		cart.setUserId(cookieUserId);
		
		// 총 게시물 수
		long totalCount = 0;
		
		totalCount = productService.cartListCount(cart);
		
		logger.debug("========================================");
		logger.debug("totalCount : " + totalCount);
		logger.debug("========================================");
		
		// 토탈 카운트 0보다 클 때 조회
		if (totalCount > 0) 
		{
			model.addAttribute("totalCount", totalCount);
			ajaxResponse.setResponse(0, "totalCount success", totalCount);
		} 
		else 
		{
			ajaxResponse.setResponse(404, "totalCount fail");
		}
		return ajaxResponse;
	}

	// 상품 상세
	@RequestMapping(value = "/product/productDetail")
	public String productDetail(ModelMap model, HttpServletRequest request, HttpServletResponse response) 
	{
		// 상품 번호 가져옴
		long productSeq = HttpUtil.get(request, "productSeq", (long) 0);
		long reviewSeq = HttpUtil.get(request, "reviewSeq", (long) 0);
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		Product product = null;
		User user = null;
		List<Review> list = null;
		Review review = new Review();
		// 현재 페이지
		long curPage = HttpUtil.get(request, "curPage", (long) 1);
		// 총 리뷰 수
		long totalCount = 0;
		long reviewCnt = HttpUtil.get(request, "reviewCnt", (long) 0);
		// 페이징 객체
		Paging paging = null;
		int maxProductQuan = 0;      

		logger.debug("------------------------------reviewSeq" + reviewSeq);
		if (productSeq > 0) 
		{
			logger.debug("1111111111111111111111111 : " + productSeq);
			product = productService.productDetail(productSeq);
			maxProductQuan = productService.maxProductQuan(productSeq);
			user = userService.userSelect(cookieUserId);
			
			reviewCnt = productService.reviewCnt(productSeq);
			
			logger.debug("~~~~~~~~~~~~~~~1111 : " + reviewCnt);
			
			if (reviewCnt > 0) 
			{
				logger.debug("~~~~~~~~~~~~~~~2222 : " + reviewCnt);
				model.addAttribute("reviewCnt", reviewCnt);
			}
			logger.debug("~~~~~~~~~~~~~~~3333 : " + reviewCnt);
			
			totalCount = productService.reviewListCount(productSeq);
			
			if (totalCount > 0) 
			{
				logger.debug("2222222222222222222222222222 : " + totalCount);
				paging = new Paging("/vote/voteList", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");
				logger.debug("333333333333333333333332 : " + totalCount);
				review.setProductSeq(productSeq);
				review.setStartRow(paging.getStartRow());
				review.setEndRow(paging.getEndRow());
			}
			
			logger.debug("444444444444444 : " + totalCount);
			list = productService.reviewList(review);
		}

		model.addAttribute("maxProductQuan", maxProductQuan);
		model.addAttribute("review", review);
		model.addAttribute("list", list);
		model.addAttribute("curPage", curPage);
		model.addAttribute("paging", paging);
		model.addAttribute("productSeq", productSeq);
		model.addAttribute("product", product);
		model.addAttribute("user", user);

		return "/product/productDetail";
	}
	@RequestMapping(value = "/product/productCartCheck")
	@ResponseBody
	public Response<Object> productCartCheck(ModelMap model, HttpServletRequest request, HttpServletResponse response) 
	{
		Response<Object> ajaxResponse = new Response<Object>();
		
		// 현재 페이지
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		List<Cart> list = null;
		Cart cart = new Cart();
		cart.setUserId(cookieUserId);
		Product product = new Product();
		// 총 게시물 수
		long totalCount = 0;
		
		totalCount = productService.cartListCount(cart);
				

		// 토탈 카운트 0보다 클 때 조회
		if (totalCount > 0) 
		{			
			list = productService.cartList(cookieUserId);
			if (!list.isEmpty()) {
		        for (Cart cartItem : list) {
		            product = productService.productDetail(cartItem.getProductSeq());
		            if (product.getProductQuantity() < cartItem.getCartQuantity()) {
		                ajaxResponse.setResponse(400, "productName",cartItem.getProductName() + ", 현재 재고 : " + product.getProductQuantity());
		                // 만약 재고 초과가 발생하면 바로 루프를 종료하려면 break;를 사용할 수 있습니다.
		                logger.debug("========================================");
		                logger.debug("11111111111111111111111111111111111111111");
		        		logger.debug("product.getProductQuantity()" +product.getProductQuantity());
		        		logger.debug("cartItem.getProductQuantity()" +cartItem.getProductQuantity());
		        		logger.debug("cartItem.getProductSeq()" +cartItem.getProductSeq());
		        		logger.debug("========================================");
		                return ajaxResponse;		                
		            }
		        }
		    }

		   ajaxResponse.setResponse(0, "success");
		}
		
		return ajaxResponse;
	}
	
	// 상품 리뷰
	@RequestMapping(value = "/product/reviewWrite", method = RequestMethod.POST)
	public String reviewWrite(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long orderNo = HttpUtil.get(request, "orderNo", (long)0);
		long productSeq = HttpUtil.get(request, "productSeq", (long)0);
		  
		  OrderDetail orderDetail = new OrderDetail();
		  
		  User user = userService.userSelect(cookieUserId);
		  
		  orderDetail.setOrderNo(orderNo);
		  orderDetail.setProductSeq(productSeq);
		  
		  String product = myPageService.reviewPName(productSeq);
		  orderDetail.setProductName(product);
		  
		  logger.debug("-----------------------productName"+product);
		  logger.debug("-----------------------productSeq"+productSeq);
		  logger.debug("-----------------------orderNo"+orderNo);
		  
		  model.addAttribute("user", user);
		  model.addAttribute("orderDetail", orderDetail);
		  model.addAttribute("orderNo", orderNo);
		  model.addAttribute("productSeq", productSeq);
		  //model.addAttribute("productName", productName);
		  
		  return "/product/reviewWrite";
	  }
	
	// 상품 리뷰 이미지 처리
	@ResponseBody
	@PostMapping("/api/uploadSummernoteImageFile")
	public HashMap<String, Object> uploadSummernoteImageFile(@RequestParam("file") MultipartFile multipartFile) 
	{
		return productService.reviewImageUpload(multipartFile);
	}
	
	// 상품 리뷰 등록
	@RequestMapping(value = "/product/reviewWriteProc", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> reviewWriteProc(HttpServletRequest request, HttpServletResponse response) 
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long orderNo = HttpUtil.get(request, "orderNo", (long)0);
		long productSeq = HttpUtil.get(request, "productSeq", (long)0);
		String summernote = HttpUtil.get(request, "summernote", "");
		Review review = new Review();
		OrderDetail orderDetail = new OrderDetail();
		
		review.setUserId(cookieUserId);
		review.setReviewContent(summernote);
		review.setOrderNo(orderNo);
		review.setProductSeq(productSeq);
		
		
		
		if (productService.reviewInsert(review) > 0) 
		{
			orderDetail.setOrderNo(orderNo);
			orderDetail.setProductSeq(productSeq);
			
			if(myPageService.orderDUpdate(orderDetail) > 0) 
			{
				ajaxResponse.setResponse(0, "정상, 성공");
			}
		} 
		else 
		{
			ajaxResponse.setResponse(500, "insert 오류");
		}
		return ajaxResponse;
	}

	// 상품 리뷰 수정
	@RequestMapping(value = "/product/reviewUpdate", method = RequestMethod.POST)
	public String reviewUpdate(ModelMap model, HttpServletRequest request, HttpServletResponse response) 
	{
		// 쿠키값
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		// 게시물 번호
		long reviewSeq = HttpUtil.get(request, "reviewSeq", (long) 0);
		Review review = null;
		User user = null;
		
		logger.debug("----------1reviewSeq" + reviewSeq);
		review = productService.reviewSelect(reviewSeq);
		
		logger.debug("----------2reviewSeq" + reviewSeq);
		if (reviewSeq > 0) 
		{
			logger.debug("----------3reviewSeq" + reviewSeq);
			if (review != null) 
			{
				logger.debug("----------4reviewSeq" + reviewSeq);
				if (StringUtil.equals(review.getUserId(), cookieUserId)) 
				{
					logger.debug("----------5reviewSeq" + reviewSeq);
					user = userService.userSelect(cookieUserId);
				} 
				else 
				{
					review = null;
				}
			}
		}
		
		model.addAttribute("review", review);
		model.addAttribute("user", user);
		
		return "/product/reviewUpdate";
	}

	// 상품 리뷰 수정 이미지 처리
	@ResponseBody
	@PostMapping("/api/uploadSummernoteImageFile2")
	public HashMap<String, Object> uploadSummernoteImageFile2(@RequestParam("file") MultipartFile multipartFile) 
	{
		return productService.reviewImageUpload(multipartFile);
	}

	// 상품 리뷰 수정 등록
	@RequestMapping(value = "/product/reviewUpdateProc", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> reviewUpdateProc(HttpServletRequest request, HttpServletResponse response) 
	{
		Response<Object> ajaxResponse = new Response<Object>();
		long reviewSeq = HttpUtil.get(request, "reviewSeq", (long) 0);
		String summernote = HttpUtil.get(request, "summernote", "");
		
		// 넘어온게 있냐
		if (reviewSeq > 0 && !StringUtil.isEmpty(summernote)) 
		{
			Review review = productService.reviewSelect(reviewSeq);
			
			// 리뷰 있냐
			if (review != null) 
			{
				review.setReviewContent(summernote);
			
				if (productService.reviewUpdate(review) > 0) 
				{
					ajaxResponse.setResponse(0, "성공");
				} 
				else 
				{
					ajaxResponse.setResponse(500, "서버 오류");
				}
			}
			// 리뷰 없다면
			else 
			{
				ajaxResponse.setResponse(404, "찾을 수 없음");
			}
		}
		// 넘어온거 없다
		else 
		{
			ajaxResponse.setResponse(400, "넘어온거 없음");
		}
		
		return ajaxResponse;
	}

	// 리뷰 삭제
	@RequestMapping(value = "/product/reviewDelete", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> reviewDelete(HttpServletRequest request, HttpServletResponse response) 
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long reviewSeq = HttpUtil.get(request, "reviewSeq", (long) 0);
		
		if (reviewSeq > 0) 
		{
			Review review = productService.reviewSelect(reviewSeq);
			
			if (review != null) 
			{
				if (StringUtil.equals(cookieUserId, review.getUserId())) 
				{
					if (productService.reviewDelete(reviewSeq) > 0) 
					{
						ajaxResponse.setResponse(0, "성공");
					} 
					else 
					{
						ajaxResponse.setResponse(500, "서버 오류22222");
					}
				} 
				else 
				{
					ajaxResponse.setResponse(500, "서버 오류");
				}
			} 
			else 
			{
				ajaxResponse.setResponse(403, "찾을 수 없음");
			}
		} 
		else 
		{
			ajaxResponse.setResponse(400, "넘어온 값 없음");
		}
		
		return ajaxResponse;
	}
	
}
