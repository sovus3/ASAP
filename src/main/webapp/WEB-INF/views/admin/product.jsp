<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ page import="java.text.SimpleDateFormat"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<style>
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
	width: 15%;
}

th:nth-child(3), td:nth-child(3) {
	width: 30%;
}

th:nth-child(4), td:nth-child(4) {
	width: 13%;
}

th:nth-child(5), td:nth-child(5) {
	width: 10%;
}

th:nth-child(6), td:nth-child(6) {
	width: 10%;
}

th:nth-child(7), td:nth-child(7), th:nth-child(8), td:nth-child(8), th:nth-child(9),
	td:nth-child(9) {
	width: 13%;
}

.search-form {
	width: 60%;
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

	$("#btnSearch").on("click",function(){
		document.bbsForm.orderNo.value="";   
		document.bbsForm.searchType.value=$("#_searchType").val();
		document.bbsForm.searchValue.value=$("#_searchValue").val();
		document.bbsForm.curPage.value="1";
		document.bbsForm.action="/admin/product";
		document.bbsForm.submit();
   });
   
   document.getElementById("_searchValue").addEventListener("keyup", function(event) {
		if (event.keyCode === 13) 
		{
			document.bbsForm.orderNo.value="";   
			document.bbsForm.searchType.value=$("#_searchType").val();
			document.bbsForm.searchValue.value=$("#_searchValue").val();
			document.bbsForm.curPage.value="1";
			document.bbsForm.action="/admin/product";
			document.bbsForm.submit();
		}
	});
});

function fn_update(productSeq)
{
	document.bbsForm.productSeq.value = productSeq;
  	document.bbsForm.action = "/admin/productUpdate";
    document.bbsForm.submit();
}

function fn_upload()
{
	document.bbsForm.action = "/admin/productUpload";
	document.bbsForm.submit();
}

function fn_list(curPage)
{
	document.bbsForm.productSeq.value="";   
	document.bbsForm.curPage.value = curPage; 
	document.bbsForm.action="/admin/product";
	document.bbsForm.submit();
}

function fn_delete(productSeq){
	Swal.fire({
        title: '상품을 삭제하시겠습니까?',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: '확인',
        cancelButtonText: '취소'
    }).then((result) => {
		if (result.isConfirmed) {
			$.ajax({
				type:"POST",
				url:"/admin/productDelete",
				data:{
					productSeq:productSeq
				},
				dataType:"JSON",
				beforeSend:function(xhr)
				{
					xhr.setRequestHeader("AJAX", "true");
				},
				success:function(response)
				{
					if(response.code == 0)
					{
						Swal.fire({
							title: '상품이 삭제되었습니다.', 
							icon: 'success'
						}).then(function(){
							location.href="/admin/product";
						})
					}
					else if(response.code == 500)
					{
						Swal.fire({
							title: '상품 삭제가 안되었습니다.', 
							icon: 'info'
						}).then(function(){
							location.href="/admin/product";
						})
					}
					else if(response.code == 403)
					{
						Swal.fire({
							title: '관리자가 아닙니다.', 
							icon: 'warning'
						}).then(function(){
							location.href="/index";
						})
					}
				},
				error(xhr, status, error)
				{
					icia.common.error(error);
				}
			});
		}
   })
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

				<!-- 투표 내역 -->
				<div class="col-xl-9 col-md-12 order-1 order-xl-2">
					<div class="gen-blog gen-blog-col-1">
						<div class="row">
							<div class="col-lg-12">
								<hr>
								<div class="gen-blog gen-blog-col-1">
									<div class="row">
										<div class="col-lg-12">
											<hr>
											<div class="container bootstrap snippets bootdey">
												<div class="row">
													<div class="col-lg-12 mb-3 mt-3">
														<h4>상품 리스트</h4>
													</div>
												</div>

												<!-- 검색 시작 -->
												<form id="search-form" class="mb-3 mt-3" style="border: #000000;" onsubmit="btnSearch(); return false;">
													<div class="row">
														<div class="col-7">
															<div class="row no-gutters">
																<div class="col-lg-3 col-md-3 col-sm-12 p-0">
																	<select class="form-control" name="_searchType" id="_searchType">
																		<option value="1" <c:if test = '${searchType eq "1"}'>selected</c:if>>상품명</option>
																	</select>
																</div>
																<div class="col-lg-7 col-md-8 col-sm-12 p-0">
																	<input type="text" placeholder="Search..." class="form-control" name="_searchValue" id="_searchValue" value="">
																</div>
																<div class="col-lg-2 col-md-1 col-sm-12 p-0">
																	<button type="button" id="btnSearch" class="btn btn-base" style="color: #ffffff;">
																		<svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-search">
																			<circle cx="11" cy="11" r="8"></circle>
												                            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
												                        </svg>
																	</button>
																</div>
															</div>
														</div>
														<div class="col-5 text-right">
															<!-- 버튼을 맨 오른쪽에 위치시키는 부분 -->
															<button type="button" name="productUpload" id="productUpload" onclick="fn_upload()" style="color: #ffffff; width: 100px; height: 54px !important; background-color: rgba(61, 79, 115, 0.5); border: 0;"> 상품 등록</button>
														</div>
													</div>
												</form>
												<!-- 검색 끝 -->
												
												<!-- 테이블 시작 -->
												<div class="row">
													<div class="col-lg-20" style="margin-top: 5px !important;">
														<!-- 결제내역 1개 시작 -->
														<table>
															<thead style="background-color: rgba(61, 79, 115, 0.5);">
																<tr>
																	<th>상품번호</th>
																	<th>상품</th>
																	<th>상품명</th>
																	<th>상품 금액</th>
																	<th>상품 재고</th>
																	<th>판매상태</th>
																	<th>판매 시작일</th>
																	<th>판매 종료일</th>
																	<th></th>
																</tr>
															</thead>
															<tbody>
																<c:if test="${!empty list}">
																	<c:forEach var="product" items="${list}" varStatus="status">
																		<tr>
																			<td>
																				<div class="cell-inner">
																					<span>${product.productSeq}</span>
																				</div>
																			</td>
																			<td width="100">
																				<img src="/resources/upload/product/${product.productSeq}.png">
																			</td>
																			<td>
																				<div class="cell-inner">
																					<span>${product.productName}</span>
																				</div>
																			</td>
																			<td>
																				<div class="cell-inner">
																					<span>₩<fmt:formatNumber type="number" maxFractionDigits="3" value="${product.productPrice}" /></span>
																				</div>
																			</td>
																			<td>
																				<div class="cell-inner" style="cursor: pointer" onclick="fn_view(${pay.orderNo})">
																					<span>${product.productQuantity}</span>
																				</div>
																			</td>
																			<td>
																				<div class="cell-inner">
																					<span>${product.status}</span>
																				</div>
																			</td>
																			<td>
																				<div class="cell-inner">
																					<c:set var="originalDate" value="${product.productStartDate}" />
																					<c:set var="dateParts" value="${fn:split(originalDate, ' ')}" />
																					<c:set var="dateOnly" value="${dateParts[0]}" />
																					<span>${dateOnly}</span>
																				</div>
																			</td>
																			<td>
																				<div class="cell-inner">
																					<c:set var="originalDate1" value="${product.productEndDate}" />
																					<c:set var="dateParts1" value="${fn:split(originalDate1, ' ')}" />
																					<c:set var="dateOnly1" value="${dateParts1[0]}" />
																					<span>${dateOnly1}</span>
																				</div>
																			</td>
																			<td>
																				<label class="badge badge-warning" onclick="fn_update(${product.productSeq})">수정</label>
																				&nbsp; 
																				<label class="badge badge-danger" onclick="fn_delete(${product.productSeq})">삭제</label>
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
				</div>
			</div>
		</div>
	</section>

	<form name="bbsForm" id="bbsForm" method="post">
		<input type="hidden" name="productSeq" value="" /> 
		<input type="hidden" name="searchType" value="${searchType}" /> 
		<input type="hidden" name="searchValue" value="${searchValue}" /> 
		<input type="hidden" name="curPage" value="${curPage}" />
	</form>
	
	<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>