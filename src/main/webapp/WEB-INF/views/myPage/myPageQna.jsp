<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<style>
th, td {
   border-color: transparent !important;
}

td{
	text-align:left !important;
	color: white !important;
}
</style>

<script>
function fn_detail(qaSeq)	{
	document.bbsForm.qaSeq.value=qaSeq;
	document.bbsForm.action="/myPage/myPageQnaDetail";
	document.bbsForm.submit();
}

function fn_list(curPage){
	document.bbsForm.qaSeq.value="";	
	document.bbsForm.curPage.value = curPage;
	document.bbsForm.action="/myPage/myPageQna";
	document.bbsForm.submit();
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
                     <h1>문의내역</h1>
                  </div>
                  <div class="gen-breadcrumb-container">
                     <ol class="breadcrumb">
                        <li class="breadcrumb-item">
                           <a href="index.html"> 
                              <i class="fas fa-home mr-2"></i>홈
                           </a>
                        </li>
                        <li class="breadcrumb-item active">문의내역</li>
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
                        <hr>
                        <div class="container bootstrap snippets bootdey">
                           <div class="row">
                              <div class="col-lg-12 mt-3 mb-3">
                                 <h3>문의내역</h3>
                              </div>
                           </div>
                           <div class="row">
                              <!--/col-3-->
                              <div class="col-lg-12">
                                 <div class="table-responsive" style="color: #ffffff;">
                                    <table class="table" style="color: #ffffff;">
                                       <thead style="background-color: rgba(61,79,115,0.3); color: #ffffff;">
                                          <tr>
                                          	 <th></th>
                                             <th>문의 내역</th>
                                             <th></th>
                                          </tr>
                                       </thead>
										<tbody>
											<c:if test="${!empty list}">
											<c:set var="startNum" value="${paging.startNum}" />
												<c:forEach var="qnaBoard" items="${list}" varStatus="status">																					
											<tr>
												<c:choose>
													<c:when test="${qnaBoard.qaIndent == 0 }">
														<!-- indent가 0일때 -->
														<td class="text-center">${startNum}</td>
													</c:when>
													<c:otherwise>
														<!-- indent가 0이 아닐 때 -->
														<td class="text-center"></td>
													</c:otherwise>
												</c:choose>
																							
												<td>
													<a href="javascript:void(0)" onclick="fn_detail(${qnaBoard.qaSeq})" style="color:#ffffff">
													<c:if test="${empty qnaBoard.userId}">
														<strong id="userId" name="userId">관리자</strong>
													</c:if>
														<strong id="userId" name="userId">${qnaBoard.userId}</strong>
														<span id="regDate" name="regDate">${qnaBoard.regDate}</span>
														<div>
														<c:if test="${qnaBoard.qaIndent>0}">
															<img src = "/resources/images/right.png" style="margin-left:${qnaBoard.qaIndent}em; margin-top:-7px !important;"/>
														</c:if>
															<span id="qaTitle" name="qaTitle">${qnaBoard.qaTitle}</span>
														</div>
													</a>
												</td>
											</tr>
											
												<c:set var="startNum" value="${startNum-1}"></c:set>
												</c:forEach>
											</c:if>
                                       </tbody>
                                    </table>
                                    
	                                <!-- 리스트가 비어있으면 시작 -->
									<div style="margin-left:45% !important; margin-top:65px !important;">
										<c:if test="${empty list}">
											<i class="fa fa-exclamation-circle fa-4x" aria-hidden="true" style="left:-100px !important;"></i>
											<h6 class="mt-3" style="margin-left:-10% !important;">조회된 내역이 없습니다.</h6>
										</c:if>
									</div>
									<!-- 리스트가 비어있으면 끝 -->
                                    
                          <div class="col-lg-12 col-md-12" style="margin: 0 auto;">
							<div class="gen-pagination" style="text-align: center;">
								<nav aria-label="Page navigation" style="display: inline-block;">
									<ul class="page-numbers">
										<c:if test="${!empty paging}">
											<c:if test="${paging.prevBlockPage gt 0}">
												<!-- greater than, less than -->
												<li><<a class="next page-numbers" href="javascript:void(0)"
													onclick="fn_list(${paging.prevBlockPage})">이전블럭</a></li>
											</c:if>

											<c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
												<c:choose>
													<c:when test="${i ne curPage}">
														<!-- not equal -->
														<li><a class="page-numbers" href="javascript:void(0)"
															onclick="fn_list(${i})">${i}</a></li>
													</c:when>
													<c:otherwise>
														<li><a class="page-numbers" href="javascript:void(0)"
															style="cursor: default;">${i}</a></li>
													</c:otherwise>
												</c:choose>
											</c:forEach>
											<c:if test="${paging.nextBlockPage gt 0}">
												<li><a class="next page-numbers"
													href="javascript:void(0)"
													onclick="fn_list(${paging.nextBlockPage})">다음블럭</a></li>
											</c:if>
										</c:if>
									</ul>
								</nav>
							</div>
						</div>      
                                    
                                 </div>
                              </div>
                           </div>
                           <!--/col-9-->
                        </div>
                        <!--/row-->
                     </div>
                  </div>
               </div>
            </div>
            <!-- 문의내역 끝 -->
         </div>
      </div>
   </section>
   <!-- Blog-left-Sidebar -->
   
   <form name="bbsForm" id="bbsForm" method="post">
      <input type="hidden" name="qaSeq" id="qaSeq" value="" />
      <input type="hidden" name="curPage" value="${curPage}" />
   </form>

   <%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>