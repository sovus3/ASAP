<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<style>
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
                  href="/admin/voteUpload"> <span class="icon-bg"><i
                        class="mdi mdi-settings menu-icon"></i></span> <span class="menu-title">투표</span>
               </a></li>
               <li class="nav-item"><a class="nav-link"
                  data-toggle="collapse" href="#ui-basic3" aria-expanded="false"
                  aria-controls="ui-basic"> <span class="icon-bg"><i
                        class="mdi mdi-settings menu-icon"></i></span> <span class="menu-title">내역
                        관리</span> <i class="menu-arrow"></i>
               </a>
                  <div class="collapse" id="ui-basic3">
                     <ul class="nav flex-column sub-menu">
                        <li class="nav-item"><a class="nav-link"
                           href="/admin/product">상품 관리</a></li>
                        <li class="nav-item"><a class="nav-link"
                           href="/admin/payList">결제 관리</a></li>
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
                    <h4 class="card-title">공지사항 작성</h4>
                    <form class="forms-sample">
                    <div class="form-group h5" >
                    <!-- 수정 -->
                    <label for="exampleInputPassword4">관리자 아이디  ${admin.admId}*</label>
                    <!-- 수정 -->
                    
                    </div>                     
                      <div class="form-group" >
                        <label for="exampleInputEmail3">제목 *</label>
                        <input type="text" style="width: 50%;" class="form-control" name="nbTitle" id="nbTitle" placeholder="제목을 입력해주세요."  >
                      </div>
                      <div class="form-group">
                        <label for="exampleInputPassword4">내용 *</label>
                        <textarea class="form-control" rows="10" name="nbContent" id="nbContent" placeholder="내용을 입력해주세요" ></textarea>
                      </div> 
                      <input type="button" class="btn btn-secondary" id="btnList" value="  목록  " >
                  <input type="button" class="btn btn-primary ml-1" id="btnWrite"  value="  저장  " >
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
    <form name="bbsForm" id="bbsForm" method="post">
      <input type="hidden" name="searchType" value="" />
      <input type="hidden" name="searchValue" value="" />
      <input type="hidden" name="curPage" value="" />
      <input type="hidden" name="admId" id="admId" value="${admin.admId}"/>
   </form>
  </body>
</html>