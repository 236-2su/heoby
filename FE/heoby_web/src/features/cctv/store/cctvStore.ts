/**
 * CCTV 상태 관리 Store
 */

import { create } from "zustand";
import type { Cctv, ConnectionStatus } from "../type/domain/cctv.domain";
import { CONNECTION_STATUS } from "../type/domain/cctv.domain";

interface CctvStore {
  // 상태
  selectedCctv: Cctv | null;
  connectionStatus: ConnectionStatus;
  stream: MediaStream | null;

  // 액션
  setSelectedCctv: (cctv: Cctv) => void;
  setConnectionStatus: (status: ConnectionStatus) => void;
  setStream: (stream: MediaStream | null) => void;
  clearStream: () => void;
  reset: () => void;
}

export const useCctvStore = create<CctvStore>((set) => ({
  // 초기 상태
  selectedCctv: null,
  connectionStatus: CONNECTION_STATUS.DISCONNECTED,
  stream: null,

  // CCTV 선택
  setSelectedCctv: (cctv) => {
    set({ selectedCctv: cctv });
  },

  // 연결 상태 설정
  setConnectionStatus: (status) => {
    set({ connectionStatus: status });
  },

  // 스트림 설정
  setStream: (stream) => {
    set({ stream });
  },

  // 스트림 정리
  clearStream: () => {
    set((state) => {
      // 기존 스트림 트랙 정리
      state.stream?.getTracks().forEach((track) => track.stop());
      return { stream: null };
    });
  },
  reset: () =>
    set(() => ({
      selectedCctv: null,
      connectionStatus: CONNECTION_STATUS.DISCONNECTED,
      stream: null,
    })),
}));
