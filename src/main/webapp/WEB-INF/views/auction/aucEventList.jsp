<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
	<%@ include file="/WEB-INF/views/include/head.jsp"%>

<script>
	//작품 클릭시 상세페이지 이동
	function fn_detail(aeSeq) {
		document.aucEventForm.aeSeq.value = aeSeq;
		document.aucEventForm.action = "/auction/aucEventDetail";
		document.aucEventForm.submit();
	}
	
	//다음페이지 이동
	function fn_list(curPage){
	   document.aucEventForm.curPage.value = curPage;
	   document.aucEventForm.action = "/auction/aucEventList";
	   document.aucEventForm.submit();
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
                               이벤트 경매
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
    <section class="gen-section-padding-3"  style="margin-top: -4% !important;">
        <div class="container container-2" style="width:80%;">
            <div class="row">
	            <c:forEach var="list" items="${list}" varStatus="status">
	            	<!-- 진행 경매 작품 1개 시작 -->
	                <div class="col-xl-6 col-lg-6 col-md-6" style="margin-top:2%;">
	                        <div class="gen-price-detail"> 
	                        	<a href="javascript:void(0)" onclick="fn_detail(${list.aeSeq})">
	                            	<img src="/resources/upload/eventbanner/${list.aeSeq}.png" alt="stream-lab-image" style="border-radius:20px !important;">
	                            </a>
	                      		<dl>
	                           		<h6 class="mt-3">[이벤트 경매] ${list.aeTitle}</h6>
	                        	</dl>
	                    </div>
	                </div>
	                <!-- 진행 경매 작품 1개 끝 -->
	            </c:forEach>
            </div>
        </div>
    </section>
    <!-- Pricing Plan End -->
    <div class="col-lg-12 col-md-12" style="margin: 0 auto;">
 		<div class="gen-pagination" style="text-align: center;">
			<nav aria-label="Page navigation" style="display :inline-block;">
				<ul class="page-numbers">
					<c:if test="${!empty paging}">
						<c:if test="${paging.prevBlockPage gt 0}">		<!-- greater than, less than  --> 
         					<li><a class="next page-numbers" href="javascript:void(0)" onclick="fn_list(${paging.prevBlockPage})">이전블럭</a></li>
						</c:if>
	
						<c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}" >
							<c:choose>
								<c:when test="${i ne curPage}" >		<!-- not equal  --> 
									<li><a class="page-numbers" href="javascript:void(0)" onclick="fn_list(${i})">${i}</a></li>
								</c:when>
								<c:otherwise>         
									<li><a class="page-numbers" href="javascript:void(0)" style="cursor:default;">${i}</a></li>
								</c:otherwise>   		
							</c:choose>
   						</c:forEach>
    					<c:if test="${paging.nextBlockPage gt 0}">
         					<li><a class="next page-numbers" href="javascript:void(0)" onclick="fn_list(${paging.nextBlockPage})">다음블럭</a></li>
						</c:if>
					</c:if>
                </ul>
            </nav>
        </div>
    </div>
    <br><br><br>
    <!-- 페이징 처리 끝 -->
     
     
     
    <form name="aucEventForm" id="aucEventForm" method="post">
		<input type="hidden" id="aeSeq" name="aeSeq" value="${aeSeq}"/> 
		<input type="hidden" id="curPage" name="curPage" value="${curPage}" />
	
	</form>
	   <%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>