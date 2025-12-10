import type { ReactNode } from "react";
import type { TableColumnConfig } from "../Box/TableBox";

interface TableRowLayoutProps {
  columns: TableColumnConfig[];
  cells: ReactNode[];
  className?: string;
  gap?: number;
  paddingClassName?: string;
}

export function TableRowLayout({
  columns,
  cells,
  className,
  gap = 8,
  paddingClassName = "px-4 py-3",
}: TableRowLayoutProps) {
  if (columns.length !== cells.length) {
    console.warn("TableRowLayout: columns and cells length must match.");
    return null;
  }

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
      className={`flex w-full items-center ${paddingClassName} ${
        className ?? ""
      }`}
      style={{ gap }}
    >
      {columns.map((column, index) => (
        <div
          key={`${column.label}-${index}`}
          className={`flex-1 text-sm text-gray-900 ${getAlignment(
            column.align
          )} ${column.className ?? ""}`}
          style={{ flex: column.flex ?? 1 }}
        >
          {cells[index]}
        </div>
      ))}
    </div>
  );
}
