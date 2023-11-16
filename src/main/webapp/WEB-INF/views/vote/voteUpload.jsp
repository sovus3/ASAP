<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>

<style>
</style>

<script>
$(document).ready(function() {
	var date = new Date();

	var firstDay = new Date(date.getFullYear(), date.getMonth() + 1, 1);
	var lastDay = new Date(date.getFullYear(), date.getMonth() + 2, 0);

	var firstDayYear = firstDay.getFullYear();
	var firstDayMonth = ('0' + (firstDay.getMonth() + 1)).slice(-2);
	var firstDayDay = ('0' + firstDay.getDate()).slice(-2);

	var lastDayYear = lastDay.getFullYear();
	var lastDayMonth = ('0' + (lastDay.getMonth() + 1)).slice(-2);
	var lastDayDay = ('0' + lastDay.getDate()).slice(-2);

	document.getElementById("vrStartDate").value = firstDayYear + firstDayMonth + firstDayDay;
	document.getElementById("vrEndDate").value = lastDayYear + lastDayMonth + lastDayDay;
	
	var curDate = new Date();
    var year = curDate.getFullYear();
    var month = (curDate.getMonth() + 1).toString().padStart(2, '0'); // 문자열이 최소 2자리가 되도록 설정
    var day = curDate.getDate().toString().padStart(2, '0');

    var formatDate = year + month + day; // 20230901
    $("#vrTitle").focus();


                
	$("#btnVoteUpload").on("click", function() {

		$("#btnVoteUpload").prop("disabled", true);
			
		if ($.trim($("#vrTitle").val()).length <= 0) {
			$("#vrTitle").val("");
			$("#vrTitle").focus();
			$("#btnVoteUpload").prop("disabled", false);
			Swal.fire("작품명은 필수 입력사항입니다.", '', 'info');
			return;
		}
		
		if ($.trim($("#vrContent").val()).length <= 0) {
			$("#vrContent").val("");
			$("#vrContent").focus();
			$("#btnVoteUpload").prop("disabled", false);
			Swal.fire("작품 설명은 필수 입력사항입니다.", '', 'info');
			return;
		}
		
		if ($.trim($("#vrStartPrice").val()).length <= 0) {
			$("#vrStartPrice").val("");
			$("#vrStartPrice").focus();
			$("#btnVoteUpload").prop("disabled", false);
			Swal.fire("희망가를 입력하지 않을 시 '0원'으로 설정됩니다.", '', 'info');
			return;
		}
		
		var fileCheck = $("#vrFile").val()
		
		if (!fileCheck) {
			$("#btnVoteUpload").prop("disabled", false);
			Swal.fire("작품 사진을 첨부하세요.", '', 'info');
			return;
		}
		
		var form = $("#voteUploadForm")[0];
		var formData = new FormData(form);
		
		$.ajax({
			type : "POST",
			url : "/vote/voteUploadProc",
			enctype : "multipart/form-data",
			processData : false,
			contentType : false,
			data : formData,
			timeout : 60000,
			beforeSend : function(xhr) {
				xhr.setRequestHeader("AJAX", "true");
			},
			success : function(result) {
				if (result.code == 1) {
					Swal.fire({title: '신청이 완료됐습니다.', 
		                   icon: 'success'
		            }).then(function(){
		         	  location.href = "/";
		            })
				} else if (result.code == 0) {
					$("#btnVoteUpload").prop("disabled", false);
					$("#vrTitle").val();
					Swal.fire("작품 등록 중 오류가 발생했습니다.", '', 'warning');
				} else if (result.code == 400) {
					$("#btnVoteUpload").prop("disabled", false);
					$("#vrTitle").val();
					Swal.fire("파라미터가 부족합니다.", '', 'warning');
				}
			},
			error : function(error) {
				icia.common.error(error);
			}
		});

	});
             	
});
</script>

</head>
<body>
<%@ include file="/WEB-INF/views/include/navigation.jsp"%>
<!-- breadcrumb -->
    <div class="gen-breadcrumb" style="background-image: url('/resources/images/background/back.png');">
        <div class="container">
            <div class="row align-items-center" >
                <div class="col-lg-12">
                    <nav aria-label="breadcrumb">
                        <div class="gen-breadcrumb-title">
                            <h1>
                                투표 작품 신청하기
                            </h1>
                        </div>
                        <div class="gen-breadcrumb-container">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="index.html"><i
                                            class="fas fa-home mr-2"></i>홈</a></li>
                                <li class="breadcrumb-item active">투표 작품 신청하기</li>
                            </ol>
                        </div>
                    </nav>
                </div>
            </div>
        </div>
    </div>
    <!-- breadcrumb -->


    <!-- 투표 작품 신청 폼 -->
    <section class="gen-section-padding-3 gen-library">
        <div class="container">
            <div class="row" style="width:60% !important; margin:0 auto !important;">
                <div class="col-lg-12">
                    <form name="voteUploadForm" id="voteUploadForm" method="post" enctype="multipart/form-data">
                        <div class="gen-register-form">
                            <h2>작품 신청</h2>
                            
								<label>작품 카테고리 *</label>
	                            <select name="categoryNo" id="categoryNo" style="width:20%;">
			                        <option value="01">미술</option>
			                        <option value="02">사진</option>
			                        <option value="03">도예</option>
			                     </select><br><br>
                            
                            <label>작품명 *</label>
                            <input type="text" id="vrTitle" name="vrTitle" value="">
                            
                            <label>작가명 *</label>
                            <input type="text" id="userNick" name="userNick" value="">
                            
                            <label>작품 설명 *</label>
                            <textarea id="vrContent" name="vrContent" rows="6" cols="60" placeholder="작품 설명을 작성해주세요." style="resize: none;"></textarea><br><br><br><br>
                            
                            <label>희망가 *</label>
                            <input type="text" id="vrStartPrice" name="vrStartPrice" placeholder="희망가를 입력하지 않을 시 '0원'으로 설정됩니다.">
                            
                            <label>작품 사진 첨부 *</label>
                            <input type="file" id="vrFile" name="vrFile">
                            
                            <input type="hidden" id="vrStartDate" name="vrStartDate" value="">
							<input type="hidden" id="vrEndDate" name="vrEndDate" value="">
                        </div>
                    </form>
                    <div class="form-button">
                        <input type="button" id="btnVoteUpload" name="btnVoteUpload" value="신청하기" class="mb-0">
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- 투표 작품 신청 폼 -->
    	<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>