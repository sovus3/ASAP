<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
	<%@ include file="/WEB-INF/views/include/head.jsp"%>
<style>
.liCss {
   border: 1px solid #ffffff !important; 
   width:15%;
   line-height:20px !important;
   margin:0 auto;
   font-size:15px !important;
   margin-top:-30px !important;
   margin-bottom:20px;
}
</style>

<script>
	//작품 클릭시 상세페이지 이동
	function fn_detail(aucSeq) {
		document.voteForm.aucSeq.value = aucSeq;
		document.voteForm.action = "/auction/auctionDetail";
		document.voteForm.submit();
	}
</script>

</head>
<body>
	<%@ include file="/WEB-INF/views/include/navigation.jsp"%>
	<!-- breadcrumb -->
    <div class="gen-breadcrumb" style="background-image: url('/resources/images/background/back.png');">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-12">
                    <nav aria-label="breadcrumb">
                        <div class="gen-breadcrumb-title">
                            <h1>
                                진행 경매
                            </h1>
                        </div>
                        <div class="gen-breadcrumb-container">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="index.html"><i
                                            class="fas fa-home mr-2"></i>홈</a></li>
                                <li class="breadcrumb-item active">진행 경매</li>
                            </ol>
                        </div>
                    </nav>
                </div>
            </div>
        </div>
    </div>
    <!-- breadcrumb -->
    
    <!-- Pricing Plan Start -->
    <section class="gen-section-padding-3 " style="margin-top: -5% !important;">
        <div class="container container-2">
            <div class="row">
            
       <c:choose>
	         <c:when test="${!empty list }">
	            <c:forEach var="list" items="${list}" varStatus="status">
	            	<!-- 진행 경매 작품 1개 시작 -->
	                <div class="col-xl-4 col-lg-4 col-md-4 mb-3" style="margin-top:3%;">
	                    <div class="gen-price-block text-center">
	                        <div class="gen-price-detail">
	                            <img src="/resources/upload/vote/${list.vrSeq}.png" alt="stream-lab-image">
	                        </div>
	                        <ul class="gen-list-info">
	                        	<li class="liCss">
	                        		<c:choose>
                                       <c:when test="${list.categoryNo == 01}">
                                           <span>미술</span>
                                       </c:when>
                                       <c:when test="${list.categoryNo == 02}">                                       
                                          <span>사진</span>                              
                                       </c:when>
                                       <c:when test="${list.categoryNo == 03}">                                         
                                          <span>도예</span>                                 
                                       </c:when>
                                    </c:choose>
                                </li>
	                            <h6>${list.vrTitle}</h6>
	                            <li>
	                                ${list.userName} 
	                            </li>
	                            <li>
	                                시작가 | <fmt:formatNumber type="number" maxFractionDigits="3" value="${list.vrStartPrice}" />
	                            </li>
	                        </ul>
		                    <c:choose>
			                  <c:when test ="${list.aucStatus == 'Y'}">
		                        <div class="gen-btn-container button-1">
									<a href="javascript:void(0)" class="gen-button" onclick="fn_detail(${list.aucSeq})">
			                             <span class="text">경매 참여</span>
		                            </a>
		                        </div>
		                      </c:when>
		                      <c:otherwise>
		                      	<div class="gen-btn-container button-1">
									<a class="gen-button" style="background-color: #C4C4C4">
			                             <span class="text" style="font-size: 18px; color:#0867cc !important; font-weight:bold;">진행 예정의 경매 입니다.</span>
		                            </a>
		                        </div>
		                      </c:otherwise>
		                    </c:choose>
	                    </div>
	                </div>
	                <!-- 진행 경매 작품 1개 끝 -->
	            </c:forEach>
	         </c:when>  
	         <c:otherwise>
			     <!-- 경매가 비어있으면 시작 -->
			      <div style="margin-left:47% !important; margin-top:1% !important;">
			         <i class="fa fa-exclamation-circle fa-5x" aria-hidden="true"></i>
			         <h3 class="mt-3" style="margin-left:-38% !important; margin-bottom:300px !important;">예정 및 진행 중인 경매가 없습니다.</h3>
			      </div>
			      <!-- 경매가 비어있으면 끝 -->

		         </div>
	         </c:otherwise> 
       </c:choose>
            </div>
        </div>
    </section>
    <!-- Pricing Plan End -->
    
    <form name="voteForm" id="voteForm" method="post">
		<input type="hidden" id="vrSeq" name="vrSeq" value="${vrSeq}" /> 
		<input type="hidden" id="curPage" name="curPage" value="${curPage}" />
		<input type="hidden" id="aucSeq" name="aucSeq" value="" /> 
	</form>
	
	   <%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>