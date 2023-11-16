/**
 * <pre>
 * 프로젝트명 : HiBoard
 * 패키지명   : com.icia.web.service
 * 파일명     : UserService.java
 * 작성일     : 2021. 1. 20.
 * 작성자     : daekk
 * </pre>
 */
package com.icia.web.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.icia.web.dao.UserDao;
import com.icia.web.model.User;

/**
 * <pre>
 * 패키지명   : com.icia.web.service
 * 파일명     : UserService.java
 * 작성일     : 2023. 8. 30.
 * 작성자     : daekk
 * 설명       : 사용자 서비스
 * </pre>
 */
@Service("userService")
public class UserService
{
	private static Logger logger = LoggerFactory.getLogger(UserService.class);

	@Autowired
	private UserDao userDao;

	//로그인, 사용자 조회, 아이디 중복확인
	public User userSelect(String userId){
		User user = null;
		
		try{
			user = userDao.userSelect(userId);
		}
		catch(Exception e){
			logger.error("[UserService] userSelect Exception", e);
		}
		
		return user;
	}
	
	//회원 탈퇴, 상태 변경
	public int userDrop(User user) {
		int count = 0;
		
		try {
			count = userDao.userDrop(user);
		}
		catch(Exception e) {
			logger.error("[UserService] userDrop Exception", e);
		}
		
		return count;
	}
	
	//닉네임 중복확인
	public User userNickSelect(String userNick) {
		User user = null;
		
		try{
			user = userDao.userNickSelect(userNick);
		}
		catch(Exception e){
			logger.error("[UserService] userNickSelect Exception", e);
		}
		
		return user;
	}
	
	//회원가입 insert
	public int userRegInsert(User user) {
		int cnt = 0;
		
		try{
			cnt = userDao.userRegInsert(user);
		}
		catch(Exception e){
			logger.error("[UserService] userRegInsert Exception", e);
		}

		return cnt;
	}
	
	//회원정보수정
	public int userUpdate(User user){
		int count = 0;
		
		try{
			count = userDao.userUpdate(user);
		}
		catch(Exception e){
			logger.error("[UserService] userUpdate Exception",e);
		}
		
		return count;
	}
	
	public int userFeeUpdate(String userId) {
		int cnt = 0;
		
		try{
			cnt = userDao.userFeeUpdate(userId);
		}
		catch(Exception e){
			logger.error("[UserService] userFeeUpdate Exception", e);
		}

		return cnt;
	}
}
