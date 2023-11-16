package com.icia.web.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.icia.web.model.NoticeBoard;
import com.icia.web.model.QnaBoard;


@Repository("boardDao")
public interface BoardDao {
	
	public List<NoticeBoard> NoticeBoardList(NoticeBoard noticeBoard);
	
	public long NoticeBoardListCount(NoticeBoard noticeBoard);
	
	public NoticeBoard NoticeBoardSelect(long nbSeq);
	
	public int NoticeBoardUpdate(NoticeBoard noticeBoard);
	
	public int NoticeBoardDelete(long nbSeq);
	
	public int NoticeBoardInsert(NoticeBoard noticeBoard);
	
	//게시물 등록 
	public int QnaBoardInsert(QnaBoard qnaBoard);
	//게시물 리스트 
	public List<QnaBoard> QnaBoardList(QnaBoard qnaBoard);
	//총 게시물 
	public long QnaBoardListCount(QnaBoard qnaBoard);
	//게시물 조회
	public QnaBoard QnaBoardSelect(long qaSeq);
	//게시물 조회수 증가
	public int QnaBoardReadCntPlus(long qaSeq);
	//게시물 그룹 순서 변경
	public int QnaBoardGroupOrderUpdate(QnaBoard qnaBoard);
	//게시물 답글 등
	public int QnaBoardReplyInsert(QnaBoard qnaBoard);
	//게시물 수정 
	public int QnaBoardUpdate(QnaBoard qnaBoard);
	//게시물 삭제
	public int QnaBoardDelete(QnaBoard qnaBoard);
	public int QnaBoardDelete2(long qaSeq);
	//게시물 삭제시 답변글 조회
	public int QnaBoardAnswersCount (long qaSeq);
}
