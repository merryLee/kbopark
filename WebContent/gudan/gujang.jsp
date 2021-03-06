<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR" import="com.baseball.gudan.model.*"%>
<!--header 영역-->
<%@ include file="/common/header.jsp"%>
<%
GudanDto gudanDto = (GudanDto) session.getAttribute("gudandto");
StadiumDto stadiumDto = (StadiumDto) request.getAttribute("stadiumdto");
System.out.println("gujang.jsp gudandto >>> " + gudanDto);
System.out.println("gujang.jsp tno >>> "+NullCheck.nullToZero(request.getParameter("tno")));
System.out.println(stadiumDto.getLat() + " " +stadiumDto.getLng() + " " + stadiumDto.getLocid());
%>

<!-- 구단네비게이터 -->
<%@ include file="/gudan/gudan_nav.jsp"%>

<div id="stadium-map">
<div class="container py-5">
	<div class="row">
		<div class="col-md-12 py-5">
			<h4 class="mb-4">
				<strong><%=stadiumDto.getSname() %></strong>
			</h4>
            <img class="d-block mb-3 w-100 img-fluid mx-auto" src="<%=root%><%=stadiumDto.getImage()%>">
		</div>
		
		<!-- 시간이되면 캐러셀 띄워서 이미지 자동 연결! -->
		
		<div class="col-md-12 py-5">
			<h4 class="mb-4">
				<strong>찾아오시는길</strong>
			</h4>
			
           <div id="map" style="width:100%;height:700px;"></div>

		</div>
	</div>
</div>
</div>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=b0101ddc1403bcc7a5e3b093d7b37b95"></script>
<script>
var mapContainer = document.getElementById('map'), // 지도의 중심좌표
    mapOption = { 
        center: new daum.maps.LatLng(<%=stadiumDto.getLat()%>, <%=stadiumDto.getLng()%>), // 지도의 중심좌표
        level: 3 // 지도의 확대 레벨
    }; 

var map = new daum.maps.Map(mapContainer, mapOption); // 지도를 생성합니다

// 지도에 마커를 표시합니다 
var marker = new daum.maps.Marker({
    map: map, 
    position: new daum.maps.LatLng(<%=stadiumDto.getLat()%>, <%=stadiumDto.getLng()%>)
});

// 커스텀 오버레이에 표시할 컨텐츠 입니다
// 커스텀 오버레이는 아래와 같이 사용자가 자유롭게 컨텐츠를 구성하고 이벤트를 제어할 수 있기 때문에
// 별도의 이벤트 메소드를 제공하지 않습니다 
var content = '<div class="wrap">' + 
            '    <div class="info">' + 
            '        <div class="title">' + 
            '            <%=stadiumDto.getSname()%>' + 
            '            <div class="close" onclick="closeOverlay()" title="닫기"></div>' + 
            '        </div>' + 
            '        <div class="body">' + 
            '            <div class="img">' +
            '                <img src="<%=root%><%=gudanDto.getEmblem()%>" width="73" height="70">' +
            '           </div>' + 
            '            <div class="desc">' + 
            '                <div class="ellipsis"><%=stadiumDto.getSloc()%></div>' + 
            '                <div><a href="http://place.map.daum.net/'+ <%=stadiumDto.getLocid()%> + '" target="_blank" class="link">구장 상세보기</a></div>' + 
            '            </div>' + 
            '        </div>' + 
            '    </div>' +    
            '</div>';

// 마커 위에 커스텀오버레이를 표시합니다
// 마커를 중심으로 커스텀 오버레이를 표시하기위해 CSS를 이용해 위치를 설정했습니다
var overlay = new daum.maps.CustomOverlay({
    content: content,
    map: map,
    position: marker.getPosition()       
});

// 마커를 클릭했을 때 커스텀 오버레이를 표시합니다
daum.maps.event.addListener(marker, 'click', function() {
    overlay.setMap(map);
});

// 커스텀 오버레이를 닫기 위해 호출되는 함수입니다 
function closeOverlay() {
    overlay.setMap(null);     
}

//일반 지도와 스카이뷰로 지도 타입을 전환할 수 있는 지도타입 컨트롤을 생성합니다
var mapTypeControl = new daum.maps.MapTypeControl();

//지도에 컨트롤을 추가해야 지도위에 표시됩니다
//daum.maps.ControlPosition은 컨트롤이 표시될 위치를 정의하는데 TOPRIGHT는 오른쪽 위를 의미합니다
map.addControl(mapTypeControl, daum.maps.ControlPosition.TOPRIGHT);

//지도 확대 축소를 제어할 수 있는  줌 컨트롤을 생성합니다
var zoomControl = new daum.maps.ZoomControl();
map.addControl(zoomControl, daum.maps.ControlPosition.RIGHT);
</script>

<!-- footer영역 -->
<%@ include file="/common/footer.jsp"%>