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
	
	if($.trim($("#productName").val()).length <= 0){
        $("#productName").val("");
        $("#productName").focus();
        Swal.fire("상품명을 입력하세요.", '', 'info');
        return;
     }

     if($.trim($("#productPrice").val()).length <= 0){
        $("#productPrice").val("");
        $("#productPrice").focus();
        Swal.fire("상품 가격을 입력하세요.", '', 'info');
        return;
     }

     if($.trim($("#productQuantity").val()).length <= 0){
        $("#productQuantity").val("");
        $("#productQuantity").focus();
        Swal.fire("수량을 입력하세요.", '', 'info');
        return;
     }

     if($.trim($("#productStartDate").val()).length <= 0){
        $("#productStartDate").val("");
        $("#productStartDate").focus();
        Swal.fire("판매 시작일을 입력하세요.", '', 'info');
        return;
     }
        
     if($.trim($("#productEndDate").val()).length <= 0){
         $("#productEndDate").val("");
         $("#productEndDate").focus();
         Swal.fire("판매 종료일을 입력하세요.", '', 'info');
         return;
      }
        
      if($.trim($("#productDetail").val()).length <= 0){
          $("#productDetail").val("");
          $("#productDetail").focus();
          Swal.fire("상품 상세설명을 입력하세요.", '', 'info');
          return;
       }
      
	Swal.fire({
		title: '상품정보를 수정하시겠습니까?',
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
						Swal.fire('빈칸을 채워주세요.', '', 'warning');
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
<div class="container-scroller">
		<!-- partial:/partials/_navbar.html -->
		<%@ include file="/WEB-INF/views/include/navigation.jsp"%>
		<!-- partial -->
		 <div class="container-fluid page-body-wrapper">
        <!-- partial:/partials/_sidebar.html -->
        			 <nav class="sidebar sidebar-offcanvas" id="sidebar">
            <ul class="nav">
               <li class="nav-item nav-category" style="margin-bottom:10px;"></li>
               <li class="nav-item"><a class="nav-link"
                  href="/admin/userList"> <span class="icon-bg"><i
                        class="mdi mdi-settings menu-icon"></i></span> <span class="menu-title">회원</span>
               </a></li>
               <li class="nav-item"><a class="nav-link"
                  href="/admin/voteUpload"> <span class="icon-bg"><i
                        class="mdi mdi-settings menu-icon"></i></span> <span class="menu-title">투표</span>
               </a></li>
               <li class="nav-item"><a class="nav-link"
                  data-toggle="collapse" href="#ui-basic1" aria-expanded="false"
                  aria-controls="ui-basic"> <span class="icon-bg"><i
                        class="mdi mdi-settings menu-icon"></i></span> <span class="menu-title">경매</span>
                     <i class="menu-arrow"></i>
               </a>
                  <div class="collapse" id="ui-basic1">
                     <ul class="nav flex-column sub-menu">
                        <li class="nav-item"><a class="nav-link"
                           href="/admin/adminAuction">경매 업로드</a></li>
                        <li class="nav-item"><a class="nav-link"
                           href="/admin/adminAucCurList">경매 입찰내역</a></li>
                        <li class="nav-item"><a class="nav-link"
                           href="/admin/adminAucBuyPriceList">경매 낙찰내역</a></li>
                     </ul>
                  </div></li>
               <li class="nav-item"><a class="nav-link"
                  data-toggle="collapse" href="#ui-basic2" aria-expanded="false"
                  aria-controls="ui-basic"> <span class="icon-bg"><i
                        class="mdi mdi-settings menu-icon"></i></span> <span class="menu-title">이벤트
                        경매</span> <i class="menu-arrow"></i>
               </a>
                  <div class="collapse" id="ui-basic2">
                     <ul class="nav flex-column sub-menu">
                        <li class="nav-item"><a class="nav-link"
                           href="/admin/aucEvent">이벤트경매 관리</a></li>
                        <li class="nav-item"><a class="nav-link"
                           href="/admin/aeCur">이벤트경매 입찰내역</a></li>
                     </ul>
                  </div></li>
               
               <li class="nav-item"><a class="nav-link"
                  data-toggle="collapse" href="#ui-basic3" aria-expanded="false"
                  aria-controls="ui-basic"> <span class="icon-bg"><i
                        class="mdi mdi-settings menu-icon"></i></span> <span class="menu-title">상품 및 결제 관리</span> <i class="menu-arrow"></i>
               </a>
                  <div class="collapse" id="ui-basic3">
                     <ul class="nav flex-column sub-menu">
                        <li class="nav-item"><a class="nav-link"
                           href="/admin/product">상품 관리</a></li>
                        <li class="nav-item"><a class="nav-link"
                           href="/admin/payList">결제 내역</a></li>
                     </ul>
                  </div></li>
               <li class="nav-item"><a class="nav-link"
                  data-toggle="collapse" href="#ui-basic4" aria-expanded="false"
                  aria-controls="ui-basic"> <span class="icon-bg"><i
                        class="mdi mdi-settings menu-icon"></i></span> <span class="menu-title">게시판</span>
                     <i class="menu-arrow"></i>
               </a>
                  <div class="collapse" id="ui-basic4">
                     <ul class="nav flex-column sub-menu">
                        <li class="nav-item"><a class="nav-link"
                           href="/admin/adminNoticeBoard">공지사항 게시판</a></li>
                        <li class="nav-item"><a class="nav-link"
                           href="/admin/adminQnaBoard">문의사항 게시판</a></li>
                     </ul>
                  </div>
                  </li>
               <li class="nav-item sidebar-user-actions" style="margin-top:30px;">
                  <div class="user-details">
                     <div class="d-flex justify-content-between align-items-center">
                        <div>
                           <div class="d-flex align-items-center">
                              <div class="sidebar-profile-img" style="margin-top:-10px;">
                                 <i class="mdi mdi-account-star" style="font-size:20px;"></i>                                  
                              </div> 
                              <div class="sidebar-profile-text">
                                 <p class="mb-1" style="color:white;">${gnbAdmId }</p>
                              </div>
                           </div>
                        </div>
                     </div>
                  </div>
               </li>
               <li class="nav-item sidebar-user-actions">
                  <div class="sidebar-user-menu">
                     <a href="/user/logOut" class="nav-link"><i
                        class="mdi mdi-logout menu-icon"></i> <span class="menu-title">로그아웃</span></a>
                  </div>
               </li>
            </ul>
         </nav>		
        <div class="main-panel">
				<div class="content-wrapper">
					<div class="page-header">
					</div>
			<!-- partial -->
			<div class="row">
						<div class="col-lg-12 grid-margin stretch-card">
							<div class="card">
								<div class="card-body">
	
	<!-- Shop Detail Start -->
	<br>
	<div style="text-align: center;">
	<input type="button" class="btn btn-secondary" onclick="fn_back()" value="  목록  " >
    <input type="button" class="btn btn-primary ml-1" onclick="fn_update()" value="  수정  " >
</div>
	<form name="productUpdateForm" id="productUpdateForm" method="post" enctype="multipart/form-data">
	<div class="container-fluid py-5">
		<div class="row px-xl-5">
			<div class="col-lg-5 pb-5">
				<div id="product-carousel" class="carousel slide"
					data-ride="carousel">
					<div class="carousel-inner border">
						<div class="carousel-item active">
							<img class="w-100 h-100"
								src="/resources/upload/product/${product.productSeq}.png"
								alt="Image">
						</div>
					</div>
				</div>
			</div>
			<input type="hidden" name="productSeq" id="productSeq" value="${product.productSeq}" /> 
			<div class="col-lg-7 pb-5" style="margin: auto;!important;">
				상품명&nbsp; : &nbsp;  
				<div class="d-flex mb-3">
				 <input type="text" style="width:50%;" class="font-weight-semi-bold" id="productName" name="productName" value="${product.productName}">
				</div>
				상품 가격&nbsp; : &nbsp;
				<div class="d-flex mb-3">
				<input type="number" style="width:30%;" id="productPrice" name="productPrice" value="${product.productPrice}">
				</div>
				현재 재고&nbsp; : &nbsp; 
				<div class="d-flex mb-3">
				<input type="number" style="width:30%;" id="productQuantity" name="productQuantity" value="${product.productQuantity}">
				</div>
				판매상태 :
				<div class="d-flex mb-3">
					<select name="status" id="status" style="width:30%;">
			                        <option value="Y">Y</option>
			                        <option value="N">N</option>
			                     </select>
				</div>
				
				<div class="d-flex mb-3">
					상품 판매 시작일&nbsp; : &nbsp; <input type="text" style="width:20%;" id="productStartDate" name="productStartDate" value="${product.productStartDate}">&nbsp;&nbsp;
					상품 판매 종료일&nbsp; : &nbsp; <input type="text" style="width:20%;" id="productEndDate" name="productEndDate" value="${product.productEndDate}">
				</div>
				</div>
			
		</div>
				
		<div class="row px-xl-5">
			<div class="col">
				<div
					class="nav nav-tabs justify-content-center border-secondary mb-4">
					<a class="nav-item nav-link active" data-toggle="tab"
						href="#tab-pane-1">상세정보</a> 
					
				</div>
				<div class="tab-content" style="border:transparent; padding:0;">
					<div class="tab-pane fade show active" id="tab-pane-1">
						<textarea class="form-control" rows="10" id="productDetail" name="productDetail">${product.productDetail}</textarea>
					</div>
					
						</div>
					</div>
					
				</div>
			</div>
			</form>
	<!-- Shop Detail End -->
	</div>
	</div>
	</div>
	</div>
	</div>

	

	<form name="bbsForm" id="bbsForm" method="post">
		<input type="hidden" name="productSeq" value="" />  <input type="hidden"
			name="curPage" value="${curPage}" />
		<input type="hidden" name="searchType" value="${searchType}" /> 
		<input type="hidden" name="searchValue" value="${searchValue}" /> 
	</form>

        </div>
        <!-- main-panel ends -->
      </div>
      <!-- page-body-wrapper ends -->
    </div>
    <!-- container-scroller -->
    <!-- plugins:js -->
    <script src="/resources/vendors/js/vendor.bundle.base.js"></script>
    <!-- endinject -->
    <!-- Plugin js for this page -->
    <!-- End plugin js for this page -->
    <!-- inject:js -->
    <script src="/resources/js/off-canvas.js"></script>
    <script src="/resources/js/hoverable-collapse.js"></script>
    <script src="/resources/js/misc.js"></script>
    <!-- endinject -->
    <!-- Custom js for this page -->
    <script src="/resources/js/file-upload.js"></script>
    <!-- End custom js for this page -->
  </body>
</html>