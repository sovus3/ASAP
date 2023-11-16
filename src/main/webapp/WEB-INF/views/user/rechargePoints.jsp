<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<style>
.card{
   background-color: transparent !important;
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

$(document).ready(function(){
	let price = $("#point").val();
	let userPoint =$("#userPoint").val(); 
    let itemName = '포인트 충전';	
    let itemCode = 1;
    let userId = $("#userId2").val();
    let totalPrice = 0;
    let userCode = $("#userCode").val();
	console.log("price",price);
    console.log("userPoint",userPoint);
    console.log("totalPrice",totalPrice);
    console.log("userId",userId);
    console.log("userCode",userCode); 
});
function setPoint()
{	
	let price = $("#point").val();
	let userPoint =$("#userPoint").val(); 
    let itemName = '포인트 충전';	
    let itemCode = 1;
    let userId = $("#userId2").val();
    let totalPrice = 0;
    
    totalPrice =parseInt( price )+ parseInt(userPoint);
    console.log("price",price);
    console.log("userPoint",userPoint);
    console.log("totalPrice",totalPrice);
    console.log("userId",userId);   
    
	$.ajax({
			type:"POST",
			url:"/user/pointProc",
			data:{
				 userId:$("#userId2").val(),
				 orderTotalPrice:totalPrice,
				 amount:price,
				 orderTotalQuantity:1,
				 itemCode:1,
				 itemName:'포인트 충전'
				 
			},
			datatype:"JSON",
		    beforeSend:function(xhr)
		    {
		    	xhr.setRequestHeader("AJAX","true");
		    },
		    success:function(response)
		    {
		    	if(response.code == 0)
		   		{
					var orderId = response.data.orderId;
					var tId = response.data.tId;
					var pcUrl = response.data.pcUrl;
					
					$("#orderId").val(orderId);
					$("#tId").val(tId);
					$("#pcUrl").val(pcUrl);
					$("#gubunCheck").val('gubunCheckPoint');
					console.log("orderId",orderId);
				    console.log("tId:", tId);  
				    console.log("pcUrl:", pcUrl);
				    
				    
					var win = window.open('','kakaoPopUp',
							'toolbar=no,location=no,status=no,menubar=no,scrollbars=yes,resizable=no,width=540,height=700,left=100,top=100');
					
					$("#kakaoForm").submit();
		   		}
		    	else if(response.code == 100)
	    		{
		    		$("#point").focus();	
		    		Swal.fire("0원이상 입력해주세요.", '', 'warning'); 
	                
	    		}
		    	else if(response.code == 200)
		   		{
		   			Swal.fire("결제 테이블에 입력되지 않았습니다.", '', 'warning');
		   		}
		    	else if(response.code == 300)
		   		{
		    		Swal.fire("주문상세테이블에 입력되지 않았습니다.", '', 'warning');
		   		}
		    	else if(response.code == 400)
		   		{			   			
		   			Swal.fire("주문테이블에 입력되지 않았습니다.", '', 'warning');
		   		}
		    	else
	    		{
		    		Swal.fire("0원이상 입력해주세요.", '', 'info');
	    		}
		    },
		    error:function(xhr,status,error)
		    {
		    	icia.common.error(error);
		    	Swal.fire("카카오페이 결제에 실패했습니다.", '', 'warning');
		    }
				
		});
}  
function movePage()
{
   location.href = "/myPage/myPageMain";
}
</script>
</head>
<body >
<%@ include file="/WEB-INF/views/include/navigation.jsp"%>
<!-- breadcrumb -->
   <div class="gen-breadcrumb"
      style="background-image: url('/resources/images/background/back.png');">
      <div class="container">
         <div class="row align-items-center">
            <div class="col-lg-12">
               <nav aria-label="breadcrumb">
                  <div class="gen-breadcrumb-title">
                     <h1>포인트 충전</h1>
                  </div>
                  <div class="gen-breadcrumb-container">
                     <ol class="breadcrumb">
                        <li class="breadcrumb-item">
                           <a href="/"> 
                              <i class="fas fa-home mr-2"></i>홈
                           </a>
                        </li>
                        <li class="breadcrumb-item active">포인트 충전</li>
                     </ol>
                  </div>
               </nav>
            </div>
         </div>
      </div>
   </div>
   <!-- breadcrumb -->
  
   <div class="card mt-5 mb-5" style="border-color:#3D4F74; margin:0 auto; width:30%">
               <div class="card-header border-0" style="background-color:#3D4F74;">
                  <h4 class="font-weight-semi-bold m-0" style="text-align:center" >결제</h4>
               </div>
               <form class="mb-5" style="margin:0 auto; width:85%; text-align:center" action="">
               <h4 class="font-weight-semi-bold mt-5 m-0 mb-3" style="text-align:center" >포인트 충전</h4>
                    <div class="input-group" style="margin:0 auto; width:55%">
                        <input type="text" name="point" onkeyup="inputNumberFormat(this)" id="point" class="point_input form-control p-4" style="text-align:center" value="0" >
                    </div>
                    <small>
                       보유 포인트 : <i >&#8361;<fmt:formatNumber type="number" maxFractionDigits="3" value="${user.userCharge }" /></i> 
                       &nbsp;
                       
                    </small>
			   </form>
               <div class="card-body">
                  <div class="form-group">
                     <div class="custom-control custom-radio" style="margin:0 auto; width:20%"> 
                        <input type="radio" class="custom-control-input" name="payment" id="paypal" checked> 
                        <label style="margin:0 auto;  text-align:center" class="custom-control-label" for="paypal">카카오페이</label>
                     </div>
                  </div>
               </div>
               <div class="card-footer bg-transparent" style="border-color:#3D4F74;">
                  <button class="btn btn-lg btn-block font-weight-bold my-3 py-3 pay" style="background-color:#3D4F74; color:#ffffff;" onclick="setPoint()">결제하기</button>
               </div> 
                         
      </div>
      <input type="hidden" id="userId2" value="${user.userId}">  
      <input type="hidden" id="userPoint" value="${user.userCharge }">        
      <input type="hidden" name="userCode" id="userCode" value="${user.userCode }"/>
      
	<form name="kakaoForm" id="kakaoForm" method="post" target="kakaoPopUp" action="/kakao/payPopUp">
      <input type="hidden" name="orderId" id="orderId" value="" />
      <input type="hidden" name="tId" id="tId" value="" />
      <input type="hidden" name="pcUrl" id="pcUrl" value="" />
      <input type="hidden" name="gubunCheck" id="gubunCheck" value="" />
	</form>
	
<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>