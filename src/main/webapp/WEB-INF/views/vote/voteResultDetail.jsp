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
	if($.trim($("#gubun").val()) == "1")
	{
		document.voteResultForm.searchType.value=1
		document.voteResultForm.action = "/vote/voteResult";
	    document.voteResultForm.submit();
	}
	else if($.trim($("#gubun").val()) == "2")
	{
		document.voteResultForm.searchType.value=2
		document.voteResultForm.action = "/vote/voteResult";
	    document.voteResultForm.submit();
	}
	else if($.trim($("#gubun").val()) == "3")
	{
		document.voteResultForm.searchType.value=3
		document.voteResultForm.action = "/vote/voteResult";
	    document.voteResultForm.submit();
	}
	else if($.trim($("#gubun").val()) == "11")
	{
		document.voteResultForm.searchType.value=1
		document.voteResultForm.action = "/myPage/myPageVoteList";
	    document.voteResultForm.submit();
	}
	else if($.trim($("#gubun").val()) == "12")
	{
		document.voteResultForm.searchType.value=2
		document.voteResultForm.action = "/myPage/myPageVoteList";
	    document.voteResultForm.submit();
	}
	else if($.trim($("#gubun").val()) == "13")
	{
		document.voteResultForm.searchType.value=3
		document.voteResultForm.action = "/myPage/myPageVoteList";
	    document.voteResultForm.submit();
	}
	else
	{
	    document.voteResultForm.searchType.value = "";
	    document.voteResultForm.action = "/vote/voteResult";
	    document.voteResultForm.submit();
	}
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
    
    <input type="hidden" name="gubun" id="gubun" value="${gubun }" />
    <form name="voteResultForm" id="voteResultForm" method="post">
		<input type="hidden" name="vrSeq" value="${vrSeq}" /> 
        <input type="hidden" name="searchType" value="" />
		<input type="hidden" name="curPage" value="${curPage}" />		
		<input type="hidden" name="searchDate" value="${searchDate}" />
	</form>
		<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>