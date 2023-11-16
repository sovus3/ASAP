<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script>
//본 예제에서는 도로명 주소 표기 방식에 대한 법령에 따라, 내려오는 데이터를 조합하여 올바른 주소를 구성하는 방법을 설명합니다.
 function execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
	
                	
                // 도로명 주소의 노출 규칙에 따라 주소를 표시한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var userAddr = data.roadAddress; // 도로명 주소 변수
                var extraRoadAddr = ''; // 참고 항목 변수
					
              
                
                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraRoadAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if(data.buildingName !== '' && data.apartment === 'Y'){
                   extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if(extraRoadAddr !== ''){
                    extraRoadAddr = ' (' + extraRoadAddr + ')';
                }

                if(userAddr != '')
                {
                	userAddr += extraRoadAddr;
                }
                
                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('userPostcode').value = data.zonecode;
                document.getElementById("userAddr").value = userAddr;
        
                
                // 참고항목 문자열이 있을 경우 해당 필드에 넣는다.
                /*if(roadAddr !== ''){
                    document.getElementById("extraAddress").value = extraRoadAddr;
                } else {
                    document.getElementById("extraAddress").value = '';
                }*/

                var guideTextBox = document.getElementById("guide");
                // 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
                if(data.autoRoadAddress) {
                    var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
                    guideTextBox.innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';
                    guideTextBox.style.display = 'block';
                } 
                else if(data.autoJibunAddress) {
                    var expJibunAddr = data.autoJibunAddress;
                    guideTextBox.innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';
                    guideTextBox.style.display = 'block';
                } 
                else {
                    guideTextBox.innerHTML = '';
                    guideTextBox.style.display = 'none';
                }
            }
        }).open();
    }
</script>

<script>
$(document).ready(function() {
	
	$("#cancel").on("click", function(){
	      location.href = "/myPage/myPageMain"
	   });

	$("#btnUpdate").on("click", function() {		

		var emptCheck = /\s/g;		
		var pwdCheck = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{4,20}$/;
		var phoneCheck = /^(010|011|016|017|018|019)[0-9]{3,4}[0-9]{4}$/;			
		
		if($.trim($("#userPwd1").val()).length <= 0){
			$("#userPwd1").val("");
			$("#userPwd1").focus();
			Swal.fire('비밀번호를 입력하세요.', '', 'warning');
			return;
		}
		
		if(emptCheck.test($("#userPwd1").val())){
			$("#userPwd1").focus();
			Swal.fire('비밀번호는 공백없이 입력하세요', '', 'warning');
			return;
		}
		
		if(!pwdCheck.test($("#userPwd1").val())){
			$("#userPwd1").focus();
			Swal.fire('비밀번호는 영문 대소문자와 숫자로 4~16자리 입니다.', '', 'warning');
			return;
		}
		
		if($("#userPwd1").val() != $("#userPwd2").val()){
			$("#userPwd2").focus();
			Swal.fire('비밀번호가 일치하지 않습니다.', '', 'warning');
			return;
		}
		
		if($.trim($("#userName").val()).length <= 0){
			$("#userName").val("");
			$("#userName").focus();
			Swal.fire('이름을 입력하세요.', '', 'warning');
			return;
		}
	
		if($.trim($("#userPhone").val()).length <= 0){
			$("#userPhone").val("");
			$("#userPhone").focus();
			Swal.fire('전화번호를 입력하세요.', '', 'warning');
			return;
		}
		
		if(emptCheck.test($("#userPhone").val())){
			$("#userPhone").val("");
			$("#userPhone").focus();
			Swal.fire('전화번호는 공백없이 입력하세요.', '', 'warning');
			return;
		}
		
		if(!phoneCheck.test($("#userPhone").val())){
			$("#userPhone").val("");
			$("#userPhone").focus();
			Swal.fire('전화번호는 "-"없이 숫자만 입력하세요.', '', 'warning');
			return;
		}
		
		if($.trim($("#userEmail").val()).length <= 0){
			$("#userEmail").val("");
			$("#userEmail").focus();
			Swal.fire('이메일을 입력하세요.', '', 'warning');
			return;
		}
		
		if(!fn_validateEmail($("#userEmail").val())){
			$("#userEmail").focus();
			Swal.fire('이메일 형식이 올바르지 않습니다.', '', 'warning');
			return;
		}
		
		if($.trim($("#userAddr").val()).length <= 0){
			$("#userAddr").val("");
			$("#userAddr").focus();
			Swal.fire('주소를 입력하세요.', '', 'warning');
			return;
		}	
	
		$("#userPwd").val($("#userPwd1").val());
		
		$.ajax({
			type:"POST",
			url:"/myPage/updateProc",
			data:{
				userPwd:$("#userPwd").val(),
				userName:$("#userName").val(),
				userPhone:$("#userPhone").val(),
				userAddr:$("#userAddr").val(),
				userEmail:$("#userEmail").val(),
				userPostcode:$("#userPostcode").val()
			},
			datatype:"JSON",
			beforeSend:function(xhr){
				xhr.setRequestHeader("AJAX", "true");
			},
			success:function(response){
				if(response.code == 0){
					Swal.fire({title: '회원 정보가 수정되었습니다.', 
	                       		icon: 'success'
	               	}).then(function(){
	            	   location.href = "/myPage/userUpdate";
	               	})
				}
				else if(response.code == 400){
					Swal.fire('파라미터 값이 올바르지 않습니다.', '', 'warning');
					$("#userPwd1").focus();
				}
				else if(response.code == 404){
					Swal.fire({title: '회원 정보가 존재하지 않습니다.', 
	                       		icon: 'warning'
	               	}).then(function(){
	            	   location.href = "/";
	               	})
				}
				else if(response.code == 500){
					Swal.fire('회원정보 수정 중 오류가 발생하였습니다.', '', 'warning');
					$("#userPwd1").focus();
				}
				else{
					Swal.fire('회원정보 수정 중 오류 발생', '', 'warning');
				}
			},
			error:function(xhr, status, error){
				icia.common.error(error);
			}
		});
	});
});

function fn_validateEmail(value){
	var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;	
	return emailReg.test(value);
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
						    <h1>
						        마이페이지
						    </h1>
						</div>
						<div class="gen-breadcrumb-container">
							<ol class="breadcrumb">
								<li class="breadcrumb-item">
									<a href="index.html">
										<i class="fas fa-home mr-2"></i>홈
									</a>
								</li>
								<li class="breadcrumb-item active">마이페이지</li>
							</ol>
						</div>
					</nav>
				</div>
			</div>
		</div>
    </div>
    <!-- breadcrumb -->
	
	<!-- Blog-left-Sidebar -->
	<section class="gen-section-padding-3">
		<div class="container">
			<div class="row">
			
				<!-- 사이드바 시작 -->
					<div class="col-xl-3 col-md-12 order-2 order-xl-1 mt-4 mt-xl-0" style="width:20%;">
						<div class="widget widget_recent_entries">
							<h2 class="widget-title"><a href="/myPage/myPageMain">마이페이지</a></h2>
							<ul>
								<li><a href="/myPage/userUpdate">회원정보수정</a></li>
								<li><a href="/myPage/myPagePay">결제내역</a></li>	
								<li><a href="/myPage/myPageVote">투표내역</a></li>	
								<li><a href="/myPage/myPageAucCur">입찰내역</a></li>
								<li><a href="/myPage/myPageQna">문의내역</a></li>
								<c:if test="${user.userCode == 'A'}">
								<li><a href="/myPage/myPageVoteUpload">투표작품신청내역</a></li>
								<li><a href="/myPage/artAucResult">경매결과내역</a></li>
								</c:if>
							</ul>
						</div>
					</div>
	            <!-- 사이드바 끝 -->
				
				<!-- 회원정보수정 시작 -->
				<div class="col-xl-9 col-md-12 order-1 order-xl-2">
					<div class="gen-blog gen-blog-col-1">
						<div class="row">
							<div class="col-lg-12">
								<form>
									<div class="gen-login-form">
										<h2>${user.userId}님 안녕하세요:)</h2><br>
							
										<label>비밀번호 *</label>
										<input type="password" name="userPwd1" id="userPwd1" value="${user.userPwd}">
										<br><br>
										
										<label>비밀번호 확인 *</label>
										<input type="password" name="userPwd2" id="userPwd2" value="${user.userPwd}">
										<br><br>
										 
										<label>이름 *</label>
										<input type="text" name="userName" id="userName" value="${user.userName}">
										<br><br>
										
										<label>이메일 *</label>
										<input type="text" name="userEmail" id="userEmail" value="${user.userEmail}">
										<br><br>
										
										<label>전화번호 *</label>
										<input type="text" name="userPhone" id="userPhone" value="${user.userPhone}">
										<br><br>
									
										<label>주소 *</label>
										<div class="row form-group">
											<div class="col-md-8">
												<input type="text" id="userPostcode" value="${user.userPostcode}">
											</div>
										
											<div class="col-md-4">
												<input type="button" onclick="execDaumPostcode()" value="우편번호 찾기">
											</div>
										</div>
									                     
										<input type="text" id="userAddr" value="${user.userAddr}">
										<span id="guide" style="color:#999;display:none"></span>
										<br><br>
							
										<div class="form-button" style="margin-top:20px !important;">
										    <input type="button" name="cancel" id="cancel" class="mb-0 mr-1" style="background:gray" value="취소" >
										    <input type="button" name="btnUpdate" id="btnUpdate" class="mb-0" value="수정">
										</div>
										<br><br>
										<div class="drop mt-3">
											<a href="/user/userDrop" style="color:gray; text-decoration : underline;">회원탈퇴</a>
									    </div>
									    
									    <input type="hidden" name="userPwd" id="userPwd" value="">
									</div>
								</form>
							</div>
						</div>
					</div>
				</div>
				<!-- 회원정보수정 끝 -->
			</div>
		</div>
	</section>
	<!-- Blog-left-Sidebar -->
	
<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>