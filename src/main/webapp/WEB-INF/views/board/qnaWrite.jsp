<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<script type="text/javascript">
$(document).ready(function() {
    
   $("#qaTitle").focus();
   
   
   /* Sweetalert 수정 시작 */
   $("#btnWrite").on("click", function() {
		//버튼에 대해서 비활성화 처리를 한다.
		$("#btnWrite").prop("disabled",true);		//글쓰기 버튼 비활성화 : ajax할때는 이런것까지 고려 2번 저장하면 안되니까.
		
		if($.trim($("#qaTitle").val()).length <=0)
		{
			$("#qaTitle").val("");
			$("#qaTitle").focus();
			$("#btnWrite").prop("disabled",false);		//글쓰기 버튼 활성화
			Swal.fire('제목을 입력하세요.', '', 'warning');
			return;
		}
		if($.trim($("#qaContent").val()).length <=0)
		{
			$("#qaContent").val("");
			$("#qaContent").focus();
			$("#btnWrite").prop("disabled",false);		//글쓰기 버튼 활성화
			Swal.fire('내용을 입력하세요.' ,'' ,'warning');
			return;
		}
		
		$.ajax({
			type:"POST",
			url:"/board/qnaWriteProc",
			data:{
				 userId:$("#userId").val(),
				 userNick:$("#userNick").val(),
				 qaTitle:$("#qaTitle").val(),
	    		 qaContent:$("#qaContent").val()
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
	    				title : '게시물이 등록되었습니다.',
	    				icon : 'success'
	    			}).then(function (){
	    				location.href="/board/qnaBoard";
	    			})
	    		}
		    	else if(response.code == 400)
	    		{    			
	    			$("#qaTitle").focus();
	    			$("#btnWrite").prop("disabled",false);
	    			Swal.fire('파라미터 값이 올바르지 않습니다.' ,'' ,'warning');
	    		}
		    	else
	    		{
	    			$("#qaTitle").focus();
	    			$("#btnWrite").prop("disabled",false);
	    			Swal.fire('게시물 등록 중 오류 발생' ,'' ,'warning');
	    		}
		    },
		    error:function(xhr,status,error)
		    {
		    	icia.common.error(error);
		    	$("#btnWrite").prop("disabled",false);	//글쓰기버튼 활성화
		    	Swal.fire('게시물 등록 중 오류가 발생하였습니다.' ,'' ,'warning');
		    }
				
		});
		
   });
   
   /* Sweetalert 수정 끝 */
   
   $("#btnList").on("click", function() {
	document.bbsForm.action="/board/qnaBoard";
	document.bbsForm.submit();
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
						<h3 class="comment-reply-title">게시물 작성</h3>
						<br>
						<div class="row">
							<div class="col-lg-12">
								<form name="writeForm" id="writeForm" method="post">
									<div class="row">
										<div class="col-xl-4 col-md-4">
											<p class="comment-form-author">
												<input type="hidden" name="userId" id="userId"
													value="${user.userId}" /> <input type="text"
													name="userNick" id="userNick" value="${user.userNick}"
													readonly>
											</p>
										</div>
										<div class="col-xl-8 col-md-4">
											<p class="comment-form-email">
												<input type="text" name="qaTitle" id="qaTitle"
													placeholder="제목을 입력해주세요." required>
											</p>
										</div>

										<div class="col-xl-12">
											<p class="comment-form-comment">
												<textarea name="qaContent" id="qaContent" rows="6" cols="60"
													placeholder="내용을 입력해주세요" required></textarea>
											</p>
										</div>
									</div>

									<a class="gen-button" id="btnWrite"> <span class="text" style="cursor:pointer;">저장</span>
									</a> <a class="gen-button" id="btnList"
										style="background-color: gray;"> <span class="text" style="cursor:pointer;">리스트</span>
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
		<input type="hidden" name="searchType" value="" /> <input
			type="hidden" name="searchValue" value="" /> <input type="hidden"
			name="curPage" value="" />
	</form>
	<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>