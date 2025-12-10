import { useCctvStream } from "@/features/cctv";
import { useHeobyList } from "@/features/heoby/hooks/useHeoby";
import { useHeobyStore } from "@/features/heoby/store/heobyStore";
import type { Heoby } from "@/features/heoby/type/domain/heoby.domain";
import { getHeobyStatusStyle } from "@/shared/utils/heobyStatus";
import { Camera } from "lucide-react";
import { useCallback, useEffect, useMemo, useState } from "react";
import { BaseBox } from "../../shared/components/Box/BaseBox";
import { BaseLayout } from "../../shared/components/Layout/BaseLayout";
import { Loading } from "../../shared/components/Loading/Loading";
import "../../styles/pages/cctv.css";

export function CctvPage() {
  const { isLoading } = useHeobyList();
  const { heobyList } = useHeobyStore();
  const [selectedHeoby, setSelectedHeoby] = useState<Heoby | null>(null);
  const [isPlaying] = useState(true);

  // WebRTC 훅 사용
  const { videoRef, connectionStatus, isConnected, isInitialized, switchCctv } =
    useCctvStream();

  // 허수아비 목록 합치기
  const allHeobys = useMemo(() => {
    const myHeobys = heobyList?.my ?? [];
    const otherHeobys = heobyList?.other ?? [];
    return [...myHeobys, ...otherHeobys];
  }, [heobyList]);

  const heobysWithSerial = useMemo(
    () => allHeobys.filter((heoby) => heoby.serial_number != null),
    [allHeobys]
  );

  const buildStreamPath = useCallback((serialNumber?: string | null) => {
    if (serialNumber == null) {
      return null;
    }
    // 시리얼 넘버를 그대로 사용
    return serialNumber;
  }, []);

  // 초기 선택된 허수아비 설정
  useEffect(() => {
    if (heobysWithSerial.length > 0 && !selectedHeoby) {
      setSelectedHeoby(heobysWithSerial[0]);
    }
  }, [heobysWithSerial, selectedHeoby]);

  // 허수아비 선택 변경 시 CCTV 스트림 전환
  useEffect(() => {
    if (!isInitialized || !selectedHeoby) {
      return;
    }

    const path = buildStreamPath(selectedHeoby.serial_number);
    if (!path) {
      return;
    }

    // 시리얼 넘버로 먼저 연결 시도, 실패하면 "cctv"로 폴백
    void switchCctv(path).catch(() => {
      return switchCctv("cctv").catch(() => {
        // 두 번째 시도도 실패
      });
    });
  }, [buildStreamPath, isInitialized, selectedHeoby, switchCctv]);

  if (isLoading) {
    return (
      <BaseLayout>
        <div className="py-4 flex items-center justify-center min-h-[400px]">
          <Loading />
        </div>
      </BaseLayout>
    );
  }

  if (!selectedHeoby) {
    return (
      <BaseLayout>
        <div className="py-4 flex items-center justify-center min-h-[400px]">
          <p className="text-gray-500">등록된 허수아비가 없습니다.</p>
        </div>
      </BaseLayout>
    );
  }

  return (
    <BaseLayout>
      <div className="py-4">
        <section className="custom-cctv-grid mt-4">
          <div className="custom-cctv-grid__list">
            <BaseBox
              title="허수아비 목록"
              className="h-full"
              contentClassName="flex flex-col gap-3"
              contentPadding={16}
              scrollable={true}
            >
              {allHeobys.map((heoby) => {
                const statusInfo = getHeobyStatusStyle(heoby.status);
                return (
                  <button
                    key={heoby.uuid}
                    onClick={() => setSelectedHeoby(heoby)}
                    className={`w-full p-3 text-left border rounded-[20px] transition ${
                      selectedHeoby.uuid === heoby.uuid
                        ? "border-blue-500 bg-blue-50"
                        : "border-gray-300 hover:bg-gray-50"
                    }`}
                  >
                    <div className="flex items-start justify-between">
                      <div className="flex-1">
                        <div className="font-medium text-sm">{heoby.name}</div>
                        <div className="text-xs text-gray-600 mt-1">
                          주인: {heoby.owner_name}
                        </div>
                      </div>
                      <span
                        className="text-xs px-2 py-1 rounded-full"
                        style={{
                          backgroundColor: statusInfo.bgColor,
                          color: statusInfo.textColor,
                        }}
                      >
                        {statusInfo.label}
                      </span>
                    </div>
                  </button>
                );
              })}
            </BaseBox>
          </div>

          <div className="custom-cctv-grid__video">
            <BaseBox title={selectedHeoby.name} contentPadding={0}>
              <div className="relative w-full aspect-video bg-gray-900 overflow-hidden">
                <video
                  ref={videoRef}
                  autoPlay
                  playsInline
                  muted={!isPlaying}
                  className="w-full h-full object-cover block"
                />

                {!isConnected && (
                  <div className="absolute inset-0 flex items-center justify-center bg-gray-900">
                    <div className="text-center text-gray-400">
                      <Camera className="w-16 h-16 mx-auto mb-4" />
                      <p className="text-lg">
                        {connectionStatus === "connecting"
                          ? "연결 중..."
                          : "CCTV 피드"}
                      </p>
                      <p className="text-sm mt-2">
                        주인: {selectedHeoby.owner_name}
                      </p>
                      <p className="text-xs mt-1">
                        {connectionStatus === "failed" && "연결 실패"}
                        {connectionStatus === "disconnected" && "연결 대기 중"}
                        {connectionStatus === "connecting" && "연결 시도 중..."}
                      </p>
                    </div>
                  </div>
                )}

                <div className="absolute top-4 left-4">
                  <span
                    className={`px-3 py-1 rounded-full text-xs font-semibold ${
                      isConnected
                        ? "bg-green-500 text-white"
                        : connectionStatus === "connecting"
                        ? "bg-yellow-500 text-white"
                        : "bg-red-500 text-white"
                    }`}
                  >
                    {isConnected
                      ? "연결됨"
                      : connectionStatus === "connecting"
                      ? "연결 중"
                      : "연결 안됨"}
                  </span>
                </div>
              </div>
            </BaseBox>
          </div>
        </section>
      </div>
    </BaseLayout>
  );
}
