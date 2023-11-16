<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<style>
/*** Store ***/
.store-item .store-overlay {
   position: absolute;
   top: 0;
   left: 0;
   width: 100%;
   height: 100%;
   display: flex;
   flex-direction: column;
   align-items: center;
   justify-content: center;
   background: rgba(152, 193, 217, .3);
   opacity: 0;
   transition: .5s;
}

.store-item:hover .store-overlay {
   opacity: 1;
}
</style>

<script>

$(document).ready(function() {
	$("button[data-dismiss=modal]").click(function()
	{
		$(".modal").modal('hide');
		$("#cartCount").load("/product/productCart #cartCount");		 
	});
});
function addCart(productSeq) {
    $.ajax({
        type: "POST",
        url: "/product/cartCheck",
        data: {
            userId: $("#userId").val(),
            productSeq: productSeq
        },
        datatype: "JSON",
        beforeSend: function (xhr) {
            xhr.setRequestHeader("AJAX", "true");
        },
        success: function (response) {
            if (response.code == 0) {
                $.ajax({
                    type: "POST",
                    url: "/prodcut/cartProc1",
                    data: {
                        userId: $("#userId").val(),
                        productSeq: productSeq
                    },
                    datatype: "JSON",
                    beforeSend: function (xhr) {
                        xhr.setRequestHeader("AJAX", "true");
                    },
                    success: function (response) {
                        if (response.code == 0) {
                        	$("#cartCount").load(location.href + " #cartCount");
                            $("#exampleModalCenter1").modal('show');
                        } else {
                            Swal.fire('게시물 등록 중 오류 발생', '', 'warning');
                        }
                    },
                    error: function (xhr, status, error) {
                        icia.common.error(error);
                        Swal.fire('게시물 등록 중 오류가 발생하였습니다.', '', 'warning');
                    }
                });
            } else if (response.code == 100) {
                /*Swal.fire({title: '장바구니에 동일한 상품이 있습니다.', 
                    		icon: 'warning'
            	}).then(function(){
                	location.href = "/product/productList";
            	})*/
            	Swal.fire('장바구니에 동일한 상품이 있습니다.', '', 'warning');
            	
            }
        },
        error: function (xhr, status, error) {
            icia.common.error(error);
        }
    });
}

//작품 클릭시 상세페이지 이동
function fn_detail(productSeq) 
{
   document.productForm.productSeq.value = productSeq;
   document.productForm.action = "/product/productDetail";
   document.productForm.submit();
}
function fn_list()
{
 document.productForm.action = "/product/productList";
 document.productForm.submit();
}
function fn_cart()
{
   document.productForm.action = "/product/productCart";
   document.productForm.submit();
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
                     <h1>상품</h1>
                  </div>
                  <div class="gen-breadcrumb-container">
                     <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="index.html"> <i
                              class="fas fa-home mr-2"></i> 홈
                        </a></li>
                        <li class="breadcrumb-item active">파생 상품</li>
                     </ol>
                  </div>
               </nav>
            </div>
         </div>
      </div>
   </div>
   <!-- breadcrumb -->

   <!-- Store Start -->
   <div class="container-xxl py-5">
      <div class="container" style="width:80%;">
         <div class="row g-4">
            <!-- 상품 1개 시작 -->
            <c:if test="${!empty list}">
               <c:forEach var="product" items="${list}" varStatus="status">
                  <div class="col-lg-4 col-md-6 wow fadeInUp mb-3" data-wow-delay="0.1s">
                     <div class="store-item position-relative text-center">
                        <img class="img-fluid"
                           src="/resources/upload/product/${product.productSeq}.png"
                           alt="">
                        <div class="p-4">
                        <!-- 
                           <div class="text-center mb-3">
                              <small class="fa fa-star text-primary"></small> <small
                                 class="fa fa-star text-primary"></small> <small
                                 class="fa fa-star text-primary"></small> <small
                                 class="fa fa-star text-primary"></small> <small
                                 class="fa fa-star text-primary"></small>
                           </div>
                            -->
                           <h5 class="mb-3">${product.productName}</h5>
                           <!-- <p style="font-size:10px;">${product.productDetail}</p> -->
                           <h5 class="text-primary">
                              &#8361;<fmt:formatNumber type="number" maxFractionDigits="3" value="${product.productPrice}" />
                           </h6>
                        </div>
                        <div class="store-overlay">
                           <a onclick="fn_detail(${product.productSeq})" class="btn btn-primary rounded-pill py-2 px-4 m-2" style="font-size:20px;">자세히 보기
                              <i class="fa fa-arrow-right ms-2"></i>
                           </a> 
                           <a onclick="addCart(${product.productSeq})" class="btn btn-dark rounded-pill py-2 px-4 m-2" style="font-size:20px;">장바구니 담기 
							   <i class="fa fa-cart-plus ms-2"></i>
						   </a>                            
                        </div>                        
                     </div>
                  </div> 
                 
               </c:forEach>
            </c:if>
            <!-- 상품 1개 끝 -->
		</div>
      </div>
   </div>
   <!--  Store End  -->
 
       
	  <form name="productForm" id="productForm" method="post">
		  <input type="hidden" name="productSeq" id="productSeq" value="" />
	      <input type="hidden" name="userId" id="userId" value="${user.userId}" />    
      </form>
<%@ include file="/WEB-INF/views/include/footer.jsp"%>

	<!-- Modal -->
	<div class="modal fade" id="exampleModalCenter1" tabindex="-1"
		role="dialog" aria-labelledby="exampleModalCenterTitle1"
		aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered" role="document">
			<div class="modal-content">

				<div class="modal-body mt-3" align="center"
					style="color: #000000 !important">장바구니에 상품이 정상적으로 담겼습니다.</div>
				<div class="modal-footer"
					style="display: flex; justify-content: center;">
					<button type="button" style="display: inline-block;"
						class="btn btn-secondary find-btn1" data-dismiss="modal">쇼핑계속하기</button>
					<button type="button" onclick="fn_cart()"
						style="display: inline-block;" class="btn btn-primary find-btn1">장바구니 이동</button>
				</div>
			</div>
		</div>
	</div>

</body>
</html>