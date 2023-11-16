package com.icia.web.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.icia.web.model.Order;
import com.icia.web.model.OrderDetail;
import com.icia.web.model.Pay;
import com.icia.web.model.Product;
import com.icia.web.model.User;

@Repository("orderDao")
public interface OrderDao {

	public int orderSeq(Order order);

	public int orderInsert(Order order);

	public int orderDetailInsert(OrderDetail orderDetail);

	public long cartOrderDelete(String userId);

	public Order orderSelect(String userId);

	public String orderNoSelect(String userId);

	public int payInsert(Pay pay);

	public int userChargeUpdate(User user);

	public int orderStatusUpdate(int orderNo);

	public int payStatusUpdate(int orderNo);

	public int productQuanUpdate(Product product);

	public List<Product> selectProductQuan(int orderNo);
}