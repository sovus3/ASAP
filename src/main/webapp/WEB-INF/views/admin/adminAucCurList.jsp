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
</style>
<script>
	
$(document).ready(function(){
	setDateBox();
	
   $("#btnSearch").on("click",function(){
		var searchDate = mk_date();
		
		document.bbsForm.vrSeq.value = "";	
		document.bbsForm.curPage.value = 1;
		document.bbsForm.yearValue.value = $("#year").val();
		document.bbsForm.monthValue.value = $("#month").val();
	    document.bbsForm.searchType.value = $("#searchType").val();
		document.bbsForm.searchValue.value = $("#searchValue").val();
		document.bbsForm.searchDate.value = searchDate;
		document.bbsForm.action="/admin/adminAucCurList";
		document.bbsForm.submit();
	});
});

function fn_list(curPage){
	var searchDate = mk_date();
	
	document.bbsForm.vrSeq.value="";	
	document.bbsForm.curPage.value = curPage;
	document.bbsForm.searchDate.value = searchDate;
	document.bbsForm.action="/admin/adminAucCurList";
	document.bbsForm.submit();
}

function mk_date(){
	var year = $("#year").val();
	var month = $("#month").val();
	var searchDate;	
	
	if(month.length > 0){
		searchDate = year + month;
	}
	else
	{
		year ="";
		searchDate = year + month;
	}
	
	return searchDate;
}

function setDateBox(){
	
	window.onkeydown = function() {
		var kcode = event.keyCode;
		if(kcode == 116) 
		{
			history.replaceState({}, null, location.pathname);
		}
	}
	
	var dt = new Date();
	var year = dt.getFullYear();
	var month = dt.getMonth()+1;
	var selectedValue;
	
	if(!icia.common.isEmpty($("#yearValue").val()) && $("#yearValue").val() != "")
	{	
		for(var y = (year); y >=(year-5); y--)
		{
			if(y == $("#yearValue").val())
			{
				$("#year").append("<option selected value='"+ $("#yearValue").val() +"'>"+ $("#yearValue").val() + "년" +"</option>");
				continue;
			}
			else
			{
				$("#year").append("<option value='"+ y +"'>"+ y + "년" +"</option>");
			}
		}
	}
	else
	{
		for(var y = (year); y >=(year-5); y--)
		{
			if(year == y) 
			{
				$("#year").append("<option selected value='"+ y +"'>"+ y + "년" +"</option>");
			}
			else
			{
				$("#year").append("<option value='"+ y +"'>"+ y + "년" +"</option>");
			}
		}	
	}
	
	if(!icia.common.isEmpty($("#monthValue").val()) && $("#monthValue").val() != "")
	{	
		$("#month").append("<option value>"+"전체" +"</option>");
		
		for(var i = 1; i <= 12; i++)
		{
			if(i.toString().length == 1)
			{
				i = "0" + i;
				
				if(i == $("#monthValue").val())
				{
					$("#month").append("<option selected value='"+ $("#monthValue").val() +"'>"+ $("#monthValue").val() + "월" +"</option>");
					continue;
				}
				
				$("#month").append("<option value='"+ i +"'>"+ i + "월" +"</option>");
			}
			else
			{
				$("#month").append("<option value='"+ i +"'>"+ i + "월" +"</option>");
			}		
		}
	}
	else
	{
		$("#month").append("<option selected value>"+"전체" +"</option>");
		for(var i = 1; i <= 12; i++)
		{
			if(i.toString().length == 1)
			{
				i = "0" + i;
				$("#month").append("<option value='"+ i +"'>"+ i + "월" +"</option>");
			}
			else
			{
				$("#month").append("<option value='"+ i +"'>"+ i + "월" +"</option>");
			}		
		}
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
							<h1>관리자</h1>
						</div>
						<div class="gen-breadcrumb-container">
							<ol class="breadcrumb">
								<li class="breadcrumb-item">
									<a href="index.html"> 
										<i class="fas fa-home mr-2"></i>홈
									</a>
								</li>
								<li class="breadcrumb-item active">관리자</li>
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
				<div class="col-xl-3 col-md-12 order-2 order-xl-1 mt-4 mt-xl-0" style="width: 20%;">
					<div class="widget widget_recent_entries">
						<h2 class="widget-title">
							<a href="/admin/adminNoticeBoard">관리자</a>
						</h2>
						<ul>
							<li><a href="/admin/userList">회원</a></li>
							<li><a href="/admin/adminAuction">경매 업로드</a></li>
							<li><a href="/admin/adminAucCurList">경매 입찰내역</a></li>
							<li><a href="/admin/adminAucBuyPriceList">경매 낙찰내역</a></li>
							<li><a href="/admin/aucEvent">이벤트 경매</a></li>
							<li><a href="/admin/aeCur">이벤트경매 입찰내역</a></li>
							<li><a href="/admin/voteUpload">투표관리</a></li>
							<li><a href="/admin/payList">결제내역</a></li>
							<li><a href="/admin/product">상품내역</a></li>
							<li><a href="/admin/adminNoticeBoard">공지사항 게시판</a></li>
							<li><a href="/admin/adminQnaBoard">문의사항 게시판</a></li>
						</ul>
					</div>
				</div>
				<!-- 사이드바 끝 -->

				<!-- 문의내역 시작 -->
				<div class="col-xl-9 col-md-9 order-1 order-xl-2">
					<div class="gen-blog gen-blog-col-1">
						<div class="row">
							<div class="col-lg-12">
								<hr>
								<div class="container bootstrap snippets bootdey">
									<br>
									<h4>경매 입찰내역</h4>
									<span>경매일 조회</span>
									<!-- 날짜 검색 시작 -->
									<div class="row">
										<div class="col-lg-2 mb-3 mt-3">
											<select class="form-control input-sm" id="year" name="year"></select>
										</div>
										<div class="col-lg-2 mb-3 mt-3">
											<select class="form-control input-sm" id="month" name="month"></select>
										</div>
									</div>
									<!-- 날짜 검색 끝 -->

									<!-- 검색 창 시작 -->
									<div class="container container-2">
										<div class="row">
											<form id="search-form">
												<div class="row">
													<div class="col-12">
														<div class="row no-gutters">
															<div class="col-lg-4 col-md-3 col-sm-12 p-0">
																<select class="form-control" name="searchType" id="searchType">
																	<option value="">조회 항목</option>
																	<option value="1" <c:if test = '${searchType eq "1"}'>selected</c:if>>제목</option>
																	<option value="2" <c:if test = '${searchType eq "2"}'>selected</c:if>>아이디</option>
																</select>
															</div>
															<div class="col-lg-7 col-md-6 col-sm-12 p-0">
																<input type="text" placeholder="Search..." class="form-control" name="searchValue" id="searchValue" value="">
															</div>
															<div class="col-lg-1 col-md-3 col-sm-12 p-0">
																<button type="button" id="btnSearch" class="btn btn-base" style="color: #ffffff;">
																	<svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-search">
																		<circle cx="11" cy="11" r="8"></circle>
																		<line x1="21" y1="21" x2="16.65" y2="16.65"></line>
																	</svg>
																</button>
															</div>
														</div>
													</div>
												</div>
											</form>
										</div>
									</div>
									<!-- 검색 창 끝 -->
									<div class="row">
										<!--/col-3-->
										<div class="col-lg-12">
											<!-- 결제내역 1개 시작 -->
											<table>
												<thead style="background-color: rgba(61, 79, 115, 0.3); color: #ffffff;">
													<tr>
														<th>경매번호</th>
														<th>카테고리명</th>
														<th>작품명</th>
														<th>아이디</th>
														<th>입찰가</th>
														<th>입찰일시</th>
														<th>입찰상태</th>
													</tr>
												</thead>
												<tbody>
													<c:if test="${!empty list}">
														<c:forEach var="aucCur" items="${list}" varStatus="status">
															<tr>
																<td>
																	<div class="cell-inner">
																		<span>${aucCur.aucSeq}</span>
																	</div>
																</td>
																<td>
																	<div class="cell-inner">
																		<c:choose>
																			<c:when test="${aucCur.categoryNo == 01}">
																				<span>미술</span>
																			</c:when>
																			<c:when test="${aucCur.categoryNo == 02}">
																				<span>사진</span>
																			</c:when>
																			<c:when test="${aucCur.categoryNo == 03}">
																				<span>도예</span>
																			</c:when>
																		</c:choose>
																	</div>
																</td>
																<td>
																	<div class="cell-inner">
																		<span>${aucCur.vrTitle}</span>
																	</div>
																</td>
																<td>
																	<div class="cell-inner">
																		<span>${aucCur.userId}</span>
																	</div>
																</td>
																<td>
																	<div class="cell-inner">
																		<span>${aucCur.aucCurPrice}</span>
																	</div>
																</td>
																<td>
																	<div class="cell-inner">
																		<span>${aucCur.aucCurBuyTime}</span>
																	</div>
																</td>
																<td>
																	<div class="cell-inner">
																		<c:choose>
																			<c:when test="${aucCur.status == 'N'}">
																				<span>입찰</span>
																			</c:when>
																			<c:when test="${aucCur.status == 'Y'}">
																				<span>낙찰성공</span>
																			</c:when>
																			<c:when test="${aucCur.status == 'C'}">
																				<span>입찰(환불)</span>
																			</c:when>
																		</c:choose>
																	</div>
																</td>
															</tr>
														</c:forEach>
													</c:if>
												</tbody>
											</table>
											<!-- 결제내역 1개 끝 -->
											
											<!-- 페이징처리 시작 -->
											<div class="col-lg-12 col-md-12" style="margin: 0 auto;">
												<div class="gen-pagination" style="text-align: center;">
													<nav aria-label="Page navigation" style="display: inline-block;">
														<ul class="page-numbers">
															<c:if test="${!empty paging}">
																<c:if test="${paging.prevBlockPage gt 0}">
																	<!-- greater than, less than -->
																	<li>
																		<a class="next page-numbers" href="javascript:void(0)" onclick="fn_list(${paging.prevBlockPage})">이전블럭</a>
																	</li>
																</c:if>

																<c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
																	<c:choose>
																		<c:when test="${i ne curPage}">
																			<!-- not equal -->
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
																<c:if test="${paging.nextBlockPage gt 0}">
																	<li>
																		<a class="next page-numbers" href="javascript:void(0)" onclick="fn_list(${paging.nextBlockPage})">다음블럭</a>
																	</li>
																</c:if>
															</c:if>
														</ul>
													</nav>
												</div>
											</div>
											<!-- 페이징처리 끝 -->
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
	<!-- Blog-left-Sidebar -->

	<form name="bbsForm" id="bbsForm" method="post">
		<input type="hidden" name="vrSeq" id="vrSeq" value="" /> 
		<input type="hidden" id="curPage" name="curPage" value="${curPage}" /> 
		<input type="hidden" id="searchDate" name="searchDate" value="" /> 
		<input type="hidden" id="yearValue" name="yearValue" value="${yearValue}" />
		<!-- modelMapd의 변수 -->
		<input type="hidden" id="monthValue" name="monthValue" value="${monthValue}" /> 
		<input type="hidden" id="searchType" name="searchType" value="${searchType}" />
		<!-- modelMapd의 변수 -->
		<input type="hidden" id="searchValue" name="searchValue" value="${searchValue}" />
	</form>

	<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>