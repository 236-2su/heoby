import typia from "typia";
import type { AuthState } from "../domain/auth.domain";

export interface RefreshReqDto {
  refreshToken: string;
}

export interface RefreshResDto {
  accessToken: string;
  accessTokenExpiresIn: number;
  refreshToken: string;
  refreshTokenExpiresIn: number;
  userUuid: string;
}

export const RefreshMapper = {
  assertRes: typia.createAssert<RefreshResDto>(),
  fromDto: (dto: RefreshResDto): AuthState => {
    return {
      accessToken: dto.accessToken,
      userUuid: dto.userUuid,
      isAuthenticated: true,
    };
  },
};
