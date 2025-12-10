import type { LucideIcon } from "lucide-react";

type ColorVariant = "red" | "yellow" | "green" | "blue" | "gray";

interface StatItem {
  icon: LucideIcon;
  label: string;
  value: number;
  color: ColorVariant;
}

interface StatsBarProps {
  items: StatItem[];
}

const colorClasses: Record<
  ColorVariant,
  {
    hover: string;
    iconBg: string;
    iconColor: string;
  }
> = {
  red: {
    hover: "hover:from-red-50",
    iconBg: "bg-red-100",
    iconColor: "text-red-600",
  },
  yellow: {
    hover: "hover:from-yellow-50",
    iconBg: "bg-yellow-100",
    iconColor: "text-yellow-600",
  },
  green: {
    hover: "hover:from-green-50",
    iconBg: "bg-green-100",
    iconColor: "text-green-600",
  },
  blue: {
    hover: "hover:from-blue-50",
    iconBg: "bg-blue-100",
    iconColor: "text-blue-600",
  },
  gray: {
    hover: "hover:from-gray-50",
    iconBg: "bg-gray-100",
    iconColor: "text-gray-600",
  },
};

export function StatsBar({ items }: StatsBarProps) {
  return (
    <div className="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
      <div className="grid grid-cols-4 divide-x divide-gray-100">
        {items.map((item, index) => {
          const Icon = item.icon;
          const colors = colorClasses[item.color];

          return (
            <div
              key={index}
              className={`p-6 flex items-center gap-4 hover:bg-gradient-to-br ${colors.hover} hover:to-white transition-all cursor-pointer group`}
            >
              <div
                className={`p-3 ${colors.iconBg} rounded-2xl group-hover:scale-110 transition-transform`}
              >
                <Icon className={`w-7 h-7 ${colors.iconColor}`} />
              </div>

              <div>
                <p className="text-xs text-gray-500 font-medium uppercase tracking-wide hidden md:block">
                  {item.label}
                </p>
                <p className="text-3xl font-bold text-gray-900 mt-1">
                  {item.value}
                </p>
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}
