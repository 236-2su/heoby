import { useNotifications } from "@/features/notification/hooks/useNotifications";
import { BaseBox } from "@/shared/components/Box/BaseBox";

export function NotificationSummary() {
  const { data, isLoading, error } = useNotifications();
  const emergency = data?.summary.critical_unread ?? 0;
  const warning = data?.summary.warning_unread ?? 0;
  const hasAlert = emergency > 0 || warning > 0;
  const highlighted =
    emergency > 0
      ? { label: "긴급", count: emergency, tone: "critical" as const }
      : warning > 0
      ? { label: "주의", count: warning, tone: "warning" as const }
      : null;

  return (
    <BaseBox
      title="최근 알림"
      className="h-full w-full md:max-w-none lg:max-w-[320px] cursor-pointer"
      contentClassName="items-center justify-center"
      contentPadding={20}
    >
      {isLoading ? (
        <p className="text-sm text-gray-500">로딩 중...</p>
      ) : error ? (
        <p className="text-sm text-red-500">
          에러: {error.message ?? "잠시 후 다시 시도해주세요."}
        </p>
      ) : (
        <div className="w-full">
          {!hasAlert || !highlighted ? (
            <EmptyState />
          ) : (
            <AlertHighlight severity={highlighted} />
          )}
        </div>
      )}
    </BaseBox>
  );
}

function EmptyState() {
  return (
    <div className="flex flex-col items-center justify-center rounded-2xl border border-dashed border-gray-200 bg-gray-50 py-10 text-center">
      <div className="mb-2 text-3xl">🔔</div>
      <p className="font-medium text-gray-700">새 알림이 없어요</p>
      <p className="mt-1 text-sm text-gray-500">
        긴급/주의 알림이 도착하면 여기에서 확인할 수 있어요.
      </p>
    </div>
  );
}

function AlertHighlight({
  severity,
}: {
  severity: { label: string; count: number; tone: "critical" | "warning" };
}) {
  const isCritical = severity.tone === "critical";
  const tone = isCritical
    ? {
        card: "border-red-100 bg-red-50/70",
        dot: "bg-red-500",
        pill: "bg-white/90 text-red-600",
        accent: "text-red-600",
      }
    : {
        card: "border-amber-100 bg-amber-50/70",
        dot: "bg-amber-500",
        pill: "bg-white/90 text-amber-600",
        accent: "text-amber-600",
      };

  return (
    <div
      className={`rounded-2xl border px-4 py-5 shadow-sm ${tone.card}`}
      aria-live="assertive"
    >
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-2 text-sm font-semibold text-gray-800">
          <span className={`h-2.5 w-2.5 rounded-full ${tone.dot}`} />
          <span>{severity.label}</span>
        </div>
        <span
          className={`rounded-full px-3 py-1 text-xs font-semibold ${tone.pill}`}
        >
          {severity.count}건
        </span>
      </div>
      <p className={`mt-4 text-sm font-medium ${tone.accent}`}>
        가장 최근 {severity.label} 알림이 도착했어요.
      </p>
    </div>
  );
}
