import type { NotificationAlert } from "@/features/notification/types/domain/notification";
import { showSuccessToast } from "@/shared/lib/toast";
import {
  AlertTriangle,
  Clock,
  Fingerprint,
  Mail,
  MailOpen,
  MapPin,
  Navigation,
} from "lucide-react";
import { getLevelStyle, getLevelText, getTypeIcon, getTypeText } from "./utils";

interface NotificationDetailProps {
  notification: NotificationAlert;
}

export function NotificationDetailCard({
  notification,
}: NotificationDetailProps) {
  const levelStyle = getLevelStyle(notification.level);
  const isUnread = !notification.isRead;
  const ReadIcon = isUnread ? Mail : MailOpen;

  const lat = notification.location?.lat ?? "-";
  const lon = notification.location?.lon ?? "-";

  const handleNavigation = () => {
    if (notification.location?.lat && notification.location?.lon) {
      const lat = notification.location.lat;
      const lng = notification.location.lon;
      const name = encodeURIComponent(notification.heoby_name);

      // 웹 네이버 지도 URL
      const webUrl = `https://map.naver.com/?lng=${lng}&lat=${lat}&title=${name}`;
      window.open(webUrl, "_blank");
    }
  };

  const handleReport = () => {
    // 119에 신고
    showSuccessToast("근처 119에 신고했습니다.");
  };

  return (
    <div className="flex flex-col gap-6">
      <div className="flex flex-col gap-4">
        <div className="flex items-start gap-4">
          <span className="text-4xl">{getTypeIcon(notification.type)}</span>
          <div className="flex flex-1 flex-col gap-2">
            <div className="flex flex-wrap items-center gap-2">
              <span
                className={`inline-flex items-center rounded-full border px-3 py-1 text-sm font-semibold ${levelStyle.badge}`}
              >
                {getLevelText(notification.level)}
              </span>
              <span className="inline-flex items-center gap-1 rounded-full bg-blue-50 px-3 py-1 text-xs font-semibold text-blue-600">
                <ReadIcon className="h-3.5 w-3.5" />
                {isUnread ? "읽지 않음" : "읽음"}
              </span>
            </div>
            <h3 className="text-lg font-semibold text-gray-900">
              {getTypeText(notification.type)}
            </h3>
            <div className="flex items-center gap-2 text-sm text-gray-500">
              <Clock className="h-4 w-4" />
              <span>
                {new Date(notification.occurred_at).toLocaleString("ko-KR")}
              </span>
            </div>
          </div>
        </div>

        <div className="grid gap-3 rounded-2xl border border-gray-100 bg-gray-50/80 p-4 text-sm text-gray-600">
          <div className="flex items-start gap-2">
            <Fingerprint className="h-4 w-4 text-gray-400" />
            <div>
              <p className="text-xs font-semibold tracking-wide text-gray-400">
                허수아비 이름
              </p>
              <p className="font-semibold text-gray-900">
                {notification.heoby_name}
              </p>
            </div>
          </div>
          <div className="flex items-start gap-2">
            <MapPin className="h-4 w-4 text-gray-400" />
            <div>
              <p className="text-xs font-semibold tracking-wide text-gray-400">
                위치 좌표
              </p>
              <p className="font-semibold text-gray-900">
                {lat}, {lon}
              </p>
            </div>
          </div>
        </div>

        {/* 길찾기 및 신고 버튼 */}
        <div className="flex gap-3">
          <button
            onClick={handleNavigation}
            className="flex flex-1 items-center justify-center gap-2 rounded-xl border border-blue-200 bg-blue-50 px-4 py-3 text-sm font-semibold text-blue-700 transition hover:bg-blue-100"
          >
            <Navigation className="h-4 w-4" />
            길찾기
          </button>
          <button
            onClick={handleReport}
            className="flex flex-1 items-center justify-center gap-2 rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm font-semibold text-red-700 transition hover:bg-red-100"
          >
            <AlertTriangle className="h-4 w-4" />
            신고
          </button>
        </div>
      </div>

      <div className="space-y-2">
        <h4 className="text-sm font-semibold text-gray-900">알림 내용</h4>
        <p className="whitespace-pre-wrap text-sm leading-relaxed text-gray-700">
          {notification.message}
        </p>
      </div>

      {notification.snapshot_url ? (
        <div className="space-y-2">
          <h4 className="text-sm font-semibold text-gray-900">첨부 이미지</h4>
          <img
            src={notification.snapshot_url}
            alt="알림 첨부 이미지"
            className="w-full rounded-xl border border-gray-200"
          />
        </div>
      ) : null}
    </div>
  );
}
