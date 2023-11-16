<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>

<script>

	$(document).ready(function() {
		$("#btnCancel").on("click", function() {
			location.href = "/myPage/myPageMain";
		});

		$("#btnDrop").on("click", function() {
			fn_drop();
		});
	});

	function fn_drop() {
		$.ajax({
			type : "POST",
			url : "/user/dropProc",
			data : {
				userId : $("#userId").val()
			},
			datatype : "JSON",
			beforeSend : function(xhr) {
				xhr.setRequestHeader("AJAX", "true");
			},
			success : function(response) {

				if (!icia.common.isEmpty(response)) {
					icia.common.log(response);

					// var data = JSON.parse(obj);
					var code = icia.common.objectValue(response, "code", -500);

					if (code == 0) {
						Swal.fire({title: '회원 탈퇴가 완료되었습니다.', 
		                       icon: 'success'
			               }).then(function(){
			            	   location.href = "/";
			               })
					} else if (code == 404) {
						$("#userPwd").focus();
						Swal.fire("비밀번호를 입력하세요", '', 'info');
					} else if (code == 400) {
						$("#userPwd").focus();
						Swal.fire("비밀번호가 일치하지 않습니다.", '', 'info');
					} else {
						$("#userPwd").focus();
						Swal.fire("오류가 발생하였습니다.", '', 'info');
					}

				} else {
					Swal.fire("오류가 발생하였습니다.", '', 'info');
				}
			},
			complete : function(data) {
				// 응답이 종료되면 실행, 잘 사용하지않는다
				icia.common.log(data);
			},
			error : function(xhr, status, error) {
				icia.common.error(error);
			}
		});
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
                            <h1>회원탈퇴</h1>
                        </div>
                        <div class="gen-breadcrumb-container">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="index.html"><i
                                            class="fas fa-home mr-2"></i>홈</a></li>
                                <li class="breadcrumb-item active">회원탈퇴</li>
                            </ol>
                        </div>
                    </nav>
                </div>
            </div>
        </div>
    </div>
    <!-- breadcrumb -->


    <!-- Register -->
    <section class="gen-section-padding-3 gen-library">
        <div class="container">
            <div class="row">
                <div class="col-lg-12">
                    <h4>정말 탈퇴하시겠어요?</h4><br>
                    <p>탈퇴 버튼 선택 시, 계정은 삭제되며 복구되지 않습니다.</p>
                    <p>비밀번호 확인 후 탈퇴가 진행됩니다.</p>
                </div>
                
                
                <br><br><br><br>
                
                <div class="col-lg-0">
                   <div class="form-button">
                      <input type="button" name="btnCancel" id="btnCancel" value="취소" />
                      <br>
                   </div>
                </div>
                <div class="col-lg-1">
                   <div class="form-button">
                      <input type="button" name="btnDrop" id="btnDrop"  value="탈퇴" style="background:gray"/>
                   </div>
                   <input type="hidden" id="userId" name="userId" value="${user2.userId }" />
                </div>
            </div>
        </div>
    </section>
    <!-- Register --> 
<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>