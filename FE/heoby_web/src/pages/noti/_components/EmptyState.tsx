import type { ReactNode } from "react";

interface EmptyStateProps {
  icon: ReactNode;
  title: string;
  description?: string;
}

export function EmptyState({ icon, title, description }: EmptyStateProps) {
  return (
    <div className="flex h-full w-full flex-col items-center justify-center gap-3 p-12 text-center">
      <div className="rounded-full bg-gray-100 p-3 text-gray-400">{icon}</div>
      <p className="text-sm font-medium text-gray-700">{title}</p>
      {description ? (
        <p className="text-xs text-gray-500">{description}</p>
      ) : null}
    </div>
  );
}
