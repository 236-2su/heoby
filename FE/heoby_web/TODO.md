# TODO

## 인증 및 세션
- `src/app/routes/ProtectedRoute.tsx`에서 인증 미검증 상태로 보호 라우트를 통과하고 있음. 스토어 기반 isAuthenticated 체크를 복원하고, 비인증 시 로그인으로 리다이렉트하도록 수정해 401 루프와 무단 접근을 막아주세요.
- 자동 로그인 실패 시 `src/features/auth/hooks/useAuth.ts`에서 user 스토어/캐시가 남아 있어 이전 사용자 데이터가 노출될 수 있음. `REFRESH_TOKEN_KEY`를 일관되게 사용하고, 실패·로그아웃 시 heoby 등 피처 스토어까지 초기화하도록 확장하세요.
- 베이스 경로 배포 시 로그인 후 `navigate("/")`(LoginPage/ProfilePage)가 잘못된 위치로 갈 수 있음. `VITE_BASE_PATH`를 고려한 경로 헬퍼를 공통으로 적용하세요.

## 알림/FCM
- `src/App.tsx:52-94`에서 로그인 여부와 무관하게 FCM 권한 요청 및 초기화를 수행함. 인증 이후에만 토큰을 요청하고, 권한 거부/에러 시 사용자 안내 및 재시도 UI를 추가하세요.
- `src/shared/lib/firebase/fcm.ts:17-50`에서 서비스워커 경로를 루트(`/firebase-messaging-sw.js`)로 고정. 베이스 경로 배포 시 깨지므로 `import.meta.env.BASE_URL` 또는 `VITE_BASE_PATH`를 반영하고, 포그라운드 메시지 처리(TODO 주석)를 구현해 토스트·알림 목록 반영을 해주세요.

## 데이터 페칭/캐싱
- 역할 값이 없을 때 `role!`로 쿼리를 생성(`useHeobyList`, `useGetTotalWorkers`, `useWeather`)해 런타임 undefined 키가 생길 수 있음. 쿼리 키/함수를 role 존재 여부에 안전하게 묶고, 역할 변경·로그아웃 시 관련 캐시와 스토어를 리셋하세요.
- 알림 읽음 처리(`src/pages/noti/_components/NotificationsSection.tsx:75-99`)가 선택 상태만 수정하고 쿼리 캐시를 갱신하지 않아 목록/요약 숫자가 stale 상태로 남음. React Query `setQueryData` 또는 `invalidateQueries`로 동기화하세요.

## 지도/CCTV 성능
- `src/pages/map/_components/Map.tsx:91-139,216-241`에서 선택 변경마다 모든 마커를 제거/재생성해 리렌더 비용이 큼. 마커를 1회 생성 후 강조 상태만 업데이트하고, 스크립트 중복 삽입/클린업도 방지하도록 로더를 분리하세요.
- `src/features/cctv/hooks/useCctvStream.ts`의 WHEP fetch는 AbortController/타임아웃 없이 재시도하며 에러 UI도 제한적. 전환 시 기존 요청을 취소하고, 실패 원인을 사용자에게 노출하는 상태/토스트를 추가하세요.

## UX 품질
- `src/pages/map/_components/HeobyDetail.tsx`의 클립보드 복사 실패 시 사용자 피드백이 없음. try/catch로 권한 오류를 처리하고 토스트를 노출해 성공/실패를 안내하세요.

# 방금 한 일
- 인증 가드 복원 및 세션 리셋 확장(heoby/CCTV 캐시 포함), 베이스 경로 대응 네비게이션 헬퍼 도입.
- FCM을 인증 후에만 요청하도록 수정하고, 퍼미션 거부/에러/미지원 시 배너 안내 및 서비스워커 베이스 경로 반영, 포그라운드 알림 토스트 및 목록 갱신 추가.
- 역할 값 안전성 강화(heoby, CCTV)와 알림 읽음 처리 시 React Query 캐시 동기화 개선.
- 지도 마커 재사용/강조로 리렌더 비용 축소, Naver 스크립트 로더 중복 방지, CCTV 스트림 Abort/타임아웃 및 토스트 추가, 위경도 복사 시 성공/실패 토스트 추가.
