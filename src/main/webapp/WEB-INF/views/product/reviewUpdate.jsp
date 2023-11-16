<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>

<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>


<style>
body {
	background: #161616;
	color: #000000 !important;
}

p {
	margin:-5px -5px -5px 0px !important;
}

.star-rating {
	display: flex;
	flex-direction: row-reverse;
	font-size: 1.7rem;
	line-height: 1.95rem;
	justify-content: space-around;
	padding: 0 0.2em;
	text-align: center;
	width: 5em;
	margin-left: 20px !important;
}

.star-rating input {
	display: none;
}

.star-rating label {
	-webkit-text-fill-color: white;
	/* Will override color (regardless of order) */
	-webkit-text-stroke-width: 2.3px;
	-webkit-text-stroke-color: #2b2a29;
	cursor: pointer;
}

.star-rating :checked ~ label {
	-webkit-text-fill-color: gold;
	-webkit-text-stroke-color: gold;
}

.star-rating label:hover, .star-rating label:hover ~ label {
	-webkit-text-fill-color: #fff58c;
}
</style>

<script>
   $(document).ready(function() {
	   
	   $("#btnProductDetail").click(function(){
		   document.reviewForm.action="/product/productDetail";
		   document.reviewForm.submit();
	   });
	   
	   //썸머노트 라이브러리 사용
	   $('#reviewContent').summernote({
			placeholder : '리뷰를 작성해주세요...',
			tabsize : 4,		//탭 칸 수
			height : 400,		//에디터 높이
			maxHeight: null,	// 최대 높이
			focus: true,		// 에디터 로딩 후 포커스 설정
			lang: 'ko-KR',		// 언어 설정 (한국어)
	   
			callbacks: {	//여기 부분이 이미지를 첨부하는 부분
	            onImageUpload: function (files) {
	                uploadSummernoteImageFile(files[0], this);
	            },
	            onPaste: function (e) {
	                let clipboardData = e.originalEvent.clipboardData;
	                if (clipboardData && clipboardData.items && clipboardData.items.length) 
	                {
	                    let item = clipboardData.items[0];
	                    if (item.kind === 'file' && item.type.indexOf('image/') !== -1) 
	                    {
	                        e.preventDefault();
	                    }
	                }
	            }
	        }
		});
	   
		// "작성하기" 버튼 클릭 시 실행되는 함수
	    $("#btnReviewUpdate").click(function() {
	    	console.log("#reviewSeq", $("#reviewSeq").val());
	    	
	    	//ajax 통신 끝나기 전까지 글쓰기 버튼 비활성화 처리
			$("#btnReviewUpdate").prop("disabled", true);
	    	
			if($.trim($("#reviewContent").val()).length <= 0)
			{
				$("#reviewContent").val("");
				$("#reviewContent").focus();
				Swal.fire('내용을 입력하세요.', '', 'warning');
				
				//글쓰기 버튼 활성화 처리
				$("#btnReviewUpdate").prop("disabled", false);
				
				return;
			}
			
			//내용이 정상적으로 입력됐다면
			var form = $("#writeForm")[0]; //writeForm의 0번째를 받아서 form에 담고
			var formData = new FormData(form); //담은 것은 formData에 저장
			
			$.ajax({
				type : "POST",
				url : "/product/reviewUpdateProc",
				data : {
					reviewSeq:$("#reviewSeq").val(),
					summernote:$("#reviewContent").val()
				},
				datatype : "JSON",
				beforeSend : function(xhr) {
					//ajax 통신이라는 requestHeader 정보에 삽입(없어도 됨, 오류 안남)
					xhr.setRequestHeader("AJAX", "true");
				},
				success : function(response) {
					//정상
					if (response.code == 0) 
					{
						Swal.fire({title: '리뷰 수정이 완료됐습니다.', 
		                       		icon: 'success'
		               	}).then(function(){
							document.reviewForm.action = "/product/productDetail";
							document.reviewForm.submit();
		               	})
					}
					else if(response.code == 400)
					{
						$("#reviewContent").focus();
						//글쓰기 버튼 활성화
						$("#btnReviewUpdate").prop("disabled", false);
						Swal.fire('넘어온 값 없습니다.', '', 'warning');
					}
					else if(response.code == 404)
					{
						$("#reviewContent").focus();
						//글쓰기 버튼 활성화
						$("#btnReviewUpdate").prop("disabled", false);
						Swal.fire('찾을 수 없습니다.', '', 'warning');
					}
					else if(response.code == 500)
					{
						$("#reviewContent").focus();
						//글쓰기 버튼 활성화
						$("#btnReviewUpdate").prop("disabled", false);
						Swal.fire('서버 오류 입니다.', '', 'warning');
					}
					else 
					{
						$("#reviewContent").focus();
						//글쓰기 버튼 활성화
						$("#btnReviewUpdate").prop("disabled", false);
						Swal.fire('리뷰 수정 중 오류 발생', '', 'warning');
					}
				},
				error : function(xhr, status, error) {
					$("#btnReviewUpdate").prop("disabled", false);
					Swal.fire('리뷰 수정 중 오류 발생', '', 'warning');
					icia.common.error(error);				
				}
			});
		});
	    	
	});
   
   /*이미지 파일 업로드*/
   function uploadSummernoteImageFile(file) {
       const data = new FormData();
       data.append("file", file);
       $.ajax({
           data: data,
           type: "POST",
           url: "/api/uploadSummernoteImageFile2",
           contentType: false,
           processData: false,
           success: function (data) {
               //항상 업로드된 파일의 url이 있어야 한다.
               $("#reviewContent").summernote('insertImage', data.url);
           }
       });
   }
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
							<h1>리뷰 수정</h1>
						</div>
						<div class="gen-breadcrumb-container">
							<ol class="breadcrumb">
								<li class="breadcrumb-item">
									<a href="index.html"> 
										<i class="fas fa-home mr-2"></i> 홈
									</a>
								</li>
								<li class="breadcrumb-item active">리뷰 수정</li>
							</ol>
						</div>
					</nav>
				</div>
			</div>
		</div>
	</div>
	<!-- breadcrumb -->
	<div class="container-fluid py-5" style="width: 80%;">
		<div class="col-md-12">
			<form id="writeForm" enctype="multipart/form-data">
				<h2 class="mb-2">리뷰 수정</h2>
				<small style="color: white !important;">${review.userId}님, 남기신 상품 리뷰를 수정해보세요<i class="fa fa-heart" aria-hidden="true"></i></small>
				<!--
				<div class="d-flex my-3" style="color: white !important;">
					<p class="mb-0 mr-2">별점* :</p>
					<div class="text-primary">
						<div class="star-rating space-x-4 mx-auto" id="star">
							<input type="radio" id="5-stars" name="rating" value="5" /> <label
								for="5-stars" class="star pr-4"> <i class="far fa-star"></i>
							</label> <input type="radio" id="4-stars" name="rating" value="4" /> <label
								for="4-stars" class="star"> <i class="far fa-star"></i>
							</label> <input type="radio" id="3-stars" name="rating" value="3" /> <label
								for="3-stars" class="star"> <i class="far fa-star"></i>
							</label> <input type="radio" id="2-stars" name="rating" value="2" /> <label
								for="2-stars" class="star"> <i class="far fa-star"></i>
							</label> <input type="radio" id="1-star" name="rating" value="1" /> <label
								for="1-star" class="star"> <i class="far fa-star"></i>
							</label>
						</div>
					</div>
				</div>
				-->
				<div class="row">
					<div class="col-xl-4 col-md-4 mt-3">
						<label for="orderNo" style="color: white !important;">주문 번호</label>
						<input type="text" id="orderNo" name="orderNo" value="${review.orderNo}" readonly>
					</div>
					
					<div class="col-xl-4 col-md-6 mt-3">
						<label for="orderNo" style="color: white !important;">상품명</label>
						<input type="text" id="productName" name="productName" value="${review.productName}" readonly>
					</div>
					
					<div class="col-xl-12 mt-3">
						<label for="message" style="color: white !important;">내용</label>
						<textarea id="reviewContent" name="content" style="color: white !important;">${review.reviewContent}</textarea>
					</div>
					
					<div class="col-xl-12 mt-3">
						<input type="button" id="btnReviewUpdate" value="수정하기" class="btn btn-primary px-3 mr-3"> 
						<input type="button" id="btnProductDetail" value="리스트" class="btn btn-primary px-3">
					</div>
				</div>
			</form>
		</div>
	</div>

	<form name="reviewForm" id="reviewForm" method="post">
		<input type="hidden" name="reviewSeq" id="reviewSeq" value="${review.reviewSeq}" /> 
		<input type="hidden" name="productSeq" value="${review.productSeq}" /> 
		<input type="hidden" name="orderNo" value="${review.orderNo}" />
	</form>

	<%@ include file="/WEB-INF/views/include/footer2.jsp"%>
</body>
<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-bs4.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-bs4.min.js"></script>
</html>