/**
 * 허수아비 상태 정보
 */
export interface HeobyStatusInfo {
  /** 표시할 텍스트 (예: "정상", "주의", "경고") */
  label: string;
  /** 배경 색상 */
  bgColor: string;
  /** 텍스트 색상 */
  textColor: string;
  /** 테두리 색상 (옵션) */
  borderColor?: string;
}

/**
 * 허수아비 상태 값에 따른 스타일 정보를 반환합니다.
 *
 * @param status - 허수아비 상태 문자열 (예: "warning", "critical", "정상", "경고" 등)
 * @returns 상태에 맞는 스타일 정보 객체
 *
 * @example
 * ```tsx
 * const statusInfo = getHeobyStatusStyle(heoby.status);
 * <span style={{
 *   backgroundColor: statusInfo.bgColor,
 *   color: statusInfo.textColor
 * }}>
 *   {statusInfo.label}
 * </span>
 * ```
 */
export function getHeobyStatusStyle(status?: string | null): HeobyStatusInfo {
  if (!status) {
    return {
      label: "알 수 없음",
      bgColor: "#f3f4f6", // gray-100
      textColor: "#6b7280", // gray-500
      borderColor: "#e5e7eb", // gray-200
    };
  }

  const normalized = status.toLowerCase();

  // Warning / 주의 / 경고
  if (normalized.includes("warning") || normalized.includes("주의")) {
    return {
      label: "주의",
      bgColor: "#fff7ed", // orange-50
      textColor: "#c2410c", // orange-700
      borderColor: "#fed7aa", // orange-200
    };
  }

  // Critical / Error / 오류 / 위험 / 심각
  if (
    normalized.includes("critical") ||
    normalized.includes("error") ||
    normalized.includes("오류") ||
    normalized.includes("위험") ||
    normalized.includes("심각")
  ) {
    return {
      label: "경고",
      bgColor: "#fef2f2", // red-50
      textColor: "#b91c1c", // red-700
      borderColor: "#fecaca", // red-200
    };
  }

  // Normal / 정상 / OK
  if (
    normalized.includes("normal") ||
    normalized.includes("정상") ||
    normalized.includes("ok")
  ) {
    return {
      label: "정상",
      bgColor: "#f0fdf4", // green-50
      textColor: "#15803d", // green-700
      borderColor: "#bbf7d0", // green-200
    };
  }

  // 기본값 (인식되지 않는 상태)
  return {
    label: status,
    bgColor: "#f3f4f6", // gray-100
    textColor: "#374151", // gray-700
    borderColor: "#d1d5db", // gray-300
  };
}

/**
 * Tailwind CSS 클래스명을 반환하는 버전
 *
 * @param status - 허수아비 상태 문자열
 * @returns Tailwind CSS 클래스명 문자열
 *
 * @example
 * ```tsx
 * <span className={getHeobyStatusClass(heoby.status)}>
 *   {getHeobyStatusStyle(heoby.status).label}
 * </span>
 * ```
 */
export function getHeobyStatusClass(status?: string | null): string {
  if (!status) {
    return "bg-gray-100 text-gray-500 border-gray-200";
  }

  const normalized = status.toLowerCase();

  // Warning / 주의 / 경고
  if (normalized.includes("warning") || normalized.includes("주의")) {
    return "bg-orange-50 text-orange-700 border-orange-200";
  }

  // Critical / Error / 오류 / 위험 / 심각
  if (
    normalized.includes("critical") ||
    normalized.includes("error") ||
    normalized.includes("오류") ||
    normalized.includes("위험") ||
    normalized.includes("심각")
  ) {
    return "bg-red-50 text-red-700 border-red-200";
  }

  // Normal / 정상 / OK
  if (
    normalized.includes("normal") ||
    normalized.includes("정상") ||
    normalized.includes("ok")
  ) {
    return "bg-green-50 text-green-700 border-green-200";
  }

  // 기본값
  return "bg-gray-100 text-gray-700 border-gray-300";
}
