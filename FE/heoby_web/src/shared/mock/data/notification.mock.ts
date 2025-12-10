// import type { NotificationDto } from "@/features/notification/types/dto/notificationDto";

// const now = new Date();

// const minutesAgo = (minutes: number) =>
//   new Date(now.getTime() - minutes * 60 * 1000).toISOString();

// export const getMockNotification = (): NotificationDto => {
//   const alerts = [
//     {
//       alert_uuid: "mock-alert-001",
//       severity: "CRITICAL" as const,
//       type: "INTRUDER" as const,
//       message: "논두렁 구역에서 사람 움직임이 감지되었어요.",
//       scarecrow_uuid: "mock-my-001",
//       scarecrow_name: "허비 알파",
//       location: { lat: 37.5538, lon: 126.9694 },
//       occurred_at: minutesAgo(3),
//       snapshot_url: "",
//       read: false,
//     },
//     {
//       alert_uuid: "mock-alert-002",
//       severity: "WARNING" as const,
//       type: "BOAR" as const,
//       message: "멧돼지가 펜스 근처를 지나갔어요.",
//       scarecrow_uuid: "mock-village-003",
//       scarecrow_name: "허비 찰리",
//       location: { lat: 37.5612, lon: 126.9891 },
//       occurred_at: minutesAgo(18),
//       snapshot_url: "",
//       read: false,
//     },
//     {
//       alert_uuid: "mock-alert-003",
//       severity: "WARNING" as const,
//       type: "NO_MOVEMENT" as const,
//       message: "허비 델타가 30분째 움직임이 없어요.",
//       scarecrow_uuid: "mock-village-004",
//       scarecrow_name: "허비 델타",
//       location: { lat: 37.5742, lon: 126.9523 },
//       occurred_at: minutesAgo(52),
//       snapshot_url: "",
//       read: true,
//     },
//   ];

//   return {
//     summary: {
//       critical_unread: alerts.filter(
//         (alert) => alert.severity === "CRITICAL" && !alert.read
//       ).length,
//       warning_unread: alerts.filter(
//         (alert) => alert.severity === "WARNING" && !alert.read
//       ).length,
//       total_unread: alerts.filter((alert) => !alert.read).length,
//     },
//     alerts,
//   };
// };
