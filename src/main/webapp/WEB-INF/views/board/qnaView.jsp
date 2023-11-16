<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%
// 개행문자 값을 저장한다.
pageContext.setAttribute("newLine", "\n");
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<script type="text/javascript">
$(document).ready(function() {

   $("#btnList").on("click", function() {
	document.bbsForm.action="/board/qnaBoard";
	document.bbsForm.submit();
   });

   $("#btnUpdate").on("click", function() {
	document.bbsForm.action="/board/qnaUpdate";
	document.bbsForm.submit();
   });
   
   $("#btnReply").on("click", function() {
		document.bbsForm.action="/board/qnaReply";
		document.bbsForm.submit();
   });
   
   /* Sweetalert 수정 시작 */
   
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
				url:"/board/qnaDelete",
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
							title : '게시물이 삭제되었습니다.',
							icon : 'success'
						}).then(function() {
							location.href="/board/qnaBoard";	
						})					
					}
					else if(response.code == 404)
					{
						Swal.fire({
							title : '해당 게시물을 찾을 수 없습니다.',
							icon : 'warning'
						}).then(function() {
							location.href="/board/qnaBoard";
						})
					}
					else if(response.code == 403)
					{
						Swal.fire('본인 글이 아니므로 삭제할 수 없습니다.' ,'' ,'warning');
					}
					else if(response.code == 400)
					{
						Swal.fire('파라미터 값이 올바르지 않습니다.' ,'' ,'warning');
					}
					else
					{
						Swal.fire('게시물 삭제 중 오류가 발생하였습니다.' ,'' ,'warning');
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
		$("#btnDelete2").on("click", function(){
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
				url:"/board/qnaDelete2",
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
							title : '게시물이 삭제되었습니다.',
							icon : 'success'
						}).then(function() {
							location.href="/board/qnaBoard";
						})
					}
					else if(response.code == 404)
					{
						Swal.fire({
							title : '해당 게시물을 찾을 수 없습니다',
							icon : 'warning'
						}).then(function() {
							location.href="/board/qnaBoard";
						})
					}
					else if(response.code == 403)
					{
						Swal.fire('본인 글이 아니므로 삭제할 수 없습니다.' ,'' ,'warning');
					}
					else if(response.code == 400)
					{
						Swal.fire('파라미터 값이 올바르지 않습니다.' ,'' ,'warning');
					}
					else
					{
						Swal.fire('게시물 삭제 중 오류가 발생하였습니다.' ,'' ,'warning');
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


/* Sweetalert 수정 끝 */

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
							<h1>문의사항 게시판</h1>
						</div>
						<div class="gen-breadcrumb-container">
							<ol class="breadcrumb">
								<li class="breadcrumb-item"><a href="index.html"><i
										class="fas fa-home mr-2"></i>홈</a></li>
								<li class="breadcrumb-item active">문의사항 게시판</li>
							</ol>
						</div>
					</nav>
				</div>
			</div>
		</div>
	</div>
	<!-- breadcrumb -->

	<!-- blog single -->
	<section class="gen-section-padding-3">
		<div class="container">
			<div class="row">
				<!-- 게시물 상세 1개 시작 -->
				<div class="col-lg-9 col-md-12">
					<div class="gen-blog-post">
						<div class="gen-blog-contain">
							<h2>
								<c:out value="${qnaBoard.qaTitle}" />
							</h2>
							<br>
							<div class="gen-post-meta">
								<ul>
									<li class="gen-post-author"><i class="fa fa-user"></i> <c:out
											value="${qnaBoard.userNick}" /></li>
									<li class="gen-post-meta"><a href="#"><i
											class="fa fa-calendar"></i>${qnaBoard.regDate}</a></li>
									<li class="gen-post-tag"><a href="#"><i
											class="fa fa-tag"></i>문의사항</a></li>
								</ul>
							</div>
							<p style="font-size:18px">
								<c:out value="${qnaBoard.qaContent}" />
							</p>
							
							<!-- 버튼 시작 -->
							<br><br>
							<a class="gen-button gen-button-flat" id="btnList"> 
							    <span class="text" style="cursor:pointer;">리스트</span>
							</a>
							
							<c:if test="${boardMe2 eq 'Y'}">
							    <a class="gen-button gen-button-flat" id="btnReply" style="background-color: #4E64A6;"> 
							        <span class="text" style="cursor:pointer;">답변</span>
							    </a>
							    <a class="gen-button gen-button-flat" id="btnDelete2" style="background-color: gray;"> 
							        <span class="text" style="cursor:pointer;">삭제</span>
							    </a>
							</c:if>
							
							<c:if test="${boardMe1 eq 'Y'}">
							    <a class="gen-button gen-button-flat" id="btnUpdate"> 
							        <span class="text" style="cursor:pointer;">수정</span>
							    </a>
							    <a class="gen-button gen-button-flat" id="btnDelete"> 
							        <span class="text" style="cursor:pointer;">삭제</span>
							    </a>
							</c:if>
							<br /><br />
							<!-- 버튼 끝 -->
						</div>
					</div>
				</div>
				<!-- 게시물 상세 1개 끝 -->

				<!-- 카테고리 시작 -->
				<div class="col-lg-3 col-md-12 mt-4 mt-lg-0">
					<div class="widget widget_categories">
						<h2 class="widget-title">카테고리</h2>
						<ul>
							<li class="cat-item cat-item-1"><a href="/board/qnaBoard">문의사항</a></li>
							<li class="cat-item cat-item-1"><a href="/board/noticeBoard">공지사항</a></li>
						</ul>
					</div>
				</div>
				<!-- 카테고리 끝 -->
			</div>
		</div>
	</section>
	<!-- blog single -->

	<form name="bbsForm" id="bbsForm" method="post">
		<input type="hidden" name="qaSeq" id="qaSeq" value="${qnaBoard.qaSeq}" />
		<input type="hidden" name="searchType" value="${searchType}" /> <input
			type="hidden" name="searchValue" value="${searchValue}" /> <input
			type="hidden" name="curPage" value="${curPage}" />
	</form>
	<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>