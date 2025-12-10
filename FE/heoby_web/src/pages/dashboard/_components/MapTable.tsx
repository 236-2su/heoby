import Map from "@/pages/map/_components/Map";

export function MapTable() {
  return (
    <div
      className={`rounded-[20px] relative hidden h-full w-full overflow-hidden bg-amber-50 lg:block`}
    >
      <Map className={`h-full w-full`} />
    </div>
  );
}
