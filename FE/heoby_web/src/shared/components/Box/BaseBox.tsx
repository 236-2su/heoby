import type { FC, ReactNode } from "react";

interface BaseBoxProps {
  title: string;
  children: ReactNode;
  className?: string;
  contentClassName?: string;
  contentPadding?: number | string;
  scrollable?: boolean;
}

export const BaseBox: FC<BaseBoxProps> = ({
  title,
  children,
  className,
  contentClassName,
  contentPadding = 0,
  scrollable = false,
}) => {
  const bodyPadding =
    typeof contentPadding === "number" ? `${contentPadding}px` : contentPadding;
  const contentOverflowClass = scrollable
    ? "overflow-y-auto"
    : "flex flex-col items-center justify-center";

  return (
    <div
      className={`custom-surface-card flex flex-col w-full ${className ?? ""}`}
    >
      <div className="custom-box-title-bar">
        <p className="custom-box-title-text">{title}</p>
      </div>
      <div className="custom-divider" />
      <div className="flex-1 min-h-0 w-full overflow-hidden rounded-b-[20px]">
        <div
          className={`h-full w-full ${contentOverflowClass} ${
            contentClassName ?? ""
          }`}
          style={{ padding: bodyPadding }}
        >
          {children}
        </div>
      </div>
    </div>
  );
};
