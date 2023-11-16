<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>

<style>
input[type="date"]::-webkit-calendar-picker-indicator {
	filter: invert(1); /* 달력 아이콘을 하얀색으로 변경 */
}
</style>

<script>
$(document).ready(function() {
   
	$("#btnProductUpload").on("click", function() {

		$("#btnProductUpload").prop("disabled", true);

		if ($.trim($("#productName").val()).length <= 0) 
		{
			$("#productName").val("");
			$("#productName").focus();
			$("#btnProductUpload").prop("disabled", false);
			Swal.fire('상품명은 필수 입력사항입니다.', '', 'info');
			return;
		}
      
		if ($.trim($("#productPrice").val()).length <= 0) 
		{
			$("#productPrice").val("");
			$("#productPrice").focus();
			$("#btnProductUpload").prop("disabled", false);
			Swal.fire('상품 가격은 필수 입력사항입니다.', '', 'info');
			return;
		}
      
		if ($.trim($("#productQuantity").val()).length <= 0) 
		{
			$("#productQuantity").val("");
			$("#productQuantity").focus();
			$("#btnProductUpload").prop("disabled", false);
			Swal.fire('재고 수량은 필수 입력사항입니다.', '', 'info');
			return;
		}
      
		if ($.trim($("#productStartDate").val()).length <= 0) 
		{
			$("#productStartDate").val("");
			$("#productStartDate").focus();
			$("#btnProductUpload").prop("disabled", false);
			Swal.fire('상품 판매 시작일은 필수 입력사항입니다.', '', 'info');
			return;
		}

		if ($.trim($("#productEndDate").val()).length <= 0) 
		{
			$("#productEndDate").val("");
			$("#productEndDate").focus();
			$("#btnProductUpload").prop("disabled", false);
			Swal.fire('상품 판매 종료일은 필수 입력사항입니다.', '', 'info');
			return;
		}
		
		if ($.trim($("#productDetail").val()).length <= 0) 
		{
			$("#productDetail").val("");
			$("#productDetail").focus();
			$("#btnProductUpload").prop("disabled", false);
			Swal.fire('상품 설명은 필수 입력사항입니다.', '', 'info');
			return;
		}
		
		var fileCheck = $("#productFile").val()
		
		if (!fileCheck) 
		{
			$("#btnProductUpload").prop("disabled", false);
			Swal.fire('상품 사진을 첨부하세요.', '', 'info');
			return;
		}
                  
		var form = $("#productUploadForm")[0];
		var formData = new FormData(form);

		$.ajax({
			type : "POST",
			url : "/admin/productUploadProc",
			enctype : "multipart/form-data",
			processData : false,
			contentType : false,
			data : formData,
			timeout : 60000,
			beforeSend : function(xhr) {
			   xhr.setRequestHeader("AJAX", "true");
			},
			success : function(result) {
				if (result.code == 1) 
				{
					Swal.fire({
						title: '상품이 등록됐습니다.', 
						icon: 'success'
					}).then(function(){
						location.href = "/admin/product";
					})
				} 
				else if (result.code == 0) 
				{
					$("#btnProductUpload").prop("disabled", false);
					$("#productName").val();
					Swal.fire('상품 등록 중 오류가 발생했습니다.', '', 'warning');
				} 
				else if (result.code == 400) 
				{
					$("#btnProductUpload").prop("disabled", false);
					$("#productName").val();
					Swal.fire('파라미터가 부족합니다.', '', 'warning');
				}
			},
			error : function(error) {
				icia.common.error(error);
			}
		}); 
	});
});

function fn_list()
{
	document.bbsForm.action = "/admin/product";
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
							<h1>상품 올리기</h1>
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
							<li><a href="#">회원</a></li>
							<li><a href="#">경매</a></li>
							<li><a href="#">이벤트 경매</a></li>
							<li><a href="#">투표</a></li>
							<li><a href="#">쇼핑</a></li>
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
									<!-- 상품 업로드 -->
									<div class="container">
										<div class="row">
											<div class="col-lg-12">
												<form name="productUploadForm" id="productUploadForm" method="post" enctype="multipart/form-data">
													<i class="fa fa-times" aria-hidden="true" style="float: right !important; margin-right: 100px; cursor: pointer;" onclick="fn_list()"></i>
													<div class="gen-register-form">
														<h2>상품 올리기</h2><br> 
														
														<label>상품명 *</label><br> 
														<input type="text" style="width: 50%;" id="productName" name="productName" value="" /> <br><br> 
														
														<label>상품 가격 *</label><br> 
														<input type="number" style="width: 30%;" id="productPrice" name="productPrice" placeholder="숫자만 입력해주세요." value=""><br><br> 
														
														<label>재고 수량 *</label><br> 
														<input type="number" style="width: 30%;" id="productQuantity" name="productQuantity" placeholder="숫자만 입력해주세요." value=""><br><br> 
														
														<label>상태 *</label><br> 
														<select name="status" id="status" style="width: 30%;">
															<option value="Y">Y</option>
															<option value="N">N</option>
														</select><br><br> 
														
														<label>상품 판매 시작일 *</label><br> 
														<input type="date" style="width: 30%;" id="productStartDate" name="productStartDate" value=""> <br><br> 
														
														<label>상품 판매 종료일 *</label><br> 
														<input type="date" style="width: 30%;" id="productEndDate" name="productEndDate" value=""> <br><br> 
														
														<label>상품 설명 *</label><br>
														<textarea id="productDetail" name="productDetail" rows="6" cols="60" placeholder="상품 설명을 작성해주세요." style="resize: none;"></textarea>
														<br><br><br><br> 
														
														<label>상품 사진 첨부 *</label><br> 
														<input type="file" id="productFile" name="productFile" class="mb-5">
													</div>
												</form>
												<div class="form-button mt-3">
													<input type="button" id="btnProductUpload" name="btnProductUpload" value="신청하기" class="mb-0">
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
		</div>
	</section>

	<!-- 상품 업로드 -->
	<form name="bbsForm" id=bbsForm method="post"></form>

	<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>