import { useEffect, useRef, useState } from "react";

const DEFAULT_BASE_URL = import.meta.env.VITE_CCTV_BASE_URL;

interface CCTVPlayerProps {
  baseUrl?: string;
  streamPath?: string;
}

export function CCTVPlayer({
  baseUrl = DEFAULT_BASE_URL,
  streamPath = "cctv",
}: CCTVPlayerProps = {}) {
  const videoRef = useRef<HTMLVideoElement>(null);
  const [connectionState, setConnectionState] = useState<string>("연결 중...");

  useEffect(() => {
    const peer = new RTCPeerConnection({
      iceServers: [{ urls: "stun:stun.l.google.com:19302" }],
    });

    // WHEP는 수신 전용이므로 recvonly 설정
    peer.addTransceiver("video", { direction: "recvonly" });

    peer.ontrack = (event) => {
      const [stream] = event.streams;
      if (videoRef.current && stream) {
        videoRef.current.srcObject = stream;
        setConnectionState("스트림 수신 중");
      }
    };

    peer.onconnectionstatechange = () => {
      setConnectionState(`연결 상태: ${peer.connectionState}`);
    };

    const connect = async () => {
      const offer = await peer.createOffer();
      await peer.setLocalDescription(offer);

      // cctv <= 시리얼 넘버
      const whepEndpoint = `${baseUrl}/cctv/whep`;

      const response = await fetch(whepEndpoint, {
        method: "POST",
        headers: { "Content-Type": "application/sdp" },
        body: offer.sdp ?? "",
      });

      if (!response.ok) {
        throw new Error(
          `WHEP 연결 실패 (status: ${response.status} ${response.statusText})`
        );
      }

      const answer = await response.text();
      await peer.setRemoteDescription({ type: "answer", sdp: answer });
    };

    connect().catch((err) => {
      console.error("CCTV 스트림 연결 실패:", err);
      setConnectionState(`연결 실패: ${err.message}`);
    });

    return () => {
      peer.close();
    };
  }, [baseUrl, streamPath]);

  return (
    <div className="relative">
      <video
        ref={videoRef}
        autoPlay
        playsInline
        controls={false}
        muted
        className="w-full rounded-xl bg-black"
      />
      <div className="absolute top-2 left-2 bg-black/50 text-white text-xs px-2 py-1 rounded">
        {connectionState}
      </div>
    </div>
  );
}
