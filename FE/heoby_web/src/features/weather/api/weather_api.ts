import type { USERROLE } from "@/features/auth/type/domain/user.domain";
import ApiClient, { ENDPOINTS } from "@/shared/api/rest";
import { WeatherMapper, type WeatherDto } from "../type/dto/weatherDto";

export const getWeatherByCrowId = async (
  role: USERROLE,
  crowId: string
): Promise<WeatherDto> => {
  const { data } = await ApiClient.get(ENDPOINTS.WEATHER[role](crowId));
  return WeatherMapper.assertRes(data);
};
