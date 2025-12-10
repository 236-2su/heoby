// import type {
//   LoginResDto,
//   LoginReqDto,
// } from "@/features/auth/type/dto/login.dto";
// import type {
//   RefreshReqDto,
//   RefreshResDto,
// } from "@/features/auth/type/dto/refresh.dto";
// import type { GetMeUserDto } from "@/features/auth/type/dto/user.dto";

// const MOCK_USER_UUID = "mock-user-uuid";
// const MOCK_VILLAGE_ID = 42;

// export const mockLoginResponse = (
//   credentials: LoginReqDto
// ): LoginResDto => ({
//   accessToken: `mock-access-token-${Date.now()}`,
//   accessTokenExpiresIn: 60 * 60,
//   refreshToken: `mock-refresh-token-${Date.now()}`,
//   refreshTokenExpiresIn: 60 * 60 * 24,
//   user: {
//     userUuid: MOCK_USER_UUID,
//     username: credentials.email.split("@")[0] || "모의 사용자",
//     email: credentials.email,
//     role: "ADMIN",
//     villageId: MOCK_VILLAGE_ID,
//   },
// });

// export const mockRefreshResponse = (
//   _: RefreshReqDto
// ): RefreshResDto => ({
//   accessToken: `mock-access-token-${Date.now()}`,
//   accessTokenExpiresIn: 60 * 60,
//   refreshToken: `mock-refresh-token-${Date.now()}`,
//   refreshTokenExpiresIn: 60 * 60 * 24,
//   userUuid: MOCK_USER_UUID,
// });

// export const mockUserDto: GetMeUserDto = {
//   userUuid: MOCK_USER_UUID,
//   username: "모의 사용자",
//   email: "mock@heoby.app",
//   role: "ADMIN",
//   userVillageId: MOCK_VILLAGE_ID,
// };
