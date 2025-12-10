import { useHeobyList } from "@/features/heoby/hooks/useHeoby";
import { useHeobyStore } from "@/features/heoby/store/heobyStore";
import type { Heoby } from "@/features/heoby/type/domain/heoby.domain";
import { BaseBox } from "@/shared/components/Box/BaseBox";
import {
  TableBox,
  type TableColumnConfig,
} from "@/shared/components/Box/TableBox";
import { Loading } from "@/shared/components/Loading/Loading";
import { TableRowLayout } from "@/shared/components/Table/TableRowLayout";
import { getRelativeTime } from "@/shared/utils/date";
import type { ReactNode } from "react";

const HEOBY_COLUMNS: TableColumnConfig[] = [
  { label: "", flex: 1, align: "left" },
  { label: "이름", flex: 3, align: "left" },
  { label: "상태", flex: 2, align: "center" },
  { label: "주인", flex: 3, align: "left" },
  { label: "업데이트", flex: 2, align: "right" },
];

interface HeobyTableProps {
  className?: string;
}

export function HeobyTable({ className }: HeobyTableProps) {
  const { isLoading } = useHeobyList();
  const { heobyList } = useHeobyStore();
  const selectedHeoby = useHeobyStore((state) => state.selectedHeoby);
  const setSelectedHeoby = useHeobyStore((state) => state.setSelectedHeoby);

  const myHeobys = heobyList?.my ?? [];
  const otherHeobys = heobyList?.other ?? [];
  const rows = [
    ...myHeobys.map((data) => ({ data, isMy: true })),
    ...otherHeobys.map((data) => ({ data, isMy: false })),
  ];

  const hasData = !!heobyList && rows.length > 0;
  const commonProps = {
    isLoading,
    hasData,
    rows,
    selectedHeobyUuid: selectedHeoby?.uuid,
    onSelect: setSelectedHeoby,
  };

  return (
    <>
      <div className="hidden h-full lg:block">
        <BaseBox
          title="허수아비 목록"
          className={className}
          contentClassName="flex flex-col gap-3"
          contentPadding={16}
          scrollable={true}
        >
          <ContentRenderer {...commonProps} renderType="compact" />
        </BaseBox>
      </div>

      <div className="block h-full lg:hidden">
        <TableBox
          title="허수아비 목록"
          columns={HEOBY_COLUMNS}
          bodyPadding={0}
          className={className}
        >
          <ContentRenderer {...commonProps} renderType="desktop" />
        </TableBox>
      </div>
    </>
  );
}

interface ContentRendererProps {
  isLoading: boolean;
  hasData: boolean;
  rows: Array<{ data: Heoby; isMy: boolean }>;
  selectedHeobyUuid?: string;
  onSelect: (heoby: Heoby) => void;
  renderType: "desktop" | "compact";
}

function ContentRenderer({
  isLoading,
  hasData,
  rows,
  selectedHeobyUuid,
  onSelect,
  renderType,
}: ContentRendererProps): ReactNode {
  if (isLoading) {
    return (
      <div className="flex w-full items-center justify-center py-12">
        <Loading />
      </div>
    );
  }

  if (!hasData) {
    const padding = renderType === "desktop" ? "py-10" : "py-6";
    return (
      <p className={`${padding} text-center text-sm text-gray-500`}>
        등록된 허수아비가 없습니다.
      </p>
    );
  }

  if (renderType === "desktop") {
    return (
      <div className="flex flex-col">
        {rows.map(({ data, isMy }, index) => (
          <HeobyRow
            key={data.uuid}
            data={data}
            isMy={isMy}
            isSelected={selectedHeobyUuid === data.uuid}
            onClick={() => onSelect(data)}
            isLast={index === rows.length - 1}
          />
        ))}
      </div>
    );
  }

  return (
    <>
      {rows.map(({ data, isMy }) => (
        <HeobyCard
          key={data.uuid}
          data={data}
          isMy={isMy}
          isSelected={selectedHeobyUuid === data.uuid}
          onClick={() => onSelect(data)}
        />
      ))}
    </>
  );
}

interface HeobyRowProps {
  data: Heoby;
  isMy: boolean;
  isSelected: boolean;
  isLast: boolean;
  onClick: () => void;
}

function HeobyRow({ data, isMy, isSelected, isLast, onClick }: HeobyRowProps) {
  const rowTone = isSelected
    ? "bg-blue-50 hover:bg-blue-100"
    : isMy
    ? "bg-white hover:bg-gray-50"
    : "bg-gray-50 hover:bg-gray-100";

  return (
    <button
      type="button"
      onClick={onClick}
      className={`w-full border-b border-gray-100 text-left transition-colors focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-blue-400 ${rowTone} ${
        isLast ? "border-b-0" : ""
      }`}
    >
      <TableRowLayout
        columns={HEOBY_COLUMNS}
        gap={12}
        paddingClassName="px-4 py-4 md:px-5"
        className="text-sm md:text-base"
        cells={[
          <span key="owner" aria-hidden className="text-lg">
            {isMy ? "👤" : "👥"}
          </span>,
          <p
            key="name"
            className="truncate font-semibold text-gray-900"
            title={data.name}
          >
            {data.name}
          </p>,
          <span key="status" role="img" aria-label={data.status}>
            {getStatusIcon(data.status)}
          </span>,
          <p
            key="owner_name"
            className="truncate text-sm text-gray-600 md:text-base"
            title={data.owner_name}
          >
            {data.owner_name}
          </p>,
          <p
            key="updated"
            className="text-sm font-semibold text-gray-800 md:text-base"
          >
            {getRelativeTime(data.updated_at)}
          </p>,
        ]}
      />
    </button>
  );
}

function getStatusIcon(status: string) {
  const normalized = status.toLowerCase();

  if (normalized.includes("경고") || normalized.includes("warning"))
    return "🟡";
  if (normalized.includes("오류") || normalized.includes("error")) return "🔴";
  return "🟢";
}

function HeobyCard({
  data,
  isMy,
  isSelected,
  onClick,
}: {
  data: Heoby;
  isMy: boolean;
  isSelected: boolean;
  onClick: () => void;
}) {
  return (
    <button
      type="button"
      onClick={onClick}
      className={`cursor-pointer w-full rounded-2xl border border-gray-100 px-4 py-3 text-left shadow-sm transition-colors focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-blue-400 ${
        isSelected ? "bg-blue-50" : "bg-white"
      }`}
    >
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-2">
          <span aria-hidden className="text-xl">
            {isMy ? "👤" : "👥"}
          </span>
          <p className="font-semibold text-gray-900">{data.name}</p>
        </div>
        <span role="img" aria-label={data.status}>
          {getStatusIcon(data.status)}
        </span>
      </div>
      <div className="mt-2 flex items-center justify-between text-sm text-gray-600">
        <span>{data.owner_name}</span>
        <span className="font-medium text-gray-800">
          {getRelativeTime(data.updated_at)}
        </span>
      </div>
    </button>
  );
}
