<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<style>

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
        <!-- partial -->
        <div class="main-panel">
          <div class="content-wrapper">
            <div class="page-header">
            </div>
            <div class="row">
              
              <div class="col-12 grid-margin stretch-card">
                <div class="card">
                  <div class="card-body">
                    <h4 class="card-title">상품 올리기</h4>
                      <form name="productUploadForm" id="productUploadForm" method="post" enctype="multipart/form-data">              
                      <div class="form-group" >
                        <label for="exampleInputEmail3">상품명 *</label>
                        <input type="text" style="width: 50%;" class="form-control" name="productName" id="productName" value=""  >
                      </div>
                      <div class="form-group">
                        <label for="exampleInputPassword4">상품 가격 *</label>
                        <input type="number" style="width: 30%;" class="form-control"  name="productPrice" id="productPrice" value="" placeholder="숫자만 입력하세요." >
                      </div>
                      <div class="form-group">
                        <label for="exampleTextarea1">재고 수량 *</label>
                        <input type="number" style="width: 30%;" class="form-control" name="productQuantity" id="productQuantity" value="" placeholder="숫자만 입력하세요.">    
                      </div>                                      
                      <div class="form-group">
                        <label for="exampleInputCity1">상태 *</label>
                        <div class="form-group"
											style="display: flex; margin-bottom: 10px;">
                        <select name="status" id="status" style="width: 10%;">
							<option value="Y">Y</option>
							<option value="N">N</option>
						</select>
						</div>
                      </div>
                      <div class="form-group">
                        <label for="exampleTextarea1">상품 판매 시작일 *</label>
                        <input type="date" style="width: 30%;" class="form-control" name="productStartDate" id="productStartDate" value="" >
                      </div>
                       <div class="form-group">
                        <label for="exampleTextarea1">상품 판매 종료일 *</label>
                        <input type="date" style="width: 30%;" class="form-control" name="productEndDate" id="productEndDate" value="" >
                      </div>
                       <div class="form-group">
                        <label for="exampleTextarea1">상품 설명 *</label>
                        <textarea class="form-control" rows="10" id="productDetail" name="productDetail"></textarea>
                        </div>
                        <div class="form-group">
                        <label for="exampleSelectGender">상품 사진 첨부 *</label>
                        <input type="file" id="productFile" name="productFile" class="mb-3">
                      </div>                     
                      
                      <input type="button" class="btn btn-light" onclick="fn_list()" value="  취소  " >
                      <input type="button" name="btnProductUpload" id="btnProductUpload" class="btn btn-primary ml-1" value=" 상품 올리기 " >
				     </form>
				      <form name="bbsForm" id=bbsForm method="post">          
						  <input type="hidden" name="curPage" id="curPage" value="${curPage}" /> 
				     </form>
                  </div>
                </div>
              </div>
            </div>
          </div>

        </div>
        <!-- main-panel ends -->
      </div>
      <!-- page-body-wrapper ends -->
    </div>
    <!--container-scroller  -->
    <!--plugins:js  -->
    <script src="/resources/vendors/js/vendor.bundle.base.js"></script>
    <!--  -->
    <!--Plugin js for this page  -->
    <!--End plugin js for this page -->
    <!--inject:js  -->
    <script src="/resources/js/off-canvas.js"></script>
    <script src="/resources/js/hoverable-collapse.js"></script>
    <script src="/resources/js/misc.js"></script>
    <!-- endinject -->
    <!-- Custom js for this page-->
    <script src="/resources/js/file-upload.js"></script>
    <!-- End custom js for this page  -->
  </body>
</html>