<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<style>
</style>
<script>
$(document).ready(function(){
	$("#btnSearch").click(function(){
		document.admVoteForm.vrSeq.value= $("#vrSeq").val();   
		/* 추가 */
		document.admVoteForm.vlSearchType.value=$("#vlSearchType").val();
		document.admVoteForm.vlSearchValue.value=$("#vlSearchValue").val();
		/* 추가	*/
		document.admVoteForm.searchType.value=$("#searchType").val();
		document.admVoteForm.searchValue.value=$("#searchValue").val();
		document.admVoteForm.listPage.value="1";
		document.admVoteForm.action="/admin/voteList";
		document.admVoteForm.submit();
	});      
});

function fn_listPage(listPage){
	document.admVoteForm.listPage.value = listPage;
	document.admVoteForm.vrSeq.value= $("#vrSeq").val();
	document.admVoteForm.curPage.value= $("#curPage").val();
	document.admVoteForm.searchType.value=$("#searchType").val();
	document.admVoteForm.searchValue.value=$("#searchValue").val();
	/* 추가 */
	document.admVoteForm.vlSearchType.value=$("#vlSearchType").val();
	document.admVoteForm.vlSearchValue.value=$("#vlSearchValue").val();
	/* 추가 */
	document.admVoteForm.action = "/admin/voteList";
	document.admVoteForm.submit();      
}

// 뒤로가기 버튼
function fn_Upload(curPage){
	document.admVoteForm.curPage.value = curPage;
	/* 추가 */
	document.admVoteForm.vrSeq.value = $("#vrSeq").val();
	document.admVoteForm.searchType.value=$("#searchType").val();
	document.admVoteForm.searchValue.value=$("#searchValue").val();
	/* 추가 */
	document.admVoteForm.action = "/admin/voteUpload";
	document.admVoteForm.submit();
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
								<li class="breadcrumb-item active">투표자 내역</li>
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
												<div class="row">
													<div class="col-lg-7">
														<h4 class="card-title" style="color: #ffffff;">투표 리스트</h4>
													</div>
												</div>
												
												<div class="ml-auto input-group" style="width: 50%;">
													<select name="vlSearchType" id="vlSearchType"
														class="custom-select" style="width: auto;">
														<option value="">조회 항목</option>
														<option value="1"
															<c:if test='${vlSearchType eq "1"}'>selected</c:if>>아이디</option>
														<option value="2"
															<c:if test='${vlSearchType eq "2"}'>selected</c:if>>시간</option>
													</select> <input type="text" name="vlSearchValue" id="vlSearchValue"
														value="${vlSearchValue}" class="form-control mx-1"
														maxlength="20" style="width: auto; ime-mode: active; height:38px !important;"
														placeholder="조회값을 입력하세요." />
													<button type="button" id="btnSearch"
														class="btn btn-secondary mb-3 mx-1">조회</button>
												</div>
												

												<div class="table-responsive">
													<!-- 테이블 시작 -->
													<table class="table" style="color: #ffffff;">
														<thead style="background-color: rgba(61, 79, 115, 0.5);">
															<tr>
																<th>번호</th>
																<th>투표자 아이디</th>
																<th>투표시간</th>
															</tr>
														</thead>
														<tbody id="items">
															<c:set var="count" value="${paging.totalCount - (listPage -1 ) * paging.listCount}" />
															<c:forEach var="list" items="${list}" varStatus="status">
																<tr>
																	<td>
																		<div class="cell-inner">
																			<span>${count}</span>
																		</div>
																	</td>
																	<td>
																		<div class="cell-inner">
																			<span>${list.vlUserId}</span>
																		</div>
																	</td>
																	<td>
																		<div class="cell-inner">
																			<span>${list.voteDate}</span>
																		</div>
																	</td>
																</tr>
																<c:set var="count" value="${count - 1}" />
															</c:forEach>
														</tbody>
													</table>
													<!-- 테이블 끝 -->

													<!-- 페이징 처리 시작 -->
													<div class="col-lg-12 col-md-12" style="margin: 0 auto;">
														<div class="gen-pagination" style="text-align: center;">
															<nav aria-label="Page navigation" style="display: inline-block;">
																<ul class="page-numbers">
																	<c:if test="${!empty paging}">
																		<c:if test="${paging.prevBlockPage gt 0}">
																			<li>
																				<a class="next page-numbers" href="javascript:void(0)" onclick="fn_listPage(${paging.prevBlockPage})">이전</a>
																			</li>
																		</c:if>

																		<c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
																			<c:choose>
																				<c:when test="${i ne listPage}">
																					<li>
																						<a class="page-numbers" href="javascript:void(0)" onclick="fn_listPage(${i})">${i}</a>
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
																				<a class="next page-numbers" href="javascript:void(0)" onclick="fn_listPage(${paging.nextBlockPage})">다음</a>
																			</li>
																		</c:if>
																	</c:if>
																</ul>
															</nav>
														</div>
													</div>
													<input type="button" onClick="fn_Upload(${curPage})"
										value="뒤로가기">
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

	<form name="admVoteForm" id="admVoteForm" method="post">
		<input type="hidden" name="vrSeq" id="vrSeq" value="${vrSeq}" /> 
		<input type="hidden" name="curPage" id="curPage" value="${curPage}" /> 
		<input type="hidden" name="searchType" id="searchType" value="${searchType}" />
		<input type="hidden" name="searchValue" id="searchValue" value="${searchValue}" /> 
		<input type="hidden" name="vlSearchType" id="vlSearchType" value="${vlSearchType}" /> 
		<input type="hidden" name="vlSearchValue" id="vlSearchValue" value="${vlSearchValue}" /> 
		<input type="hidden" name="listPage" id="listPage" value="${listPage}" />
	</form>

	<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>