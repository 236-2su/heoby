/**
 * 커스텀 에러 클래스
 * API 에러를 구조화하여 일관성 있게 처리합니다.
 */

import type { AxiosError } from "axios";

/**
 * 기본 API 에러
 */
export class ApiError extends Error {
  public readonly status: number;
  public readonly code: string;
  public readonly detail?: unknown;

  constructor(
    message: string,
    status: number,
    code: string = "UNKNOWN_ERROR",
    detail?: unknown
  ) {
    super(message);
    this.name = "ApiError";
    this.status = status;
    this.code = code;
    this.detail = detail;

    // Error 클래스 상속 시 필요한 프로토타입 설정
    Object.setPrototypeOf(this, ApiError.prototype);
  }
}

/**
 * 인증 에러 (401)
 */
export class UnauthorizedError extends ApiError {
  constructor(message: string = "인증이 필요합니다.") {
    super(message, 401, "UNAUTHORIZED");
    this.name = "UnauthorizedError";
    Object.setPrototypeOf(this, UnauthorizedError.prototype);
  }
}

/**
 * 권한 에러 (403)
 */
export class ForbiddenError extends ApiError {
  constructor(message: string = "접근 권한이 없습니다.") {
    super(message, 403, "FORBIDDEN");
    this.name = "ForbiddenError";
    Object.setPrototypeOf(this, ForbiddenError.prototype);
  }
}

/**
 * 리소스 없음 에러 (404)
 */
export class NotFoundError extends ApiError {
  constructor(message: string = "요청한 리소스를 찾을 수 없습니다.") {
    super(message, 404, "NOT_FOUND");
    this.name = "NotFoundError";
    Object.setPrototypeOf(this, NotFoundError.prototype);
  }
}

/**
 * 유효성 검증 에러 (400, 422)
 */
export class ValidationError extends ApiError {
  constructor(
    message: string = "입력 데이터가 유효하지 않습니다.",
    detail?: unknown
  ) {
    super(message, 400, "VALIDATION_ERROR", detail);
    this.name = "ValidationError";
    Object.setPrototypeOf(this, ValidationError.prototype);
  }
}

/**
 * 서버 에러 (500)
 */
export class ServerError extends ApiError {
  constructor(message: string = "서버에서 오류가 발생했습니다.") {
    super(message, 500, "SERVER_ERROR");
    this.name = "ServerError";
    Object.setPrototypeOf(this, ServerError.prototype);
  }
}

/**
 * 네트워크 에러 (요청은 보냈지만 응답 없음)
 */
export class NetworkError extends Error {
  constructor(message: string = "서버와 연결할 수 없습니다.") {
    super(message);
    this.name = "NetworkError";
    Object.setPrototypeOf(this, NetworkError.prototype);
  }
}

/**
 * 타임아웃 에러
 */
export class TimeoutError extends Error {
  constructor(message: string = "요청 시간이 초과되었습니다.") {
    super(message);
    this.name = "TimeoutError";
    Object.setPrototypeOf(this, TimeoutError.prototype);
  }
}

/**
 * AxiosError를 커스텀 에러로 변환
 */
export function convertAxiosError(error: AxiosError): Error {
  // 응답이 있는 경우 (서버에서 응답을 받음)
  if (error.response) {
    const status = error.response.status;
    const data = error.response.data as unknown & {
      message?: string;
      code?: string;
    };
    const message = data?.message || error.message;

    // 백엔드가 500으로 내려줘도 사실상 권한 오류인 경우
    if (
      status >= 500 &&
      typeof message === "string" &&
      message.includes("Forbidden alert access")
    ) {
      return new ForbiddenError(message);
    }

    switch (status) {
      case 400:
      case 422:
        return new ValidationError(message, data);
      case 401:
        return new UnauthorizedError(message);
      case 403:
        return new ForbiddenError(message);
      case 404:
        return new NotFoundError(message);
      case 500:
      case 502:
      case 503:
        return new ServerError(message);
      default: {
        const code = (data && typeof data === 'object' && 'code' in data && typeof data.code === 'string' ? data.code : undefined);
        return new ApiError(message, status, code);
      }
    }
  }

  // 요청은 보냈지만 응답을 받지 못한 경우
  if (error.request) {
    if (error.code === "ECONNABORTED") {
      return new TimeoutError();
    }
    return new NetworkError();
  }

  // 요청 설정 중 에러가 발생한 경우
  return new Error(error.message);
}

/**
 * 에러 타입 체크 헬퍼 함수
 */
export function isApiError(error: unknown): error is ApiError {
  return error instanceof ApiError;
}

export function isUnauthorizedError(
  error: unknown
): error is UnauthorizedError {
  return error instanceof UnauthorizedError;
}

export function isForbiddenError(error: unknown): error is ForbiddenError {
  return error instanceof ForbiddenError;
}

export function isNetworkError(error: unknown): error is NetworkError {
  return error instanceof NetworkError;
}

export function isTimeoutError(error: unknown): error is TimeoutError {
  return error instanceof TimeoutError;
}
