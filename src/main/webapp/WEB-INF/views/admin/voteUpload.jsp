<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<style>
</style>
<script>
$(document).ready(function(){

	$("#btnSearch").on("click",function(){
		document.admVoteForm.searchType.value=$("#searchType").val();
		document.admVoteForm.searchValue.value=$("#searchValue").val();
		document.admVoteForm.curPage.value="1";
		document.admVoteForm.action="/admin/voteUpload";
		document.admVoteForm.submit();
	});
});

function fn_list(curPage)
{
	document.admVoteForm.curPage.value = curPage;
	document.admVoteForm.action = "/admin/voteUpload";
	document.admVoteForm.submit();
}

function fn_voteList(vrSeq)
{ 
	/* 수정 */
	document.admVoteForm.vrSeq.value = vrSeq;
	document.admVoteForm.curPage.value = $("#curPage").val();
	document.admVoteForm.searchType.value= $("#searchType").val();
	document.admVoteForm.searchValue.value= $("#searchValue").val();
	/* 수정 */
	document.admVoteForm.action = "/admin/voteList";
	document.admVoteForm.submit(); 
}

// 상태 변경시키기 ( 승인 )
function buttonClick(vrSeq)
{	
	document.getElementById("vrSeq").value = vrSeq;
	
	Swal.fire({
		title: '승인하시겠습니까?',
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
				url:"/admin/statusProc",
				data:{
					vrSeq:$("#vrSeq").val()
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
							title: '승인 완료했습니다.', 
							icon: 'success'
						}).then(function(){
							location.href ="/admin/voteUpload"
						})
					}
					else if(rs.code == 200)
					{
						Swal.fire('승인 실패하였습니다.', '', 'warning');
					}
					else if(rs.code == 300)
					{
						Swal.fire('접근 권한이 없습니다.', '', 'warning');
					}
					else
					{
						Swal.fire('기타 오류가 발생하였습니다.', '', 'error');
					}
				},
				error:function(xhr, status, error)
				{
					icia.common.error(error);
				}
			});
		}
	})
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
								<li class="breadcrumb-item active">투표자 내역</li>
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

				<div class="col-xl-9 col-md-12 order-1 order-xl-2">
					<div class="gen-blog gen-blog-col-1">
						<div class="row">
							<div class="col-lg-12">

								<div class="container bootstrap snippets bootdey">
									<div class="row">
										<div class="col-lg-12">
											<h4>투표관리</h4>
											<div class="ml-auto input-group" style="width: 50%;">
												<select name="searchType" id="searchType" class="custom-select" style="width: auto;">
													<option value="">조회 항목</option>
													<option value="1" <c:if test='${searchType eq "1"}'>selected</c:if>>제목</option>
													<option value="2" <c:if test='${searchType eq "2"}'>selected</c:if>>아이디</option>
												</select> 
												<input type="text" name="searchValue" id="searchValue" value="${searchValue}" class="form-control mx-1" maxlength="20" style="width: auto; ime-mode: active; height:38px;" placeholder="조회값을 입력하세요." />
												<button type="button" id="btnSearch" class="btn btn-secondary mb-3 mx-1">조회</button>
											</div>
											<div class="row">
												<!--/col-3-->
												<div class="col-lg-12">
													<div class="table-responsive" style="color: #ffffff;">
														<table class="table" style="color: #ffffff;">
															<thead style="background-color: rgba(61, 79, 115, 0.3); color: #ffffff;">
																<tr>
																	<th>작품번호</th>
																	<th>작가아이디</th>
																	<th>작품제목</th>
																	<th>카테고리명</th>
																	<th>득표수</th>
																	<th>희망가</th>
																	<th>등록일</th>
																	<th>상태</th>
																	<th>관리</th>
																	<th>투표상세</th>
																</tr>
															</thead>
															<tbody id="items">
																<c:forEach var="list" items="${list}" varStatus="status">
																	<tr>
																		<td>
																			<div class=“vrSeq”>
																				<span>${list.vrSeq}</span>
																			</div>
																		</td>
																		<td>
																			<div class=“userId”>
																				<span>${list.userId}</span>
																			</div>
																		</td>
																		<td>
																			<div class="vrTitle">
																				<span>${list.vrTitle}</span>
																			</div>
																		</td>
																		<td>
																			<div class="categoryName">
																				<span>${list.categoryName}</span>
																			</div>
																		</td>
																		<td>
																			<div class="vrTotalCnt">
																				<span>${list.vrTotalCnt}</span>
																			</div>
																		</td>
																		<td>
																			<div class="vrStartPrice">
																				<span>${list.vrStartPrice}</span>
																			</div>
																		</td>
																		<td>
																			<div class=“regDate”>
																				<span>${list.regDate}</span>
																			</div>
																		</td>
																		<td>
																			<c:choose>
																				<c:when test="${list.status == 'P'}">
																					<div>
																						<a><span>신청</span></a>
																					</div>
																				</c:when>
																				<c:when test="${list.status == 'R'}">
																					<div>
																						<a><span>예정</span></a>
																					</div>
																				</c:when>
																				<c:when test="${list.status == 'Y'}">
																					<div>
																						<a><span>진행중</span></a>
																					</div>
																				</c:when>
																				<c:when test="${list.status == 'N' }">
																					<div>
																						<a><span>종료</span></a>
																					</div>
																				</c:when>
																			</c:choose>
																		</td>
																		<td>
																			<c:choose>
																				<c:when test="${list.status == 'P'}">
																					<button onclick="buttonClick(${list.vrSeq})">승인</button>
																				</c:when>
																				<c:otherwise>
																					<div class="cell-inner">
																						<span>승인완료</span>
																					</div>
																				</c:otherwise>
																			</c:choose>
																		</td>
																		<td>
																			<div class="voteList">
																				<a href="javascript:void(0)" onclick="fn_voteList(${list.vrSeq})"> 
																					<span class="text">투표자 확인</span>
																				</a>
																			</div>
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
						</div>
					</div>
				</div>
			</div>
		</div>
	</section>
	
	<form name="admVoteForm" id="admVoteForm" method="post">
		<input type="hidden" name="vrSeq" id="vrSeq" value="${vrSeq}" /> 
		<input type="hidden" name="curPage" id="curPage" value="${curPage}" /> 
		<input type="hidden" name="searchType" id="searchType" value="${searchType}" />
		<input type="hidden" name="searchValue" id="searchValue" value="${searchValue}" />
	</form>
	
	<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>