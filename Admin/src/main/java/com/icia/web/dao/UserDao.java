/**
 * <pre>
 * 프로젝트명 : HiBoard
 * 패키지명   : com.icia.web.dao
 * 파일명     : UserDao.java
 * 작성일     : 2021. 1. 19.
 * 작성자     : daekk
 * </pre>
 */
package com.icia.web.dao;

import org.springframework.stereotype.Repository;

import com.icia.web.model.User;

@Repository("userDao")
public interface UserDao
{
	//로그인, 사용자 조회, 아이디 중복 확인
	public User userSelect(String userId);	
	//회원탈퇴, 상태 변경
	public int userDrop(User user);	
	//닉네임 중복 확인
	public User userNickSelect(String userNick);	
	//회원가입
	public int userRegInsert(User user);	
	//회원정보수정
	public int userUpdate(User user);
	
	public int userFeeUpdate(String userId);
}
