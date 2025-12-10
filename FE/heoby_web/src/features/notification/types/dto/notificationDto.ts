import type { Location } from "@/shared/types/location";
import typia from "typia";

export interface NotificationDto {
  summary: NotificationSummaryDto;
  alerts: NotificationAlertDto[];
}

export interface NotificationSummaryDto {
  critical_unread: number;
  warning_unread: number;
  total_unread: number;
}

export interface NotificationAlertDto {
  alert_uuid: string;
  severity: keyof SeverityDto;
  type: keyof DetectionTypeDto;
  message: string;
  scarecrow_uuid: string;
  scarecrow_name: string;
  location: Location;
  occurred_at: string;
  snapshot_url: string | null;
  read: boolean;
}

export const SeverityDto = {
  CRITICAL: "긴급",
  WARNING: "주의",
  INFO: "정보",
} as const;

export const DetectionTypeDto = {
  INTRUDER: "침입자",
  BOAR: "멧돼지",
  ROE_DEER: "노루",
  MAGPIE: "까치",
  OTHER: "이상 물체",
  HEAT_STRESS: "열",
  FALL_DETECTED: "낙상",
  NO_MOVEMENT: "움직임 없음",
  BEAR: "곰",
} as const;

export type SeverityDto = typeof SeverityDto;
export type DetectionTypeDto = typeof DetectionTypeDto;

export const NotificationMapper = {
  assertRes: typia.createAssert<NotificationDto>(),
  fromDto: (dto: NotificationDto) => {
    return {
      alerts: NotificationAlertMapper.fromDto(dto.alerts),
      summary: NotificationSummaryMapper.fromDto(dto.summary),
    };
  },
};

export const NotificationAlertMapper = {
  fromDto: (dto: NotificationAlertDto[]) => {
    return dto.map((alert) => ({
      alert_uuid: alert.alert_uuid,
      level: alert.severity,
      type: alert.type,
      message: alert.message,
      heoby_uuid: alert.scarecrow_uuid,
      heoby_name: alert.scarecrow_name,
      location: {
        lat: alert.location.lat,
        lon: alert.location.lon,
      },
      occurred_at: alert.occurred_at,
      snapshot_url: alert.snapshot_url,
      isRead: alert.read,
    }));
  },
};

export const NotificationSummaryMapper = {
  fromDto: (dto: NotificationSummaryDto) => {
    return {
      critical_unread: dto.critical_unread,
      warning_unread: dto.warning_unread,
      total_unread: dto.total_unread,
    };
  },
};
