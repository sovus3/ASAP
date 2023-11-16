<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<style>
tr {
	height: 5px !important;
}

.commentScroll::-webkit-scrollbar {
	width: 10px; /* 스크롤바의 너비 */
}

.commentScroll::-webkit-scrollbar-track {
	background: #f1f1f1; /* 트랙 배경 색상 */
}

.commentScroll::-webkit-scrollbar-thumb {
	background: #888; /* 슬라이더 배경 색상 */
	border-radius: 5px; /* 슬라이더 모서리 둥글게 */
}
</style>

<script>

function inputNumberFormat(obj) {
    obj.value = comma(uncomma(obj.value));
}
function comma(str) {
    str = String(str);
    return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
}
function uncomma(str) {
    str = String(str);
    return str.replace(/[^\d]+/g, '');
}

function fn_list(){
	location.href = "/auction/auctionList";
}

/* Sweetalert 수정 시작 */
function isAucCurPrice(){
	var vrStartPrice = ${vrDetail.vrStartPrice};
	
	var aucCurPrice = $("#aucCurPrice").val().replace(",", "");
	
	if($.trim($("#aucCurPrice").val()).length <= 0){
		$("#aucCurPrice").focus();
		Swal.fire('금액을 입력해주세요','', 'warning');
		return;
	}
	
	if(aucCurPrice < vrStartPrice){
		$("#aucCurPrice").val("");
		$("#aucCurPrice").focus();
		Swal.fire('시작가 미만의 금액은 입력할 수 없습니다.', '', 'warning');
		return;
	}
	
	Swal.fire({
		title : '입찰을 진행하시겠습니까?',
		icon : 'warning',
	    showCancelButton: true,
	    confirmButtonColor: '#3085d6',
	    cancelButtonColor: '#d33',
	    confirmButtonText: '확인',
	    cancelButtonText: '취소'

	}).then((result) => {
		if(result.isConfirmed)	{
	
			$.ajax({
				type : "POST",
				url : "/auction/aucCurProc",
				data : {
					aucSeq: $("#aucSeq").val(),
					aucCurPrice: $("#aucCurPrice").val()
				},
				datatype : "JSON",
				beforeSend : function(xhr) {
					xhr.setRequestHeader("AJAX", "true");
				},
				success: function(result) {
					if(result.code == 1){
						Swal.fire({
							title : '입찰을 성공했습니다.',
							icon : 'success'
						}).then(function() {
							document.aucCurForm.aucSeq.value = $("#aucSeq").val();
							document.aucCurForm.action = "/auction/auctionDetail";
							document.aucCurForm.submit();
						})
					} 
					else if(result.code == 0){
						Swal.fire({
							title : '충전금이 부족합니다.',
							icon : 'warning'
						}).then(function(){
							location.href="/user/rechargePoints";
						})				
					}
					else if(result.code == 100){
						$("#aucCurPrice").val("");
						$("#aucCurPrice").focus();
						Swal.fire('입찰 진행 중 오류가 발생했습니다.', '', 'warning');
					}
					else if(result.code == 404){
						Swal.fire({
							title : '사용자가 아닙니다.',
							icon : 'warning'
						}).then(function() {
							location.href="/";
						})					
					}
					else if(result.code == 400){
						Swal.fire({
							title : '파라미터 값이 부족합니다.',
							icon : 'warning'
						}).then(function(){
							location.href = "/auction/auctionDetail";
						})
					}else{
						Swal.fire({
							title : '기타 오류가 발생했습니다.',
							icon : 'warning'
						}).then(function(){
							location.href = "/auction/auctionDetail";
						})					
					}
				},
				error: function(error){
					icia.com.error(error);		
				}
			});
		
		}		
	})		
	
}

$(document).ready(function(){
	
	$(".nav-link").click(function(){
		var target = $(this).attr("href"); // 클릭한 링크의 href 속성을 가져온다
		
		$('html, body').animate({
			scrollTop: $(target).offset().top // 해당 섹션의 상단 위치로 스크롤.
		}, 500); // 500은 스크롤 애니메이션의 속도를 나타낸다. 원하는 속도로 조정할 수 있다.
	});
	
	$("#btnCmt").click(function() {
		
		if($.trim($("#cmtContent").val()).length <= 0 ){
			Swal.fire('댓글을 입력하세요.', '', 'warning');
			$("#cmtContent").focus();
			return;
		}

		$.ajax({
			type:"POST",
			url:"/auction/cmtWriteProc",
			data:{
				aucSeq : $("#aucSeq").val(),
				cmtContent : $("#cmtContent").val()	
			},
			dataType:"JSON",
			beforeSend:function(xhr){
				xhr.setRequestHeader("AJAX", "true");
			},
			success:function(response){
				
				if(response.code == 0){
					let aucSeq = $("#aucSeq").val();
					
					  $('.commentScroll').load('/auction/auctionDetail?aucSeq=${aucSeq} .commentList');
				      $("#cmtContent").val("");
				        
				      /*
				      	1. 제이쿼리 .load() 사용  /auction/auctionDetail URL에서 .commentList 클래스를 가진 요소를
				      	가져와서 .commentScroll 에 로드 이 코드에서는 URL로 요청을 보내고, 가져온 내용을
				      	.commentScroll 요소에 적용하는 역할

						2 .aucSeq 값을 유지하면서 새로고침하려면, .load() 메서드를 호출할 때 aucSeq 값을 URL에 포함하여
						서버로 보낸다.

						3.
						let aucSeq = $("#aucSeq").val();

						$('.commentScroll').load(`/auction/auctionDetail?aucSeq=${aucSeq} .commentList`);
						서버에 aucSeq 값을 전달하고, 새로 고침된 댓글 리스트에서도 aucSeq 값을 사용할 수 있다. ${aucSeq}에 JavaSc
						ript 변수 aucSeq의 값을 URL에집어넣는 새로 고침된 페이지에서 aucSeq 값을 사용가능 
				      */
				      
				}
				else if(response.code == 400){
					Swal.fire('값이 없습니다.', '', 'warning');
				}
				else if(response.code == 404){
					Swal.fire('로그인 하세요.', '', 'warning');
				}
				else if(response.code == 500){
					Swal.fire('댓글 작성을 실패하였습니다.', '', 'warning');
				}
				else{
					Swal.fire('댓글 작성 중 오류 발생.', '', 'warning');	
				}
			},
			error:function(xhr, status, error){
				icia.common.error(error);
			}
			
		});
	});	

});
/* Sweetalert 수정 끝 */
</script>
</head>
<body>
	<%@ include file="/WEB-INF/views/include/navigation.jsp"%>
	<!-- Single-tv-Shows -->
	<section class="position-relative gen-section-padding-3">
		<div class="tv-single-background">
			<img src="/resources/upload/vote/${vrDetail.vrSeq}.png" alt="stream-lab-image" style="height: 700px;">
		</div>
		<div class="container">
			<div class="row">
				<div class="col-lg-12">
					<div class="gen-tv-show-wrapper style-1">
					<i class="fa fa-plus" id="btnList" onclick="fn_list()" style="color: #ffffff; float:right; margin-right:20px; transform: rotate(45deg); cursor:pointer;"></i>
						<!-- 경매 작품 1개 시작 -->
						<div class="gen-tv-show-top">
							<div class="row">
								<div class="col-lg-6">
									<div class="gentech-tv-show-img-holder">
										<img src="/resources/upload/vote/${vrDetail.vrSeq}.png"
											alt="stream-lab-image">
									</div>
								</div>
								<div class="col-lg-6 align-self-center">
									<div class="gen-single-tv-show-info">
										<h2 class="gen-title">${vrDetail.vrTitle}</h2>
										<div class="gen-single-meta-holder">
											<ul>
												<li>${vrDetail.userName}</li>
												<c:choose>
													<c:when test="${vrDetail.categoryNo == 01}">
														<li><a href="#"><span>미술</span></a></li>
													</c:when>
													<c:when test="${vrDetail.categoryNo == 02}">
														<li><a href="#"><span>사진</span></a></li>
													</c:when>
													<c:when test="${vrDetail.categoryNo == 03}">
														<li><a href="#"><span>도예</span></a></li>
													</c:when>
												</c:choose>
											</ul>
										</div>
										<p>${vrDetail.vrContent}</p>

										<form name="aucCurForm" action="POST">
											<c:choose>
												<c:when test="${vrDetail.aucStatus == 'Y'}">
													<div class="row form-group">
														<div class="col-md-5">
															<input type="text" placeholder="금액입력" id="aucCurPrice"
																name="aucCurPrice" onkeyup="inputNumberFormat(this)"><br>
															<br>
															<div style="font-size: 17px; color: #007bff !important; font-weight: bold;">
																*시작가: 
																<fmt:formatNumber type="number" maxFractionDigits="3" value="${vrDetail.vrStartPrice}" />원
															</div>
														</div>
														<div class="col-md-7">
															<input type="button" onclick="isAucCurPrice()" value="입찰하기" /><br> 
															<input type="hidden" name="userId" id="userId" value="${vrDetail.userId}" />
															<input type="hidden" id="aucSeq" name="aucSeq" value="${aucSeq}" /> 
															<input type="hidden" id="aucCurPrice" name="aucCurPrice" value="${aucCurPrice}" />
														</div>
													</div>
												</c:when>
												<c:when test="${vrDetail.aucStatus == 'N'}">
													<span class="text"><font color="#BD2A2E">
													<font size="4"><strong>종료된 경매 입니다.</strong></font></font></span>
												</c:when>
												<c:otherwise>
													<span class="text"><font color="#BD2A2E"><font
															size="4"><strong>진행이 예정된 경매 입니다.</strong></font></font></span>
												</c:otherwise>
											</c:choose>
										</form>
									</div>
								</div>
							</div>
						</div>
						<!-- 경매 작품 1개 끝 -->

						<div class="gen-section-padding-3">
							<div class="container container-2">

								<!-- 카테고리 시작 -->
								<div class="gen-season-holder">
									<ul class="nav">
										<li class="nav-item"><a class="nav-link active show" data-toggle="tab" href="#all">전체</a></li>
										<li class="nav-item"><a class="nav-link" data-toggle="tab" href="#aucCur">입찰가 내역</a></li>
										<li class="nav-item"><a class="nav-link" data-toggle="tab" href="#comment">댓글</a></li>
									</ul>
								</div>
								<!-- 카테고리 시작 -->

								<!-- 입찰가 내역 시작 -->
								<div class="gen-comparison-table table-style-1 table-responsive">
									<h6>입찰가 내역</h6>
									<div id="aucCur">
										<table class="table table-striped table-bordered">
											<thead>
												<tr>
													<th>
														<div class="cell-inner">
															<span>입찰 시간</span>
														</div>
														<div class="cell-tag">
															<span></span>
														</div>
													</th>
													<th>
														<div class="cell-inner">
															<span>닉네임</span>
														</div>
														<div class="cell-tag">
															<span></span>
														</div>
													</th>
													<th>
														<div class="cell-inner">
															<span>입찰 금액</span>
														</div>
														<div class="cell-tag">
															<span></span>
														</div>
													</th>
												</tr>
											</thead>
											<tbody>

												<c:forEach var="aucCur" items="${aucCur}" varStatus="status">

													<tr>
														<td>
															<div class=“cell-inner”>
																<span>${aucCur.aucCurBuyTime}</span>
															</div>
														</td>
														<td>
															<div class="cell-inner">
																<span>${aucCur.userNick}</span>
															</div>
														</td>
														<td>
															<div class="cell-inner">
																<span>
																<fmt:formatNumber type="number" maxFractionDigits="3"
																	value="${aucCur.aucCurPrice}" />
																</span>
															</div>
														</td>
													</tr>

												</c:forEach>

											</tbody>
										</table>
									</div>
								</div>
								<!-- 입찰가 내역 끝 -->

								<!-- 댓글 시작 -->
								<div class="my-3 p-3 bg-body rounded shadow-sm">
									<div id="comment">
										<h6>댓글</h6>
									</div>
									<div class="row form-group">
										<div class="col-md-11">
											<input type="text" id="cmtContent"
												placeholder="댓글을 작성해주세요...">
										</div>
										<div class="col-md-1">
											<input type="button" id="btnCmt" value="등록"><br>
										</div>
									</div>

									<div class="commentScroll"
										style="max-height: 500px; overflow-y: scroll;">
										<c:if test="${!empty list}">
											<c:forEach var="comment" items="${list}">
												<div class="commentList" id="commentList">
													<strong class="nickName">${comment.userNick}</strong> <span
														class="regDate">${comment.regDate}</span>
													<p class="cmtContent">${comment.cmtContent}</p>
												</div>
											</c:forEach>
										</c:if>
									</div>
									<!-- 댓글 끝 -->
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
	</section>
	<!-- Single-tv-Shows -->

	<%@ include file="/WEB-INF/views/include/footer.jsp"%>

</body>
</html>