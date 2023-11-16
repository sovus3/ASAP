<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<script
	src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<style>
.card {
	background-color: transparent !important;
}

body {
	font-family: 'Gowun Dodum', sans-serif;
}
</style>

<script>
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
$(document).ready(function() {
	totalPrice = $(".totalPrice_input").val();
    console.log("totalPrice", totalPrice);
    console.log("totalPrice >= 50000", totalPrice >= 50000);
    let deliveryFee = 2500;
    /* 배송비 결정 */
    if(totalPrice >= 50000){
       deliveryFee = 0;
    } 
    else if(totalPrice == 0)
    {
       deliveryFee = 0;
    }
    //배송
	$(".font-weight-medium.delieveryFee").text("₩" +deliveryFee.toLocaleString());
      
   /* 포인트 입력 */
   //0 이상 & 최대 포인트 수 이하
   $(".point_input").on("propertychange change keyup paste input", function(){
      const maxPoint = parseInt('${user.userCharge}');   // maxPoint 상수를 선언하고 회원이 소유하고 있는 포인트로 대입
      let inputValue = $(this).val();         // inputValue 변수를 선언하고 사용자가 입력한 값으로 초기화($(this)는 $("#point_input")을 의미)
      totalPrice = $(".totalPrice_input").val();
      
      
      let deliveryFee = 2500;
      /* 배송비 결정 */
		if (totalPrice >= 50000) {
		    deliveryFee = 0;
		} else if (totalPrice > 0 && totalPrice < 50000) {
		    deliveryFee = 2500;
		} else {
		    deliveryFee = 0; // totalPrice가 0인 경우도 배송비를 0으로 설정
		}
      finalTotalPrice = parseInt(totalPrice) + parseInt(deliveryFee);
      
      // 숫자로 시작하지 않는 문자 제거
      inputValue = inputValue.replace(/\D/g, '');

      // 0으로 시작할 경우 0 제거
      if (inputValue.length > 1 && inputValue.charAt(0) === '0') {
          inputValue = inputValue.substring(1);
      }

      // 입력값 업데이트
      $(this).val(inputValue);
      
      if(inputValue < 0)
      {
         $(this).val(0);
      } 
      else if(inputValue > maxPoint)
      {
    	  console.log("111111111111111111111");
         $(this).val(maxPoint);
      }
      
      else if(inputValue > finalTotalPrice)
      {
         $(this).val(finalTotalPrice);
      }
      /* else if(finalTotalPrice > maxPoint)
      {
    	  $(this).val(maxPoint);
      } */
      else if(maxPoint == 0)
      {
    	  $(this).val(0);
      }
      else
      {
    	  $(this).val(inputValue);
      }
          
      /* 주문 조합정보란 최신화 */
      setTotalInfo();
   });

   /* 포인트 모두사용 취소 버튼 
    * Y: 모두사용 상태 / N : 모두 취소 상태
    */
   $(".point_input_btn").on("click", function(){
      const maxPoint = parseInt('${user.userCharge}');   // 상수 maxPoint를 선언하여 회원이 소유한 포인트 값을 대입
      let state = $(this).data("state");               // 사용자가 클릭한 "point_input" 태그에 심어진 data-state 속성 값을 대입
      
      if(state == 'N')
      {
         console.log("n동작");
         /* 모두사용 */
         totalPrice = $(".totalPrice_input").val();
         /* 배송비 결정 */
 		if (totalPrice >= 50000) {
 		    deliveryFee = 0;
 		} else if (totalPrice > 0 && totalPrice < 50000) {
 		    deliveryFee = 2500;
 		} else {
 		    deliveryFee = 0; // totalPrice가 0인 경우도 배송비를 0으로 설정
 		}
  	   
  	     totalPrice = parseInt(totalPrice) + parseInt(deliveryFee);
         //값 변경
         if(maxPoint < totalPrice)
    	 {
         	$(".point_input").val(maxPoint);
    	 }
         else
    	 {
        	 $(".point_input").val(totalPrice);
    	 }
         //글 변경
         $(".point_input_btn_Y").css("display", "inline-block");
         $(".point_input_btn_N").css("display", "none");
      } 
      else if(state == 'Y')
      {
         console.log("y동작");
         /* 취소 */
         
         //값 변경
         $(".point_input").val(0);
         //글 변경
         $(".point_input_btn_Y").css("display", "none");
         $(".point_input_btn_N").css("display", "inline-block");      
      }
      /* 주문 조합정보란 최신화 */
      setTotalInfo();
   });

   /* 주문 조합정보란 최신화 */
   setTotalInfo();
});

/* 총 주문 정보 세팅*/
function setTotalInfo(){
   let totalPrice = 0;            // 최종 가격
   let usePoint = 0;            // 사용 포인트(할인가격)
   let finalTotalPrice = 0;       // 결제 가격(최종 가격 - 포인트)   
   let deliveryFee = 2500;
   
   totalPrice = $(".totalPrice_input").val();
   /* 배송비 결정 */
	if (totalPrice >= 50000) {
	    deliveryFee = 0;
	} else if (totalPrice > 0 && totalPrice < 50000) {
	    deliveryFee = 2500;
	} else {
	    deliveryFee = 0; // totalPrice가 0인 경우도 배송비를 0으로 설정
	}
   
   
   /* 사용 포인트 */
   usePoint = $(".point_input").val();       // '포인트' 입력란에 삽입한 데이터를 가져와서 'usePoint' 대입 
   finalTotalPrice = parseInt(totalPrice) + parseInt(deliveryFee);
   finalTotalPrice -= usePoint;   //사용한 포인트만큼 비용에서 차감되어야 하기 때문에 totalPrice(총 (지불) 가격)에서 usePoint값을 빼준 후 얻은 값을 finalTotalPrice(최종 총 (지불) 가격)에 대입
   
   /* 값 삽입 */
   // 최종 가격
   $(".totalPrice_span").text("₩" + totalPrice.replace(/\B(?=(\d{3})+(?!\d))/g, ","));
   // 결제 가격(총 가격 - 포인트)
   $(".finalTotalPrice_span").text("₩" + finalTotalPrice.toLocaleString());      
   // 할인가(사용 포인트)
   $(".usePoint_span").text("₩" + usePoint.replace(/\B(?=(\d{3})+(?!\d))/g, ","));
}
function setOrderInfo(){
	let totalPrice = 0;            // 최종 가격
    let usePoint = 0;            // 사용 포인트(할인가격)
    let finalTotalPrice = 0;       // 결제 가격(최종 가격 - 포인트)  
    let deliveryFee = 2500;	
    let quantity = $("#quantity").val(); 
    let itemName = $("#itemName").val();
    let itemCode = $("#itemCode").val();
    let itemPrice = $("#price").val();
    let maxProductQuan = $("#maxProductQuan").val();
    console.log("itemCode",itemCode); 
    console.log("itemName:", itemName);
	        
    totalPrice = $(".totalPrice_input").val(); 

	const maxPoint = parseInt('${user.userCharge}'); 
    usePoint = $(".point_input").val();       // '포인트' 입력란에 삽입한 데이터를 가져와서 'usePoint' 대입   
	let pointPrice = maxPoint - usePoint
    console.log("maxPoint:",maxPoint);
    console.log("pointPrice:", pointPrice);
    /* 배송비 결정 */
	if (totalPrice >= 50000) {
	    deliveryFee = 0;
	} else if (totalPrice > 0 && totalPrice < 50000) {
	    deliveryFee = 2500;
	} else {
	    deliveryFee = 0; // totalPrice가 0인 경우도 배송비를 0으로 설정
	}
   
    totalPrice = parseInt(totalPrice) + parseInt(deliveryFee); //최종금액
    finalTotalPrice = totalPrice - usePoint;   //실결제가
    console.log("totalPrice", totalPrice);
    console.log(" finalTotalPrice:",  finalTotalPrice);
    console.log(" userId : ",$("#userId2").val()); 
    console.log("finalTotalPrice",finalTotalPrice);
    console.log("quantity",quantity);
    console.log("itemCode",itemCode);
    console.log(" itemName", itemName);
    console.log(" finalTotalPrice",finalTotalPrice);
    console.log("totalPrice",totalPrice);
    console.log("usePoint",usePoint);
    console.log("pointPrice",pointPrice);
    console.log("itemprice",itemPrice);
    console.log("maxProductQuan",maxProductQuan);
  
    if(maxProductQuan<quantity)
   	{
    	Swal.fire('재고가 부족합니다. 재고 : ' + maxProductQuan, '', 'warning');
   	}
    else
   	{    	
    	$.ajax({
			type:"POST",
			url:"/product/orderDirectProc",
			data:{
				 userId:$("#userId2").val(),
				 orderTotalPrice:finalTotalPrice,
				 itemCode:$("#itemCode").val(),
				 itemName:$("#itemName").val(),
				 quantity:quantity,
				 totalAmount:finalTotalPrice,
				 payTotalPrice:totalPrice,
				 payPointPrice:usePoint,
				 userCharge:pointPrice,
				 itemPrice:itemPrice
				 
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
					console.log("orderId",orderId);
				    console.log("tId:", tId);  
				    console.log("pcUrl:", pcUrl);				    
				    
					var win = window.open('','kakaoPopUp',
							'toolbar=no,location=no,status=no,menubar=no,scrollbars=yes,resizable=no,width=540,height=700,left=100,top=100');
					
					$("#kakaoForm").submit();
		   		}
		    	if(response.code == 1)
		   		{
		    		 Swal.fire({
	                    title: '결제 하시겠습니까?',
	         	   		html: '상품명: ' + itemName + ' ' + quantity + '개 <br>결제가격: 0원',
	                    icon: 'question',
	                    color: '#FFFFFF',
						showCancelButton: true,
						confirmButtonColor: '#3085d6',
						cancelButtonColor: '#d33',
						confirmButtonText: '확인',
						cancelButtonText: '취소'
						}).then((result) => {
							
						if (result.isConfirmed) {
							$.ajax({
								type:"POST",
								url:"/kakao/directPayUpdate",
								data:{
									orderId:response.data
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
							    		Swal.fire({title: '주문이 완료되었습니다.', 
							                   		icon: 'success'
							           	}).then(function(){
							        	   location.href="/myPage/myPagePay";
							           	})
							    		
							   		}
							    	else if(responser.code == 200)
							   		{
							   			Swal.fire('결제테이블 수정X', '', 'warning');
							   		}
							    	else if(responser.code == 300)
							   		{
							   			Swal.fire('주문테이블 수정X', '', 'warning');
							   		}
							    	else
									{
							    		Swal.fire('서버오류', '', 'warning');
									}
							    },
							    error:function(xhr,status,error)
							    {
							    	icia.common.error(error);
							    }
									
							});
						}
				
					})
		    		 
		   		}
		    	else if(response.code == 500)
		   		{
		   			Swal.fire('결제테이블에 입력되지 않았습니다.', '', 'warning');
		   		}
		    	else if(response.code == 400)
		   		{
		   			Swal.fire('주문테이블에 입력되지 않았습니다.', '', 'warning');
		   		}
		    	else if(response.code == 404)
		   		{
		   			Swal.fire('주문상세테이블에 입력되지 않았습니다.', '', 'warning');
		   		}
		    },
		    error:function(xhr,status,error)
		    {
		    	icia.common.error(error);
		    	Swal.fire('결제에 실패했습니다.', '', 'warning');
		    }
	    });
   	}

   /* 값 삽입 */
   // 최종 가격
   $(".totalPrice_span").text("₩" +totalPrice.toLocaleString());
   //배송
   $(".font-weight-medium.delieveryFee").text("₩" +deliveryFee.toLocaleString());
   // 결제 가격(총 가격 - 포인트)
   $(".finalTotalPrice_span").text("₩" +finalTotalPrice.toLocaleString());      
	   // 할인가(사용 포인트)
   $(".usePoint_span").text("₩" + usePoint.replace(/\B(?=(\d{3})+(?!\d))/g, ",")); 
	
} 
function movePage()
{
   location.href = "/myPage/myPagePay";
}

</script>

</head>
<body>
	<%@ include file="/WEB-INF/views/include/navigation.jsp"%>

	<!-- breadcrumb -->
	<div class="gen-breadcrumb"
		style="background-image: url('/resources/images/background/back.png');">
		<div class="container">
			<div class="row align-items-center">
				<div class="col-lg-12">
					<nav aria-label="breadcrumb">
						<div class="gen-breadcrumb-title">
							<h1>결제</h1>
						</div>
						<div class="gen-breadcrumb-container">
							<ol class="breadcrumb">
								<li class="breadcrumb-item"><a href="/"> <i
										class="fas fa-home mr-2"></i>홈
								</a></li>
								<li class="breadcrumb-item active">결제</li>
							</ol>
						</div>
					</nav>
				</div>
			</div>
		</div>
	</div>
	<!-- breadcrumb -->

	<!-- Checkout Start -->
	<div class="container-fluid pt-5">
		<div class="row px-xl-5">
			<div class="col-lg-8">
				<div class="mb-4">
					<h4 class="font-weight-semi-bold mb-4">기본 배송 주소</h4>
					<div class="row">
						<div class="col-md-12 form-group">
							<label>이름</label> <input type="text" placeholder="홍길동"
								value="${user.userName}" readonly>
						</div>
						<div class="col-md-12 form-group">
							<label>이메일</label> <input type="text"
								placeholder="example@email.com" value="${user.userEmail}"
								readonly>
						</div>
						<div class="col-md-12 form-group">
							<label>전화번호</label> <input type="text" placeholder="01012345678"
								value="${user.userPhone}" readonly>
						</div>
						<div class="col-md-6 form-group">
							<label>우편번호</label> <input type="text" placeholder="000000"
								value="${user.userPostcode}" readonly>
						</div>
						<div class="col-md-12 form-group">
							<label>주소</label> <input type="text"
								placeholder="서울특별시 마포구 월드컵북로 21 풍성빌딩 2층"
								value="${user.userAddr}" readonly>
						</div>
						<div class="col-md-12 form-group">
							<div class="custom-control custom-checkbox">
								<input type="checkbox" class="custom-control-input" id="shipto">
								<label class="custom-control-label" for="shipto"
									data-toggle="collapse" data-target="#shipping-address">다른
									배송지 주소 입력</label>
							</div>
						</div>
					</div>
				</div>
				<div class="collapse mb-4" id="shipping-address"
					style="position: sticky;">
					<h4 class="font-weight-semi-bold mb-4">신규 배송 주소</h4>
					<div class="row">
						<div class="col-md-12 form-group">
							<label>이름</label> <input type="text" value="">
						</div>
						<div class="col-md-12 form-group">
							<label>이메일</label> <input type="text" value="">
						</div>
						<div class="col-md-12 form-group">
							<label>전화번호</label> <input type="text" value="">
						</div>
						<div class="col-md-6 form-group">
							<label>우편번호</label> <input type="text" id="postcode" value="">
						</div>
						<div class="col-md-6 form-group">
							<input type="button" onclick="execPostcode()" value="우편번호 찾기"
								style="margin-top: 38px;">
						</div>
						<div class="col-md-12 form-group">
							<label>주소</label> <input type="text" id="address" value="">
						</div>
					</div>
				</div>
			</div>
			<div class="col-lg-4">
				<form class="mb-5" action="">
					<h4 class="font-weight-semi-bold m-0 mb-3">포인트 사용</h4>
					<div class="input-group">
						<input type="text" class="point_input form-control p-4" value="0">
					</div>
					<small> 보유 포인트 : <i>&#8361;<fmt:formatNumber
								type="number" maxFractionDigits="3" value="${user.userCharge}" /></i>
						&nbsp; <a class="point_input_btn point_input_btn_N" data-state="N"
						style="cursor: pointer; text-decoration: underline; font-weight: bold;">모두
							사용</a> <a class="point_input_btn point_input_btn_Y" data-state="Y"
						style="cursor: pointer; text-decoration: underline; font-weight: bold; display: none;">사용
							취소</a>
					</small>
				</form>

				<div class="card mb-5" style="border-color: #3D4F74;">
					<div class="card-header border-0"
						style="background-color: #3D4F74;">
						<h4 class="font-weight-semi-bold m-0">주문 내역서</h4>
					</div>
					<div class="card-body price">
						<h5 class="font-weight-medium mb-3">상품</h5>
						<div class="d-flex justify-content-between">
							<p>${product.productName}</p>
							<p>${quantity}개</p>
							<p>
								&#8361;
								<fmt:formatNumber type="number" maxFractionDigits="3"
									value="${product.productPrice  *  quantity}" />
							</p>

							<input type="hidden" class="totalPrice_input"
								value="${product.productPrice  *  quantity}"> <input
								type="hidden" id="userId2" value="${user.userId}"> <input
								type="hidden" id="itemName" value="${product.productName}">
							<input type="hidden" id="itemCode" value="${product.productSeq }">
							<input type="hidden" id="price" value="${product.productPrice }">
							<input type="hidden" id="quantity" value="${quantity}">
						</div>

						<hr class="mt-0">

						<div class="d-flex justify-content-between mb-3 mt-1 pt-1">
							<h6 class="font-weight-medium">최종 금액</h6>
							<h6 class="font-weight-medium totalPrice_span">
								&#8361;
								<fmt:formatNumber type="number" maxFractionDigits="3" value="" />
							</h6>
						</div>

						<div class="d-flex justify-content-between mb-3 mt-1 pt-1">
							<h6 class="font-weight-medium">배송비</h6>
							<h6 class="font-weight-medium delieveryFee">
								&#8361;
								<fmt:formatNumber type="number" maxFractionDigits="3"
									value="2500" />
							</h6>
						</div>

						<div class="d-flex justify-content-between">
							<h6 class="font-weight-medium">포인트 사용</h6>
							<h6 class="font-weight-medium usePoint_span"
								style="color: #DAA520;">
								&#8361;
								<fmt:formatNumber type="number" maxFractionDigits="3" value="" />
							</h6>
						</div>
					</div>

					<div class="card-footer bg-transparent"
						style="border-color: #3D4F74;">
						<div class="d-flex justify-content-between mt-2">
							<h5 class="font-weight-bold">결제 금액</h5>
							<h5 class="font-weight-bold finalTotalPrice_span">
								&#8361;
								<fmt:formatNumber type="number" maxFractionDigits="3" value="" />
							</h5>
						</div>
					</div>
				</div>

				<div class="card mb-5" style="border-color: #3D4F74;">
					<div class="card-header border-0"
						style="background-color: #3D4F74;">
						<h4 class="font-weight-semi-bold m-0">결제</h4>
					</div>
					<div class="card-body">
						<div class="form-group">
							<div class="custom-control custom-radio">
								<input type="radio" class="custom-control-input" name="payment"
									id="paypal" checked> <label
									class="custom-control-label" for="paypal">카카오페이</label>
							</div>
						</div>
					</div>
					<div class="card-footer bg-transparent"
						style="border-color: #3D4F74;">
						<button onclick="setOrderInfo()"
							class="btn btn-lg btn-block font-weight-bold my-3 py-3"
							style="background-color: #3D4F74; color: #ffffff;">결제하기</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- Checkout End  -->
	<form name="kakaoForm" id="kakaoForm" method="post" target="kakaoPopUp" action="/kakao/directPayPopUp">
		<input type="hidden" name="orderId" id="orderId" value="" /> 
		<input type="hidden" name="tId" id="tId" value="" /> 
		<input type="hidden" name="pcUrl" id="pcUrl" value="" />
		<input type="hidden" name="maxProductQuan" id="maxProductQuan" value="${maxProductQuan }" />
	</form>
	<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>