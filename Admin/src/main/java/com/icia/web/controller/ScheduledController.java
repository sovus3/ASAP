package com.icia.web.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.icia.web.model.Admin;
import com.icia.web.model.AucCur;
import com.icia.web.model.MyPageNmailSend;
import com.icia.web.model.Response;
import com.icia.web.service.AuctionService;
import com.icia.web.util.CookieUtil;
import com.icia.web.util.HttpUtil;

@Component
@EnableScheduling
public class ScheduledController {
	
	private static final Logger logger = LoggerFactory.getLogger(ScheduledController.class);
	
	@Autowired
	AuctionService as;

	//오늘 날짜 가져오기
	public static String nowDate() {
		Date now = new Date();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMM");
		String formatedNow = formatter.format(now);
			        
		System.out.println("################################");
		logger.info("date is: " + now);
		logger.info("formatter is: " + formatter);
		logger.info("formatedDate is: " + formatedNow);
		System.out.println("################################");
	        
		return formatedNow;
	}
	
	//경매 상태 변경(경매 시작 R->Y)
	@Scheduled(cron = "00 38 17 30 10 *")
	public void auctionStatusToY() {
		int cnt = 0;
		
		cnt = as.auctionStatusToY();
		
        if(cnt > 0) {
        	System.out.println("################################");
        	logger.info("ScheduledController.auctionStatusToY: success" + cnt);
        	System.out.println("################################");
        }
        else {
        	System.out.println("################################");
        	logger.info("ScheduledController.auctionStatusToY : failed " + cnt);
        	System.out.println("################################");
        }
	}
	
	//경매 상태 변경(경매 종료 Y->N) -> 각 카테고리별 입찰가가 높은 아이디를 대상으로 입찰 상태를 Y로 변경
	@Scheduled(cron = "0 30 10 30 10 *")
	public void auctionStatusToN() {
		int cnt = 0;
		String formatedDate = nowDate();
		
		try {
			cnt = as.auctionStatusToN(formatedDate);
		}
		catch(Exception e) {
			logger.error("[AuctionService] auctionStatusToY Exception",e);
		}
		
        if(cnt > 0) {
        	System.out.println("################################");
        	logger.info("ScheduledController.auctionStatusToN: success" + cnt);
        	System.out.println("################################");
        }
        else {
        	System.out.println("################################");
        	logger.info("ScheduledController.auctionStatusToN : failed " + cnt);
        	System.out.println("################################");
        }
	}
	
	/*각 카테고리별 입찰가가 높은 아이디를 대상으로 입찰 상태를 Y로 변경
	@Scheduled(cron = "03 10 23 * * *")
	public void aucCurChangeToY() {
			
		try {
			String formatedDate = nowDate();
			String formatedDatetest = "202309";
					        
			int cnt = as.aucCurChangeToY(formatedDatetest);
			
			if(cnt > 0) {
				System.out.println("################################");
				logger.info("auctionService.aucCurChangeToY : success: " + cnt);
				System.out.println("################################");
			}
			else {
				System.out.println("################################");
				logger.info("auctionService.aucCurChangeToY : failed: " + cnt);
				System.out.println("################################");
			}
		}
		catch(Exception e) {
			logger.error("[Scheduling] aucCurChangeToY Exception", e);
		}
	}*/
	
	//입찰에 실패한 경매 참여자들 대상으로 환불
	@Scheduled(cron = "03 30 10 *30 10 *")
	public void returnProc(){	
		
		List<AucCur> list = as.chargeReturnSelect(nowDate());
		int cnt = 0;
			
		if(list != null){
			for(int i = 0; i < list.size(); i++){
				AucCur cur = list.get(i);
					
				cnt = as.chargeReturnUpdate(cur);
					
				if(cnt > 0){
					System.out.println("################################################################");
					logger.info("auctionService.chargeReturnUpdate : success: " + cnt);
					System.out.println("################################################################");
				}
				else {
					System.out.println("################################################################");
					logger.info("auctionService.chargeReturnUpdate : failed: " + cnt);
					System.out.println("################################################################");
				}
				cnt = 0;
			}
		}
		else{
			System.out.println("################################################################");
			logger.info("list is null");
			System.out.println("################################################################");
		}
	}
	
	//각 카테고리별 1등, 월의 리스트를 가져와서 그 대상자들한테 메일 보내기
	@Scheduled(cron = "06 30 10 30 10 *")
	public void aucMailSend() {
		
		 Properties prop = new Properties();
			prop.put("mail.smtp.host", "smtp.gmail.com"); 
			prop.put("mail.smtp.port", 465); 
			prop.put("mail.smtp.auth", "true"); 
			prop.put("mail.smtp.ssl.enable", "true"); 
			prop.put("mail.smtp.ssl.trust", "smtp.gmail.com");
		     
			final String USER = "asapproject2@gmail.com";
			final String PASSWORD = "qvvbxeqwtllzcnby";
			        
			//사용자 인증
			Session session = Session.getDefaultInstance(prop, new javax.mail.Authenticator() {
			   @Override
				protected PasswordAuthentication getPasswordAuthentication() {
			     return new PasswordAuthentication(USER, PASSWORD);
			   }
			});

			MimeMessage msg = new MimeMessage(session);
			
			String recipient = "sovusmk3@gmail.com";
			String title = "[낙찰 안내] 안녕하세요 ASAP 입니다. 낙찰을 축하드립니다.";
			String content =  "";
			String receiver = "";
			
			//String formatedDate = nowDate();
			String formatedDate = "202309";
			
			List<MyPageNmailSend> myPageNmailSend = as.myPageNmailSendSelect(formatedDate);
			
			try {
				if(myPageNmailSend != null){
					for(int i = 0; i < myPageNmailSend.size(); i++) {

						content = "<html>\r\n"
								+ "<head>\r\n"
								+ "</head>\r\n"
								+ "<body>\r\n"
								+ "    <div>\r\n"
								+ "    <h3>" + myPageNmailSend.get(i).getAcUserId() + "님, 낙찰을 축하드립니다.</h3>\r\n"
								+ "    <ul>\r\n"
								+ "        <li>낙찰 작품 내역</ol> <br>\r\n"
								+ "        <li> 작품명: " +   myPageNmailSend.get(i).getVrTitle()     + " </ol><br>\r\n"
								+ "        <li> 작가명: " +   myPageNmailSend.get(i).getArtUserName()    + " </ol><br>\r\n"
								+ "        <li> 낙찰가: " +   myPageNmailSend.get(i).getAucCurPrice()     + " </ol><br>\r\n"
								+ "        <li> 낙찰일: " +   myPageNmailSend.get(i).getAucCurBuyTime()     + " </ol><br>\r\n"
								+ "    </ul>\r\n"
								+ "</div>\r\n"
								+ "\r\n"
								+ "낙찰가는 충전금에서 차감되었고, 낙찰 내역은 마이페이지에서 확인이 가능합니다.<br>\r\n"
								+ "앞으로도 ASAP과 함께 해주시기를 바라겠습니다.<br>\r\n"
								+ "감사합니다.\r\n"
								+ "</body>\r\n"
								+ "</html>";

						receiver = myPageNmailSend.get(i).getAcUserEmail();

						msg.setFrom(new InternetAddress("asapproject2@gmail.com", "ASAP", "utf-8"));
						msg.setRecipient(Message.RecipientType.TO, new InternetAddress(receiver)); //수신자
						msg.setSubject(title); //메일 제목을 입력
						msg.setText(content, "UTF-8", "html");

						Transport.send(msg); ////전송
					}
				}
				else {
					logger.debug("myPageNmailSend is null");
				}
			}
			catch (AddressException e) {
				logger.error("[Scheduling] aucMailSend AddressException", e);
		    } 
			catch (MessagingException e) {
				logger.error("[Scheduling] aucMailSend MessagingException", e);
		    }
			catch(Exception e) {
				logger.error("[Scheduling] aucMailSend Exception", e);
			}

	}
	//aucBuyPrice update
	@Scheduled(cron = "09 30 10 30 10 *")
	public void aucBuyPriceUpdate() {
		String date = "202309";
		int cnt = 0;
		
		List<AucCur> aucCurList = as.aucCurSelectForAuctionPriceUpdate(date);
		
		if(aucCurList != null) {	
			for(int i = 0; i < aucCurList.size(); i++) {
				
				AucCur aucCur = aucCurList.get(i);	
				cnt = as.aucBuyPriceUpdate(aucCur);
				
				if(cnt > 0) {
					System.out.println("################################################################");
					logger.info("auctionService.aucBuyPriceUpdate : success: " + cnt);
					System.out.println("################################################################");
				}
				else {
					System.out.println("################################################################");
					logger.info("auctionService.aucBuyPriceUpdate : failed: " + cnt);
					System.out.println("################################################################");
				}
			}
		}
		else {
			logger.debug("aucCur is null");
		}
	}
	
}
