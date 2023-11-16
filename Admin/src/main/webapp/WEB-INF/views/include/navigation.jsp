<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<style>
.position-absolute {
	color: #FFFFFF !important;
}
</style>

<script>
$(document).ready(function () {
	var userId = $.trim($("#userId").val());
    console.log("userId:", userId); 
    var totalCount = $.trim($("#totalCount").val());
    console.log("totalCount:", totalCount); 
	$.ajax({
            url: "/include/navigation",    
            data:{
            	userId:userId
            },
            dataType: "JSON",
            beforeSend: function (xhr) {
                xhr.setRequestHeader("AJAX", "true");
            },
            success: function (response) {
                if (response.code === 0) {                    
                	$(".position-absolute.top-0.start-100.translate-middle.badge.rounded-pill.bg-warning").text(response.data);    
                }
            },
            error: function (xhr, status, error) {
                icia.common.error(error);
            }
        }); 
	
	$("#uploadCheck").click(function() {
	    up_Check(); 
	});
    
}); 
   function up_Check() {
      var curDate = new Date();
      var year = curDate.getFullYear();
      var month = (curDate.getMonth() + 1).toString().padStart(2, '0'); // 문자열이 최소 2자리가 되도록 설정
      var day = curDate.getDate().toString().padStart(2, '0');

      var formatDate = year + month + day; // 20230901

      /* Sweetalert 수정 시작 */
      
      $.ajax({
         type : "POST",
         url : "/vote/voteProc",
         data : {
            curDate : formatDate
         },
         datatype : "JSON",
         beforeSend : function(xhr) {
            xhr.setRequestHeader("AJAX", "true");
         },
         success : function(response) {

               if (response.code == 0) {
                  location.href = "/vote/voteUpload";
               } else if (response.code == 300) {
                  Swal.fire({
        		  		title : '투표기간이 아닙니다.',
        		  		icon : 'warning'
                  	}).then(function(){
        		  	    location.href = "/";	
        		  	})     
               } else if (response.code == 200) {
                  Swal.fire({
						title : '작품업로드는 "작가"만 가능합니다.',
						icon : 'warning'
                  }).then(function(){
                 		location.href = "/";
                	})
                } else if (response.code == 400) {                
                  Swal.fire({
						title : '회원이 아닙니다.',
						icon : 'warning'
                  }).then(function(){
               		 location.href = "/";
              	})
          	  } else {
            	 Swal.fire({
            		 	title : '오류가 발생하였습니다.', 
            		 	icon : 'warning'            
            	 }).then(function(){
            		  location.href = "/";
            	 })
              
            }  
         },
         error : function(xhr, status, error) {
            icia.common.error(error);
         }
      });

   }

   /* Sweetalert 수정 끝 */
   
   
   function searchByCategory2(value) {
       document.voteUploadListForm2.searchType.value = value;
       document.voteUploadListForm2.curPage.value = "1";
       document.voteUploadListForm2.action = "/vote/voteList2";
       document.voteUploadListForm2.submit();       
   }

   function searchCategory2(value) {
       document.voteForm2.searchType.value = value;
       document.voteForm2.curPage.value = "1";
       document.voteForm2.action = "/vote/voteResult2";
       document.voteForm2.submit();       
   }
</script>
</head>
<body>
	<nav class="navbar default-layout-navbar col-lg-12 col-12 p-0 fixed-top d-flex flex-row">
        <div class="text-center navbar-brand-wrapper d-flex align-items-center justify-content-center" >
          <a class="navbar-brand brand-logo" href="/admin/userList"><img src="/resources/images/asap.png" style="height:50px" alt="logo" /></a>
        </div>
        <div class="navbar-menu-wrapper d-flex align-items-stretch">
          <button class="navbar-toggler navbar-toggler align-self-center" type="button" data-toggle="minimize">
            <span class="mdi mdi-menu"></span>
          </button>
          <ul class="navbar-nav navbar-nav-right">
            
            
            <li class="nav-item nav-profile dropdown">
              <a class="nav-link dropdown-toggle" id="profileDropdown" href="#" data-toggle="dropdown" aria-expanded="false">
                <div class="nav-profile-img">
                <c:choose>
                <c:when test="${gnbAdmId == 'admin' }">
                  <img src="/resources/images/faces/face29.jpg" alt="image">
                  </c:when>
                  <c:when test="${gnbAdmId == 'admin2' }">
                  <img src="/resources/images/faces/face31.png" alt="image">
                  </c:when>
                  <c:when test="${gnbAdmId == 'admin3' }">
                  <img src="/resources/images/faces/face32.png" alt="image">
                  </c:when>
                  <c:otherwise>
                  <img src="/resources/images/faces/face30.png" alt="image">
                  </c:otherwise>
                  </c:choose>
                </div>
                <div class="nav-profile-text">
                  <p class="mb-1 text-black">${gnbAdmId}</p>
                </div>
              </a>
              <div class="dropdown-menu navbar-dropdown dropdown-menu-right p-0 border-0 font-size-sm" aria-labelledby="profileDropdown" data-x-placement="bottom-end">
                <div class="p-3 text-center bg-primary">
                  <c:choose>
                <c:when test="${gnbAdmId == 'admin' }">
                  </c:when>
                  <c:when test="${gnbAdmId == 'admin2' }">
                  <img class="img-avatar img-avatar48 img-avatar-thumb"  src="/resources/images/faces/face31.png" alt="">
                  </c:when>
                  <c:when test="${gnbAdmId == 'admin3' }">
                  <img class="img-avatar img-avatar48 img-avatar-thumb"  src="/resources/images/faces/face32.png" alt="">
                  </c:when>
                  <c:otherwise>
                  <img class="img-avatar img-avatar48 img-avatar-thumb"  src="/resources/images/faces/face30.png"alt="">
                  </c:otherwise>
                  </c:choose>
                </div>
                <div class="p-2">
                  <h5 class="dropdown-header text-uppercase pl-2 text-dark">${gnbAdmId}</h5>
                  
                  <a class="dropdown-item py-1 d-flex align-items-center justify-content-between" href="/user/logOut">
                    <span>Log Out</span>
                    <i class="mdi mdi-logout ml-1"></i>
                  </a>
                </div>
              </div>
            
          <button class="navbar-toggler navbar-toggler-right d-lg-none align-self-center" type="button" data-toggle="offcanvas">
            <span class="mdi mdi-menu"></span>
          </button>
        </div>
      </nav>
</body>
</html>