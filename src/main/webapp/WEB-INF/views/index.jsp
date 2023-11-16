<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<style>
.btnCss {
   color:#ffffff !important;
}

.txt_line{
	width: 600px !important;
	text-overflow: ellipsis!important;
	white-space: normal !important;
	overflow: hidden !important;
	display: -webkit-box !important;
	 -webkit-box-orient: vertical !important;
	-webkit-line-clamp: 3 !important;
}

</style>

</head>
<body>
   <%@ include file="/WEB-INF/views/include/navigation.jsp"%>

   <!-- 경매 구역 시작 -->
   <section class="pt-0 pb-0">
      <div class="container-fluid px-0">
         <div class="row no-gutters">
            <div class="col-12">
               <div class="gen-banner-movies banner-style-2">
                  <div class="owl-carousel owl-loaded owl-drag" data-dots="false" data-nav="true" data-desk_num="1" data-lap_num="1" data-tab_num="1" data-mob_num="1" data-mob_sm="1" data-autoplay="true" data-loop="true" data-margin="0">
						
						<!-- 슬라이드1 시작 -->
						<c:if test= "${!empty aucList}">
							<c:forEach var="aucList" items="${aucList}" varStatus="status">
								<div class="item" style="background: url('/resources/upload/vote/${aucList.vrSeq}.png')">
									<div class="gen-movie-contain-style-2 h-100">
										<div class="container h-100">
											<div class="row flex-row-reverse align-items-center h-100">
												<div class="col-xl-6">
													<div class="gen-front-image">
														<img src="/resources/upload/vote/${aucList.vrSeq}.png" alt="owl-carousel-banner-image">
													</div>
												</div>
												<div class="col-xl-6">
													<div class="gen-tag-line">
													<c:choose>
														<c:when test="${aucList.categoryNo == 01}">
															<span>미술</span>
														</c:when>
														<c:when test="${aucList.categoryNo == 02}">
															<span>사진</span>
														</c:when>
														<c:when test="${aucList.categoryNo == 03}">
															<span>도예</span>
														</c:when>																														
													</c:choose>															
													</div>
													<div class="gen-movie-info">
														<h3>${aucList.vrTitle}</h3>
													</div>
													<div class="gen-movie-meta-holder">
														<ul class="gen-meta-after-title">
															<li class="gen-sen-rating"><span>${aucList.userName}</span></li>
														</ul>
														<p class="txt_line">${aucList.vrContent}</p>
													</div>
													<div class="gen-movie-action">
														<div class="gen-btn-container">
														<c:choose>
															<c:when test="${isUser == 'Y'}">
																<a href="/auction/auctionList" class="gen-button .gen-button-dark"> 
																	<span class="text" style="font-weight: bold; font-size: large;">경매 참여</span>
																</a>															
															</c:when>
															<c:otherwise>
																<a href="/user/logIn" class="gen-button .gen-button-dark"> 
																	<span class="text" style="font-weight: bold; font-size: large;">경매 참여</span>
																</a>
															</c:otherwise>
														</c:choose>
														</div>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</c:forEach>
						</c:if>
						<!-- 슬라이드1 끝 -->
                  </div>
               </div>
            </div>
         </div>
      </div>
   </section>
   <!-- 경매 구역 끝 -->

   <!-- 이벤트 경매 구역 시작 -->
   <section class="gen-section-padding-2">
      <div class="container">
         <div class="row">
            <div class="col-xl-6 col-lg-6 col-md-6">
               <h4 class="gen-heading-title">이벤트 경매</h4>
            </div>
            <div class="col-xl-6 col-lg-6 col-md-6 d-none d-md-inline-block">
               <div class="gen-movie-action">
                  <div class="gen-btn-container text-right">
					<c:choose>
						<c:when test="${isUser == 'Y'}">
							<a href="/auction/aucEventList" class="gen-button .gen-button-dark"> 
								<span class="text" style="font-weight: bold; font-size: large;">전체보기</span>
							</a>															
						</c:when>
						<c:otherwise>
	                     <a href="/user/logIn" class="gen-button gen-button-flat"> 
	                        <span class="text">전체보기</span>
	                     </a>
						</c:otherwise>
					</c:choose>
                  </div>
               </div>
            </div>
         </div>
         <div class="row mt-3">
            <div class="col-12">
               <div class="gen-style-2">
                  <div class="owl-carousel owl-loaded owl-drag" data-dots="false" data-nav="true" data-desk_num="4" data-lap_num="3" data-tab_num="2" data-mob_num="1" data-mob_sm="1" data-autoplay="false" data-loop="false" data-margin="30">

                     <!-- 이벤트 경매 총 4개중 1개 시작 -->
                     <c:forEach var="aucEvent" items="${aucEvent}" varStatus="status">
	                     <div class="item">
	                        <div
	                           class="movie type-movie status-publish has-post-thumbnail hentry movie_genre-action movie_genre-adventure movie_genre-drama">
	                           <div class="gen-carousel-movies-style-2 movie-grid style-2">
	                              <div class="gen-movie-contain">
	                                 <div class="gen-movie-img">
	                                    <img src="/resources/upload/eventbanner/${aucEvent.aeSeq}.png" alt="owl-carousel-video-image">
	                                 </div>
	                                 <div class="gen-info-contain">
	                                    <div class="gen-movie-info">
	                                       <h3>
	                                          <a href="#">${aucEvent.aeTitle}</a>
	                                       </h3>
	                                    </div>
	                                 </div>
	                              </div>
	                           </div>
	                        </div>
	                        <!-- #post-## -->
	                     </div>
                     </c:forEach>
                     <!-- 이벤트 경매 총 4개중 1개 끝 -->

                  </div>
               </div>
            </div>
         </div>
      </div>
   </section>
   <!-- 이벤트 경매 구역 끝 -->

   <!-- 상품 구역 시작 -->
   <section class="pt-0 gen-section-padding-2">
      <div class="container">
         <div class="row">
            <div class="col-xl-6 col-lg-6 col-md-6">
               <h4 class="gen-heading-title">파생 상품</h4>
            </div>
            <div class="col-xl-6 col-lg-6 col-md-6 d-none d-md-inline-block">
               <div class="gen-movie-action">
                  <div class="gen-btn-container text-right">
					<c:choose>
						<c:when test="${isUser == 'Y'}">
							<a href="/product/productList" class="gen-button .gen-button-dark"> 
								<span class="text" style="font-weight: bold; font-size: large;">전체보기</span>
							</a>															
						</c:when>
						<c:otherwise>
	                     <a href="/user/logIn" class="gen-button gen-button-flat"> 
	                        <span class="text">전체보기</span>
	                     </a>
						</c:otherwise>
					</c:choose>
                  </div>
               </div>
            </div>
         </div>
         <div class="row mt-3">
            <div class="col-12">
               <div class="gen-style-2">
                  <div class="owl-carousel owl-loaded owl-drag" data-dots="false" data-nav="true" data-desk_num="4" data-lap_num="3" data-tab_num="2" data-mob_num="1" data-mob_sm="1" data-autoplay="false" data-loop="false" data-margin="30">

                     <!-- 상품 총 9개 중 1개 시작 -->
                     <c:forEach var="product" items="${product}" varStatus="status">
	                     <div class="item">
	                        <div
	                           class="movie type-movie status-publish has-post-thumbnail hentry movie_genre-action movie_genre-adventure movie_genre-drama">
	                           <div class="gen-carousel-movies-style-2 movie-grid style-2">
	                              <div class="gen-movie-contain">
	                                 <div class="gen-movie-img">
	                                    <img src="/resources/upload/product/${product.productSeq}.png" alt="owl-carousel-video-image">
	                                 </div>
	                                 <div class="gen-info-contain">
	                                    <div class="gen-movie-info ">
	                                       <h3>
	                                          <a href="#">${product.productName}</a>
	                                       </h3>
	                                    </div>
	                                    <div class="gen-movie-meta-holder">
	                                       <ul>
	                                          <li style="font-size: 17px; color:#007bff !important; font-weight:bold;">&#8361;<fmt:formatNumber type="number" maxFractionDigits="3" value="${product.productPrice}" /></li>
	                                       </ul>
	                                    </div>
	                                 </div>
	                              </div>
	                           </div>
	                        </div>
	                        <!-- #post-## -->
	                     </div>
                     </c:forEach>
                     <!-- 상품 총 9개 중 1개 끝 -->
                  </div>
               </div>
            </div>
         </div>
      </div>
   </section>
   <!-- 상품 구역 끝 -->

   <!-- 진행 투표 구역 시작 -->
   <h4 class="ml-5 mb-4">진행중인 투표</h4>
   <section class="gen-section-padding-2 pt-0 pb-0">
      <div class="container">
         <div class="home-singal-silder">
            <div class="gen-nav-movies gen-banner-movies">
               <div class="row">
                  <div class="col-lg-12">
                     <!-- 투표 큰 화면 시작 -->
                     <div class="slider slider-for" >

                        <!-- 투표 작품 TOP 5개중 1개 시작 -->
                        <c:forEach var="voteList" items="${voteList}" varStatus="status">
                        <div class="slider-item" style="background: url('/resources/upload/vote/${voteList.vrSeq}.png');">
                           <div class="gen-slick-slider h-100">
                              <div class="gen-movie-contain h-100">
                                 <div class="container h-100">
                                    <div class="row align-items-center h-100">
                                       <div class="col-lg-6">
                                          <div class="gen-movie-info">
                                             <h3>${voteList.vrTitle}</h3>
                                             <p class="txt_line">${voteList.vrContent}</p>

                                          </div>
                                          <div class="gen-movie-action">
                                             <div class="gen-btn-container button-1">
												<c:choose>
													<c:when test="${isUser == 'Y'}">
														<a class="gen-button" href="/vote/voteList" tabindex="0"> 
		                                                  <i aria-hidden="true" class="ion ion-play"></i> 
		                                                  <span class="text">투표 참여하기</span>
			                                            </a>														
													</c:when>
													<c:otherwise>
														<a class="gen-button" href="/user/logIn" tabindex="0"> 
		                                                  <i aria-hidden="true" class="ion ion-play"></i> 
		                                                  <span class="text">투표 참여하기</span>
				                                        </a>
													</c:otherwise>
												</c:choose>
                                             </div>
                                          </div>
                                       </div>
                                    </div>
                                 </div>
                              </div>
                           </div>
                        </div>
                        </c:forEach>
                        <!-- 투표 작품 TOP 5개중 1개 끝 -->

                     </div>
                     <!-- 투표 큰 화면 끝 -->

                     <!-- 투표 사이드 스크롤 시작 -->
                     <div class="slider slider-nav">

                        <!-- 투표 작품 TOP 5개중 1개 시작 -->
                         <c:forEach var="voteList" items="${voteList}" varStatus="status">
                        <div class="slider-nav-contain" style="height:150px !important;  width:310px !important;">
                           <div class="gen-nav-img" style="height:150px !important;  width:310px !important;">
                              <img src="/resources/upload/vote/${voteList.vrSeq}.png" alt="steamlab-image" style="height:150px !important; width:310px !important;">
                           </div>
                           <div class="movie-info">
                              <h3>${voteList.vrTitle}</h3>
                              <div class="gen-movie-meta-holder">
                                 <ul>
                                    <li>${voteList.userName}</li>
	                                <c:choose>
										<c:when test="${voteList.categoryNo == 01}">
											<li>미술</li>
										</c:when>
										<c:when test="${voteList.categoryNo == 02}">
											<li>사진</li>
										</c:when>
										<c:when test="${voteList.categoryNo == 03}">
											<li>도예</li>
										</c:when>																	
									 </c:choose>	
                                 </ul>
                              </div>
                           </div>
                        </div>
                        </c:forEach>
                        <!-- 투표 작품 TOP 5개중 1개 끝 -->
                     </div>
                     <!-- 투표 사이드 스크롤 끝 -->
                  </div>
               </div>
            </div>
         </div>
      </div>
   </section>
   <!-- 진행 투표 구역 끝 -->



   <br>
   <br>
   <br>
   <%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>