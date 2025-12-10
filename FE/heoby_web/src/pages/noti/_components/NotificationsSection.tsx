import type {
  Notification,
  NotificationAlert,
} from "@/features/notification/types/domain/notification";
import { BaseBox } from "@/shared/components/Box/BaseBox";
import { AlertTriangle, Inbox, MailOpen } from "lucide-react";
import { useEffect, useMemo, useState } from "react";
import { markNotificationAsRead } from "../../../features/notification/api/notificationApi";
import {
  NOTIFICATION_KEYS,
  useNotifications,
} from "../../../features/notification/hooks/useNotifications";
import { EmptyState } from "./EmptyState";
import { NotificationDetailCard } from "./NotificationDetailCard";
import { NotificationDetailDrawer } from "./NotificationDetailDrawer";
import { NotificationListItem } from "./NotificationListItem";
import { SummarySkeleton } from "./SummarySkeleton";
import type { FilterType } from "./types";
import { useQueryClient } from "@tanstack/react-query";

const FILTER_OPTIONS: Array<{ value: FilterType; label: string }> = [
  { value: "all", label: "전체" },
  { value: "emergency", label: "긴급" },
  { value: "warning", label: "주의" },
  { value: "unread", label: "읽지 않음" },
];

export function NotificationsSection() {
  const { data, isLoading, error } = useNotifications();
  const queryClient = useQueryClient();

  const [filter, setFilter] = useState<FilterType>("all");
  const [selectedNotification, setSelectedNotification] =
    useState<NotificationAlert | null>(null);
  const [showMobileDetail, setShowMobileDetail] = useState(false);

  const filteredNotifications = useMemo(() => {
    const notifications = data?.alerts ?? [];

    switch (filter) {
      case "emergency":
        return notifications.filter(
          (notification) => notification.level === "CRITICAL"
        );
      case "warning":
        return notifications.filter(
          (notification) => notification.level === "WARNING"
        );
      case "unread":
        return notifications.filter((notification) => !notification.isRead);
      default:
        return notifications;
    }
  }, [data?.alerts, filter]);

  useEffect(() => {
    if (!filteredNotifications.length) {
      setSelectedNotification(null);
      return;
    }

    if (!selectedNotification) {
      setSelectedNotification(filteredNotifications[0]);
      return;
    }

    const exists = filteredNotifications.some(
      (notification) =>
        notification.alert_uuid === selectedNotification.alert_uuid
    );

    if (!exists) {
      setSelectedNotification(filteredNotifications[0]);
    }
  }, [filteredNotifications, selectedNotification]);

  useEffect(() => {
    if (showMobileDetail && !selectedNotification) {
      setShowMobileDetail(false);
    }
  }, [showMobileDetail, selectedNotification]);

  const decrementSummary = (
    alert: NotificationAlert | null,
    source: Notification | undefined
  ) => {
    if (!alert || !source) return source;

    const summary = { ...source.summary };
    const wasUnread =
      source.alerts.find((item) => item.alert_uuid === alert.alert_uuid)
        ?.isRead === false;
    if (!wasUnread) return source;

    summary.total_unread = Math.max(0, summary.total_unread - 1);

    const levelKey =
      alert.level === "CRITICAL"
        ? "critical_unread"
        : alert.level === "WARNING"
        ? "warning_unread"
        : null;

    if (levelKey) {
      summary[levelKey] = Math.max(0, summary[levelKey] - 1);
    }

    return { ...source, summary };
  };

  const markAsRead = async (alert: NotificationAlert) => {
    try {
      await markNotificationAsRead(alert.alert_uuid);
      setSelectedNotification((previous) => {
        if (previous?.alert_uuid === alert.alert_uuid) {
          return { ...previous, isRead: true };
        }
        return previous;
      });

      queryClient.setQueryData<Notification>(
        NOTIFICATION_KEYS.base(),
        (previous) => {
          if (!previous) return previous;

          const updated = decrementSummary(alert, previous);
          const alerts = previous.alerts.map((item) =>
            item.alert_uuid === alert.alert_uuid
              ? { ...item, isRead: true }
              : item
          );

          return updated ? { ...updated, alerts } : previous;
        }
      );
    } catch (markError) {
      console.error("Failed to mark notification as read:", markError);
    }
  };

  const handleNotificationClick = (notification: NotificationAlert) => {
    const nextSelection = notification.isRead
      ? notification
      : { ...notification, isRead: true };

    setSelectedNotification(nextSelection);
    setShowMobileDetail(true);

    if (!notification.isRead) {
      void markAsRead(notification);
    }
  };

  const handleCloseMobileDetail = () => {
    setShowMobileDetail(false);
  };

  if (isLoading) {
    return (
      <section className="notification-section">
        <SummarySkeleton />
        <BaseBox
          title="알림 목록"
          className="notification-grid__list"
          contentClassName="items-stretch min-h-0"
          scrollable={true}
        >
          <div className="flex flex-1 flex-col gap-3 p-6">
            {["first", "second", "third", "fourth"].map((placeholder) => (
              <div
                key={placeholder}
                className="h-20 rounded-2xl bg-gray-100 animate-pulse"
              />
            ))}
          </div>
        </BaseBox>
      </section>
    );
  }

  if (error) {
    return (
      <BaseBox title="알림 목록">
        <div className="flex flex-1 flex-col items-center justify-center gap-3 p-10 text-center">
          <AlertTriangle className="h-8 w-8 text-red-500" />
          <p className="text-sm font-medium text-gray-700">
            알림을 불러오는 중 문제가 발생했어요.
          </p>
          <p className="text-xs text-gray-500">{error.message}</p>
        </div>
      </BaseBox>
    );
  }

  return (
    <section className="notification-section">
      <div className="notification-grid">
        <BaseBox
          title="알림 목록"
          className="notification-grid__list"
          contentClassName="flex-col items-stretch min-h-0"
          scrollable={true}
        >
          <div className="flex w-full flex-col min-h-0">
            <div className="flex items-center gap-2 border-t border-gray-100 px-4 py-3">
              {FILTER_OPTIONS.map((option) => {
                const isActive = option.value === filter;
                return (
                  <button
                    key={option.value}
                    type="button"
                    onClick={() => setFilter(option.value)}
                    className={`rounded-full px-3 py-1 text-xs font-semibold transition ${
                      isActive
                        ? "bg-blue-600 text-white shadow-sm"
                        : "bg-gray-100 text-gray-600 hover:bg-gray-200"
                    }`}
                  >
                    {option.label}
                  </button>
                );
              })}
            </div>
            <div className="flex-1 overflow-y-auto border-t border-gray-100">
              {filteredNotifications.length === 0 ? (
                <EmptyState
                  icon={<Inbox className="h-6 w-6" />}
                  title="조건에 해당하는 알림이 없어요."
                  description="다른 필터를 선택해 보세요."
                />
              ) : (
                <div className="flex flex-col gap-2 px-4 py-4">
                  {filteredNotifications.map((notification) => (
                    <NotificationListItem
                      key={notification.alert_uuid}
                      notification={notification}
                      isSelected={
                        selectedNotification?.alert_uuid ===
                        notification.alert_uuid
                      }
                      onClick={() => handleNotificationClick(notification)}
                    />
                  ))}
                </div>
              )}
            </div>
          </div>
        </BaseBox>

        <div className="notification-grid__detail">
          <BaseBox
            title="상세 정보"
            className="notification-grid__detail"
            contentClassName="flex-col items-stretch min-h-0"
            scrollable={true}
          >
            <div className="flex w-full flex-col min-h-0">
              <div className="flex-1 overflow-y-auto">
                <div className="p-6">
                  {selectedNotification ? (
                    <NotificationDetailCard notification={selectedNotification} />
                  ) : (
                    <EmptyState
                      icon={<MailOpen className="h-6 w-6" />}
                      title="알림을 선택하면 자세한 내용이 보여요."
                      description="왼쪽 목록에서 확인할 알림을 선택해 주세요."
                    />
                  )}
                </div>
              </div>
            </div>
          </BaseBox>
        </div>
      </div>

      {showMobileDetail && selectedNotification && (
        <NotificationDetailDrawer
          notification={selectedNotification}
          onClose={handleCloseMobileDetail}
        />
      )}
    </section>
  );
}
