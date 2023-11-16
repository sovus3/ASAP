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

label {
	cursor: pointer !important;
}
</style>

<script>

$(document).ready(function(){
	
	$("#btnSearch").on("click",function(){		
		document.searchForm.curPage.value = "1";
		document.searchForm.action="/admin/userList";
		document.searchForm.submit();
	});
	
	$(".userInfoUpdate").click(function(){		
		var userId = $(this).next().val();
		document.searchForm.userId2.value = userId;
		document.searchForm.action="/admin/userUpdate";
		document.searchForm.submit();
	});
	
	$(".artAccess").click(function(){
		var userId = $(this).next().val();
		document.searchForm.userId2.value = userId;
		
		$.ajax({
			type: "POST",
			url: "/admin/userCodeUpdate",
			data:{
				userId: userId
			},
  			beforeSend : function(xhr) {
   				xhr.setRequestHeader("AJAX", "true");
   			},
   			success : function(result) {
   				if (result.code == 1) 
   				{
   					Swal.fire({
						title: '작가승인이 완료됐습니다.', 
						icon: 'success'
					}).then(function(){
						document.searchForm.action="/admin/userList";
	   					document.searchForm.submit();
					})
   				} 
   				else if (result.code == 0) 
   				{
   					Swal.fire({
						title: '작가신청 승인 중 오류가 발생했습니다.', 
						icon: 'warning'
					}).then(function(){
						document.searchForm.action="/admin/userList";
	   					document.searchForm.submit();
					})
   				} 
   				else if (result.code == 400) 
   				{
					Swal.fire({
						title: '관리자가 아닙니다.', 
						icon: 'warning'
					}).then(function(){
						location.href = "/";
					})
   				}
   				else
   				{
   					Swal.fire({
						title: '기타 오류가 발생했습니다.', 
						icon: 'error'
					}).then(function(){
						location.href="/";
					})
   				}
   			},
   			error : function(error) {
   				icia.common.error(error);
   			}
		});
	});
});

function fn_list(curPage){	
	document.searchForm.curPage.value = curPage;
	document.searchForm.action="/admin/userList";
	document.searchForm.submit();
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
								<li class="breadcrumb-item active">관리자</li>
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
								<hr>
								<div class="container bootstrap snippets bootdey">
									<br>
									<h4>회원관리</h4>
									<!-- 날짜 검색 시작 -->
									<form name="searchForm" id="searchForm" method="post">

										<div class="row">
											<div class="col-lg-12 mb-3 mt-3">
												<select id="status" name="status" style="font-size: 1rem; width: 8rem; height: 3rem;">
													<option value="">회원상태</option>
													<option value="Y" <c:if test="${status == 'Y'}">selected</c:if>>정상</option>
													<option value="N" <c:if test="${status == 'N'}">selected</c:if>>정지</option>
												</select> 
												<select id="userCode" name="userCode" style="font-size: 1rem; width: 10rem; height: 3rem; margin-left: .5rem;">
													<option value="">회원구분</option>
													<option value="U" <c:if test="${userCode == 'U'}">selected</c:if>>일반회원</option>
													<option value="A" <c:if test="${userCode == 'A'}">selected</c:if>>작가회원</option>
													<option value="W" <c:if test="${userCode == 'W'}">selected</c:if>>작가승인예정</option>
												</select>
											</div>
										</div>
										<!-- 날짜 검색 끝 -->

										<!-- 검색 창 시작 -->
										<div class="row">
											<div class="col-lg-12 mb-3 mt-3">
												<input type="text" placeholder="아이디 검색..." class="form-control" name="userIdSeacrch" id="userIdSeacrch" value="${userIdSeacrch}" style="font-size: 1rem; width: 15rem; height: 3rem;">

												<button type="button" id="btnSearch" class="btn btn-base" style="color: #ffffff;">
													<svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-search">
														<circle cx="11" cy="11" r="8"></circle>
														<line x1="21" y1="21" x2="16.65" y2="16.65"></line>
													</svg>
												</button>
											</div>
										</div>

										<input type="hidden" id="curPage" name="curPage" value="${curPage}" />


										<!-- 검색 창 끝 -->
										<div class="row">
											<!--/col-3-->
											<div class="col-lg-12">
												<!-- 결제내역 1개 시작 -->
												<table>
													<thead style="background-color: rgba(61, 79, 115, 0.3); color: #ffffff;">
														<tr>
															<th>번호</th>
															<th>아이디</th>
															<th>닉네임</th>
															<th>회원상태</th>
															<th>일반/작가</th>
															<th>작가신청여부</th>
															<th>충전금</th>
															<th>확인&수정</th>
														</tr>
													</thead>
													<tbody>
														<c:if test="${!empty list}">
															<c:set var="startNum" value="${paging.startNum}" />
															<c:forEach var="user" items="${list}" varStatus="status">
																<tr>
																	<td>
																		<div class="cell-inner">
																			<span>${startNum}</span>
																		</div>
																	</td>
																	<td>
																		<div class="cell-inner">
																			<span>${user.userId}</span>
																		</div>
																	</td>
																	<td>
																		<div class="cell-inner">
																			<span>${user.userNick}</span>
																		</div>
																	</td>
																	<td>
																		<div class="cell-inner">
																			<c:choose>
																				<c:when test="${user.status == 'N'}">
																					<span>탈퇴</span>
																				</c:when>
																				<c:when test="${user.status == 'Y'}">
																					<span>정상</span>
																				</c:when>
																			</c:choose>
																		</div>
																	</td>
																	<td>
																		<div class="cell-inner">
																			<c:choose>
																				<c:when test="${user.userCode == 'U'}">
																					<span>일반</span>
																				</c:when>
																				<c:when test="${user.userCode == 'A'}">
																					<span>작가</span>
																				</c:when>
																				<c:when test="${user.userCode == 'W'}">
																					<span>작가승인대기</span>
																				</c:when>
																			</c:choose>
																		</div>
																	</td>
																	<td>
																		<div class="cell-inner">
																			<c:choose>
																				<c:when test="${user.userCode == 'W'}">
																					<input type="button" class="artAccess"
																						id="artAccess" value="승인">
																					<input type="hidden" id="updateUserId"
																						name="updateUserId" value="${user.userId}">
																				</c:when>
																				<c:otherwise>
																					<span>미신청</span>
																				</c:otherwise>
																			</c:choose>
																		</div>
																	</td>
																	<td>
																		<div class="cell-inner">
																			<span>${user.userCharge}</span>
																		</div>
																	</td>
																	<td>
																		<div class="cell-inner">
																			<input type="button" class="userInfoUpdate"
																				id="userInfoUpdate" value="확인및수정"> <input
																				type="hidden" id="updateUserId" name="updateUserId"
																				value="${user.userId}">
																		</div>
																	</td>
																</tr>
																<c:set var="startNum" value="${startNum-1}"></c:set>
															</c:forEach>
														</c:if>
													</tbody>
												</table>
												<input type="hidden" id="userId2" name="userId2" value="">
											</div>
										</div>
									</form>
									
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

									<!-- 결제내역 1개 끝 -->
								</div>
							</div>
							<!--/col-9-->
						</div>
						<!--/row-->
					</div>
				</div>
			</div>
		</div>
		<!-- 문의내역 끝 -->
	</section>
	<!-- Blog-left-Sidebar -->

	<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>