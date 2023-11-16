<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<style>
th, td {
	border-color: transparent !important;
}

.table td, .table th {
	vertical-align: middle !important;
}
</style>

<script>

function fn_review(value1, value2){	
	document.reviewForm.orderNo.value = value1;
	document.reviewForm.productSeq.value = value2;
	document.reviewForm.action = "/product/reviewWrite";
	document.reviewForm.submit();
}

//페이지 버튼 클릭 이동
function fn_list(curPage){
	document.orderDListForm.curPage.value = curPage;
	document.orderDListForm.action = "/myPage/myPageOrderDetail";
	document.orderDListForm.submit();
}

//페이지 버튼 클릭 이동
function fn_detail(val){
    document.reviewForm.productSeq.value = val;
    document.reviewForm.action = "/product/productDetail";
    document.reviewForm.submit();
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
							<h1>마이페이지</h1>
						</div>
						<div class="gen-breadcrumb-container">
							<ol class="breadcrumb">
								<li class="breadcrumb-item">
									<a href="index.html"> 
										<i class="fas fa-home mr-2"></i>홈
									</a>
								</li>
								<li class="breadcrumb-item active">마이페이지</li>
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
								<div class="container bootstrap snippets bootdey">
									<div class="row">
										<div class="col-lg-12 mt-3 mb-3">
											<h4>주문 상세</h4>
										</div>
									</div>
									<div class="row">
										<!--/col-3-->
										<div class="col-lg-12">
											<div class="table-responsive" style="color: #ffffff;">
												<table class="table" style="color: #ffffff;">
													<thead style="background-color: rgba(61, 79, 115,0.5); color: #ffffff;">
														<tr>
															<th>주문번호: ${orderDetail.orderNo}</th>
															<th>상품명</th>
															<th>주문수량</th>
															<th>상품 가격</th>
															<th></th>
														</tr>
													</thead>
													<tbody id="items">
														<c:if test="${!empty list}">
															<c:forEach var="orderDetail" items="${list}">
																<tr>
																	<td width="150">
																		<img src="/resources/upload/product/${orderDetail.productSeq}.png">
																	</td>
																	<td onclick="fn_detail(${orderDetail.productSeq})" style="cursor:pointer;">
																		${orderDetail.productName}
																	</td>
																	<td>${orderDetail.orderDetailQuantity}</td>
																	<td>${orderDetail.orderDetailPrice}</td>
																	<td>
																		<c:if test = "${orderDetail.status == 'N'}">
																			<div class="cell-inner">
																				<span>
																					<input type="button" id="reviewWrite" value="리뷰작성" onclick="fn_review(${orderDetail.orderNo}, ${orderDetail.productSeq})" class="mr-3"/>
																				</span>
																			</div>
																		</c:if>
																		<c:if test = "${orderDetail.status == 'Y'}">
																			<div style="float:left;" class="ml-4">
																				<span class="mr-3" style="color:#3d4f73; font-weight:bold;">
																					작성완료
																				</span>
																			</div>
																		</c:if>
																	</td>
																</tr>
															</c:forEach>
														</c:if>
													</tbody>
												</table>
											</div>
										</div>
									</div>
									<!--/col-9-->
								</div>
								<!--/row-->
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
				<!-- 문의내역 끝 -->
			</div>
		</div>
	</section>
	<!-- Blog-left-Sidebar -->
	
	<form name="reviewForm" id="reviewForm" method="post">
		<input type="hidden" name="userId" id="userId" value="${orderDetail.userId}">
		<input type="hidden" name="orderNo" id="orderNo" value="">
		<input type="hidden" name="productSeq" id="productSeq" value="">
		<input type="hidden" name="productName" id="productName" value="${orderDetail.productName}">
		<input type="hidden" name="orderDetailQuantity" id="orderDetailQuantity" value="${orderDetail.orderDetailQuantity}">
		<input type="hidden" name="productName" id="orderDetailPrice" value="${orderDetail.orderDetailPrice}">
	</form>

	<form name="orderDListForm" id="orderDListForm" method="post">
		<input type="hidden" name="curPage" id="curPage" value="${curPage}" />
		<!-- 여기서 현재 페이지 번호를 입력받음, 기본값은 1임 -->
	</form>
	<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>