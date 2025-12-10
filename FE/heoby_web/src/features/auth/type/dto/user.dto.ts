import typia from "typia";
import { type USERROLE, type UserState } from "../domain/user.domain";

export type UserRoleDto = "USER" | "LEADER";

export interface UserDto {
  userUuid: string;
  username: string;
  email: string;
  role: UserRoleDto;
  createdAt?: string;
  updatedAt?: string;
}

export interface LoginUserDto extends UserDto {
  villageId: number;
}
export interface GetMeUserDto extends UserDto {
  userVillageId: number;
}

export const UserMapper = {
  assertDto: typia.createAssert<LoginUserDto | GetMeUserDto>(),
  fromDto: (dto: LoginUserDto | GetMeUserDto): UserState => {
    const villageId = "villageId" in dto ? dto.villageId : dto.userVillageId;
    return {
      userUuid: dto.userUuid,
      villageId,
      username: dto.username,
      email: dto.email,
      role: roleDtoToDomain(dto.role),
    };
  },
};

const roleDtoToDomain = (dtoRole: UserRoleDto): USERROLE => {
  return dtoRole as USERROLE;
};
