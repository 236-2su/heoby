import { BaseLayout } from "../../shared/components/Layout/BaseLayout";
import "../../styles/pages/notification.css";
import { NotificationsSection } from "./_components/NotificationsSection";

export function NotificationPage() {
  return (
    <BaseLayout>
      <section className="notification-page">
        <NotificationsSection />
      </section>
    </BaseLayout>
  );
}
