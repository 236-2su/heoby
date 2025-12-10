import type { NotificationAlert } from "../../../features/notification/types/domain/notification";
import { NotificationItem } from "./NotificationItem";

interface NotificationListProps {
  notifications: NotificationAlert[];
  onMarkAsRead?: (id: string) => void;
  onDelete?: (id: string) => void;
  onMarkAllAsRead?: () => void;
  isLoading?: boolean;
  error: string | null;
}

export function NotificationList({
  notifications,
  onMarkAsRead,
  onDelete,
  onMarkAllAsRead,
  isLoading,
  error,
}: NotificationListProps) {
  // 로딩 상태
  if (isLoading) {
    return (
      <div className="flex justify-center items-center py-8">
        <div className="text-gray-500">알림을 불러오는 중...</div>
      </div>
    );
  }

  // 에러 상태
  if (error) {
    return (
      <div className="flex justify-center items-center py-8">
        <div className="text-red-500">{error}</div>
      </div>
    );
  }

  // 알림이 없는 경우
  if (notifications.length === 0) {
    return (
      <div className="flex justify-center items-center py-8">
        <div className="text-gray-500">알림이 없습니다.</div>
      </div>
    );
  }

  const unreadCount = notifications.filter((n) => !n.isRead).length;

  return (
    <div className="space-y-4">
      {/* 헤더 */}
      <div className="flex justify-between items-center mb-4">
        <h2 className="text-xl font-bold">
          알림 {unreadCount > 0 && `(${unreadCount}개 읽지 않음)`}
        </h2>
        {unreadCount > 0 && onMarkAllAsRead && (
          <button
            onClick={onMarkAllAsRead}
            className="text-sm px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600 transition"
          >
            모두 읽음 처리
          </button>
        )}
      </div>

      {/* 알림 목록 */}
      <div className="space-y-3">
        {notifications.map((notification) => (
          <NotificationItem
            key={notification.alert_uuid}
            notification={notification}
            onMarkAsRead={onMarkAsRead}
            onDelete={onDelete}
          />
        ))}
      </div>
    </div>
  );
}
