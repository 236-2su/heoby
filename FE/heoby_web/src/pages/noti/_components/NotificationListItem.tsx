import type { NotificationAlert } from "@/features/notification/types/domain/notification";
import { Clock, Mail, MailOpen } from "lucide-react";
import { getLevelStyle } from "./utils";

interface NotificationListItemProps {
  notification: NotificationAlert;
  isSelected: boolean;
  onClick: () => void;
}

export function NotificationListItem({
  notification,
  isSelected,
  onClick,
}: NotificationListItemProps) {
  const levelStyle = getLevelStyle(notification.level);
  const isUnread = !notification.isRead;

  const ReadIcon = isUnread ? Mail : MailOpen;

  return (
    <button
      type="button"
      onClick={onClick}
      className={`flex w-full flex-col gap-3 rounded-2xl border px-4 py-4 text-left transition ${
        isSelected
          ? "border-blue-400 bg-blue-50 shadow-sm"
          : "border-transparent bg-white hover:border-blue-200 hover:bg-blue-50/50"
      } ${isUnread ? "ring-1 ring-blue-100" : ""}`}
    >
      <div className="flex items-start gap-3">
        <span
          className={`flex h-10 w-10 items-center justify-center rounded-xl text-lg ${levelStyle.badge}`}
        >
          <ReadIcon
            className={`h-4 w-4 ${isUnread ? "text-black" : "text-gray-500"}`}
          />
        </span>

        <div className="min-w-0 flex-1 space-y-2">
          <div className="flex flex-wrap items-center gap-2">
            <span className="text-xs font-semibold text-gray-500">
              {notification.heoby_name}
            </span>
          </div>
          <p
            className={`break-words text-sm leading-5 ${
              isUnread ? "font-semibold text-gray-900" : "text-gray-600"
            }`}
          >
            {notification.message}
          </p>
          <div className="flex items-center gap-2 text-xs text-gray-400">
            <Clock className="h-3.5 w-3.5" />
            <span>
              {new Date(notification.occurred_at).toLocaleString("ko-KR")}
            </span>
          </div>
        </div>
      </div>
    </button>
  );
}
