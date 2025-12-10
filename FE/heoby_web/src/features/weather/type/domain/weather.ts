import type { Location } from "@/shared/types/location";
import type { Sensor } from "../dto/weatherDto";

export interface Weather {
  location: Location;
  sensor: Sensor;
  weather_forecast: WeatherForecast[];
}

export interface WeatherForecast {
  time: Date;
  temperature_c: number;
  humidity_pct: number;
  precip_mm: number;
  wind_ms: number;
  wind_dir: string;
  condition: string;
}
