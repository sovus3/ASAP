<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>

<style>
th, td {
   border-color: transparent !important;
}
</style>

<script>
$(document).ready(function() {
	
	$("#btnList").on("click", function() {
		document.bbsForm.action="/myPage/myPageQna";
		document.bbsForm.submit();
	});

   $("#qaTitle").focus();
   
   $("#btnUpdate").on("click", function() {
	   
	   $("#btnUpdate").prop("disabled",true);

	   if($.trim($("#qaTitle").val()).length <=0 ){
		   $("#qaTitle").val("");
		   $("#qaTitle").focus();
		   $("#btnUpdate").prop("disabled",false);
		   Swal.fire('제목을 입력하세요.', '', 'warning');
		   return;
	   }
	   if($.trim($("#qaContent").val()).length <=0 ){
		   $("#qaContent").val("");
		   $("#qaContent").focus();
		   $("#btnUpdate").prop("disabled",false);
		   Swal.fire('내용을 입력하세요.', '', 'warning');
		   return;
	   }
	   
	   $.ajax({
    	  type:"POST",
    	  url:"/board/qnaUpdateProc",
    	  data:{
    		  qaSeq:$("#qaSeq").val(),
    		  qaTitle:$("#qaTitle").val(),
    		  qaContent:$("#qaContent").val()
    	  },
    	  datatype:"JSON",
		  beforeSend:function(xhr){
			  xhr.setRequestHeader("AJAX","true");
		  },
		  success:function(response){
			  if(response.code == 0){
				  Swal.fire({title: '게시물이 수정되었습니다.', 
							  icon: 'success'
					}).then(function(){
					  document.bbsForm.action = "/myPage/myPageQna";
					  document.bbsForm.submit();
					})
			  }
			  else if(response.code == 400){
				  Swal.fire('파라미터 값이 올바르지 않습니다.', '', 'warning');
				  $("#btnUpdate").prop("disabled",false);
			  }
			  else if(response.code == 403){
				  Swal.fire('본인 게시물이 아닙니다.', '', 'warning');
				  $("#btnUpdate").prop("disabled",false);
			  }
			  else if(response.code == 404){
					  Swal.fire({title: '게시물을 찾을 수 없습니다.', 
						  		  icon: 'warning'
						}).then(function(){
							location.href="/myPage/myPageQna";
						})
			  }
			  else{
				  Swal.fire('게시물 수정 중 오류가 발생하였습니다.', '', 'warning');
				  $("#btnUpdate").prop("disabled",false);	//버튼 활성화 
			  }
		  },
		  error:function(xhr, status, error){
			  icia.common.error(error);
			  Swal.fire('게시물 수정 중 오류가 발생하였습니다.', '', 'warning');
			  $("#btnUpdate").prop("disabled",false);
		  }
		  
	   });

   });

});
</script>
</head>
<body>
   <%@ include file="/WEB-INF/views/include/navigation.jsp"%>

   <!-- breadcrumb -->
   <div class="gen-breadcrumb"
      style="background-image: url('/resources/images/background/back.png');">
      <div class="container">
         <div class="row align-items-center">
            <div class="col-lg-12">
               <nav aria-label="breadcrumb">
                  <div class="gen-breadcrumb-title">
                     <h1>마이페이지</h1>
                  </div>
                  <div class="gen-breadcrumb-container">
                     <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="index.html"> <i
                              class="fas fa-home mr-2"></i>홈
                        </a></li>
                        <li class="breadcrumb-item active">마이페이지</li>
                     </ol>
                  </div>
               </nav>
            </div>
         </div>
      </div>
   </div>
   <!-- breadcrumb -->

   <!-- Blog-left-Sidebar -->
   <section class="gen-section-padding-3">
      <div class="container">
         <div class="row">
         
				<!-- 사이드바 시작 -->
					<div class="col-xl-3 col-md-12 order-2 order-xl-1 mt-4 mt-xl-0" style="width:20%;">
						<div class="widget widget_recent_entries">
							<h2 class="widget-title"><a href="/myPage/myPageMain">마이페이지</a></h2>
							<ul>
								<li><a href="/myPage/userUpdate">회원정보수정</a></li>
								<li><a href="/myPage/myPagePay">결제내역</a></li>	
								<li><a href="/myPage/myPageVote">투표내역</a></li>	
								<li><a href="/myPage/myPageAucCur">입찰내역</a></li>
								<li><a href="/myPage/myPageQna">문의내역</a></li>
								<c:if test="${user.userCode == 'A'}">
								<li><a href="/myPage/myPageVoteUpload">투표작품신청내역</a></li>
								<li><a href="/myPage/artAucResult">경매결과내역</a></li>
								</c:if>
							</ul>
						</div>
					</div>
	            <!-- 사이드바 끝 -->

            <!-- 문의내역 시작 -->
            <div class="col-xl-9 col-md-12 order-1 order-xl-2">
               <div class="gen-blog gen-blog-col-1">
                  <div class="row">
                     <div class="col-lg-12">
                        <hr>
                        <div class="container bootstrap snippets bootdey">
                           <div class="row">
                              <div class="col-lg-12 mb-3 mt-3">
                                 <h4>문의내역 수정</h4>
                              </div>
                           </div>
                           <div class="row">
                              <!--/col-3-->
                              <div class="col-lg-12">
                                 <form name="updateForm" id="updateForm" method="post">
                                    <div class="row">
                                       <div class="col-xl-4">
                                          <p class="comment-form-author">
                                          <span>닉네임</span>
                                             <input type="text" name="userNick" id="userNick" value="${qnaBoard.userNick}" readonly>
                                          </p>
                                       </div>
                                       <br>
                                       <br>
                                       <div class="col-xl-12">
                                          <p class="comment-form-email">
                                          	 <span>제목</span>
                                             <input type="text" name="qaTitle" id="qaTitle" placeholder="제목을 입력해주세요." value="${qnaBoard.qaTitle}" required>
                                          </p>
                                       </div>
                                       <br>
                                       <br>
                                       <div class="col-xl-12">
                                          <p class="comment-form-comment">
                                          <span>내용</span>
                                             <textarea name="qaContent" id="qaContent" rows="6" cols="60" placeholder="내용을 입력해주세요" required>${qnaBoard.qaContent}
                                             </textarea>
                                          </p>
                                       </div>
                                    </div>
                                    <br><br>
                                    <a class="gen-button" id="btnUpdate"> 
                                       <span class="text">수정</span>
                                    </a> 
                                    <a class="gen-button" id="btnList" style="background-color: gray;"> 
                                       <span class="text">리스트</span>
                                    </a>
                                 </form>
                              </div>
                           </div>
                           <!--/col-9-->
                        </div>
                        <!--/row-->
                     </div>
                  </div>
               </div>
            </div>
            <!-- 문의내역 끝 -->
         </div>
      </div>
   </section>
   <!-- Blog-left-Sidebar -->
     <form name="bbsForm" id="bbsForm" method="post">
		<input type="hidden" name="qaSeq" id="qaSeq" value="${qnaBoard.qaSeq}" />
		<input type="hidden" name="curPage" value="${curPage}" />
	</form>

   <%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>