import { useCallback, useEffect, useRef, useState } from "react";
import { useCctvStore } from "../store/cctvStore";
import { CONNECTION_STATUS } from "../type/domain/cctv.domain";
import { showErrorToast } from "@/shared/lib/toast";

interface WhepOptions {
  url: string;
}

const useWhepOptions = (): WhepOptions => {
  const url = import.meta.env.VITE_CCTV_BASE_URL;

  return { url };
};

const buildRequestUrl = (baseUrl: string, serialNumber: string) => {
  // ${VITE_CCTV_BASE_URL}/${serial_number}/whep 형식
  console.log(`${baseUrl}/${serialNumber}/whep`);
  return `${baseUrl}/${serialNumber}/whep`;
};

export function useCctvStream() {
  const { url: whepUrl } = useWhepOptions();
  const videoRef = useRef<HTMLVideoElement>(null);
  const peerRef = useRef<RTCPeerConnection | null>(null);
  const abortRef = useRef<AbortController | null>(null);

  const connectionStatus = useCctvStore((state) => state.connectionStatus);
  const setConnectionStatus = useCctvStore(
    (state) => state.setConnectionStatus
  );
  const stream = useCctvStore((state) => state.stream);
  const setStream = useCctvStore((state) => state.setStream);
  const clearStream = useCctvStore((state) => state.clearStream);

  const [isInitialized, setIsInitialized] = useState(false);
  const [isSwitching, setIsSwitching] = useState(false);
  const [error, setError] = useState<Error | null>(null);

  const cleanupPeer = useCallback(() => {
    abortRef.current?.abort();
    abortRef.current = null;
    peerRef.current
      ?.getReceivers()
      .forEach((receiver) => receiver.track?.stop());
    peerRef.current?.getSenders().forEach((sender) => sender.track?.stop());
    peerRef.current?.close();
    peerRef.current = null;
    clearStream();
    if (videoRef.current) {
      videoRef.current.srcObject = null;
    }
  }, [clearStream]);

  const disconnect = useCallback(() => {
    cleanupPeer();
    setConnectionStatus(CONNECTION_STATUS.DISCONNECTED);
  }, [cleanupPeer, setConnectionStatus]);

  const createPeer = useCallback(() => {
    const pc = new RTCPeerConnection({
      iceServers: [{ urls: "stun:stun.l.google.com:19302" }],
    });

    pc.addTransceiver("video", { direction: "recvonly" });
    pc.addTransceiver("audio", { direction: "recvonly" });

    pc.ontrack = (event) => {
      const [stream] = event.streams;
      if (stream) {
        setStream(stream);
        if (videoRef.current) {
          videoRef.current.srcObject = stream;
        }
      }
    };

    pc.onconnectionstatechange = () => {
      switch (pc.connectionState) {
        case "connected":
          setConnectionStatus(CONNECTION_STATUS.CONNECTED);
          break;
        case "connecting":
          setConnectionStatus(CONNECTION_STATUS.CONNECTING);
          break;
        case "failed":
          setConnectionStatus(CONNECTION_STATUS.FAILED);
          break;
        case "disconnected":
        case "closed":
          setConnectionStatus(CONNECTION_STATUS.DISCONNECTED);
          break;
        default:
          break;
      }
    };

    pc.oniceconnectionstatechange = () => {
      if (pc.iceConnectionState === "failed") {
        setConnectionStatus(CONNECTION_STATUS.FAILED);
      }
    };

    return pc;
  }, [setConnectionStatus, setStream]);

  const connectToPath = useCallback(
    async (serialNumber: string) => {
      setIsSwitching(true);
      setError(null);
      setConnectionStatus(CONNECTION_STATUS.CONNECTING);
      cleanupPeer();

      const abortController = new AbortController();
      abortRef.current = abortController;
      const timeoutId = window.setTimeout(() => abortController.abort(), 15000);

      try {
        const peer = createPeer();
        peerRef.current = peer;

        const offer = await peer.createOffer();
        await peer.setLocalDescription(offer);

        const endpoint = buildRequestUrl(whepUrl, serialNumber);
        const response = await fetch(endpoint, {
          method: "POST",
          headers: {
            "Content-Type": "application/sdp",
            Accept: "application/sdp",
          },
          signal: abortController.signal,
          body: offer.sdp ?? "",
        });

        if (!response.ok) {
          throw new Error(`WHEP 요청 실패 (status: ${response.status})`);
        }

        const answerSdp = await response.text();
        await peer.setRemoteDescription({ type: "answer", sdp: answerSdp });
        setConnectionStatus(CONNECTION_STATUS.CONNECTED);
      } catch (err) {
        const errorInstance =
          err instanceof Error ? err : new Error("WHEP 연결 실패");
        if (!abortController.signal.aborted) {
          showErrorToast(
            errorInstance.message || "CCTV 연결에 실패했습니다. 다시 시도해주세요."
          );
        }
        setError(errorInstance);
        cleanupPeer();
        setConnectionStatus(CONNECTION_STATUS.FAILED);
        throw errorInstance;
      } finally {
        window.clearTimeout(timeoutId);
        abortRef.current = null;
        setIsSwitching(false);
      }
    },
    [cleanupPeer, createPeer, setConnectionStatus, whepUrl]
  );

  useEffect(() => {
    setIsInitialized(true);
    return () => {
      disconnect();
    };
  }, [disconnect]);

  return {
    videoRef,
    connectionStatus,
    isConnected: connectionStatus === CONNECTION_STATUS.CONNECTED,
    stream,
    isInitialized,
    isLoading: isSwitching,
    isError: Boolean(error),
    error,
    switchCctv: connectToPath,
    disconnect,
  };
}
