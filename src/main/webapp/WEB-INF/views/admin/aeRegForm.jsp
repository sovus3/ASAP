<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>

<script>

	$(document).ready(function() {

		$("#aeTitle").focus();

		$("#btnAeUpload").on("click", function() {

			$("#btnAeUpload").prop("disabled", true);

			if ($.trim($("#aeTitle").val()).length <= 0) 
			{
				$("#aeTitle").val("");
				$("#aeTitle").focus();
				$("#btnAeUpload").prop("disabled", false);
				Swal.fire('제목은 필수 입력사항입니다.', '', 'info');
				return;
			}

			if ($.trim($("#aeProductTitle").val()).length <= 0) 
			{
				$("#aeProductTitle").val("");
				$("#aeProductTitle").focus();
				$("#btnAeUpload").prop("disabled", false);
				Swal.fire('내용은 필수 입력사항입니다.', '', 'info');
				return;
			}

			if ($.trim($("#aeStartPrice").val()).length <= 0) 
			{
				$("#aeStartPrice").val("");
				$("#aeStartPrice").focus();
				$("#btnAeUpload").prop("disabled", false);
				Swal.fire('시작가를 입력하지 않을 시 "0원"으로 설정됩니다.', '', 'info');
				return;
			}

			var b_fileCheck = $("#bannerFile").val()

			if (!b_fileCheck) 
			{
				$("#btnAeUpload").prop("disabled", false);
				Swal.fire('배너 사진을 첨부하세요.', '', 'info');
				return;
			}

			var m_fileCheck = $("#mainFile").val()

			if (!m_fileCheck) 
			{
				$("#btnAeUpload").prop("disabled", false);
				Swal.fire('상품 사진을 첨부하세요.', '', 'info');
				return;
			}

			var d_fileCheck = $("#detailFile").val()

			if (!d_fileCheck) 
			{
				$("#btnAeUpload").prop("disabled", false);
				Swal.fire('설명 사진을 첨부하세요.', '', 'info');
				return;
			}

			var form = $("#aeUploadForm")[0];
			var formData = new FormData(form);

			$.ajax({
				type : "POST",
				url : "/admin/aeRegFormProc",
				enctype : "multipart/form-data",
				processData : false,
				contentType : false,
				data : formData,
				timeout : 60000,
				beforeSend : function(xhr) {
					xhr.setRequestHeader("AJAX", "true");
				},
				success : function(response) {
					if (response.code == 0) 
					{
						Swal.fire({
							title : '작품이 등록됐습니다.',
							icon : 'success'
						}).then(function() {
							location.href = "/admin/aeRegForm";
						})
					} 
					else if (response.code == 100) 
					{
						$("#btnAeUpload").prop("disabled", false);
						$("#aeTitle").val();
						Swal.fire('오류가 발생하였습니다.', '', 'warning');
					} 
					else if (response.code == 400) 
					{
						$("#btnAeUpload").prop("disabled", false);
						$("#aeTitle").val();
						Swal.fire('파라미터 오류입니다.', '', 'warning');
					} 
					else 
					{
						Swal.fire('기타 오류가 발생하였습니다.', '', 'error');
					}
				},
				error : function(error) {
					icia.common.error(error);
				}
			});
		});
	});
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

				<!-- 투표 작품 신청 폼 -->
				<div class="col-lg-9 col-md-12 order-1 order-xl-2">
					<div class="gen-blog gen-blog-col-1">
						<div class="row">
							<div class="col-lg-12">
								<form name="aeUploadForm" id="aeUploadForm" method="post" enctype="multipart/form-data">
									<div class="gen-register-form">
										<h2>이벤트경매 올리기</h2>

										<label>경매 이름 *</label><br> 
										<input type="text" id="aeTitle" name="aeTitle"> 
										
										<label>상품 이름 *</label><br>
										<input type="text" id="aeProductTitle" name="aeProductTitle">

										<label>시작가 *</label><br> 
										<input type="text" id="aeStartPrice" name="aeStartPrice"> 
										
										<label>경매 시작시간</label><br> 
										<input type="text" id="aeStartTime" name="aeStartTime"> 
										
										<label>경매 종료시간</label><br> 
										<input type="text" id="aeEndTime" name="aeEndTime"> 
										
										<label>배너 사진 첨부 *</label><br> 
										<input type="file" id="bannerFile" name="bannerFile"> 
										
										<label>상품 사진 첨부 *</label><br>
										<input type="file" id="mainFile" name="mainFile"> 
										
										<label>설명 사진 첨부 *</label><br> 
										<input type="file" id="detailFile" name="detailFile"><br><br><br>
									</div>
								</form>
								<div class="form-button">
									<input type="button" id="btnAeUpload" name="btnAeUpload" value="등록하기">
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</section>
	<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>