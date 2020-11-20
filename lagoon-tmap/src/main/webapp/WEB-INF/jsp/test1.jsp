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

	var unq_tmak = "30c275dc-dc9f-4ae4-bd12-9a17c9c76231";
	var map;

	var myHome = [ 37.42613857401658, 126.74999713897746 ];
	var target = [ 37.4206513831434, 126.74134969711344 ];

	function initTmap() {
		map = new Tmapv2.Map("map_div", {
			center : new Tmapv2.LatLng(myHome[0], myHome[1]),
			width : "1200px",
			height : "600px",
			zoom : 16
		});
	}

	function fn_test() {
		// 마커
		var marker = new Tmapv2.Marker({
			position : new Tmapv2.LatLng(myHome[0], myHome[1]),
			map : map
		});

		//선
		var polyline = new Tmapv2.Polyline({
			path : [ new Tmapv2.LatLng(37.566381, 126.985123),
					new Tmapv2.LatLng(37.566581, 126.985123),
					new Tmapv2.LatLng(37.566381, 126.985273),
					new Tmapv2.LatLng(37.566581, 126.985423),
					new Tmapv2.LatLng(37.566381, 126.985423) ],
			strokeColor : "#dd00dd",
			strokeWeight : 6,
			map : map
		});

		//다각형
		var polygon = new Tmapv2.Polygon({
			paths : [ new Tmapv2.LatLng(37.566610, 126.985666),
					new Tmapv2.LatLng(37.566595, 126.985985),
					new Tmapv2.LatLng(37.566512, 126.986071),
					new Tmapv2.LatLng(37.566397, 126.985894),
					new Tmapv2.LatLng(37.566395, 126.985664) ],
			fillColor : "pink",
			draggable : true,
			map : map
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

	var new_polyLine = [];
	var new_Click_polyLine = [];

	function drawData(data) {
		// 지도위에 선은 다 지우기
		routeData = data;
		var resultStr = "";
		var distance = 0;
		var idx = 1;
		var newData = [];
		var equalData = [];
		var pointId1 = "-1234567";
		var ar_line = [];
		for (var i = 0; i < data.features.length; i++) {
			var feature = data.features[i];
			//배열에 경로 좌표 저장
			if (feature.geometry.type == "LineString") {
				ar_line = [];
				for (var j = 0; j < feature.geometry.coordinates.length; j++) {
					var startPt = new Tmapv2.LatLng(feature.geometry.coordinates[j][1], feature.geometry.coordinates[j][0]);
					ar_line.push(startPt);
				}
				var polyline = new Tmapv2.Polyline({
					path : ar_line,
					strokeColor : "#ff0000",
					strokeWeight : 6,
					map : map
				});
				new_polyLine.push(polyline);
			}
			var pointId2 = feature.properties.viaPointId;
			if (pointId1 != pointId2) {
				equalData = [];
				equalData.push(feature);
				newData.push(equalData);
				pointId1 = pointId2;
			} else {
				equalData.push(feature);
			}
		}
		geoData = newData;
		var markerCnt = 1;
		for (var i = 0; i < newData.length; i++) {
			var mData = newData[i];
			var type = mData[0].geometry.type;
			var pointType = mData[0].properties.pointType;
			var pointTypeCheck = false; // 경유지 일때만 true
			if (mData[0].properties.pointType == "S") {
				var img = 'http://tmapapis.sktelecom.com/upload/tmap/marker/pin_r_m_s.png';
				var lon = mData[0].geometry.coordinates[0];
				var lat = mData[0].geometry.coordinates[1];
			} else if (mData[0].properties.pointType == "E") {
				var img = 'http://tmapapis.sktelecom.com/upload/tmap/marker/pin_r_m_e.png';
				var lon = mData[0].geometry.coordinates[0];
				var lat = mData[0].geometry.coordinates[1];
			} else {
				markerCnt = i;
				var lon = mData[0].geometry.coordinates[0];
				var lat = mData[0].geometry.coordinates[1];
			}
		}
	}

	function addMarker(status, lon, lat, tag) {
		//출도착경유구분
		var markerLayer;
		switch (status) {
		case "llStart":
			imgURL = 'http://tmapapis.sktelecom.com/upload/tmap/marker/pin_r_m_s.png';
			break;
		case "llPass":
			imgURL = 'http://tmapapis.sktelecom.com/upload/tmap/marker/pin_b_m_p.png';
			break;
		case "llEnd":
			imgURL = 'http://tmapapis.sktelecom.com/upload/tmap/marker/pin_r_m_e.png';
			break;
		default:
		};
		var marker = new Tmapv2.Marker({
			position : new Tmapv2.LatLng(lat, lon),
			icon : imgURL,
			map : map
		});
		return marker;
	}

	var fn_find = function() {
		// 시작, 도착 심볼 찍기
		addMarker("llStart", myHome[1], myHome[0], 1);
		addMarker("llEnd", target[1], target[0], 2);
		// 경유지 심볼 찍기
		addMarker("llPass", 126.74712998475393,37.429435198839975, 3);
		// 경로탐색 API 사용요청
		var startX = myHome[1];
		var startY = myHome[0];
		var endX = target[1];
		var endY = target[0];
		var passList = "126.74712998475393,37.429435198839975";
		var prtcl;
		var headers = {};
		headers["appKey"] = unq_tmak;
		$.ajax({
			method : "POST",
			headers : headers,
			url : "https://apis.openapi.sk.com/tmap/routes?version=1&format=json",
			async : false,
			data : {
				startX : startX,
				startY : startY,
				endX : endX,
				endY : endY,
				// passList : passList,
				reqCoordType : "WGS84GEO",
				resCoordType : "WGS84GEO",
				angle : "172",
				searchOption : "0",
				trafficInfo : "Y"
			},
			success : function(response) {
				console.log(response);
				prtcl = response;
				// 경로탐색 결과 Line 그리기 
				drawData(prtcl);
				// 경로탐색 결과 반경만큼 지도 레벨 조정
				var newData = geoData[0];
				PTbounds = new Tmapv2.LatLngBounds();
				for (var i = 0; i < newData.length; i++) {
					var mData = newData[i];
					var type = mData.geometry.type;
					var pointType = mData.properties.pointType;
					if (type == "Point") {
						var linePt = new Tmapv2.LatLng(mData.geometry.coordinates[1], mData.geometry.coordinates[0]);
// 						console.log(linePt);
						PTbounds.extend(linePt);
					} else {
						var startPt, endPt;
						for (var j = 0; j < mData.geometry.coordinates.length; j++) {
							var linePt = new Tmapv2.LatLng(mData.geometry.coordinates[j][1], mData.geometry.coordinates[j][0]);
							PTbounds.extend(linePt);
						}
					}
				}
				map.fitBounds(PTbounds);

			},
			error : function(request, status, error) {
				console.log("code:" + request.status + "\n"
						+ "message:" + request.responseText + "\n"
						+ "error:" + error);
			}
		});
	}
</script>


</head>
<body>
	<div id="map_div"></div>
	<div>
		<button onClick="fn_bound()">WGS84 좌표</button>
		<button onClick="fn_find()">길 찾기2</button>
		<p id="result" />
	</div>
</body>
</html>
