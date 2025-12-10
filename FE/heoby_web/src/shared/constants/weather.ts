import cloudyIcon from "@/assets/icons/cloudy-forecast.svg";
import rainForecastIcon from "@/assets/icons/rain-forecast.svg";
import rainIcon from "@/assets/icons/rain.svg";
import snowIcon from "@/assets/icons/snowing.svg";
import sunIcon from "@/assets/icons/sun.svg";

export const WEATHER_ICONS = {
  SUNNY: sunIcon,
  CLOUDY: cloudyIcon,
  RAINY: rainIcon,
  RAIN_FORECAST: rainForecastIcon,
  SNOWY: snowIcon,
} as const;

/**
 * 날씨 상태 코드
 * 기상청 API 또는 서버 응답 코드에 맞게 수정 필요
 */
export const WEATHER_CODES = {
  CLEAR: "1", // 맑음
  PARTLY_CLOUDY: "2", // 구름 조금
  CLOUDY: "3", // 흐림
  RAIN: "4", // 비
  RAIN_SNOW: "5", // 비/눈
  SNOW: "6", // 눈
} as const;

/**
 * 날씨 코드에 따른 아이콘 매핑
 */
export const getWeatherIcon = (code: string): string => {
  switch (code) {
    case WEATHER_CODES.CLEAR:
      return WEATHER_ICONS.SUNNY;
    case WEATHER_CODES.PARTLY_CLOUDY:
    case WEATHER_CODES.CLOUDY:
      return WEATHER_ICONS.CLOUDY;
    case WEATHER_CODES.RAIN:
      return WEATHER_ICONS.RAINY;
    case WEATHER_CODES.RAIN_SNOW:
    case WEATHER_CODES.SNOW:
      return WEATHER_ICONS.SNOWY;
    default:
      return WEATHER_ICONS.SUNNY;
  }
};
