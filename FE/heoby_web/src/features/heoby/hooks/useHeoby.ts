import { useUserStore } from "@/features/auth/store/userStore";
import { useHeobyStore } from "@/features/heoby/store/heobyStore";
import { useQuery } from "@tanstack/react-query";
import { useEffect } from "react";
import { HeobyApi } from "../api/heobyApi";
import { HeobyListMapper, type HeobyListDto } from "../type/dto/heoby.dto";

export const HEOBY_KEYS = {
  type: ["heoby"] as const,
  list: (role: string) => [...HEOBY_KEYS.type, "list", role] as const,
} as const;

export const useHeobyList = () => {
  const role = useUserStore((state) => state.role);
  const setHeobyList = useHeobyStore((state) => state.setHeobyList);

  const query = useQuery<HeobyListDto, Error>({
    queryKey: role ? HEOBY_KEYS.list(role) : ["heoby", "list"],
    queryFn: () => {
      if (!role) {
        throw new Error("권한 정보가 없습니다");
      }
      return HeobyApi.getList(role);
    },
    enabled: !!role,
  });

  useEffect(() => {
    if (!query.data) return;

    const mappedData = HeobyListMapper.formDto(query.data);
    setHeobyList(mappedData);
  }, [query.data, setHeobyList]);

  return query;
};

export const useAutoSelectHeoby = () => {
  const heobyList = useHeobyStore((state) => state.heobyList);
  const selectedHeoby = useHeobyStore((state) => state.selectedHeoby);
  const setSelectedHeoby = useHeobyStore((state) => state.setSelectedHeoby);

  useEffect(() => {
    if (!heobyList || selectedHeoby) return;

    const firstHeoby = heobyList.my[0] ?? heobyList.other[0];
    if (firstHeoby) {
      setSelectedHeoby(firstHeoby);
    }
  }, [heobyList, selectedHeoby, setSelectedHeoby]);
};
