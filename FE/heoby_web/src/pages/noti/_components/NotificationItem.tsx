import type { NotificationAlert } from "../../../features/notification/types/domain/notification";
import { getLevelText, getTypeText } from "./utils";

interface NotificationItemProps {
  notification: NotificationAlert;
  onMarkAsRead?: (id: string) => void;
  onDelete?: (id: string) => void;
}

export function NotificationItem({
  notification,
  onMarkAsRead,
  onDelete,
}: NotificationItemProps) {
  const getLevelColor = () => {
    const level = notification.level.toUpperCase();
    switch (level) {
      case "CRITICAL":
        return "bg-red-100 border-red-500";
      case "WARNING":
        return "bg-orange-100 border-orange-500";
      case "INFO":
        return "bg-green-100 border-green-500";
      default:
        return "bg-blue-100 border-blue-500";
    }
  };

  const getLevelTextColor = () => {
    const level = notification.level.toUpperCase();
    switch (level) {
      case "CRITICAL":
        return "text-red-700";
      case "WARNING":
        return "text-orange-700";
      case "INFO":
        return "text-green-700";
      default:
        return "text-blue-700";
    }
  };

  return (
    <div
      className={`rounded-lg border-l-4 p-4 shadow-sm ${getLevelColor()} ${
        notification.isRead ? "opacity-60" : ""
      }`}
    >
      <div className="flex justify-between items-start gap-4">
        <div className="flex-1">
          {/* 레벨과 카테고리 */}
          <div className="flex gap-2 mb-2">
            <span
              className={`text-xs font-semibold px-2 py-1 rounded ${getLevelTextColor()}`}
            >
              {getLevelText(notification.level)}
            </span>
            <span className="text-xs font-medium px-2 py-1 rounded bg-gray-200 text-gray-700">
              {getTypeText(notification.type)}
            </span>
          </div>

          {/* 메시지 */}
          <p className="text-sm text-gray-800 mb-2">{notification.message}</p>

          {/* 이미지 (있는 경우) */}
          {notification.snapshot_url && (
            <img
              src={notification.snapshot_url}
              alt="알림 이미지"
              className="w-full max-w-sm rounded-md mt-2"
            />
          )}

          {/* 날짜 */}
          <p className="text-xs text-gray-500 mt-2">
            {new Date(notification.occurred_at).toLocaleString("ko-KR")}
          </p>
        </div>

        {/* 액션 버튼들 */}
        <div className="flex gap-2">
          {!notification.isRead && onMarkAsRead && (
            <button
              onClick={() => onMarkAsRead(notification.alert_uuid)}
              className="text-xs px-3 py-1 bg-blue-500 text-white rounded hover:bg-blue-600 transition"
            >
              읽음
            </button>
          )}
          {onDelete && (
            <button
              onClick={() => onDelete(notification.alert_uuid)}
              className="text-xs px-3 py-1 bg-gray-300 text-gray-700 rounded hover:bg-gray-400 transition"
            >
              삭제
            </button>
          )}
        </div>
      </div>
    </div>
  );
}
