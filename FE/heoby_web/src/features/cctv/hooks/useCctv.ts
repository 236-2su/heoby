import { useUserStore } from "@/features/auth";
import type { USERROLE } from "@/features/auth/type/domain/user.domain";
import { useQuery } from "@tanstack/react-query";
import { CctvApi } from "../api/cctvApi";
import type { TotalWorkersDto } from "../type/dto/cctv.dto";

export const CCTV_KEYS = {
  type: ["cctv"] as const,
  totalWorkers: (role: USERROLE | "no-role") =>
    [...CCTV_KEYS.type, "totalWorkers", role] as const,
};

export const useGetTotalWorkers = () => {
  const role = useUserStore((s) => s.role);
  const roleKey = role ?? "no-role";

  return useQuery<TotalWorkersDto, Error, number>({
    queryKey: CCTV_KEYS.totalWorkers(roleKey),
    queryFn: () => {
      if (!role) {
        throw new Error("권한 정보가 없습니다");
      }
      return CctvApi.getTotalWorkers(role);
    },
    select: (data) => data.workers,
    enabled: !!role,
  });
};
