import { useHeobyStore } from "@/features/heoby/store/heobyStore";
import { BaseBox } from "@/shared/components/Box/BaseBox";
import {
  Battery,
  Copy,
  Droplets,
  Home,
  IdCard,
  MapPin,
  RefreshCw,
  Thermometer,
  User,
} from "lucide-react";
import { showErrorToast, showSuccessToast } from "@/shared/lib/toast";

/* ───────────────── components ───────────────── */

interface InfoCardProps {
  icon: React.ReactNode;
  label: string;
  value: React.ReactNode;
  className?: string;
  action?: React.ReactNode;
}

function InfoCard({ icon, label, value, className, action }: InfoCardProps) {
  return (
    <div
      className={` rounded-2xl bg-[#F9F8F6] border border-[#EFEEEA] px-3 py-3 shadow ${
        className || ""
      }`}
    >
      <div className="flex flex-col gap-2">
        <div className="flex items-center justify-between">
          <div className="flex items-center justify-between gap-3">
            <div className="flex h-10 w-10 items-center justify-center rounded-full bg-white shadow-sm">
              {icon}
            </div>
            <div className="text-md text-black">{label}</div>
          </div>
          {action}
        </div>
        <div>
          <div className="font-semibold text-black text-md">{value}</div>
        </div>
      </div>
    </div>
  );
}

interface InfoCardHorizontalProps {
  icon: React.ReactNode;
  label: string;
  value: React.ReactNode;
  className?: string;
}

function InfoCardHorizontal({
  icon,
  label,
  value,
  className,
}: InfoCardHorizontalProps) {
  return (
    <div
      className={`rounded-2xl bg-[#F9F8F6] border border-[#EFEEEA] px-3 py-3 shadow ${
        className || ""
      }`}
    >
      <div className="flex flex-col items-start gap-3">
        <div className="flex items-center gap-3">
          <div className="flex h-10 w-10 items-center justify-center rounded-full bg-white shadow-sm">
            {icon}
          </div>
          <div className="text-md text-black">{label}</div>
        </div>
        <div className="flex-1 min-w-0">
          <div className="font-semibold text-black text-md">{value}</div>
        </div>
      </div>
    </div>
  );
}

function Meter({ value, suffix = "%" }: { value: number; suffix?: string }) {
  const pct = Math.max(0, Math.min(100, value));
  const color =
    pct >= 60 ? "bg-green-500" : pct >= 30 ? "bg-amber-500" : "bg-red-500";
  return (
    <div>
      <div className="flex items-baseline justify-between">
        <span className="text-xs text-gray-500">배터리</span>
        <span className="text-sm font-semibold text-gray-900">
          {pct}
          {suffix}
        </span>
      </div>
      <div className="mt-1.5 h-2 w-full rounded-full bg-gray-200">
        <div
          className={`h-2 rounded-full transition-all ${color}`}
          style={{ width: `${pct}%` }}
        />
      </div>
    </div>
  );
}

/* ───────────────── main ───────────────── */

export function HeobyDetail() {
  const { selectedHeoby, selectedAddress } = useHeobyStore();

  if (!selectedHeoby) {
    return (
      <BaseBox title="선택된 허비 정보">
        <div className="p-8 text-center text-sm text-gray-500">
          선택된 허비가 없습니다.
        </div>
      </BaseBox>
    );
  }

  const handleCopy = async (text: string) => {
    try {
      await navigator.clipboard.writeText(text);
      showSuccessToast("클립보드에 복사했어요.");
    } catch (copyError) {
      console.error("클립보드 복사 실패:", copyError);
      showErrorToast("복사 권한을 확인하고 다시 시도해 주세요.");
    }
  };

  return (
    <BaseBox title="감자밭 상세 정보" contentClassName="items-stretch">
      <div className="p-5 text-gray-800">
        {/* 2개씩 그리드 레이아웃 */}
        <div className="grid grid-cols-2 gap-3">
          {/* 주인 정보 */}
          <InfoCard
            icon={<User className="h-5 w-5 text-gray-600" />}
            label="주인"
            value={selectedHeoby.owner_name || "정보 없음"}
          />

          {/* 위치 정보 */}
          <InfoCard
            icon={<Home className="h-5 w-5 text-gray-600" />}
            label="위치"
            value={selectedAddress ?? "주소 정보 없음"}
          />

          {/* 업데이트 시간 */}
          <InfoCard
            icon={<RefreshCw className="h-5 w-5 text-gray-600" />}
            label="업데이트"
            value={
              <>
                {new Date(selectedHeoby.updated_at)
                  .toLocaleDateString("ko-KR", {
                    year: "numeric",
                    month: "2-digit",
                    day: "2-digit",
                  })
                  .replace(/\. /g, ".")}{" "}
                {" · "}
                {new Date(selectedHeoby.updated_at).toLocaleTimeString(
                  "ko-KR",
                  {
                    hour: "2-digit",
                    minute: "2-digit",
                  }
                )}
              </>
            }
          ></InfoCard>
          {/* 배터리 */}
          <InfoCard
            icon={<Battery className="h-5 w-5 text-gray-600" />}
            label="배터리"
            value={<Meter value={selectedHeoby.battery ?? 0} />}
          />

          {/* 온도 */}
          <InfoCard
            icon={<Thermometer className="h-5 w-5 text-gray-600" />}
            label="온도"
            value={
              selectedHeoby.temperature ? `${selectedHeoby.temperature}°C` : "—"
            }
          />

          {/* 습도 */}
          <InfoCard
            icon={<Droplets className="h-5 w-5 text-gray-600" />}
            label="습도"
            value={selectedHeoby.humidity ? `${selectedHeoby.humidity}%` : "—"}
          />

          {/* 위도 */}
          <InfoCard
            icon={<MapPin className="h-5 w-5 text-gray-600" />}
            label="위도"
            value={selectedHeoby.location.lat.toFixed(6)}
            action={
              <button
                onClick={() =>
                  void handleCopy(selectedHeoby.location.lat.toString())
                }
                className="flex h-8 w-8 items-center justify-center rounded-lg bg-white shadow-sm hover:bg-gray-100 transition-colors"
              >
                <Copy className="h-4 w-4 text-gray-600" />
              </button>
            }
          />

          {/* 경도 */}
          <InfoCard
            icon={<MapPin className="h-5 w-5 text-gray-600" />}
            label="경도"
            value={selectedHeoby.location.lon.toFixed(6)}
            action={
              <button
                onClick={() =>
                  void handleCopy(selectedHeoby.location.lon.toString())
                }
                className="flex h-8 w-8 items-center justify-center rounded-lg bg-white shadow-sm hover:bg-gray-100 transition-colors"
              >
                <Copy className="h-4 w-4 text-gray-600" />
              </button>
            }
          />

          {/* ID - 전체 너비 */}
          <InfoCardHorizontal
            icon={<IdCard className="h-5 w-5 text-gray-600" />}
            label="ID"
            value={selectedHeoby.uuid}
            className="col-span-2"
          />
        </div>
      </div>
    </BaseBox>
  );
}
