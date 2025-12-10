import { create } from "zustand";
import type { Heoby, HeobyList } from "../type/domain/heoby.domain";

interface HeobyStore {
  heobyList: HeobyList | null;
  selectedHeoby: Heoby | null;
  selectedAddress: string | null;
  setHeobyList: (list: HeobyList) => void;
  setSelectedHeoby: (heoby: Heoby) => void;
  clearSelectedHeoby: () => void;
  setSelectedAddress: (address: string | null) => void;
  reset: () => void;
}

export const useHeobyStore = create<HeobyStore>((set) => ({
  heobyList: null,
  selectedHeoby: null,
  selectedAddress: null,

  setHeobyList: (list: HeobyList) => set({ heobyList: list }),
  setSelectedHeoby: (heoby: Heoby) => set({ selectedHeoby: heoby }),
  clearSelectedHeoby: () => set({ selectedHeoby: null }),
  setSelectedAddress: (address: string | null) =>
    set({ selectedAddress: address }),
  reset: () =>
    set({ heobyList: null, selectedHeoby: null, selectedAddress: null }),
}));
