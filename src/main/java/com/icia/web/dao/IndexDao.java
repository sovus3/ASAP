package com.icia.web.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.icia.web.model.AucEvent;
import com.icia.web.model.Product;
import com.icia.web.model.VoteUpload;

@Repository("IndexDao")
public interface IndexDao {
	
	public List<VoteUpload> indexAucList();
	
	public List<VoteUpload> indexVoteList();
	
	public List<AucEvent> indexAucEventList();
	
	public List<Product> indexProcutList();
}
