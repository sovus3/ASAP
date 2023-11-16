<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<style>
th, td {
   text-align: center !important; /* 텍스트를 왼쪽 정렬합니다. */
}
</style>
<script>
   //본 예제에서는 도로명 주소 표기 방식에 대한 법령에 따라, 내려오는 데이터를 조합하여 올바른 주소를 구성하는 방법을 설명합니다.
   function execDaumPostcode() {
      new daum.Postcode({
         oncomplete : function(data) {
            // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

            // 도로명 주소의 노출 규칙에 따라 주소를 표시한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            var userAddr = data.roadAddress; // 도로명 주소 변수
            var extraRoadAddr = ''; // 참고 항목 변수

            // 법정동명이 있을 경우 추가한다. (법정리는 제외)
            // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
            if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
               extraRoadAddr += data.bname;
            }
            // 건물명이 있고, 공동주택일 경우 추가한다.
            if (data.buildingName !== '' && data.apartment === 'Y') {
               extraRoadAddr += (extraRoadAddr !== '' ? ', '
                     + data.buildingName : data.buildingName);
            }
            // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
            if (extraRoadAddr !== '') {
               extraRoadAddr = ' (' + extraRoadAddr + ')';
            }

            if (userAddr != '') {
               userAddr += extraRoadAddr;
            }

            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            document.getElementById('userPostcode').value = data.zonecode;
            document.getElementById("userAddr").value = userAddr;

            // 참고항목 문자열이 있을 경우 해당 필드에 넣는다.
            /*if(roadAddr !== ''){
                document.getElementById("extraAddress").value = extraRoadAddr;
            } else {
                document.getElementById("extraAddress").value = '';
            }*/

            var guideTextBox = document.getElementById("guide");
            // 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
            if (data.autoRoadAddress) {
               var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
               guideTextBox.innerHTML = '(예상 도로명 주소 : ' + expRoadAddr
                     + ')';
               guideTextBox.style.display = 'block';

            } else if (data.autoJibunAddress) {
               var expJibunAddr = data.autoJibunAddress;
               guideTextBox.innerHTML = '(예상 지번 주소 : ' + expJibunAddr
                     + ')';
               guideTextBox.style.display = 'block';
            } else {
               guideTextBox.innerHTML = '';
               guideTextBox.style.display = 'none';
            }
         }
      }).open();
   }
</script>


<script>
$(document).ready(function() {

   $("#btnChargePlus").on("click", function() {
      $.ajax({
         type : "POST",
         url : "/admin/userChargeProc",
         data : {
            userChargePlus : $("#userChargePlus").val(),
            userId : $("#userId2").val()
         },
         datatype : "JSON",
         beforeSend : function(xhr) {
            xhr.setRequestHeader("AJAX", "true");
         },
         success : function(result) {
            if (result.code == 1) 
            {
               Swal.fire({
                  title : '포인트가 지급됐습니다.',
                  icon : 'success'
               }).then(function() {
                  document.updateForm.action = "/admin/userUpdate";
                  document.updateForm.submit();
               })
            } 
            else if (result.code == 0) 
            {
               Swal.fire('포인트가 지급 중 오류가 발생했습니다.', '', 'warning');
            } 
            else if (result.code == 400) 
            {
               Swal.fire('관리자가 아닙니다.', '', 'warning');
            } 
            else 
            {
               Swal.fire('기타 오류가 발생했습니다.', '', 'error');
            }
         },
         error : function(xhr, status, error) {
            icia.common.error(error);
         }
      });
   });

   $("#cancel").on("click", function() {
     document.updateForm.action = "/admin/userList";
     
        document.updateForm.submit();
   });

   $("#btnUpdate").on("click", function() {
      var empCheck = /\s/gi;
      var IdCheck = /^[a-zA-Z0-9]{4,16}$/;
      var emailCheck = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
      var pwdCheck = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{4,20}$/;
      var phoneCheck = /^(010|011|016|017|018|019)[0-9]{3,4}[0-9]{4}$/;
      
      if($.trim($("#userName").val()).length <= 0){
         $("#userName").val("");
         $("#userName").focus();
         Swal.fire("이름을 입력하세요.", '', 'info');
         return;
      }
         
      if(empCheck.test($("#userName").val())){
         $("#userName").val("");
         $("#userName").focus();
         Swal.fire("이름은 공백없이 입력하세요.", '', 'info');
         return;
      }

      if($.trim($("#userPwd1").val()).length <= 0){
         $("#userPwd1").val("");
         $("#userPwd1").focus();
         Swal.fire("비밀번호를 입력하세요.", '', 'info');
         return;
      }
         
      if(empCheck.test($("#userPwd1").val())){
         $("#userPwd1").val("");
         $("#userPwd1").focus();
         Swal.fire("비밀번호는 공백없이 입력하세요.", '', 'info');
         return;
      }
         

      
      if($("#userPwd1").val() != $("#userPwd2").val()){
         $("#userPwd2").val("");
         $("#userPwd2").focus();
         Swal.fire("비밀번호가 일치하지 않습니다.", '', 'info');
         return;
      }
      
      $("#userPwd").val($("#userPwd1").val());

      if($.trim($("#userPhone").val()).length <= 0){
         $("#userPhone").val("");
         $("#userPhone").focus();
         Swal.fire("전화번호를 입력하세요.", '', 'info');
         return;
      }

      if(empCheck.test($("#userPhone").val())){
         $("#userPhone").val("");
         $("#userPhone").focus();
         Swal.fire('전화번호는 공백없이 입력하세요.', '', 'warning');
         return;
      }
      
      if(!phoneCheck.test($("#userPhone").val())){
         $("#userPhone").val("");
         $("#userPhone").focus();
         Swal.fire('"-"없이 숫자만 입력하세요.', '', 'warning');
         return;
      }

      if($.trim($("#userEmail").val()).length <= 0){
         $("#userEmail").val("");
         $("#userEmail").focus();
         Swal.fire("이메일을 입력하세요.", '', 'info');
         return;
      }
         
      if(empCheck.test($("#userEmail").val())){
         $("#userEmail").val("");
         $("#userEmail").focus();
         Swal.fire("이메일은 공백없이 입력하세요.", '', 'info');
         return;
      }
         
      if(!emailCheck.test($("#userEmail").val())){
         $("#userEmail").val("");
         $("#userEmail").focus();
         Swal.fire("이메일 형식에 맞게 입력하세요.", '', 'info');
         return;
      }

      if ($.trim($("#userAddr").val()).length <= 0) 
      {
         $("#userAddr").val("");
         $("#userAddr").focus();
         Swal.fire('주소를 입력하세요.', '', 'info');
         return;
      }
      
      if ($.trim($("#userPostcode").val()).length <= 0) 
      {
         $("#userPostcode").val("");
         $("#userPostcode").focus();
         Swal.fire('우편번호를 입력하세요.', '', 'info');
         return;
      }

      $("#userPwd").val($("#userPwd1").val());

      $.ajax({
         type : "POST",
         url : "/admin/userUpdateProc",
         data : {
            userId : $("#userId2").val(),
            userPwd : $("#userPwd").val(),
            userName : $("#userName").val(),
            userPhone : $("#userPhone").val(),
            userAddr : $("#userAddr").val(),
            userEmail : $("#userEmail").val(),
            userPostcode : $("#userPostcode").val(),
            userStatus : $("#userStatus").val()
         },
         datatype : "JSON",
         beforeSend : function(xhr) {
            xhr.setRequestHeader("AJAX", "true");
         },
         success : function(result) {
            if (result.code == 1) 
            {
               Swal.fire({
                  title : '회원 정보가 수정되었습니다.',
                  icon : 'success'
               }).then(function() {
                   document.updateForm.action = "/admin/userUpdate";
                   document.updateForm.submit();
               })
            } 
            else if (result.code == 0) 
            {
               $("#userPwd1").focus();
               Swal.fire('회원정보 수정 중 오류가 발생하였습니다.', '', 'warning');
            } 
            else if (result.code == 400) 
            {
               Swal.fire({
                  title : '파라미터 값이 부족합니다.',
                  icon : 'warning'
               }).then(function() {
                  location.href = "/";
               })
            } 
            else if (result.code == 404) 
            {
               $("#userPwd1").focus();
               Swal.fire('회원정보 수정 중 오류가 발생하였습니다.', '', 'warning');
            } 
            else 
            {
               Swal.fire('기타 오류가 발생했습니다.', '', 'error');
            }
         },
         error : function(xhr, status, error) {
            icia.common.error(error);
         }
      });
   });

});

function fn_validateEmail(value) {
   var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
   return emailReg.test(value);
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
                  <form name="updateForm" id="updateForm" method="post">
                    <h4 class="card-title">회원 ${user.userId}</h4>
                    <form class="forms-sample">
                      <div class="form-group">
                        <label for="exampleInputName1">포인트 지급</label>
                        <div class="row form-group" style="margin-bottom: 10px; margin-left: 0.5px;'">
                  <input type="number" class="form-control" name="userChargePlus" id="userChargePlus" style="width: 10rem; height: 2.5rem; margin-right:10px;" >
                  <button type="button" id="btnChargePlus" class="btn btn-primary">포인트 지급</button>
                  </div>
                      </div>
                      <div class="form-group">
                        <label for="exampleInputEmail3">포인트 *</label>
                        <input type="text" class="form-control" name="userCharge" id="userCharge" value="${user.userCharge}" readonly>
                      </div>
                      <div class="form-group">
                        <label for="exampleInputPassword4">닉네임 *</label>
                        <input type="text" class="form-control"  name="userNick" id="userNick" value="${user.userNick}" readonly >
                      </div>
                      <div class="form-group">
                        <label for="exampleTextarea1">이름 *</label>
                        <input type="text" class="form-control" name="userName" id="userName" value="${user.userName}" readonly >    
                      </div>                                      
                      <div class="form-group">
                        <label for="exampleInputCity1">비밀번호 *</label>
                        <input type="password" class="form-control" name="userPwd1" id="userPwd1" value="${user.userPwd}" >
                      </div>
                      <div class="form-group">
                        <label for="exampleTextarea1">비밀번호 확인 *</label>
                        <input type="password" class="form-control" name="userPwd2" id="userPwd2" value="${user.userPwd}" >
                      </div>
                       <div class="form-group">
                        <label for="exampleTextarea1">이메일 *</label>
                        <input type="text" class="form-control" name="userEmail" id="userEmail" value="${user.userEmail}" >
                      </div>
                       <div class="form-group">
                        <label for="exampleTextarea1">전화번호 *</label>
                        <input type="text" class="form-control" name="userPhone" id="userPhone" value="${user.userPhone}" >
                      </div>
                        <div class="form-group">
                        <label for="exampleSelectGender">회원상태 *</label>
                        <select class="form-control" name="userStatus" id="userStatus" style="font-size: 0.8rem; width: 8rem; height: 2.5rem;">
                          <option value="">회원상태</option>
                       <option value="Y" <c:if test="${user.status == 'Y'}">selected</c:if>>정상</option>
                       <option value="N" <c:if test="${user.status == 'N'}">selected</c:if>>정지</option>
                        </select>
                      </div>
                      <div class="form-group">
                        <label for="exampleTextarea1">주소 *</label>
                  <div class="row form-group" style="margin-bottom: 10px; margin-left: 0.5px;'">
                     <input type="text" class="form-control" name="userPostcode" id="userPostcode" value="${user.userPostcode}" style="width: 8rem; height: 2.5rem; margin-right:10px;" >
                     <button type="button" onclick="execDaumPostcode()" class="btn btn-primary">우편번호 찾기</button>
                        
                  </div>
                    <input type="text" class="form-control" name="userAddr" id="userAddr" value="${user.userAddr}" > 
                  <span id="guide" style="color:#999;display:none"></span>
                      </div>
                      <input type="button" class="btn btn-light" name="cancel" id="cancel" value="  취소  " >
                      <input type="button" name="btnUpdate" id="btnUpdate" class="btn btn-primary ml-1" value="  수정  " >
                      <input type="hidden" name="userPwd" id="userPwd" value="">
                      <input type="hidden" name="userId2" id="userId2" value="${user.userId}">
                      <input type="hidden" name="userIdSearch" id="userIdSearch" value="${userIdSearch}">
                      <input type="hidden" name="curPage" id="curPage" value="${curPage}">
                      <input type="hidden" name="userCode" id="userCode" value="${userCode}">
                      <input type="hidden" name="status" id="status" value="${status}">
                      
                      </form>
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