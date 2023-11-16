<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<script>
$(document).ready(function(){
	
	   $("#admId").focus();
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
	    	         url: "/index/adminProc",//url 만들기
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
	    		            	   location.href = "/admin/userList"; //추후 변경
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


</script>
  </head>
  <body>
    <div class="container-scroller">
      <div class="container-fluid page-body-wrapper full-page-wrapper">
        <div class="content-wrapper d-flex align-items-center auth">
          <div class="row flex-grow">
            <div class="col-lg-4 mx-auto">
              <div class="auth-form-light text-left p-5">
                <div class="brand-logo" style="margin-left:-10px;">
                  <img src="/resources/images/asap.png">
                </div>
                <h4>관리자 로그인</h4>
                <form class="pt-3">
                  <div class="form-group">
                    <input type="text" class="form-control form-control-lg" name="admId" id="admId" placeholder="아이디">
                  </div>
                  <div class="form-group">
                    <input type="password" class="form-control form-control-lg" name="admPwd" id="admPwd" placeholder="비밀번호">
                  </div>
                  <div class="mt-3">
                    <a class="btn btn-block btn-primary btn-lg font-weight-medium auth-form-btn" name="btnLogin2" id="btnLogin2" >SIGN IN</a>
                  </div>                 
                </form>
              </div>
            </div>
          </div>
        </div>
        <!-- content-wrapper ends -->
      </div>
      <!-- page-body-wrapper ends -->
    </div>
    <!-- container-scroller -->
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
  </body>
</html>