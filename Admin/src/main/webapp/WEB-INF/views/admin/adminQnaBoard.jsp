<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<style>
th, td {
	text-align: center !important; /* 텍스트를 왼쪽 정렬합니다. */
}
select, select.form-control {
	height: 54px !important;
}
</style>
<script>
$(document).ready(function() {
	$("#btnSearch").on("click",function(){
		document.bbsForm.qaSeq.value="";   
		document.bbsForm.searchType.value=$("#_searchType").val();
		document.bbsForm.searchValue.value=$("#_searchValue").val();
		document.bbsForm.curPage.value="1";
		document.bbsForm.curPage2.value="1";
		document.bbsForm.action="/admin/adminQnaBoard";
		document.bbsForm.submit();
	});
});

//문의사항 상세보기
function fn_view(qaSeq)   
{   
	document.bbsForm.qaSeq.value=qaSeq;
	document.bbsForm.action="/admin/adminQnaView";
	document.bbsForm.submit();
}

//문의사항 관리자 답변
function fn_reply(qaSeq)   
{
	document.bbsForm.qaSeq.value=qaSeq;
	document.bbsForm.action="/admin/adminQnaReply";
	document.bbsForm.submit();
}

//문의사항 삭제
function fn_delete(value)      
{
	Swal.fire({
		title: '게시물을 삭제하시겠습니까?',
		icon: 'warning',
		showCancelButton: true,
		confirmButtonColor: '#3085d6',
		cancelButtonColor: '#d33',
		confirmButtonText: '확인',
		cancelButtonText: '취소'
	}).then((result) => {
		if (result.isConfirmed) 
		{
			$.ajax({
				type:"POST",
				url:"/admin/adminQnaDelete",
				data:{
					qaSeq:value
				},
				dataType:"JSON",
				beforeSend:function(xhr)
				{
					xhr.setRequestHeader("AJAX", "true");
				},
				success:function(response)
				{
					if(response.code == 0)
					{
						Swal.fire({
							title: '게시물이 삭제되었습니다.', 
							icon: 'success'
						}).then(function(){
							location.href="/admin/adminQnaBoard";
						})
					}
					else if(response.code == 404)
					{
						Swal.fire({
							title: '해당 게시물을 찾을 수 없습니다.', 
							icon: 'warning'
						}).then(function(){
							location.href="/admin/adminQnaBoard";
						})
					}
					else if(response.code == 403)
					{
						Swal.fire('본인 글이 아니므로 삭제할 수 없습니다.', '', 'warning');
					}
					else if(response.code == 400)
					{
						Swal.fire('파라미터 값이 올바르지 않습니다.', '', 'warning');
					}
					else
					{
						Swal.fire('게시물 삭제 중 오류가 발생하였습니다.', '', 'error');
					}
				},
				error(xhr, status, error)
				{
					icia.common.error(error);
				}
			});
		}
	})
}

//공지사항 답변대기 페이징
function fn_list(curPage)
{
	document.bbsForm.curPage.value=curPage;   
	
	$.ajax({
		type : "POST",
		url : "/admin/adminQnaBoard",
		data : {
			curPage:$("#curPage").val()
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

//공지사항 답변완료 페이징
function fn_list2(curPage2)
{
	document.bbsForm.curPage2.value=curPage2;   
	
	$.ajax({
		type : "POST",
		url : "/admin/adminQnaBoard",
		data : {
			curPage2:$("#curPage2").val()
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

function showResult(resultNumber) {
   
	document.bbsForm.resultNumber.value = resultNumber;
	
	// 모든 결과를 숨깁니다.
	document.getElementById('result1').style.display = 'none';
	document.getElementById('result2').style.display = 'none';
	
	// 선택한 결과를 표시합니다.
	if (resultNumber === 1) 
	{
		document.getElementById('result1').style.display = 'block';
	} 
	else if (resultNumber === 2) 
	{
		document.getElementById('result2').style.display = 'block';
	}
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
									<h4 class="card-title">문의사항 게시판 관리</h4>
							
								<div class="form-group"
											style="display: flex; margin-bottom: 10px;">
											<select id="_searchType" name="_searchType"
												class="form-control bg-transparent border-1"
												style="width: 100px; height: 46px !important; margin-top:1px; margin-right: 5px;">
												<option value="">조회 항목</option>
												<option value="1" <c:if test = '${searchType eq "1"}'>selected</c:if>>제목</option>
												<option value="2" <c:if test = '${searchType eq "2"}'>selected</c:if>>내용</option>
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
										<div style="margin-right:20px; margin-top:10px">
										<button type="button" class="btn btn-inverse-danger btn-fw" onclick="showResult(1)">답변대기</button>
										<button type="button" class="btn btn-inverse-primary btn-fw" onclick="showResult(2)">답변완료</button></div>
										</div>


									<div id="result1">
										<table class="table table-striped">
											<thead>
												<tr>
													<th>번호</th>
													<th>회원 아이디</th>
													<th>제목</th>
													<th>등록일</th>
													<th>삭제상태</th>
													<th></th>
												</tr>
											</thead>
													<tbody>
													<c:if test="${!empty list}">
														<c:forEach var="qnaBoard" items="${list}" varStatus="status">
														<input type="hidden" name="status" id="stauts" value="${qnaBoard.status}" />
														<tr>
															<c:if test="${qnaBoard.qaIndent eq 0}">
															<td>${qnaBoard.qaSeq}</td>
															<td>${qnaBoard.userId}</td>
															<td><c:choose>
																<c:when test="${qnaBoard.status eq 'N'}">
																	<a id="view" href="javascript:void(0)" onclick=null> ${qnaBoard.qaTitle} </a>
																</c:when>
																<c:otherwise>
																	<a id="view" href="javascript:void(0)" onclick="fn_view(${qnaBoard.qaSeq})"> ${qnaBoard.qaTitle} </a>
																</c:otherwise>
															</c:choose></td>
															<td>${qnaBoard.regDate}</td>
															<td>${qnaBoard.status}</td>
															<td>${product.status}</td>
															<td ><label class="badge badge-warning" style="cursor:pointer;" onclick="fn_reply(${qnaBoard.qaSeq})">답변</label>
																&nbsp; <label class="badge badge-danger" style="cursor:pointer;" onclick="fn_delete(${qnaBoard.qaSeq})">삭제</label></td>																							
														</c:if>
														</tr>
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
									
									
									<div id="result2" style="display: none;">
										<table class="table table-striped">
											<thead>
												<tr>
													<th>번호</th>
													<th>회원 아이디</th>
													<th>관리자 아이디</th>
													<th>제목</th>
													<th>등록일</th>
													<th>삭제상태</th>
													<th></th>
												</tr>
											</thead>
													<tbody>
													<c:if test="${!empty list2}">
														<c:forEach var="qnaBoard" items="${list2}" varStatus="status">
														<input type="hidden" name="status2" id="stauts2" value="${qnaBoard.status}" />
														<tr>
															<td>${qnaBoard.qaSeq}</td>
															<td>${qnaBoard.userId}</td>
															<td>${qnaBoard.admId}</td>
															<td><c:choose>
																<c:when test="${qnaBoard.status eq 'N'}">
																	<a id="view" href="javascript:void(0)" onclick=null> ${qnaBoard.qaTitle} </a>
																</c:when>
																<c:otherwise>
																<c:if test = "${qnaBoard.qaIndent>0}">
                           											<i class="mdi mdi-subdirectory-arrow-right" style="color:#0062ff"></i>
                           										</c:if>
																	<a id="view" href="javascript:void(0)" onclick="fn_view(${qnaBoard.qaSeq})"> ${qnaBoard.qaTitle} </a>
																</c:otherwise>
															</c:choose></td>
															<td>${qnaBoard.regDate}</td>
															<td>${qnaBoard.status}</td>
															<td>${product.status}</td>
															<td>
															<label class="badge badge-danger" style="cursor:pointer;" onclick="fn_delete(${qnaBoard.qaSeq})">삭제</label>
															</td>																																					
														</tr>
													</c:forEach>
													</c:if>
											</tbody>
										</table>
										

									<!-- 여기부 터 -->

									<div class="mt-3"
										style="display: flex; justify-content: center;">
										<!-- 페이징 샘플 시작 -->
										<c:if test="${!empty paging2}">
											<!--  이전 블럭 시작 -->
											<c:if test="${paging2.prevBlockPage gt 0}">
												<a href="javascript:void(0)" class="btn btn-primary"
													onclick="fn_list2(${paging2.prevBlockPage})" title="이전 블럭">&laquo;</a>
											</c:if>
											<div style="width: 4px;"></div>
											<!--  이전 블럭 종료 -->
											<span> <!-- 페이지 시작 --> <c:forEach var="i"
													begin="${paging2.startPage}" end="${paging2.endPage}">
													<c:choose>
														<c:when test="${i ne curPage2}">
															<a href="javascript:void(0)" class="btn btn-primary"
																onclick="fn_list2(${i})" style="font-size: 14px;">${i}</a>
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
											<c:if test="${paging2.nextBlockPage gt 0}">
												<a href="javascript:void(0)" class="btn btn-primary"
													onclick="fn_list2(${paging2.nextBlockPage})" title="다음 블럭">&raquo;</a>
											</c:if>
											<!--  다음 블럭 종료 -->
										</c:if>
										<!-- 페이징 샘플 종료 -->
									</div>
									</div>

								</div>
							</div>
						</div>
					</div>

					<!-- content-wrapper ends -->

	<form name="bbsForm" id="bbsForm" method="post">
		<input type="hidden" name="qaSeq" id="qaSeq" value="" /> 
		<input type="hidden" name="searchType" value="${searchType}" />
		<!-- modelMapd의 변수 -->
		<input type="hidden" name="searchValue" value="${searchValue}" /> 
		<input type="hidden" name="curPage" id="curPage" value="${curPage}" /> 
		<input type="hidden" name="curPage2" id="curPage2" value="${curPage2}" /> 
		<input type="hidden" name="resultNumber" id="resultNumber" value="" />
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