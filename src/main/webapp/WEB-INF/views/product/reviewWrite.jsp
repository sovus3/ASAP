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
		   document.reviewForm.action="/myPage/myPageOrderDetail";
		   document.reviewForm.submit();
	   });
	   
      //썸머노트 라이브러리 사용
      $('#reviewContent').summernote({
         placeholder : '리뷰를 작성해주세요...',
         tabsize : 4,      //탭 칸 수
         height : 400,      //에디터 높이
         maxHeight: null,   // 최대 높이
         focus: true,      // 에디터 로딩 후 포커스 설정
         lang: 'ko-KR',      // 언어 설정 (한국어)
      
         callbacks: {   //여기 부분이 이미지를 첨부하는 부분
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
       $("#btnReviewWrite").click(function() {
          //ajax 통신 끝나기 전까지 글쓰기 버튼 비활성화 처리
         $("#btnReviewWrite").prop("disabled", true);
          
         if($.trim($("#reviewContent").val()).length <= 0)
         {
            Swal.fire('내용을 입력하세요.', '', 'warning');
            $("#reviewContent").val("");
            $("#reviewContent").focus();
            
            //글쓰기 버튼 활성화 처리
            $("#btnReviewWrite").prop("disabled", false);
            
            return;
         }
         
         //내용이 정상적으로 입력됐다면
         var form = $("#writeForm")[0]; //writeForm의 0번째를 받아서 form에 담고
         var formData = new FormData(form); //담은 것은 formData에 저장
         
         $.ajax({
            type : "POST",
            url : "/product/reviewWriteProc",
            data : {
               userId:$("#userId").val(),
               summernote:$("#reviewContent").val(),
               orderNo:$("#orderNo").val(),
               productSeq:$("#productSeq").val(),
            },
            datatype : "JSON",
            beforeSend : function(xhr) {
               //ajax 통신이라는 requestHeader 정보에 삽입(없어도 됨, 오류 안남)
               xhr.setRequestHeader("AJAX", "true");
            },
            success : function(response) {
               //정상
               if (response.code == 0) {
                  Swal.fire({title: '리뷰 작성이 완료됐습니다.', 
                      		  icon: 'success'
              	   }).then(function(){
                  	  document.reviewForm.action="/myPage/myPageOrderDetail"
                      document.reviewForm.submit();
              	   })
               }
               else {
                  $("#reviewContent").focus();
                  //글쓰기 버튼 활성화
                  $("#btnReviewWrite").prop("disabled", false);
                  Swal.fire('리뷰 등록 중 오류 발생했습니다.', '', 'warning');
               }
            },
            error : function(xhr, status, error) {
               $("#btnReviewWrite").prop("disabled", false);
               Swal.fire('리뷰 등록 중 오류 발생했습니다.', '', 'warning');
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
           url: "/api/uploadSummernoteImageFile",
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
   <div class="gen-breadcrumb" style="background-image: url('/resources/images/background/back.png');">
      <div class="container">
         <div class="row align-items-center">
            <div class="col-lg-12">
               <nav aria-label="breadcrumb">
                  <div class="gen-breadcrumb-title">
                     <h1>리뷰 작성</h1>
                  </div>
                  <div class="gen-breadcrumb-container">
                     <ol class="breadcrumb">
                        <li class="breadcrumb-item">
                           <a href="index.html"> 
                              <i class="fas fa-home mr-2"></i> 홈
                           </a>
                        </li>
                        <li class="breadcrumb-item active">리뷰 작성</li>
                     </ol>
                  </div>
               </nav>
            </div>
         </div>
      </div>
   </div>
   <!-- breadcrumb -->
   <div class="container-fluid py-5" style="width:60% !important; margin:0 auto !important;">
      <div class="col-md-12">
         <form id="writeForm" enctype="multipart/form-data">
            <h2 class="mb-4">리뷰 작성</h2>
            <small style="color: white !important;">"${user.userNick}"님 상품에 대한 다양한 후기를 알려주세요<i class="fa fa-heart" aria-hidden="true"></i></small>
            <br><br>
            <div class="row">
               <div class="col-xl-4 col-md-4">
                  <label for="orderNo" style="color: white !important;">주문 번호</label>
                  <input type="text" id="orderNo" name="orderNo" value="${orderDetail.orderNo}" readonly>
               </div>
               
               <div class="col-xl-6 col-md-6">
                  <label for="productSeq" style="color: white !important;">상품명</label>
                  <input type="text" id="productName" name="productName" value="${orderDetail.productName}" readonly>
               </div>
               
               <div class="col-xl-12 mt-3">
                  <label for="message" style="color: white !important;">내용</label>
                  <textarea id="reviewContent" name="content" style="color: white !important;"></textarea>
               </div>
            
               <div class="col-xl-12 mt-3">
                  <input type="button" id="btnReviewWrite" value="작성하기" class="btn px-3 mr-2">
                  <input type="button" id="btnProductDetail" value="리스트" class="btn btn-primary px-3" style="background-color:gray">
               </div>
                  
            </div>
         </form>
      </div>
   </div>

   <form name="reviewForm" id="reviewForm" method="post">
      <input type="hidden" name="productSeq" id="productSeq" value="${orderDetail.productSeq}" />
      <input type="hidden" name="orderNo" id="orderNo" value="${orderDetail.orderNo}" />
   </form>
   
       <%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-bs4.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-bs4.min.js"></script>
</html>