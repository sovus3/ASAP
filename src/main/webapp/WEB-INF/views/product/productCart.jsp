<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<style>
.form-control-plaintext.form-control-sm, .form-control-plaintext.form-control-lg
	{
	padding-right: 0;
	padding-left: 0;
}

.form-control-sm {
	height: calc(1.5em + 0.5rem + 2px) !important;
	padding: 0.25rem 0.5rem;
	font-size: 0.875rem;
	line-height: 1.5;
}

th, td {
	border-color: transparent !important;
}

.card {
	background-color: transparent !important;
}
</style>
<script>
$(document).ready(function() {
	document.getElementById("quan_input").readOnly = true;
	var subTotal = parseInt($("#subTotal1").val());
    var deliveryFee = 2500;
    console.log("$('#subTotal').val() :",  subTotal);
    console.log("subTotal >= 50000",subTotal >= 50000);
    console.log("deliveryFee",deliveryFee);
    
    /* 배송비 결정 */
    if(subTotal >= 50000)
    {
       deliveryFee = 0;
    } 
    else if(subTotal == 0)
    {
       deliveryFee = 0;
	}
    var totalPrice = deliveryFee + subTotal;
    $(".font-weight-medium.deliveryFee").text("₩" +deliveryFee.toLocaleString());
    $("#totalPrice").text("₩" + totalPrice.toFixed(0).replace(/\B(?=(\d{3})+(?!\d))/g, ",")); 
    $(".btn.btn-sm.btn-plus").prop("disabled", false);  

	//수량 플러스 버튼 클릭 이벤트
	$(".btn.btn-sm.btn-plus").on("click", function() {
		//$(".btn.btn-sm.btn-plus").on("click", function() {
		$(".btn.btn-sm.btn-plus").prop("disabled", false);
		var productRow = $(this).closest("tr");
		var maxProductQuan = productRow.find("#maxProductQuan").val()
		var quanInput = productRow.find("#quan_input");   	
		var curQuan = parseInt(quanInput.val());  
			
		// 입력값이 재고보다 크면 재고값으로 변경합니다.
       if (curQuan >= parseInt(maxProductQuan)) {
           curQuan = maxProductQuan; // 재고값으로 설정

           Swal.fire({title: '재고가 부족합니다.',
        	  		   html: '재고: ' + ${maxProductQuan} + '',
               		   icon: 'warning',
               		   color: '#FFFFFF'
       		})
           productRow.find(".btn.btn-sm.btn-plus").prop("disabled", true);
           
       } else {
    	   curQuan++;
    	   updateSubTotal(productRow);
       }
       quanInput.val(curQuan);
       updateTotal(productRow); 
		
		console.log("quanInput",quanInput);
		console.log("curQuan",curQuan);
		console.log("maxProductQuan",maxProductQuan);
    
		$(".btn.btn-sm.btn-plus").prop("disabled", false);
       
		var productSeq = parseInt(productRow.find("#product_seq").data("product-seq"));
		var userId = $("#userId1").val();
		var totalQuan = parseInt(quanInput.val());
		var totalPrice = totalQuan *  parseInt(productRow.find("#cartPrice").attr("data-cartPrice"));
		console.log("ProductSeq:", productSeq);
		console.log("userId:", userId);
		console.log("totalQuan : ", totalQuan);   
		console.log("totalPrice : ", totalPrice); 
		console.log("3333333333333333333333333333333333");
       
		$.ajax({
			type: "POST",
			url: "/prodcut/cartUpdateProc",
			data: {
				userId:userId,
				productSeq:parseInt(productSeq),
				cartQuantity:totalQuan,
				cartPrice:totalPrice
			},
			datatype:"JSON",
			beforeSend:function(xhr){
				xhr.setRequestHeader("AJAX", "true");//서버에 보내기 전에 호추로디는 함수. request헤더에 ajax통신에 관련한걸 담아서 보내라는 의미.
			},
			success:function(response)
			{
				if(response.code == 0)
				{
					
				}
				else {
					Swal.fire({title: '오류가 발생했습니다.', 
				  		  		icon: 'warning'
					}).then(function(){
						location.href = "/product/productList";
					})
				}
			},
			error:function(xhr, status, error)
			{
				icia.common.error(error);
			}
		});
	});
    //수량 마이너스 버튼 클릭 이벤트
    $(".btn.btn-sm.btn-minus").on("click", function() {
    	$(".btn.btn-sm.btn-plus").prop("disabled", false);
    	var productRow = $(this).closest("tr");
        var quanInput = productRow.find("#quan_input");
        var curQuan = parseInt(quanInput.val());
        if (curQuan > 1) {
            quanInput.val(curQuan - 1);
            updateTotal(productRow); // 총 금액 업데이트
            updateSubTotal2(productRow);
        }
        var productSeq = parseInt(productRow.find("#product_seq").data("product-seq"));
        var userId = $("#userId1").val();
        var totalQuan = parseInt(quanInput.val());
        var totalPrice = totalQuan * parseInt(productRow.find("#cartPrice").attr("data-cartPrice"));
        console.log("ProductSeq:", productSeq);
		console.log("userId:", userId);
		console.log("totalQuan : ", totalQuan);   
		console.log("totalPrice : ", totalPrice); 
		console.log("3333333333333333333333333333333333");
        $.ajax({
			   type: "POST",
				url: "/prodcut/cartUpdateProc",
				data: {
					userId:userId,
					productSeq:parseInt(productSeq),
					cartQuantity:totalQuan,
					cartPrice:totalPrice
				},
				datatype:"JSON",
				beforeSend:function(xhr){
					xhr.setRequestHeader("AJAX", "true");//서버에 보내기 전에 호추로디는 함수. request헤더에 ajax통신에 관련한걸 담아서 보내라는 의미.
				},
				success:function(response)
				{
					if(response.code == 0)
					{
						
					}
					else 
					{
						Swal.fire({title: '오류가 발생했습니다.', 
			  		  				icon: 'warning'
						}).then(function(){
							location.href = "/product/productList";
						})
					}
				},
				error:function(xhr, status, error)
				{
					icia.common.error(error);
				}
			});
    });
     
    
              
    
    //총 금액 업데이트 함수
    function updateTotal(productRow) {
	    var cartPriceStr = productRow.find("#cartPrice").attr("data-cartPrice");
	    var quantityStr = productRow.find("#quan_input").val();

        console.log("cartPriceStr:", cartPriceStr);
        console.log("quantityStr:", quantityStr);
        console.log("111111111111111111");   
	    // 값이 숫자로 변환 가능한지 확인
	    var cartPrice = parseFloat(cartPriceStr);
	    var quantity = parseInt(quantityStr);
	    
	    // 값이 NaN인 경우 오류 처리
	    if (isNaN(cartPrice) || isNaN(quantity)) {
	        console.log("Invalid cartPrice or quantity:", cartPriceStr, quantityStr);
	        productRow.find("#total").text("₩0"); // 유효하지 않은 값일 경우 초기화
	    } else {
	        var total = cartPrice * quantity;
	        productRow.find("#total").text("₩" + total.toFixed(0).replace(/\B(?=(\d{3})+(?!\d))/g, ",")); // 화면에 업데이트
	        
	    }
	}
    //결제 총금액 업데이트 
    function updateSubTotal(productRow) {
        var cartPriceStr = parseInt(productRow.find("#cartPrice").attr("data-cartPrice"));
        console.log("subTotal1 :", subTotal1)
        console.log("cartPrice :", cartPriceStr);
        console.log("subTotal + cartPriceStr :", (subTotal + cartPriceStr));
        subTotal += cartPriceStr 
        console.log("$('#subTotal').val() :",  subTotal);
        $("#subTotal").text("₩" + subTotal.toFixed(0).replace(/\B(?=(\d{3})+(?!\d))/g, ","));
        
	    /* 배송비 결정 */
	    if(subTotal >= 50000){
	       deliveryFee = 0;
	    } 
	    else if(subTotal == 0)
	    {
	       deliveryFee = 0;
	     }
	    console.log("subTotal :",  subTotal);
	    console.log("deliveryFee :",  deliveryFee);
	    $(".font-weight-medium.deliveryFee").text("₩" +deliveryFee.toLocaleString());
        var totalPrice = subTotal + deliveryFee 
        console.log("totalPrice :",  totalPrice);
        $("#totalPrice").text("₩" + totalPrice.toFixed(0).replace(/\B(?=(\d{3})+(?!\d))/g, ","));
    }
    function updateSubTotal2(productRow) {
 	   var deliveryFee = 2500;
 	    
        var cartPriceStr = parseInt(productRow.find("#cartPrice").attr("data-cartPrice"));
        console.log("cartPrice :", cartPriceStr);
        console.log("subTotal + cartPriceStr :", (subTotal + cartPriceStr));
        subTotal -= cartPriceStr 
        console.log("$('#subTotal').val() :",  subTotal);
        $("#subTotal").text("₩" + subTotal.toFixed(0).replace(/\B(?=(\d{3})+(?!\d))/g, ","));
        
        /* 배송비 결정 */
   	    if(subTotal >= 50000){
   	       deliveryFee = 0;
   	    } 
   	    else if(subTotal == 0)
   	    {
   	       deliveryFee = 0;
   	     }
   	    console.log("subTotal :",  subTotal);
   	    console.log("deliveryFee :",  deliveryFee);
   	    $(".font-weight-medium.deliveryFee").text("₩" +deliveryFee.toLocaleString());
        var totalPrice = subTotal + deliveryFee 
        console.log("totalPrice :",  totalPrice);
        $("#totalPrice").text("₩" + totalPrice.toFixed(0).replace(/\B(?=(\d{3})+(?!\d))/g, ","));              
    } 
    function updateSubTotal3(productRow) {
  	     var deliveryFee = 2500;
  	    
         var cartPriceStr = parseInt(productRow.find("#cartPrice").attr("data-cartPrice"));
         console.log("cartPrice :", cartPriceStr);
         console.log("subTotal + cartPriceStr :", (subTotal + cartPriceStr));
         subTotal -= cartPriceStr 
         console.log("$('#subTotal').val() :",  subTotal);
         $("#subTotal").text("₩" + subTotal.toFixed(0).replace(/\B(?=(\d{3})+(?!\d))/g, ","));
         
         /* 배송비 결정 */
    	    if(subTotal >= 50000){
    	       deliveryFee = 0;
    	    } 
    	    else if(subTotal == 0)
    	    {
    	       deliveryFee = 0;
    	     }
    	    console.log("subTotal :",  subTotal);
    	    console.log("deliveryFee :",  deliveryFee);
    	    $(".font-weight-medium.deliveryFee").text("₩" +deliveryFee.toLocaleString());
         var totalPrice = subTotal + deliveryFee 
         console.log("totalPrice :",  totalPrice);
         $("#totalPrice").text("₩" + totalPrice.toFixed(0).replace(/\B(?=(\d{3})+(?!\d))/g, ","));              
     } 

});

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
							<h1>장바구니</h1>
						</div>
						<div class="gen-breadcrumb-container">
							<ol class="breadcrumb">
								<li class="breadcrumb-item"><a href="/"> <i
										class="fas fa-home mr-2"></i>홈
								</a></li>
								<li class="breadcrumb-item active">장바구니</li>
							</ol>
						</div>
					</nav>
				</div>
			</div>
		</div>
	</div>
	<!-- breadcrumb -->

	<!-- Cart Start -->
	<div class="container-fluid pt-5">
		<div class="row px-xl-5">
			<div class="col-lg-8 table-responsive mb-5">
				<table class="table text-center mb-0" style="color: #ffffff;">
					<thead style="background-color: #3D4F74;">
						<tr>
							<th></th>
							<th>상품명</th>
							<th>금액</th>
							<th>수량</th>
							<th>총 금액</th>
							<th></th>
						</tr>
					</thead>
					<c:if test="${!empty list}">
						<c:set var="subTotal" value="0" />
						<c:forEach var="cart" items="${list}" varStatus="status">
							<tbody class="align-middle">
								<tr>
									<td class="align-middle" width="100"><img
										src="/resources/upload/product/${cart.productSeq}.png">
									</td>
									<td class="align-middle"><img src="" alt="" style="width: 50px;"> ${cart.productName} 
										<input type="hidden" id="maxProductQuan" value="${cart.productQuantity}" /> 
										<input type="hidden" id="product_seq" data-product-seq="${cart.productSeq}">
										<input type="hidden" id="userId1" value="${cart.userId}">
									</td>
									<td class="align-middle" id="cartPrice" data-cartPrice="${cart.productPrice}">
										<fmt:formatNumber type="number" maxFractionDigits="3" value="${cart.productPrice}" />
									</td>
									<input type=hidden id="cartTotalPrice" name="cartTotalPrice" value="${cart.productPrice }">
									<td class="align-middle">
										<div class="input-group quantity mx-auto" style="width: 110px;">
											<div class="input-group-btn">
												<button class="btn btn-sm btn-minus" style="background-color: #3D4F74;">
													<i class="fa fa-minus"></i>
												</button>
											</div>
											<input type="text" id="quan_input" style="background-color: rgba(0, 0, 0, 0.5); color: white;"
												class="form-control form-control-sm text-center"
												value="${cart.cartQuantity }" data-cartNo="${cart.cartNo}" readonly>
											<div class="input-group-btn">
												<button class="btn btn-sm btn-plus" style="background-color: #3D4F74;">
													<i class="fa fa-plus"></i>
												</button>
											</div>
										</div>
									</td>
									<td class="align-middle" id="total">₩ <fmt:formatNumber
											type="number" maxFractionDigits="3" value="${cart.productPrice *cart.cartQuantity}" /></td>
									<td class="align-middle">
										<button class="btn btn-sm delete" style="background-color: #3D4F74;">
											<i class="fa fa-times"></i>
										</button>
									</td>
								</tr>
							</tbody>
							<c:set var="subTotal" value="${subTotal + (cart.productPrice * cart.cartQuantity)}"></c:set>
						</c:forEach>
					</c:if>
				</table>
			</div>
	<script>
	$(".btn.btn-sm.delete").on("click", function() {
        Swal.fire({
            title: '장바구니에서 삭제하시겠습니까?',
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: '확인',
            cancelButtonText: '취소'
        }).then((result) => {
            if (result.isConfirmed) {
		  	 	 var productRow = $(this).closest("tr");
			     var productSeq = parseInt(productRow.find("#product_seq").data("product-seq"));
			     var userId = $("#userId1").val();
			     
				$.ajax({
					type: "POST",
					url: "/prodcut/cartDelete",
					data: {
						userId:userId,
						productSeq:parseInt(productSeq)
					},
					datatype:"JSON",
					beforeSend:function(xhr){
						xhr.setRequestHeader("AJAX", "true");//서버에 보내기 전에 호추로디는 함수. request헤더에 ajax통신에 관련한걸 담아서 보내라는 의미.
					},
					success:function(response){
						if(response.code == 0){
							location.href = "/product/productCart"
						}
						else {
							Swal.fire({title: '오류가 발생했습니다.', 
										icon: 'warning'
							}).then(function(){
							 	location.href = "/product/productList";
							})
						}
					},
					error:function(xhr, status, error)
					{
						icia.common.error(error);
					}
				});
 			}

        })
	});
     </script>
			<div class="col-lg-4">
				<div class="card mb-5" style="border-color: #3D4F74;">
					<div class="card-header border-0"
						style="background-color: #3D4F74;">
						<h4 class="font-weight-semi-bold m-0">Cart Summary</h4>
					</div>
					<script>
        
           </script>
					<div class="card-body">
						<div class="d-flex justify-content-between mb-3 pt-1">
							<h6 class="font-weight-medium">Subtotal</h6>
							<h6 class="font-weight-medium" id="subTotal">
								₩
								<fmt:formatNumber type="number" maxFractionDigits="3"
									value="${subTotal}" />
							</h6>
						</div>
						<div class="d-flex justify-content-between">
							<h6 class="font-weight-medium">Shipping</h6>
							<h6 class="font-weight-medium deliveryFee" id="deliveryFee">
								₩
								<fmt:formatNumber type="number" maxFractionDigits="3" value="0" />
							</h6>
						</div>
					</div>
					<div class="card-footer bg-transparent"
						style="border-color: #3D4F74;">
						<div class="d-flex justify-content-between mt-2">
							<h5 class="font-weight-bold">Total</h5>
							<h5 class="font-weight-bold" id="totalPrice">
								₩
								<fmt:formatNumber type="number" maxFractionDigits="3"
									value="${subTotal}" />
							</h5>
							<c:set var="price" value="${subTotal}"></c:set>
						</div>
						<button class="btn btn-block my-3 py-3"
							style="background-color: #3D4F74; color: #ffffff;"
							onclick="fn_cartCheck()">Proceed To Checkout</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- Cart End -->
	<form name="checkOut" id="checkOut" method="post">
		<input type="hidden" name="gubunCheck" id="gubunCheck" value="" /> 
		<input type="hidden" name="userId" id="userId1" value="${cart.userId }" />
		<input type="hidden" name="price" id="price" value="${price}" />
		<input type="hidden" id="subTotal1" value="${subTotal}"/>
	</form>
	<script>
		function fn_cartCheck()
		{
			$.ajax({
				   type: "POST",
					url: "/product/productCartCheck",
					datatype:"JSON",
					beforeSend:function(xhr){
						xhr.setRequestHeader("AJAX", "true");//서버에 보내기 전에 호추로디는 함수. request헤더에 ajax통신에 관련한걸 담아서 보내라는 의미.
					},
					success:function(response)
					{
						if(response.code == 0)
						{
							document.checkOut.gubunCheck.value="cart";
							document.checkOut.userId.value=$("#userId1").val();
							document.checkOut.action = "/product/productCheckOut";
							document.checkOut.submit();
						}
						else if(response.code == 400)
						{
							Swal.fire({title: response.data, 
	                       				icon: 'warning'
			               	}).then(function(){
								location.href = "/product/productCart";
			               	})
						}
						else
						{
							Swal.fire({title: '장바구니에 상품을 담아주세요', 
			                       		icon: 'warning'
			               	}).then(function(){
			            	   location.href = "/product/productList";
			               	})
						}
						
					},
					error:function(xhr, status, error)
					{
						icia.common.error(error);
					}
				});

		} 
	 </script>

	<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>
