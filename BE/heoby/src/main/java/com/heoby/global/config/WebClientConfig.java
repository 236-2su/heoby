package com.heoby.global.config;

import io.netty.channel.ChannelOption;
import io.netty.handler.timeout.ReadTimeoutHandler;
import io.netty.handler.timeout.WriteTimeoutHandler;
import io.netty.resolver.DefaultAddressResolverGroup;
import java.time.Duration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.client.reactive.ReactorClientHttpConnector;
import org.springframework.web.reactive.function.client.ExchangeStrategies;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.netty.http.client.HttpClient;

@Configuration
public class WebClientConfig {

  @Bean
  public WebClient webClient() {
    // Netty 타임아웃/리졸버/핸들러 설정
    HttpClient http = HttpClient.create()
        .resolver(DefaultAddressResolverGroup.INSTANCE)                    // DNS 이슈 방지
        .option(ChannelOption.CONNECT_TIMEOUT_MILLIS, 7000)                // connect timeout
        .responseTimeout(Duration.ofSeconds(20))                           // 응답 전체 타임아웃
        .doOnConnected(conn -> conn
            .addHandlerLast(new ReadTimeoutHandler(25))                    // 소켓 read 타임아웃
            .addHandlerLast(new WriteTimeoutHandler(25))                   // 소켓 write 타임아웃
        );

    return WebClient.builder()
        .clientConnector(new ReactorClientHttpConnector(http))
        .defaultHeader("User-Agent", "Heoby/1.0 (+https://example.com)")   // 일부 공공 API에서 유효
        .exchangeStrategies(ExchangeStrategies.builder()
            .codecs(c -> c.defaultCodecs().maxInMemorySize(2 * 1024 * 1024))
            .build())
        .build();
  }
}
