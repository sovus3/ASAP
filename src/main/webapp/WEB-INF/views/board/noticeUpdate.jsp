<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<script type="text/javascript">

/* Sweetalert 수정 시작 */

$(document).ready(function() {

   $("#nbTitle").focus();
   
   $("#btnUpdate").on("click", function() {
	   $("#btnUpdate").prop("disabled",true);	//버튼 비활성화
	   if($.trim($("#nbTitle").val()).length <=0 )
	   {
		   $("#nbTitle").val("");
		   $("#nbTitle").focus();
		   Swal.fire('제목을 입력하세요.','' ,'warning');
		   $("#btnUpdate").prop("disabled",false);
		   return;
	   }
	   if($.trim($("#nbContent").val()).length <=0 )
	   {
		   $("#nbContent").val("");
		   $("#nbContent").focus();
		   Swal.fire('내용을 입력하세요.' ,'' ,'warning');
		   $("#btnUpdate").prop("disabled",false);
		   return;
	   }
	   
	   $.ajax({
    	  type:"POST",
    	  url:"/board/noticeUpdateProc",
    	  data:{
    		  nbSeq:$("#nbSeq").val(),
    		  nbTitle:$("#nbTitle").val(),
    		  nbContent:$("#nbContent").val()
    	  },
    	  datatype:"JSON",
		  beforeSend:function(xhr)
		  {
			  xhr.setRequestHeader("AJAX","true");
		  },
		  success:function(response)
		  {
			  if(response.code == 0)
			  {
				  Swal.fire({
					title : '게시물이 수정되었습니다.',
					icon : 'success'
				  }).then(function() {
					 document.bbsForm.action = "/board/noticeView";
					 document.bbsForm.submit(); 
				  })
			  }
			  else if(response.code == 400) //
			  {
				  $("#btnUpdate").prop("disabled",false);
				  Swal.fire('파라미터 값이 올바르지 않습니다.', '' ,'warning');				  
			  }
			  else if(response.code == 403)
			  {
				  $("#btnUpdate").prop("disabled",false);
				  Swal.fire('본인 게시물이 아닙니다.' ,'' ,'warning');
			  }
			  else if(response.code == 404)
			  {
				   Swal.fire({
					   title : '게시물을 찾을 수 없습니다.', 
					   icon : 'warning'
				   }).then(function(){
					   location.href="/board/noticeBoard";
				   })		
			  }
			  else
			  {
				  $("#btnUpdate").prop("disabled",false);	//버튼 활성화 
				  Swal.fire('게시물 수정 중 오류가 발생하였습니다.' ,'' ,'warning');
			  }
		  },
		  error:function(xhr, status, error)
		  {
			  icia.common.error(error);
			  $("#btnUpdate").prop("disabled",false);
			  Swal.fire('게시물 수정 중 오류가 발생하였습니다.', '', 'warning');
			  
		  }
		  
	   });

   });
   
   $("#btnList").on("click", function() {
	document.bbsForm.action="/board/noticeBoard"
	document.bbsForm.submit();
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
					<div class="comment-respond">
						<h3 class="comment-reply-title">게시물 수정</h3>
						<br>
						<div class="row">
							<div class="col-lg-12">
								<form name="updateForm" id="updateForm" method="post">
									<div class="row">
										<div class="col-xl-4 col-md-4">
											<p class="comment-form-author">
												<input type="text" name="admId" id="admId"
													value="${noticeBoard.admId}" readonly>
											</p>
										</div>
										<div class="col-xl-4 col-md-4">
											<p class="comment-form-email">
												<input type="text" name="nbTitle" id="nbTitle"
													placeholder="제목을 입력해주세요." value="${noticeBoard.nbTitle}"
													required>
											</p>
										</div>

										<div class="col-xl-12">
											<p class="comment-form-comment">
												<textarea name="nbContent" id="nbContent" rows="6" cols="60"
													placeholder="내용을 입력해주세요" required>${noticeBoard.nbContent}
	                                            </textarea>
											</p>
										</div>
									</div>

									<a class="gen-button" id="btnUpdate"> <span class="text">수정</span>
									</a> <a class="gen-button" id="btnList"
										style="background-color: gray;"> <span class="text">리스트</span>
									</a>
								</form>
							</div>
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
		<input type="hidden" name="nbSeq" id="nbSeq"
			value="${noticeBoard.nbSeq}" /> <input type="hidden"
			name="searchType" value="${searchType}" /> <input type="hidden"
			name="searchValue" value="${searchValue}" /> <input type="hidden"
			name="curPage" value="${curPage}" />
	</form>
	<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>