import type { ReactNode } from "react";

export interface TableColumnConfig {
  label: string;
  flex?: number;
  align?: "left" | "center" | "right";
  className?: string;
}

interface TableBoxProps {
  title: string;
  children: ReactNode;
  columns?: TableColumnConfig[];
  className?: string;
  bodyPadding?: number | string;
}

export function TableBox({
  title,
  children,
  columns,
  className,
  bodyPadding = "8px 4px",
}: TableBoxProps) {
  const paddingValue =
    typeof bodyPadding === "number" ? `${bodyPadding}px` : bodyPadding;

  const getAlignment = (align?: TableColumnConfig["align"]) => {
    switch (align) {
      case "left":
        return "text-left justify-start";
      case "right":
        return "text-right justify-end";
      default:
        return "text-center justify-center";
    }
  };

  return (
    <div
      className={`custom-surface-card flex h-full flex-col ${className ?? ""}`}
    >
      <div className="custom-box-title-bar">
        <p className="custom-box-title-text">{title}</p>
      </div>

      {columns && columns.length > 0 && (
        <div className="w-full bg-[#F7F4ED] px-3 py-3">
          <div className="flex w-full items-center gap-2">
            {columns.map((column, index) => (
              <div
                key={`${column.label}-${index}`}
                className={`text-[15px] font-semibold text-gray-900 ${getAlignment(
                  column.align
                )} ${column.className ?? ""}`}
                style={{ flex: column.flex ?? 1 }}
              >
                {column.label}
              </div>
            ))}
          </div>
        </div>
      )}

      <div
        className="flex-1 min-h-0 w-full overflow-hidden rounded-b-[20px]"
        style={{ padding: paddingValue }}
      >
        <div className="h-full w-full overflow-y-auto">{children}</div>
      </div>
    </div>
  );
}
