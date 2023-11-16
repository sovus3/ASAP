<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp" %>

<style>
	<style>
   .search-form {
      width: 80%;
      margin: 0 auto;
      margin-top: 1rem;
   }
   
   .search-form input {
      height: 100%;
      background: transparent;
      border: 0;
      display: block;
      width: 100%;
      padding: 1rem;
      height: 100%;
      font-size: 1rem;
   }
   
   .search-form select {
      background: transparent;
      border: 0;
      padding: 1rem;
      height: 100%;
      font-size: 1rem;
   }
   
   .search-form select:focus {
      border: 0;
   }
   
   .search-form button {
      height: 100%;
      width: 100%;
      font-size: 1rem;
   }
   
   .search-form button svg {
      width: 24px;
      height: 24px;
   }
   
   select, select.form-control {
      height: 54px !important;
   }
   
   a {
   color:#ffffff !important;
}
</style>
</style>

<script type="text/javascript">
$(document).ready(function() {
    
   $("#btnWrite").on("click", function() {
     	document.bbsForm.qaSeq.value="";
     	document.bbsForm.action ="/board/qnaWrite";
     	document.bbsForm.submit();
   });
   
   $("#btnSearch").on("click",function(){
		document.bbsForm.qaSeq.value="";	
	    document.bbsForm.searchType.value=$("#_searchType").val();
		document.bbsForm.searchValue.value=$("#_searchValue").val();
		document.bbsForm.curPage.value="1";
		document.bbsForm.action="/board/qnaBoard";
		document.bbsForm.submit();
	});
});

function fn_view(qaSeq)	
{
	document.bbsForm.qaSeq.value=qaSeq;
	document.bbsForm.action="/board/qnaView";
	document.bbsForm.submit();

}

function fn_list(curPage)
{
	document.bbsForm.qaSeq.value="";	
	document.bbsForm.curPage.value = curPage;
	document.bbsForm.action="/board/qnaBoard";
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
                            <h1>문의사항 게시판</h1>
                        </div>
                        <div class="gen-breadcrumb-container">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="index.html"><i
                                            class="fas fa-home mr-2"></i>홈</a></li>
                                <li class="breadcrumb-item active">문의사항 게시판</li>
                            </ol>
                        </div>
                    </nav>
                </div>
            </div>
        </div>
    </div>
    <!-- breadcrumb -->
    
    <!-- Pricing Table Start -->
    <div class="gen-section-padding-3">
        <div class="container container-2">
           <form id="search-form">
            <div class="row">
            
               <div class="col-10">
                  <div class="row no-gutters">
                     <div class="col-lg-2 col-md-3 col-sm-12 p-0">
                        <select class="form-control" name="_searchType"
                           id="_searchType">
                           <option value="">조회 항목</option>
                           <option value="1" <c:if test = '${searchType eq "1"}'>selected</c:if>>제목</option>
                           <option value="2" <c:if test = '${searchType eq "2"}'>selected</c:if>>내용</option>
                        </select>
                     </div>
                     <div class="col-lg-9 col-md-6 col-sm-12 p-0">
                        <input type="text" placeholder="Search..." class="form-control" name="_searchValue" id="_searchValue" value="">
                     </div>
                     <div class="col-lg-1 col-md-3 col-sm-12 p-0">
                        <button type="button" id="btnSearch" class="btn btn-base" style="color:#ffffff;">
                           <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-search">
                                       <circle cx="11" cy="11" r="8"></circle>
                                      <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                                   </svg>
                        </button>
                     </div>
                  </div>
               </div>
               
               <div class="col-2" style="margin-left: -20px !important;">
               <c:if test="${boardMe eq 'N'}"  > 
                       <div class="cell-btn-holder">
                            <div class="gen-btn-container">
                                <div class="gen-button-block">
 									<a class="gen-button" id="btnWrite" style="float:right;">
                                        <span class="text" style="cursor:pointer;">글쓰기</span>
                                    </a>
                                </div>
                            </div>
                        </div>
                        </c:if>
               </div>
               
            </div>
         </form>
         <br>
            <div class="row">
                <div class="col-lg-12">
                    <div class="gen-comparison-table table-style-1 table-responsive">
                        <table class="table table-striped table-bordered" style="font-weight: bold;">
                            <thead>
                                <tr>
                                    <th>
                                        <div class="cell-inner">
                                           <span>번호</span>
                                        </div>
                                        <div class="cell-tag">
                                            <span></span>
                                        </div>
                                    </th>
                                    <th>
                                        <div class="cell-inner">                  
                                            <span>제목</span>
                                        </div>
                                        <div class="cell-tag">
                                            <span></span>
                                        </div>
                                    </th>
                                    <th>
                                        <div class="cell-inner">
                                            <span>닉네임</span>
                                        </div>
                                        <div class="cell-tag">
                                            <span></span>
                                        </div>
                                    </th>
                                    <th>
                                        <div class="cell-inner">
                                            <span>등록일</span>
                                        </div>
                                        <div class="cell-tag">
                                            <span></span>
                                        </div>
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
						<c:if test="${!empty list}">
						<c:set var="startNum" value="${paging.startNum}"/>
							<c:forEach var="qnaBoard" items="${list}" varStatus="status"> 
							<input type="hidden" name="status" id="stauts" value="${qnaBoard.status}" />
						                                <tr>
						       <c:choose>
									<c:when test ="${qnaBoard.qaIndent eq 0 }">
							      		<!-- indent가 0일때 -->
							        	<td class="text-center">${startNum}</td>
							        </c:when>
							        <c:otherwise>
							         	<!-- indent가 0이 아닐 때 -->
							         	<td class="text-center"></td>
							         </c:otherwise>
						       	</c:choose>
                                    <td>
                                        <div class=“cell-inner”>
								<c:choose>
									<c:when test = "${qnaBoard.status eq 'N'}"  >                             
										<a id="view" href="javascript:void(0)" onclick=null>
									</c:when>
									 <c:otherwise>
										<a id="view" href="javascript:void(0)" onclick="fn_view(${qnaBoard.qaSeq})">
									</c:otherwise>
								</c:choose>

 							<c:if test = "${qnaBoard.qaIndent>0}">
                           		<img src = "/resources/images/right.png" style="margin-left:${qnaBoard.qaIndent}em; margin-top:-7px !important;"/>
                           	</c:if>
                                            <span style="font-size:17px;"><c:out value="${qnaBoard.qaTitle}" /></span>
 </a>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="cell-inner">
                                            <span>${qnaBoard.userNick}</span>
                                        </div>
                                    </td>
									<td>
                                        <div class="cell-inner">
                                            <span>${qnaBoard.regDate}</span>
                                        </div>
                                    </td>
                                </tr>
<c:set var="startNum" value="${startNum-1}"></c:set>
     </c:forEach>
</c:if> 
                            </tbody>
                        </table>
                        <br/>
                        <br/>
                        <div class="col-lg-12 col-md-12" style="margin: 0 auto;">
                          <div class="gen-pagination" style="text-align: center;">
                              <nav aria-label="Page navigation" style="display :inline-block;">
                                  <ul class="page-numbers">
<c:if test="${!empty paging}">
	<c:if test="${paging.prevBlockPage gt 0}">		<!-- greater than, less than -->
         <li><<a class="next page-numbers" href="javascript:void(0)" onclick="fn_list(${paging.prevBlockPage})">이전블럭</a></li>
	</c:if>
	
	<c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}" >
		<c:choose>
			<c:when test="${i ne curPage}" >		<!-- not equal -->
         	<li><a class="page-numbers" href="javascript:void(0)" onclick="fn_list(${i})">${i}</a></li>
			</c:when>
			<c:otherwise>         
         	<li><a class="page-numbers" href="javascript:void(0)" style="cursor:default;">${i}</a></li>
			</c:otherwise>   		
   		</c:choose>
   	</c:forEach>
    <c:if test="${paging.nextBlockPage gt 0}">
         <li><a class="next page-numbers" href="javascript:void(0)" onclick="fn_list(${paging.nextBlockPage})">다음블럭</a></li>
	</c:if>
</c:if>
                                        </ul>
                              </nav>
                          </div>
                      </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
   
   <form name="bbsForm" id="bbsForm" method="post">
      <input type="hidden" name="qaSeq" id="qaSeq" value="" />
      <input type="hidden" name="searchType" value="${searchType}" />	<!-- modelMapd의 변수 -->
      <input type="hidden" name="searchValue" value="${searchValue}" />
      <input type="hidden" name="curPage" value="${curPage}" />
   </form>
<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>