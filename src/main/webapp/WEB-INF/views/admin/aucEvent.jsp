<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>

<style>
.button-container {
	text-align: right; /* 텍스트를 오른쪽으로 정렬 */
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


</script>
</head>
<body>
	<%@ include file="/WEB-INF/views/include/navigation.jsp"%>

	<!-- breadcrumb -->
	<div class="gen-breadcrumb">
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
								<li class="breadcrumb-item active">이벤트경매 내역</li>
							</ol>
						</div>
					</nav>
				</div>
			</div>
		</div>
	</div>
	<!-- breadcrumb -->

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
							<li><a href="/admin/voteUpload">투표</a></li>
							<li><a href="/admin/payList">결제내역</a></li>
							<li><a href="/admin/product">상품내역</a></li>
							<li><a href="/admin/adminNoticeBoard">공지사항 게시판</a></li>
							<li><a href="/admin/adminQnaBoard">문의사항 게시판</a></li>
						</ul>
					</div>
				</div>
				<!-- 사이드바 끝 -->

				<!-- 게시판 1개 시작  -->
				<div class="col-xl-9 col-md-12 order-1 order-xl-2">
					<div class="gen-blog gen-blog-col-1">
						<div class="row">
							<div class="col-lg-12">
								<div class="row">
									<div class="col-lg-12">
										<h4>이벤트 경매상태 관리</h4>
										<br>
										<div class="ml-auto input-group">
											<select name="searchType" id="searchType" class="custom-select" style="width: auto;">
												<option value="">조회 항목</option>
												<option value="1" <c:if test='${searchType eq "1"}'>selected</c:if>>제목</option>
												<option value="2" <c:if test='${searchType eq "2"}'>selected</c:if>>상품명</option>
											</select> 
											<input type="text" name="searchValue" id="searchValue" value="${searchValue}" class="form-control mx-1" maxlength="20" style="width: auto; ime-mode: active; height: 38px !important;" placeholder="조회값을 입력하세요." />
											<button type="button" id="btnSearch" class="btn btn-secondary mb-3 mx-1">조회</button>

											<div class="button-container" style="float: right; width: 50%;">
												<button id="btnBidY">낙찰선정</button>
												<button id="btnReturn">돌려주기</button>
												<button id="btnStatusY">경매시작</button>
												<button id="btnStatusN">경매종료</button>
											</div>
										</div>

										<div class="row">
											<!--/col-3-->
											<div class="col-lg-12">
												<div class="table-responsive" style="color: #ffffff;">
													<table class="table" style="color: #ffffff;">
														<thead style="background-color: rgba(61, 79, 115, 0.3); color: #ffffff;">
															<tr>
																<th>번호</th>
																<th>제목</th>
																<th>상품명</th>
																<th>시작가격</th>
																<th>경매시작</th>
																<th>경매종료</th>
																<th>낙찰액</th>
																<th>상태</th>
																<th>선택</th>
															</tr>
														</thead>
														<tbody id="items">
															<c:forEach var="list" items="${list}" varStatus="status">
																<tr>
																	<td>
																		<div class=“cell-inner”>
																			<span>${list.aeSeq}</span>
																		</div>
																	</td>
																	<td>
																		<div class="cell-inner">
																			<span>${list.aeTitle}</span>
																		</div>
																	</td>
																	<td>
																		<div class="cell-inner">
																			<span>${list.aeProductTitle}</span>
																		</div>
																	</td>
																	<td>
																		<div class="cell-inner">
																			<span>${list.aeStartPrice}</span>
																		</div>
																	</td>
																	<td>
																		<div class="cell-inner">
																			<span>${list.aeStartTime} 시</span>
																		</div>
																	</td>
																	<td>
																		<div class="cell-inner">
																			<span>${list.aeEndTime} 시</span>
																		</div>
																	</td>
																	<td>
																		<div class="cell-inner">
																			<span>${list.aeBuyPrice}</span>
																		</div>
																	</td>
																	<td>
																		<c:choose>
																			<c:when test="${list.status == 'Y'}">
																				<div>
																					<a><span>진행중</span></a>
																				</div>
																			</c:when>
																			<c:when test="${list.status == 'N'}">
																				<div>
																					<a><span>종료</span></a>
																				</div>
																			</c:when>
																			<c:when test="${list.status == 'R' }">
																				<div>
																					<a><span>예정</span></a>
																				</div>
																			</c:when>
																		</c:choose>
																	</td>
																	<td>
																		<label> 
																			<input type="radio" name="radio" value="${list.aeSeq}">
																		</label>
																	</td>
																</tr>
															</c:forEach>
														</tbody>
													</table>
													
													<!-- 페이징처리 시작 -->
													<div class="col-lg-12 col-md-12" style="margin: 0 auto;">
														<div class="gen-pagination" style="text-align: center;">
															<nav aria-label="Page navigation" style="display: inline-block;">
																<ul class="page-numbers">
																	<c:if test="${!empty paging}">
																		<c:if test="${paging.prevBlockPage gt 0}">
																			<li>
																				<a class="next page-numbers" href="javascript:void(0)" onclick="fn_list(${paging.prevBlockPage})">이전</a>
																			</li>
																		</c:if>

																		<c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
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
																		<c:if test="${paging.nextBlockPage gt 0}">
																			<li>
																				<a class="next page-numbers" href="javascript:void(0)" onclick="fn_list(${paging.nextBlockPage})">다음</a>
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
										</div>
									</div>
								</div>
							</div>
						</div>
						<!-- 게시판 1개 끝 -->
					</div>
				</div>
			</div>
		</div>
	</section>

	<form name="aeForm" id="aeForm" method="post">
		<input type="hidden" name="aeSeq" id="aeSeq" value="${aeSeq}" /> 
		<input type="hidden" name="curPage" id="curPage" value="${curPage}" /> 
		<input type="hidden" name="searchType" id="searchType" value="${searchType}" />
		<input type="hidden" name="searchValue" id="searchValue" value="${searchValue}" />
	</form>

	<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>