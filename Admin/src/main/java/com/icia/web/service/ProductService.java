package com.icia.web.service;

import org.apache.commons.io.FileUtils;
import org.apache.ibatis.annotations.Param;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.icia.common.util.StringUtil;
import com.icia.web.dao.ProductDao;
import com.icia.web.model.Cart;
import com.icia.web.model.OrderDetail;
import com.icia.web.model.Product;
import com.icia.web.model.Review;
import com.icia.web.util.CookieUtil;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

@Service("ProductService")
public class ProductService {
	
	private static Logger logger = LoggerFactory.getLogger(VoteService.class);
	
	@Autowired
	ProductDao productDao;
	
	
	//상품 리스트
	public List<Product> productList(Product Product)
	{
		List<Product> list = null;
		
		try 
		{
			list = productDao.productList(Product);
		}
		catch(Exception e) 
		{
			logger.error("[ProductService] productList Exception", e);
		}
		
		return list;
	}
	
	//상품 총 개수
	public long productListCount(Product Product)
	{
		long count = 0;
		
		try 
		{
			count = productDao.productListCount(Product);
		}
		catch(Exception e) 
		{
			logger.error("[ProductService] productListCount Exception", e);
		}
		
		return count;
	}
	
	//상품 상세페이지 조회
	public Product productDetail(long productSeq) 
	{
		Product product = null;
		
		try 
		{
			product = productDao.productDetail(productSeq);
		}
		catch(Exception e) 
		{
			logger.error("[ProductService] productDetail Exception", e);
		}
		
		return product;
	}
	
	//장바구니 추가
	public int cartInsert(Cart cart) {
		int cnt = 0;
		
		try{
			cnt = productDao.cartInsert(cart);
		}
		catch(Exception e){
			logger.error("[ProductService]  cartInsert Exception", e);
		}

		return cnt;
	}
	
	public Cart cartDuplicate(String userId, long productSeq) 
	{
	    Cart duplicate = null;
	    try 
	    {
	        duplicate = productDao.cartDuplicate(userId, productSeq);
	    } catch(Exception e) 
	    {
	        logger.error("[ProductService] cartDuplicate Exception", e);
	    }
	    return duplicate;
	}
	
	public int cartQuantityUpdate(Cart cart) 
	{
		int count = 0;
	    try 
	    {
	    	count =  productDao.cartQuantityUpdate(cart);
	    } 
	    catch(Exception e) 
	    {
	        logger.error("[ProductService] cartQuantityUpdate Exception", e);
	    }
	    return count;
	}
	
	public List<Cart> cartList(String userId)
	{
		List<Cart> list = null;
		
		try 
		{
			list = productDao.cartList(userId);
		}
		catch(Exception e) 
		{
			logger.error("[ProductService] cartList Exception", e);
		}
		
		return list;
	}
	
	public long cartListCount(Cart cart)
	{
		long count = 0;
		
		try 
		{
			count = productDao.cartListCount(cart);
		}
		catch(Exception e) 
		{
			logger.error("[ProductService] cartListCount Exception", e);
		}
		
		return count;
	}
	
	//장바구니 업데이트
	public int cartUpdate(Cart cart) 
	{
		int count = 0;
	    try 
	    {
	    	count =  productDao.cartUpdate(cart);
	    } 
	    catch(Exception e) 
	    {
	        logger.error("[ProductService] cartUpdate Exception", e);
	    }
	    return count;
	}
	
	//장바구니 삭제
	public int cartDelete(Cart cart) 
	{
		int count = 0;
	    try 
	    {
	    	count =  productDao.cartDelete(cart);
	    } 
	    catch(Exception e) 
	    {
	        logger.error("[ProductService] cartUpdate Exception", e);
	    }
	    return count;
	}
	
	//상품 재고
	public int maxProductQuan(long productSeq)
	{
		int count= 0;
		try 
		{
			count = productDao.maxProductQuan(productSeq);
		}
		catch(Exception e) 
		{
			logger.error("[orderService] maxProductQuan Exception", e);
		}
		
		return count;
	}
	
	//주문 상세 내역
	public List<OrderDetail> orderDetailSelect(long orderNo) 
	{
		List<OrderDetail> list = null;
		
		try 
		{
			list = productDao.orderDetailSelect(orderNo);
		}
		catch(Exception e) 
		{
			logger.error("[orderService] orderDetailSelect Exception", e);
		}
		
		return list;
	}
	
	//리뷰 등록
	public int reviewInsert(Review review) {
		int count = 0;
		
		try{
			count = productDao.reviewInsert(review);
		}
		catch(Exception e){
			logger.error("[ProductService] reviewInsert Exception", e);
		}

		return count;
	}
	
	//리뷰 리스트
	public List<Review> reviewList(Review review)
	{
		List<Review> list = null;
		
		try
		{
			list = productDao.reviewList(review);
		}
		catch (Exception e)
		{
			logger.error("[ProductService] reviewList Exception", e);
		}
		
		return list;
	}
	
	//리뷰 총 개수
	public long reviewListCount(long productSeq) 
	{
		long count = 0;
		
		try 
		{
			count = productDao.reviewListCount(productSeq);
		}
		catch(Exception e) 
		{
			logger.error("[ProductService] reviewListCount Exception", e);
		}
		
		return count;
	}
		
	/*summernote 이미지 첨부*/
	public HashMap<String, Object> reviewImageUpload(MultipartFile multipartFile) 
	{
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		String fileRoot = "C:\\project\\webapps\\ASAP\\src\\main\\webapp\\WEB-INF\\views\\resources\\upload\\productReview\\";
		
		String originalFileName = multipartFile.getOriginalFilename(); // 오리지널 파일명
		String extension = originalFileName.substring(originalFileName.lastIndexOf(".")); //파일확장자
		String savedFileName = UUID.randomUUID() + extension; //저장될 파일 명
		
		File targetFile = new File(fileRoot + savedFileName);
		
		try 
		{
			InputStream fileStream = multipartFile.getInputStream();
			FileUtils.copyInputStreamToFile(fileStream, targetFile);
			map.put("url", "/resources/upload/productReview/" + savedFileName);
			map.put("responseCode", "success");
		} 
		catch (IOException e) 
		{
			FileUtils.deleteQuietly(targetFile); //저장된 파일 삭제
			map.put("responseCode", "error");
			e.printStackTrace();
		}
		return map;
	}
	
	//리뷰 조회
	public Review reviewSelect(long reviewSeq) 
	{
		Review review = null;
		
		try 
		{
			review = productDao.reviewSelect(reviewSeq);
		}
		catch(Exception e) 
		{
			logger.error("[ProductService] review Exception", e);
		}
		
		return review;
	}
	
	//리뷰 수정
	public int reviewUpdate(Review review) 
	{
		int count = 0;
		
		try 
		{
			count = productDao.reviewUpdate(review);
		}
		catch(Exception e) 
		{
			logger.error("[ProductService] reviewUpdate Exception", e);
		}
		
		return count;
	}

	//리뷰 개수
	public long reviewCnt(long productSeq) 
	{
		long count  = 0;
		
		try 
		{
			count = productDao.reviewCnt(productSeq);
		}
		catch(Exception e) 
		{
			logger.error("[ProductService] reviewTotalCount Exception", e);
		}
		
		return count;
	}
	
	//리뷰 삭제
	public int reviewDelete(long reviewSeq) 
	{
		int count = 0;
		
		try 
		{
			count = productDao.reviewDelete(reviewSeq);
		}
		catch(Exception e) 
		{
			logger.error("[ProductService] reviewUpdate Exception", e);
		}
		
		return count;
	}
}
