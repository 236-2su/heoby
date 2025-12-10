import { useGetTotalWorkers } from "@/features/cctv/hooks/useCctv";
import { BaseBox } from "@/shared/components/Box/BaseBox";
import { Loading } from "@/shared/components/Loading/Loading";
import { Loader2, RotateCcw } from "lucide-react";

export function WorkingSummary() {
  const { data, isLoading, isFetching, error, refetch } = useGetTotalWorkers();

  if (isLoading) {
    return (
      <BaseBox
        title="작업 인원"
        className="h-full w-full"
        contentClassName="items-center justify-center"
        contentPadding={24}
      >
        <div className="flex flex-col items-center gap-2 text-gray-500">
          <Loading />
        </div>
      </BaseBox>
    );
  }

  if (error) {
    return (
      <BaseBox
        title="작업 인원"
        className="h-full w-full"
        contentClassName="items-center justify-center"
        contentPadding={24}
      >
        <div className="flex flex-col items-center gap-3 text-center">
          <p className="text-sm text-red-500">
            에러 발생: {error.message ?? "잠시 후 다시 시도해 주세요."}
          </p>
          <button
            type="button"
            onClick={() => refetch()}
            className="inline-flex items-center gap-2 rounded-lg border border-red-200 px-3 py-2 text-sm font-medium text-red-600 transition hover:bg-red-50 disabled:cursor-not-allowed disabled:opacity-60"
            disabled={isFetching}
          >
            {isFetching ? (
              <Loader2 className="h-4 w-4 animate-spin" />
            ) : (
              <RotateCcw className="h-4 w-4" />
            )}
            다시 시도
          </button>
        </div>
      </BaseBox>
    );
  }

  return (
    <BaseBox
      title="작업 인원"
      className="h-full w-full cursor-pointer"
      contentClassName="items-center justify-center"
      contentPadding={24}
    >
      <div className="flex w-full flex-col items-center gap-2 py-4">
        <div className="text-4xl font-bold text-[#2B2622] text-blue-600">
          {data ?? "0"}
        </div>
        {isFetching && (
          <div className="flex items-center gap-1 text-xs text-gray-500">
            <Loader2 className="h-3 w-3 animate-spin" />
            <span>업데이트 중...</span>
          </div>
        )}
      </div>
    </BaseBox>
  );
}
