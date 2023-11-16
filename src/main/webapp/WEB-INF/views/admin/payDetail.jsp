<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ page import="java.text.SimpleDateFormat"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<style>
th, td {
	border-color: transparent !important;
	vertical-align: middle !important; /* 수직 가운데 정렬 */
}

table {
	border: none !important;
	border-color: transparent !important;
	text-align: center !important; /* 수평 가운데 정렬 */
	vertical-align: middle !important; /* 수직 가운데 정렬 */
}

.total {
	font-size: 60%; /* 작게 표시하기 위해 폰트 크기를 조절합니다. */
	text-decoration: underline; /* 밑줄을 추가합니다. */
	float: right; /* 맨 오른쪽에 위치하도록 설정합니다. */
	margin-left: 10px; /* "투표 신청 내역" 텍스트와의 간격을 조절합니다. */
	cursor: pointer;
}
</style>
<script>
$(document).ready(function() {
	var regDate = $("#regDate").val();
	console.log("regDate : ", regDate);
});

function fn_detail(vrSeq) 
{
   document.voteDetailForm.vrSeq.value = vrSeq;
   document.voteDetailForm.gubun.value = "myPageVote"
   document.voteDetailForm.action = "/vote/voteListDetail";
   document.voteDetailForm.submit();
}
//카테고리 이동 
function searchByCategory(value) {
    document.voteDetailForm.searchType.value = value;
    document.voteDetailForm.curPage.value = "1";
    document.voteDetailForm.action = "/myPage/myPageVoteList";
    document.voteDetailForm.submit();	    
}
function fn_list(curPage2){
	document.bbsForm.orderNo.value="";   
	document.bbsForm.curPage2.value = curPage2;
	document.bbsForm.action="/admin/payDetail";
	document.bbsForm.submit();
}
function fn_back(){
	document.bbsForm.action="/admin/payList";
	document.bbsForm.submit();
	
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
							<h1>관리자</h1>
						</div>
						<div class="gen-breadcrumb-container">
							<ol class="breadcrumb">
								<li class="breadcrumb-item">
									<a href="index.html"> 
										<i class="fas fa-home mr-2"></i>홈
									</a>
								</li>
								<li class="breadcrumb-item active">관리자 페이지</li>
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
				<div class="col-xl-3 col-md-12 order-2 order-xl-1 mt-4 mt-xl-0" style="width: 20%;">
					<div class="widget widget_recent_entries">
						<h2 class="widget-title">
							<a href="/admin/adminNoticeBoard">관리자</a>
						</h2>
						<ul>
							<li><a href="/admin/userList">회원</a></li>
							<li><a href="/admin/adminAuction">경매 업로드</a></li>
							<li><a href="/admin/adminAucCurList">경매 입찰내역</a></li>
							<li><a href="/admin/adminAucBuyPriceList">경매 낙찰내역</a></li>
							<li><a href="/admin/aucEvent">이벤트 경매</a></li>
							<li><a href="/admin/aeCur">이벤트경매 입찰내역</a></li>
							<li><a href="/admin/voteUpload">투표</a></li>
							<li><a href="/admin/payList">결제내역</a></li>
							<li><a href="/admin/product">상품내역</a></li>
							<li><a href="/admin/adminNoticeBoard">공지사항 게시판</a></li>
							<li><a href="/admin/adminQnaBoard">문의사항 게시판</a></li>
						</ul>
					</div>
				</div>
				<!-- 사이드바 끝 -->

				<!-- 문의내역 시작 -->
				<div class="col-xl-9 col-md-12 order-1 order-xl-2">
					<div class="gen-blog gen-blog-col-1">
						<div class="row">
							<div class="col-lg-12">
								<div class="row">

									<!-- 관리자 게시판 1개 시작 -->
									<div class="col-lg-12 grid-margin stretch-card" style="background-color: #221f1f !important;">
										<div class="card" style="background-color: #221f1f !important;">
											<div class="card-body" style="background-color: #221f1f !important;">
												<h4 class="card-title" style="color: #ffffff;">결제상세</h4>
												<c:if test="${!empty list}">
													<h7 class="card-title" style="color: #FAFAD2;">결제일 : ${list[0].regDate}</h7>
												</c:if>
												<div class="table-responsive">
													<!-- 테이블 시작 -->
													<table class="table" style="color: #ffffff;">
														<thead style="background-color: rgba(61, 79, 115, 0.5);">
															<tr>
																<th>주문번호</th>
																<th>상품</th>
																<th>상품명</th>
																<th>주문수량</th>
																<th>상품 가격</th>
																<th>총 가격</th>
															</tr>
														</thead>
														<tbody>
															<c:if test="${!empty list}">
																<c:forEach var="orderDetail" items="${list}">
																	<tr>
																		<td>${orderDetail.orderNo}</td>
																		<td width="100">
																			<img src="/resources/upload/product/${orderDetail.productSeq}.png">
																		</td>
																		<td>${orderDetail.productName}</td>
																		<td>${orderDetail.orderDetailQuantity}</td>
																		<td>
																			<fmt:formatNumber type="number" maxFractionDigits="3" value="${orderDetail.orderDetailPrice}" />
																		</td>
																		<td>
																			<fmt:formatNumber type="number" maxFractionDigits="3" value="${orderDetail.orderDetailPrice * orderDetail.orderDetailQuantity}" />
																		</td>
																	</tr>
																</c:forEach>
															</c:if>
														</tbody>
													</table>

													<!-- 테이블 끝 -->
													<a style="background-color: transparent !important; cursor: pointer; float: right; margin-left: 10px; text-decoration: underline;" class="gen-button gen-button-flat"> 
														<span class="text" onclick="fn_back()">목록</span>
													</a>

													<!-- 페이징 처리 시작 -->
													<br /> <br />
													<div class="col-lg-12 col-md-12" style="margin: 0 auto;">
														<div class="gen-pagination" style="text-align: center;">
															<nav aria-label="Page navigation" style="display: inline-block;">
																<ul class="page-numbers">
																	<c:if test="${!empty paging}">
																		<c:if test="${paging.prevBlockPage gt 0}">
																			<!-- greater than, less than -->
																			<li>
																				<a class="next page-numbers" href="javascript:void(0)" onclick="fn_list(${paging.prevBlockPage})">이전블럭</a>
																			</li>
																		</c:if>

																		<c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
																			<c:choose>
																				<c:when test="${i ne curPage2}">
																					<!-- not equal -->
																					<li>
																						<a class="page-numbers" href="javascript:void(0)" onclick="fn_list(${i})">${i}</a>
																					</li>
																				</c:when>
																				<c:otherwise>
																					<li>
																						<a class="page-numbers" href="javascript:void(0)" style="cursor: default;">${i}</a>
																					</li>
																				</c:otherwise>
																			</c:choose>
																		</c:forEach>
																		<c:if test="${paging.nextBlockPage gt 0}">
																			<li>
																				<a class="next page-numbers" href="javascript:void(0)" onclick="fn_list(${paging.nextBlockPage})">다음블럭</a>
																			</li>
																		</c:if>
																	</c:if>
																</ul>
															</nav>
														</div>
													</div>
													<!-- 페이징 처리 끝 -->
												</div>
											</div>
										</div>
									</div>
									<!-- 관리자 게시판 1개 끝 -->
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</section>

	<form name="bbsForm" id="bbsForm" method="post">
		<input type="hidden" name="orderNo" value="" /> 
		<input type="hidden" name="searchType" value="${searchType}" /> 
		<input type="hidden" name="searchValue" value="${searchValue}" /> 
		<input type="hidden" name="curPage" value="${curPage}" /> 
		<input type="hidden" name="curPage2" value="${curPage2}" />
	</form>

</body>
<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</html>