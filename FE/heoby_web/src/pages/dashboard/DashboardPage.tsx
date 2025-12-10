import { APP_ROUTES } from "@/shared/constants/routes";
import { Link } from "react-router-dom";
import { BaseLayout } from "../../shared/components/Layout/BaseLayout";
import "../../styles/pages/dashboard.css";
import { HeobyTable } from "./_components/HeobyTable";
import { MapTable } from "./_components/MapTable";
import { NotificationSummary } from "./_components/NotificationSummary";
import { WeatherTable } from "./_components/WeatherTable";
import { WorkingSummary } from "./_components/WorkingSummary";

export const DashboardPage: React.FC = () => {
  return (
    <BaseLayout>
      <div className="py-4">
        <section className="custom-dashboard-grid">
          <div className="custom-dashboard-working">
            <Link to={APP_ROUTES.cctv}>
              <WorkingSummary />
            </Link>
          </div>
          <div className="custom-dashboard-notification">
            <Link to={APP_ROUTES.notifications}>
              <NotificationSummary />
            </Link>
          </div>
          <div className="custom-dashboard-heoby">
            <HeobyTable className="heoby-list-responsive" />
          </div>
          <div className="custom-dashboard-weather">
            <WeatherTable />
          </div>
          <div className="custom-dashboard-map">
            <MapTable />
          </div>
        </section>
      </div>
    </BaseLayout>
  );
};
