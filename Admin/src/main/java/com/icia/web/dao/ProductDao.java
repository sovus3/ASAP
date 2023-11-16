package com.icia.web.dao;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.icia.web.model.Cart;
import com.icia.web.model.OrderDetail;
import com.icia.web.model.Product;
import com.icia.web.model.Review;

@Repository("ProductDao")
public interface ProductDao {
	//상품 리스트
	public List<Product> productList(Product product);
	
	//상품 총 개수
	public long productListCount(Product product);
	
	//상품 상세 페이지 조회
	public Product productDetail(long productSeq);

	//장바구니 추가
	public int cartInsert(Cart cart);
	
	public Cart cartDuplicate(@Param("userId") String userId, @Param("productSeq") long productSeq);
	
	public int cartQuantityUpdate(Cart cart);

	public List<Cart> cartList(String userId);
	
	public long cartListCount(Cart cart);
	//장바구니 업데이트
	public int cartUpdate(Cart cart);
	//장바구니 삭제
	public int cartDelete(Cart cart);
	//상품 재고
	public int maxProductQuan(long productSeq);	
	//주문 상세, 추후 위치 변경 예정
	public List<OrderDetail> orderDetailSelect(long orderNo);	
	//리뷰 등록
	public int reviewInsert(Review review);	
	//리뷰 리스트
	public List<Review> reviewList(Review review);	
	//리뷰 총 개수 조회
	public long reviewListCount(long productSeq);	
	//리뷰 조회
	public Review reviewSelect(long reviewSeq);	
	//리뷰 수정
	public int reviewUpdate(Review review);
	
	//리뷰 개수
	public long reviewCnt(long productSeq);
	
	//리뷰 삭제
	public int reviewDelete(long reviewSeq);
}
