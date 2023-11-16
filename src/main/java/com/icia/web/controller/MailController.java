package com.icia.web.controller;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.icia.web.model.AucCur;
import com.icia.web.model.MyPageNmailSend;
import com.icia.web.service.AuctionService;

@Controller("MailController")
public class MailController {
	private static Logger logger = LoggerFactory.getLogger(MailController.class);
	
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
	
	
	@RequestMapping(value="/mail/aucToNProc")
	public String auctionStatusToN() {
		int cnt = 0;
		
		String formatedDate = nowDate();
		
		try {
			cnt = as.auctionStatusToN(formatedDate);
		}
		catch(Exception e) {
			logger.error("[AuctionService] auctionStatusToY Exception",e);
		}
		
		return "/mail/mailSend";
	}
	
	@RequestMapping(value="/mail/mailSendProc")
	public String mailSend(HttpServletRequest request, HttpServletResponse response) {
		 Properties prop = new Properties();
			prop.put("mail.smtp.host", "smtp.gmail.com"); 
			prop.put("mail.smtp.port", 465); 
			prop.put("mail.smtp.auth", "true"); 
			prop.put("mail.smtp.ssl.enable", "true"); 
			prop.put("mail.smtp.ssl.trust", "smtp.gmail.com");
		     
			final String USER = "asapproject2@gmail.com";
			final String PASSWORD = "qvvbxeqwtllzcnby";			        
			        
			Session session = Session.getDefaultInstance(prop, new javax.mail.Authenticator() {
			   @Override
				protected PasswordAuthentication getPasswordAuthentication() {
			     return new PasswordAuthentication(USER, PASSWORD);
			   }
			});

			String recipient = "sovusmk3@gmail.com";
			String title = "[낙찰 안내] 안녕하세요 ASAP 입니다. 낙찰을 축하드립니다.";
			String content =  "";
			String receiver = "";
			
			MimeMessage msg = new MimeMessage(session);
			String formatedDate = nowDate();
			
            List<MyPageNmailSend> myPageNmailSend = as.myPageNmailSendSelect(formatedDate); //이메일 주소
			
			try {
				if(myPageNmailSend != null){
					for(int i = 0; i < myPageNmailSend.size(); i++) {
						
						DecimalFormat decFormat = new DecimalFormat("###,###");
						String aucPrice  = decFormat.format(myPageNmailSend.get(i).getAucCurPrice());

						content = "<html>\r\n"
								+ "<script src='https://code.jquery.com/jquery-3.6.0.min.js'></script>\r\n"
								+ "\r\n"
								+ "<head>\r\n"
								+ "    <style>\r\n"
								+ "    h3 {\r\n"
								+ "        font-family: \"Arial Black\", sans-serif;\r\n"
								+ "        font-size: 20px;\r\n"
								+ "        font-weight: bold;\r\n"
								+ "        color: #4A744D;\r\n"
								+ "      }\r\n"
								+ "\r\n"
								+ "        table {\r\n"
								+ "            border-collapse: collapse;\r\n"
								+ "            text-align: center;\r\n"
								+ "            vertical-align: middle;\r\n"
								+ "            margin-left:auto;\r\n"
								+ "            margin-right:auto;\r\n"
								+ "        }\r\n"
								+ "\r\n"
								+ "\r\n"
								+ "        th {\r\n"
								+ "            padding: 11px 8px 9px 8px;\r\n"
								+ "            background: #D5E2D6;\r\n"
								+ "        }\r\n"
								+ "\r\n"
								+ "        td {\r\n"
								+ "            padding: 12px 10px 9px 9px;\r\n"
								+ "        }\r\n"
								+ "    </style>\r\n"
								+ "</head>\r\n"
								+ "\r\n"
								+ "<body style=\"font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif\">\r\n"
								+ "    <div style=\"border: 2px solid #3d4f73; text-align : center; width: 700px;\">\r\n"
								+ "        <h3>"+  myPageNmailSend.get(i).getAcUserId()  +"님, 낙찰을 축하드립니다.</h3>\r\n"
								+ "        <hr style=\"width: 400px; height: 2px; border:none; background-color: black;\">\r\n"
								+ "        <p>\r\n"
								+ "            낙찰가는 충전금에서 차감되었고, 낙찰 내역은 마이페이지에서 확인이 가능합니다.<br>\r\n"
								+ "            앞으로도 ASAP과 함께 해주시기를 바라겠습니다.\r\n"
								+ "        </p>\r\n"
								+ "        <p>\r\n"
								+ "        <table>\r\n"
								+ "            <thead>\r\n"
								+ "                <th>작품명</th>\r\n"
								+ "                <th>작가명</th>\r\n"
								+ "                <th>낙찰가</th>\r\n"
								+ "                <th>낙찰일</th>\r\n"
								+ "            </thead>\r\n"
								+ "            <tbody>\r\n"
								+ "                <tr>\r\n"
								+ "                    <td>"+ myPageNmailSend.get(i).getVrTitle() +"</td>\r\n"
								+ "                    <td>"+ myPageNmailSend.get(i).getArtUserName() +"</td>\r\n"
								+ "                    <td>"+ aucPrice +"원</td>\r\n"
								+ "                    <td>"+ myPageNmailSend.get(i).getAucCurBuyTime() +"</td>\r\n"
								+ "                </tr>\r\n"
								+ "            </tbody>\r\n"
								+ "        </table>\r\n"
								+ "        </p>\r\n"
								+ "    </div>\r\n"
								+ "</body>\r\n"
								+ "\r\n"
								+ "</html>";
						receiver = myPageNmailSend.get(i).getAcUserEmail();

						msg.setFrom(new InternetAddress("asapproject2@gmail.com", "ASAP", "utf-8"));
						msg.setRecipient(Message.RecipientType.TO, new InternetAddress(receiver)); //수신자
						msg.setSubject(title); //메일 제목을 입력
						msg.setText(content, "UTF-8", "html");

						Transport.send(msg); //전송
					
					}
					
					//낙찰가 갱신
					for(int j = 0; j < myPageNmailSend.size(); j++) {
						int cnt = 0;
						
						AucCur aucCur = new AucCur();
						aucCur.setAucSeq(myPageNmailSend.get(j).getAucSeq());
						aucCur.setAucCurPrice(myPageNmailSend.get(j).getAucCurPrice());
						cnt = as.aucBuyPriceUpdate(aucCur);
						
						if(cnt >= 0) {
							logger.info("#####################Success#####################");
						}
						else {
							logger.info("#####################Fail#####################");
						}
					}
					
					//환불
					List<AucCur> list = as.chargeReturnSelect(nowDate());
					
					if(list != null){
						as.aucCurStatusUpdate(formatedDate);
						for(int k = 0; k < list.size(); k++){

							AucCur cur = list.get(k);
								
							if(as.chargeReturnUpdate(cur) > 0) {
								logger.info("######################Success##########################");
							}					
						}
					}
				 
				}
				else {
					logger.error("[Scheduling] gmailSend NullPointerException");
				}
			}
			catch (AddressException e) {
				logger.error("[Scheduling] gmailSend AddressException", e);
		    } 
			catch (MessagingException e) {
				logger.error("[Scheduling] gmailSend MessagingException", e);
		    }
			catch(Exception e) {
				logger.error("[Scheduling] gmailSend Exception", e);
			}

			
			return "/mail/mailSend";
	}

	
}
