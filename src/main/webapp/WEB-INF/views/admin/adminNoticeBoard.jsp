<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>

<style>
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

label {
	cursor: pointer !important;
}
</style>

<script>
$(document).ready(function() {
    
   $("#divWrite").on("click", function() {
     	document.bbsForm.nbSeq.value="";
     	document.bbsForm.action ="/admin/adminNoticeWrite";
     	document.bbsForm.submit();
   });
   
   $("#btnSearch").on("click",function(){
		document.bbsForm.nbSeq.value="";	
	    document.bbsForm.searchType.value=$("#_searchType").val();
		document.bbsForm.searchValue.value=$("#_searchValue").val();
		document.bbsForm.curPage.value="1";
		document.bbsForm.action="/admin/adminNoticeBoard";
		document.bbsForm.submit();
	});
});
//공지사항 상세보기
function fn_view(nbSeq)		
{
	document.bbsForm.nbSeq.value= nbSeq;
	document.bbsForm.action="/admin/adminNoticeView";
	document.bbsForm.submit();
}

//공지사항 수정
function fn_update(nbSeq)		
{
	document.bbsForm.nbSeq.value= nbSeq;
	document.bbsForm.action="/admin/adminNoticeUpdate";
	document.bbsForm.submit();
}

//공지사항 삭제
function fn_delete(value)		
{
	Swal.fire({
		title: '게시물을 삭제하시겠습니까?',
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
				url:"/admin/adminNoticeDelete",
				data:{
					nbSeq:value
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
							title: '게시물이 삭제되었습니다.', 
							icon: 'success'
						}).then(function(){
							location.href = "/admin/adminNoticeBoard";
						})
					}
					else if(response.code == 404)
					{
						Swal.fire({
							title: '해당 게시물을 찾을 수 없습니다.', 
							icon: 'warning'
						}).then(function(){
							location.href = "/admin/adminNoticeBoard";
						})
					}
					else if(response.code == 403)
					{
						Swal.fire('본인 글이 아니므로 삭제할 수 없습니다.', '', 'warning');
					}
					else if(response.code == 400)
					{
						Swal.fire('파라미터 값이 올바르지 않습니다.', '', 'warning');
					}
					else
					{
						Swal.fire('게시물 삭제 중 오류가 발생하였습니다.', '', 'error');
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

//공지사항 페이징
function fn_list(curPage)
{
	document.bbsForm.nbSeq.value="";	
	document.bbsForm.curPage.value = curPage;
	document.bbsForm.action="/admin/adminNoticeBoard";
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
												<div class="row">
													<div class="col-lg-7">
														<h4 class="card-title" style="color: #ffffff;">공지사항 게시판</h4>
													</div>
													<div class="col-lg-5" id="divWrite">
														<h5 style="float: right;">
															<label class="badge badge-primary">
																<i class="fa fa-paint-brush" aria-hidden="true"></i> 글 작성
															</label>
														</h5>
													</div>
												</div>
												
												<!-- 검색 시작 -->
												<form id="search-form" class="mb-3 mt-3" style="border: #000000;">
													<div class="row">
														<div class="col-12">
															<div class="row no-gutters">
																<div class="col-lg-3 col-md-3 col-sm-12 p-0">
																	<select class="form-control" name="_searchType" id="_searchType">
																		<option value="">조회 항목</option>
																		<option value="1" <c:if test = '${searchType eq "1"}'>selected</c:if>>제목</option>
																		<option value="2" <c:if test = '${searchType eq "2"}'>selected</c:if>>내용</option>
																	</select>
																</div>

																<div class="col-lg-8 col-md-8 col-sm-12 p-0">
																	<input type="text" placeholder="Search..." class="form-control" name="_searchValue" id="_searchValue" value="">
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

												<div class="table-responsive">
													<!-- 테이블 시작 -->
													<table class="table" style="color: #ffffff;">
														<thead style="background-color: rgba(61, 79, 115, 0.5);">
															<tr>
																<th>번호</th>
																<th>관리자 아이디</th>
																<th>제목</th>
																<th>등록일</th>
																<th></th>
															</tr>
														</thead>
														<tbody>
															<c:if test="${!empty list}">
																<c:set var="startNum" value="${paging.startNum}" />
																<c:forEach var="noticeBoard" items="${list}" varStatus="status">
																	<tr>
																		<td>${startNum}</td>
																		<td>${noticeBoard.admId}</td>
																		<td>
																			<a href="javascript:void(0)" onclick="fn_view(${noticeBoard.nbSeq})" style="color: #ffffff;"> 
																				<span>
																					<c:out value="${noticeBoard.nbTitle}" />
																				</span>
																			</a>
																		</td>
																		<td>${noticeBoard.regDate}</td>
																		<td>
																			<label class="badge badge-warning" onclick="fn_update(${noticeBoard.nbSeq})">수정</label>
																			&nbsp; 
																			<label class="badge badge-danger" onclick="fn_delete(${noticeBoard.nbSeq})">삭제</label>
																		</td>
																	</tr>
																	<c:set var="startNum" value="${startNum-1}"></c:set>
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
	</section>

	<form name="bbsForm" id="bbsForm" method="post">
		<input type="hidden" name="nbSeq" value="" /> 
		<input type="hidden" name="searchType" value="${searchType}" /> 
		<input type="hidden" name="searchValue" value="${searchValue}" /> 
		<input type="hidden" name="curPage" value="${curPage}" />
	</form>

	<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>