import { useUserStore } from "@/features/auth/store/userStore";
import { useQuery } from "@tanstack/react-query";
import { getWeatherByCrowId } from "../api/weather_api";
import type { Weather } from "../type/domain/weather";
import { WeatherMapper } from "../type/dto/weatherDto";

const WEATHER_KEYS = {
  type: ["weather"] as const,
  byCrowId: (role: string, crowId: string) =>
    [...WEATHER_KEYS.type, "crow", role, crowId] as const,
};

export const useWeather = (crowId: string | null) => {
  const role = useUserStore((state) => state.role);

  return useQuery<Weather, Error>({
    queryKey:
      role && crowId
        ? WEATHER_KEYS.byCrowId(role, crowId)
        : [...WEATHER_KEYS.type, "null"],
    queryFn: async () => {
      if (!role) {
        throw new Error("권한 정보가 없습니다");
      }
      if (!crowId) {
        throw new Error("허수아비 정보가 없습니다");
      }

      const res = await getWeatherByCrowId(role, crowId);
      return WeatherMapper.fromDto(res);
    },
    enabled: !!role && !!crowId,
    staleTime: 1000 * 60 * 10, // 10분 캐싱
    gcTime: 1000 * 60 * 30, // 30분 가비지 컬렉션
  });
};
