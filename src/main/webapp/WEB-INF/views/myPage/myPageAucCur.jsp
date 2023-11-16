<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<style>
th, td {
	border-color: transparent !important;
}

/* 버튼 스타일 */
.custom-button {
	display: inline-block;
	padding: 8px 16px;
	font-size: 16px;
	cursor: pointer;
	border: none;
	border-radius: 5px;
	text-align: center;
	text-decoration: none;
	margin: 5px;
	color: #fff; /* 흰색 텍스트 */
	background-color: #606060; /* 검은 배경 */
	transition: background-color 0.3s, color 0.3s;
}

/* 버튼 클릭 시 스타일 */
.custom-button:active {
	background-color: #606060;
}

.table {
	border-top:transparent !important;
}
</style>

<script>
function showResult(resultNumber) {
	// 모든 결과를 숨깁니다.
	document.getElementById('result1').style.display = 'none';
	document.getElementById('result2').style.display = 'none';
	
	// 선택한 결과를 표시합니다.
	if (resultNumber === 1) {
		document.getElementById('result1').style.display = 'block';  
		// 버튼 스타일 변경
	    document.getElementById('button1').style.backgroundColor = '#294273';  // 선택했을때 진해지는 배경
	    document.getElementById('button2').style.backgroundColor = 'rgba(61, 82, 115, 0.3)';  // 기본 배경색
	} 
	else if (resultNumber === 2) {
		document.getElementById('result2').style.display = 'block';
		// 버튼 스타일 변경
	    document.getElementById('button1').style.backgroundColor = 'rgba(61, 82, 115, 0.3)';  // 기본 배경
	    document.getElementById('button2').style.backgroundColor = '#294273';  // 선택했을 때 진해지는 배경색
	}
}

// 일반 , 이벤트

function fn_list(aucCurPage){
	document.myPageForm.aucCurPage.value = aucCurPage;

	$.ajax({
		type : "POST",
		url : "/myPage/aucCur",
		data : {
			aucCurPage:$("#aucCurPage").val()
		},
		datatype : "html",
		beforeSend : function(xhr) {
			xhr.setRequestHeader("AJAX", "true");
		},
		success: function(response) {
			var updatedContent = $(response).find('#result1'); 
			// 추출한 내용을 페이지에 반영
			$('#result1').html(updatedContent.html());
		},
		error: function(error){
			icia.com.error(error);		
		}
	});
	
}

function fn_list2(eventCurPage){
	document.myPageForm.eventCurPage.value = eventCurPage;
	
	$.ajax({
		type : "POST",
		url : "/myPage/aucCur",
		data : {
			eventCurPage:$("#eventCurPage").val()
		},
		datatype : "html",
		beforeSend : function(xhr) {
			xhr.setRequestHeader("AJAX", "true");
		},
		success: function(response) {
			var updatedContent = $(response).find('#result2'); 
			
			// 추출한 내용을 페이지에 반영
			$('#result2').html(updatedContent.html());
		},
		error: function(error){
			icia.com.error(error);		
		}
	});
}

/*
function fn_list2(eventCurPage){
	document.myPageForm.eventCurPage.value = eventCurPage;
	document.myPageForm.action = "/myPage/aucCur";
	document.myPageForm.submit();
}
*/
//구분값

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
							<h1>입찰내역</h1>
						</div>
						<div class="gen-breadcrumb-container">
							<ol class="breadcrumb">
								<li class="breadcrumb-item">
									<a href="index.html"> 
										<i class="fas fa-home mr-2"></i>홈
									</a>
								</li>
								<li class="breadcrumb-item active">입찰내역</li>
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

				<!-- 문의내역 시작 -->
				<div class="col-xl-9 col-md-12 order-1 order-xl-2">
					<div class="gen-blog gen-blog-col-1">
						<div class="row">
							<div class="col-lg-12">
								<div class="container bootstrap snippets bootdey" style="margin-left:0% !important;">
									<div class="row">
										<!-- 
										<button id="button1" class="custom-button" onclick="showResult(1)">일반경매</button>
										<button id="button2" class="custom-button" onclick="showResult(2)">이벤트경매</button>
										 -->									
										<div class="btn-group mb-3" role="group">
											<input type="button" id="button1" onclick="showResult(1)" value="일반경매 입찰내역" style="background-color:#3D4F73;">
											<input type="button" id="button2" onclick="showResult(2)" value="이벤트경매 입찰내역" style="background-color: rgba(61, 82, 115, 0.3);">
										</div>
									</div>
								</div>
								<!--/row-->
								
								<!-- 일반경매 입찰 시작 -->
								<div id="result1">
									<div class="row">
										<!--/col-3-->
										<div class="col-lg-12">
											<div class="table-responsive" style="color: #ffffff;">
												<table class="table" style="color: #ffffff;">
													<thead style="background-color: rgba(61, 82, 115, 0.3); color: #ffffff;">
														<tr>
															<th></th>
															<th>작품 제목</th>
															<th>카테고리</th>
															<th>입찰액</th>
															<th>입찰 시간</th>
															<th>상태</th>
														</tr>
													</thead>
													<tbody id="items">
														<c:forEach var="listAuc" items="${listAuc}" varStatus="status">
															<tr>
																<td width="100">
																	<img src="/resources/upload/vote/${listAuc.vrSeq}.png">
																</td>
																<td>
																	<div class=“cell-inner”>
																		<span>${listAuc.vrTitle}</span>
																	</div>
																</td>
																<td>
																	<c:choose>
																		<c:when test="${listAuc.categoryNo == 01}">
																			<div>
																				<a><span>미술</span></a>
																			</div>
																		</c:when>
																		<c:when test="${listAuc.categoryNo == 02}">
																			<div>
																				<a><span>사진</span></a>
																			</div>
																		</c:when>
																		<c:when test="${listAuc.categoryNo == 03}">
																			<div>
																				<a><span>도예</span></a>
																			</div>
																		</c:when>
																	</c:choose>
																</td>
																<td>
																	<div class="cell-inner">
																		<span>${listAuc.aucCurPrice}</span>
																	</div>
																</td>
																<td>
																	<div class="cell-inner">
																		<span>${listAuc.aucCurBuyTime}</span>
																	</div>
																</td>
																<td>
																	<c:choose>
																		<c:when test="${listAuc.aucCurStatus == 'Y'}">
																			<div>
																				<a><span>낙찰</span></a>
																			</div>
																		</c:when>
																		<c:when test="${listAuc.aucCurStatus == 'N'}">
																			<div>
																				<a><span>입찰진행</span></a>
																			</div>
																		</c:when>
																		<c:when test="${listAuc.aucCurStatus == 'C'}">
																			<div>
																				<a><span>환불완료</span></a>
																			</div>
																		</c:when>
																	</c:choose>
																</td>
															</tr>
														</c:forEach>
													</tbody>
												</table>
												
												<!-- 리스트가 비어있으면 시작 -->
												<div style="margin-left:45% !important; margin-top:65px !important;">
													<c:if test="${empty listAuc}">
														<i class="fa fa-exclamation-circle fa-4x" aria-hidden="true" style="left:-100px !important;"></i>
														<h6 class="mt-3" style="margin-left:-10% !important;">조회된 내역이 없습니다.</h6>
													</c:if>
												</div>
												<!-- 리스트가 비어있으면 끝 -->
												
												<!-- 페이징처리 시작 -->
												<div class="col-lg-12 col-md-12" style="margin: 0 auto;">
													<div class="gen-pagination" style="text-align: center;">
														<nav aria-label="Page navigation" style="display: inline-block;">
															<ul class="page-numbers">
																<c:if test="${!empty aucPage}">
																	<c:if test="${aucPage.prevBlockPage gt 0}">
																		<li>
																			<a class="next page-numbers" href="javascript:void(0)" onclick="fn_list(${aucPage.prevBlockPage})">이전블럭</a>
																		</li>
																	</c:if>

																	<c:forEach var="i" begin="${aucPage.startPage}"
																		end="${aucPage.endPage}">
																		<c:choose>
																			<c:when test="${i ne curPage}">
																				<li>
																					<a class="page-numbers" href="javascript:void(0)" onclick="fn_list(${i})">${i}</a>
																				</li>
																			</c:when>
																			<c:otherwise>
																				<li>
																					<a class="page-numbers" href="javascript:void(0)" style="cursor: default;">${i}</a>
																				</li>
																			</c:otherwise>
																		</c:choose>
																	</c:forEach>
																	<c:if test="${aucPage.nextBlockPage gt 0}">
																		<li>
																			<a class="next page-numbers" href="javascript:void(0)" onclick="fn_list(${aucPage.nextBlockPage})">다음블럭</a>
																		</li>
																	</c:if>
																</c:if>
															</ul>
														</nav>
													</div>
												</div>
												<!-- 페이징 처리 끝 -->
												
											</div>
										</div>
										<!--/col-9-->
									</div>
								</div>
								<!-- 일반경매 입찰내역 끝 -->
								
								<!-- 이벤트경매 입찰 내역 시작 -->
								<div id="result2" style="display: none;">
									<div class="row">
										<!--/col-3-->
										<div class="col-lg-12">
											<div class="table-responsive" style="color: #ffffff;">
												<table class="table" style="color: #ffffff;">
													<thead style="background-color: rgba(61, 82, 115, 0.3); color: #ffffff;">
														<tr>
															<th></th>
															<th>작품 제목</th>
															<th>입찰액</th>
															<th>입찰 시간</th>
															<th>상태</th>
														</tr>
													</thead>
													<tbody id="items">
														<c:forEach var="listEvent" items="${listEvent}" varStatus="status">
															<tr>
																<td width="100">
																	<img src="/resources/upload/eventmain/${listEvent.aeSeq}.png">
																</td>																
																<td>
																	<div class=“cell-inner”>
																		<span>${listEvent.aeTitle}</span>
																	</div>
																</td>
																<td>
																	<div class="cell-inner">
																		<span>${listEvent.aeCurPrice}</span>
																	</div>
																</td>
																<td>
																	<div class="cell-inner">
																		<span>${listEvent.aeCurBuyTime}</span>
																	</div>
																</td>
																<td>
																	<c:choose>
																		<c:when test="${listEvent.aeStatus == 'Y'}">
																			<div>
																				<a><span>낙찰</span></a>
																			</div>
																		</c:when>
																		<c:when test="${listEvent.aeStatus == 'N'}">
																			<div>
																				<a><span>입찰진행</span></a>
																			</div>
																		</c:when>
																		<c:when test="${listEvent.aeStatus == 'C'}">
																			<div>
																				<a><span>환불완료</span></a>
																			</div>
																		</c:when>
																	</c:choose>
																</td>
															</tr>
														</c:forEach>
													</tbody>
												</table>
												
												<!-- 리스트가 비어있으면 시작 -->
												<div style="margin-left:45% !important; margin-top:65px !important;">
													<c:if test="${empty listEvent}">
														<i class="fa fa-exclamation-circle fa-4x" aria-hidden="true" style="left:-100px !important;"></i>
														<h6 class="mt-3" style="margin-left:-10% !important;">조회된 내역이 없습니다.</h6>
													</c:if>
												</div>
												<!-- 리스트가 비어있으면 끝 -->
												
												<!-- 페이징 처리 시작 -->
												<div class="col-lg-12 col-md-12" style="margin: 0 auto;">
													<div class="gen-pagination" style="text-align: center;">
														<nav aria-label="Page navigation" style="display: inline-block;">
															<ul class="page-numbers">
																<c:if test="${!empty eventPage}">
																	<c:if test="${eventPage.prevBlockPage gt 0}">
																		<li>
																			<a class="next page-numbers" href="javascript:void(0)" onclick="fn_list2(${eventPage.prevBlockPage})">이전블럭</a>
																		</li>
																	</c:if>

																	<c:forEach var="i" begin="${eventPage.startPage}" end="${eventPage.endPage}">
																		<c:choose>
																			<c:when test="${i ne curPage}">
																				<li>
																					<a class="page-numbers" href="javascript:void(0)" onclick="fn_list2(${i})">${i}</a>
																				</li>
																			</c:when>
																			<c:otherwise>
																				<li>
																					<a class="page-numbers" href="javascript:void(0)" style="cursor: default;">${i}</a>
																				</li>
																			</c:otherwise>
																		</c:choose>
																	</c:forEach>
																	<c:if test="${eventPage.nextBlockPage gt 0}">
																		<li>
																			<a class="next page-numbers" href="javascript:void(0)" onclick="fn_list2(${eventPage.nextBlockPage})">다음블럭</a>
																		</li>
																	</c:if>
																</c:if>
															</ul>
														</nav>
													</div>
												</div>
												<!-- 페이징 처리 끝 -->
											</div>
										</div>
									</div>
								</div>
								<!-- 이벤트경매 입찰 내역 끝 -->
								
							</div>
							<!-- 문의내역 끝 -->
						</div>
					</div>
				</div>
			</div>
		</div>
	</section>
	<!-- Blog-left-Sidebar -->

	<form name="myPageForm" id="myPageForm" method="post" onsubmit="return false;">
		<input type="hidden" id="aucCurPage" name="aucCurPage" value="${aucCurPage}" /> 
		<input type="hidden" id="eventCurPage" name="eventCurPage" value="${eventCurPage}" />
	</form>
	<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>