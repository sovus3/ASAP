package com.icia.web.service;

import java.net.URI;
import java.net.URISyntaxException;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

import com.icia.web.dao.OrderDao;
import com.icia.web.dao.ProductDao;
import com.icia.web.model.Cart;
import com.icia.web.model.KakaoPayApprove;
import com.icia.web.model.KakaoPayOrder;
import com.icia.web.model.KakaoPayReady;
import com.icia.web.model.Order;
import com.icia.web.model.OrderDetail;
import com.icia.web.model.Pay;
import com.icia.web.model.Product;
import com.icia.web.model.User;

@Service("orderService")
public class OrderService {

	private static Logger logger = LoggerFactory.getLogger(VoteService.class);

	@Autowired
	OrderDao orderDao;

	@Autowired
	ProductDao productDao;

	// 카카오페이 호스트
	@Value("#{env['kakao.pay.host']}")
	private String KAKAO_PAY_HOST;

	// 카카오페이 관리자 키
	@Value("#{env['kakao.pay.admin.key']}")
	private String KAKAO_PAY_ADMIN_KEY;

	// 가맹점 코드 10자
	@Value("#{env['kakao.pay.cid']}")
	private String KAKAO_PAY_CID;

	// 결제 URL
	@Value("#{env['kakao.pay.ready.url']}")
	private String KAKAO_PAY_READY_URL;

	// 결제 요청 URL
	@Value("#{env['kakao.pay.approve.url']}")
	private String KAKAO_PAY_APPROVE_URL;

	// 결제 성공 URL
	@Value("#{env['kakao.pay.success.url']}")
	private String KAKAO_PAY_SUCCESS_URL;

	// 결제 취소 URL
	@Value("#{env['kakao.pay.cancel.url']}")
	private String KAKAO_PAY_CANCEL_URL;

	// 결제 실패 URL
	@Value("#{env['kakao.pay.fail.url']}")
	private String KAKAO_PAY_FAIL_URL;

	// 결제 성공 URL
	@Value("#{env['kakao.pay.success1.url']}")
	private String KAKAO_PAY_SUCCESS1_URL;

	// 결제 취소 URL
	@Value("#{env['kakao.pay.cancel1.url']}")
	private String KAKAO_PAY_CANCEL1_URL;

	// 결제 실패 URL
	@Value("#{env['kakao.pay.fail1.url']}")
	private String KAKAO_PAY_FAIL1_URL;

	public int orderSeq(Order order) {
		int count = 0;
		try {
			count = orderDao.orderSeq(order);
		} catch (Exception e) {
			logger.error("[orderService]  orderInsert Exception", e);
		}
		return count;
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int orderInsert(Order order) throws Exception {
		// 주문(Order)를 먼저 생성하고 저장합니다.

		int count = orderDao.orderInsert(order);

		if (count > 0) {
			List<Cart> list = productDao.cartList(order.getUserId());
			if (!list.isEmpty()) {
				for (Cart cartItem : list) {
					OrderDetail orderDetail = new OrderDetail();
					orderDetail.setUserId(order.getUserId());
					orderDetail.setOrderNo(order.getOrderNo());
					orderDetail.setProductSeq(cartItem.getProductSeq());
					orderDetail.setOrderDetailQuantity(cartItem.getCartQuantity());
					orderDetail.setOrderDetailPrice(cartItem.getCartPrice());
					logger.debug("========================================");
					logger.debug("cartItem.getProductSeq() : " + cartItem.getProductSeq());
					logger.debug("cartItem.getCartQuantity()) : " + cartItem.getCartQuantity());
					logger.debug("========================================");
					orderDao.orderDetailInsert(orderDetail);
				}
			}
		}

		return count;
	}

	public int orderDirectInsert(Order order) {
		int count = 0;

		try {
			count = orderDao.orderInsert(order);
		} catch (Exception e) {
			logger.error("[orderService]  orderInsert Exception", e);
		}
		return count;
	}

	public int orderDetailInsert(OrderDetail orderDetail) {
		int count = 0;

		try {
			count = orderDao.orderDetailInsert(orderDetail);
		} catch (Exception e) {
			logger.error("[orderService] orderDetailInsert Exception", e);
		}
		return count;
	}

	public Order orderSelect(String userId) {
		Order select = null;
		try {
			select = orderDao.orderSelect(userId);
		} catch (Exception e) {
			logger.error("[orderService] orderSelect Exception", e);
		}

		return select;
	}

	public int payInsert(Pay pay) {
		int count = 0;
		try {
			count = orderDao.payInsert(pay);
		} catch (Exception e) {
			logger.error("[orderService] payInsert Exception", e);
		}

		return count;
	}

	public int userChargeUpdate(User user) {
		int count = 0;
		try {
			count = orderDao.userChargeUpdate(user);
		} catch (Exception e) {
			logger.error("[orderService] userChargeUpdate Exception", e);
		}

		return count;
	}

	public long cartOrderDelete(String userId) {
		long count = 0;
		try {
			count = orderDao.cartOrderDelete(userId);
		} catch (Exception e) {
			logger.error("[orderService]  cartOrderDelete Exception", e);
		}
		return count;
	}

	public int orderStatusUpdate(int orderNo) {
		int count = 0;
		try {
			count = orderDao.orderStatusUpdate(orderNo);
		} catch (Exception e) {
			logger.error("[orderService] userChargeUpdate Exception", e);
		}

		return count;
	}

	public int payStatusUpdate(int orderNo) {
		int count = 0;
		try {
			count = orderDao.payStatusUpdate(orderNo);
		} catch (Exception e) {
			logger.error("[orderService] userChargeUpdate Exception", e);
		}

		return count;
	}

	public KakaoPayReady kakaoPayReady(KakaoPayOrder kakaoPayOrder) {
		KakaoPayReady kakaoPayReady = null;

		if (kakaoPayOrder != null) {
			// spring에서 지원하는 객체로 편하게 rest방식 API를 호출할 수 있는 spring 내장 클래스
			RestTemplate restTemplate = new RestTemplate();
			logger.debug("=======================================");
			logger.debug("[111111111111111111111111111");
			logger.debug("=======================================");
			// 서버로 요청할 header
			HttpHeaders headers = new HttpHeaders();
			headers.add("Authorization", "KakaoAK " + KAKAO_PAY_ADMIN_KEY);
			// Content-type: application/x-www-form-urlencoded;charset=utf-8
			headers.add("Content-type", MediaType.APPLICATION_FORM_URLENCODED_VALUE + ";charset=utf-8");

			// 서버로 요청할 body
			MultiValueMap<String, String> params = new LinkedMultiValueMap<String, String>();

			params.add("cid", KAKAO_PAY_CID);
			params.add("partner_order_id", kakaoPayOrder.getPartnerOrderId());
			params.add("partner_user_id", kakaoPayOrder.getPartnerUserId());
			params.add("item_name", kakaoPayOrder.getItemName());
			params.add("item_code", kakaoPayOrder.getItemCode());
			params.add("quantity", String.valueOf(kakaoPayOrder.getQuantity()));
			params.add("total_amount", String.valueOf(kakaoPayOrder.getTotalAmount()));
			params.add("tax_free_amount", String.valueOf(kakaoPayOrder.getTaxFreeAmount()));
			params.add("approval_url", KAKAO_PAY_SUCCESS_URL);
			params.add("cancel_url", KAKAO_PAY_CANCEL_URL);
			params.add("fail_url", KAKAO_PAY_FAIL_URL);
			// 요청하기위해 header와 body를 합치기
			// spring framework에서 제공해주는 HttpEntity클래스에서 header와 body를 합치기.
			HttpEntity<MultiValueMap<String, String>> body = new HttpEntity<MultiValueMap<String, String>>(params,headers);
			try {
				kakaoPayReady = restTemplate.postForObject(new URI(KAKAO_PAY_HOST + KAKAO_PAY_READY_URL), body,KakaoPayReady.class);

				if (kakaoPayReady != null) {
					kakaoPayOrder.setTid(kakaoPayReady.getTid());
					logger.debug("=======================================");
					logger.debug("[KakaoPayService] kakaoPayReady.getTid() :" + kakaoPayReady.getTid());
					logger.debug("[KakaoPayService] kakaoPayReady :" + kakaoPayReady);
					logger.debug("=======================================");
				}
			} catch (RestClientException e) {
				logger.error("[KakaoPayService] kakaoPayReady RestClientException", e);
			} catch (URISyntaxException e) {
				logger.error("[KakaoPayService] kakaoPayReady URISyntaxException", e);
			}
		} else {
			logger.error("[KakaoPayService] kakaoPayReady kakaoPayOrder is null");
		}

		return kakaoPayReady;
	}

	public KakaoPayReady kakaoPayReady1(KakaoPayOrder kakaoPayOrder) {
		KakaoPayReady kakaoPayReady1 = null;

		if (kakaoPayOrder != null) {
			// spring에서 지원하는 객체로 편하게 rest방식 API를 호출할 수 있는 spring 내장 클래스
			RestTemplate restTemplate = new RestTemplate();
			logger.debug("=======================================");
			logger.debug("[111111111111111111111111111");
			logger.debug("=======================================");
			// 서버로 요청할 header
			HttpHeaders headers = new HttpHeaders();
			headers.add("Authorization", "KakaoAK " + KAKAO_PAY_ADMIN_KEY);
			// Content-type: application/x-www-form-urlencoded;charset=utf-8
			headers.add("Content-type", MediaType.APPLICATION_FORM_URLENCODED_VALUE + ";charset=utf-8");

			// 서버로 요청할 body
			MultiValueMap<String, String> params = new LinkedMultiValueMap<String, String>();

			params.add("cid", KAKAO_PAY_CID);
			params.add("partner_order_id", kakaoPayOrder.getPartnerOrderId());
			params.add("partner_user_id", kakaoPayOrder.getPartnerUserId());
			params.add("item_name", kakaoPayOrder.getItemName());
			params.add("item_code", kakaoPayOrder.getItemCode());
			params.add("quantity", String.valueOf(kakaoPayOrder.getQuantity()));
			params.add("total_amount", String.valueOf(kakaoPayOrder.getTotalAmount()));
			params.add("tax_free_amount", String.valueOf(kakaoPayOrder.getTaxFreeAmount()));
			params.add("approval_url", KAKAO_PAY_SUCCESS1_URL);
			params.add("cancel_url", KAKAO_PAY_CANCEL1_URL);
			params.add("fail_url", KAKAO_PAY_FAIL1_URL);
			// 요청하기위해 header와 body를 합치기
			// spring framework에서 제공해주는 HttpEntity클래스에서 header와 body를 합치기.
			HttpEntity<MultiValueMap<String, String>> body = new HttpEntity<MultiValueMap<String, String>>(params,headers);
			try {
				kakaoPayReady1 = restTemplate.postForObject(new URI(KAKAO_PAY_HOST + KAKAO_PAY_READY_URL), body,KakaoPayReady.class);

				if (kakaoPayReady1 != null) {
					kakaoPayOrder.setTid(kakaoPayReady1.getTid());
					logger.debug("=======================================");
					logger.debug("[KakaoPayService] kakaoPayReady.getTid() :" + kakaoPayReady1.getTid());
					logger.debug("[KakaoPayService] kakaoPayReady :" + kakaoPayReady1);
					logger.debug("=======================================");
				}
			} catch (RestClientException e) {
				logger.error("[KakaoPayService] kakaoPayReady RestClientException", e);
			} catch (URISyntaxException e) {
				logger.error("[KakaoPayService] kakaoPayReady URISyntaxException", e);
			}
		} else {
			logger.error("[KakaoPayService] kakaoPayReady kakaoPayOrder is null");
		}

		return kakaoPayReady1;
	}

	public KakaoPayApprove kakaoPayApprove(KakaoPayOrder kakaoPayOrder) {
		KakaoPayApprove kakaoPayApprove = null;

		if (kakaoPayOrder != null) {
			RestTemplate restTemplate = new RestTemplate();
			// 서버로 요청할 header
			HttpHeaders headers = new HttpHeaders();
			headers.add("Authorization", "KakaoAK " + KAKAO_PAY_ADMIN_KEY);
			// Content-type: application/x-www-form-urlencoded;charset=utf-8
			headers.add("Content-type", MediaType.APPLICATION_FORM_URLENCODED_VALUE + ";charset=utf-8");

			// 서버로 요청할 body
			MultiValueMap<String, String> params = new LinkedMultiValueMap<String, String>();

			params.add("cid", KAKAO_PAY_CID);
			params.add("tid", kakaoPayOrder.getTid());
			params.add("partner_order_id", kakaoPayOrder.getPartnerOrderId());
			params.add("partner_user_id", kakaoPayOrder.getPartnerUserId());
			params.add("pg_token", kakaoPayOrder.getPgToken());
			logger.debug("=======================================");
			logger.debug("[KakaoPayService] tid :" + kakaoPayOrder.getTid());
			logger.debug("[KakaoPayService] partner_order_id :" + kakaoPayOrder.getPartnerOrderId());
			logger.debug("[KakaoPayService] partner_user_id :" + kakaoPayOrder.getPartnerUserId());
			logger.debug("[KakaoPayService] pg_token:" + kakaoPayOrder.getPgToken());
			logger.debug("[KakaoPayService] cid :" + KAKAO_PAY_CID);
			logger.debug("=======================================");

			HttpEntity<MultiValueMap<String, String>> body = new HttpEntity<MultiValueMap<String, String>>(params,headers);
			try {
				kakaoPayApprove = restTemplate.postForObject(new URI(KAKAO_PAY_HOST + KAKAO_PAY_APPROVE_URL), body,KakaoPayApprove.class);
				// kakaoPayApprove=restTemplate.postForObject(new
				// URI(KAKAO_PAY_HOST+KAKAO_PAY_APPROVE_URL),body,KakaoPayApprove.class);
				logger.debug("=======================================");
				logger.debug("[KakaoPayService] kakaoPayApprove :" + kakaoPayApprove);
				logger.debug("=======================================");
				if (kakaoPayApprove != null) {
					logger.debug("=======================================");
					logger.debug("[KakaoPayService] kakaoPayApprove :" + kakaoPayApprove);
					logger.debug("=======================================");
				}
			} catch (RestClientException e) {
				logger.error("[KakaoPayService] kakaoPayApprove RestClientException", e);
			} catch (URISyntaxException e) {
				logger.error("[KakaoPayService] kakaoPayApprove URISyntaxException", e);
			}
		} else {
			logger.error("[KakaoPayService] kakaoPayApprove kakaoPayOrder is null");
		}
		return kakaoPayApprove;
	}

	public int productQuanUpdate(Product product) {
		int count = 0;
		try {
			count = orderDao.productQuanUpdate(product);
		} catch (Exception e) {
			logger.error("[orderService] productQuanUpdate Exception", e);
		}

		return count;
	}

	public List<Product> selectProductQuan(int orderNo) {
		List<Product> list = null;
		try {
			list = orderDao.selectProductQuan(orderNo);
		} catch (Exception e) {
			logger.error("[orderService] selectProductQuan Exception", e);
		}

		return list;
	}

}
