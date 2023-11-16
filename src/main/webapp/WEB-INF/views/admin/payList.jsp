<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>

<style>
.total {
	font-size: 80%; /* 작게 표시하기 위해 폰트 크기를 조절합니다. */
	color: #FAFAD2;
	cursor: pointer;
}

table {
	table-layout: fixed; /* 테이블 크기를 고정합니다. */
	width: 100%; /* 테이블의 전체 너비를 100%로 설정합니다. */
	border-collapse: collapse; /* 셀 사이의 간격을 없앱니다. */
}

th, td {
	border-color: transparent !important;
	text-align: left; /* 텍스트를 왼쪽 정렬합니다. */
}

th:nth-child(1), td:nth-child(1) {
	width: 10%;
}

th:nth-child(2), td:nth-child(2) {
	width: 12%;
}

th:nth-child(3), td:nth-child(3) {
	width: 15%;
}

th:nth-child(4), td:nth-child(4) {
	width: 35%;
}

th:nth-child(5), td:nth-child(5), th:nth-child(6), td:nth-child(6), th:nth-child(7),
	td:nth-child(7) {
	width: 15%;
}

th:nth-child(8), td:nth-child(8) {
	width: 10%;
}

.button-container {
	text-align: right; /* 텍스트를 오른쪽으로 정렬 */
}

.search-form {
	width: 80%;
	margin: 0 auto;
	margin-top: 1rem;
}

.search-form input {
	height: 100%;
	background: transparent;
	border: 0;
	display: block;
	width: 100%;
	padding: 1rem;
	height: 100%;
	font-size: 1rem;
}

.search-form select {
	background: transparent;
	border: 0;
	padding: 1rem;
	height: 100%;
	font-size: 1rem;
}

.search-form select:focus {
	border: 0;
}

.search-form button {
	height: 100%;
	width: 100%;
	font-size: 1rem;
}

.search-form button svg {
	width: 24px;
	height: 24px;
}

select, select.form-control {
	height: 54px !important;
}
</style>

<script>
$(document).ready(function() {
   
	$("#btnSearch").on("click", function() {
	   search();
	});
	
	$("#_searchValue").on("keyup", function(event) {
	    if (event.keyCode === 13) {
	       search();
	    }
	});
	
	function search() {
	   document.bbsForm.orderNo.value = "";
	   document.bbsForm.searchType.value = $("#_searchType").val();
	   document.bbsForm.searchValue.value = $("#_searchValue").val();
	   document.bbsForm.curPage.value = "1";
	   document.bbsForm.action = "/admin/payList";
	   document.bbsForm.submit();
	}

});

function fn_view(orderNo)      
{
   document.bbsForm.orderNo.value= orderNo;
   document.bbsForm.action="/admin/payDetail";
   document.bbsForm.submit();
}

function fn_list(curPage)
{
   document.bbsForm.orderNo.value="";   
   document.bbsForm.curPage.value = curPage;
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
				
				<!-- 관리자 게시판 1개 시작 -->
				<div class="col-xl-9 col-md-9 order-1 order-xl-2">
					<div class="gen-blog gen-blog-col-1">
						<div class="row">
							<div class="col-lg-12">
								<hr>
								<div class="container bootstrap snippets bootdey">
									<br>
									<h4>결제내역</h4>
									<br>
									<!-- 검색 시작 -->
									<form id="search-form" class="mb-3 mt-3" style="border: #000000;" onsubmit="btnSearch(); return false;">
										<div class="row">
											<div class="col-12">
												<div class="row no-gutters">

													<div class="col-lg-3 col-md-3 col-sm-12 p-0">
														<select class="form-control" name="_searchType" id="_searchType">
															<option value="">조회 항목</option>
															<option value="1" <c:if test = '${searchType eq "1"}'>selected</c:if>>주문번호</option>
															<option value="2" <c:if test = '${searchType eq "2"}'>selected</c:if>>결제일</option>
															<option value="3" <c:if test = '${searchType eq "3"}'>selected</c:if>>회원아이디</option>
															<option value="4" <c:if test = '${searchType eq "4"}'>selected</c:if>>상품명</option>
															<option value="5" <c:if test = '${searchType eq "5"}'>selected</c:if>>결제상태</option>
														</select>
													</div>

													<div class="col-lg-8 col-md-8 col-sm-12 p-0">
														<input type="text" placeholder="Search..." class="form-control" name="_searchValue" id="_searchValue" value="${searchValue}">
													</div>

													<div class="col-lg-1 col-md-1 col-sm-12 p-0">
														<button type="button" id="btnSearch" class="btn btn-base" style="color: #ffffff;">
															<svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-search">
																<circle cx="11" cy="11" r="8"></circle>
																<line x1="21" y1="21" x2="16.65" y2="16.65"></line>
															</svg>
														</button>
													</div>

												</div>
											</div>
										</div>
									</form>
									<!-- 검색 끝 -->
									
									<div class="total" style="margin-top: 15px !important; text-align: right !important;">
										<span>결제상태 : Y(완료), F(포인트 환불), N(취소) </span>
									</div>
									
									<!-- 테이블 시작 -->
									<div class="row">
										<div class="col-lg-20" style="margin-top: 5px !important;">
											<!-- 결제내역 1개 시작 -->
											<table>
												<thead style="background-color: rgba(61, 79, 115, 0.3); color: #ffffff;">
													<tr>
														<th>주문번호</th>
														<th>결제날</th>
														<th>회원아이디</th>
														<th>상품명</th>
														<th>총 결제액</th>
														<th>포인트 사용액</th>
														<th>실 결제액</th>
														<th>결제상태</th>
													</tr>
												</thead>
												<tbody id="items">
													<c:if test="${!empty list}">
														<c:forEach var="pay" items="${list}" varStatus="status">
															<tr>
																<td>
																	<div class="cell-inner">
																		<span>${pay.orderNo}</span>
																	</div>
																</td>
																<td>
																	<div class="cell-inner">
																		<c:set var="originalDate" value="${pay.regDate}" />
																		<c:set var="dateParts" value="${fn:split(originalDate, ' ')}" />
																		<c:set var="dateOnly" value="${dateParts[0]}" />
																		<span>${dateOnly}</span>
																		<%-- <small>${pay.regDate}</small> --%>
																	</div>
																</td>
																<td>
																	<div class="cell-inner">
																		<span>${pay.userId}</span>
																	</div>
																</td>
																<c:choose>
																	<c:when test="${pay.cnt >1 }">
																		<td>
																			<div class="cell-inner" style="cursor: pointer" onclick="fn_view(${pay.orderNo})">
																				<small>${pay.productName} 외 ${pay.cnt -1 }개</small>
																			</div>
																		</td>
																	</c:when>
																	<c:otherwise>
																		<td>
																			<div class="cell-inner" style="cursor: pointer" onclick="fn_view(${pay.orderNo})">
																				<small>${pay.productName}</small>
																			</div>
																		</td>
																	</c:otherwise>
																</c:choose>
																<td>
																	<div class="cell-inner">
																		<span>
																			<fmt:formatNumber type="number" maxFractionDigits="3" value="${pay.payTotalPrice}" />
																		</span>
																	</div>
																</td>
																<td>
																	<div class="cell-inner">
																		<span>
																			<fmt:formatNumber type="number" maxFractionDigits="3" value="${pay.payPointPrice}" />
																		</span>
																	</div>
																</td>
																<td>
																	<div class="cell-inner">
																		<span>
																			<fmt:formatNumber type="number" maxFractionDigits="3" value="${pay.payRealPrice}" />
																		</span>
																	</div>
																</td>
																<td>
																	<div class="cell-inner">
																		<span>${pay.status}</span>
																	</div>
																</td>
															</tr>
														</c:forEach>
													</c:if>
												</tbody>
											</table>
											<!-- 테이블 끝 -->

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
																		<c:when test="${i ne curPage}">
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
	</section>

	<form name="bbsForm" id="bbsForm" method="post">
		<input type="hidden" name="orderNo" value="" /> 
		<input type="hidden" name="searchType" value="${searchType}" /> 
		<input type="hidden" name="searchValue" value="${searchValue}" /> 
		<input type="hidden" name="curPage" value="${curPage}" />
	</form>

</body>
<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</html>