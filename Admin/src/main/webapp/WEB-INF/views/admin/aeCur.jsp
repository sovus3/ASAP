<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
</head>
<style>
th, td {
	text-align: center !important; /* 텍스트를 왼쪽 정렬합니다. */
}
</style>
<script>
$(document).ready(function(){
	//조회
	$("#btnSearch").on("click",function(){
		document.aeForm.aeSeq.value="";	
		document.aeForm.searchType.value=$("#searchType").val();
		document.aeForm.searchValue.value=$("#searchValue").val();
		document.aeForm.curPage.value="1";
		document.aeForm.action="/admin/aeCur";
		document.aeForm.submit();
	});
});

//페이지 이동
function fn_list(curPage)
{
	document.aeForm.curPage.value = curPage;
	document.aeForm.action ="/admin/aeCur";
	document.aeForm.submit();

}

</script>
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
									<h4 class="card-title">이벤트 경매 입찰내역</h4>
							
								<div class="form-group"
											style="display: flex; margin-bottom: 10px;">
											<select id="searchType" name="searchType"
												class="form-control bg-transparent border-1"
												style="width: 100px; height: 46px; margin-top:1px; margin-right: 5px;">
												<option value="">조회 항목</option>
													<option value="1" <c:if test='${searchType eq "1"}'>selected</c:if>>제목</option>
													<option value="2" <c:if test='${searchType eq "2"}'>selected</c:if>>아이디</option>
													<option value="3" <c:if test='${searchType eq "3"}'>selected</c:if>>입찰</option>
													<option value="4" <c:if test='${searchType eq "4"}'>selected</c:if>>낙찰</option>
												</select>  
										<!-- 여기 사이 공간을 줄이고 싶어 -->
										<div class="search-field d-none d-xl-block" style="margin-bottom: 10px;">
											<div class="input-group-prepend bg-transparent" style="width: 500px !important;">
				                                    <input type="text" class="form-control bg-transparent border-1"
				                                       style="font-size: 0.8rem; width: 15rem; height: 3rem;margin-right:5px;"
				                                       id="searchValue" name="searchValue" value="${searchValue }">
												<div id="btnSearch" class="input-group-prepend bg-transparent">
													<i class="input-group-text bg-transparent border-1 mdi mdi-magnify"></i>
												</div>
											</div>
										</div>
										</div>
										



										<table class="table table-striped">
											<thead>
												<tr>
													<th>번호</th>
													<th>아이디</th>
													<th>제목</th>
													<th>상품명</th>
													<th>입찰액</th>
													<th>입찰날짜</th>
													<th>상태</th>
												</tr>
											</thead>
													<tbody>
													<c:if test="${!empty list}">													
												<c:set var="startNum" value="${paging.startNum}" />
												<c:forEach var="list" items="${list}" varStatus="status">
														<tr>
															<td>${startNum}</td>
															<td >${list.userId}</td>
															<td >${list.aeTitle}</td>
															<td >${list.aeProductTitle}</td>
															<td ><fmt:formatNumber type="number" maxFractionDigits="3" value="${list.aeCurPrice}"/></td>
															<td >${list.aeCurBuyTime}</td>
															<td ><c:choose>
																<c:when test="${list.status == 'Y'}">
																	<div>
																		<a><span>낙찰</span></a>
																	</div>
																</c:when>
																<c:when test="${list.status == 'N'}">
																	<div>
																		<a><span>입찰</span></a>
																	</div>
																</c:when>
																<c:when test="${list.status == 'C' }">
																	<div>
																		<a><span>입찰(환불)</span></a>
																	</div>
																</c:when>
															</c:choose></td>															
																</tr>
														<c:set var="startNum" value="${startNum-1}"></c:set>
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

	<form name="aeForm" id="aeForm" method="post">
		<input type="hidden" name="aeSeq" id="aeSeq" value="${aeSeq}" /> 
		<input type="hidden" name="curPage" id="curPage" value="${curPage}" /> 
		<input type="hidden" name="searchType" id="searchType" value="${searchType}" />
		<input type="hidden" name="searchValue" id="searchValue" value="${searchValue}" />
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