<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>

<style>
</style>

<script>
function fn_back(){
	document.bbsForm.action = "/admin/product";
	document.bbsForm.submit();
}
function fn_update(){
	Swal.fire({
		title: '게시물을 수정하시겠습니까?',
		icon: 'info',
		showCancelButton: true,
		confirmButtonColor: '#3085d6',
		cancelButtonColor: '#d33',
		confirmButtonText: '확인',
		cancelButtonText: '취소'
	}).then((result) => {
		if (result.isConfirmed) {

			var form = $("#productUpdateForm")[0];
			var formData = new FormData(form);
			 	   
			$.ajax({
				type : "POST",
				url : "/admin/productUpdatedProc",
				enctype : "multipart/form-data",
				processData : false,
				contentType : false,
				data : formData,
				timeout : 60000,
				beforeSend : function(xhr) {
					xhr.setRequestHeader("AJAX", "true");
				},
				success : function(result) {
					if (result.code == 1) {
						Swal.fire({
							title: '상품이 등록되었습니다.', 
							icon: 'success'
						}).then(function(){
							location.href = "/admin/product";
						})
					} 
					else if (result.code == 0) 
					{
						Swal.fire('상품 등록 중 오류가 발생했습니다.', '', 'warning');
					} 
					else if (result.code == 400) 
					{
						Swal.fire('회원 및 관리자가 아닙니다.', '', 'warning');
					} 
					else if (result.code == 200) 
					{
						Swal.fire('파라미터가 부족합니다.', '', 'warning');
					} 
					else 
					{
						Swal.fire('관리자가 아닙니다.', '', 'error');
					}
				},
				error : function(error) {
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
							<h1>상품 구매</h1>
						</div>
						<div class="gen-breadcrumb-container">
							<ol class="breadcrumb">
								<li class="breadcrumb-item">
									<a href="index.html"> 
										<i class="fas fa-home mr-2"></i> 홈
									</a>
								</li>
								<li class="breadcrumb-item active">상품 수정</li>
							</ol>
						</div>
					</nav>
				</div>
			</div>
		</div>
	</div>
	<!-- breadcrumb -->

	<!-- Shop Detail Start -->
	<br>
	<div style="text-align: center;">
		<button style="cursor: pointer; border-color: #FAFAD2; background-color: #221f1f; color: white;" onclick="fn_back()">목록</button>
		<button style="cursor: pointer; border-color: #FAFAD2; background-color: #221f1f; color: white;" onclick="fn_update()">수정</button>
	</div>
	<form name="productUpdateForm" id="productUpdateForm" method="post" enctype="multipart/form-data">
		<div class="container-fluid py-5" style="width: 80%;">
			<div class="row px-xl-5">
				<div class="col-lg-5 pb-5">
					<div id="product-carousel" class="carousel slide" data-ride="carousel">
						<div class="carousel-inner border">
							<div class="carousel-item active">
								<img class="w-100 h-100" src="/resources/upload/product/${product.productSeq}.png" alt="Image">
							</div>
						</div>
					</div>
				</div>
				<input type="hidden" name="productSeq" id="productSeq" value="${product.productSeq}" />
				<div class="col-lg-7 pb-5" style="margin: auto;!important;">
					상품명&nbsp; : &nbsp;
					<div class="d-flex mb-3">
						<input type="text" style="width: 50%;" class="font-weight-semi-bold" id="productName" name="productName" value="${product.productName}">
					</div>
					상품 가격&nbsp; : &nbsp;
					<div class="d-flex mb-3">
						<input type="number" style="width: 30%;" id="productPrice" name="productPrice" value="${product.productPrice}">
					</div>
					현재 재고&nbsp; : &nbsp;
					<div class="d-flex mb-3">
						<input type="number" style="width: 30%;" id="productQuantity" name="productQuantity" value="${product.productQuantity}">
					</div>
					판매상태 :
					<div class="d-flex mb-3">
						<select name="status" id="status" style="width: 30%;">
							<option value="Y">Y</option>
							<option value="N">N</option>
						</select>
					</div>

					<div class="d-flex mb-3">
						상품 판매 시작일&nbsp; : &nbsp; 
						<input type="text" style="width: 20%;" id="productStartDate" name="productStartDate" value="${product.productStartDate}">
						&nbsp;&nbsp; 상품 판매 종료일&nbsp; : &nbsp; 
						<input type="text" style="width: 20%;" id="productEndDate" name="productEndDate" value="${product.productEndDate}">
					</div>
				</div>

			</div>

			<div class="row px-xl-5">
				<div class="col">
					<div class="nav nav-tabs justify-content-center border-secondary mb-4">
						<a class="nav-item nav-link active" data-toggle="tab" href="#tab-pane-1">상세정보</a>
					</div>
					<div class="tab-content">
						<div class="tab-pane fade show active" id="tab-pane-1">
							<textarea id="productDetail" name="productDetail" rows="10" cols="60" style="resize: none;">${product.productDetail}</textarea>
						</div>
					</div>
				</div>
			</div>
		</div>
	</form>
	<!-- Shop Detail End -->


	<form name="bbsForm" id="bbsForm" method="post">
		<input type="hidden" name="productSeq" value="" /> 
		<input type="hidden" name="curPage" value="${curPage}" />
	</form>
	
	<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>