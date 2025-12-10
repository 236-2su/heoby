// import type { HeobyListDto } from "@/features/heoby/type/dto/heoby.dto";

// const now = new Date();

// const minutesAgo = (minutes: number) =>
//   new Date(now.getTime() - minutes * 60 * 1000).toISOString();

// const mockLocation = (latOffset = 0, lonOffset = 0) => ({
//   lat: 37.5538 + latOffset,
//   lon: 126.9694 + lonOffset,
// });

// export const getMockHeobyList = (): HeobyListDto => ({
//   my_scarecrows: [
//     {
//       scarecrow_uuid: "mock-my-001",
//       name: "허비 알파",
//       location: mockLocation(),
//       owner_name: "홍길동",
//       status: "정상",
//       updated_at: minutesAgo(12),
//     },
//     {
//       scarecrow_uuid: "mock-my-001",
//       name: "허비 알파",
//       location: mockLocation(),
//       owner_name: "홍길동",
//       status: "정상",
//       updated_at: minutesAgo(12),
//     },
//     {
//       scarecrow_uuid: "mock-my-001",
//       name: "허비 알파",
//       location: mockLocation(),
//       owner_name: "홍길동",
//       status: "정상",
//       updated_at: minutesAgo(12),
//     },
//     {
//       scarecrow_uuid: "mock-my-001",
//       name: "허비 알파",
//       location: mockLocation(),
//       owner_name: "홍길동",
//       status: "정상",
//       updated_at: minutesAgo(12),
//     },
//     {
//       scarecrow_uuid: "mock-my-002",
//       name: "허비 브라보",
//       location: mockLocation(0.01, 0.015),
//       owner_name: "홍길동",
//       status: "경고",
//       updated_at: minutesAgo(47),
//     },
//   ],
//   village_scarecrows: [
//     {
//       scarecrow_uuid: "mock-village-003",
//       name: "허비 찰리",
//       location: mockLocation(-0.008, 0.02),
//       owner_name: "김영희",
//       status: "정상",
//       updated_at: minutesAgo(5),
//     },
//     {
//       scarecrow_uuid: "mock-village-004",
//       name: "허비 델타",
//       location: mockLocation(0.021, -0.017),
//       owner_name: "박철수",
//       status: "오류",
//       updated_at: minutesAgo(120),
//     },
//   ],
// });
