<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<style>
th, td {
	border-color: transparent !important;
}
</style>

<script>

function fn_list(curPage){	
	document.myPageForm.curPage.value = curPage;
	document.myPageForm.action = "/myPage/aucResult";
	document.myPageForm.submit();
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
							<h1>경매결과내역</h1>
						</div>
						<div class="gen-breadcrumb-container">
							<ol class="breadcrumb">
								<li class="breadcrumb-item"><a href="index.html"> <i
										class="fas fa-home mr-2"></i>홈
								</a></li>
								<li class="breadcrumb-item active">경매결과내역</li>
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

				<div class="col-xl-9 col-md-12 order-1 order-xl-2">
					<div class="gen-blog gen-blog-col-1">
						<div class="row">
							<div class="col-lg-12">
								<hr>
								<div class="container bootstrap snippets bootdey">
									<div class="row">
										<div class="col-lg-12 mt-3 mb-3">
											<h3>경매결과내역</h3>
										</div>
									</div>
									<div class="row">
										<!--/col-3-->
										<div class="col-lg-12">
											<div class="table-responsive" style="color: #ffffff;">
												<table class="table" style="color: #ffffff;">
													<thead style="background-color: rgba(61, 79, 115, 0.3); color: #ffffff;">
														<tr>
															<th>작품사진</th>
															<th>작품 제목</th>
															<th>카테고리</th>
															<th>낙찰액</th>
															<th>날짜</th>
														</tr>
													</thead>
													<tbody id="items">
														<c:forEach var="list" items="${list}" varStatus="status">
															<tr>
																<td width="100">
																	<img src="/resources/upload/vote/${list.vrSeq}.png">
																</td>
																<td>
																	<div class=“cell-inner”>
																		<span>${list.vrTitle}</span>
																	</div>
																</td>
																<td>
																	<c:choose>
																		<c:when test="${list.categoryNo == 01}">
																			<div>
																				<a><span>미술</span></a>
																			</div>
																		</c:when>
																		<c:when test="${list.categoryNo == 02}">
																			<div>
																				<a><span>사진</span></a>
																			</div>
																		</c:when>
																		<c:when test="${list.categoryNo == 03}">
																			<div>
																				<a><span>도예</span></a>
																			</div>
																		</c:when>
																	</c:choose>
																</td>
																<td>
																	<div class="cell-inner">
																		<span><fmt:formatNumber type="number" maxFractionDigits="3" value="${list.aucBuyPrice}" /></span>
																	</div>
																</td>
																<td>
																	<div class="cell-inner">
																		<span>${list.aucStartTime}</span>
																	</div>
																</td>
															</tr>
														</c:forEach>
													</tbody>

												</table>
												<div class="col-lg-12 col-md-12" style="margin: 0 auto;">
													<div class="gen-pagination" style="text-align: center;">
														<nav aria-label="Page navigation"
															style="display: inline-block;">
															<ul class="page-numbers">
																<c:if test="${!empty paging}">
																	<c:if test="${paging.prevBlockPage gt 0}">
																		<!— greater than, less than —>
																		<li><<a class="next page-numbers"
																			href="javascript:void(0)"
																			onclick="fn_list(${paging.prevBlockPage})">이전블럭</a></li>
																	</c:if>
																	<c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
																		<c:choose>
																			<c:when test="${i ne curPage}">
																				<!— not equal —>
																				<li><a class="page-numbers"
																					href="javascript:void(0)" onclick="fn_list(${i})">${i}</a></li>
																			</c:when>
																			<c:otherwise>
																				<li><a class="page-numbers"
																					href="javascript:void(0)" style="cursor: default;">${i}</a></li>
																			</c:otherwise>
																		</c:choose>
																	</c:forEach>
																	<c:if test="${paging.nextBlockPage gt 0}">
																		<li><a class="next page-numbers" href="javascript:void(0)"
																			onclick="fn_list(${paging.nextBlockPage})">다음블럭</a></li>
																	</c:if>
																</c:if>
															</ul>
														</nav>
													</div>
												</div>
											</div>
											
										  <!-- 리스트가 비어있으면 시작 -->
                                          <div style="margin-left:45% !important; margin-top:50px !important;">
                                             <c:if test="${empty list}">
                                                <i class="fa fa-exclamation-circle fa-4x" aria-hidden="true" style="left:-100px !important;"></i>
                                                <h6 class="mt-3" style="margin-left:-10% !important;">조회된 내역이 없습니다.</h6>
                                             </c:if>
                                          </div>
                                          <!-- 리스트가 비어있으면 끝 -->
                                          
										</div>
									</div>
									<!--/col-9-->
								</div>
								<!--/row-->
							</div>
						</div>
					</div>
				</div>
				<!-- 문의내역 끝 -->

			</div>
		</div>
	</section>

	<form name="myPageForm" id="myPageForm" method="post">
		<input type="hidden" id="curPage" name="curPage" value="${curPage}" />
	</form>
	<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>