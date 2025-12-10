type LevelStyle = {
  badge: string;
};

const LEVEL_STYLES: Record<string, LevelStyle> = {
  CRITICAL: {
    badge: "border-red-200 bg-red-100 text-red-600",
  },
  WARNING: {
    badge: "border-orange-200 bg-orange-100 text-orange-600",
  },
  INFO: {
    badge: "border-green-200 bg-green-100 text-green-600",
  },
  default: {
    badge: "border-blue-200 bg-blue-100 text-blue-600",
  },
};

export function getLevelStyle(level: string): LevelStyle {
  const upperLevel = level.toUpperCase();
  return LEVEL_STYLES[upperLevel] ?? LEVEL_STYLES.default;
}

export function getLevelText(level: string): string {
  const upperLevel = level.toUpperCase();
  if (upperLevel === "CRITICAL") {
    return "긴급";
  } else if (upperLevel === "WARNING") {
    return "경고";
  } else if (upperLevel === "INFO") {
    return "정보";
  }
  return "알림";
}

export function getTypeText(type: string): string {
  if (!type) return "알림";

  const upperType = type.toUpperCase();
  switch (upperType) {
    case "INTRUDER":
      return "침입자 감지";
    case "BOAR":
      return "멧돼지 감지";
    case "ROE_DEER":
      return "고라니 감지";
    case "MAGPIE":
      return "까치 감지";
    case "BEAR":
      return "곰 감지";
    case "OTHER":
      return "기타 동물 감지";
    case "WILDLIFE":
      return "야생동물 감지";
    case "UNKNOWN":
      return "알 수 없는 감지";
    case "HEAT_STRESS":
      return "온열 스트레스";
    case "FALL_DETECTED":
      return "낙상 감지";
    case "NO_MOVEMENT":
      return "무활동 감지";
    default:
      console.warn(`Unknown notification type: ${type}`);
      return `기타 (${type})`;
  }
}

export function getTypeIcon(type: string): string {
  if (!type) return "🔔";

  const upperType = type.toUpperCase();
  switch (upperType) {
    case "INTRUDER":
      return "👤";
    case "BOAR":
      return "🐗";
    case "ROE_DEER":
      return "🦌";
    case "MAGPIE":
      return "🐦";
    case "BEAR":
      return "🐻";
    case "OTHER":
      return "🐾";
    case "WILDLIFE":
      return "🦊";
    case "UNKNOWN":
      return "❓";
    case "HEAT_STRESS":
      return "🌡️";
    case "FALL_DETECTED":
      return "🚨";
    case "NO_MOVEMENT":
      return "⏸️";
    default:
      return "🔔";
  }
}
