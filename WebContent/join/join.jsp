<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!--header 영역 -->
<%@ include file="/common/header.jsp"%>

<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script src="<%=root%>/js/httpRequest.js"></script>
<script type="text/javascript">
	
	function register(){

		if(document.getElementById("name").value==""){
			alert("이름을 입력하세요!!!");
			return;
		}else if(document.getElementById("id").value==""){
			alert("아이디를 입력하세요!!!");
			return;
		}else if(document.getElementById("pass").value==""){
			alert("비밀번호를 입력하세요!!!");
			return;
		}else if(document.getElementById("pass").value != document.getElementById("passok").value){
			alert("비밀번호가 일치하지 않습니다!!");
			return;
		}else if(document.getElementById("tno").value ==""){
			alert("선호구단을 선택해 주세요!!");
			return;
		}else{
			document.getElementById("joinForm").action = "<%=root %>/kbopark";
			document.getElementById("joinForm").submit();
			}
		}
		
	function changemail(selectObj){
			//alert(selectObj.value)
			document.getElementById("email2").value = selectObj.value
	}
	  
	function zipsearch() {
	        new daum.Postcode({
	            oncomplete: function(data) {
	                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

	                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
	                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
	                var fullAddr = ''; // 최종 주소 변수
	                var extraAddr = ''; // 조합형 주소 변수

	                // 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
	                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
	                    fullAddr = data.roadAddress;

	                } else { // 사용자가 지번 주소를 선택했을 경우(J)
	                    fullAddr = data.jibunAddress;
	                }

	                // 사용자가 선택한 주소가 도로명 타입일때 조합한다.
	                if(data.userSelectedType === 'R'){
	                    //법정동명이 있을 경우 추가한다.
	                    if(data.bname !== ''){
	                        extraAddr += data.bname;
	                    }
	                    // 건물명이 있을 경우 추가한다.
	                    if(data.buildingName !== ''){
	                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
	                    }
	                    // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
	                    fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
	                }

	                // 우편번호와 주소 정보를 해당 필드에 넣는다.
	                document.getElementById('zip1').value = data.zonecode; //5자리 새우편번호 사용
	                document.getElementById('addr1').value = fullAddr;

	                // 커서를 상세주소 필드로 이동한다.
	                document.getElementById('addr2').focus();
	            }
	        }).open();
	    }
	
	
	 function idcheck(){
		  idckresult = document.getElementById("idckresult");
		  var sid = document.getElementById("id").value;
		  var len = sid.length;
		  if(len<4||len>16){
			  idckresult.innerHTML = "<font color='gray' size='2'>아이디는 4자이상 16자 이하입니다</font>";
		  }else{
			  var params = "act=idcheck&id="+sid
			  sendRequest("<%=root%>/kbopark", params, idCheckResult, "GET");
			  
		  }

		  
	  }
	  
	  function idCheckResult(){
		  if(httpRequest.readyState == 4) {
				if(httpRequest.status == 200) {
					var txt = httpRequest.responseText;
					var result=txt.split(",");
					var idcount = parseInt(result[0]);
					var searchid = result[1];
					var resulttxt="";
					if(idcount==0){
						idflag = true;
						resulttxt="<font color='gray' size='2'>"+searchid+"는 사용가능합니다</font>";
					}else{
						idflag = false;
						resulttxt="<font color='gray' size='2'>해당아이디는 존재합니다</font>";
					}
					idckresult.innerHTML = resulttxt;
				}	
			}
		}

</script>
 
<div class="py-5 mx-auto" style="max-width: 1140px;">

	<div class="row py-5">
		<div class="col-md-3"></div>
		<div class="col-md-6">
			<h2 class="text-dark mb-5 px-3">회원가입</h2>
			<form id="joinForm" name="joinForm" method="post">
			<input type="hidden" name="act" id="act" value="regist">
				<div class="form-group row px-3">
					<label for="inputName" class="col-sm-2 col-12 col-form-label">이름</label>
					<div class="col-sm-4 col-12">
						<input type="text" class="form-control" id="name" name="name"
							placeholder="">
					</div>
				</div>
				<div class="form-group row px-3">
					<label for="inputId" class="col-sm-2 col-12 col-form-label">아이디</label>
					<div class="col-sm-8 col-8">
						<input type="text" class="form-control" id="id" name="id"
							placeholder="">
					</div>
					
					<div class="col-sm-2 pl-0 col-4">
						<input type="button" class="btn btn-primary" value="중복확인" onclick="javascript:idcheck();">
					</div>
				</div>
				<div class="form-group row px-3">
				<label for="inputId" class="col-sm-2 col-12 col-form-label"></label>
				<div class="col-sm-8 col-8" id="idckresult"></div>
				</div>
				<div class="form-group row px-3">
					<label for="inputPassword1" class="col-sm-2 col-form-label">비밀번호</label>
					<div class="col-sm-10">
						<input type="password" class="form-control" id="pass" name="pass"
							placeholder="비밀번호를입력해주세요">
					</div>
				</div>
				<div class="form-group row px-3">
					<div class="col-sm-2"></div>
					<div class="col-sm-10">
						<input type="password" class="form-control" id="passok" name="passok"
							placeholder="비밀번호를 다시한번입력해주세요">
					</div>
				</div>


				<div class="form-group row align-items-center px-3">
					<label for="inputEmail1" class="col-sm-2 col-form-label">이메일</label>
					<div class="col-sm-3">
						<input type="text" class="form-control mb-2 mb-sm-0"
							id="email1" name="email1" placeholder="">
					</div>
					<div class="col-sm-4">
						<div class="input-group mb-2 mb-sm-0">
							<div class="input-group-addon">@</div>
							<input type="text" class="form-control" id="email2" name="email2"
								placeholder="">
						</div>
					</div>
					<div class="col-sm-3">
						<select id="inputEmailAddress" class="form-control" onchange="javascript:changemail(this);">
							<option selected="selected">직접입력</option>
							<option>kitri.re.kr</option>
							<option>naver.com</option>
							<option>daum.net</option>
							<option>hanmail.net</option>
						</select>
					</div>
				</div>


				<div class="form-group row px-3">
					<label for="inputTel" class="col-sm-2 col-12 col-form-label">전화번호</label>
					<div class="col-sm-3 col-4">
						<select id="tel1" name="tel1" class="form-control">
							<option selected>010</option>
							<option>011</option>
							<option>02</option>
							<option>031</option>
							<option>033</option>
						</select>
					</div>
					<label class="tellabel text-center px-0 mb-0 align-self-center">-</label>
					<div class="col-sm-3 col-4">
						<input type="text" class="form-control mb-2 mb-sm-0"
							id="tel2" name="tel2" placeholder="">
					</div>
					<label class="tellabel text-center px-0 mb-0 align-self-center">-</label>
					<div class="col-sm-3 col-4">
						<input type="text" class="form-control mb-2 mb-sm-0"
							id="tel3" name="tel3" placeholder="">
					</div>
				</div>


				<div class="form-group row align-items-center px-3">
					<label for="inputAddress" class="col-sm-2 col-form-label">우편주소</label>
					<div class="col-sm-4 col-8">
						<label class="sr-only" for="inputZipcode">zipcode</label>
						<input type="text" class="form-control mb-2 mb-sm-0" id="zip1" name="zip1"
							placeholder="" readonly>
					</div>
					<div class="col-sm-2 pl-0 col-4 align-self-center">
						<input type="button" class="btn btn-primary" value="주소검색" onclick="javascript:zipsearch();">
					</div>
				</div>

				<div class="form-group row px-3">
					<label for="inputAddress2" class="col-sm-2 col-form-label">상세주소</label>
					<div class="col-sm-4">
						<div class="input-group mb-2 mb-sm-0">
							<input type="text" class="form-control" id="addr1" name="addr1"
								placeholder="" readonly>
						</div>
					</div>
					<div class="col-sm-6">
						<input type="text" class="form-control" id="addr2" name="addr2"
							placeholder="">
					</div>
				</div>


				<div class="form-group row px-3">
					<label for="inputTeam" class="col-sm-2 col-form-label">선호구단</label>
					<div class="col-sm-4">
						<select id="tno" name="tno" class="form-control" onchange="javascript:tnochange(this);">
							<option selected="selected" value="">--선택하세요--</option>
							<option value="2">두산 베어스</option>
							<option value="3">롯데 자이언츠</option>
							<option value="1">KIA 타이거즈</option>
							<option value="4">NC 다이노스</option>
							<option value="5">SK 와이번스</option>
							<option value="6">LG 트윈스</option>
							<option value="7">넥센 히어로즈</option>
							<option value="8">한화 이글스</option>
							<option value="9">삼성 라이온즈</option>
							<option value="10">KT 위즈</option>
						</select>
					</div>
				</div>

				<div class="border-b mb-2 px-3"></div>

				<div class="px-3 py-3">
					<input type="button" class="btn btn-lg btn-block btn-primary" onclick="javascript:register();" value="회원가입">
				
				</div>
			</form>
		</div>
	</div>

</div>



 <%--   <form class="" name="memberform" method="post" action="">
   <input type= "hidden" name = "act" id= "act" value="regist">
    <div class="container" align="center">
        <div align="left" style="width:650px; border:1px solid #cccccc; padding:20px">
            <h3>회원가입</h3>
            <hr />
        
            <div class=form-inline style="margin-bottom:5px">
                <label style="width:150px">이름</label>
                <input id="name" name="name" type="text" class="form-control"/>
            </div>
            
            <div class=form-inline style="margin-bottom:5px">
                <label style="width:150px">아이디</label>
                <input id="id" name="id" type="text" class="form-control" />
                <input type="button" class="btn btn-primary" value="중복체크" onclick="javascript:openidck();" >
            </div>
    
            <div class=form-inline style="margin-bottom:5px">
                <label style="width:150px">비밀번호</label>
                <input id="pass" name="pass" type="password" class="form-control"/>
                <div style="margin-bottom:5px"></div>
                <label style="width:154px"></label>
                <input id="passok" name="passok" type="password" class="form-control" style="margin-right:5px"/>확인을 위해 한번 더 입력해 주세요.
            </div>
            
            <div class=form-inline style="margin-bottom:5px">
                <label style="width:150px">이메일</label>
                <input id="email1" name="email1" style="width:120px; margin-right:5px" type="text" class="form-control"/>@
                <input id="email3" name="email3" style="width:120px; margin-right:5px" type="text" class="form-control"/>
                <select id="email2" name="email2" class="form-control" onchange= "javascript:changemail(this);">
                   <option value="naver.com">네이버</option>
                   <option value="nate.com">네이트</option>
                   <option value="daum.net">다음</option>
                   <option value="kitri.com">키트리</option>
                   <option value="" selected="selected">직접입력</option>
                </select>
                <p><label style="width:154px"></label>영문으로 시작하는 4~10자리의 영문, 숫자 조합만 가능합니다.</p>
            </div>
            
            
            
            <div class=form-inline style="margin-bottom:5px">
                <label style="width:150px">전화번호</label>
                <select id="tel1" name="tel1" class="form-control">
                    <option>010</option>
                    <option>011</option>
                    <option>016</option>
                    <option>017</option>
                </select>
                <input id="tel2" name="tel2" style="width:70px; margin-right:5px" type="text" class="form-control" maxlength = "4"/>-
                <input id="tel3" name="tel3" style="width:70px; margin-right:5px" type="text" class="form-control" maxlength = "4"/>
            </div>
            

            <div class=form-inline style="margin-bottom:5px">
                <label style="width:150px">우편번호</label>
                <input id="zip1" name="zip1" style="width:80px; margin-right:5px" type="text" class="form-control" maxlength = "6" readonly="readonly"/>
                <input type="button" class="btn btn-default" value="검색" onclick="javascript:zipsearch();">
            </div>
            
            <div class=form-inline style="margin-bottom:5px">
                <label style="width:150px">주소</label>
                <input id="addr1" name="addr1" style="width:170px; margin-right:5px" type="text" class="form-control" readonly="readonly"/>
                <input id="addr2" name="addr2" style="width:250px; margin-right:5px" type="text" class="form-control" />
            </div>
            
            
            <hr />
            
            <div align="center">
            <input type="button" class="btn btn-success" value="회원가입" onclick ="javascript:register();">
            <input type="button" class="btn btn-success" value="뒤로가기" onclick =""> 
            </div>
        </div>
    </div>
    </form>--%>
    
<%@ include file="/common/footer.jsp" %> 


<!-- idcheck Modal >> idcheck.jsp로 뺄것 -->
<%--
<div class="modal fade" id="idcheckModal" tabindex="-1" role="dialog"
	aria-labelledby="idcheckModalLabel" aria-hidden="true">
	<div class="modal-dialog" role="document">
		<div class="modal-content text-center">
			<form name="idck" id="idck" method="get">
				<div class="modal-header">
					<h5 class="modal-title" id="idcheckModalLabel">아이디 중복검사</h5>
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body px-2 py-5">
					<label style="display: block;">사용하실 아이디를 입력해주세요</label>
					<div class="form-group row">
					<div class="col-1"></div>
						<div class="col-sm-7 col-6">
							<input type="text" class="form-control"
								id="fid" name="fid" placeholder="">
						</div>
						<div class="col-sm-3 col-4">
							<input type="button" class="btn btn-primary" value="중복검사" 
							onclick="javascript:idcheck();">
						</div>
					</div>
				</div>
				<div id = "idckresult">
				<label style="display: block;">아이디는 몇자이상 몇자이하입니다</label>
				</div>
				<div class="modal-footer p-4" style="display: block;">
					<label style="display: block;">아이디는 몇자이상 몇자이하입니다</label>
					<button type="button" class="btn btn-primary">사용하기</button>
					<button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
				</div>
			</form>
		</div>

	</div>
</div>
 --%>
<!-- zipsearch Modal >> zipsearch.jsp로 뺄것 Modal -->
<div class="modal fade" id="zipsearchModal" tabindex="-1" role="dialog"
	aria-labelledby="zipsearchModalLabel" aria-hidden="true">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="zipsearchModalLabel">우편번호검색모달</h5>
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">...</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
				<button type="button" class="btn btn-primary">Save changes</button>
			</div>
		</div>
	</div>
</div>
