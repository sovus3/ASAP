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

table {
	border: none !important;
}

.total {
	font-size: 60%; /* 작게 표시하기 위해 폰트 크기를 조절합니다. */
	text-decoration: underline; /* 밑줄을 추가합니다. */
	float: right; /* 맨 오른쪽에 위치하도록 설정합니다. */
	margin-left: 10px; /* "투표 신청 내역" 텍스트와의 간격을 조절합니다. */
	color: skyblue;
	cursor: pointer;
}
</style>

<script>
function fn_detail(vrSeq) {
   document.voteDetailForm.vrSeq.value = vrSeq;
   document.voteDetailForm.gubun.value = "myPageVoteUpload"
   document.voteDetailForm.action = "/vote/voteListDetail";
   document.voteDetailForm.submit();
}
function fn_list(curPage){
	   document.voteDetailForm.vrSeq.value="";   
	   document.voteDetailForm.curPage.value = curPage;
	   document.voteDetailForm.action="/myPage/myPageVoteUpload";
	   document.voteDetailForm.submit();
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
							<h1>투표작품신청내역</h1>
						</div>
						<div class="gen-breadcrumb-container">
							<ol class="breadcrumb">
								<li class="breadcrumb-item"><a href="index.html"> <i
										class="fas fa-home mr-2"></i>홈
								</a></li>
								<li class="breadcrumb-item active">투표작품신청내역</li>
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
								<c:if test="${user.userCode eq 'A'}">
									<hr>
									<div class="container bootstrap snippets bootdey">
										<div class="row">
											<div class="col-lg-12 mb-3 mt-3">
												<h4>투표작품 신청내역</h4>
											</div>
										</div>
										<div class="row">
											<!--/col-3-->
											<div class="col-lg-12">
												<!-- 결제내역 1개 시작 -->
												<table>
													<c:if test="${not empty list}">
														<c:forEach var="voteUpload" items="${list}"
															varStatus="status" step="2">
															<tbody class="gen-movie-contain">
																<tr>
																	<td width="850">
																		<!-- 사진 1개 시작  -->
																		<div
																			class="gen-carousel-movies-style-3 movie-grid style-3">
																			<div class="gen-movie-contain">
																				<div class="gen-movie-img">
																					<img
																						src="/resources/upload/vote/${voteUpload.vrSeq}.png">
																					<!-- 이미지 경로 끝 -->
																					<div class="gen-movie-action">
																						<!-- '+'아이콘 클릭시 팝업 화면 띄움 -->
																						<a onclick="fn_detail(${voteUpload.vrSeq})"
																							class="gen-button" name="voteDetail"> <i
																							class="fa fa-plus" style="width: 20px; cursor:pointer;"></i>
																						</a>
																					</div>
																				</div>
																			</div>
																		</div> <!-- 사진 1개 끝  -->
																	</td>
																	<td width="850" style="text-align: left; margin: auto;">
																		<p>
																			${voteUpload.vrTitle}<br>
																			<c:choose>
																				<c:when test="${voteUpload.categoryNo == 01}">
																					<span>미술</span>
																				</c:when>
																				<c:when test="${voteUpload.categoryNo == 02}">
																					<span>사진</span>
																				</c:when>
																				<c:when test="${voteUpload.categoryNo == 03}">
																					<span>도예</span>
																				</c:when>
																			</c:choose>
																			<br>
																			<fmt:formatNumber type="number" maxFractionDigits="3"
																				value="${voteUpload.vrTotalCnt}" />
																			표 <br>
																			<c:set var="originalDate"
																				value="${voteUpload.regDate}" />
																			<c:set var="dateParts"
																				value="${fn:split(originalDate, ' ')}" />
																			<c:set var="dateOnly" value="${dateParts[0]}" />
																			<span>${dateOnly}</span>
																		</p>
																	</td>
																	<c:if test="${status.index + 1 >= fn:length(list)}">
																		<td width="850"></td>
																	</c:if>
																	<!-- 다음 데이터가 존재하는지 확인하고 홀수 번째일 때만 표시 -->
																	<c:if test="${status.index + 1 < fn:length(list)}">
																		<td width="850">
																			<!-- 사진 1개 시작  -->
																			<div
																				class="gen-carousel-movies-style-3 movie-grid style-3">
																				<div class="gen-movie-contain">
																					<div class="gen-movie-img">
																						<!-- 이미지 경로 시작 -->
																						<img
																							src="/resources/upload/vote/${list[status.index + 1].vrSeq}.png"
																							alt="single-video-image">
																						<!-- 이미지 경로 끝 -->
																						<div class="gen-movie-action">
																							<!-- '+'아이콘 클릭시 팝업 화면 띄움 -->
																							<a
																								onclick="fn_detail(${list[status.index + 1].vrSeq})"
																								class="gen-button" name="voteDetail"> <i
																								class="fa fa-plus" style="width: 20px; cursor:pointer;"></i>
																							</a>
																						</div>
																					</div>
																				</div>
																			</div> <!-- 사진 1개 끝  -->
																		</td>
																		<td width="850"
																			style="text-align: left; margin: auto;">
																			<p>
																				${list[status.index + 1].vrTitle}<br>
																				<c:choose>
																					<c:when
																						test="${list[status.index + 1].categoryNo == 01}">
																						<span>미술</span>
																					</c:when>
																					<c:when
																						test="${list[status.index + 1].categoryNo == 02}">
																						<span>사진</span>
																					</c:when>
																					<c:when
																						test="${list[status.index + 1].categoryNo == 03}">
																						<span>도예</span>
																					</c:when>
																				</c:choose>
																				<br>
																				<fmt:formatNumber type="number"
																					maxFractionDigits="3"
																					value="${list[status.index + 1].vrTotalCnt}"/>
																				표 <br>
																				<c:set var="originalDate1"
																					value="${list[status.index + 1].regDate}" />
																				<c:set var="dateParts1"
																					value="${fn:split(originalDate1, ' ')}" />
																				<c:set var="dateOnly1" value="${dateParts1[0]}" />
																				<span>${dateOnly1}</span>
																			</p>
																		</td>
																	</c:if>
																	<!-- 홀수번째 끝  -->
																</tr>
															</tbody>
														</c:forEach>
													</c:if>
												</table>
												
													<!-- 리스트가 비어있으면 시작 -->
													<div style="margin-left:45% !important; margin-top:50px !important;">
														<c:if test="${empty list}">
															<i class="fa fa-exclamation-circle fa-4x" aria-hidden="true" style="left:-100px !important;"></i>
															<h6 class="mt-3" style="margin-left:-10% !important;">조회된 내역이 없습니다.</h6>
														</c:if>
													</div>
													<!-- 리스트가 비어있으면 끝 -->
									
												<!-- 결제내역 1개 끝 -->
												<div class="col-lg-12 col-md-12" style="margin: 0 auto;">
															<div class="gen-pagination" style="text-align: center;">
																<nav aria-label="Page navigation"
																	style="display: inline-block;">
																	<ul class="page-numbers">
																		<c:if test="${!empty paging}">
																			<c:if test="${paging.prevBlockPage gt 0}">
																				<!-- greater than, less than -->
																				<li><<a class="next page-numbers"
																					href="javascript:void(0)"
																					onclick="fn_list(${paging.prevBlockPage})">이전블럭</a></li>
																			</c:if>

																			<c:forEach var="i" begin="${paging.startPage}"
																				end="${paging.endPage}">
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
																			<c:if test="${paging.nextBlockPage gt 0}">
																				<li><a class="next page-numbers"
																					href="javascript:void(0)"
																					onclick="fn_list(${paging.nextBlockPage})">다음블럭</a></li>
																			</c:if>
																		</c:if>
																	</ul>
																</nav>
															</div>
														</div>
											</div>
										</div>
										<!--/col-9-->
									</div>
								</c:if>
								<!--/row-->
							</div>
						</div>
					</div>
				</div>
				<!-- 문의내역 끝 -->
			</div>
		</div>
	</section>
	<!-- Blog-left-Sidebar -->

	<form name="voteDetailForm" id="voteDetailForm" method="post">
		<input type="hidden" name="vrSeq" value="" /> <input type="hidden"
			name="gubun" value="" /> <input type="hidden" name="curPage"
			value="${curPage}" />
		<!-- 여기서 현재 페이지 번호를 입력받음, 기본값은 1임 -->
	</form>

	<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>