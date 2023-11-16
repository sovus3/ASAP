<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>

<style>
th, td {
	text-align: center !important; /* 텍스트를 왼쪽 정렬합니다. */
}
.total {
	font-size: 80%; /* 작게 표시하기 위해 폰트 크기를 조절합니다. */
	color: #007bff;
	cursor: pointer;
}
</style>
<script>
$(document).ready(function() {
	   
	$("#btnSearch").on("click", function() {
	   search();
	});
	
	$("#_searchValue").on("keyup", function(event) {
	    if (event.keyCode === 13) {
	       search();
	    }
	});
	
	function search() {
	   document.bbsForm.orderNo.value = "";
	   document.bbsForm.searchType.value = $("#_searchType").val();
	   document.bbsForm.searchValue.value = $("#_searchValue").val();
	   document.bbsForm.curPage.value = "1";
	   document.bbsForm.action = "/admin/payList";
	   document.bbsForm.submit();
	}

});

function fn_view(orderNo)      
{
   document.bbsForm.orderNo.value= orderNo;
   document.bbsForm.action="/admin/payDetail";
   document.bbsForm.submit();
}

function fn_list(curPage)
{
   document.bbsForm.orderNo.value="";   
   document.bbsForm.curPage.value = curPage;
   document.bbsForm.action="/admin/payList";
   document.bbsForm.submit();
}

</script>
</head>
<body>
	<div class="container-scroller">
		<!-- partial:/partials/_navbar.html -->
		<%@ include file="/WEB-INF/views/include/navigation.jsp"%>
		<!-- partial -->
		 <div class="container-fluid page-body-wrapper">
        <!-- partial:/partials/_sidebar.html -->
        			 <nav class="sidebar sidebar-offcanvas" id="sidebar">
            <ul class="nav">
               <li class="nav-item nav-category" style="margin-bottom:10px;"></li>
               <li class="nav-item"><a class="nav-link"
                  href="/admin/userList"> <span class="icon-bg"><i
                        class="mdi mdi-settings menu-icon"></i></span> <span class="menu-title">회원</span>
               </a></li>
               <li class="nav-item"><a class="nav-link"
                  href="/admin/voteUpload"> <span class="icon-bg"><i
                        class="mdi mdi-settings menu-icon"></i></span> <span class="menu-title">투표</span>
               </a></li>
               <li class="nav-item"><a class="nav-link"
                  data-toggle="collapse" href="#ui-basic1" aria-expanded="false"
                  aria-controls="ui-basic"> <span class="icon-bg"><i
                        class="mdi mdi-settings menu-icon"></i></span> <span class="menu-title">경매</span>
                     <i class="menu-arrow"></i>
               </a>
                  <div class="collapse" id="ui-basic1">
                     <ul class="nav flex-column sub-menu">
                        <li class="nav-item"><a class="nav-link"
                           href="/admin/adminAuction">경매 업로드</a></li>
                        <li class="nav-item"><a class="nav-link"
                           href="/admin/adminAucCurList">경매 입찰내역</a></li>
                        <li class="nav-item"><a class="nav-link"
                           href="/admin/adminAucBuyPriceList">경매 낙찰내역</a></li>
                     </ul>
                  </div></li>
               <li class="nav-item"><a class="nav-link"
                  data-toggle="collapse" href="#ui-basic2" aria-expanded="false"
                  aria-controls="ui-basic"> <span class="icon-bg"><i
                        class="mdi mdi-settings menu-icon"></i></span> <span class="menu-title">이벤트
                        경매</span> <i class="menu-arrow"></i>
               </a>
                  <div class="collapse" id="ui-basic2">
                     <ul class="nav flex-column sub-menu">
                        <li class="nav-item"><a class="nav-link"
                           href="/admin/aucEvent">이벤트경매 관리</a></li>
                        <li class="nav-item"><a class="nav-link"
                           href="/admin/aeCur">이벤트경매 입찰내역</a></li>
                     </ul>
                  </div></li>
               
               <li class="nav-item"><a class="nav-link"
                  data-toggle="collapse" href="#ui-basic3" aria-expanded="false"
                  aria-controls="ui-basic"> <span class="icon-bg"><i
                        class="mdi mdi-settings menu-icon"></i></span> <span class="menu-title">상품 및 결제 관리</span> <i class="menu-arrow"></i>
               </a>
                  <div class="collapse" id="ui-basic3">
                     <ul class="nav flex-column sub-menu">
                        <li class="nav-item"><a class="nav-link"
                           href="/admin/product">상품 관리</a></li>
                        <li class="nav-item"><a class="nav-link"
                           href="/admin/payList">결제 내역</a></li>
                     </ul>
                  </div></li>
               <li class="nav-item"><a class="nav-link"
                  data-toggle="collapse" href="#ui-basic4" aria-expanded="false"
                  aria-controls="ui-basic"> <span class="icon-bg"><i
                        class="mdi mdi-settings menu-icon"></i></span> <span class="menu-title">게시판</span>
                     <i class="menu-arrow"></i>
               </a>
                  <div class="collapse" id="ui-basic4">
                     <ul class="nav flex-column sub-menu">
                        <li class="nav-item"><a class="nav-link"
                           href="/admin/adminNoticeBoard">공지사항 게시판</a></li>
                        <li class="nav-item"><a class="nav-link"
                           href="/admin/adminQnaBoard">문의사항 게시판</a></li>
                     </ul>
                  </div>
                  </li>
               <li class="nav-item sidebar-user-actions" style="margin-top:30px;">
                  <div class="user-details">
                     <div class="d-flex justify-content-between align-items-center">
                        <div>
                           <div class="d-flex align-items-center">
                              <div class="sidebar-profile-img" style="margin-top:-10px;">
                                 <i class="mdi mdi-account-star" style="font-size:20px;"></i>                                  
                              </div> 
                              <div class="sidebar-profile-text">
                                 <p class="mb-1" style="color:white;">${gnbAdmId }</p>
                              </div>
                           </div>
                        </div>
                     </div>
                  </div>
               </li>
               <li class="nav-item sidebar-user-actions">
                  <div class="sidebar-user-menu">
                     <a href="/user/logOut" class="nav-link"><i
                        class="mdi mdi-logout menu-icon"></i> <span class="menu-title">로그아웃</span></a>
                  </div>
               </li>
            </ul>
         </nav>
			<!-- partial -->
			<div class="main-panel">
				<div class="content-wrapper">
					<div class="page-header">
					</div>


					<div class="row">
						<div class="col-lg-12 grid-margin stretch-card">
							<div class="card">
								<div class="card-body">
									<h4 class="card-title">결제 내역</h4>
							
								<div class="form-group"
											style="display: flex; margin-bottom: 10px;">
											<select id="_searchType" name="_searchType"
												class="form-control bg-transparent border-1"
												style="width: 100px; height: 46px; margin-top:1px; margin-right: 5px;">												
													<option value="">조회 항목</option>
													<option value="1" <c:if test = '${searchType eq "1"}'>selected</c:if>>주문번호</option>
													<option value="2" <c:if test = '${searchType eq "2"}'>selected</c:if>>결제일</option>
													<option value="3" <c:if test = '${searchType eq "3"}'>selected</c:if>>회원아이디</option>
													<option value="4" <c:if test = '${searchType eq "4"}'>selected</c:if>>상품명</option>
													<option value="5" <c:if test = '${searchType eq "5"}'>selected</c:if>>결제상태</option>
												</select>
										<!-- 여기 사이 공간을 줄이고 싶어 -->
										<div class="search-field d-none d-xl-block"
											style="margin-bottom: 10px;flex: 1;">
											<div class="input-group-prepend bg-transparent"
												style="width: 500px !important;">

												<input type="text"
													class="form-control bg-transparent border-1"
													style="font-size: 0.8rem; width: 15rem; height: 3rem;margin-right:5px;"
													id="_searchValue" name="_searchValue" value="${searchValue }">
												<div id="btnSearch"
													class="input-group-prepend bg-transparent">
													<i
														class="input-group-text bg-transparent border-1 mdi mdi-magnify"></i>
												</div>
											</div>
										</div>
										<div class="total" style="margin-top: 15px !important; text-align: right !important;">
											<span>결제상태 : Y(완료), F(포인트 환불), N(취소) </span>
										</div>
										</div>



										<table class="table table-striped">
											<thead>
												<tr>
													<th>주문번호</th>
													<th>결제날</th>
													<th>회원아이디</th>
													<th>상품명</th>
													<th>총 결제액</th>
													<th>포인트 사용액</th>
													<th>실 결제액</th>
													<th>결제상태</th>
												</tr>
											</thead>
													<tbody>
													<c:if test="${!empty list}">
														<c:forEach var="pay" items="${list}" varStatus="status">
														<tr>
															<td>${pay.orderNo}</td>
															<td><c:set var="originalDate" value="${pay.regDate}" />
																		<c:set var="dateParts" value="${fn:split(originalDate, ' ')}" />
																		<c:set var="dateOnly" value="${dateParts[0]}" />
																		${dateOnly}</td>
															<td>${pay.userId}</td>
															<c:choose>
																	<c:when test="${pay.cnt >1 }">
																		<td>
																			<div class="cell-inner" style="cursor: pointer; color: #007bff; " onclick="fn_view(${pay.orderNo})">
																				${pay.productName} 외 ${pay.cnt -1 }개
																			</div>
																		</td>
																	</c:when>
																	<c:otherwise>
																		<td>
																			<div class="cell-inner" style="cursor: pointer; color: #007bff;" onclick="fn_view(${pay.orderNo})">
																				${pay.productName}
																			</div>
																		</td>
																	</c:otherwise>
																</c:choose>
															<td><fmt:formatNumber type="number" maxFractionDigits="3" value="${pay.payTotalPrice}" /></td>
															<td><fmt:formatNumber type="number" maxFractionDigits="3" value="${pay.payPointPrice}" /></td>
															<td><fmt:formatNumber type="number" maxFractionDigits="3" value="${pay.payRealPrice}" /></td>
															<td>${pay.status}</td>									
														</tr>
														<c:set var="count" value="${count - 1}" />
														</c:forEach>
														</c:if>
														</tbody>
														
										</table>
										

									<!-- 여기부 터 -->

									<div class="mt-3"
										style="display: flex; justify-content: center;">
										<!-- 페이징 샘플 시작 -->
										<c:if test="${!empty paging}">
											<!--  이전 블럭 시작 -->
											<c:if test="${paging.prevBlockPage gt 0}">
												<a href="javascript:void(0)" class="btn btn-primary"
													onclick="fn_list(${paging.prevBlockPage})" title="이전 블럭">&laquo;</a>
											</c:if>
											<div style="width: 4px;"></div>
											<!--  이전 블럭 종료 -->
											<span> <!-- 페이지 시작 --> <c:forEach var="i"
													begin="${paging.startPage}" end="${paging.endPage}">
													<c:choose>
														<c:when test="${i ne curPage}">
															<a href="javascript:void(0)" class="btn btn-primary"
																onclick="fn_list(${i})" style="font-size: 14px;">${i}</a>
														</c:when>
														<c:otherwise>
															<h class="btn btn-primary"
																style="font-size:14px; font-weight:bold;">${i}</h>
														</c:otherwise>
													</c:choose>
												</c:forEach> <!-- 페이지 종료 -->
											</span>
											<div style="width: 4px;"></div>
											<!--  다음 블럭 시작 -->
											<c:if test="${paging.nextBlockPage gt 0}">
												<a href="javascript:void(0)" class="btn btn-primary"
													onclick="fn_list(${paging.nextBlockPage})" title="다음 블럭">&raquo;</a>
											</c:if>
											<!--  다음 블럭 종료 -->
										</c:if>
										<!-- 페이징 샘플 종료 -->
									</div>


								</div>
							</div>
						</div>
					</div>

					<!-- content-wrapper ends -->

	<form name="bbsForm" id="bbsForm" method="post">
		<input type="hidden" name="orderNo" value="" /> 
		<input type="hidden" name="searchType" value="${searchType}" /> 
		<input type="hidden" name="searchValue" value="${searchValue}" /> 
		<input type="hidden" name="curPage" value="${curPage}" />
	</form>

				</div>
				<!-- main-panel ends -->
			</div>
			<!-- page-body-wrapper ends -->
		</div>
		<!-- container-scroller -->
		</div>
		<!-- plugins:js -->
		<script src="/resources/vendors/js/vendor.bundle.base.js"></script>
		<!-- endinject -->
		<!-- Plugin js for this page -->
		<!-- End plugin js for this page -->
		<!-- inject:js -->
		<script src="/resources/js/off-canvas.js"></script>
		<script src="/resources/js/hoverable-collapse.js"></script>
		<script src="/resources/js/misc.js"></script>
		<!-- endinject -->
		<!-- Custom js for this page -->
		<!-- End custom js for this page -->
</body>
</html>