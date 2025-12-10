// import type { WeatherDto } from "@/features/weather/type/dto/weatherDto";

// const buildForecast = () => {
//   const items = [];
//   const base = new Date();

//   for (let i = 0; i < 24; i += 1) {
//     const time = new Date(base.getTime() + i * 2 * 60 * 60 * 1000);
//     items.push({
//       time: time.toISOString(),
//       temperature_c: 18 + i * 1.2,
//       humidity_pct: 55 + i * 2,
//       precip_mm: i % 2 === 0 ? 0 : 0.2,
//       wind_ms: 2 + i * 0.3,
//       wind_dir: ["NW", "N", "NE", "E", "SE", "S"][i % 6],
//       condition: i < 3 ? "SUNNY" : "OVERCAST",
//     });
//   }

//   return items;
// };

// export const getMockWeather = (crowId: string): WeatherDto => ({
//   location: {
//     lat: 37.5538,
//     lon: 126.9694,
//   },
//   sensor: {
//     temperature: 23.4,
//     humidity: 61,
//   },
//   weather_forecast: buildForecast().map((forecast, index) => ({
//     ...forecast,
//     // crowId를 구분값으로 써서 약간씩 변화를 줌
//     temperature_c: forecast.temperature_c + (crowId ? index * 0.5 : 0),
//   })),
// });
