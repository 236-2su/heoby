import { BaseLayout } from "../../shared/components/Layout/BaseLayout";
import "../../styles/pages/map.css";
import { HeobyTable } from "../dashboard/_components/HeobyTable";
import { HeobyDetail } from "./_components/HeobyDetail";
import Map from "./_components/Map";

export function MapPage() {
  return (
    <BaseLayout>
      <div className="py-4">
        <section className="custom-map-grid">
          <div className="custom-map-grid__map">
            <div className="relative w-full h-[360px] md:h-[500px] lg:h-full rounded-3xl bg-amber-50 shadow-md">
              <Map className="rounded-3xl h-full w-full" />
            </div>
          </div>
          <div className="custom-map-grid__detail">
            <HeobyDetail />
          </div>
          <div className="custom-map-grid__list">
            <HeobyTable className="h-full" />
          </div>
        </section>
      </div>
    </BaseLayout>
  );
}
