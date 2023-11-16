<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>

<style>
.icon{
   width:50px;
   filter: invert(100%);
   margin-top:80px;
   float:left;
}

.pCss{
   margin-top:140px;
   margin-left:-15px;
}

.pCss2{
   margin-top:140px;
   margin-left:-10px;
}

.hCss{
   margin-top:-30px;
   margin-left:-20px;
}
</style>

<script>

function setUserFee(){	
	Swal.fire({
        title: '작가 신청하시겠습니까?',
        html: '작가 신청비는 5만원입니다. <br> 관리자의 승인 후 작가로 활동이 가능하고 <br>승인은 최대 3일이 소요됩니다.',
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
				url:"/user/pointProc",
				data:{
					 userId:$("#userId2").val(),
					 amount:50000,
					 orderTotalQuantity:1,
					 itemCode:2,
					 itemName:'작가비'
					 
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
						$("#gubunCheck").val('gubunCheckFee');
						console.log("orderId",orderId);
					    console.log("tId:", tId);  
					    console.log("pcUrl:", pcUrl);					    
					    
						var win = window.open('','kakaoPopUp',
								'toolbar=no,location=no,status=no,menubar=no,scrollbars=yes,resizable=no,width=540,height=700,left=100,top=100');
						
						$("#kakaoForm").submit();
			   		}
			    	else if(response.code == 100)
		    		{
			    		Swal.fire({title: '카카오페이 결제에 실패했습니다.', 
		                       		icon: 'warning'
		               	}).then(function(){
		            	   location.href="/myPage/myPageMain";
		               	})
		    		}
			    	else if(response.code == 200)
			   		{
			   			Swal.fire('결제 테이블에 입력되지 않았습니다.', '', 'warning');
			   		}
			    	else if(response.code == 300)
			   		{
			    		Swal.fire('주문상세테이블에 입력되지 않았습니다.', '', 'warning');
			   		}
			    	else if(response.code == 400)
			   		{			   			
			   			Swal.fire('주문테이블에 입력되지 않았습니다.', '', 'warning');
			   		}
			    	else
		    		{
			    		Swal.fire('0원이상 입력해주세요.', '', 'warning');
		    		}
			    },
			    error:function(xhr,status,error)
			    {
			    	icia.common.error(error);
			    	Swal.fire('카카오페이 결제에 실패했습니다.', '', 'warning');
			    }
						
				});
		   }

	})
}   
function movePage()
{
   location.href = "/myPage/myPageMain";
}
</script>

</head>
<body>
<%@ include file="/WEB-INF/views/include/navigation.jsp"%>

   <!-- breadcrumb -->
   <div class="gen-breadcrumb" style="background-image: url('/resources/images/background/back.png');">
      <div class="container">
         <div class="row align-items-center">
            <div class="col-lg-12">
               <nav aria-label="breadcrumb">
                  <div class="gen-breadcrumb-title">
                     <h1>마이페이지</h1>
                  </div>
                  <div class="gen-breadcrumb-container">
                     <ol class="breadcrumb">
                        <li class="breadcrumb-item">
                           <a href="index.html"> 
                              <i class="fas fa-home mr-2"></i>홈
                           </a>
                        </li>
                        <li class="breadcrumb-item active">마이페이지</li>
                     </ol>
                  </div>
               </nav>
            </div>
         </div>
      </div>
   </div>
   <!-- breadcrumb -->
   
   <!-- Blog-left-Sidebar -->
   <section class="gen-section-padding-3">
      <div class="container">
         <div class="row">
         
				<!-- 사이드바 시작 -->
					<div class="col-xl-3 col-md-12 order-2 order-xl-1 mt-4 mt-xl-0" style="width:20%;">
						<div class="widget widget_recent_entries">
							<h2 class="widget-title"><a href="/myPage/myPageMain">마이페이지</a></h2>
							<ul>
								<li><a href="/myPage/userUpdate">회원정보수정</a></li>
								<li><a href="/myPage/myPagePay">결제내역</a></li>	
								<li><a href="/myPage/myPageVote">투표내역</a></li>	
								<li><a href="/myPage/myPageAucCur">입찰내역</a></li>
								<li><a href="/myPage/myPageQna">문의내역</a></li>
								<c:if test="${user.userCode == 'A'}">
								<li><a href="/myPage/myPageVoteUpload">투표작품신청내역</a></li>
								<li><a href="/myPage/artAucResult">경매결과내역</a></li>
								</c:if>
							</ul>
						</div>
					</div>
	            <!-- 사이드바 끝 -->
            
            <!-- 문의내역 시작 -->
            <div class="col-xl-9 col-md-12 order-1 order-xl-2">
               <div class="gen-blog gen-blog-col-1">
                  <div class="row">
                     <div class="col-lg-12">
                        <div class="row">
                           
                           <!-- 마이페이지 메인 1개 시작 -->
                           <div class="col-md-12">
                              <div class="row no-gutters border rounded overflow-hidden flex-md-row mb-4 shadow-sm h-md-250 position-relative">
                                 <div class="col-md-8 mt-5 mb-5">
                                    <div style="margin-left:130px;">
                                       <c:if test="${user.userCode ne 'A'}">
                                          <strong class="d-inline-block mb-2 text-primary">일반 회원</strong>
                                       </c:if>                                      
                                       <c:if test="${user.userCode eq 'A'}">
                                          <strong class="d-inline-block mb-2 text-primary">작가</strong>
                                       </c:if>
                                       <h3 class="mb-0">${user.userId}님 안녕하세요</h3>
                                       <div class="mb-1 text-muted">${user.userNick}</div>
                                       <p class="card-text mb-auto">저희 ASAP 사이트를 방문해주셔서 진심으로 감사드립니다.</p>
                                       <a href="/myPage/userUpdate" class="stretched-link" style="color:#007bff;">회원정보수정</a>
                                    </div>
                                 </div>
                                 <div class="col-md-2">
                                    <a href="/user/rechargePoints" style="color:#ffffff;">
                                       <img class="icon" src="/resources/images/svg/point.svg" alt="icon"/>
                                       <p class="pCss">포인트 충전 <i class="fa fa-angle-right" aria-hidden="true"></i></p>
                                       <h5 class="hCss"><fmt:formatNumber type="number" maxFractionDigits="3" value="${user.userCharge}" />P</h5>
                                    </a>
                                 </div>
                                 <div class="col-md-2">
                                    <c:if test="${user.userCode == 'U'}">
                                    
                                    <button onClick="setUserFee()" style="background-color:transparent; border:none;  outline: none;">
                                       <a style="color:#ffffff;">
                                          <img class="icon" src="/resources/images/svg/pay.svg" alt="icon"/>
                                          <p class="pCss2">작가 신청 <i class="fa fa-angle-right" aria-hidden="true"></i></p>
                                          <h5 class="hCss">₩<fmt:formatNumber type="number" maxFractionDigits="3" value="50000" /></h5>
                                       </a>
                                       </button>
                                    </c:if>
                                    <c:if test="${user.userCode == 'W'}">
                                    
                                       <a style="color:#ffffff;">
                                          <img class="icon" src="/resources/images/svg/pay.svg" alt="icon"/>
                                          <p class="pCss2">작가 신청 <i class="fa fa-angle-right" aria-hidden="true"></i></p>
                                          <p class="hCss" style="color: yellow">관리자가 확인중입니다.</p>
                                       </a>
                                    </c:if>
                                 </div>
                              </div>
                           </div>
                           <!-- 마이페이지 메인 1개 끝 -->                          
                        </div>
                     </div>
                  </div>
               </div>
            </div>
         </div>
      </div>
   </section>
   
   
   <!-- Modal -->
				<div class="modal fade" id="exampleModalCenter1" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle1" aria-hidden="true">
				  <div class="modal-dialog modal-dialog-centered" role="document">
				    <div class="modal-content">
				      
				      <div class="modal-body mt-3" align="center" style="color:#000000 !important">
				        장바구니에 상품이 정상적으로 담겼습니다. 
				      </div>
				      <div class="modal-footer" style="display: flex; justify-content: center;">
				        <button type="button" style=" display: inline-block;" class="btn btn-secondary find-btn1" data-dismiss="modal">쇼핑 계속하기</button>
				        <button type="button" onclick="fn_cart()" style=" display: inline-block;"  class="btn btn-primary find-btn1">장바구니 이동</button>
				      </div>
				    </div>
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