<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR" import="com.baseball.gudan.model.GudanDto,com.baseball.board.model.BoardDto"%>
<!--header 慎蝕-->
<%@ include file="/common/header.jsp"%>
<%
GudanDto gudanDto = (GudanDto) session.getAttribute("gudandto");
BoardDto boardDto = (BoardDto) request.getAttribute("parentarticle");

if(memberDto != null) {
%>
<link rel="stylesheet" type="text/css" HREF="<%=root %>/css/alice.css">
<link rel="stylesheet" type="text/css" HREF="<%=root %>/css/oz.css">
<script type="text/javascript" src="<%=root %>/js/prototype.js"></script>
<script type="text/javascript" src="<%=root %>/js/extprototype.js"></script>	
<script type="text/javascript" src="<%=root %>/js/oz.js"></script>	
<script type="text/javascript" src="<%=root %>/js/alice.js"></script>
<script type="text/javascript">
control = "/board";

var alice;
Event.observe(window, "load", function() {
	alice = Web.EditorManager.instance("editor",{type:'detail',width:'96%',height:'100%',limit:20,family:'妓崇',size:'13px'});

});	

function writeArticle(){
	if(document.getElementById("subject").value == "") {
		alert("薦鯉聖 脊径馬室推");
		return;
	}else if(alice.getContent() == ""){
		alert("鎧遂聖 脊径馬室推");
		return;
	}else{
		document.getElementById("content").value = alice.getContent();
		document.getElementById("boardtno").value = document.getElementById("selectgudan").value;
		document.getElementById("writeForm").action = "<%=root%>/board";
		document.getElementById("writeForm").submit();
	}
}

</script>

<!-- 姥舘革搾惟戚斗 -->
<%@ include file="/gudan/gudan_nav.jsp"%>

<div id="comm-best">
	<div class="container py-5">
		<div class="row">
			<div class="col-md-8 py-5">

				<div class="">
					<h5>
						<strong>朕溝艦銅 呪舛馬奄</strong>
					</h5>
				</div>
				<div class="border-b-strong mb-5"></div>


<form id="writeForm" name="writeForm" class="">

<input type="hidden" name="act" value="modifyarticle">
<input type="hidden" name="tno" value="<%=tno%>">
<input type="hidden" name="pg" value="1">
<input type="hidden" name="seq" value="<%=boardDto.getBno()%>">
<input type="hidden" id="content" name="content" value=""> <!-- 訟軒什凶庚拭 琶推敗 -->
				
					<div class="form-group row px-3">
						<label for="selectgudan" class="col-sm-2 col-4 col-form-label">姥舘</label>
						<div class="col-sm-4 col-8">
							<select id="selectgudan" name="selectgudan" class="form-control">
								<option value="2" selected>砧至 今嬢什</option>
								<option value="3">茎汽 切戚情苧</option>
								<option value="1">KIA 展戚暗綜</option>
								<option value="4">NC 陥戚葛什</option>
								<option value="5">SK 人戚腰什</option>
								<option value="6">LG 闘制什</option>
								<option value="7">学湿 備嬢稽綜</option>
								<option value="8">廃鉢 戚越什</option>
								<option value="9">誌失 虞戚紳綜</option>
								<option value="10">KT 是綜</option>
							</select>
						</div>
					</div>

					<div class="form-group row px-3">
						<label for="writeName" class="col-sm-2 col-4 col-form-label">拙失切</label>
						<div class="col-sm-4 col-8">
							<input type="text" class="form-control" id="writer" name="writer"
								placeholder="<%=memberDto.getName()%>" readonly>
						</div>
					</div>

					<div class="form-group row px-3">
						<label for="inputSubject" class="col-sm-2 col-12 col-form-label">薦鯉</label>
						<div class="col-sm-10 col-12">
							<input type="text" class="form-control" id="subject" name="subject"
								placeholder="" size="76" maxlength="150" value="<%=boardDto.getBname()%>">
						</div>
					</div>

					<div class="form-group row px-3">
						<div class="col-md-12">
							<textarea class="form-control" rows="20" id="editor" name="editor"><%=boardDto.getBdetail()%></textarea>
						</div>
					</div>

					<!-- 歎採督析 -->
					<div class="form-group row px-3">
						<label for="inputfile" class="col-sm-2 col-form-label">歎採督析</label>
						<div class="col-sm-10">
							<input type="file" class="form-control-file mb-2"
								id="exampleFormControlFile1"> <label
								style="font-size: 14px;">戚耕走 滴奄澗 3MB戚馬稽 薦廃桔艦陥.(呪舛)</label>
							<!-- 訊照股備走..ばば
								<label class="custom-file">
								<input type="file" id="file2" class="custom-file-input mb-2"> <span
									class="custom-file-control"></span>
								</label> -->
						</div>
					</div>

					<!-- 銚鱈 -->
				</form>

				<div class="border-b mb-3"></div>
				<div class="d-flex">
					<div class="mr-auto p-2">
						<a class="btn btn-primary btn-sm" href="javascript:listArticle('<%=gudanDto.getTno()%>','<%=pg%>','<%=key%>','<%=word%>');" role="button"
							style="color: white !important;">鯉系左奄</a>
					</div>
					<div class="p-2">
						<a class="btn btn-secondary btn-sm" href="javascript:history.back();" role="button"
							style="color: white !important;">昼社</a>
					</div>
					<div class="p-2">
						<a class="btn btn-primary btn-sm" href="javascript: writeArticle();" role="button"
							style="color: white !important;">呪舛</a>
					</div>
				</div>





			</div>
			<!-- col-md-8 -->

			<div class="col-md-4 py-5">
				<h5>
					<strong>叔獣娃今什闘</strong>
				</h5>
				<div class="border-b-strong"></div>
				<ul class="list-group">
					<li class="list-group-item" style="border: none;"><span
						class="bestnum" style="color: red;">1</span> しさし級 析戚 戚係惟 朕遭...
						(157)</li>
					<li class="list-group-item"><span class="bestnum"
						style="color: red;">2</span> 馬馬馬馬馬 益君壱左艦 号添社... (65)</li>
					<li class="list-group-item"><span class="bestnum"
						style="color: red;">3</span> 馬馬馬馬馬 益君壱左艦 号添社... (65)</li>
					<li class="list-group-item"><span class="bestnum">4</span>
						馬馬馬馬馬 益君壱左艦 号添社... (65)</li>
					<li class="list-group-item"><span class="bestnum">5</span>
						馬馬馬馬馬 益君壱左艦 号添社... (65)</li>
					<li class="list-group-item" style="border: none;"><span
						class="bestnum">6</span> しさし級 析戚 戚係惟 朕遭... (157)</li>
					<li class="list-group-item"><span class="bestnum">7</span>
						馬馬馬馬馬 益君壱左艦 号添社... (65)</li>
					<li class="list-group-item"><span class="bestnum">8</span>
						馬馬馬馬馬 益君壱左艦 号添社... (65)</li>
					<li class="list-group-item"><span class="bestnum">9</span>
						馬馬馬馬馬 益君壱左艦 号添社... (65)</li>
					<li class="list-group-item"><span class="bestnum">10</span>
						馬馬馬馬馬 益君壱左艦 号... (65)</li>
				</ul>
			</div>

		</div>

	</div>
</div>
<%
} else {
%>
<script>
alert("稽益昔戚 琶推廃 凪戚走脊艦陥.");
document.location.href = "<%=root%>/login/login.jsp";
</script>
<%
}
%>


<!-- alice遂 footer慎蝕 -->
<%@ include file="/community/boardfooter.jsp"%>