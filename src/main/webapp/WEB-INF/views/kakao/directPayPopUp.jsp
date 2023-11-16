<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<link rel="stylesheet" href="/resources/css/progress-bar.css" type="text/css">
<script type="text/javascript">
function kakaoDirectPayResult(pgToken)
{
	$("#pgToken").val(pgToken);
	//아이프레임은 사라지고 페이리줄트가 열리는 것
	document.kakaoForm.action="/kakao/directPayResult";
	document.kakaoForm.submit();
}
function kakaoPayCancel()
{
	 opener.movePage();
	 window.close();
}
</script>
</head>
<body><!-- 카카오에서 QR 뿌려줌 -->
<iframe width="100%" height="650" src="${pcUrl }" frameborder="0" allowfullscreen=""></iframe>
<form name = "kakaoForm" id="kakaoForm" method="post">
	<input type="hidden" name="orderId" id="orderId" value="${orderId }" />
	<input type="hidden" name="tId" id="tId" value="${tId }" />
	<input type="hidden" name="userId" id="userId" value="${userId }" />
	<input type="hidden" name="pgToken" id="pgToken" value="" />
</form>
</body>
</html>