<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<style>
select, select.form-control {
	height: 40px !important;
	line-height: normal !important;
}
</style>

<script>
$(document).ready(function(){
	
   $("#userId2").focus();
   //일반유저 로그인
   $("#btnLogin1").on("click", function(){
      if($.trim($("#userId2").val()).length <= 0){
         $("#userId2").focus();
         Swal.fire("아이디를 입력하세요.", '', 'info');
         return;
      }
      
      if($.trim($("#userPwd").val()).length <= 0){
         $("#userPwd").focus();
         Swal.fire("비밀번호를 입력하세요.", '', 'info');
         return;
      }
      $.ajax({
	         type:"POST",
	         url: "/user/loginProc",
	         data:{
	            userId:$("#userId2").val(),
	            userPwd:$("#userPwd").val()
	         },
	         datatype:"JSON",
	         beforeSend:function(xhr){
	            xhr.setRequestHeader("AJAX", "true");
	         },
	         success:function(response){
	            //응답이 있음
	            if(!icia.common.isEmpty(response)){
	               //var data = JSON.parse(response);
	               var code = icia.common.objectValue(response, "code", -500);
	               
	               if(code == 0){
	            	   Swal.fire({title: '로그인 성공', 
	                       icon: 'success'
		               }).then(function(){
		            	   location.href = "/"; //추후 변경
		               })
	               }
	               else{
	                  //비번 다름
	                  if(code == -1){
		                 $("#userPwd").focus();
	                     Swal.fire("비밀번호가 올바르지 않습니다.", '', 'info');
	                  }
	                  else if(code == -2){
		                 $("#userId2").focus();
	                     Swal.fire("탈퇴한 회원입니다.", '', 'info');
	                  }
	                  else if(code == 404){
		                 $("#userId2").focus();
	                     Swal.fire("아이디와 일치하는 사용자 정보가 없습니다.", '', 'info');
	                  }
	                  else if(code == 400){
		                 $("#userId").focus();
	                     Swal.fire("파라미터 값이 올바르지 않습니다.", '', 'info');
	                  }
	                  else{
		                 $("#userId2").focus();
	                     Swal.fire("오류가 발생하였습니다.", '', 'info');
	                  }
	               }
	            }
	            //응답이 비어있음
	            else{
		           $("#userId2").focus();
	               Swal.fire("오류가 발생하였습니다.", '', 'info');
	            }
	         },
	         complete:function(data){
	            //응답이 종료되면 실행 잘 사용하지 않음
	            icia.common.log(data);
	         },
	         error:function(xhr, status, error){
	            icia.common.error(error);
	         }
	         
	      });
   });
	  //관리자 로그인
      $("#btnLogin2").on("click", function(){
          if($.trim($("#admId").val()).length <= 0){
             $("#admId").focus();
             Swal.fire("아이디를 입력하세요.", '', 'info');
             return;
          }
          
          if($.trim($("#admPwd").val()).length <= 0){
        	 $("#admPwd").focus();
             Swal.fire("비밀번호를 입력하세요.", '', 'info');
             return;
          }
          $.ajax({
    	         type:"POST",
    	         url: "/admin/adminProc",//url 만들기
    	         data:{
    	            admId:$("#admId").val(),
    	            admPwd:$("#admPwd").val()
    	         },
    	         datatype:"JSON",
    	         beforeSend:function(xhr){
    	            xhr.setRequestHeader("AJAX", "true");
    	         },
    	         success:function(response){
    	            //응답이 있음
    	            if(!icia.common.isEmpty(response)){
    	               //var data = JSON.parse(response);
    	               var code = icia.common.objectValue(response, "code", -500);
    	               
    	               if(code == 0){
    	            	   Swal.fire({title: '로그인 성공', 
    	                       icon: 'success'
    		               }).then(function(){
    		            	   location.href = "http://manager2.co.kr:8088/"; //추후 변경
    		               })
    	               }
    	               else{
    	                  //비번 다름
    	                  if(code == -1){
    	                	 $("#admPwd").focus();
    	                     Swal.fire("비밀번호가 올바르지 않습니다.", '', 'info');    	                     
    	                  }
    	                  else if(code == -2){
    	                	 $("#admId").focus();
    	                     Swal.fire("탈퇴한 회원입니다.", '', 'info');
    	                  }
    	                  else if(code == 404){
    	                	 $("#admId").focus();
    	                     Swal.fire("아이디와 일치하는 사용자 정보가 없습니다.", '', 'info');    	                    
    	                  }
    	                  else if(code == 400){
    	                	  $("#admId").focus();
    	                     Swal.fire("파라미터 값이 올바르지 않습니다.", '', 'info');    	                    
    	                  }
    	                  else{
    	                	 $("#admId").focus();
    	                     Swal.fire("오류가 발생하였습니다.", '', 'info');   	                     
    	                  }
    	               }
    	            }
    	            //응답이 비어있음
    	            else{
    	               $("#admId").focus();	
    	               Swal.fire("오류가 발생하였습니다.", '', 'info');    	               
    	            }
    	         },
    	         complete:function(data){
    	            //응답이 종료되면 실행 잘 사용하지 않음
    	            icia.common.log(data);
    	         },
    	         error:function(xhr, status, error){
    	            icia.common.error(error);
    	         }
    	         
    	      });
       });
});

function fn_loginCheck(value){
	if(value=="3"){
		document.getElementById("userLogin").style.display ="block";
		document.getElementById("admLogin").style.display = "none";
	}
	else if(value=="4"){
		document.getElementById("userLogin").style.display = "none";
		document.getElementById("admLogin").style.display = "block";
			
	}	
	
}
</script>

</head>
<body>
   <%@ include file="/WEB-INF/views/include/navigation.jsp"%>
   
    <section class="position-relative pb-0">
        <div class="gen-login-page-background" style="background-image: url('/resources/images/background/back.png');"></div>
        <div class="container" id="userLogin" style="display:block">
            <div class="row">
                <div class="col-lg-12">
                    <div class="text-center">
                    <br><br>
                        <form name="pms_login" id="pms_login" action="#" method="post">
                            <h4>
                            	회원 로그인
                        		<div class="col-lg-3 col-md-3 col-sm-12 p-0" style="float:right;" >
                           			<select class="form-control" name="_searchType1" id="_searchType1" onChange = "fn_loginCheck(this.value)">
                              			<option value="3" selected>일반</option>
                              			<option value="4">관리자</option>
                           			</select>
                        		</div>
                            </h4>
							<p class="login-username">
                                <label for="user_login">ID</label>
                                <input type="text" name="userId" id="userId2" class="input" value="" size="20">
                            </p>
                            <p class="login-password">
                                <label for="user_pass">Password</label>
                                <input type="password" name="userPwd" id="userPwd" class="input" value="" size="20">
                            </p>
                            <br><br>
                            <p class="login-submit">
                                <input type="button" name="btnLogin1" id="btnLogin1" class="button button-primary" value="로그인">
                            </p>
                            <input type="hidden" name="pms_login" value="1">
                               <input type="hidden" name="pms_redirect">
                               <a href="/user/userRegForm" style="color: #007bff">회원가입</a>
                        </form>
                    </div>
                </div>
            </div>
        </div>
	<div class="container" id="admLogin" style="display:none">
            <div class="row">
                <div class="col-lg-12">
                    <div class="text-center" >
                    <br><br>
                        <form name="pms_login" id="pms_login" action="#" method="post">
                            <h4>
                            	관리자 로그인
	                            <div class="col-lg-3 col-md-3 col-sm-12 p-0" style="float:right;" >
	                            	<select class="form-control" name="_searchType2" id="_searchType2" onChange = "fn_loginCheck(this.value)">
	                              		<option value="3">일반</option>
	                              		<option value="4" selected>관리자</option>
	                           		</select>
	                        	</div>
                        	</h4>
                            <p class="login-username">
                                <label for="user_login">ID</label>
                                <input type="text" name="admId" id="admId" class="input" value="" size="20">
                            </p>
                            <p class="login-password">
                                <label for="user_pass">Password</label>
                                <input type="password" name="admPwd" id="admPwd" class="input" value="" size="20">
                            </p>
                            <br><br>
                            <p class="login-submit">
                                <input type="button" name="btnLogin2" id="btnLogin2" class="button button-primary" value="로그인">
                            </p>
                            <input type="hidden" name="pms_login" value="1">
                               <input type="hidden" name="pms_redirect">
                               <a href="/user/userRegForm">회원가입</a>
                        </form>
                    </div>
                </div>
            </div>
        </div> 
    </section>
    <br><br><br><br><br><br><br><br>
</body>
<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</html>