import type { USERROLE } from "@/features/auth/type/domain/user.domain";
import ApiClient, { ENDPOINTS } from "@/shared/api/rest";
import { HeobyListMapper, type HeobyListDto } from "../type/dto/heoby.dto";

export const HeobyApi = {
  async getList(role: USERROLE): Promise<HeobyListDto> {
    const { data } = await ApiClient.get(ENDPOINTS.HEOBY[role]);

    return HeobyListMapper.assertHeobyListRes(data);
  },
};
