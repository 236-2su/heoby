import ApiClient, { ENDPOINTS } from "@/shared/api/rest";
import { UserMapper, type GetMeUserDto } from "../type/dto/user.dto";

export const UserApi = {
  async getMe(): Promise<GetMeUserDto> {
    const { data } = await ApiClient.get(ENDPOINTS.USER.ME);
    return UserMapper.assertDto(data) as GetMeUserDto;
  },
};
