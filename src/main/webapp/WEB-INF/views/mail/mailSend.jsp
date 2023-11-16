<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<script>
	$(document).ready(function(){
		
		$("#btnChangeToN").click(function(){
			document.mailForm.action = "/mail/aucToNProc";
			docuemtn.mailForm.submit();
		});
		
		$("#btnMailSend").click(function(){
			document.mailForm.action = "/mail/mailSendProc";
			docuemtn.mailForm.submit();
		});

	});
</script>
</head>
<body>
<hr><br>

<div>
	<form name="mailForm" method="post">
		<div class="click">
			<input style="margin-right: 5px"type="submit" id="btnChangeToN" name="auctionPriceUpdate" value="경매 종료 및 낙찰자 선정">			
		</div>
		<div class="click">
			<input style="margin-right: 5px" type="submit" id="btnMailSend" name="btnMailSend" value="메일 보내기, 낙찰액 갱신, 낙찰실패자 환불">			
		</div>
	</form>
</div>
	
</body>
</html>