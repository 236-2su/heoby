import type { USERROLE } from "@/features/auth/type/domain/user.domain";
import ApiClient, { ENDPOINTS } from "@/shared/api/rest";
import type { TotalWorkersDto } from "../type/dto/cctv.dto";

export const CctvApi = {
  async getTotalWorkers(role: USERROLE): Promise<TotalWorkersDto> {
    const { data } = await ApiClient.get(ENDPOINTS.CCTV[role]);
    return data;
  },
};
