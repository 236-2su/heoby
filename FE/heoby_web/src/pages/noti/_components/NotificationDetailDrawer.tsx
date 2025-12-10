import type { NotificationAlert } from "@/features/notification/types/domain/notification";
import { NotificationDetailCard } from "./NotificationDetailCard";
import { X } from "lucide-react";

interface NotificationDetailDrawerProps {
  notification: NotificationAlert;
  onClose: () => void;
}

export function NotificationDetailDrawer({
  notification,
  onClose,
}: NotificationDetailDrawerProps) {
  return (
    <div className="fixed inset-0 z-50 bg-white md:hidden">
      <div className="sticky top-0 flex items-center justify-between border-b border-gray-200 bg-white px-4 py-3">
        <h3 className="text-base font-semibold text-gray-900">알림 상세</h3>
        <button
          type="button"
          onClick={onClose}
          className="rounded-full p-2 hover:bg-gray-100"
        >
          <X className="h-5 w-5" />
        </button>
      </div>
      <div className="h-[calc(100%-56px)] overflow-y-auto p-4">
        <NotificationDetailCard notification={notification} />
      </div>
    </div>
  );
}
