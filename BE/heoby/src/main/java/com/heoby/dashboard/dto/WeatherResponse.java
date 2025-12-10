package com.heoby.dashboard.dto;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.heoby.scarecrow.dto.Location;
import java.util.List;

public record WeatherResponse(
    @JsonProperty("location") Location location,
    @JsonProperty("sensor") SensorBrief sensor,
    @JsonProperty("weather_forecast") List<ForecastItem> weatherForecast
) {
  public record SensorBrief(@JsonProperty("temperature") Double temperature,
                            @JsonProperty("humidity") Double humidity) {}

  public record ForecastItem(
      @JsonProperty("time") String time,
      @JsonProperty("temperature_c") Integer temperatureC,
      @JsonProperty("humidity_pct") Integer humidityPct,
      @JsonProperty("precip_mm") Double precipMm,
      @JsonProperty("wind_ms") Double windMs,
      @JsonProperty("wind_dir") String windDir,
      @JsonProperty("condition") String condition
  ) {}
}
