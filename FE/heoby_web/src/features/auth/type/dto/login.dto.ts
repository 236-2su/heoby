import typia from "typia";
import type { AuthState } from "../domain/auth.domain";
import type { LoginUserDto } from "./user.dto";

export interface LoginReqDto {
  email: string;
  password: string;
}

export interface LoginResDto {
  accessToken: string;
  accessTokenExpiresIn: number;
  refreshToken: string;
  refreshTokenExpiresIn: number;
  user: LoginUserDto;
}

export const LoginMapper = {
  assertRes: typia.createAssert<LoginResDto>(),
  toAuth(dto: LoginResDto): AuthState {
    return {
      accessToken: dto.accessToken,
      userUuid: dto.user.userUuid,
      isAuthenticated: true,
    };
  },
} as const;
