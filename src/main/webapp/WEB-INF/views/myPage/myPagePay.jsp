<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>

<style>
body{
	font-weight: bold !important;
}

th, td {
	border-color: transparent !important;
}

.fmtCss{
	color: #007bff !important; 
}
</style>

<script>
function fn_orderDetail(value){
	document.orderDForm.orderNo.value = value;
	document.orderDForm.action = "/myPage/myPageOrderDetail";
	document.orderDForm.submit();
}

//페이지 버튼 클릭 이동
function fn_list(curPage){
	document.payListForm.curPage.value = curPage;
	document.payListForm.action = "/myPage/myPagePay";
	document.payListForm.submit();
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
							<h1>결제내역</h1>
						</div>
						<div class="gen-breadcrumb-container">
							<ol class="breadcrumb">
								<li class="breadcrumb-item">
									<a href="index.html"> 
										<i class="fas fa-home mr-2"></i>홈
									</a>
								</li>
								<li class="breadcrumb-item active">결제내역</li>
							</ol>
						</div>
					</nav>
				</div>
			</div>
		</div>
	</div>
	<!-- breadcrumb -->
	
	<!-- Blog-left-Sidebar -->
	<section class="gen-section-padding-3">
		<div class="container">
			<div class="row">
			
				<!-- 사이드바 시작 -->
					<div class="col-xl-3 col-md-12 order-2 order-xl-1 mt-4 mt-xl-0" style="width:20%;">
						<div class="widget widget_recent_entries">
							<h2 class="widget-title"><a href="/myPage/myPageMain">마이페이지</a></h2>
							<ul>
								<li><a href="/myPage/userUpdate">회원정보수정</a></li>
								<li><a href="/myPage/myPagePay">결제내역</a></li>	
								<li><a href="/myPage/myPageVote">투표내역</a></li>	
								<li><a href="/myPage/myPageAucCur">입찰내역</a></li>
								<li><a href="/myPage/myPageQna">문의내역</a></li>
								<c:if test="${user.userCode == 'A'}">
								<li><a href="/myPage/myPageVoteUpload">투표작품신청내역</a></li>
								<li><a href="/myPage/artAucResult">경매결과내역</a></li>
								</c:if>
							</ul>
						</div>
					</div>
	            <!-- 사이드바 끝 -->
				
				<!-- 문의내역 시작 -->
				<div class="col-xl-9 col-md-12 order-1 order-xl-2">
					<div class="gen-blog gen-blog-col-1">
						<div class="row">
							<div class="col-lg-12">
								<hr>
								<div class="row">
									<div class="col-lg-12 mt-3 mb-3">
										<h4>결제 내역</h4>
									</div>
									
									<div class="row">
										<!--/col-3-->
										<div class="col-lg-12">
											<c:if test="${!empty list}">
												<c:forEach var="pay" items="${list}" varStatus="status">
													<!-- 결제내역 1개 시작 -->
													<table>
														<tbody>
															<tr>
																<td width="150">
																	<img src="/resources/upload/product/${pay.productSeq}.png">
																</td>
																<td width="850" style="text-align:left; margin: auto;">
																	<c:if test="${pay.cnt > 1}">
																		<p style="margin:0">${pay.productName} 외 ${pay.cnt - 1}</p>
																	</c:if>
																	<c:if test="${pay.cnt <= 1}">
																		<p style="margin:0">${pay.productName}</p>
																	</c:if>
																	<p style="margin:0">OrderNo : ${pay.orderNo}</p>
																	<!-- 총결제(실결제: 13,000원 | 포인트 결제: 5,000원) -->
																	<b class="fmtCss "><span style="margin:0">&#8361;<fmt:formatNumber type="number" maxFractionDigits="3" value="${pay.payTotalPrice}"/></span></b>
																	
																	<span style="text-decoration-line: underline !important; font-size: 14px; display: inline-block !important; ">
																		실결제: <span style="margin:0">&#8361;<fmt:formatNumber type="number" maxFractionDigits="3" value="${pay.payRealPrice}" /> | </span>
																		포인트 결제: <span style="margin:0">&#8361;<fmt:formatNumber type="number" maxFractionDigits="3" value="${pay.payPointPrice}" /></span>
																	</span>
																</td>
																<td>
																	<c:if test="${pay.productSeq > 2}">
																		<span>
																			<input type="button" id="orderDetail" value="주문상세" onclick="fn_orderDetail(${pay.orderNo})" class="mr-3"/>
																		</span>
																	</c:if>
																</td>
															</tr>
														</tbody>
													</table>
													<!-- 결제내역 1개 끝 -->
												</c:forEach>
											</c:if>
										</div>
									</div>
									
									<!-- 리스트가 비어있으면 시작 -->
		                           <div style="margin:0 auto !important; margin-top:5% !important;">
		                              <c:if test="${empty list}">
		                                 <i class="fa fa-exclamation-circle fa-4x" aria-hidden="true" style="left:-100px !important;"></i>
		                                 <h6 class="mt-3" style="margin-left:-30% !important;">조회된 내역이 없습니다.</h6>
		                              </c:if>
		                           </div>
		                           <!-- 리스트가 비어있으면 끝 -->
									
								</div>
							</div>
						</div>
					</div>
					
					<!-- 페이징처리 시작 -->
					<div class="col-lg-12 col-md-12" style="margin: 0 auto;">
				 		<div class="gen-pagination" style="text-align: center;">
							<nav aria-label="Page navigation" style="display :inline-block;">
								<ul class="page-numbers">
									<c:if test="${!empty paging}">
										<c:if test="${paging.prevBlockPage gt 0}">		
				         					<li><<a class="next page-numbers" href="javascript:void(0)" onclick="fn_list(${paging.prevBlockPage})">이전블럭</a></li>
										</c:if>
					
										<c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}" >
											<c:choose>
												<c:when test="${i ne curPage}" >		
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
					<!-- 페이징처리 끝 -->
				</div>
			</div>
		</div>
	</section>
	
	<form name="orderDForm" id = "orderDForm" method="post">
		<input type="hidden" name="orderNo" id="orderNo" value="">
	</form>
	
	<form name="payListForm" id="payListForm" method="post">
		<input type="hidden" name="curPage" id="curPage" value="${curPage}" />
		<!-- 여기서 현재 페이지 번호를 입력받음, 기본값은 1임 -->
	</form>
	   <%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>