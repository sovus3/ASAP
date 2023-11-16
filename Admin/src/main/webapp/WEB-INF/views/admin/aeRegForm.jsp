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

	$("#aeTitle").focus();

	$("#btnAeUpload").on("click", function() {

		$("#btnAeUpload").prop("disabled", true);

		if ($.trim($("#aeTitle").val()).length <= 0) 
		{
			$("#aeTitle").val("");
			$("#aeTitle").focus();
			$("#btnAeUpload").prop("disabled", false);
			Swal.fire('경매 이름은 필수 입력사항입니다.', '', 'info');
			return;
		}

		if ($.trim($("#aeProductTitle").val()).length <= 0) 
		{
			$("#aeProductTitle").val("");
			$("#aeProductTitle").focus();
			$("#btnAeUpload").prop("disabled", false);
			Swal.fire('상품 이름은 필수 입력사항입니다.', '', 'info');
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
						location.href = "/admin/aucEvent";
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
function fn_list(curPage)
{
	document.bbsForm.curPage.value = curPage; 
	document.bbsForm.action="/admin/aucEvent";
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
                    <h4 class="card-title">이벤트경매 올리기</h4>
                    <form name="aeUploadForm" id="aeUploadForm" method="post" enctype="multipart/form-data">                    
                      <div class="form-group" >
                        <label for="exampleInputEmail3">경매 이름 *</label>
                        <input type="text" style="width: 50%;" class="form-control" name="aeTitle" id="aeTitle" value="" >
                      </div>
                      <div class="form-group">
                        <label for="exampleInputPassword4">상품 이름 *</label>
                        <input type="text" style="width: 30%;" class="form-control"  name="aeProductTitle" id="aeProductTitle" value="" >
                      </div>
                      <div class="form-group">
                        <label for="exampleTextarea1">시작가 *</label>
                        <input type="number" style="width: 30%;" class="form-control" name="aeStartPrice" id="aeStartPrice" value="" placeholder="0" >    
                      </div>
                      <div class="form-group">
                        <label for="exampleTextarea1">경매 시작시간 *</label>
                        <input type="text" style="width: 30%;" class="form-control" name="aeStartTime" id="aeStartTime" value="${user.userPwd}" >
                      </div>
                       <div class="form-group">
                        <label for="exampleTextarea1">경매 종료시간 *</label>
                        <input type="text" style="width: 30%;" class="form-control" name="aeEndTime" id="aeEndTime" value="${user.userEmail}" >
                      </div>
                        <div class="form-group">
                        <label for="exampleSelectGender">배너 사진 첨부 *</label>
                        <input type="file" id="bannerFile" name="bannerFile" class="mb-5">
                      </div>      
                      <div class="form-group">
                        <label for="exampleSelectGender">상품 사진 첨부 *</label>
                        <input type="file" id="mainFile" name="mainFile" class="mb-5">
                      </div>   
                      <div class="form-group">
                        <label for="exampleSelectGender">설명 사진 첨부 *</label>
                        <input type="file" id="detailFile" name="detailFile" class="mb-5">
                      </div>                  
                      <input type="button" class="btn btn-light" onclick="fn_list()" value="  취소  " >
                      <input type="button" name="btnAeUpload" id="btnAeUpload" class="btn btn-primary ml-1" value=" 이벤트 경매 올리기 " >
                    </form>
			     	<form name="bbsForm" id="bbsForm" method="post">
						<input type="hidden" name="curPage" value="${curPage}" />
					</form>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <!-- content-wrapper ends -->

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