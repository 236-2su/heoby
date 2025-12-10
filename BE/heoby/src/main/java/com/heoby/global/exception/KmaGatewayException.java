package com.heoby.global.exception;

import org.springframework.http.HttpStatus;

public class KmaGatewayException extends CustomException {

  private final int upstreamStatus;

  public KmaGatewayException(String message, int upstreamStatus) {
    super(message, mapUpstreamToStatus(upstreamStatus)); // <-- (message, status) 순서
    this.upstreamStatus = upstreamStatus;
  }

  public int getUpstreamStatus() {
    return upstreamStatus;
  }

  private static HttpStatus mapUpstreamToStatus(int upstream) {
    if (upstream == 504) {
      return HttpStatus.GATEWAY_TIMEOUT;
    }
    if (upstream >= 500 && upstream < 600) {
      return HttpStatus.BAD_GATEWAY;
    }
    return HttpStatus.BAD_GATEWAY;
  }
}
