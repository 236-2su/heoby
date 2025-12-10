import ApiClient, { ENDPOINTS } from "@/shared/api/rest";

import {
  LoginMapper,
  type LoginReqDto,
  type LoginResDto,
} from "../type/dto/login.dto";
import type { LogoutReqDto } from "../type/dto/logout.dto";
import {
  RefreshMapper,
  type RefreshReqDto,
  type RefreshResDto,
} from "../type/dto/refresh.dto";

export const AuthApi = {
  async login(credentials: LoginReqDto): Promise<LoginResDto> {
    const { data } = await ApiClient.post(ENDPOINTS.AUTH.LOGIN, credentials);

    return LoginMapper.assertRes(data);
  },

  async logout(credentials: LogoutReqDto): Promise<void> {
    try {
      await ApiClient.post(ENDPOINTS.AUTH.LOGOUT, credentials);
    } catch (error) {
      console.warn(
        "[mock:logout] 서버에 연결할 수 없어도 로컬에서 로그아웃 처리합니다.",
        error
      );
    }
  },

  async refresh(credentials: RefreshReqDto): Promise<RefreshResDto> {
    const { data } = await ApiClient.post(ENDPOINTS.AUTH.REFRESH, credentials);
    return RefreshMapper.assertRes(data);
  },
};
