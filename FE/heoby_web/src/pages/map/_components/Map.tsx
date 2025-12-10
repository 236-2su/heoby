import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import HeobyIcon from "../../../assets/icons/heoby.svg";
import { useAutoSelectHeoby } from "../../../features/heoby/hooks/useHeoby";
import { useHeobyStore } from "../../../features/heoby/store/heobyStore";
import { getHeobyStatusStyle } from "../../../shared/utils/heobyStatus";

interface MapProps {
  className?: string;
}

export default function Map({ className }: MapProps) {
  const mapRef = useRef<naver.maps.Map | null>(null);
  const markersRef = useRef<Map<string, naver.maps.Marker>>(
    new globalThis.Map<string, naver.maps.Marker>()
  );
  const infoRef = useRef<naver.maps.InfoWindow | null>(null);

  const selectedHeoby = useHeobyStore((state) => state.selectedHeoby);
  const setSelectedHeoby = useHeobyStore((state) => state.setSelectedHeoby);
  const setSelectedAddress = useHeobyStore((state) => state.setSelectedAddress);
  const { heobyList } = useHeobyStore();

  // 첫 번째 허수아비 자동 선택
  useAutoSelectHeoby();

  const [address, setAddress] = useState("");
  const [_coords, setCoords] = useState<{ lat: number; lng: number } | null>(
    null
  );

  const [_zoom, setZoom] = useState(15);

  // 좌표를 주소로 변환
  const searchCoordinateToAddress = useCallback((latlng: naver.maps.LatLng) => {
    if (!window.naver?.maps?.Service) {
      const fallback = `위도: ${latlng.lat().toFixed(6)}, 경도: ${latlng.lng().toFixed(6)}`;
      setAddress(fallback);
      setSelectedAddress(fallback);
      return;
    }

    naver.maps.Service.reverseGeocode(
      {
        coords: latlng,
        orders: [
          naver.maps.Service.OrderType.ADDR,
          naver.maps.Service.OrderType.ROAD_ADDR,
        ].join(","),
      },
      (status, response) => {
        if (status !== naver.maps.Service.Status.OK) {
          // API 실패 시 좌표 표시
          const fallback = `위도: ${latlng.lat().toFixed(6)}, 경도: ${latlng.lng().toFixed(6)}`;
          setAddress(fallback);
          setSelectedAddress(fallback);
          return;
        }

        const result = response.v2;
        const items = result.results;
        const addressItem = items[0];

          if (addressItem) {
            // 지번 주소 우선 표시
            let addr = "";

          if (addressItem.land) {
            // 지번 주소 조합
            const region = addressItem.region;
            const land = addressItem.land;

            addr = `${region.area1.name} ${region.area2.name} ${region.area3.name} ${region.area4.name}`;

            if (land.number1) {
              addr += ` ${land.number1}`;
              if (land.number2) {
                addr += `-${land.number2}`;
              }
            }
          } else if (addressItem.region) {
            // land 정보가 없으면 region만 표시
            addr = `${addressItem.region.area1.name} ${addressItem.region.area2.name} ${addressItem.region.area3.name}`;
          }

          const resolved = addr.trim();
          setAddress(resolved);
          setSelectedAddress(resolved);
        } else {
          const fallback = `위도: ${latlng.lat().toFixed(6)}, 경도: ${latlng.lng().toFixed(6)}`;
          setAddress(fallback);
          setSelectedAddress(fallback);
        }
      }
    );
  }, [setSelectedAddress]);

  const buildMarkerIcon = (isSelected: boolean) => ({
    content: `
      <div style="
        width: 40px;
        height: 40px;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        position: relative;
      ">
        <img
          src="${HeobyIcon}"
          alt="허수아비"
          style="
            width: 100%;
            height: 100%;
            filter: ${
              isSelected
                ? "drop-shadow(0 0 8px #3b82f6) brightness(1.2)"
                : "drop-shadow(0 2px 4px rgba(0,0,0,0.3))"
            };
            transition: all 0.3s ease;
          "
        />
      </div>
    `,
    anchor: new naver.maps.Point(20, 40),
  });

  // 모든 마커 생성
  const syncMarkers = useCallback(() => {
    if (!mapRef.current || !heobyList) return;

    const allHeobies = [...heobyList.my, ...heobyList.other];
    const activeMarkerIds = new Set<string>();

    allHeobies.forEach((heoby) => {
      activeMarkerIds.add(heoby.uuid);
      const position = new naver.maps.LatLng(
        heoby.location.lat,
        heoby.location.lon
      );

      let marker = markersRef.current.get(heoby.uuid);

      if (!marker) {
        marker = new naver.maps.Marker({
          position,
          map: mapRef.current!,
          title: heoby.name,
          icon: buildMarkerIcon(selectedHeoby?.uuid === heoby.uuid),
        });

        naver.maps.Event.addListener(marker, "click", () => {
          const latlng = new naver.maps.LatLng(
            heoby.location.lat,
            heoby.location.lon
          );

          setSelectedHeoby(heoby);

          mapRef.current?.panTo(latlng, {
            duration: 500,
            easing: "easeOutCubic",
          });

          setCoords({ lat: heoby.location.lat, lng: heoby.location.lon });

          searchCoordinateToAddress(latlng);
        });

        markersRef.current.set(heoby.uuid, marker);
      } else {
        marker.setPosition(position);
        marker.setMap(mapRef.current!);
      }
    });

    // stale markers 제거
    markersRef.current.forEach((marker, uuid) => {
      if (!activeMarkerIds.has(uuid)) {
        marker.setMap(null);
        markersRef.current.delete(uuid);
      }
    });
  }, [heobyList, searchCoordinateToAddress, selectedHeoby?.uuid, setSelectedHeoby]);

  const highlightSelectedMarker = useCallback(() => {
    markersRef.current.forEach((marker, uuid) => {
      const isSelected = selectedHeoby?.uuid === uuid;
      marker.setIcon(buildMarkerIcon(isSelected));
      marker.setZIndex(isSelected ? 10 : 0);
    });
  }, [selectedHeoby?.uuid]);

  const statusMeta = useMemo(() => {
    const statusInfo = getHeobyStatusStyle(selectedHeoby?.status);
    return {
      label: statusInfo.label,
      bg: statusInfo.bgColor,
      color: statusInfo.textColor,
    };
  }, [selectedHeoby?.status]);

  // 지도 초기화
  const initializeMap = useCallback(() => {
    if (mapRef.current) return;
    const map = new naver.maps.Map("map", {
      center: new naver.maps.LatLng(37.3595316, 127.1052133),
      zoom: 17,
      scrollWheel: false, // 휠 줌 비활성화
      scaleControl: false,
      logoControl: false,
      mapDataControl: false,
      zoomControl: false, // 기본 줌 컨트롤 비활성화
    });

    mapRef.current = map;
    infoRef.current = new naver.maps.InfoWindow({ content: "" });

    // 줌 변경 리스너
    naver.maps.Event.addListener(map, "zoom_changed", () => {
      setZoom(map.getZoom());
    });

    // 마커 생성
    syncMarkers();
    highlightSelectedMarker();
  }, [syncMarkers, highlightSelectedMarker]);

  // Naver Maps 스크립트 동적 로드
  useEffect(() => {
    // 이미 로드되어 있으면 바로 초기화
    if (window.naver?.maps) {
      initializeMap();
      return;
    }

    const scriptId = "naver-maps-sdk";
    const existingScript = document.getElementById(scriptId) as
      | HTMLScriptElement
      | null;

    if (existingScript) {
      existingScript.onload = () => initializeMap();
      return;
    }

    const script = document.createElement("script");
    script.id = scriptId;
    script.src = `https://oapi.map.naver.com/openapi/v3/maps.js?ncpKeyId=${
      import.meta.env.VITE_NCP_APIGW_API_KEY_ID
    }&submodules=geocoder`;
    script.async = true;
    script.onload = () => initializeMap();
    script.onerror = () => {};

    document.head.appendChild(script);

    return () => {
      if (!window.naver?.maps && script.parentNode) {
        script.parentNode.removeChild(script);
      }
    };
  }, [initializeMap]);

  // 허수아비 리스트가 변경될 때 마커 재생성
  useEffect(() => {
    if (mapRef.current) {
      syncMarkers();
      highlightSelectedMarker();
    }
  }, [heobyList, syncMarkers, highlightSelectedMarker]);

  // 선택된 허수아비 위치로 지도 이동
  useEffect(() => {
    if (!selectedHeoby || !mapRef.current) return;

    const { location } = selectedHeoby;
    const latlng = new naver.maps.LatLng(location.lat, location.lon);

    // 지도 중심 이동 (부드러운 애니메이션)
    mapRef.current.panTo(latlng, {
      duration: 500,
      easing: "easeOutCubic",
    });

    // 좌표 상태 업데이트
    setCoords({ lat: location.lat, lng: location.lon });

    // 마커 업데이트 (선택된 마커 강조)
    highlightSelectedMarker();

    // InfoWindow 업데이트 (허수아비 정보 표시)
    if (infoRef.current) {
      infoRef.current.setContent(`
        <div style="padding: 10px; min-width: 200px; font-family: 'NanumMyeongjo', system-ui, sans-serif;">
          <h4 style="margin: 0 0 5px 0;">${selectedHeoby.name}</h4>
          <p style="margin: 0; font-size: 12px;">주인: ${selectedHeoby.owner_name}</p>

        </div>
      `);
    }

    // 주소 검색
    searchCoordinateToAddress(latlng);
  }, [selectedHeoby, highlightSelectedMarker, searchCoordinateToAddress]);

  const handleZoomIn = () => {
    if (mapRef.current) {
      mapRef.current.setZoom(mapRef.current.getZoom() + 1);
    }
  };

  const handleZoomOut = () => {
    if (mapRef.current) {
      mapRef.current.setZoom(mapRef.current.getZoom() - 1);
    }
  };

  return (
    <div style={{ width: "100%", height: "100%", position: "relative" }}>
      <div
        id="map"
        style={{ width: "100%", height: "100%" }}
        className={`sh ${className ?? ""} custom-surface-card`}
      />

      {/* 상단 주소 표시 */}
      {(selectedHeoby || address) && (
        <div
          style={{
            position: "absolute",
            top: "20px",
            left: "50%",
            transform: "translateX(-50%)",
            background: statusMeta.bg,
            padding: "12px 20px",
            borderRadius: "12px",
            boxShadow: "0 2px 8px rgba(0,0,0,0.15)",
            zIndex: 100,
            minWidth: "250px",
            textAlign: "center",
            border: `1px solid ${statusMeta.color}22`,
            fontFamily: "'NanumMyeongjo', system-ui, sans-serif",
          }}
        >
          {selectedHeoby ? (
            <>
              <h4
                style={{
                  margin: "0 0 5px 0",
                  fontSize: "16px",
                  fontWeight: "bold",
                  color: "#111827",
                }}
              >
                {selectedHeoby.name}
              </h4>
              <p style={{ margin: "0", fontSize: "13px", color: "#4b5563" }}>
                {address || "주소 로딩 중..."}
              </p>
              <p
                style={{
                  margin: "5px 0 0 0",
                  fontSize: "11px",
                  color: statusMeta.color,
                  fontWeight: 700,
                }}
              >
                주인: {selectedHeoby.owner_name} | 상태: {statusMeta.label}
              </p>
            </>
          ) : (
            <>
              <h4
                style={{
                  margin: "0 0 5px 0",
                  fontSize: "14px",
                  fontWeight: "bold",
                }}
              >
                선택한 위치
              </h4>
              <p style={{ margin: "0", fontSize: "13px", color: "#666" }}>
                {address || "주소 로딩 중..."}
              </p>
            </>
          )}
        </div>
      )}

      {/* 줌 컨트롤 */}
      <div
        style={{
          position: "absolute",
          bottom: "20px",
          right: "20px",
          display: "flex",
          flexDirection: "column",
          gap: "8px",
          zIndex: 100,
        }}
      >
        <button
          onClick={handleZoomIn}
          style={{
            width: "40px",
            height: "40px",
            background: "#ffffff",
            border: "1px solid #e5e7eb",
            borderRadius: "8px",
            boxShadow: "0 2px 8px rgba(0,0,0,0.15)",
            cursor: "pointer",
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            fontSize: "20px",
            fontWeight: "bold",
            color: "#374151",
            transition: "all 0.2s",
          }}
          onMouseEnter={(e) => {
            e.currentTarget.style.background = "#f3f4f6";
          }}
          onMouseLeave={(e) => {
            e.currentTarget.style.background = "#ffffff";
          }}
        >
          +
        </button>
        <button
          onClick={handleZoomOut}
          style={{
            width: "40px",
            height: "40px",
            background: "#ffffff",
            border: "1px solid #e5e7eb",
            borderRadius: "8px",
            boxShadow: "0 2px 8px rgba(0,0,0,0.15)",
            cursor: "pointer",
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            fontSize: "20px",
            fontWeight: "bold",
            color: "#374151",
            transition: "all 0.2s",
          }}
          onMouseEnter={(e) => {
            e.currentTarget.style.background = "#f3f4f6";
          }}
          onMouseLeave={(e) => {
            e.currentTarget.style.background = "#ffffff";
          }}
        >
          −
        </button>
      </div>
    </div>
  );
}
