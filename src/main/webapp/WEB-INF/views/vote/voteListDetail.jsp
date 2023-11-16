<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
	<%@ include file="/WEB-INF/views/include/head.jsp"%>
<style>
	.fontSize{
		font-size: 20px !important;
	}
</style>
</head>

<script>
$(document).ready(function() {
	console.log($.trim($("#gubun").val()));
	
});

function fn_list()
{
	if($.trim($("#gubun").val()) == "myPageVote")
	{
		document.voteListForm.action = "/myPage/myPageVote";
	    document.voteListForm.submit();
	}
	else if($.trim($("#gubun").val()) == "myPageVoteList")
	{
		document.voteListForm.curPage.value = $("#curPage").val();
		document.voteListForm.action = "/myPage/myPageVoteList";
	    document.voteListForm.submit();
	}
	else if($.trim($("#gubun").val()) == "myPageVoteUpload")
	{
		document.voteListForm.action = "/myPage/myPageVoteUpload";
	    document.voteListForm.submit();
	}
	else if($.trim($("#gubun").val()) == "1")
	{
		document.voteListForm.searchType.value=1
		document.voteListForm.action = "/vote/voteList";
	    document.voteListForm.submit();
	}
	else if($.trim($("#gubun").val()) == "2")
	{
		document.voteListForm.searchType.value=2
		document.voteListForm.action = "/vote/voteList";
	    document.voteListForm.submit();
	}
	else if($.trim($("#gubun").val()) == "3")
	{
		document.voteListForm.searchType.value=3
		document.voteListForm.action = "/vote/voteList";
	    document.voteListForm.submit();
	}
	else if($.trim($("#gubun").val()) == "11")
	{
		document.voteListForm.searchType.value=1
		document.voteListForm.action = "/vote/voteResult";
	    document.voteListForm.submit();
	}
	else if($.trim($("#gubun").val()) == "12")
	{
		document.voteListForm.searchType.value=2
		document.voteListForm.action = "/vote/voteResult";
	    document.voteListForm.submit();
	}
	else if($.trim($("#gubun").val()) == "13")
	{
		document.voteListForm.searchType.value=3
		document.voteListForm.action = "/vote/voteResult";
	    document.voteListForm.submit();
	}
	else
	{
		document.voteListForm.action = "/vote/voteList";
	    document.voteListForm.submit();
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
                                                <li class="fontSize">${voteUpload.userName}</li>
                                                <li class="fontSize">${voteUpload.categoryName}</li>
                                                <li class="fontSize">${voteUpload.vrTotalCnt}표</li>
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
    <form name="voteListForm" id="voteListForm" method="post">
		<input type="hidden" name="vrSeq" value="${vrSeq}" />
		<input type="hidden" name="searchType" value="" />
		<input type="hidden" name="curPage" id="curPage" value="${curPage}" />
	</form>
		<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>