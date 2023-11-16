<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ page import="java.text.SimpleDateFormat"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<style>
th, td {
	border-color: transparent !important;
}

table {
	border: none !important;
}

.total {
	font-size: 60%; /* 작게 표시하기 위해 폰트 크기를 조절합니다. */
	text-decoration: underline; /* 밑줄을 추가합니다. */
	float: right; /* 맨 오른쪽에 위치하도록 설정합니다. */
	margin-left: 10px; /* "투표 신청 내역" 텍스트와의 간격을 조절합니다. */
	cursor: pointer;
}
</style>
<script>
//카테고리 이동 
function searchByCategory(value) {
    document.voteDetailForm.searchType.value = value;
    document.voteDetailForm.curPage.value = "1";
    document.voteDetailForm.action = "/myPage/myPageVoteList";
    document.voteDetailForm.submit();	    
}
function fn_list(curPage){
	document.voteDetailForm.vrSeq.value="";   
	document.voteDetailForm.curPage.value = curPage;
	document.voteDetailForm.action="/myPage/myPageVoteList";
	document.voteDetailForm.submit();
}
function fn_detail(vrSeq) 
{
	if($("#gubun").val() == 1)
	{
		document.voteDetailForm.vrSeq.value = vrSeq;
		document.voteDetailForm.gubun.value = 11;
		document.voteDetailForm.action = "/vote/voteResultDetail";
		document.voteDetailForm.submit();
	}
	else if($("#gubun").val() == 2)
	{
		document.voteDetailForm.vrSeq.value = vrSeq;
		document.voteDetailForm.gubun.value = 12;
		document.voteDetailForm.action = "/vote/voteResultDetail";
		document.voteDetailForm.submit();
	}
	else if($("#gubun").val() == 3)
	{
		document.voteDetailForm.vrSeq.value = vrSeq;
		document.voteDetailForm.gubun.value = 13;
		document.voteDetailForm.action = "/vote/voteResultDetail";
		document.voteDetailForm.submit();
	}
	else
	{
		document.voteDetailForm.vrSeq.value = vrSeq;
	    document.voteDetailForm.gubun.value = "myPageVoteList"
	    document.voteDetailForm.action = "/vote/voteListDetail";
	    document.voteDetailForm.submit();
	} 
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
							<h1>마이페이지</h1>
						</div>
						<div class="gen-breadcrumb-container">
							<ol class="breadcrumb">
								<li class="breadcrumb-item">
									<a href="index.html"> 
										<i class="fas fa-home mr-2"></i>홈
									</a>
								</li>
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

				<!-- 투표 내역 -->
				<div class="col-xl-9 col-md-12 order-1 order-xl-2">
					<div class="gen-blog gen-blog-col-1">
						<div class="row">
							<div class="col-lg-12">
								<hr>
								<div class="gen-blog gen-blog-col-1">
									<div class="row">
										<div class="col-lg-12">
											<hr>
											<div class="container bootstrap snippets bootdey">
												<div class="row">
													<div class="col-lg-12 mb-3 mt-3">
														<h4>
															투표 내역
														</h4>
													</div>
												</div>
												<div id="_searchType">
													<a style="background-color: rgba(61, 79, 115, 0.3); cursor: pointer;"
														class="gen-button gen-button-flat"> <span class="text"
														onclick="location.href='/myPage/myPageVoteList'">전체</span>
													</a> 
													<a style="background-color: rgba(61, 79, 115, 0.3); cursor: pointer;"
														class="gen-button gen-button-flat"> <span class="text"
														onclick="searchByCategory(1)">미술</span>
													</a> 
													<a style="background-color: rgba(61, 79, 115, 0.3); cursor: pointer;"
														class="gen-button gen-button-flat"> <span class="text"
														onclick="searchByCategory(2)">사진</span>
													</a> 
													<a style="background-color: rgba(61, 79, 115, 0.3); cursor: pointer;"
														class="gen-button gen-button-flat"> <span class="text"
														onclick="searchByCategory(3)">도예</span>
													</a>
												</div>
												<br>
												<div class="row">
													<!--/col-3-->
													<div class="col-lg-12">
														<!-- 결제내역 1개 시작 -->
														<table>
															<thead style="background-color: rgba(61, 79, 115, 0.3); color: #ffffff;">
																<tr>
																	<th>그림</th>
																	<th>카테고리</th>
																	<th>작가명</th>
																	<th>작품명</th>
																	<th>투표 시작일</th>
																	<th>투표 종료일</th>
																</tr>
															</thead>
															<tbody>
																<c:if test="${!empty list1}">
																	<c:forEach var="voteUpload1" items="${list1}"
																		varStatus="status">
																		<tr>
																			<td width="100"><img src="/resources/upload/vote/${voteUpload1.vrSeq}.png">
																			</td>																			
																			<td>
																				<div class="cell-inner">
																					<span>${voteUpload1.categoryName}</span>
																				</div>
																			</td>
																			<td>
																				<div class="cell-inner">
																					<span>${voteUpload1.userName}</span>
																				</div>
																			</td>
																			<td>
																				<div class="cell-inner">
																					<span onclick="fn_detail(${voteUpload1.vrSeq})" style="cursor:pointer">${voteUpload1.vrTitle}</span>
																				</div>
																			</td>
																			<td>
																				<div class="cell-inner">
																					<span>${voteUpload1.vrStartDate}</span>
																				</div>
																			</td>
																			<td>
																				<div class="cell-inner">
																					<span>${voteUpload1.vrEndDate}</span>
																				</div>
																			</td>
																		</tr>
																	</c:forEach>
																</c:if>
															</tbody>
														</table>
														
													<!-- 리스트가 비어있으면 시작 -->
													<div style="margin-left:45% !important; margin-top:65px !important;">
														<c:if test="${empty list1}">
															<i class="fa fa-exclamation-circle fa-4x" aria-hidden="true" style="left:-100px !important;"></i>
															<h6 class="mt-3" style="margin-left:-10% !important;">조회된 내역이 없습니다.</h6>
														</c:if>
													</div>
													<!-- 리스트가 비어있으면 끝 -->
														
														<div class="col-lg-12 col-md-12" style="margin: 0 auto;">
															<div class="gen-pagination" style="text-align: center;">
																<nav aria-label="Page navigation"
																	style="display: inline-block;">
																	<ul class="page-numbers">
																		<c:if test="${!empty paging1}">
																			<c:if test="${paging1.prevBlockPage gt 0}">
																				<!-- greater than, less than -->
																				<li><<a class="next page-numbers"
																					href="javascript:void(0)"
																					onclick="fn_list(${paging1.prevBlockPage})">이전블럭</a></li>
																			</c:if>

																			<c:forEach var="i" begin="${paging1.startPage}"
																				end="${paging1.endPage}">
																				<c:choose>
																					<c:when test="${i ne curPage}">
																						<!-- not equal -->
																						<li><a class="page-numbers"
																							href="javascript:void(0)" onclick="fn_list(${i})">${i}</a></li>
																					</c:when>
																					<c:otherwise>
																						<li><a class="page-numbers"
																							href="javascript:void(0)"
																							style="cursor: default;">${i}</a></li>
																					</c:otherwise>
																				</c:choose>
																			</c:forEach>
																			<c:if test="${paging1.nextBlockPage gt 0}">
																				<li><a class="next page-numbers"
																					href="javascript:void(0)"
																					onclick="fn_list(${paging1.nextBlockPage})">다음블럭</a></li>
																			</c:if>
																		</c:if>
																	</ul>
																</nav>
															</div>
														</div>
													</div>
												</div>
											</div>
										</div>
										<!-- 투표내역 -->
									</div>
								</div>
							</div>
						</div>
						<!-- 문의내역 끝 -->
					</div>
				</div>
			</div>
		</div>

	</section>
	<!-- Blog-left-Sidebar -->

	<form name="voteDetailForm" id="voteDetailForm" method="post">
		<input type="hidden" name="vrSeq" value="" />
		<input type="hidden" name="gubun" id="gubun" value="${gubun }" />
		<input type="hidden" name="curPage" id="curPage" value="${curPage}" />
		<input type="hidden" name="searchType" value="" />
		<!-- 여기서 현재 페이지 번호를 입력받음, 기본값은 1임 -->
	</form>
	<!-- 여기서 현재 페이지 번호를 입력받음, 기본값은 1임 -->


	<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>