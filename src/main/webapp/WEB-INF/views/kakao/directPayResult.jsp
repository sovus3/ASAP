<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<link rel="stylesheet" href="/resources/css/progress-bar.css" type="text/css">
<style>
/* Desgin Areas */
.info div {
   display: flex;
   margin: 10px 0;
}

.info dt {
   width: 30%;
}

.info dt:after {
   content: ' :';
}

.info dd {
   width: 70%;
   text-align: right;
}

.price:before {
   content: '￦';
}

/* Design Areas */
body {
   background-color: #ccc;
   color: #555;
   font-family: 'Fredoka', sans-serif;
   font-weight: 300;
   font-size: 15px;
}

.wrap {
   background-color: #f4f4f4;
   width: 500px;
   padding: 20px;
   position: absolute;
   top: 50%;
   left: 50%;
   transform: translate(-50%, -50%);
   box-shadow: 0px 2px 15px rgba(0, 0, 0, 0.2);
}

header {
   margin: 20px 0;
}

h1 {
   text-align: center;
   border-bottom: dashed 4px #666;
   padding-bottom: 30px;
}

main {
   border-top: dotted 4px #aaa;
   border-bottom: dotted 4px #aaa;
   padding: 20px 0;
}

main table col:first-child {
   width: 50%;
}

main table col:nth-child(2) {
   width: 10%;
}

main table col:nth-child(3) {
   width: 20%;
}

main table col:last-child {
   width: 20%;
}

main table th {
   text-align: right;
}

main table th:first-child {
   text-align: left;
   text-indent: -3px;
}

main table td {
   text-align: right;
   padding: 10px 0;
}

main table td:first-child {
   text-align: left;
}

main table td:nth-child(2) {
   text-align: center;
}

footer .discount {
   margin: 20px 0;
}

footer .total {
   border-top: dashed 4px #666;
   border-bottom: dashed 4px #666;
   padding: 20px 0;
}

footer .total h5 {
   color: #294273;
}

footer .total dt {
   width: 50%;
   text-align: right;
   margin-right: 20px;
}

footer .total dt:after {
   content: '';
}

footer .total dd {
   width: 50%;
   text-align: left;
   margin-left: 20px;
}

footer .greeting {
   text-align: center;
   margin-top: 20px;
}

h1, h6 {
   color: #555555;
}

table, tr, th, td {
   border: none !important;
}

</style>
<script type="text/javascript">
$(document).ready(function() {
   let orderNo = $("#orderNo").val()
   console.log("orderNo",orderNo);
   
   $.ajax({
      type:"POST",
      url:"/kakao/directPayUpdate",
      data:{
         orderId:orderNo
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
             
            }
          else if(responser.code == 100)
            {
               Swal.fire('장바구니에 물품이 삭제 안되었습니다.', '', 'warning');
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
   $("#btnClose").on("click", function() {
       
      opener.movePage();
      window.close(); 
      
   });
});
</script>
</head>
<body>
<div class="wrap">
      <!-- 컨트롤러 서비스호출해서 하면 되는거야 -->
      <c:choose>
         <c:when test="${!empty kakaoPayApprove }">
            <i class="fa fa-times" aria-hidden="true" style="float: right; cursor:pointer;" id="btnClose"></i>
            <h1>영수증</h1>
            <header>
               <dl class="info">
                  <div>
                     <dt>회사</dt>
                     <dd>ASAP</dd>
                  </div>
                  <div>
                     <dt>결제일시</dt>
                     <dd>${kakaoPayApprove.approved_at}</dd>
                  </div>
                  <div>
                     <dt>주문번호</dt>
                     <dd>${kakaoPayApprove.partner_order_id}</dd>
                  </div>
               </dl>
            </header>
            <main>
               <table>
                  <colgroup>
                     <col>
                     <col>
                     <col>
                  </colgroup>
                  <tr>
                     <th>상품명</th>
                     <th>수량</th>
                     <th>결제금액</th>
                  </tr>
                  <tr>
                     <td class="ml-2">${kakaoPayApprove.item_name}</td>
                     <td>${kakaoPayApprove.quantity}</td>
                     <td><span class="price mr-2"><fmt:formatNumber type="number" maxFractionDigits="3" value="${kakaoPayApprove.amount.total}" /></span></td>
                  </tr>
               </table>
            </main>
            <footer>
               <dl class="info">
                  <div class="discount">
                     <dt>결제방법</dt>
                     <dd>${kakaoPayApprove.payment_method_type}</span>
                     </dd>
                  </div>
                  <div class="total">
                     <dt>
                        <h5>결제금액</h5>
                     </dt>
                     <dd>
                        <h5>
                           <span class="price"><fmt:formatNumber type="number" maxFractionDigits="3" value="${kakaoPayApprove.amount.total}" /></span>
                        </h5>
                     </dd>
                  </div>
               </dl>
               <p class="greeting">저희 ASAP에서 구매해주셔서 감사합니다!</p>
            </footer>
         </c:when>
         <c:otherwise>
            <i class="fa fa-times" aria-hidden="true" style="float: right; cursor:pointer;" id="btnClose2"></i>
            <h6>
               <i class="fa fa-exclamation-circle" aria-hidden="true"></i> 카카오페이 결제 중 오류가 발생하였습니다.
            </h6>
         </c:otherwise>
      </c:choose>
   </div>
   
 <form name="kakaoResultForm" id="kakaoResultForm" method="post">
      <input type="hidden" name="orderNo" id="orderNo" value="${kakaoPayApprove.partner_order_id}" />
</form>
</body>
</html>