<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>

<style>
.cat-item .cat-img img, .product-item .product-img img {
	transition: .5s;
}

.cat-item:hover .cat-img img, .product-item:hover .product-img img {
	transform: scale(1.2);
}

.product-item .btn:hover {
	color: #D19C97 !important;
}

.bg-secondary {
	background-color: #EDF1FF !important;
}

a.bg-secondary:hover, a.bg-secondary:focus, button.bg-secondary:hover,
	button.bg-secondary:focus {
	background-color: #bac9ff !important;
}

body {
	background: #161616;
	color: #ffffff;
	font-weight: bold !important;
	font-size: 20px;

}

p {
	margin:-5px -5px -5px 0px !important;
}

.modal-header {
	border-bottom: none !important;
}

.modal-footer {
	border-top: none !important;
	text-align: center !important;
}

.find-btn1 {
	display: inline-block !important;
}

.bd-placeholder-img {
	font-size: 1.125rem;
	text-anchor: middle;
	-webkit-user-select: none;
	-moz-user-select: none;
	-ms-user-select: none;
	user-select: none;
}

@media ( min-width : 768px) {
	.bd-placeholder-img-lg {
		font-size: 3.5rem;
	}
}
</style>
<script>
$(document).ready(function() {

	$("button[data-dismiss=modal]").click(function()
	{
		$(".modal").modal('hide');
	});
	
	$(".btn.btn-primary.btn-plus").prop("disabled", false);  
	
	let quantity = parseInt($(".quantity_input").val()); 
	const maxProductQuan = $("#maxProductQuan").val();
	
	$(".quantity_input").on("propertychange change keyup paste input", function() {	    
	    let inputValue = $(this).val();

	    // 숫자 이외의 문자를 제거합니다.
	    inputValue = inputValue.replace(/\D/g, '');

	    // 0으로 시작할 경우 0 제거
	    inputValue = inputValue.replace(/^0+/, '');

	    // 입력값이 재고보다 크면 재고값으로 변경합니다.
	    if (parseInt(inputValue) > parseInt(maxProductQuan)) {
	        inputValue = "";
	        Swal.fire('재고가 부족합니다. 재고 : ' + maxProductQuan, '', 'warning');
	    }
	    
	    // 입력란에 수정된 값을 설정합니다.
	    $(this).val(inputValue);
	    
	    quantity = inputValue;
	});
	
	$(".btn.btn-primary.btn-plus").on("click", function() {
		quantity = parseInt(quantity) + 1; 	
		
		// 입력값이 재고보다 크면 재고값으로 변경합니다.
		if (quantity > parseInt(maxProductQuan)) 
		{
			quantity = 1;
			Swal.fire('재고가 부족합니다. 재고 : ' + maxProductQuan, '', 'warning');
			$(".btn.btn-primary.btn-plus").prop("disabled",true);
			console.log("quantity",quantity);
			console.log("maxProductQuan",maxProductQuan);
		}
		
		$(".btn.btn-primary.btn-plus").prop("disabled", false); 
		
		// quantity 값을 1 증가시키고 입력란에 설정
		console.log("quantity",quantity);
		$(".quantity_input").val(quantity);
	});
	
	$(".btn.btn-secondary.btn-minus").on("click", function() {
		if (quantity > 1) 
		{
			// quantity 값을 1 감소시키고 입력란에 설정
			quantity = quantity - 1;
			$(".quantity_input").val(quantity);
		}
	})
	       
	$("#cart").on("click", function() {
		var totalPrice = parseInt($("#price").val())*parseInt($(".quantity_input").val());
		
		$.ajax({
			type: "POST",
			url: "/product/cartCheck",
			data: {
				userId:$("#userId").val(),
			 	productSeq:$("#productSeq").val()
			},
			datatype:"JSON",
			beforeSend:function(xhr){
				xhr.setRequestHeader("AJAX", "true");
			},
			success:function(response){
				if(response.code == 0)
				{
					$.ajax({
						type:"POST",
						url:"/prodcut/cartProc",
						data:{
							 userId:$("#userId").val(),
							 productSeq:$("#productSeq").val(),
							 productName:$("#productName").val(),
							 cartQuantity:quantity,
							 cartPrice:totalPrice
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
					    		$("#exampleModalCenter").modal("show");					    		
					   		}
					    	else if(response.code == 300)
				    		{
					    		Swal.fire('재고가 부족합니다.', '', 'warning');
				    		}
					    	else
					   		{
					   			Swal.fire('게시물 등록 중 오류 발생', '', 'warning');
					   		}
					    },
					    error:function(xhr,status,error)
					    {
					    	icia.common.error(error);
					    }							
					});
				}
				else if(response.code == 100)
				{
					$("#babo").modal("show");
				}
			},
			error:function(xhr, status, error)
			{
			    icia.common.error(error);
			}
		});
	});
});
	
//닫기 버튼 클릭시 리스트페이지로 이동
function fn_list()
{
	document.productForm.action = "/product/productList";
	document.productForm.submit();
}

//페이지 클릭시
function fn_list2(curPage)
{
	document.productForm.reviewSeq= "";
	document.productForm.curPage.value = curPage;
	document.productForm.action = "/product/productDetail";
	document.productForm.submit();
}

function fn_cart()
{
	document.productForm.action = "/product/productCart";
	document.productForm.submit();
}
   
function fn_update()
{
	$.ajax({
		type: "POST",
		url: "/product/cartQuantityUpdate",
		data: {
			userId:$("#userId").val(),
			productSeq:$("#productSeq").val()
		},
		datatype:"JSON",
		beforeSend:function(xhr){
			xhr.setRequestHeader("AJAX", "true");
		},
		success:function(response)
		{
			if(response.code == 0)
			{
				location.href ="/product/productCart";
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
 
}
   
function checkOut() 
{
	var quantity = parseInt($(".quantity_input").val());
	document.productForm.quantity.value=quantity;
	document.productForm.action = "/product/productCheckOutDirect";
	document.productForm.submit();
}
   
function fn_update1(val)
{
	document.reviewForm.reviewSeq.value=val;
	document.reviewForm.action = "/product/reviewUpdate";
	document.reviewForm.submit();
}
	
function fn_delete(val){
    Swal.fire({
        title: '리뷰를 삭제하시겠습니까?',
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: '확인',
        cancelButtonText: '취소'
    }).then((result) => {
        if (result.isConfirmed) {
			$.ajax({
					type:"POST",
					url:"/product/reviewDelete",
					data:{
						reviewSeq:val
					},
					datatype:"JSON",
					beforeSend:function(xhr){
						xhr.setRequestHeader("AJAX", "true");
					},
					success:function(response){
						if(response.code == 0){
							Swal.fire({title: '리뷰가 삭제되었습니다.', 
			                       		icon: 'success'
			               	}).then(function(){
								location.href="/product/productList";
			              	 })
						}
						else if(response.code == 400){
							Swal.fire('파라미터 값일 올바르지 않습니다.', '', 'warning');
						}
						else if(response.code == 403){
							Swal.fire('본인의 리뷰가 아니므로 삭제할 수 없습니다.', '', 'warning');
						}
						else if(response.code == 404){					
							Swal.fire({title: '해당 리뷰를 찾을 수 없습니다.', 
			                       icon: 'warning'
			               	}).then(function(){
			            	   location.href="/product/productList";
			               	})
						}
						else{
							Swal.fire('리뷰 삭제 중 오류가 발생하였습니다.', '', 'warning');
						}
					},
					error:function(xhr, status, error)
					{
						icia.common.error(error);
					}
				});

        }

    })
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
							<h1>상품 구매</h1>
						</div>
						<div class="gen-breadcrumb-container">
							<ol class="breadcrumb">
								<li class="breadcrumb-item"><a href="index.html"> <i
										class="fas fa-home mr-2"></i> 홈
								</a></li>
								<li class="breadcrumb-item active">상품 구매</li>
							</ol>
						</div>
					</nav>
				</div>
			</div>
		</div>
	</div>
	<!-- breadcrumb -->

	<!-- Shop Detail Start -->
	<div class="container-fluid py-5" style="width: 80%;">
		<i class="fa fa-times" aria-hidden="true"
			style="float: right; cursor: pointer;" onclick="fn_list()"></i>
		<div class="row px-xl-5">
			<div class="col-lg-5 pb-5">
				<div id="product-carousel" class="carousel slide"
					data-ride="carousel">
					<div class="carousel-inner border">
						<div class="carousel-item active">
							<img class="w-100 h-100"
								src="/resources/upload/product/${product.productSeq}.png"
								alt="Image">
						</div>
					</div>
				</div>
			</div>

			<div class="col-lg-7 pb-5" style="margin: auto;!important;">
				<h3 class="font-weight-semi-bold">${product.productName}</h3>
				<div class="d-flex mb-3">
					<small class="pt-1"> <c:choose>
							<c:when test="${reviewCnt ne null}">(${reviewCnt}</c:when>
							<c:otherwise>(0</c:otherwise>
						</c:choose> Reviews)
					</small>
				</div>
				<h3 class="font-weight-semi-bold mb-4">
					&#8361;
					<fmt:formatNumber type="number" maxFractionDigits="3" value="${product.productPrice}" />
				</h3>

				<div class="align-items-center mb-4 pt-2">
					<div class="input-group quantity mr-3">
						<div class="container">
							<div class="row">
								<div class="col-3">
									<input type="text" class="quantity_input" value="1"
										id="quantity_input" name="pop_out" style="text-align: center;" />
								</div>
								<div class="col-0 mr-1 pt-1">
									<button class="btn btn-secondary btn-minus">
										<i class="fa fa-minus"></i>
									</button>
								</div>
								<div class="col-0 pt-1">
									<button class="btn btn-primary btn-plus">
										<i class="fa fa-plus"></i>
									</button>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="container">
					<div class="row">
						<div class="col-0">
							<button class="btn btn-primary mr-2 px-3" id="cart">
								<i class="fa fa-shopping-cart mr-1"></i> 장바구니
							</button>
						</div>
						

						<div class="col-0">
							<button class="btn btn-primary px-3 " onclick="checkOut()">
								<i class="fa fa-credit-card" aria-hidden="true"></i> 바로 결제
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="row px-xl-5">
			<div class="col">
				<div
					class="nav nav-tabs justify-content-center border-secondary mb-4">
						<a class="nav-item nav-link active" data-toggle="tab" href="#tab-pane-1" style="color:#007bff;">상세정보</a> 
						    <a class="nav-item nav-link" data-toggle="tab" href="#tab-pane-2" style="color:#007bff;">상품리뷰 
						    <c:choose>
						        <c:when test="${reviewCnt ne null}">(${reviewCnt})</c:when>
						        <c:otherwise>(0)</c:otherwise>
						    </c:choose>
						</a>
				</div>
				<div class="tab-content">
					<div class="tab-pane fade show active" id="tab-pane-1">
						<h4 class="mb-3">${product.productName}</h4>
						<p>${product.productDetail}</p>
					</div>
					<div class="tab-pane fade" id="tab-pane-2">
						<div class="row">
							<div class="col-md-12">
								<div class="media mb-4">
									<!-- <img src="img/user.jpg" alt="Image" class="img-fluid mr-3 mt-1" style="width: 45px;">-->
									<div class="media-body">
										<c:if test="${!empty list}">
											<c:forEach var="review" items="${list}">
												<!-- 데이터가 있을 때만 보임 -->
												<h6>
													${review.userId}<small> - <i>${review.regDate}</i></small>
												</h6>
												<c:if test="${!empty user.userId && user.userId == review.userId}">
													<c:set var="reviewSeq" value="${review.reviewSeq}" />

													<div class="btn-group" role="group" aria-label="Basic example" style="float: right;">
														<button type="button" class="btn btn-light" id="btnUpdate" onclick="fn_update1(${review.reviewSeq})">수정</button>
													</div>
												</c:if>
												<!-- 
                                        		<div class="text-primary mb-2">
                                            		<i class="far fa-star"></i>
	                                        		<i class="far fa-star"></i>
	                                        		<i class="far fa-star"></i>
	                                        		<i class="far fa-star"></i>
	                                        		<i class="far fa-star"></i>
                                        		</div>
                                        		 -->
												<p>${review.reviewContent}</p><br>
											</c:forEach>
										</c:if>
										<!-- 리스트가 비어있으면 시작 -->
                                          <div style="margin-left:45% !important; margin-top:50px !important;">
                                             <c:if test="${empty list}">
                                                <i class="fa fa-exclamation-circle fa-4x" aria-hidden="true" style="left:-100px !important;"></i>
                                                <h6 class="mt-3" style="margin-left:-10% !important;">작성된 리뷰가 없습니다.</h6>
                                             </c:if>
                                          </div>
                                          <!-- 리스트가 비어있으면 끝 -->
									</div>
								</div>
							</div>

							<!-- 페이징 처리 시작 -->
							<div class="col-lg-12 col-md-12" style="margin: 0 auto;">
								<div class="gen-pagination" style="text-align: center;">
									<nav aria-label="Page navigation"
										style="display: inline-block;">
										<ul class="page-numbers">
											<c:if test="${!empty paging}">
												<c:if test="${paging.prevBlockPage gt 0}">
													<li><a class="next page-numbers"
														href="javascript:void(0)"
														onclick="fn_list2(${paging.prevBlockPage})">이전블럭</a></li>
												</c:if>

												<c:forEach var="i" begin="${paging.startPage}"
													end="${paging.endPage}">
													<c:choose>
														<c:when test="${i ne curPage}">
															<li><a class="page-numbers"
																href="javascript:void(0)" onclick="fn_list2(${i})">${i}</a>
															</li>
														</c:when>
														<c:otherwise>
															<li><a class="page-numbers"
																href="javascript:void(0)" style="cursor: default;">${i}</a>
															</li>
														</c:otherwise>
													</c:choose>
												</c:forEach>
												<c:if test="${paging.nextBlockPage gt 0}">
													<li><a class="next page-numbers"
														href="javascript:void(0)"
														onclick="fn_list2(${paging.nextBlockPage})">다음블럭</a></li>
												</c:if>
											</c:if>
										</ul>
									</nav>
								</div>
							</div>
							<br> <br> <br>
							<!-- 페이징 처리 끝 -->
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- Shop Detail End -->


	<form name="productForm" id="productForm" method="post">
		<input type="hidden" name="userId" id="userId" value="${user.userId}" />
		<input type="hidden" name="productSeq" id="productSeq" value="${product.productSeq}" /> 
		<input type="hidden" name="quantity" id="quantity" value="" /> 
		<input type="hidden" name="productName" id="productName" value="${product.productName}" />
		<input type="hidden" name="price" id="price" value="${product.productPrice}" /> 
		<input type="hidden" name="reviewSeq" id="review" value="" /> 
		<input type="hidden" name="curPage" value="${curPage}" /> 
		<input type="hidden" name="maxProductQuan" id="maxProductQuan" value="${maxProductQuan}" />
	</form>

	<form name="reviewForm" id=reviewForm method="post">
		<input type="hidden" id="reviewSeq" name="reviewSeq" value="">
	</form>

	<%@ include file="/WEB-INF/views/include/footer.jsp"%>
	<!-- Modal -->
	<div class="modal fade" id="babo" tabindex="-1" role="dialog"
		aria-labelledby="babo" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered" role="document">
			<div class="modal-content">

				<div class="modal-body mt-3" align="center"
					style="color: #000000 !important">장바구니에 동일한 상품이 있습니다.
					추가하시겠습니까?</div>
				<div class="modal-footer"
					style="display: flex; justify-content: center;">
					<button type="button" style="display: inline-block;"
						class="btn btn-secondary find-btn1" data-dismiss="modal" >쇼핑
						계속하기</button>
					<button type="button" onclick="fn_update()"
						style="display: inline-block;"
						class="btn btn-primary find-btn1">장바구니 이동</button>
				</div>
			</div>
		</div>
	</div>
	<!-- Modal -->
	<div class="modal fade" id="exampleModalCenter" tabindex="-1"
		role="dialog" aria-labelledby="exampleModalCenterTitle"
		aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered" role="document">
			<div class="modal-content">

				<div class="modal-body mt-3" align="center"
					style="color: #000000 !important">장바구니에 상품이 정상적으로 담겼습니다.</div>
				<div class="modal-footer"
					style="display: flex; justify-content: center;">
					<button type="button" style="display: inline-block;"
						class="btn btn-secondary find-btn1" data-dismiss="modal" ">쇼핑
						계속하기</button>
					<button type="button" onclick="fn_cart()"
						style="display: inline-block;"
						class="btn btn-primary find-btn1">장바구니 이동</button>
				</div>
			</div>
		</div>
	</div>
</body>
</html>