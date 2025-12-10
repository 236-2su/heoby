import { useHeobyStore } from "@/features/heoby/store/heobyStore";
import { useWeather } from "@/features/weather/hooks/useWeather";
import { Loading } from "@/shared/components/Loading/Loading";
import { getWeatherIcon } from "@/shared/constants/weather";
import {
  TableBox,
  type TableColumnConfig,
} from "@/shared/components/Box/TableBox";
import { TableRowLayout } from "@/shared/components/Table/TableRowLayout";

export function WeatherTable() {
  const selectedHeoby = useHeobyStore((state) => state.selectedHeoby);
  const { data, isLoading, error } = useWeather(selectedHeoby?.uuid ?? null);

  const filteredData =
    data?.weather_forecast
      ?.slice(0, 12)
      .filter((_, index) => index % 2 === 0) || [];

  const title = `날씨 예보${selectedHeoby ? ` - ${selectedHeoby.name}` : ""}`;

  let headerColumns: TableColumnConfig[] = [];
  let content: React.ReactNode;

  if (!selectedHeoby) {
    content = (
      <Placeholder message="허수아비를 선택하면 예보를 확인할 수 있어요." />
    );
  } else if (isLoading) {
    content = (
      <div className="flex w-full items-center justify-center py-12">
        <Loading />
      </div>
    );
  } else if (error) {
    content = (
      <p className="py-10 text-center text-sm text-red-500">
        에러: {error.message}
      </p>
    );
  } else if (!filteredData.length) {
    content = <Placeholder message="예보 데이터가 없습니다." />;
  } else {
    headerColumns = filteredData.map((forecast) => ({
      label: `${forecast.time.getHours()}시`,
      flex: 1,
      align: "center",
    }));

    content = (
      <TableRowLayout
        columns={headerColumns}
        paddingClassName="px-4 py-5"
        gap={12}
        className="text-sm"
        cells={filteredData.map((forecast) => (
          <div
            key={forecast.time.toISOString()}
            className="flex flex-col items-center gap-2 text-gray-900"
          >
            <img
              src={getWeatherIcon(forecast.condition)}
              alt={forecast.condition}
              className="h-12 w-12"
            />
            <span className="text-sm font-semibold">
              {forecast.temperature_c}°
            </span>
          </div>
        ))}
      />
    );
  }

  return (
    <TableBox
      title={title}
      columns={headerColumns.length ? headerColumns : undefined}
      bodyPadding={0}
      className="h-full"
    >
      {content}
    </TableBox>
  );
}

function Placeholder({ message }: { message: string }) {
  return (
    <p className="py-10 text-center text-sm text-gray-500">{message}</p>
  );
}
