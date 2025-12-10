import type { Location } from "@/shared/types/location";
import typia from "typia";
import type { Weather, WeatherForecast } from "../domain/weather";

export interface WeatherDto {
  location: Location;
  sensor: Sensor;
  weather_forecast: WeatherForecastDto[];
}

export interface WeatherForecastDto {
  time: string;
  temperature_c: number;
  humidity_pct: number;
  precip_mm: number;
  wind_ms: number;
  wind_dir: string;
  condition: string;
}

export interface Sensor {
  temperature: number;
  humidity: number;
}

export const WeatherMapper = {
  assertRes: typia.createAssert<WeatherDto>(),
  fromDto: (dto: WeatherDto): Weather => {
    return {
      location: dto.location,
      sensor: dto.sensor,
      weather_forecast: dto.weather_forecast.map((e) =>
        WeatherForecastMapper.fromDto(e)
      ),
    };
  },
};

export const WeatherForecastMapper = {
  fromDto: (dto: WeatherForecastDto): WeatherForecast => {
    return {
      time: new Date(dto.time),
      temperature_c: dto.temperature_c,
      humidity_pct: dto.humidity_pct,
      precip_mm: dto.precip_mm,
      wind_ms: dto.wind_ms,
      wind_dir: dto.wind_dir,
      condition: dto.condition,
    };
  },
};
