<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>

<style>
a {
	cursor:pointer !important;
}
</style>

<script>
$(document).ready(function() {

	$("#btnList").on("click", function() {
		document.bbsForm.action="/admin/adminQnaBoard";
		document.bbsForm.submit();
	});
	
	$("#btnUpdate").on("click", function() {
		document.bbsForm.action="/admin/adminQnaUpdate";
		document.bbsForm.submit();
	});
	
	$("#btnReply").on("click", function() {
		document.bbsForm.action="/admin/adminQnaReply";
		document.bbsForm.submit();
	});
   
	$("#btnDelete").on("click", function(){
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
					url:"/admin/adminQnaDelete",
					data:{
						qaSeq:<c:out value="${qaSeq}"/>
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
								location.href="/admin/adminQnaBoard";
							})
						}
						else if(response.code == 404)
						{
							Swal.fire({
								title: '해당 게시물을 찾을 수 없습니다.', 
								icon: 'warning'
							}).then(function(){
								location.href="/admin/adminQnaBoard";
							})
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
   });
});
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
							<li><a href="/admin/voteList">투표</a></li>
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

												<!-- 게시물 상세 1개 시작 -->
												<div class="gen-blog-post">
													<div class="gen-blog-contain">
														<h2>
															<c:out value="${qnaBoard.qaTitle}" />
														</h2>
														<br>
														<div class="gen-post-meta">
															<ul>
																<li class="gen-post-author">
																	<i class="fa fa-user"></i>
																	<c:out value="${qnaBoard.userId}" /> 
																	<c:out value="${qnaBoard.admId}" />
																	<!--추가된 부분-->
																</li>
																<li class="gen-post-meta">
																	<a href="#">
																		<i class="fa fa-calendar"></i>${qnaBoard.regDate}
																	</a>
																</li>
																<li class="gen-post-tag">
																	<a href="#">
																		<i class="fa fa-tag"></i>문의사항
																	</a>
																</li>
															</ul>
														</div>
														<p>
															<c:out value="${qnaBoard.qaContent}" />
														</p>
													</div>
												</div>
												<!-- 게시물 상세 1개 끝 -->

												<!-- 버튼 시작 -->
												<c:if test="${boardMe eq 'Y'}">
													<a class="gen-button gen-button-flat ml-3" id="btnList">
														<span class="text">리스트</span>
													</a>
													<a class="gen-button gen-button-flat" id="btnReply" style="background-color: #4E64A6;"> 
														<span class="text">답변</span>
													</a>
													<a class="gen-button gen-button-flat" id="btnDelete" style="background-color: gray;"> 
														<span class="text">삭제</span>
													</a>
												</c:if>
												<br /> <br />
												<!-- 버튼 끝 -->
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
		<input type="hidden" name="qaSeq" id="qaSeq" value="${qnaBoard.qaSeq}" />
		<input type="hidden" name="searchType" value="${searchType}" />
		<input type="hidden" name="searchValue" value="${searchValue}" />
		<input type="hidden" name="curPage" value="${curPage}" />
	</form>
	
 	<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>