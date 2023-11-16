<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!-- 경매 입찰낙찰 조회(검색) -->
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<script>

$(document).ready(function(){
	//조회
	$("#btnSearch").on("click",function(){
		document.aeForm.aeSeq.value="";	
		document.aeForm.searchType.value=$("#searchType").val();
		document.aeForm.searchValue.value=$("#searchValue").val();
		document.aeForm.curPage.value="1";
		document.aeForm.action="/admin/aeCur";
		document.aeForm.submit();
	});
});

//페이지 이동
function fn_list(curPage)
{
	document.aeForm.curPage.value = curPage;
	document.aeForm.action ="/admin/aeCur";
	document.aeForm.submit();

}
</script>
</head>
<body>
	<%@ include file="/WEB-INF/views/include/navigation.jsp"%>

	<!-- breadcrumb -->
	<div class="gen-breadcrumb">
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
								<li class="breadcrumb-item active">이벤트경매 내역</li>
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

				<!-- 게시판 1개 시작 -->
				<div class="col-xl-9 col-md-12 order-1 order-xl-2">
					<div class="gen-blog gen-blog-col-1">
						<div class="row">
							<div class="col-lg-12">
								<div class="container bootstrap snippets bootdey">
									<div class="row">
										<div class="col-lg-12">
											<h4>이벤트경매 입찰 내역</h4>
											<div class="ml-auto input-group" style="width: 50%;">
												<select name="searchType" id="searchType" class="custom-select" style="width: auto;">
													<option value="">조회 항목</option>
													<option value="1" <c:if test='${searchType eq "1"}'>selected</c:if>>제목</option>
													<option value="2" <c:if test='${searchType eq "2"}'>selected</c:if>>아이디</option>
													<option value="3" <c:if test='${searchType eq "3"}'>selected</c:if>>입찰</option>
													<option value="4" <c:if test='${searchType eq "4"}'>selected</c:if>>낙찰</option>
												</select> 
												<input type="text" name="searchValue" id="searchValue" value="${searchValue}" class="form-control mx-1" maxlength="20" style="width: auto; ime-mode: active; height: 38px !important;" placeholder="조회값을 입력하세요." />
												<button type="button" id="btnSearch" class="btn btn-secondary mb-3 mx-1">조회</button>
											</div>
											<div class="row">
												<!--/col-3-->
												<div class="col-lg-12">
													<div class="table-responsive" style="color: #ffffff;">
														<table class="table" style="color: #ffffff;">
															<thead style="background-color: rgba(61, 79, 115, 0.3); color: #ffffff;">
																<tr>
																	<th>번호</th>
																	<th>아이디</th>
																	<th>제목</th>
																	<th>상품명</th>
																	<th>입찰액</th>
																	<th>입찰날짜</th>
																	<th>상태</th>
																</tr>
															</thead>
															<tbody id="items">
																<c:forEach var="list" items="${list}" varStatus="status">
																	<tr>
																		<td>
																			<div class=“cell-inner”>
																				<span>${list.aeSeq}</span>
																			</div>
																		</td>

																		<td>
																			<div class="cell-inner">
																				<span>${list.userId}</span>
																			</div>
																		</td>
																		<td>
																			<div class="cell-inner">
																				<span>${list.aeTitle}</span>
																			</div>
																		</td>
																		<td>
																			<div class="cell-inner">
																				<span>${list.aeProductTitle}</span>
																			</div>
																		</td>

																		<td>
																			<div class="cell-inner">
																				<span>${list.aeCurPrice}</span>
																			</div>
																		</td>
																		<td>
																			<div class="cell-inner">
																				<span>${list.aeCurBuyTime}</span>
																			</div>
																		</td>
																		<td>
																			<c:choose>
																				<c:when test="${list.status == 'Y'}">
																					<div>
																						<a><span>낙찰</span></a>
																					</div>
																				</c:when>
																				<c:when test="${list.status == 'N'}">
																					<div>
																						<a><span>입찰</span></a>
																					</div>
																				</c:when>
																				<c:when test="${list.status == 'C' }">
																					<div>
																						<a><span>입찰(환불)</span></a>
																					</div>
																				</c:when>
																			</c:choose>
																		</td>
																	</tr>
																</c:forEach>
															</tbody>
														</table>

														<!-- 페이징처리 시작 -->
														<div class="col-lg-12 col-md-12" style="margin: 0 auto;">
															<div class="gen-pagination" style="text-align: center;">
																<nav aria-label="Page navigation" style="display: inline-block;">
																	<ul class="page-numbers">
																		<c:if test="${!empty paging}">

																			<c:if test="${paging.prevBlockPage gt 0}">
																				<li>
																					<a class="next page-numbers" href="javascript:void(0)" onclick="fn_list(${paging.prevBlockPage})">이전</a>
																				</li>
																			</c:if>

																			<c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
																				<c:choose>
																					<c:when test="${i ne curPage}">
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
																					<a class="next page-numbers" href="javascript:void(0)" onclick="fn_list(${paging.nextBlockPage})">다음</a>
																				</li>
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
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<!-- 게시판 1개 끝 -->
			</div>
		</div>
	</section>

	<form name="aeForm" id="aeForm" method="post">
		<input type="hidden" name="aeSeq" id="aeSeq" value="${aeSeq}" /> 
		<input type="hidden" name="curPage" id="curPage" value="${curPage}" /> 
		<input type="hidden" name="searchType" id="searchType" value="${searchType}" />
		<input type="hidden" name="searchValue" id="searchValue" value="${searchValue}" />
	</form>

	<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>