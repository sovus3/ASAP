<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
	<%@ include file="/WEB-INF/views/include/head.jsp"%>
<style>
</style>

<script>
var idFlag = false;
var nickFlag = false;

$(document).ready(function() {
	var empCheck = /\s/gi;
	var IdCheck = /^[a-zA-Z0-9]{4,16}$/;
	var emailCheck = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
	var pwdCheck = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{4,20}$/;
	var phoneCheck = /^(010|011|016|017|018|019)[0-9]{3,4}[0-9]{4}$/;	
	var idFlag = false;
	var idFlag = false;
	
	$("#userId2").focus();
	
	$("#isId").on("click", function(){
		idFlag = true;
		
		if($.trim($("#userId2").val()).length <= 0){
			$("#userId2").val("");
			$("#userId2").focus();
			Swal.fire("아이디를 입력하세요.", '', 'warning');
			return;
		}
				
		if(empCheck.test($("#userId2").val())){
			$("#userId2").val("");
			$("#userId2").focus();
			Swal.fire("아이디는 공백없이 입력하세요.", '', 'warning');
			return;
		}
				
		if(!IdCheck.test($("#userId2").val())){
			$("#userId2").val("");
			$("#userId2").focus();
			Swal.fire("아이디 4~16자, 영대소문자, 숫자만 입력이 가능합니다.", '', 'warning');
			return;
		}
			
		$.ajax({
			type: "POST",
			url: "/user/idCheck",
			data: {
				userId: $("#userId2").val()
			},
			datatype:"JSON",
			beforeSend:function(xhr){
				xhr.setRequestHeader("AJAX", "true");//서버에 보내기 전에 호추로디는 함수. request헤더에 ajax통신에 관련한걸 담아서 보내라는 의미.
			},
			success:function(response){
				if(response.code == 1){
					$("#userId2").focus();
					Swal.fire("사용 가능한 아이디 입니다.", '', 'warning');
					idFlag = true;
				}
				else if(response.code == 100){
					$("#userId2").val("");
					$("#userId2").focus();
					Swal.fire("중복된 아이디 입니다.", '', 'warning');
					idFlag = false;
				}
				else if(response.code == 400){
					$("#userId2").focus();
					Swal.fire("파라미터 값이 올바르지 않습니다.", '', 'warning');
				}
				else{
					$("#userId2").focus();
					Swal.fire("기타 오류 발생", '', 'warning');
				}
			},
			error:function(xhr, status, error){
			    icia.common.error(error);
			}
		});	
	});
	
	$("#isNick").on("click", function(){
		nickFlag = true;
		
		if($.trim($("#userNick").val()).length <= 0){
			$("#userNick").val("");
			$("#userNick").focus();
			Swal.fire("닉네임을 입력하세요.", '', 'info');
			return;
		}
			
		if(empCheck.test($("#userNick").val())){
			$("#userNick").val("");
			$("#userNick").focus();
			Swal.fire("닉네임은 공백없이 입력하세요.", '', 'info');
			return;
		}
		
		$.ajax({
			type: "POST",
			url: "/user/nickCheck",
			data: {
				userNick: $("#userNick").val()
			},
			datatype:"JSON",
			beforeSend:function(xhr){
				xhr.setRequestHeader("AJAX", "true");
			},
			success:function(response){
				if(response.code == 1){
					$("#userNick").focus();
					Swal.fire("사용 가능한 닉네임 입니다.", '', 'warning');
					nickFlag = true;
				}
				else if(response.code == 100){
					$("#userNick").val("");
					$("#userNick").focus();
					Swal.fire("중복된 닉네임 입니다.", '', 'warning');
					nickFlag = false;
				}
				else if(response.code == 400){
					$("#userNick").focus();
					Swal.fire("파라미터 값이 올바르지 않습니다.", '', 'warning');
				}
				else{
					$("#userNick").focus();
					Swal.fire("기타 오류 발생", '', 'warning');
				}
			},
			error:function(xhr, status, error){
			    icia.common.error(error);
			}
		});
	});
	
	$("#btnReg").on("click", function() {
		
		if($.trim($("#userId2").val()).length <= 0){
			$("#userId2").val("");
			$("#userId2").focus();
			Swal.fire("아이디를 입력하세요.", '', 'info');
			return;
		}
				
		if(empCheck.test($("#userId2").val())){
			$("#userId2").val("");
			$("#userId2").focus();
			Swal.fire("아이디는 공백없이 입력하세요.", '', 'info');
			return;
		}
				
		if(!IdCheck.test($("#userId2").val())){
			$("#userId2").val("");
			$("#userId2").focus();
			Swal.fire("아이디 4~16자, 영대소문자, 숫자만 입력이 가능합니다.", '', 'info');
			return;
		}
	
		if(idFlag == false){
			$("#userId2").focus();
			Swal.fire("아이디의 중복을 확인해주세요.", '', 'info');
			return;
		}
		
		if($.trim($("#userEmail").val()).length <= 0){
			$("#userEmail").val("");
			$("#userEmail").focus();
			Swal.fire("이메일을 입력하세요.", '', 'info');
			return;
		}
			
		if(empCheck.test($("#userEmail").val())){
			$("#userEmail").val("");
			$("#userEmail").focus();
			Swal.fire("이메일은 공백없이 입력하세요.", '', 'info');
			return;
		}
			
		if(!emailCheck.test($("#userEmail").val())){
			$("#userEmail").val("");
			$("#userEmail").focus();
			Swal.fire("이메일 형식에 맞게 입력하세요.", '', 'info');
			return;
		}
		
		if($.trim($("#userName").val()).length <= 0){
			$("#userName").val("");
			$("#userName").focus();
			Swal.fire("이름을 입력하세요.", '', 'info');
			return;
		}
			
		if(empCheck.test($("#userName").val())){
			$("#userName").val("");
			$("#userName").focus();
			Swal.fire("이름은 공백없이 입력하세요.", '', 'info');
			return;
		}
		
		if($.trim($("#userNick").val()).length <= 0){
			$("#userNick").val("");
			$("#userNick").focus();
			Swal.fire("닉네임을 입력하세요.", '', 'info');
			return;
		}
			
		if(empCheck.test($("#userNick").val())){
			$("#userNick").val("");
			$("#userNick").focus();
			Swal.fire("닉네임은 공백없이 입력하세요.", '', 'info');
			return;
		}
		
		if(nickFlag == false){
			$("#userId").focus();
			Swal.fire("닉네임의 중복을 확인해주세요.", '', 'info');
			return;
		}
		
		if($.trim($("#userPwd1").val()).length <= 0){
			$("#userPwd1").val("");
			$("#userPwd1").focus();
			Swal.fire("비밀번호를 입력하세요.", '', 'info');
			return;
		}
			
		if(empCheck.test($("#userPwd1").val())){
			$("#userPwd1").val("");
			$("#userPwd1").focus();
			Swal.fire("비밀번호는 공백없이 입력하세요.", '', 'info');
			return;
		}
			
		if(!pwdCheck.test($("#userPwd1").val())){
			$("#userPwd1").val("");
			$("#userPwd1").focus();
			Swal.fire("비밀번호는 특수문자, 문자, 숫자 포함 형태의 4~20자리 이내로 입력하세요.", '', 'info');
			return;
		}
		
		if($("#userPwd1").val() != $("#userPwd2").val()){
			$("#userPwd2").val("");
			$("#userPwd2").focus();
			Swal.fire("비밀번호가 일치하지 않습니다.", '', 'info');
			return;
		}
		
		$("#userPwd").val($("#userPwd1").val());
		
		if($.trim($("#userPhone").val()).length <= 0){
			$("#userPhone").val("");
			$("#userPhone").focus();
			Swal.fire("전화번호를 입력하세요.", '', 'info');
			return;
		}

		if(empCheck.test($("#userPhone").val())){
			$("#userPhone").val("");
			$("#userPhone").focus();
			Swal.fire('전화번호는 공백없이 입력하세요.', '', 'warning');
			return;
		}
		
		if(!phoneCheck.test($("#userPhone").val())){
			$("#userPhone").val("");
			$("#userPhone").focus();
			Swal.fire('"-"없이 숫자만 입력하세요.', '', 'warning');
			return;
		}

		$.ajax({
			type: "POST",
			url: "/user/userRegProc",
			data: {
				 userId: $("#userId2").val(),		
				 userPwd: $("#userPwd").val(),
				 userNick: $("#userNick").val(), 
				 userName: $("#userName").val(),
				 userPhone: $("#userPhone").val(),	
				 postCode: $("#postcode").val(),
				 address: $("#address").val(), 
				 userEmail: $("#userEmail").val() 
			},
			datatype:"JSON",
			beforeSend:function(xhr){
				xhr.setRequestHeader("AJAX", "true");//서버에 보내기 전에 호추로디는 함수. request헤더에 ajax통신에 관련한걸 담아서 보내라는 의미.
			},
			success:function(result){
				if(result.code == 1){
					Swal.fire({title: '회원가입이 완료됐습니다.', 
	                       icon: 'success'
		               }).then(function(){
		            	   location.href = "/user/logIn";
		               })
				}
				else if(result.code == 404){
					Swal.fire({title: '회원가입 중 오류가 발생했습니다.', 
	                       icon: 'warning'
		               }).then(function(){
		            	   location.href = "redirect:/";
		               })
				}
				else if(result.code == 400){
					Swal.fire({title: '파라미터 값이 부족합니다.', 
	                       icon: 'warning'
		               }).then(function(){
		            	   location.href = "redirect:/";
		               })
				}
				else{
					Swal.fire({title: '회원가입 중 기타 오류가 발생했습니다.', 
	                       icon: 'warning'
		               }).then(function(){
		            	   location.href = "redirect:/";
		               })
				}
			},
			error:function(xhr, status, error){
			    icia.common.error(error);
			}
		});
		
	});

});

//도로명 주소
function execPostcode() {
	new daum.Postcode({
		oncomplete: function(data) {
          // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

          // 각 주소의 노출 규칙에 따라 주소를 조합한다.
          // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
          var addr = ''; // 주소 변수
          var extraAddr = ''; // 법정동명 조합 주소 변수

          //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
          if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
              addr = data.roadAddress;
          } 
          else { // 사용자가 지번 주소를 선택했을 경우(J)
              addr = data.jibunAddress;
          }

          // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
          if(data.userSelectedType === 'R'){
              // 법정동명이 있을 경우 추가한다. (법정리는 제외)
              // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
              if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                  extraAddr += data.bname;
              }
              // 건물명이 있고, 공동주택일 경우 추가한다.
              if(data.buildingName !== '' && data.apartment === 'Y'){
                  extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
              }
              // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
              if(extraAddr !== ''){
                  extraAddr = ' (' + extraAddr + ')';
              }
              if(addr != ''){
              	addr += extraAddr;
              }
          } 
          else {
              document.getElementById("sample6_extraAddress").value = '';
          }

          // 우편번호와 주소 정보를 해당 필드에 넣는다.
          document.getElementById('postcode').value = data.zonecode;
          document.getElementById("address").value = addr;

      }
  }).open();
}
</script>

</head>
<body>
	<%@ include file="/WEB-INF/views/include/navigation.jsp"%>
	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
		
	<!-- register -->
    <section class="position-relative pb-0">
        <div class="gen-register-page-background" style="background-image: url('/resources/images/background/back.png');">
        </div>
        <div class="container">
            <div class="row">
                <div class="col-lg-12">
                    <div class="text-center">
                        <form id="pms_register-form" name="form1" class="pms-form" method="POST">
                            <h4>회원가입</h4>
                            <input type="hidden" id="pmstkn" name="pmstkn" value="59b502f483"><input type="hidden" name="_wp_http_referer" value="/register/">
                               <ul class="pms-form-fields-wrapper pl-0">
                                <li class="pms-field pms-user-login-field">
                                    <label for="userId">아이디 *</label>
                                    <div class="row form-group">
	                                    <div class="col-md-8">
	                                    	<input type="text" id="userId2" name="userId2" value="" placeholder="영문/숫자 조합 (4~16자)">
	                                    </div>
	                                    <div class="col-md-4">
											<button class="gen-button gen-button-plat" type="button" id="isId" name="isId" style="background:gray">중복확인</button>
										</div>
									</div>
                                </li>
                                <li class="pms-field pms-user-email-field ">
                                    <label for="userEmail">이메일 *</label>
                                    <input type="text" id="userEmail" name="userEmail" value="">
                                </li>
                                <li class="pms-field pms-first-name-field ">
                                    <label for="userName">이름 *</label>
                                    <input type="text" id="userName" name="userName" value="">
                                </li>
                                <li class="pms-field pms-last-name-field ">
                                    <label for="userNick">닉네임 *</label>
                                    <div class="row form-group">
                                    	<div class="col-md-8">
                                    		<input type="text" id="userNick" name="userNick" value="">
                                    	</div>
                                    	<div class="col-md-4">
                                    		<button class="gen-button gen-button-plat" type="button" id="isNick" name="isNick" style="background:gray">중복확인</button>
                                    	</div> 
                                    </div>
                                </li>
                                <li class="pms-field pms-pass1-field">
                                    <label for="userPwd1">비밀번호 *</label>
                                    <input type="password" id="userPwd1" name="userPwd1" placeholder="영문/숫자/특수문자 모두 포함되는 조합 (4~20자)">
                                </li>
                                <li class="pms-field pms-pass2-field">
                                    <label for="userPwd2">비밀번호 확인 *</label>
                                    <input type="password" id="userPwd2" name="userPwd2" placeholder="확인을 위해 새 비밀번호를 다시 입력해주세요.">
                                </li>
                                <li class="pms-field pms-pass2-field">
                                    <label for="userPhone">전화번호</label>
                                    <input type="text" id="userPhone" name="userPhone" placeholder="'-'없이 숫자만 입력하세요.">
                                </li>
                                <li class="pms-field pms-pass2-field">
                                    <label for="">주소</label>
                                    <div class="row form-group">
	                                    <div class="col-md-8">
	                                    	<input type="text" id="postcode" placeholder="우편번호" readonly>
	                                    </div>
	                                    <div class="col-md-4">
											<input type="button" onclick="execPostcode()" value="우편번호 찾기"><br>
										</div>
									</div>
										<input type="text" id="address" placeholder="도로명 주소"><br>
                                </li>
                            </ul>
                            <span id="pms-submit-button-loading-placeholder-text" class="d-none">잠시 기다려주세요...</span>
                            <input type="button" id="btnReg" value="회원가입">
                            
                            <input type="hidden" id="userPwd" name="userPwd" value="" />
	                		<input type="hidden" id="userCk" name="userCk" value="" />
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- register -->
    	<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>