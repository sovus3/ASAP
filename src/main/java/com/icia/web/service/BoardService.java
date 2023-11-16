package com.icia.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.icia.common.util.FileUtil;
import com.icia.web.dao.BoardDao;
import com.icia.web.model.NoticeBoard;
import com.icia.web.model.QnaBoard;

@Service("boardService")
public class BoardService {
	
	private static Logger logger = LoggerFactory.getLogger(BoardService.class);
	
	@Autowired 
	private BoardDao boardDao;
	
	public List<NoticeBoard> NoticeBoardList(NoticeBoard noticeBoard)
	{
		List<NoticeBoard> list = null;
		
		try 
		{
			list=boardDao.NoticeBoardList(noticeBoard);
		}
		catch(Exception e)
		{
			logger.error("[BoardService] NoticeBoardList Exception", e);
		}
		return list;
	}
	
	public long NoticeBoardListCount(NoticeBoard noticeBoard)
	{
		long count = 0;
		try
		{
			count=boardDao.NoticeBoardListCount(noticeBoard);
		}
		catch(Exception e)
		{
			logger.error("[BoardService]NoticeBoardListCountt Exception",e);
		}
		return count;
	}
	//게시물 보기
	public NoticeBoard NoticeBoardView(long nbSeq)
	{
		NoticeBoard noticeBoard = null;
		
		try 
		{
			noticeBoard = boardDao.NoticeBoardSelect(nbSeq);
			
		}
		catch(Exception e)
		{
			logger.error("[BoardService] NoticeBoardView Exception",e);
		}
		
		return noticeBoard;
	}
	// 게시물 수정폼 조회
    public NoticeBoard NoticeBoardViewUpdate(long nbSeq)
    {
    	NoticeBoard noticeBoard = null;
 
       try
       {
    	   noticeBoard = boardDao.NoticeBoardSelect(nbSeq);
       }
       catch(Exception e)
       {
          logger.error("[BoardService] NoticeBoardViewUpdate Exception",e);   
       }
      
       return noticeBoard;
    }
    //게시물 수정 
    public int NoticeBoardUpdate(NoticeBoard noticeBoard)
	{
		int count = 0;
		try
		{
			count=boardDao.NoticeBoardUpdate(noticeBoard);
		}
		catch(Exception e)
		{
			logger.error("[BoardService] NoticeBoardUpdate Exception",e);
		}
		return count;
	}
    //게시물 삭제 
    public int NoticeBoardDelete(long nbSeq)
	{
		int count = 0;
		try
		{
			count=boardDao.NoticeBoardDelete(nbSeq);
		}
		catch(Exception e)
		{
			logger.error("[BoardService] NoticeBoardDelete Exception",e);
		}
		return count;
	}
  //게시판 등록
  	public int NoticeBoardInsert(NoticeBoard noticeBoard)			
  	{
  		int count =0;
  		try
		{
  			count = boardDao.NoticeBoardInsert(noticeBoard);		
  		
	  	}
		catch(Exception e)
		{
			logger.error("[BoardService] NoticeBoardInsert Exception",e);
		}
  		
  		return count;
  	}
  //게시판 등록
  	public int QnaBoardInsert(QnaBoard qnaBoard)		
  	{
  		int count =0;	
  		
  		try
		{
  			count = boardDao.QnaBoardInsert(qnaBoard);		
  		
	  	}
		catch(Exception e)
		{
			logger.error("[BoardService] QnaBoardInsert Exception",e);
		}
  		
  		return count;
  				
  	}
  	//게시물 리스트
  	public List<QnaBoard> QnaBoardList(QnaBoard qnaBoard)
  	{
  		List<QnaBoard> list = null;
  		
  		try
  		{
  			list = boardDao.QnaBoardList(qnaBoard);
  		}
  		catch(Exception e)
  		{
  			logger.error("[BoardService] QnaBoardList Exception",e);
  		}
  		return list;
  	}
  	//총 게시물 수
  	public long QnaBoardListCount(QnaBoard qnaBoard)
  	{
  		long count = 0;
  		
  		try
  		{
  			count= boardDao.QnaBoardListCount(qnaBoard);
  		}
  		catch(Exception e)
  		{
  			logger.error("[BoardService] QnaBoardListCount Exception",e);
  		}
  		
  		return count;
  		
  	}
  	//게시물 조회 
  	public QnaBoard QnaBoardSelect(long qaSeq)
  	{
  		QnaBoard hiBoard = null;
  		try
  		{
  			hiBoard=boardDao.QnaBoardSelect(qaSeq);
  		}
  		catch(Exception e)
  		{
  			logger.error("[BoardService] QnaBoardSelect Exception",e );
  		}
  		return hiBoard;		
  	}
  	//게시물 보기(첨부파일 포함, 조회수 증가 포함)
  	public QnaBoard QnaBoardView(long qaSeq)
  	{
  		QnaBoard qnaBoard = null;
  		
  		try 
  		{
  			qnaBoard = boardDao.QnaBoardSelect(qaSeq);
  			
  		}
  		catch(Exception e)
  		{
  			logger.error("[BoardService] QnaBoardView Exception",e);
  		}
  		
  		return qnaBoard;
  	}
  	//게시물 답글 등록
  	public int QnaBoardReplyInsert(QnaBoard qnaBoard)
  	{
  		int count =0;
  		
  		try 
  		{
  			count = boardDao.QnaBoardReplyInsert(qnaBoard);
  			
  		}
  		catch(Exception e)
  		{
  			logger.error("[BoardService] QnaBoardView Exception",e);
  		}
  		
  		return count;
  	}
  	// 게시물 수정폼 조회 ( 첨부파일 포함 )
      public QnaBoard QnaBoardViewUpdate(long qaSeq)
      {
    	 QnaBoard qnaBoard = null;
   
         try
         {
            qnaBoard = boardDao.QnaBoardSelect(qaSeq);
            
         }
         catch(Exception e)
         {
            logger.error("[BoardService] QnaBoardViewUpdate Exception",e);   
         }
        
         return qnaBoard;
      }
  	//게시물 수정
  	public int QnaBoardUpdate(QnaBoard qnaBoard)
  	{
  		int count = 0;
		try
		{
			count=boardDao.QnaBoardUpdate(qnaBoard);
		}
		catch(Exception e)
		{
			logger.error("[BoardService] QnaBoardUpdate Exception",e);
		}
		return count;
  		
  	}
  	//게시물 삭제시 답변글 수 조회
  	public int QnaBoardAnswersCount(long qaSeq)
  	{
  		int count = 0;
  		try
  		{
  			count = boardDao.QnaBoardAnswersCount(qaSeq);
  		}
  		catch(Exception e)
  		{
  			logger.error("[BoardService] QnaBoardAnswersCount Exception",e);
  		}
  		return count;
  	}
  	//게시물 삭제
  	public int QnaBoardDelete(QnaBoard qnaBoard)
  	{
  		int count = 0;
  		
  		try
		{
  			count = boardDao.QnaBoardDelete(qnaBoard);
		}
		catch(Exception e)
		{
			logger.error("[BoardService] QnaBoardDelete Exception",e);
		}
		return count;
  		
  	}
  //게시물 삭제
  	public int QnaBoardDelete2(long qaSeq)
  	{
  		int count = 0;
  		
  		try
		{
  			count = boardDao.QnaBoardDelete2(qaSeq);
		}
		catch(Exception e)
		{
			logger.error("[BoardService] QnaBoardDelete Exception",e);
		}
		return count;
  		
  	}
}
