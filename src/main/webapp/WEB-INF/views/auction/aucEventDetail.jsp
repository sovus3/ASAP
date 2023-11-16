<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<style>
.eventMainFrontImg {
	width: 70%;
	margin: 0 auto;
}

.eventMain4Img {
	width: 85%;
	margin: 0 auto;
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
	   location.href = "/auction/aucEventList";
	}

/* Sweetalert 수정 시작 */
function isAeCurPrice() {

	var aeStartPrice = ${aucEvent.aeStartPrice};
	var aeCurPrice = $("#aeCurPrice").val().replace(",", "");

		if ($.trim($("#aeCurPrice").val()).length <= 0) {
			$("#aeCurPrice").focus();
			Swal.fire('금액을 입력하세요.' ,'' ,'warning');	
			return;
		}
		if (aeCurPrice < aeStartPrice) {
			$("#aeCurPrice").val("");
			$("#aeCurPrice").focus();
			Swal.fire('시작가 미만의 금액은 입력할 수 없습니다.', '', 'error');
			return;
		}

		Swal.fire({
			 title: '입찰을 진행하시겠습니까?',
		        icon: 'warning',
		        showCancelButton: true,
		        confirmButtonColor: '#3085d6',
		        cancelButtonColor: '#d33',
		        confirmButtonText: '확인',
		        cancelButtonText: '취소'

		}).then((result) => {
			if(result.isConfirmed) {
		
			$.ajax({
					type : "POST",
					url : "/auction/aeCurProc",
					data : {
							aeSeq : $("#aeSeq").val(),
							aeCurPrice: aeCurPrice,
							},
					datatype : "JSON",
					beforeSend : function(xhr) {
						xhr.setRequestHeader("AJAX", "true");
					},
					success : function(result) {
							if (result.code == 1) {
								Swal.fire({
									title : '입찰에 성공했습니다.',
									icon : 'success'
								}).then(function() {
									document.aucEventForm.aeSeq.value = $("#aeSeq").val();
									document.aucEventForm.action = "/auction/aucEventDetail";
									document.aucEventForm.submit();
								})
							} else if (result.code == 0) {
								Swal.fire({
									title : '포인트가 부족합니다.',
									icon : 'warning'
								}).then(function() {
									location.href = "/user/rechargePoints"
								})
							} else if (result.code == 100) {
								$("#aeCurPrice").val("");
								$("#aeCurPrice").focus();
								Swal.fire('입찰 진행 중 오류가 발생했습니다.', '', 'warning'); //
							} else if (result.code == 400) {
								Swal.fire({
									title : '사용자가 아닙니다.',
									icon : 'warning'
								}).then(function() {
									location.href = "/";//
								})
							} else if (result.code == 404) {								
								$("#aeCurPrice").val("");
								$("#aeCurPrice").focus();
								Swal.fire('파라미터 값이 부족합니다', '', 'warning');
							} else {
								Swal.fire({
									title : '기타 오류가 발생했습니다.', //
									icon : 'warning'
								}).then(function() {
									location.href = "/auction/aucEventDetail";
								})
							}
						},
						error : function(error) {
							icia.com.error(error);
						}
					});

		}
	
	})

}
/* Sweetalert 수정 끝 */
</script>

</head>
<body>
	<%@ include file="/WEB-INF/views/include/navigation.jsp"%>
	<!-- Single-tv-Shows -->
	<section class="position-relative gen-section-padding-3">
		<div class="container">
			<div class="row">
				<div class="col-lg-12">
					<div class="gen-tv-show-wrapper style-1">
					<i class="fa fa-plus" id="btnList" onclick="fn_list()" style="color: #ffffff; float:right; margin-right:20px; transform: rotate(45deg); cursor:pointer;"></i>
						<!-- 경매 작품 1개 시작 -->
						<div class="gen-tv-show-top">
							<div class="row">
								<div class="col-lg-6">
									<c:choose>
										<c:when test="${aucEvent.aeSeq == 4}">
											<div class="gentech-tv-show-img-holder eventMain4Img">
												<img src="/resources/upload/eventmain/${aucEvent.aeSeq}.png"
													alt="stream-lab-image">
											</div>
										</c:when>
										<c:otherwise>
											<div class="gentech-tv-show-img-holder eventMainFrontImg">
												<img src="/resources/upload/eventmain/${aucEvent.aeSeq}.png"
													alt="stream-lab-image">
											</div>
										</c:otherwise>
									</c:choose>

								</div>
								<div class="col-lg-6 align-self-center">
									<div class="gen-single-tv-show-info">
										<h2 class="gen-title">${aucEvent.aeProductTitle}</h2>
										<br> <br>
										<c:choose>
											<c:when test="${aucEvent.status == 'Y'}">
												<div class="row form-group">
													<div class="col-md-5">
														<input type="text" placeholder="금액입력" id="aeCurPrice"
															name="aeCurPrice" onkeyup="inputNumberFormat(this)"><br> <br>
														<div
															style="font-size: 17px; color: #007bff !important; font-weight: bold;">
															*시작가: &#8361;
															<fmt:formatNumber type="number" maxFractionDigits="3"
																value="${aucEvent.aeStartPrice}" />
														</div>
													</div>
													<div class="col-md-7">
														<input type="button" onclick="isAeCurPrice()" value="입찰하기" /><br>
													</div>
												</div>
											</c:when>
											<c:otherwise>
												<span class="text" style="font-size: 25px; color: #007bff !important; font-weight: bold;">
													진행 예정 경매입니다.
												</span>
											</c:otherwise>
										</c:choose>
									</div>
								</div>
							</div>
						</div>
						<div class="tab-content" id="eventDetailImg">
							<img src="/resources/upload/eventdetail/${aucEvent.aeSeq}.png"
								alt="stream-lab-image">
						</div>
					</div>
				</div>
			</div>
		</div>
		</div>
		</div>
	</section>
	<!-- Single-tv-Shows -->

	<form name="aucEventForm" id="aucEventForm" method="post">
		<input type="hidden" id="aeSeq" name="aeSeq" value="${aucEvent.aeSeq}" />
	</form>

	<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>