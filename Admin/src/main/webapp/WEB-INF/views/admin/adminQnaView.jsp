<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
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
                    <h1 style="color:black; margin-left:15px;">${qnaBoard.qaTitle}</h1>
                    <form class="forms-sample"> 
                    <div class="form-group h4" >
					    <ul style="list-style-type: none; display: flex;">
					        <li style=" display: flex; align-items: center; margin-right: 10px;">
					            <i class="mdi mdi-account"></i>&ensp;
					            <c:out value="${qnaBoard.userId}" />
					            <c:out value="${qnaBoard.admId}" />
					        </li>
					        &ensp;&ensp;
					        <li style="display: flex; align-items: center; margin-right: 10px;">
					            <i class="mdi mdi-calendar"></i>&ensp;${qnaBoard.regDate}
					        </li>
					        &ensp;&ensp;
					        <li style="display: flex; align-items: center;">
					            <i class="mdi mdi-tag-multiple"></i>&ensp;문의사항
					        </li>
					    </ul>
					</div> 
						<div class="form-group h3" style="color:#5F5F5F; margin-left: 15px; width:70%;">
						${qnaBoard.qaContent}
						</div>
					  <button type="button" id="btnList" style="margin-left: 10px; margin-top:10px;"class="btn btn-outline-secondary btn-icon-text"> 
					  <i class="mdi mdi-replay"></i>목록 </button>
                       <c:if test = "${empty qnaBoard.admId}">
                      <button type="button" id="btnReply" style="margin-left: 5px; margin-top:10px;" class="btn btn-outline-primary btn-icon-text">
                       <i class="mdi mdi-message-reply-text"></i> 답변 </button>
                       </c:if>
                       <button type="button" id="btnDelete" style="margin-left: 5px; margin-top:10px;" class="btn btn-outline-danger btn-icon-text">
                            <i class="mdi mdi-delete"></i> 삭제 </button>
                    </form>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <!-- content-wrapper ends -->
   <form name="bbsForm" id="bbsForm" method="post">
		<input type="hidden" name="qaSeq" id="qaSeq" value="${qnaBoard.qaSeq}" />
		<input type="hidden" name="searchType" value="${searchType}" />
		<input type="hidden" name="searchValue" value="${searchValue}" />
		<input type="hidden" name="curPage" value="${curPage}" />
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