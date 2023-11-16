<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
</head>
<script>
$(document).ready(function(){
/* 수정 */   
   $("#btnSearch").on("click",function(){      
      document.searchForm.curPage.value = "1";
      document.searchForm.action="/admin/userList";
      document.searchForm.userCode.value=$("#userCode").val();
      document.searchForm.status.value=$("#status").val();
      document.searchForm.submit();
   });
   
   $(".userInfoUpdate").click(function(){      
      var userId = $(this).next().val();
      document.searchForm.userId2.value = userId;
      var userIdSearch = $("#userIdSearch").val();
      var curPage = $("#curPage").val();
      var userCode = $("#userCode").val();
       var status = $("#status").val();
      document.searchForm.curPage.value = curPage;
      document.searchForm.userIdSearch.value = userIdSearch;
      document.searchForm.userCode.value = userCode;
      document.searchForm.status.value = status;
      document.searchForm.action="/admin/userUpdate";
      document.searchForm.submit();
   });
/* 수정 */
 $(".artAccess").click(function(){
      var userId = $(this).next().val();
      document.searchForm.userId2.value = userId;
      
      $.ajax({
         type: "POST",
         url: "/admin/userCodeUpdate",
         data:{
            userId: userId
         },
           beforeSend : function(xhr) {
               xhr.setRequestHeader("AJAX", "true");
            },
            success : function(result) {
               if (result.code == 1) 
               {
                  Swal.fire({
                  title: '작가승인이 완료됐습니다.', 
                  icon: 'success'
               }).then(function(){
                  document.searchForm.action="/admin/userList";
                     document.searchForm.submit();
               })
               } 
               else if (result.code == 0) 
               {
                  Swal.fire({
                  title: '작가신청 승인 중 오류가 발생했습니다.', 
                  icon: 'warning'
               }).then(function(){
                  document.searchForm.action="/admin/userList";
                     document.searchForm.submit();
               })
               } 
               else if (result.code == 400) 
               {
               Swal.fire({
                  title: '관리자가 아닙니다.', 
                  icon: 'warning'
               }).then(function(){
                  location.href = "/";
               })
               }
               else
               {
                  Swal.fire({
                  title: '기타 오류가 발생했습니다.', 
                  icon: 'error'
               }).then(function(){
                  location.href="/";
               })
               }
            },
            error : function(error) {
               icia.common.error(error);
            }
      });
   });
});

function fn_list(curPage){   
   document.searchForm.curPage.value = curPage;
   document.searchForm.action="/admin/userList";
   document.searchForm.submit();
}

</script>

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
                  <div class="col-lg-12 grid-margin stretch-card">
                     <div class="card">
                        <div class="card-body">
                           <h4 class="card-title">회원 관리</h4>

                           <form name="searchForm" id="searchForm" method="post">
                              <input type="hidden" id="curPage" name="curPage"
                                 value="${curPage}" />


                              <div class="form-group"
                                 style="display: flex; margin-bottom: 10px;">
                                 <select id="status" name="status"
                                    class="form-control form-control-lg"
                                    style="width: 100px; height: 40px; margin-right: 10px;">
                                    <option value="">회원상태</option>
                                    <option value="Y"
                                       <c:if test="${status == 'Y'}">selected</c:if>>정상</option>
                                    <option value="N"
                                       <c:if test="${status == 'N'}">selected</c:if>>정지</option>
                                 </select> <select id="userCode" name="userCode"
                                    class="form-control form-control-lg"
                                    style="width: 100px; height: 40px;">
                                    <option value="">회원구분</option>
                                    <option value="U"
                                       <c:if test="${userCode == 'U'}">selected</c:if>>일반회원</option>
                                    <option value="A"
                                       <c:if test="${userCode == 'A'}">selected</c:if>>작가회원</option>
                                    <option value="W"
                                       <c:if test="${userCode == 'W'}">selected</c:if>>작가승인예정</option>
                                 </select>
                              </div>
                              <!-- 여기 사이 공간을 줄이고 싶어 -->
                              <div class="search-field d-none d-xl-block"
                                 style="margin-bottom: 10px;">
                                 <div class="input-group-prepend bg-transparent"
                                    style="width: 500px !important;">

                                    <input type="text"
                                       class="form-control bg-transparent border-1"
                                       style="font-size: 0.8rem; width: 15rem; height: 3rem; margin-right:5px;"
                                       name="userIdSearch" id="userIdSearch" placeholder="아이디 검색..." value="${userIdSearch}" >
                                    <div id="btnSearch"
                                       class="input-group-prepend bg-transparent">
                                       <i
                                          class="input-group-text bg-transparent border-1 mdi mdi-magnify"></i>
                                    </div>
                                 </div>
                              </div>

                              <table class="table table-striped">
                                 <thead>
                                    <tr>
                                       <th>User</th>
                                       <th>번호</th>
                                       <th>아이디</th>
                                       <th>닉네임</th>
                                       <th>회원상태</th>
                                       <th>일반/작가</th>
                                       <th>작가신청여부</th>
                                       <th>충전금</th>
                                       <th>확인&수정</th>
                                    </tr>
                                 </thead>
                                       <tbody>
                                       <c:if test="${!empty list}">
                                    <c:set var="startNum" value="${paging.startNum}" />
                                    <c:forEach var="user" items="${list}" varStatus="status">
                                          <tr>
                                             <td class="py-1"><img
                                                src="/resources/images/faces-clipart/pic-<%=(int) (Math.random() * 4) + 1%>.png"
                                                alt="image" /></td>
                                             <td>${startNum}</td>
                                             <td >${user.userId}</td>
                                             <td >${user.userNick}</td>
                                             <td ><c:choose>
                                                   <c:when test="${user.status == 'N'}">
                                                              탈퇴
                                                           </c:when>
                                                   <c:when test="${user.status == 'Y'}">
                                                              정상
                                                           </c:when>
                                                </c:choose></td>
                                             <td ><c:choose>
                                                   <c:when test="${user.userCode == 'U'}">
                                                              일반
                                                           </c:when>
                                                   <c:when test="${user.userCode == 'A'}">
                                                              작가
                                                           </c:when>
                                                   <c:when test="${user.userCode == 'W'}">
                                                              작가승인대기
                                                           </c:when>
                                                </c:choose></td>
                                             <td ><c:choose>
                                                   <c:when test="${user.userCode == 'W'}">
                                                      <label class="badge badge-info artAccess">승인</label>
                                                      <input type="hidden" id="updateUserId" 
                                                         name="updateUserId" value="${user.userId}">
                                                   </c:when><c:when test="${user.userCode == 'A' }">                                                
                                                             
                                                          </c:when>
                                                   <c:otherwise>
                                                             미신청
                                                          </c:otherwise>
                                                </c:choose></td>
                                             <td ><fmt:formatNumber type="number"
                                                   maxFractionDigits="3" value="${user.userCharge}" /></td>
                                             <td ><label class="badge badge-success userInfoUpdate"
                                                id="userInfoUpdate" style="cursor:pointer;">확인및수정</label> <input type="hidden"
                                                id="updateUserId" name="updateUserId"
                                                value="${user.userId}"></td>
                                          </tr>
                                          <c:set var="startNum" value="${startNum-1}"></c:set>
                                          </c:forEach>
                                 </c:if>
                                          </tbody>
                                          
                              </table>




                              <input type="hidden" id="userId2" name="userId2" value="">
                              <!--  <input type="hidden" id="userIdSearch" name="userIdSearch" value="${userIdSearch}">-->
                           </form>
                           <!-- 여기부 터 -->

                           <div class="mt-3"
                              style="display: flex; justify-content: center;">
                              <!-- 페이징 샘플 시작 -->
                              <c:if test="${!empty paging}">
                                 <!--  이전 블럭 시작 -->
                                 <c:if test="${paging.prevBlockPage gt 0}">
                                    <a href="javascript:void(0)" class="btn btn-primary"
                                       onclick="fn_list(${paging.prevBlockPage})" title="이전 블럭">&laquo;</a>
                                 </c:if>
                                 <div style="width: 4px;"></div>
                                 <!--  이전 블럭 종료 -->
                                 <span> <!-- 페이지 시작 --> <c:forEach var="i"
                                       begin="${paging.startPage}" end="${paging.endPage}">
                                       <c:choose>
                                          <c:when test="${i ne curPage}">
                                             <a href="javascript:void(0)" class="btn btn-primary"
                                                onclick="fn_list(${i})" style="font-size: 14px;">${i}</a>
                                          </c:when>
                                          <c:otherwise>
                                             <h class="btn btn-primary"
                                                style="font-size:14px; font-weight:bold;">${i}</h>
                                          </c:otherwise>
                                       </c:choose>
                                    </c:forEach> <!-- 페이지 종료 -->
                                 </span>
                                 <div style="width: 4px;"></div>
                                 <!--  다음 블럭 시작 -->
                                 <c:if test="${paging.nextBlockPage gt 0}">
                                    <a href="javascript:void(0)" class="btn btn-primary"
                                       onclick="fn_list(${paging.nextBlockPage})" title="다음 블럭">&raquo;</a>
                                 </c:if>
                                 <!--  다음 블럭 종료 -->
                              </c:if>
                              <!-- 페이징 샘플 종료 -->
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
      </div>
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
      <!-- End custom js for this page -->
</body>
</html>