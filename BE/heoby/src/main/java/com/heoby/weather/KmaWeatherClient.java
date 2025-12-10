package com.heoby.weather;

import com.heoby.dashboard.dto.WeatherResponse.ForecastItem;
import com.heoby.global.exception.KmaGatewayException;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatusCode;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.util.UriComponentsBuilder;
import reactor.core.publisher.Mono;
import reactor.util.retry.Retry;

import java.net.URI;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.time.*;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class KmaWeatherClient {

  private final WebClient webClient;

  @Value("${kma.service-key}")
  private String serviceKeyPlain;

  @Value("${kma.base-url}") // e.g. https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0
  private String baseUrl;

  private static final DateTimeFormatter DATE = DateTimeFormatter.ofPattern("yyyyMMdd");
  private static final DateTimeFormatter TIME = DateTimeFormatter.ofPattern("HHmm");

  public List<ForecastItem> fetch24hForecast(Double lat, Double lon) {
    if (lat == null || lon == null) return List.of();

    Grid grid = toGrid(lat, lon);
    ZonedDateTime nowKst = ZonedDateTime.now(ZoneId.of("Asia/Seoul"));

    // 발표 기준 시각 3단계 폴백: now → 직전(−1h) → 전날 마지막(23시)
    ZonedDateTime base1 = latestBaseTime(nowKst);
    ZonedDateTime base2 = latestBaseTime(nowKst.minusHours(1));
    ZonedDateTime base3 = nowKst.minusDays(1).withHour(23).withMinute(0).withSecond(0).withNano(0);

    String svcKey = normalizedServiceKey(serviceKeyPlain);

    Map<?, ?> raw = callKma(buildUri(grid, base1, svcKey), "primary");
    if (raw == null) raw = callKma(buildUri(grid, base2, svcKey), "fallback-prev-base");
    if (raw == null) raw = callKma(buildUri(grid, base3, svcKey), "fallback-yesterday-23");

    if (raw == null) throw new KmaGatewayException("KMA retries exhausted", 504);

    List<Map<String, Object>> items = extractItems(raw);
    Map<LocalDateTime, Map<String, String>> byTime = new TreeMap<>();

    for (var it : items) {
      String category = s(it.get("category"));
      String fcstDate = s(it.get("fcstDate"));
      String fcstTime = s(it.get("fcstTime"));
      String fcstValue = s(it.get("fcstValue"));
      if (category == null || fcstDate == null || fcstTime == null) continue;

      LocalDateTime when = LocalDateTime.parse(fcstDate + fcstTime,
          DateTimeFormatter.ofPattern("yyyyMMddHHmm"));
      byTime.computeIfAbsent(when, k -> new HashMap<>()).put(category, fcstValue);
    }

    LocalDateTime from = nowKst.toLocalDateTime();
    LocalDateTime to   = from.plusHours(24);

    return byTime.entrySet().stream()
        .filter(e -> !e.getKey().isBefore(from) && !e.getKey().isAfter(to))
        .sorted(Map.Entry.comparingByKey())
        .limit(24)
        .map(e -> toForecast(e.getKey(), e.getValue()))
        .filter(Objects::nonNull)
        .collect(Collectors.toList());
  }

  // --- internals ---

  private static String normalizedServiceKey(String key) {
    if (key == null) return "";
    String trimmed = key.trim();
    // 포털이 제공한 키가 "%2B%2F..." 처럼 이미 인코딩돼 온 경우가 많음 → 한 번 디코딩해서 넘기기
    if (trimmed.contains("%")) {
      try { return URLDecoder.decode(trimmed, StandardCharsets.UTF_8); }
      catch (Exception ignore) { /* fail open */ }
    }
    return trimmed;
  }

  private URI buildUri(Grid grid, ZonedDateTime base, String serviceKey) {
    String baseDate = base.toLocalDate().format(DATE);
    String baseTime = base.toLocalTime().format(TIME);
    String normalized = normalizeBase(baseUrl);

    URI uri = UriComponentsBuilder
        .fromHttpUrl(normalized + "/getVilageFcst")
        .queryParam("serviceKey", serviceKey)   // UriComponentsBuilder가 필요 시 인코딩
        .queryParam("pageNo", 1)
        .queryParam("numOfRows", 1000)
        .queryParam("dataType", "JSON")
        .queryParam("base_date", baseDate)
        .queryParam("base_time", baseTime)
        .queryParam("nx", grid.nx())
        .queryParam("ny", grid.ny())
        .build(true)
        .toUri();

    // 디버그용: 실제 호출 URI 확인 (키는 마스킹)
    System.out.println("[KMA] GET " + masked(uri.toString()));
    return uri;
  }

  private static String masked(String url) {
    return url.replaceAll("(serviceKey=)([^&]+)", "$1****MASKED****");
  }

  @SuppressWarnings("unchecked")
  private Map<?, ?> callKma(URI uri, String tag) {
    try {
      return webClient.get()
          .uri(uri)
          .retrieve()
          .onStatus(HttpStatusCode::is5xxServerError, resp ->
              resp.bodyToMono(String.class).defaultIfEmpty("")
                  .flatMap(body -> Mono.error(
                      new KmaGatewayException("KMA " + resp.statusCode() + " body=" + body,
                          resp.statusCode().value())
                  ))
          )
          .bodyToMono(Map.class)
          .timeout(java.time.Duration.ofSeconds(20))                 // 20초
          .retryWhen(
              Retry.backoff(2, java.time.Duration.ofSeconds(1))  // 2회 재시도
                  .jitter(0.3)
                  .filter(ex -> ex instanceof java.util.concurrent.TimeoutException
                      || ex instanceof KmaGatewayException)
          )
          .blockOptional()
          .orElse(Map.of());
    } catch (Exception e) {
      System.out.println("[KMA][" + tag + "] failed: " + e.getClass().getSimpleName() + ": " + e.getMessage());
      return null;
    }
  }

  private static String normalizeBase(String url) {
    if (url == null || url.isBlank()) throw new IllegalArgumentException("kma.base-url is blank");
    String u = url.trim();
    if (!u.startsWith("http://") && !u.startsWith("https://")) u = "https://" + u;
    if (u.endsWith("/")) u = u.substring(0, u.length() - 1);
    return u;
  }

  @SuppressWarnings("unchecked")
  private List<Map<String, Object>> extractItems(Map<?, ?> raw) {
    try {
      var resp = (Map<String, Object>) raw.get("response");
      var body = (Map<String, Object>) resp.get("body");
      var items = (Map<String, Object>) body.get("items");
      var list  = (List<Map<String, Object>>) items.get("item");
      return (list != null) ? list : List.of();
    } catch (Exception e) {
      return List.of();
    }
  }

  private static String s(Object o) { return (o == null) ? null : String.valueOf(o); }

  private ForecastItem toForecast(LocalDateTime when, Map<String, String> m) {
    Integer tmp = asInt(m.get("TMP"));
    Integer reh = asInt(m.get("REH"));
    Double  wsd = asDouble(m.get("WSD"));
    Integer vec = asInt(m.get("VEC"));
    String  sky = m.get("SKY");
    String  pty = m.get("PTY");

    Double pcp = parsePrecipMm(m.get("PCP"));
    String windDir = (vec != null) ? degToCompass(vec.doubleValue()) : null;
    String condition = toCondition(pty, sky);

    return new ForecastItem(when.toString(), tmp, reh, pcp != null ? pcp : 0.0, wsd, windDir, condition);
  }

  private static Integer asInt(String v) { try { return v == null ? null : Integer.valueOf(v); } catch (Exception e) { return null; } }
  private static Double  asDouble(String v) { try { return v == null ? null : Double.valueOf(v); } catch (Exception e) { return null; } }

  private static Double parsePrecipMm(String v) {
    if (v == null) return null;
    String s = v.trim();
    if (s.equals("강수없음") || s.equals("-")) return 0.0;
    if (s.contains("1mm 미만")) return 0.0;
    try { return Double.valueOf(s.replace("mm","").trim()); } catch (Exception e) { return 0.0; }
  }

  private static String toCondition(String pty, String sky) {
    if (pty != null) {
      switch (pty) {
        case "1": return "RAIN";
        case "2": return "RAIN_SNOW";
        case "3": return "SNOW";
        case "4": return "SHOWER";
        case "5": return "DRIZZLE";
        case "6": return "SLEET";
        case "7": return "SNOW_SHOWER";
      }
    }
    if (sky == null) return "SUNNY";
    return switch (sky) { case "1" -> "SUNNY"; case "3" -> "CLOUDY"; case "4" -> "OVERCAST"; default -> "SUNNY"; };
  }

  private static ZonedDateTime latestBaseTime(ZonedDateTime nowKst) {
    int[] bases = {2, 5, 8, 11, 14, 17, 20, 23};
    ZonedDateTime cand = nowKst.withMinute(0).withSecond(0).withNano(0);
    for (int i = bases.length - 1; i >= 0; i--) if (nowKst.getHour() >= bases[i]) return cand.withHour(bases[i]);
    return cand.minusDays(1).withHour(23);
  }

  private static String degToCompass(double deg) {
    String[] dirs = { "N","NNE","NE","ENE","E","ESE","SE","SSE","S","SSW","SW","WSW","W","WNW","NW","NNW" };
    int idx = (int)Math.round(((deg % 360) / 22.5)) & 15;
    return dirs[idx];
  }

  private static Grid toGrid(double lat, double lon) {
    double RE = 6371.00877, GRID = 5.0, SLAT1 = 30.0, SLAT2 = 60.0, OLON = 126.0, OLAT = 38.0, XO = 43, YO = 136;
    double DEGRAD = Math.PI / 180.0;
    double re = RE / GRID;
    double slat1 = SLAT1 * DEGRAD, slat2 = SLAT2 * DEGRAD, olon = OLON * DEGRAD, olat = OLAT * DEGRAD;

    double sn = Math.tan(Math.PI * 0.25 + slat2 * 0.5) / Math.tan(Math.PI * 0.25 + slat1 * 0.5);
    sn = Math.log(Math.cos(slat1) / Math.cos(slat2)) / Math.log(sn);
    double sf = Math.tan(Math.PI * 0.25 + slat1 * 0.5);
    sf = Math.pow(sf, sn) * Math.cos(slat1) / sn;
    double ro = Math.tan(Math.PI * 0.25 + olat * 0.5);
    ro = re * sf / Math.pow(ro, sn);

    double ra = Math.tan(Math.PI * 0.25 + lat * DEGRAD * 0.5);
    ra = re * sf / Math.pow(ra, sn);
    double theta = lon * DEGRAD - olon;
    if (theta > Math.PI) theta -= 2.0 * Math.PI;
    if (theta < -Math.PI) theta += 2.0 * Math.PI;
    theta *= sn;

    int nx = (int) Math.floor(ra * Math.sin(theta) + XO + 0.5);
    int ny = (int) Math.floor(ro - ra * Math.cos(theta) + YO + 0.5);
    return new Grid(nx, ny);
  }

  private record Grid(int nx, int ny) {}
}
