<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>

<style>
th, td {
	text-align: center !important; /* 텍스트를 왼쪽 정렬합니다. */
}
</style>
<script>

$(document).ready(function(){
	
	$("#btnSearch").on("click",function(){
		document.aeForm.aeSeq.value="";	
	    document.aeForm.searchType.value=$("#searchType").val();
		document.aeForm.searchValue.value=$("#searchValue").val();
		document.aeForm.curPage.value="1";
		document.aeForm.action="/admin/aucEvent";
		document.aeForm.submit();
	});
	
	
	/* 입찰자 -> 낙찰자 상태 변경 */ 
	$("#btnBidY").click(function(){
		
		var radios = document.getElementsByName("radio"); // 라디오 버튼 요소 가져오기
		var isChecked = false; // 체크 여부를 저장할 변수 초기화

		// 라디오 버튼을 반복해서 확인
		for (var i = 0; i < radios.length; i++)
		{
			if (radios[i].checked)
			{
				isChecked = true; // 체크된 라디오 버튼이 있으면 isChecked를 true로 설정
				break; // 체크된 라디오 버튼이 하나라도 발견되면 반복문 종료
			}
		}
		
		if (!isChecked) 
		{
			// 체크된 라디오 버튼이 있으면 다음 단계로 넘어가는 로직을 여기에 작성
			Swal.fire('체크	해주세요.', '', 'info');
			return;
		} 
	        
		document.aeForm.aeSeq.value = $('input[name=radio]:checked').val();
		
		Swal.fire({
			title: '낙찰자로 설정하시겠습니까?',
			icon: 'info',
			showCancelButton: true,
			confirmButtonColor: '#3085d6',
			cancelButtonColor: '#d33',
			confirmButtonText: '확인',
			cancelButtonText: '취소'
		}).then((result) => {
			if (result.isConfirmed) {
				$.ajax({
					type:"POST",
					url:"/admin/bidUpdateProc",
					data:{
						aeSeq:$("#aeSeq").val()
					},
					datatype:"JSON",
					beforeSend:function(xhr)
					{
						xhr.setRequestHeader("AJAX", "true");
					},
					success:function(rs)
					{
						if(rs.code == 0)
						{
							Swal.fire({
								title: '낙찰자를 설정했습니다.', 
								icon: 'success'
							}).then(function(){
								location.href="/admin/aucEvent";
							})
						}
						else if(rs.code == 1)
						{
							Swal.fire('낙찰자가 있거나 경매가 종료되지 않았습니다.', '', 'warning');
						}
						else if(rs.code == 400)
						{
							Swal.fire('상태 변경 중 오류가 발생하였습니다.', '', 'warning');
						}
						else
						{
							Swal.fire('알수 없는 오류가 발생하였습니다.', '', 'error');
						}
	    						
					},
					error:function(xhr, status, error)
					{
						icia.common.error(error);
					}
				});
			}
		})	
	});
	
	/* 돈 돌려주기 + 상태 변경 */ 
	$("#btnReturn").click(function(){
		var radios = document.getElementsByName("radio"); // 라디오 버튼 요소 가져오기
		var isChecked = false; // 체크 여부를 저장할 변수 초기화

		// 라디오 버튼을 반복해서 확인
		for (var i = 0; i < radios.length; i++)
		{
			if (radios[i].checked)
			{
				isChecked = true; // 체크된 라디오 버튼이 있으면 isChecked를 true로 설정
				break; // 체크된 라디오 버튼이 하나라도 발견되면 반복문 종료
			}
		}
		
		if (!isChecked)
		{
			// 체크된 라디오 버튼이 있으면 다음 단계로 넘어가는 로직을 여기에 작성
			Swal.fire('체크해주세요.', '', 'info');
			return;
		} 
	        	
		document.aeForm.aeSeq.value = $('input[name=radio]:checked').val();
	
		Swal.fire({
			title: '돈을 돌려주시겠습니까?',
			icon: 'info',
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
					url:"/admin/chargeProc",
					data:{
						aeSeq:$("#aeSeq").val()
					},
					datatype:"JSON",
					beforeSend:function(xhr)
					{
						xhr.setRequestHeader("AJAX", "true");
					},
					success:function(rs)
					{
						if(rs.code == 0)
						{
							Swal.fire({
								title: '환불 완료되었습니다.', 
								icon: 'success'
							}).then(function(){
								location.href="/admin/aucEvent";
							})
						}
						else if(rs.code == 200)
						{
							Swal.fire('접근 권한이 없습니다.', '', 'warning');
						}
						else if(rs.code == 300)
						{
							Swal.fire('환불 과정 중 오류가 발생하였습니다.', '', 'warning');
						}
						else if(rs.code == 400)
						{
							Swal.fire('상태 변경 중 오류가 발생하였습니다.', '', 'warning');
						}
						else
						{
							Swal.fire('알 수 없는 오류가 발생하였습니다.', '', 'error');
						}
								
					},
					error:function(xhr, status, error)
					{
						icia.common.error(error);
					}
				});
			}
		})
	});
	
	/* 경매 시작 상태 변경 */ 
	$("#btnStatusY").click(function(){
		
		var radios = document.getElementsByName("radio"); // 라디오 버튼 요소 가져오기
		var isChecked = false; // 체크 여부를 저장할 변수 초기화

		// 라디오 버튼을 반복해서 확인
		for (var i = 0; i < radios.length; i++) 
		{
			if (radios[i].checked)
			{
				isChecked = true; // 체크된 라디오 버튼이 있으면 isChecked를 true로 설정
				break; // 체크된 라디오 버튼이 하나라도 발견되면 반복문 종료
			}
		}

        if (!isChecked) 
        {
            // 체크된 라디오 버튼이 있으면 다음 단계로 넘어가는 로직을 여기에 작성
            Swal.fire('체크해주세요', '', 'info');
       		return;
        } 
		
        document.aeForm.aeSeq.value = $('input[name=radio]:checked').val();
    	
        Swal.fire({
			title: '경매 시작으로 변경하겠습니까?',
			icon: 'info',
			showCancelButton: true,
			confirmButtonColor: '#3085d6',
			cancelButtonColor: '#d33',
			confirmButtonText: '확인',
			cancelButtonText: '취소'
        }).then((result) => {
			if (result.isConfirmed) {
				$.ajax({
					type:"POST",
					url:"/admin/yStatusProc",
					data:{
						aeSeq:$("#aeSeq").val()
					},
					datatype:"JSON",
					beforeSend:function(xhr)
					{
						xhr.setRequestHeader("AJAX", "true");
					},
					success:function(rs)
					{
						if(rs.code == 0)
						{
							Swal.fire({
								title: '경매 시작으로 변경되었습니다.', 
								icon: 'success'
							}).then(function(){
								location.href="/admin/aucEvent"
							})
						}
						else if(rs.code == 1)
						{
							Swal.fire('경매 예정 작품만 가능합니다.', '', 'info');
						}
						else if(rs.code == 400)
						{
							Swal.fire('상태 변경 중 오류가 발생하였습니다.', '', 'warning');
						}
						else
						{
							Swal.fire('알 수 없는 오류가 발생하였습니다.', '', 'error');
						}
						
					},
					error:function(xhr, status, error)
					{
						icia.common.error(error);
					}
				});
			}
		})
	});
	
	
	/* 경매 종료 상태 변경 */ 
	$("#btnStatusN").click(function(){
	      
		var radios = document.getElementsByName("radio"); // 라디오 버튼 요소 가져오기
		var isChecked = false; // 체크 여부를 저장할 변수 초기화

		// 라디오 버튼을 반복해서 확인
		for (var i = 0; i < radios.length; i++)
		{
			if (radios[i].checked) {
				isChecked = true; // 체크된 라디오 버튼이 있으면 isChecked를 true로 설정
				break; // 체크된 라디오 버튼이 하나라도 발견되면 반복문 종료
			}
		}
		
		if (!isChecked) {
			// 체크된 라디오 버튼이 있으면 다음 단계로 넘어가는 로직을 여기에 작성
			Swal.fire('체크해주세요.', '', 'info');
			return;
		} 
	           
		document.aeForm.aeSeq.value = $('input[name=radio]:checked').val();
	          
		Swal.fire({
			title: '경매 종료로 하겠습니까?',
			icon: 'info',
			showCancelButton: true,
			confirmButtonColor: '#3085d6',
			cancelButtonColor: '#d33',
			confirmButtonText: '확인',
			cancelButtonText: '취소'
		}).then((result) => {
			if (result.isConfirmed) {
				$.ajax({
					type:"POST",
					url:"/admin/nStatusProc",
					data:{
						aeSeq:$("#aeSeq").val()
					},
					datatype:"JSON",
					beforeSend:function(xhr)
					{
						xhr.setRequestHeader("AJAX", "true");
					},
					success:function(rs)
					{
						if(rs.code == 0)
						{
							Swal.fire({
								title: '종료 상태로 변경되었습니다.', 
								icon: 'success'
							}).then(function(){
								location.href="/admin/aucEvent";
							})
						}
						else if(rs.code == 1)
						{
							Swal.fire('진행중인 경매만 가능합니다.', '', 'info');
						}
						else if(rs.code == 400)
						{
							Swal.fire('상태 변경 중 오류가 발생하였습니다.', '', 'warning');
						}
						else
						{
							Swal.fire('알 수 없는 오류가 발생하였습니다.', '', 'error');
						}
						       	                  
					},
					error:function(xhr, status, error)
					{
						icia.common.error(error);
					}
				});
			}
		})        
	});
});

function fn_list(curPage)
{
	document.aeForm.curPage.value = curPage;
	document.aeForm.action ="/admin/aucEvent";
	document.aeForm.submit();
}

function fn_upload()
{
	document.aeForm.action ="/admin/aeRegForm";
	document.aeForm.submit();
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
									<h4 class="card-title">이벤트 경매상태 관리</h4>
							
								<div class="form-group" style="display: flex; margin-bottom: 10px;">
											<select id="searchType" name="searchType" class="form-control bg-transparent border-1"
												style="width: 100px; height: 46px; margin-top:1px; margin-right: 5px;">
												<option value="">조회 항목</option>
												<option value="1" <c:if test = '${searchType eq "1"}'>selected</c:if>>제목</option>
												<option value="2" <c:if test = '${searchType eq "2"}'>selected</c:if>>상품명</option>
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
										<div style="text-align:left !important; margin-bottom:10px; display: flex;">
									      <div style="margin-left: auto; margin-bottom:10px;">
											<input type="button" onclick="fn_upload()" class="btn btn-primary" value="이벤트 경매 올리기" >
										  </div>
										</div>
										<table class="table table-striped">
											<thead>
												<tr>
													<th>번호</th>
													<th>제목</th>
													<th>상품명</th>
													<th>시작 가격</th>
													<th>경매 시작</th>
													<th>경매 종료</th>
													<th>낙찰액</th>
													<th>상태</th>
													<th>선택</th>
												</tr>
											</thead>
													<tbody>
													<c:if test="${!empty list}">
												<c:forEach var="list" items="${list}" varStatus="status">
														<tr>
															<td>${list.aeSeq}</td>
															<td >${list.aeTitle}</td>
															<td >${list.aeProductTitle}</td>
															<td ><fmt:formatNumber type="number" maxFractionDigits="3" value="${list.aeStartPrice}"/></td>
															<td >${list.aeStartTime} 시</td>
															<td >${list.aeEndTime} 시</td>
															<td >${list.aeBuyPrice}</td>
															<td ><c:choose>
																	<c:when test="${list.status == 'Y'}">
																		진행중
																	</c:when>
																	<c:when test="${list.status == 'N'}">
																		종료
																	</c:when>
																	<c:when test="${list.status == 'R' }">
																		예정
																	</c:when>
																</c:choose></td>
																<td><label> <input type="radio"
																			name="radio" value="${list.aeSeq}">
																	</label></td>
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
							</div>
						</div>
					</div>

					<!-- content-wrapper ends -->

 <form name="aeForm" id="aeForm" method="post">
 		<input type="hidden" name="aeSeq" id="aeSeq" value="${aeSeq}"/>
		<input type="hidden" name="curPage" id="curPage" value="${curPage}" />
		<input type="hidden" name="searchType" id="searchType" value="${searchType}"/>
		<input type="hidden" name="searchValue" id="searchValue" value="${searchValue}"/>
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