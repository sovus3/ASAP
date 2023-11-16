/**
 * <pre>
 * 프로젝트명 : HiBoard
 * 패키지명   : com.icia.web.controller
 * 파일명     : UserController.java
 * 작성일     : 2021. 1. 20.
 * 작성자     : daekk
 * </pre>
 */
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

import com.google.gson.JsonObject;
import com.icia.common.util.StringUtil;
import com.icia.web.model.KakaoPayOrder;
import com.icia.web.model.KakaoPayReady;
import com.icia.web.model.Order;
import com.icia.web.model.OrderDetail;
import com.icia.web.model.Pay;
import com.icia.web.model.Response;
import com.icia.web.model.User;
import com.icia.web.service.AdminService;
import com.icia.web.service.OrderService;
import com.icia.web.service.ProductService;
import com.icia.web.service.UserService;
import com.icia.web.util.CookieUtil;
import com.icia.web.util.HttpUtil;
import com.icia.web.util.JsonUtil;

@Controller("userController")
public class UserController
{
	private static Logger logger = LoggerFactory.getLogger(UserController.class);
	
	// 쿠키명
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	@Autowired
	private UserService userService;
	@Autowired
	private AdminService adminService;
	@Autowired
	private OrderService orderService;	
	@Autowired
	ProductService productService;

	//로그인
	@RequestMapping(value = "/user/logIn", method=RequestMethod.GET)
	public String logIn(HttpServletRequest request, HttpServletResponse response)
	{
		return "/user/logIn";
	}
	
	//일반 로그인Proc
	@RequestMapping(value="/user/loginProc", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> login(HttpServletRequest request, HttpServletResponse response)
	{
		String userId = HttpUtil.get(request, "userId");
		String userPwd = HttpUtil.get(request, "userPwd");
		Response<Object> ajaxResponse = new Response<Object>();
		logger.debug("=======================================");
		logger.debug("userId : "+userId);
		logger.debug("userPwd : "+userPwd);
		logger.debug("=======================================");
		if(!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd))
		{
			User user = userService.userSelect(userId);
			
			if(user != null)
			{
				if(StringUtil.equals(user.getUserPwd(), userPwd))
				{
					if(StringUtil.equals(user.getStatus(), "Y"))
					{
						CookieUtil.addCookie(response, "/", -1, AUTH_COOKIE_NAME, CookieUtil.stringToHex(userId));
						
						ajaxResponse.setResponse(0, "Success"); // 로그인 성공
					}
					else
					{
						ajaxResponse.setResponse(-2, "Status N"); //상태 비활성화 
					}
				}
				else
				{
					ajaxResponse.setResponse(-1, "Passwords do not match"); // 비밀번호 불일치
				}
			}
			else
			{
				ajaxResponse.setResponse(404, "Not Found"); // 사용자 정보 없음 (Not Found)
			}
		}
		else
		{
			ajaxResponse.setResponse(400, "Bad Request"); // 파라미터가 올바르지 않음 (Bad Request)
		}
		
		if(logger.isDebugEnabled())
		{
			logger.debug("[UserController] /user/login response\n" + JsonUtil.toJsonPretty(ajaxResponse));
		}
		
		return ajaxResponse;
	}
	
	//로그아웃
	@RequestMapping(value="/user/logOut", method=RequestMethod.GET)
	public String logOut(HttpServletRequest request, HttpServletResponse response) 
	{
		//리퀘스트 객체에 쿠키가 있는지 여부 판단 후 있으면 쿠키 삭제
		if(CookieUtil.getCookie(request, AUTH_COOKIE_NAME) != null) 
		{
			//값이 있으면 쿠키를 삭제
			CookieUtil.deleteCookie(request, response, "/" , AUTH_COOKIE_NAME);
		}
		
		//서버에서 재접속하라는 명령(URL을 다시 가리킴)
		//리턴타입이 스트링이라서 뷰리졸버를 호출해야 하지만 그러지 말고 다시 재접속하라는 의미
		//클라이언트로 안가고 서버단에서 메인페이지로 다시 접속하라는 의미
		return "redirect:/";
	}
	
	//회원탈퇴
	@RequestMapping(value = "/user/userDrop")
	public String userDrop(HttpServletRequest request, HttpServletResponse response)
	{
		return "/user/userDrop";
	}
	
	//회원탈퇴proc
	@RequestMapping(value="/user/dropProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> dropProc(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String userId = HttpUtil.get(request, "userId");
		String status = HttpUtil.get(request, "status");
		
		if(!StringUtil.isEmpty(cookieUserId))
		{
			User user = userService.userSelect(cookieUserId);
			
			//User 비어있지 않으면
			if(user != null)
			{
					//쿠키아이디와 사용자아이가 같으면
					if(StringUtil.equals(cookieUserId, user.getUserId()))
					{
						
						if(userService.userDrop(user) > 0)
						{
							ajaxResponse.setResponse(0,"Success");
							CookieUtil.deleteCookie(request, response,"/", AUTH_COOKIE_NAME);
						}
						else
						{
							ajaxResponse.setResponse(500, "Internal Sever error");	//서버에서 에러 발생
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
	
	//회원가입form 이동
	@RequestMapping(value="/user/userRegForm")
	public String userRegForm(HttpServletRequest request, HttpServletResponse response) {
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);

		if(StringUtil.isEmpty(cookieUserId)) {
			return "/user/userRegForm";
		}
		else {
			CookieUtil.deleteCookie(request, response,"/" ,AUTH_COOKIE_NAME);
			return "redirect:/";
		}
	}
		
	//회원가입 아이디 중복 확인
	@RequestMapping(value="/user/idCheck", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> idCheck(HttpServletRequest request, HttpServletResponse response){
		Response<Object> res = new Response<Object>();
		
		String userId = HttpUtil.get(request, "userId");
		
		if(!StringUtil.isEmpty(userId)) {
			User user = userService.userSelect(userId);
			
			if(user != null) {
				res.setResponse(100, "중복된 아이디");
			}
			else {
				res.setResponse(1, "사용가능한 아이디");
			}
		}
		else {
			res.setResponse(400, "아이디 미 입력");
		}
		
		if(logger.isDebugEnabled()){
			logger.debug("[UserController] /user/idCheck response\n" + JsonUtil.toJsonPretty(res));
		}
		
		return res;
	}
		
	//회원가입 닉네임 중복 확인
	@RequestMapping(value="/user/nickCheck", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> nickCheck(HttpServletRequest request, HttpServletResponse response){
		Response<Object> res = new Response<Object>();
		
		String userNick = HttpUtil.get(request, "userNick");
		
		if(!StringUtil.isEmpty(userNick)) {
			User user = userService.userNickSelect(userNick);
			
			if(user != null) {
				res.setResponse(100, "중복된 닉네임");
			}
			else {
				res.setResponse(1, "사용가능한 닉네임");
			}
		}
		else {
			res.setResponse(400, "닉네임 미입력");
		}
		
		if(logger.isDebugEnabled()){
			logger.debug("[UserController] /user/nickCheck response\n" + JsonUtil.toJsonPretty(res));
		}
		
		return res;		
	}
		
	//회원가입 insert
	@RequestMapping(value="/user/userRegProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> userRegProc(HttpServletRequest request, HttpServletResponse response){
		Response<Object> res = new Response<Object>();
		
		String userId = HttpUtil.get(request, "userId");		//아이디
		String userPwd = HttpUtil.get(request, "userPwd");		//비밀번호
		String userNick = HttpUtil.get(request, "userNick");	//닉네임
		String userEmail = HttpUtil.get(request, "userEmail");	//이메일
		String userName = HttpUtil.get(request, "userName");	//이름
		String userPhone = HttpUtil.get(request, "userPhone");	//전화번호
		
		String postCode = HttpUtil.get(request, "postCode");	//
		String address = HttpUtil.get(request, "address");		//지번 주소 상세 정보
		
		String userAddr = "";
		
		if(!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd) &&!StringUtil.isEmpty(userNick) &&!StringUtil.isEmpty(userEmail) 
			&&!StringUtil.isEmpty(userName) && !StringUtil.isEmpty(userPhone) && !StringUtil.isEmpty(postCode) && !StringUtil.isEmpty(address)) {
			
			logger.debug("userAddr: " + userAddr);
			logger.debug("userPwd: " + userPwd);
			logger.debug("postCode: " + postCode);
			logger.debug("userAddr: " + userAddr);
			
			User user = new User();
			
			user.setUserId(userId);
			user.setUserPwd(userPwd);
			user.setUserNick(userNick);
			user.setUserEmail(userEmail);
			user.setUserName(userName);
			user.setUserPhone(userPhone);
			user.setUserAddr(address);
			user.setUserPostcode(postCode);
			
			if(userService.userRegInsert(user) > 0) {
				res.setResponse(1, "insert성공");
			}
			else {
				res.setResponse(404, "insert오류");
			}
		}
		else {
			res.setResponse(400, "파라미터 값 부족");
		}
		
		return res;
	}
	
	// 회원정보수정 폼
	@RequestMapping(value="/user/userUpdate")
	public String updateForm(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		User user = userService.userSelect(cookieUserId);
		
		model.addAttribute("user", user); 	
		
		return "/user/userUpdate";
	}
		
		
	//회원정보 수정
	@RequestMapping(value="/user/updateProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> updateProc(HttpServletRequest request, HttpServletResponse response)
	{
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		String userPwd = HttpUtil.get(request, "userPwd");
		String userName = HttpUtil.get(request, "userName");
		String userPhone = HttpUtil.get(request, "userPhone");
		String userAddr = HttpUtil.get(request, "userAddr");
		String userEmail = HttpUtil.get(request, "userEmail");
		String userPostcode = HttpUtil.get(request, "userPostcode");
		
		Response<Object> ajaxResponse = new Response<Object>();
		
		if(!StringUtil.isEmpty(cookieUserId))
		{
			User user = userService.userSelect(cookieUserId);
			
			if(user != null)
			{
				if(!StringUtil.isEmpty(userPwd) && !StringUtil.isEmpty(userName) && 
						!StringUtil.isEmpty(userPhone) && !StringUtil.isEmpty(userAddr) && !StringUtil.isEmpty(userEmail))
				{
					user.setUserPwd(userPwd);
					user.setUserName(userName);
					user.setUserPhone(userPhone);
					user.setUserAddr(userAddr);
					user.setUserEmail(userEmail);
					user.setUserPostcode(userPostcode);
					
					if(userService.userUpdate(user) > 0)
					{
						ajaxResponse.setResponse(0, "success");
					}
					else
					{
						ajaxResponse.setResponse(500, "Server error");
					}
				}
				else
				{
					ajaxResponse.setResponse(400, "Bad Request");
				}
			}
			else
			{
				CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
				ajaxResponse.setResponse(404, "Not Found");
			}
		}
		else
		{
			ajaxResponse.setResponse(400, "Bad Request");
		}
		
		if(logger.isDebugEnabled())
		{
			logger.debug("[UserController]/user/updateProc response\n" + JsonUtil.toJsonPretty(ajaxResponse));
		}
		
		return ajaxResponse;
	}
	
	@RequestMapping(value="/user/rechargePoints")
	public String test(ModelMap model,HttpServletRequest request,HttpServletResponse response)
	{
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		User user = userService.userSelect(cookieUserId);
		
		model.addAttribute("user", user); 
		return"/user/rechargePoints";
	}
	@RequestMapping(value = "/user/pointProc", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> pointProc(HttpServletRequest request, HttpServletResponse response) {
	    Response<Object> ajaxResponse = new Response<Object>();
	    
	    String userId = HttpUtil.get(request, "userId", "");
	    long orderTotalPrice = HttpUtil.get(request, "orderTotalPrice", (long) 0);
	    long amount = HttpUtil.get(request, "amount", (long) 0);
	    long orderTotalQuantity = HttpUtil.get(request, "orderTotalQuantity", (long) 0);
		int itemCode = HttpUtil.get(request, "itemCode", 0);
	    logger.debug("userId: " + userId);
	    logger.debug("orderTotalPrice: " + orderTotalPrice);
	    logger.debug("orderTotalQuantity: " + orderTotalQuantity);
     
		Order order = new Order();
	    int orderNo = orderService.orderSeq(order);
	    order.setUserId(userId);
	    order.setOrderTotalPrice(amount);
	    order.setOrderTotalQuantity(orderTotalQuantity);
	    order.setOrderNo(orderNo);

		logger.debug("========================================");
		logger.debug("orderNo : " + orderNo);
		logger.debug("========================================");
	    
		if (orderService.orderDirectInsert(order) > 0) 
        {
			OrderDetail orderDetail = new OrderDetail();
            orderDetail.setUserId(order.getUserId());
            orderDetail.setOrderNo(order.getOrderNo());
            orderDetail.setProductSeq(itemCode);
            orderDetail.setOrderDetailQuantity(1);
            orderDetail.setOrderDetailPrice(amount);
			if (orderService.orderDetailInsert(orderDetail) > 0) 
	        {
	            Pay pay = new Pay();
	            pay.setOrderNo(orderNo);
	            pay.setUserId(userId);
	            pay.setPayTotalPrice(amount);
	            pay.setPayPointPrice(0);
	            pay.setPayRealPrice(amount);
	            if(orderService.payInsert(pay)>0)
	            {
//	            	User user = new User();            	
//	            	user.setUserCharge(orderTotalPrice);
//	            	user.setUserId(userId);
//	            	if(orderService.userChargeUpdate(user)>0)
//	            	{
		        		String orderId = String.valueOf(orderNo);
		        		String itemName = HttpUtil.get(request,"itemName","");
		        		int taxFreeAmount = HttpUtil.get(request, "taxFreeAmount",(int)0);
		        		int vatAmount = HttpUtil.get(request, "vatAmount",(int)0);
		        		String gubunCheck=HttpUtil.get(request,"gubunCheck","");
		        		logger.debug("========================================");
		        		logger.debug("11111111111111111111111!!");
		        		logger.debug("========================================");
		        		KakaoPayOrder kakaoPayOrder = new KakaoPayOrder();
		        		
		        		kakaoPayOrder.setPartnerOrderId(orderId);
		        		kakaoPayOrder.setPartnerUserId(userId);
		        		kakaoPayOrder.setItemCode(String.valueOf(itemCode));
		        		kakaoPayOrder.setItemName(itemName);
		        		kakaoPayOrder.setQuantity(1);
		        		kakaoPayOrder.setTotalAmount((int)amount);
		        		kakaoPayOrder.setTaxFreeAmount(taxFreeAmount);
		        		kakaoPayOrder.setVatAmount(vatAmount);
		        		kakaoPayOrder.setGubunCheck(gubunCheck);
		        		
		        		KakaoPayReady kakaoPayReady = orderService.kakaoPayReady(kakaoPayOrder);
		        		
		        		if(kakaoPayReady != null)
		        		{logger.debug("========================================");
		        		logger.debug("22222222222222222222");
		        		logger.debug("========================================");
		        			logger.debug("[userController]payReady :"+ kakaoPayReady );
		        			kakaoPayOrder.setTid(kakaoPayReady.getTid());		//서비스에도 있음. 
		        			JsonObject json = new JsonObject();
		        			
		        			json.addProperty("orderId", orderId);
		        			json.addProperty("tId",kakaoPayReady.getTid());
		        			json.addProperty("appUrl",kakaoPayReady.getNext_redirect_app_url());
		        			json.addProperty("mobileUrl",kakaoPayReady.getNext_redirect_mobile_url());
		        			json.addProperty("pcUrl",kakaoPayReady.getNext_redirect_pc_url());
		        			json.addProperty("gubunCheck", kakaoPayReady.getGubunCheck());
		        			logger.debug("========================================");
			        		logger.debug("orderId",orderId);
			        		logger.debug("tId",kakaoPayReady.getTid());
			        		logger.debug("pcUrl",kakaoPayReady.getNext_redirect_pc_url());
			        		logger.debug("========================================");
		        			ajaxResponse.setResponse(0, "success",json);
//		        		}
//		        		else 
//		        		{
//		        			ajaxResponse.setResponse(-1,"kakaoPay faill");
//		        		}
		
			        }
	            	else 
	        		{
	        			ajaxResponse.setResponse(100,"kakaoPay fail");
	        		}
		        } 
	            else
		        {
		        	ajaxResponse.setResponse(200, "Failed to insert pay");
		        }
	        }
			else 
	        {
	            ajaxResponse.setResponse(300, "Failed to insert orderDetail");
	        }
		}
        else
        {
	        ajaxResponse.setResponse(400, "Failed to insert order");
	    }
	    return ajaxResponse;
	}
	@RequestMapping(value="/user/userPointUpdate")
	@ResponseBody
	public Response<Object> userPointUpdate(ModelMap model, HttpServletRequest request, HttpServletResponse response) 
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String orderId = HttpUtil.get(request, "orderId","");
		String userId = CookieUtil.getHexValue(request,AUTH_COOKIE_NAME);
		long amount = HttpUtil.get(request,"amount",(long) 0);
		logger.debug("=======================================");		
		logger.debug("orderId  :"+orderId);
		logger.debug("amount  :"+amount);
		logger.debug("=======================================");
		
		Order order = new Order();
		order.setOrderNo(Integer.parseInt(orderId));
		if(orderService.orderStatusUpdate(Integer.parseInt(orderId))>0)
		{
			Pay pay = new Pay();
			pay.setOrderNo(Integer.parseInt(orderId));
			if(orderService.payStatusUpdate(Integer.parseInt(orderId))>0)
			{
				User user = new User();            	
            	user = userService.userSelect(userId);    
            	long totalAmount = user.getUserCharge() + (int)amount;
            	user.setUserCharge(totalAmount);
            	logger.debug("=======================================");
            	logger.debug("totalAmount :"+totalAmount);
        		logger.debug("UserCharge :"+user.getUserCharge());
        		logger.debug("=======================================");
            	if(orderService.userChargeUpdate(user)>0)
            	{
			       ajaxResponse.setResponse(0,"success");
			    }
				else
				{
					ajaxResponse.setResponse(100, "cart delete fail");
				}
			}
			else
			{
				ajaxResponse.setResponse(200, "pay Update fail");
			}
		}
		else
		{
			ajaxResponse.setResponse(200, "order Update fail");
		}
		
		return ajaxResponse;
	}
	@RequestMapping(value="/user/userFeeUpdate")
	@ResponseBody
	public Response<Object> userFeeUpdate(ModelMap model, HttpServletRequest request, HttpServletResponse response) 
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String orderId = HttpUtil.get(request, "orderId","");
		String userId = CookieUtil.getHexValue(request,AUTH_COOKIE_NAME);
		logger.debug("=======================================");		
		logger.debug("orderId  :"+orderId);
		logger.debug("=======================================");
		
		Order order = new Order();
		order.setOrderNo(Integer.parseInt(orderId));
		if(orderService.orderStatusUpdate(Integer.parseInt(orderId))>0)
		{
			Pay pay = new Pay();
			pay.setOrderNo(Integer.parseInt(orderId));
			if(orderService.payStatusUpdate(Integer.parseInt(orderId))>0)
			{
            	if(userService.userFeeUpdate(userId)>0)
            	{
			       ajaxResponse.setResponse(0,"success");
			    }
				else
				{
					ajaxResponse.setResponse(100, "cart delete fail");
				}
			}
			else
			{
				ajaxResponse.setResponse(200, "pay Update fail");
			}
		}
		else
		{
			ajaxResponse.setResponse(200, "order Update fail");
		}
		
		return ajaxResponse;
	}
	
}
