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

import com.google.gson.JsonObject;
import com.icia.web.model.Cart;
import com.icia.web.model.KakaoPayApprove;
import com.icia.web.model.KakaoPayOrder;
import com.icia.web.model.KakaoPayReady;
import com.icia.web.model.Order;
import com.icia.web.model.OrderDetail;
import com.icia.web.model.Pay;
import com.icia.web.model.Product;
import com.icia.web.model.Response;
import com.icia.web.model.User;
import com.icia.web.service.OrderService;
import com.icia.web.service.ProductService;
import com.icia.web.util.CookieUtil;
import com.icia.web.util.HttpUtil;

@Controller("OrderController")
public class OrderController {
	private static Logger logger = LoggerFactory.getLogger(OrderController.class);
	
	//쿠키명
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	@Autowired
	private OrderService orderService;
	
	@Autowired
	ProductService productService;


	@RequestMapping(value = "/product/orderProc", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> orderProc(HttpServletRequest request, HttpServletResponse response) {
	    Response<Object> ajaxResponse = new Response<Object>();
	    
	    String userId = HttpUtil.get(request, "userId", "");
	    long orderTotalPrice = HttpUtil.get(request, "orderTotalPrice", (long)0);
	    long orderTotalQuantity = HttpUtil.get(request, "orderTotalQuantity", (long) 0);
	    long payTotalPrice = HttpUtil.get(request, "payTotalPrice", (long) 0);
		long payPointPrice = HttpUtil.get(request, "payPointPrice", (long) 0);
		long userCharge = HttpUtil.get(request, "userCharge", (long) 0);
		 
	    logger.debug("userId: " + userId);
	    logger.debug("orderTotalPrice: " + orderTotalPrice);
	    logger.debug("orderTotalQuantity: " + orderTotalQuantity);
	    logger.debug("payTotalPrice: " + payTotalPrice);
	    logger.debug("payPointPrice: " + payPointPrice);
	    logger.debug("userCharge: " + userCharge);
	  if(orderTotalPrice == 0)
	  {
	   try {     
	       
	        Order order = new Order();
	        int orderNo = orderService.orderSeq(order);
	        order.setUserId(userId);
	        order.setOrderTotalPrice(orderTotalPrice);
	        order.setOrderTotalQuantity(orderTotalQuantity);
	        order.setOrderNo(orderNo);
	
			logger.debug("========================================");
			logger.debug("orderNo111111 : " + orderNo);
			logger.debug("========================================");
		    
			if (orderService.orderInsert(order) > 0) 
	        {
	            Pay pay = new Pay();
	            pay.setOrderNo(orderNo);
	            pay.setUserId(userId);
	            pay.setPayTotalPrice(payTotalPrice);
	            pay.setPayPointPrice(payPointPrice);
	            pay.setPayRealPrice(orderTotalPrice);
	            if(orderService.payInsert(pay)>0)
	            {
	            	User user = new User();            	
	            	user.setUserCharge(userCharge);
	            	user.setUserId(userId);
	            	if(orderService.userChargeUpdate(user)>0)
	            	{
	            		
	            		ajaxResponse.setResponse(1,"orderNo",orderNo);
	            	}
	            	else 
	        		{
	        			ajaxResponse.setResponse(400,"userChargeUpdate fail");
	        		}
		        } 
	            else
		        {
		        	ajaxResponse.setResponse(500, "Failed to insert pay");
		        }
	        }
			else 
	        {
	            ajaxResponse.setResponse(600, "Failed to insert order");
	        }
		}
        catch (Exception e) 
        {
	        logger.error("Order processing error:", e);
	        ajaxResponse.setResponse(404, "error");
	    }
	  }
	  else
	  {
		  try {     
		       
		        Order order = new Order();
		        int orderNo = orderService.orderSeq(order);
		        order.setUserId(userId);
		        order.setOrderTotalPrice(orderTotalPrice);
		        order.setOrderTotalQuantity(orderTotalQuantity);
		        order.setOrderNo(orderNo);
		
				logger.debug("========================================");
				logger.debug("orderNo : " + orderNo);
				logger.debug("========================================");
			    
				if (orderService.orderInsert(order) > 0) 
		        {
		            Pay pay = new Pay();
		            pay.setOrderNo(orderNo);
		            pay.setUserId(userId);
		            pay.setPayTotalPrice(payTotalPrice);
		            pay.setPayPointPrice(payPointPrice);
		            pay.setPayRealPrice(orderTotalPrice);
		            if(orderService.payInsert(pay)>0)
		            {
		            	User user = new User();            	
		            	user.setUserCharge(userCharge);
		            	user.setUserId(userId);
		            	if(orderService.userChargeUpdate(user)>0)
		            	{
			        		String orderId = String.valueOf(orderNo);
			        		String itemName = HttpUtil.get(request,"itemName","");
			        		String itemCode = HttpUtil.get(request, "itemCode","");
			        		int totalAmount = HttpUtil.get(request, "totalAmount",(int)0);
			        		int taxFreeAmount = HttpUtil.get(request, "taxFreeAmount",(int)0);
			        		int vatAmount = HttpUtil.get(request, "vatAmount",(int)0);
			        		logger.debug("========================================");
			        		logger.debug("11111111111111111111111!!");
			        		logger.debug("========================================");
			        		KakaoPayOrder kakaoPayOrder = new KakaoPayOrder();
			        		
			        		kakaoPayOrder.setPartnerOrderId(orderId);
			        		kakaoPayOrder.setPartnerUserId(userId);
			        		kakaoPayOrder.setItemCode(itemCode);
			        		kakaoPayOrder.setItemName(itemName);
			        		kakaoPayOrder.setQuantity((int)orderTotalQuantity);
			        		kakaoPayOrder.setTotalAmount(totalAmount);
			        		kakaoPayOrder.setTaxFreeAmount(taxFreeAmount);
			        		kakaoPayOrder.setVatAmount(vatAmount);
			        		
			        		KakaoPayReady kakaoPayReady = orderService.kakaoPayReady(kakaoPayOrder);
			        		
			        		if(kakaoPayReady != null)
			        		{logger.debug("========================================");
			        		logger.debug("22222222222222222222");
			        		logger.debug("========================================");
			        			logger.debug("[OrderController]payReady :"+ kakaoPayReady );
			        			kakaoPayOrder.setTid(kakaoPayReady.getTid());		//서비스에도 있음. 
			        			JsonObject json = new JsonObject();
			        			
			        			json.addProperty("orderId", orderId);
			        			json.addProperty("tId",kakaoPayReady.getTid());
			        			json.addProperty("appUrl",kakaoPayReady.getNext_redirect_app_url());
			        			json.addProperty("mobileUrl",kakaoPayReady.getNext_redirect_mobile_url());
			        			json.addProperty("pcUrl",kakaoPayReady.getNext_redirect_pc_url());
			        			
			        			ajaxResponse.setResponse(0, "success",json);
			        		}
			        		else 
			        		{
			        			ajaxResponse.setResponse(-1,"kakaoPay faill");
			        		}
			
				        }
		            	else 
		        		{
		        			ajaxResponse.setResponse(400, "userChargeUpdate fail");
		        		}
			        } 
		            else
			        {
			        	ajaxResponse.setResponse(500, "pay insert fail");
			        }
		        }
				else 
		        {
		            ajaxResponse.setResponse(600, "Failed to insert order");
		        }
			}
	        catch (Exception e) 
	        {
		        logger.error("Order processing error:", e);
		        ajaxResponse.setResponse(404, "error");
		    }
	  }

	    return ajaxResponse;
	}
	@RequestMapping(value = "/product/orderDirectProc", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> orderDirectProc(HttpServletRequest request, HttpServletResponse response) {
	    Response<Object> ajaxResponse = new Response<Object>();
	    
	    String userId = HttpUtil.get(request, "userId", "");
	    long orderTotalPrice = HttpUtil.get(request, "orderTotalPrice", (long) 0);
	    long payTotalPrice = HttpUtil.get(request, "payTotalPrice", (long) 0);
		long payPointPrice = HttpUtil.get(request, "payPointPrice", (long) 0);
		long userCharge = HttpUtil.get(request, "userCharge", (long) 0);
		String itemName = HttpUtil.get(request,"itemName","");
		String itemCode = HttpUtil.get(request, "itemCode","");
		long itemPrice = HttpUtil.get(request,"itemPrice",(long)0);
		int quantity = HttpUtil.get(request, "quantity", (int)0);
		int taxFreeAmount = HttpUtil.get(request, "taxFreeAmount",(int)0);
		int vatAmount = HttpUtil.get(request, "vatAmount",(int)0); 
	    logger.debug("userId: " + userId);
	    logger.debug("orderTotalPrice: " + orderTotalPrice);
	    logger.debug("payTotalPrice: " + payTotalPrice);
	    logger.debug("payPointPrice: " + payPointPrice);
	    logger.debug("userCharge: " + userCharge);

      
       
        Order order = new Order();
        int orderNo = orderService.orderSeq(order);
        order.setUserId(userId);
        order.setOrderTotalPrice(orderTotalPrice);
        order.setOrderTotalQuantity(quantity);
        order.setOrderNo(orderNo);
        if(orderTotalPrice == 0)
	  	{

	        if (orderService.orderDirectInsert(order) > 0) 
	        {
				logger.debug("========================================");
				logger.debug("orderNo11111 : " + orderNo);
				logger.debug("========================================");
				OrderDetail orderDetail = new OrderDetail();
	            orderDetail.setUserId(order.getUserId());
	            orderDetail.setOrderNo(order.getOrderNo());
	            orderDetail.setProductSeq(Integer.parseInt(itemCode));
	            orderDetail.setOrderDetailQuantity(quantity);
	            orderDetail.setOrderDetailPrice(itemPrice);
				if (orderService.orderDetailInsert(orderDetail) > 0) 
		        {
		            Pay pay = new Pay();
		            pay.setOrderNo(orderNo);
		            pay.setUserId(userId);
		            pay.setPayTotalPrice(payTotalPrice);
		            pay.setPayPointPrice(payPointPrice);
		            pay.setPayRealPrice(orderTotalPrice);
		            if(orderService.payInsert(pay)>0)
		            {
		            	User user = new User();            	
		            	user.setUserCharge(userCharge);
		            	user.setUserId(userId);
		            	if(orderService.userChargeUpdate(user)>0)
		            	{
			        		ajaxResponse.setResponse(1, "orderNo",order.getOrderNo());
			
				        }
		            	else 
		        		{
		        			ajaxResponse.setResponse(400, "userChargeUpdate fail");
		        		}
			        } 
		            else
			        {
			        	ajaxResponse.setResponse(500, "pay insert fail");
			        }
		        }
				else 
		        {
		            ajaxResponse.setResponse(600, "Failed to insert orderDetail");
		        }
			}
	        else
	        {
		        
		        ajaxResponse.setResponse(404, "Failed to insert order");
		    }
	  	}
        else
        {
	        if (orderService.orderDirectInsert(order) > 0) 
	        {
				logger.debug("========================================");
				logger.debug("orderNo : " + orderNo);
				logger.debug("========================================");
				OrderDetail orderDetail = new OrderDetail();
	            orderDetail.setUserId(order.getUserId());
	            orderDetail.setOrderNo(order.getOrderNo());
	            orderDetail.setProductSeq(Integer.parseInt(itemCode));
	            orderDetail.setOrderDetailQuantity(quantity);
	            orderDetail.setOrderDetailPrice(itemPrice);
				if (orderService.orderDetailInsert(orderDetail) > 0) 
		        {
		            Pay pay = new Pay();
		            pay.setOrderNo(orderNo);
		            pay.setUserId(userId);
		            pay.setPayTotalPrice(payTotalPrice);
		            pay.setPayPointPrice(payPointPrice);
		            pay.setPayRealPrice(orderTotalPrice);
		            if(orderService.payInsert(pay)>0)
		            {
		            	User user = new User();            	
		            	user.setUserCharge(userCharge);
		            	user.setUserId(userId);
		            	if(orderService.userChargeUpdate(user)>0)
		            	{
			        		String orderId = String.valueOf(orderNo);
			        		logger.debug("========================================");
			        		logger.debug("11111111111111111111111!!");
			        		logger.debug("========================================");
			        		KakaoPayOrder kakaoPayOrder = new KakaoPayOrder();
			        		
			        		kakaoPayOrder.setPartnerOrderId(orderId);
			        		kakaoPayOrder.setPartnerUserId(userId);
			        		kakaoPayOrder.setItemCode(itemCode);
			        		kakaoPayOrder.setItemName(itemName);
			        		kakaoPayOrder.setQuantity(quantity);
			        		kakaoPayOrder.setTotalAmount((int)orderTotalPrice);
			        		kakaoPayOrder.setTaxFreeAmount(taxFreeAmount);
			        		kakaoPayOrder.setVatAmount(vatAmount);
			        		
			        		KakaoPayReady kakaoPayReady = orderService.kakaoPayReady1(kakaoPayOrder);
			        		
			        		if(kakaoPayReady != null)
			        		{logger.debug("========================================");
			        		logger.debug("22222222222222222222");
			        		logger.debug("========================================");
			        			logger.debug("[OrderController]payReady :"+ kakaoPayReady );
			        			kakaoPayOrder.setTid(kakaoPayReady.getTid());		//서비스에도 있음. 
			        			JsonObject json = new JsonObject();
			        			
			        			json.addProperty("orderId", orderId);
			        			json.addProperty("tId",kakaoPayReady.getTid());
			        			json.addProperty("appUrl",kakaoPayReady.getNext_redirect_app_url());
			        			json.addProperty("mobileUrl",kakaoPayReady.getNext_redirect_mobile_url());
			        			json.addProperty("pcUrl",kakaoPayReady.getNext_redirect_pc_url());
			        			
			        			ajaxResponse.setResponse(0, "success",json);
			        		}
			        		else 
			        		{
			        			ajaxResponse.setResponse(-1,"kakaoPay faill");
			        		}
			
				        }
		            	else 
		        		{
		        			ajaxResponse.setResponse(400, "userChargeUpdate fail");
		        		}
			        } 
		            else
			        {
			        	ajaxResponse.setResponse(500, "pay insert fail");
			        }
		        }
				else 
		        {
		            ajaxResponse.setResponse(600, "Failed to insert orderDetail");
		        }
			}
	        else
	        {
		        
		        ajaxResponse.setResponse(404, "Failed to insert order");
		    }
        }

	    return ajaxResponse;
	}
	@RequestMapping(value="/kakao/payPopUp", method=RequestMethod.POST)
	public String payPopUp(ModelMap model, HttpServletRequest request,HttpServletResponse response)
	{
		String pcUrl = HttpUtil.get(request, "pcUrl","");
		String orderId = HttpUtil.get(request,"orderId","");
		String tId = HttpUtil.get(request, "tId","");
		String userId = CookieUtil.getHexValue(request,AUTH_COOKIE_NAME);
		String gubunCheck = HttpUtil.get(request, "gubunCheck","");
		
		logger.debug("=======================================");
		logger.debug("gubunCheck :"+gubunCheck);
		logger.debug("=======================================");
		
		model.addAttribute("pcUrl",pcUrl);
		model.addAttribute("orderId",orderId);
		model.addAttribute("tId",tId);
		model.addAttribute("userId",userId);
		model.addAttribute("gubunCheck",gubunCheck);
		
		return "/kakao/payPopUp";
	}
	@RequestMapping(value="/kakao/directPayPopUp", method=RequestMethod.POST)
	public String directPayPopUp(ModelMap model, HttpServletRequest request,HttpServletResponse response)
	{
		String pcUrl = HttpUtil.get(request, "pcUrl","");
		String orderId = HttpUtil.get(request,"orderId","");
		String tId = HttpUtil.get(request, "tId","");
		String userId = CookieUtil.getHexValue(request,AUTH_COOKIE_NAME);
		
		model.addAttribute("pcUrl",pcUrl);
		model.addAttribute("orderId",orderId);
		model.addAttribute("tId",tId);
		model.addAttribute("userId",userId);
		
		return "/kakao/directPayPopUp";
	}
	@RequestMapping(value="kakao/paySuccess")
	public String paySuccess(ModelMap model,HttpServletRequest request, HttpServletResponse response)
	{
		String pgToken = HttpUtil.get(request, "pg_token","");
		String gubunCheck = HttpUtil.get(request, "gubunCheck","");
		
		logger.debug("=======================================");
		logger.debug("gubunCheck :"+gubunCheck);
		logger.debug("=======================================");
		
		model.addAttribute("gubunCheck",gubunCheck);
		model.addAttribute("pgToken",pgToken);
		return "/kakao/paySuccess";
	}
	@RequestMapping(value="kakao/directPaySuccess")
	public String directPaySuccess(ModelMap model,HttpServletRequest request, HttpServletResponse response)
	{
		String pgToken = HttpUtil.get(request, "pg_token","");
		
		model.addAttribute("pgToken",pgToken);
		return "/kakao/directPaySuccess";
	}
	@RequestMapping(value="/kakao/payResult")
	public String payResult(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		KakaoPayApprove kakaoPayApprove = null;
		
		String tId = HttpUtil.get(request, "tId","");
		String orderId = HttpUtil.get(request, "orderId","");
		String userId = CookieUtil.getHexValue(request,AUTH_COOKIE_NAME);
		String pgToken = HttpUtil.get(request, "pgToken","");
		String itemName = HttpUtil.get(request,"itemName","");
		String gubunCheck = HttpUtil.get(request, "gubunCheck","");
		
		logger.debug("=======================================");
		logger.debug("tId :"+tId);
		logger.debug("orderId  :"+orderId);
		logger.debug("userId :"+userId);
		logger.debug("gubunCheck :"+gubunCheck);
		logger.debug("=======================================");
		
		KakaoPayOrder kakaoPayOrder = new KakaoPayOrder();
		
		kakaoPayOrder.setTid(tId);
		kakaoPayOrder.setPartnerOrderId(orderId);
		kakaoPayOrder.setPartnerUserId(userId);
		kakaoPayOrder.setPgToken(pgToken);
		kakaoPayOrder.setItemName(itemName);
		kakaoPayOrder.setGubunCheck(gubunCheck);
		
		kakaoPayApprove = orderService.kakaoPayApprove(kakaoPayOrder);
		
		model.addAttribute("kakaoPayApprove",kakaoPayApprove);
		model.addAttribute("gubunCheck",gubunCheck);
		
		return "/kakao/payResult";
	}
	@RequestMapping(value="/kakao/directPayResult")
	public String directPayResult(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		KakaoPayApprove kakaoPayApprove = null;
		
		String tId = HttpUtil.get(request, "tId","");
		String orderId = HttpUtil.get(request, "orderId","");
		String userId = CookieUtil.getHexValue(request,AUTH_COOKIE_NAME);
		String pgToken = HttpUtil.get(request, "pgToken","");
		String itemName = HttpUtil.get(request,"itemName","");
		
		logger.debug("=======================================");
		logger.debug("tId :"+tId);
		logger.debug("orderId  :"+orderId);
		logger.debug("userId :"+userId);
		logger.debug("=======================================");
		
		KakaoPayOrder kakaoPayOrder = new KakaoPayOrder();
		
		kakaoPayOrder.setTid(tId);
		kakaoPayOrder.setPartnerOrderId(orderId);
		kakaoPayOrder.setPartnerUserId(userId);
		kakaoPayOrder.setPgToken(pgToken);
		kakaoPayOrder.setItemName(itemName);
		
		kakaoPayApprove = orderService.kakaoPayApprove(kakaoPayOrder);
		
		model.addAttribute("kakaoPayApprove",kakaoPayApprove);
		
		return "/kakao/directPayResult";
	}
	@RequestMapping(value="/kakao/payUpdate")
	@ResponseBody
	public Response<Object> payUpdate(ModelMap model, HttpServletRequest request, HttpServletResponse response) 
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
				Cart cart = new Cart();
				cart.setUserId(userId);
				if(orderService.cartOrderDelete(cart.getUserId())>0)
				{
					 List<Product> list = orderService.selectProductQuan(Integer.parseInt(orderId));
					 if (!list.isEmpty()) 
			         {	            
			             for (Product productSeq : list) 
			             {
			            	 Product product = new Product();
			            	 long productQuan = (productSeq.getProductQuantity() - productSeq.getOrderDetailQuantity());
			            	 product.setProductQuantity(productQuan);
			            	 product.setProductSeq(productSeq.getProductSeq());
			            	 logger.debug("=======================================");
			         		 logger.debug("productQuan :"+productQuan);
			         		 logger.debug(" product.setProductQuantity  :"+ product.getProductQuantity());
			         		 logger.debug(" productSeq.getOrderDetailQuantity()  :"+ productSeq.getOrderDetailQuantity());
			         		 logger.debug(" productQuan  :"+ (productSeq.getProductQuantity() - productSeq.getOrderDetailQuantity()));
			         		 logger.debug("userId :"+userId);
			         		 logger.debug("=======================================");
			            	 if(orderService.productQuanUpdate(product)>0)
			            	 {
			            		 ajaxResponse.setResponse(0,"success");
			            	 }
			             }
			             
			         }
					 else 
		             {
		            	 ajaxResponse.setResponse(-1, "productQuan update fail");
		             }
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
	@RequestMapping(value="/kakao/directPayUpdate")
	@ResponseBody
	public Response<Object> directPayUpdate(ModelMap model, HttpServletRequest request, HttpServletResponse response) 
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String orderId = HttpUtil.get(request, "orderId","");
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
				List<Product> list = orderService.selectProductQuan(Integer.parseInt(orderId));
					 if (!list.isEmpty()) 
			         {	            
			             for (Product productSeq : list) 
			             {
			            	 Product product = new Product();
			            	 long productQuan = productSeq.getProductQuantity();
			            	 long orderDetail = productSeq.getOrderDetailQuantity();
			            	 long quantity = productQuan-orderDetail;
			            	 product.setProductQuantity(quantity);
			            	 product.setProductSeq(productSeq.getProductSeq());
			            	 logger.debug("=======================================");
			         		 logger.debug("productQuan :"+productQuan);
			         		logger.debug(" orderDetail  :", orderDetail);
			         		 logger.debug(" product.setProductQuantity  :"+ product.getProductQuantity());
			         		 logger.debug(" productSeq.getOrderDetailQuantity()  :"+ productSeq.getOrderDetailQuantity());
			         		 logger.debug(" quantity :"+ quantity);
			         		 logger.debug("=======================================");
			            	 if(orderService.productQuanUpdate(product)>0)
			            	 {
			            		 ajaxResponse.setResponse(0,"success");
			            	 }
			             }
			             
			         }
					 else 
		             {
		            	 ajaxResponse.setResponse(-1, "productQuan update fail");
		             }
			}
			else
			{
				ajaxResponse.setResponse(200, "pay Update fail");
			}
		}
		else
		{
			ajaxResponse.setResponse(300, "order Update fail");
		}
		
		return ajaxResponse;
	}
	@RequestMapping(value="/kakao/payCancel")
	public String payCancel(HttpServletRequest request,HttpServletResponse response)
	{
		return"/kakao/payCancel";
	}
	@RequestMapping(value="/kakao/payFail")
	public String payFail(HttpServletRequest request,HttpServletResponse response)
	{
		return"/kakao/payFail";
	}
	@RequestMapping(value="/kakao/directPayCancel")
	public String directPayCancel(HttpServletRequest request,HttpServletResponse response)
	{
		return"/kakao/directPayCancel";
	}
	@RequestMapping(value="/kakao/directPayFail")
	public String directPayFail(HttpServletRequest request,HttpServletResponse response)
	{
		return"/kakao/directPayFail";
	}
	
}
