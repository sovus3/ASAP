<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
	<%@ include file="/WEB-INF/views/include/head.jsp"%>
</head>

<script>
	//닫기 버튼 클릭시 리스트페이지로 이동
	function fn_list()
	{
		document.voteForm.action = "/vote/voteList";
		document.voteForm.submit();
	}
</script>

<body>
<%@ include file="/WEB-INF/views/include/navigation.jsp"%>
	<!-- Single-tv-Shows -->
    <section>
        <div class="tv-single-background">
            <img src="/resources/upload/vote/${voteUpload.vrSeq}.png" alt="stream-lab-image">
        </div>
        <div class="container">
            <div class="row">
                <div class="col-lg-12">
                
                <i class="fa fa-plus" id="btnList" onclick="fn_list()" style="color: #ffffff; float:right; margin-right:20px; transform: rotate(45deg); cursor:pointer;"></i>
                
                    <div class="gen-tv-show-wrapper style-1">
                    	<!-- 작품 상세페이지 1개 시작 -->
                    	<div class="gen-tv-show-top">
                            <div class="row">
                                <div class="col-lg-6">
                                    <div class="gentech-tv-show-img-holder">
                                        <img src="/resources/upload/vote/${voteUpload.vrSeq}.png" alt="stream-lab-image">
                                    </div>
                                </div>
                                <div class="col-lg-6 align-self-center">
                                    <div class="gen-single-tv-show-info">
                                        <h2 class="gen-title">${voteUpload.vrTitle}</h2>
                                        <div class="gen-single-meta-holder">
                                            <ul>
                                                <li>${voteUpload.userName}</li>
                                                <li>${voteUpload.categoryName}</li>
                                                <li>${voteUpload.vrTotalCnt}표</li>
                                            </ul>
                                        </div>
                                        <p>${voteUpload.vrContent}</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- 작품 상세페이지 1개 끝 -->
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <form name="voteForm" id="voteForm" method="post">
		<input type="hidden" name="vrSeq" value="${vrSeq}" /> 
		<input type="hidden" name="curPage" value="${curPage}" />
	</form>
		<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>