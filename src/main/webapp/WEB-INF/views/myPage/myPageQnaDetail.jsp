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

	$("#btnUpdate").on("click", function() {
		document.bbsForm.action="/myPage/myPageQnaUpdate";
		document.bbsForm.submit();
	});
	
	$("#btnDelete2").on("click", function(){
        Swal.fire({
            title: '게시물을 삭제하시겠습니까?',
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: '확인',
            cancelButtonText: '취소'
        }).then((result) => {
            if (result.isConfirmed) {
			$.ajax({
					type:"POST",
					url:"/board/qnaDelete",
					data: { 
						qaSeq: $("#qaSeq").val()
					},
					dataType:"JSON",
					beforeSend:function(xhr){
						xhr.setRequestHeader("AJAX", "true");
					},
					success:function(response)
					{
						if(response.code == 0){
				    		Swal.fire({title: '게시물이 삭제되었습니다.', 
	                       				icon: 'success'
	               			}).then(function(){
	               				location.href="/myPage/myPageQna";
	               			})
						}
						else if(response.code == 404){
				    		Swal.fire({title: '해당 게시물을 찾을 수 없습니다.', 
	               						icon: 'warning'
			       			}).then(function(){
			       				location.href="/myPage/myPageQna";
			       			})
						}
						else if(response.code == 403){
							Swal.fire('본인 글이 아니므로 삭제할 수 없습니다.', '', 'warning');
						}
						else if(response.code == 400){
							Swal.fire('파라미터 값이 올바르지 않습니다.', '', 'warning');
						}
						else{
							Swal.fire('게시물 삭제 중 오류가 발생하였습니다.', '', 'warning');
						}
					},
					error(xhr, status, error){
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
                              <!--/col-3-->
                              <div class="col-lg-12">
                                 <div class="gen-blog-post mt-5">
                                    <div class="gen-blog-contain">
                                       <h2>
                                          <c:out value="${qnaBoard.qaTitle}" />
                                       </h2>
                                       <br>
                                       <div class="gen-post-meta">
                                          <ul>
                                             <li class="gen-post-author">
                                                <i class="fa fa-user"></i>
                                                <c:out value="${qnaBoard.userNick}" />
                                             </li>
                                             <li class="gen-post-meta">
                                                <a href="#">
                                                   <i class="fa fa-calendar"></i>${qnaBoard.regDate}
                                                </a>
                                             </li>
                                             <li class="gen-post-tag">
                                                <a href="#">
                                                   <i class="fa fa-tag"></i>문의사항
                                                </a>
                                             </li>
                                          </ul>
                                       </div>
                                       <p>
                                          <c:out value="${qnaBoard.qaContent}" />
                                       </p>
                                    </div>
                                 </div>
                              </div>
                           </div>
                           <!--/col-9-->
                        </div>
                        <!--/row-->
                     </div>
                  </div>
               </div>
               
               <!-- 여러버튼시작 -->
               <a class="gen-button gen-button-flat ml-5" id="btnList">
                  <span class="text" style="cursor:pointer;">리스트</span>
               </a> 
               <c:if test="${boardMe == 'Y'}">
	               <a class="gen-button gen-button-flat" id="btnUpdate" style="background-color:#4E64A6;">
	                  <span class="text" style="cursor:pointer;">수정</span>
	               </a>
	               <a class="gen-button gen-button-flat" id="btnDelete2" style="background-color:gray;">
	                  <span class="text" style="cursor:pointer;">삭제</span>
	               </a> 
               </c:if>
               <c:if test="${boardMe == 'A'}">
	               <a class="gen-button gen-button-flat" id="btnUpdate" style="background-color:#4E64A6;">
	                  <span class="text" style="cursor:pointer;">수정</span>
	               </a>
	               <a class="gen-button gen-button-flat" id="btnDelete2" style="background-color:gray;">
	                  <span class="text" style="cursor:pointer;">삭제</span>
	               </a> 
               </c:if>
               <br/>
               <br/>
               <!-- 여러버튼끝 -->
               
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