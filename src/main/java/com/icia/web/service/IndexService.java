package com.icia.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.icia.web.dao.IndexDao;
import com.icia.web.model.AucEvent;
import com.icia.web.model.Product;
import com.icia.web.model.VoteUpload;

@Service("IndexService")
public class IndexService {
	private static Logger logger = LoggerFactory.getLogger(MyPageService.class);
	
	@Autowired
	IndexDao indexDao;

	public List<VoteUpload> indexAucList() {
		List<VoteUpload> voteUpload = null;
		
		try {
			voteUpload = indexDao.indexAucList();
		}
		catch(Exception e) {
			logger.error("[IndexService] indexAucList Exception", e);
		}
		
		return voteUpload;
	}
	
	public List<VoteUpload> indexVoteList() {
		List<VoteUpload> voteList = null;
		
		try {
			voteList = indexDao.indexVoteList();
		}
		catch(Exception e) {
			logger.error("[IndexService] indexVoteList Exception", e);
		}
		
		return voteList;
	}
	
	
	public List<AucEvent> indexAucEventList() {
		List<AucEvent> aucEvent = null;
		
		try {
			aucEvent = indexDao.indexAucEventList();
		}
		catch(Exception e) {
			logger.error("[IndexService] indexAucEventList Exception", e);
		}
		
		return aucEvent;
	}
	
	public List<Product> indexProcutList() {
		List<Product> product = null;
		
		try {
			product = indexDao.indexProcutList();
		}
		catch(Exception e) {
			logger.error("[IndexService] indexProcutList Exception", e);
		}
		
		return product;
	}
}
