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
</head>
<body >
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
   <div style="margin:0 auto; width:30%">
   <form class="mb-5" action="">
               <h4 class="font-weight-semi-bold mt-5 m-0 mb-3">포인트 충전</h4>
                    <div class="input-group">
                        <input type="text" class="point_input form-control p-4" value="0">
                    </div>
                    <small>
                       보유 포인트 : <i>&#8361;<fmt:formatNumber type="number" maxFractionDigits="3" value="1" /></i> 
                       &nbsp;
                       
                    </small>
    </form>
    <div class="card mb-5" style="border-color:#3D4F74;">
               <div class="card-header border-0" style="background-color:#3D4F74;">
                  <h4 class="font-weight-semi-bold m-0" >결제</h4>
               </div>
               <div class="card-body">
                  <div class="form-group">
                     <div class="custom-control custom-radio">
                        <input type="radio" class="custom-control-input" name="payment" id="paypal" checked> 
                        <label class="custom-control-label" for="paypal">카카오페이</label>
                     </div>
                  </div>
               </div>
               <div class="card-footer bg-transparent" style="border-color:#3D4F74;">
                  <button class="btn btn-lg btn-block font-weight-bold my-3 py-3 pay" style="background-color:#3D4F74; color:#ffffff;" onclick="setOrderInfo()">결제하기</button>
               </div>               
            </div>
      </div>
</body>
</html>