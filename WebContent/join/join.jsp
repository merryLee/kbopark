<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!--header ���� -->
<%@ include file="/common/header.jsp"%>

<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script src="<%=root%>/js/httpRequest.js"></script>
<script type="text/javascript">
	
	function register(){

		if(document.getElementById("name").value==""){
			alert("�̸��� �Է��ϼ���!!!");
			return;
		}else if(document.getElementById("id").value==""){
			alert("���̵� �Է��ϼ���!!!");
			return;
		}else if(document.getElementById("pass").value==""){
			alert("��й�ȣ�� �Է��ϼ���!!!");
			return;
		}else if(document.getElementById("pass").value != document.getElementById("passok").value){
			alert("��й�ȣ�� ��ġ���� �ʽ��ϴ�!!");
			return;
		}else if(document.getElementById("tno").value ==""){
			alert("��ȣ������ ������ �ּ���!!");
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
	                // �˾����� �˻���� �׸��� Ŭ�������� ������ �ڵ带 �ۼ��ϴ� �κ�.

	                // �� �ּ��� ���� ��Ģ�� ���� �ּҸ� �����Ѵ�.
	                // �������� ������ ���� ���� ��쿣 ����('')���� �����Ƿ�, �̸� �����Ͽ� �б� �Ѵ�.
	                var fullAddr = ''; // ���� �ּ� ����
	                var extraAddr = ''; // ������ �ּ� ����

	                // ����ڰ� ������ �ּ� Ÿ�Կ� ���� �ش� �ּ� ���� �����´�.
	                if (data.userSelectedType === 'R') { // ����ڰ� ���θ� �ּҸ� �������� ���
	                    fullAddr = data.roadAddress;

	                } else { // ����ڰ� ���� �ּҸ� �������� ���(J)
	                    fullAddr = data.jibunAddress;
	                }

	                // ����ڰ� ������ �ּҰ� ���θ� Ÿ���϶� �����Ѵ�.
	                if(data.userSelectedType === 'R'){
	                    //���������� ���� ��� �߰��Ѵ�.
	                    if(data.bname !== ''){
	                        extraAddr += data.bname;
	                    }
	                    // �ǹ����� ���� ��� �߰��Ѵ�.
	                    if(data.buildingName !== ''){
	                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
	                    }
	                    // �������ּ��� ������ ���� ���ʿ� ��ȣ�� �߰��Ͽ� ���� �ּҸ� �����.
	                    fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
	                }

	                // ������ȣ�� �ּ� ������ �ش� �ʵ忡 �ִ´�.
	                document.getElementById('zip1').value = data.zonecode; //5�ڸ� ��������ȣ ���
	                document.getElementById('addr1').value = fullAddr;

	                // Ŀ���� ���ּ� �ʵ�� �̵��Ѵ�.
	                document.getElementById('addr2').focus();
	            }
	        }).open();
	    }
	
	
	 function idcheck(){
		  idckresult = document.getElementById("idckresult");
		  var sid = document.getElementById("id").value;
		  var len = sid.length;
		  if(len<4||len>16){
			  idckresult.innerHTML = "<font color='gray' size='2'>���̵�� 4���̻� 16�� �����Դϴ�</font>";
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
						resulttxt="<font color='gray' size='2'>"+searchid+"�� ��밡���մϴ�</font>";
					}else{
						idflag = false;
						resulttxt="<font color='gray' size='2'>�ش���̵�� �����մϴ�</font>";
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
			<h2 class="text-dark mb-5 px-3">ȸ������</h2>
			<form id="joinForm" name="joinForm" method="post">
			<input type="hidden" name="act" id="act" value="regist">
				<div class="form-group row px-3">
					<label for="inputName" class="col-sm-2 col-12 col-form-label">�̸�</label>
					<div class="col-sm-4 col-12">
						<input type="text" class="form-control" id="name" name="name"
							placeholder="">
					</div>
				</div>
				<div class="form-group row px-3">
					<label for="inputId" class="col-sm-2 col-12 col-form-label">���̵�</label>
					<div class="col-sm-8 col-8">
						<input type="text" class="form-control" id="id" name="id"
							placeholder="">
					</div>
					
					<div class="col-sm-2 pl-0 col-4">
						<input type="button" class="btn btn-primary" value="�ߺ�Ȯ��" onclick="javascript:idcheck();">
					</div>
				</div>
				<div class="form-group row px-3">
				<label for="inputId" class="col-sm-2 col-12 col-form-label"></label>
				<div class="col-sm-8 col-8" id="idckresult"></div>
				</div>
				<div class="form-group row px-3">
					<label for="inputPassword1" class="col-sm-2 col-form-label">��й�ȣ</label>
					<div class="col-sm-10">
						<input type="password" class="form-control" id="pass" name="pass"
							placeholder="��й�ȣ���Է����ּ���">
					</div>
				</div>
				<div class="form-group row px-3">
					<div class="col-sm-2"></div>
					<div class="col-sm-10">
						<input type="password" class="form-control" id="passok" name="passok"
							placeholder="��й�ȣ�� �ٽ��ѹ��Է����ּ���">
					</div>
				</div>


				<div class="form-group row align-items-center px-3">
					<label for="inputEmail1" class="col-sm-2 col-form-label">�̸���</label>
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
							<option selected="selected">�����Է�</option>
							<option>kitri.re.kr</option>
							<option>naver.com</option>
							<option>daum.net</option>
							<option>hanmail.net</option>
						</select>
					</div>
				</div>


				<div class="form-group row px-3">
					<label for="inputTel" class="col-sm-2 col-12 col-form-label">��ȭ��ȣ</label>
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
					<label for="inputAddress" class="col-sm-2 col-form-label">�����ּ�</label>
					<div class="col-sm-4 col-8">
						<label class="sr-only" for="inputZipcode">zipcode</label>
						<input type="text" class="form-control mb-2 mb-sm-0" id="zip1" name="zip1"
							placeholder="" readonly>
					</div>
					<div class="col-sm-2 pl-0 col-4 align-self-center">
						<input type="button" class="btn btn-primary" value="�ּҰ˻�" onclick="javascript:zipsearch();">
					</div>
				</div>

				<div class="form-group row px-3">
					<label for="inputAddress2" class="col-sm-2 col-form-label">���ּ�</label>
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
					<label for="inputTeam" class="col-sm-2 col-form-label">��ȣ����</label>
					<div class="col-sm-4">
						<select id="tno" name="tno" class="form-control" onchange="javascript:tnochange(this);">
							<option selected="selected" value="">--�����ϼ���--</option>
							<option value="2">�λ� ���</option>
							<option value="3">�Ե� ���̾���</option>
							<option value="1">KIA Ÿ�̰���</option>
							<option value="4">NC ���̳뽺</option>
							<option value="5">SK ���̹���</option>
							<option value="6">LG Ʈ����</option>
							<option value="7">�ؼ� �������</option>
							<option value="8">��ȭ �̱۽�</option>
							<option value="9">�Ｚ ���̿���</option>
							<option value="10">KT ����</option>
						</select>
					</div>
				</div>

				<div class="border-b mb-2 px-3"></div>

				<div class="px-3 py-3">
					<input type="button" class="btn btn-lg btn-block btn-primary" onclick="javascript:register();" value="ȸ������">
				
				</div>
			</form>
		</div>
	</div>

</div>



 <%--   <form class="" name="memberform" method="post" action="">
   <input type= "hidden" name = "act" id= "act" value="regist">
    <div class="container" align="center">
        <div align="left" style="width:650px; border:1px solid #cccccc; padding:20px">
            <h3>ȸ������</h3>
            <hr />
        
            <div class=form-inline style="margin-bottom:5px">
                <label style="width:150px">�̸�</label>
                <input id="name" name="name" type="text" class="form-control"/>
            </div>
            
            <div class=form-inline style="margin-bottom:5px">
                <label style="width:150px">���̵�</label>
                <input id="id" name="id" type="text" class="form-control" />
                <input type="button" class="btn btn-primary" value="�ߺ�üũ" onclick="javascript:openidck();" >
            </div>
    
            <div class=form-inline style="margin-bottom:5px">
                <label style="width:150px">��й�ȣ</label>
                <input id="pass" name="pass" type="password" class="form-control"/>
                <div style="margin-bottom:5px"></div>
                <label style="width:154px"></label>
                <input id="passok" name="passok" type="password" class="form-control" style="margin-right:5px"/>Ȯ���� ���� �ѹ� �� �Է��� �ּ���.
            </div>
            
            <div class=form-inline style="margin-bottom:5px">
                <label style="width:150px">�̸���</label>
                <input id="email1" name="email1" style="width:120px; margin-right:5px" type="text" class="form-control"/>@
                <input id="email3" name="email3" style="width:120px; margin-right:5px" type="text" class="form-control"/>
                <select id="email2" name="email2" class="form-control" onchange= "javascript:changemail(this);">
                   <option value="naver.com">���̹�</option>
                   <option value="nate.com">����Ʈ</option>
                   <option value="daum.net">����</option>
                   <option value="kitri.com">ŰƮ��</option>
                   <option value="" selected="selected">�����Է�</option>
                </select>
                <p><label style="width:154px"></label>�������� �����ϴ� 4~10�ڸ��� ����, ���� ���ո� �����մϴ�.</p>
            </div>
            
            
            
            <div class=form-inline style="margin-bottom:5px">
                <label style="width:150px">��ȭ��ȣ</label>
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
                <label style="width:150px">������ȣ</label>
                <input id="zip1" name="zip1" style="width:80px; margin-right:5px" type="text" class="form-control" maxlength = "6" readonly="readonly"/>
                <input type="button" class="btn btn-default" value="�˻�" onclick="javascript:zipsearch();">
            </div>
            
            <div class=form-inline style="margin-bottom:5px">
                <label style="width:150px">�ּ�</label>
                <input id="addr1" name="addr1" style="width:170px; margin-right:5px" type="text" class="form-control" readonly="readonly"/>
                <input id="addr2" name="addr2" style="width:250px; margin-right:5px" type="text" class="form-control" />
            </div>
            
            
            <hr />
            
            <div align="center">
            <input type="button" class="btn btn-success" value="ȸ������" onclick ="javascript:register();">
            <input type="button" class="btn btn-success" value="�ڷΰ���" onclick =""> 
            </div>
        </div>
    </div>
    </form>--%>
    
<%@ include file="/common/footer.jsp" %> 


<!-- idcheck Modal >> idcheck.jsp�� ���� -->
<%--
<div class="modal fade" id="idcheckModal" tabindex="-1" role="dialog"
	aria-labelledby="idcheckModalLabel" aria-hidden="true">
	<div class="modal-dialog" role="document">
		<div class="modal-content text-center">
			<form name="idck" id="idck" method="get">
				<div class="modal-header">
					<h5 class="modal-title" id="idcheckModalLabel">���̵� �ߺ��˻�</h5>
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body px-2 py-5">
					<label style="display: block;">����Ͻ� ���̵� �Է����ּ���</label>
					<div class="form-group row">
					<div class="col-1"></div>
						<div class="col-sm-7 col-6">
							<input type="text" class="form-control"
								id="fid" name="fid" placeholder="">
						</div>
						<div class="col-sm-3 col-4">
							<input type="button" class="btn btn-primary" value="�ߺ��˻�" 
							onclick="javascript:idcheck();">
						</div>
					</div>
				</div>
				<div id = "idckresult">
				<label style="display: block;">���̵�� �����̻� ���������Դϴ�</label>
				</div>
				<div class="modal-footer p-4" style="display: block;">
					<label style="display: block;">���̵�� �����̻� ���������Դϴ�</label>
					<button type="button" class="btn btn-primary">����ϱ�</button>
					<button type="button" class="btn btn-secondary" data-dismiss="modal">�ݱ�</button>
				</div>
			</form>
		</div>

	</div>
</div>
 --%>
<!-- zipsearch Modal >> zipsearch.jsp�� ���� Modal -->
<div class="modal fade" id="zipsearchModal" tabindex="-1" role="dialog"
	aria-labelledby="zipsearchModalLabel" aria-hidden="true">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="zipsearchModalLabel">������ȣ�˻����</h5>
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