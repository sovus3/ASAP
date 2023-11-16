<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<style>
/* 드롭다운 목록의 폭과 높이를 동시에 조절 */
#excpStrYear {
   width: 120px; /* 원하는 폭으로 설정 */
   height: 50px; /* 원하는 높이로 설정 */
   font-size: 14px; /* 원하는 글꼴 크기로 설정 */
}

#excpStrMonth {
   width: 120px; /* 원하는 폭으로 설정 */
   height: 50px; /* 원하는 높이로 설정 */
   font-size: 14px; /* 원하는 글꼴 크기로 설정 */
}

#btnDate {
   height: 50px;
}

.liCss {
   border: 1px solid #ffffff !important;
   width: 15%;
   line-height: 20px !important;
   margin: 0 auto;
   font-size: 15px !important;
   margin-bottom: 20px;
}

.gen-price-block .gen-bg-effect {
   opacity : 0.7 !important;
}
</style>


<script>

$(document).ready(function(){

	setSelectFormCalendar("excpStr");
	
	var selectedMonth = localStorage.getItem("selectedMonth");
	  if (selectedMonth) {
	    $("#excpStrMonth").val(selectedMonth);
	  }

	  // 월 선택 드롭다운 변경 시 로컬 저장소에 저장
	  $("#excpStrMonth").change(function() {
	    var selectedValue = $("#excpStrMonth").val();
	    localStorage.setItem("selectedMonth", selectedValue);
	  });

	  // 조회 버튼 클릭 시 선택한 월을 사용하여 검색
	  $("#btnDate").click(function() {
	    var selectedValue = $("#excpStrMonth").val();
	    document.aucForm.searchDate.value = selectedValue;
	    document.aucForm.curPage.value = "1";
	    document.aucForm.action = "/auction/auctionResult";
	    document.aucForm.submit();
	  });

});

// 날짜 조회 (연도는 껍데기 )
function setSelectFormCalendar(id){
	
	
	
	var monthNames = ["", "1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월" ];
	var qntYears = 1;
	var selectYear = $("#"+id+"Year");
	var selectMonth = $("#"+id+"Month");
	var currentYear = new Date().getFullYear();
	// var currentYear = 2023;

  // "월을 선택하세요" 옵션 추가
  var monthPrompt = document.createElement("option");
  monthPrompt.value = "";
  monthPrompt.textContent = "전체";
  selectMonth.append(monthPrompt);
	
	
  //년도에대한 드롭다운 요소추가
	for (var y = 0; y < qntYears; y++){
		var date = new Date(currentYear);
		var yearElem = document.createElement("option");
		yearElem.value = currentYear; 
		yearElem.textContent = currentYear+"년";
		selectYear.append(yearElem);
		currentYear++;
	} 

  // 에대한 요소 추가
	for (var m = 0; m < 12; m++){
		var monthNum = new Date(currentYear, m).getMonth()+1;
		var month = monthNames[monthNum];
		var monthElem = document.createElement("option");
		if(monthNum<10){monthNum='0'+monthNum}
		monthElem.value = monthNum; 
		monthElem.textContent = month;
		selectMonth.append(monthElem);
	}
  

}

//버튼을 누르면 조회

	
function fn_list(curPage){
	var selectedValue = $("#excpStrMonth").val();
	document.aucForm.searchDate.value = selectedValue;
	document.aucForm.curPage.value = curPage;
	document.aucForm.action = "/auction/auctionResult";
	document.aucForm.submit();
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
                     <h1>경매 결과</h1>
                  </div>
                  <div class="gen-breadcrumb-container">
                     <ol class="breadcrumb">
                        <li class="breadcrumb-item">
                           <a href="index.html">
                              <i class="fas fa-home mr-2"></i>홈
                           </a>
                        </li>
                        <li class="breadcrumb-item active">경매 결과</li>
                     </ol>
                  </div>
               </nav>
            </div>
         </div>
      </div>
   </div>
   <!-- breadcrumb -->

   <section class="gen-section-padding-3" style="margin-left: 30px !important; margin-top: -50px !important;">
      <div class="container container-2">
         <div class="row">
            <!-- 종료경매 날짜 조회 -->
            <select id="excpStrYear"></select> 
            <select id="excpStrMonth"></select>
            <input type="button" id="btnDate" name="btnDate" onClick="monthSearch()" value="조회" />
         </div>
      </div>
   </section>

   <!-- Pricing Plan Start -->
   <section class="gen-section-padding-3" style="margin-top: -12% !important;">
      <div class="container container-2">
         <div class="row">
            <c:if test="${!empty list}">
               <c:forEach var="auction" items="${list}">
                  <div class="col-xl-4 col-lg-4 col-md-4" style="margin-top: 3%;">
                     <div class="gen-price-block text-center">
                        <div class="gen-price-detail">
                           <span class="gen-price-title">2023년 ${auction.aucStartTime}월</span>
                           <h4 class="price">
                              &#8361;<fmt:formatNumber type="number" maxFractionDigits="3" value="${auction.aucBuyPrice}" />
                              <br>
                           </h4>
                           <div class="gen-bg-effect">
                              <img src="/resources/upload/vote/${auction.vrSeq}.png" alt="stream-lab-image">
                           </div>
                        </div>
                        <ul class="gen-list-info ">
                           <li class="liCss">
                              <c:choose>
                                 <c:when test="${auction.categoryNo == 01}">
                                    <span>미술</span>
                                 </c:when>
                                 <c:when test="${auction.categoryNo == 02}">
                                    <span>사진</span>
                                 </c:when>
                                 <c:when test="${auction.categoryNo == 03}">
                                    <span>도예</span>
                                 </c:when>
                              </c:choose>
                           </li>
                           <li>
                              <h6>${auction.vrTitle}</h6>
                           </li>
                           <li>${auction.userName}</li>
                        </ul>
                     </div>
                  </div>
               </c:forEach>
            </c:if>
         </div>
      </div>
   </section>
   <!-- Pricing Plan End -->
   
   <!-- 페이징 처리 시작 -->
   <div class="col-lg-12 col-md-12" style="margin: 0 auto;">
      <div class="gen-pagination" style="text-align: center;">
         <nav aria-label="Page navigation" style="display: inline-block;">
            <ul class="page-numbers">
               <c:if test="${!empty paging}">
                  <c:if test="${paging.prevBlockPage gt 0}">
                     <!-- greater than, less than  -->
                     <li>
                        <a class="next page-numbers" href="javascript:void(0)" onclick="fn_list(${paging.prevBlockPage})">이전블럭</a>
                     </li>
                  </c:if>

                  <c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
                     <c:choose>
                        <c:when test="${i ne curPage}">
                           <!-- not equal  -->
                           <li>
                              <a class="page-numbers" href="javascript:void(0)" onclick="fn_list(${i})">${i}</a>
                           </li>
                        </c:when>
                        <c:otherwise>
                           <li>
                              <a class="page-numbers" href="javascript:void(0)" style="cursor: default;">${i}</a>
                           </li>
                        </c:otherwise>
                     </c:choose>
                  </c:forEach>
                  <c:if test="${paging.nextBlockPage gt 0}">
                     <li>
                        <a class="next page-numbers" href="javascript:void(0)" onclick="fn_list(${paging.nextBlockPage})">다음블럭</a>
                     </li>
                  </c:if>
               </c:if>
            </ul>
         </nav>
      </div>
   </div>
   <br>
   <br>
   <br>
   <!-- 페이징 처리 끝 -->

   <form name="aucForm" id="aucForm" method="post">
      <input type="hidden" name="curPage" value="${curPage}" /> 
      <input type="hidden" name="searchDate" value="${searchDate}" />
   </form>

   <%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>