import type { Location } from "@/shared/types/location";

export interface Notification {
  summary: NotificationSummary;
  alerts: NotificationAlert[];
}

export interface NotificationAlert {
  alert_uuid: string;
  level: string;
  type: string;
  message: string;
  heoby_uuid: string;
  heoby_name: string;
  location: Location;
  occurred_at: string;
  snapshot_url: string | null;
  isRead: boolean;
}

export interface NotificationSummary {
  critical_unread: number;
  warning_unread: number;
  total_unread: number;
}
