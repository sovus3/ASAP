<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>

<style>
input, textarea{
	border: 1px solid #3D4F73 !important;
}

a{
	cursor:pointer;
}
</style>

<script>
	$(document).ready(function() {
		$("#nbTitle").focus();

		$("#btnWrite").on("click", function() {
			//버튼에 대해서 비활성화 처리를 한다.
			$("#btnWrite").prop("disabled", true); //글쓰기 버튼 비활성화 : ajax할때는 이런것까지 고려 2번 저장하면 안되니까.

			if ($.trim($("#nbTitle").val()).length <= 0) 
			{
				$("#nbTitle").val("");
				$("#nbTitle").focus();
				$("#btnWrite").prop("disabled", false); //글쓰기 버튼 활성화
				Swal.fire('제목을 입력하세요.', '', 'info');
				return;
			}
			if ($.trim($("#nbContent").val()).length <= 0) 
			{
				$("#nbContent").val("");
				$("#nbContent").focus();
				$("#btnWrite").prop("disabled", false); //글쓰기 버튼 활성화
				Swal.fire('내용을 입력하세요.', '', 'info');
				return;
			}

			$.ajax({
				type : "POST",
				url : "/admin/adminNoticeWriteProc",
				data : {
					admId : $("#admId").val(),
					nbTitle : $("#nbTitle").val(),
					nbContent : $("#nbContent").val()
				},
				datatype : "JSON",
				beforeSend : function(xhr) {
					xhr.setRequestHeader("AJAX", "true");
				},
				success : function(response) {
					if (response.code == 0) 
					{
						Swal.fire({
							title : '게시물이 등록되었습니다.',
							icon : 'success'
						}).then(function() {
							location.href = "/admin/adminNoticeBoard";
						})
					} 
					else if (response.code == 400) 
					{
						$("#nbTitle").focus();
						$("#btnWrite").prop("disabled", false);
						Swal.fire('파라미터 값이 올바르지 않습니다.', '', 'warning');
					} 
					else 
					{
						$("#nbTitle").focus();
						$("#btnWrite").prop("disabled", false);
						Swal.fire('게시물 등록 중 오류 발생', '', 'error');
					}
				},
				error : function(xhr, status, error) {
					icia.common.error(error);
					$("#btnWrite").prop("disabled", false); //글쓰기버튼 활성화
					Swal.fire('게시물 등록 중 오류가 발생하였습니다.', '', 'error');
				}
			});

		});

		$("#btnList").on("click", function() {
			document.bbsForm.action = "/admin/adminNoticeBoard";
			document.bbsForm.submit();
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
										<div class="col-lg-12 grid-margin stretch-card" style="background-color:#221f1f !important;">
											<div class="card" style="background-color:#221f1f !important;">
												<div class="card-body" style="background-color:#221f1f !important;">
													<form name="writeForm" id="writeForm" method="post">
						                                <div class="row">
						                                    <div class="col-xl-12 col-md-12">
						                                        <p class="comment-form-author">
						                                        	<label>관리자 아이디</label>
						                                            <input type="text" name="admId" id="admId" value="${admin.admId}" readonly>
						                                        </p>
						                                    </div>
						                                    <div class="col-xl-12 col-md-12">
						                                        <p class="comment-form-email">
						                                        	<label>제목</label>
						                                            <input type="text" name="nbTitle" id="nbTitle" placeholder="제목을 입력해주세요." required>
						                                        </p>
						                                    </div>
						                                    
						                                    <div class="col-xl-12">
						                                        <p class="comment-form-comment">
						                                        	<label>내용</label>
						                                            <textarea name="nbContent" id="nbContent" rows="6" cols="60" placeholder="내용을 입력해주세요" required></textarea>
						                                        </p>
						                                    </div>
						                                </div>
														
						                                <a class="gen-button mt-5" id="btnWrite">
														   <span class="text">저장</span>
														</a>
														<a class="gen-button mt-5" id="btnList" style="background-color:gray;">
														   <span class="text">리스트</span>
														</a>
						                            </form>
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
      <input type="hidden" name="searchType" value="" />
      <input type="hidden" name="searchValue" value="" />
      <input type="hidden" name="curPage" value="" />
   </form>
   
   <%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>