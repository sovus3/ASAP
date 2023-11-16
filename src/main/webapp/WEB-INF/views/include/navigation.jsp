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
	<!--=========== Loader =============-->
	<div id="gen-loading">
		<div id="gen-loading-center">
			<img src="/resources/images/asap.png" alt="loading">
		</div>
	</div>
	<!--=========== Loader =============-->

	<!--========== Header ==============-->
	<% String cookieUserId = com.icia.web.util.CookieUtil.getHexValue(request, (String) request.getAttribute("AUTH_COOKIE_NAME"));
%>
	<input type="hidden" name="userId" id="userId"
		value="<%= cookieUserId %> " />
	<input type="hidden" name="totalCount" id="totalCount"
		value="${totalCount }" />
	<header id="gen-header" class="gen-header-style-1 gen-has-sticky">
		<div class="gen-bottom-header">
			<div class="container">
				<div class="row">
					<div class="col-lg-12">
						<nav class="navbar navbar-expand-lg navbar-light">
							<a class="navbar-brand" href="/"> <img class="img-fluid logo"
								src="/resources/images/asap.png" alt="streamlab-image">
							</a>
							<div class="collapse navbar-collapse" id="navbarSupportedContent">
								<div id="gen-menu-contain" class="gen-menu-contain">
									<ul id="gen-main-menu" class="navbar-nav ml-auto">
										<li class="menu-item active"><a href="/" aria-current="page" style="color: #007bff">홈</a></li>
										<li class="menu-item"><a href="/vote/voteList">투표</a> <i
											class="fa fa-chevron-down gen-submenu-icon"></i>
											<ul class="sub-menu">
												<li class="menu-item menu-item-has-children"><a
													href="/vote/voteList">진행 투표</a> <i
													class="fa fa-chevron-down gen-submenu-icon"></i>
													<ul class="sub-menu">
														<li class="menu-item"><a
															onclick="searchByCategory2(1)">미술</a></li>
														<li class="menu-item"><a
															onclick="searchByCategory2(2)">사진</a></li>
														<li class="menu-item"><a
															onclick="searchByCategory2(3)">도예</a></li>
													</ul></li>
												<li class="menu-item menu-item-has-children"><a
													href="/vote/voteResult">투표 결과</a> <i
													class="fa fa-chevron-down gen-submenu-icon"></i>
													<ul class="sub-menu">
														<li class="menu-item"><a onclick="searchCategory2(1)">미술</a>
														</li>
														<li class="menu-item"><a onclick="searchCategory2(2)">사진</a>
														</li>
														<li class="menu-item"><a onclick="searchCategory2(3)">도예</a>
														</li>
													</ul></li>
												<!-- 네비게이션 수정 시작 -->
												<li class="menu-item"><a href="#" id="uploadCheck">작품
														올리기</a></li>
												<!-- 네비게이션 수정 끝 -->
											</ul></li>
										<li class="menu-item"><a href="/auction/auctionList">경매</a>
											<i class="fa fa-chevron-down gen-submenu-icon"></i>
											<ul class="sub-menu">
												<li class="menu-item menu-item-has-children"><a
													href="/auction/auctionList">진행 경매</a></li>
												<li class="menu-item menu-item-has-children"><a
													href="/auction/auctionResult">경매 결과</a></li>
											</ul></li>
										<li class="menu-item"><a href="/auction/aucEventList">이벤트
												경매</a></li>
										<li class="menu-item"><a href="/product/productList">쇼핑</a>
										</li>
										<li class="menu-item"><a href="/user/rechargePoints">포인트
												충전</a></li>
										<li class="menu-item"><a href="#">게시판</a> <i
											class="fa fa-chevron-down gen-submenu-icon"></i>
											<ul class="sub-menu">
												<li class="menu-item menu-item-has-children"><a
													href="/board/noticeBoard">공지사항</a></li>
												<li class="menu-item menu-item-has-children"><a
													href="/board/qnaBoard">문의사항</a></li>
											</ul></li>
									</ul>
								</div>
							</div>

							<%
                  if (com.icia.web.util.CookieUtil.getCookie(request, (String) request.getAttribute("AUTH_COOKIE_NAME")) == null) 
                  {
                  %>
							<!-- 회원이라면 시작 -->
							<div class="gen-header-info-box">
								<div class="gen-account-holder">
									<a href="javascript:void(0)" id="gen-user-btn"> <i
										class="fa fa-user"></i>
									</a>
									<div class="gen-account-menu">
										<ul class="gen-account-menu">
											<!-- Pms Menu -->
											<li><a href="/user/logIn"> <i
													class="fas fa-sign-in-alt"></i> 로그인
											</a></li>
											<li><a href="/user/userRegForm"> <i
													class="fa fa-user"></i> 회원가입
											</a></li>
										</ul>
									</div>
								</div>
								<div class="gen-btn-container">
									<a href="/user/logIn" class="gen-button">
										<div class="gen-button-block">
											<span class="gen-button-line-left"></span> <span
												class="gen-button-text">로그인</span>
										</div>
									</a>
								</div>
							</div>
							<!-- 회원이라면 끝 -->
							<%
                  } 
                  else 
                  {
                  %>
							<!-- 비회원이라면 시작 -->
							<div class="gen-header-info-box">
								<div class="gen-account-holder">
									<a href="javascript:void(0)" id="gen-user-btn"> <i
										class="fa fa-user"></i>
									</a>
									<div class="gen-account-menu">
										<ul class="gen-account-menu">
											<!-- Library Menu -->
											<li><a href="/user/logOut"> <i
													class="fas fa-sign-in-alt"></i> 로그아웃
											</a></li>
											<li><a href="/myPage/myPageMain"> <i
													class="fa fa-list"></i> 마이페이지
											</a></li>
											<li><a href="/user/userUpdate"> <i
													class="fa fa-upload"></i> 회원정보수정
											</a></li>
											<li><a href="/user/userDrop"> <i
													class="fas fa-sign-in-alt"></i> 회원탈퇴
											</a></li>
										</ul>
									</div>
								</div>
								<div class="gen-account-holder position-relative" id="cartCount">
									<a href="/product/productCart" id="gen-cart-btn"> <i
										class="fa fa-cart-plus ms-2"></i> <span
										class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-warning">
											<c:out value="${totalCount}" />
									</span>
									</a>
								</div>
								<div class="gen-btn-container">
									<a href="/user/logOut" class="gen-button">
										<div class="gen-button-block">
											<span class="gen-button-line-left"></span> <span
												class="gen-button-text">로그아웃</span>
										</div>
									</a>
								</div>
							</div>
							<!--   비회원이라면 끝 -->
							<%
                  }
                  %>

							<button class="navbar-toggler" type="button"
								data-toggle="collapse" data-target="#navbarSupportedContent"
								aria-controls="navbarSupportedContent" aria-expanded="false"
								aria-label="Toggle navigation">
								<i class="fas fa-bars"></i>
							</button>
						</nav>
					</div>
				</div>
			</div>
		</div>
	</header>
	<!--========== Header ==============-->
	<form name="voteUploadListForm2" id="voteUploadListForm2" method="post">
		<input type="hidden" name="searchType" value="${searchType}" /> <input
			type="hidden" name="curPage" value="${curPage}" />
	</form>
	<form name="voteForm2" id="voteForm2" method="post">
		<input type="hidden" name="searchType" value="${searchType}" /> <input
			type="hidden" name="curPage" value="${curPage}" />
	</form>
</body>
</html>