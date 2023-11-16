<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
	<%@ include file="/WEB-INF/views/include/head.jsp"%>
	
<style>
.aCss {
   cursor: pointer;
}
</style>
<script>
$(document).ready(function() {
	$("#btnVote").on("click", function(){
		var selectedValues = [];
		if(!$('.form-check-input').is(':checked'))
        {
           Swal.fire("투표할 작품에 체크해주세요.", '', 'info');
           return;
        }
		//if($.trim($(".form-check-input:checked").val()).length <= 0)
	   	// {
	    //	  Swal.fire("체크박스 체크 후 투표 부탁합니다.");
	    //	  return;
	   	// }
		
		// 배열 선언해서 배열에 체크한 값을 다 받아온다
	    $(".form-check-input:checked").each(function() {
              selectedValues.push($(this).val());
        });
	
		// 받은 배열값들을 문자열로 저장한다. 1, 2, 3 요렇게.	    
        var resultString = selectedValues.join(", ");
        
		$("input[name=string]").val(resultString); //서버에 보내려고 hidden값에 값 대입
           
		 
		 $.ajax({
	          type:"POST",
	          url: "/vote/doVoteProc",
	          data:{
	             string:$("#string").val() // 보낼 값   
	          },
	          datatype:"JSON",
	          beforeSend:function(xhr){
	             xhr.setRequestHeader("AJAX", "true");
	          },
	          success:function(response){
	             //응답이 있음                      
	             if(response.code == 0)
	             {
	                 Swal.fire({title: '투표가 완료되었습니다.', 
	                     		  icon: 'success'
	                    		}).then(function(){
	                     	var checkboxes = document.querySelectorAll('#voteCheck');               
	     	                checkboxes.forEach(function(checkbox){                       
	     	                checkbox.checked = false;
	                  		});
	        			})
	             }
	             else if(response.code == 100)
	             {
	                Swal.fire("투표에 실패하셨습니다.", '', 'warning');
	              
	            }
	             else if(response.code == 200)
	             {
	                Swal.fire("중복된 투표가 있습니다.", '', 'warning');
	/////////////////////////추가된 부분//////////////////////////////////////////
	                 var checkboxes = document.querySelectorAll('#voteCheck');               
	                 checkboxes.forEach(function(checkbox){                       
	                 checkbox.checked = false;
	                 });
	/////////////////////////추가된 부분//////////////////////////////////////////

	             }
	             else if(response.code == 400)
	             {
	               Swal.fire("로그인 후 투표 부탁합니다.", '', 'warning');    
	             }
	             else if(response.code == 500)
	             {
	               Swal.fire("체크박스 체크 후 투표 부탁합니다.", '', 'warning');    
	             }
	            else
	            {
	               Swal.fire(" 알수 없는 오류가 발생하였습니다.", '', 'warning');  
	            }
	          },
	          error:function(xhr, status, error){
	             icia.common.error(error);
	          }
		 });
	});
	
});

//카테고리 이동 
function searchByCategory(value) {
	document.voteUploadListForm.vrSeq.value = "";
    document.voteUploadListForm.searchType.value = value;
    document.voteUploadListForm.curPage.value = "1";
    document.voteUploadListForm.action = "/vote/voteList";
    document.voteUploadListForm.submit();	    
}
//페이지 버튼 클릭 이동
function fn_list(curPage)
{
	document.voteUploadListForm.vrSeq.value = "";
	document.voteUploadListForm.curPage.value = curPage;
	document.voteUploadListForm.action = "/vote/voteList";
	document.voteUploadListForm.submit();
}

//작품 클릭시 상세페이지 이동
function fn_detail(vrSeq) 
{
	if($("#gubun").val() == 1)
	{
		document.voteUploadListForm.vrSeq.value = vrSeq;
		document.voteUploadListForm.gubun.value = 1;
		document.voteUploadListForm.action = "/vote/voteListDetail";
		document.voteUploadListForm.submit();
	}
	else if($("#gubun").val() == 2)
	{
		document.voteUploadListForm.vrSeq.value = vrSeq;
		document.voteUploadListForm.gubun.value = 2;
		document.voteUploadListForm.action = "/vote/voteListDetail";
		document.voteUploadListForm.submit();
	}
	else if($("#gubun").val() == 3)
	{
		document.voteUploadListForm.vrSeq.value = vrSeq;
		document.voteUploadListForm.gubun.value = 3;
		document.voteUploadListForm.action = "/vote/voteListDetail";
		document.voteUploadListForm.submit();
	}
	else
	{
		document.voteUploadListForm.vrSeq.value = vrSeq;
		document.voteUploadListForm.action = "/vote/voteListDetail";
		document.voteUploadListForm.submit();
	}
    
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
                            <h1>
                                진행투표
                            </h1>
                        </div>
                        <div class="gen-breadcrumb-container">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item">
                                	<a href="index.html">
                                		<i class="fas fa-home mr-2"></i>
                                		홈
                                	</a>
                                </li>
                                <li class="breadcrumb-item active">진행투표</li>
                            </ol>
                        </div>
                    </nav>
                </div>
            </div>
        </div>
    </div>
    <!-- breadcrumb -->
    
	<!-- 카테고리 시작 -->
     <br>
    <div style="text-align:center !important;" id="_searchType" >
      <a class="gen-button gen-button-flat aCss">
            <span class="text" href="#" onclick="location.href='/vote/voteList'">전체</span>
      </a>
      <a class="gen-button gen-button-flat aCss">
            <span class="text" onclick="searchByCategory(1)">미술</span>
      </a>
      <a class="gen-button gen-button-flat aCss">
            <span class="text" onclick="searchByCategory(3)">도예</span>
      </a>
       <a class="gen-button gen-button-flat aCss">
            <span class="text" onclick="searchByCategory(2)">사진</span>
      </a>
   </div>
   <!-- 카테고리 끝 -->

	<!-- 투표 리스트 시작 -->
	<section class="gen-section-padding-3" style="margin-top:-50px !important;">
        <div class="container">
            <div class="row">
                <div class="col-lg-12">
                    <div class="row">
                    	<!-- 작품1개 시작 -->
                    	<c:if test="${!empty list}">
                    		<c:forEach var="voteUpload" items="${list}" varStatus="status">
		                        <div class="col-xl-3 col-lg-4 col-md-6">
		                            <div class="gen-carousel-movies-style-3 movie-grid style-3">
		                                <div class="gen-movie-contain">
		                                    <div class="gen-movie-img">
		                                    	<!-- 이미지 경로 시작 -->
		                                        <img src="/resources/upload/vote/${voteUpload.vrSeq}.png" alt="single-video-image">
		                                        <!-- 이미지 경로 끝 -->
		                                        <div class="gen-movie-action" style="cursor:pointer;">
		                                        	<!-- '+'아이콘 클릭시 팝업 화면 띄움 -->
		                                            <a onclick="fn_detail(${voteUpload.vrSeq})" class="gen-button" name="voteDetail">
		                                                <i class="fa fa-plus"></i>
		                                            </a>
		                                        </div>
		                                    </div>
		                                    <div class="gen-info-contain">
												<!-- 체크박스 시작 -->
												<div class="gen-movie-info form-check">
													<h3>
														<input class="form-check-input voteCheckBox" type="checkbox" id="voteCheck" name="voteCheck" value="${voteUpload.vrSeq}"> 
														<label class="form-check-label" for="exampleRadios1"> 
															<a href="/vote/voteDetail">${voteUpload.vrTitle}</a>
														</label>
													</h3>
												</div>
												<!-- 체크박스 끝 -->
		                                        <div class="gen-movie-meta-holder">
		                                            <ul>
		                                                <li style="font-size:17px">${voteUpload.userName}</li>
		                                                <li><span>${voteUpload.categoryName}</span></li>
		                                            </ul>
		                                        </div>
		                                    </div>
		                                </div>
		                            </div>
		                        </div>
	                        </c:forEach>
                        </c:if>
                        <!-- 작품1개 끝 -->
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- 투표 리스트 끝 -->
    
<!-- 투표하기 버튼 시작 -->
    <div class="col-lg-12 col-md-12" style="margin: 0 auto; margin-top:-70px !important; ">
        <div class="gen-pagination" style="text-align: center; cursor:pointer;">
            <a id="btnVote" class="gen-button">
               <span class="text">투표하기</span>
         	</a>
        </div>
    </div>
    <br>
    <!-- 투표하기 버튼 끝 -->
    
    <!-- 페이징 처리 시작 -->
	<div class="col-lg-12 col-md-12" style="margin: 0 auto;">
 		<div class="gen-pagination" style="text-align: center;">
			<nav aria-label="Page navigation" style="display :inline-block;">
				<ul class="page-numbers">
					<c:if test="${!empty paging}">
						<c:if test="${paging.prevBlockPage gt 0}">		
         					<li><<a class="next page-numbers" href="javascript:void(0)" onclick="fn_list(${paging.prevBlockPage})">이전블럭</a></li>
						</c:if>
	
						<c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}" >
							<c:choose>
								<c:when test="${i ne curPage}" >		
									<li><a class="page-numbers" href="javascript:void(0)" onclick="fn_list(${i})">${i}</a></li>
								</c:when>
								<c:otherwise>         
									<li><a class="page-numbers" href="javascript:void(0)" style="cursor:default;">${i}</a></li>
								</c:otherwise>   		
							</c:choose>
   						</c:forEach>
    					<c:if test="${paging.nextBlockPage gt 0}">
         					<li><a class="next page-numbers" href="javascript:void(0)" onclick="fn_list(${paging.nextBlockPage})">다음블럭</a></li>
						</c:if>
					</c:if>
                </ul>
            </nav>
        </div>
    </div>
    <br><br><br>
    <!-- 페이징 처리 끝 -->
    
    <form name="voteUploadListForm" id="voteUploadListForm" method="post">
		<input type="hidden" name="vrSeq" value="" /> 
		<input type="hidden" name="gubun" id="gubun" value="${gubun }" />
		<input type="hidden" name="searchType" id="searchType" value="${searchType}" />	
		<input type="hidden" name="curPage" value="${curPage}" />		
		<input type="hidden" name="string" id="string" value=" "/>
		<!-- 여기서 현재 페이지 번호를 입력받음, 기본값은 1임 -->
	</form>

	<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>