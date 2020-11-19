<html>
<head>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<title>Tmap Test</title>
<script src="https://code.jquery.com/jquery-3.5.1.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
<script src="https://apis.openapi.sk.com/tmap/jsv2?version=1&appKey=30c275dc-dc9f-4ae4-bd12-9a17c9c76231"></script>

<script type="text/javascript">
$(document).ready(function() {
	initTmap();
	
	map.addListener("click", onClick); // 이벤트의 종류와 해당 이벤트 발생 시 실행할 함수를 리스너를 통해 등록합니다
});

var map;
function initTmap(){ 
	map = new Tmapv2.Map("map_div", {
		center: new Tmapv2.LatLng(37.42613857401658,126.74999713897746), 
		width: "1200px",
		height: "600px",
		zoom: 16
	});
	
	// 마커
	var marker = new Tmapv2.Marker({
		position: new Tmapv2.LatLng(37.42613857401658,126.74999713897746),
		map: map
	});	

	//선
	var polyline = new Tmapv2.Polyline({
	    path: [new Tmapv2.LatLng(37.566381,126.985123),
	    	new Tmapv2.LatLng(37.566581,126.985123),
	    	new Tmapv2.LatLng(37.566381,126.985273),
	    	new Tmapv2.LatLng(37.566581,126.985423),
	    	new Tmapv2.LatLng(37.566381,126.985423)],
	    strokeColor: "#dd00dd",
	    strokeWeight: 6,
	    map: map
	});
	
	//다각형
   var polygon = new Tmapv2.Polygon({
        paths: [new Tmapv2.LatLng(37.566610,126.985666),
            new Tmapv2.LatLng(37.566595,126.985985),
            new Tmapv2.LatLng(37.566512,126.986071),
            new Tmapv2.LatLng(37.566397,126.985894),
            new Tmapv2.LatLng(37.566395,126.985664)],
        fillColor:"pink",
        draggable: true,
        map: map
    });
}

function fn_bound() {
	//지도의 대각선 위경도 좌표를 보여줍니다.
	var bound = map.getBounds(); //지도의 영역을 가져오는 함수
	var result = '[ WGS84 ]영역은 ' + bound + '입니다.'; // 표출할 메시지
	var resultDiv = document.getElementById("result"); // 메시지가 표시될 요소
	resultDiv.innerHTML = result; // 요소의 메시지 값을 변경
}

function onClick(e) {
	var result = '클릭한 위치의 좌표는' + e.latLng + '입니다.';
	var resultDiv = document.getElementById("result");
	resultDiv.innerHTML = result;
}

</script>


</head>
<body>
	<div id="map_div"></div>
	<div>
		<button onClick="fn_bound()">WGS84 좌표</button>
		<p id="result" />
	</div>
</body>
</html>
