# TODO List - 우선순위 기반 정리

## 🔴 High Priority (기능 버그 및 중요 사용성 문제)

### 1. [NOTIFICATION] 알림 선택 시 해당 detail 페이지로 넘어가지 않음
**수정 계획:**
- NotificationList 컴포넌트에서 onPress 핸들러 추가
- gorouter를 사용하여 NotificationDetail 페이지로 라우팅
- NotificationDetail 페이지 생성 (단일 페이지로 모든 알림 타입 처리)
- 알림 타입에 따라 경고 색상, 이미지, 내용만 동적으로 변경
  - ERROR: 빨간색 배경 + 경고 아이콘
  - WARNING: 노란색 배경 + 주의 아이콘
  - INFO: 파란색 배경 + 정보 아이콘
- 알림 ID를 파라미터로 전달하여 해당 알림 데이터 fetch 

### 2. [HEOBY] 목록 테이블의 정렬이 이상함
**수정 계획:**
- 현재 사용 중인 Table 컴포넌트 구조 확인
- Table의 column width 값 조정 (각 컬럼에 적절한 flex 또는 width 지정)
- TableHeader와 TableRow의 정렬 일치 확인
- 각 셀의 textAlign, padding 값 통일
- 필요시 minWidth, maxWidth로 컬럼 크기 제한
- 데이터 정렬 로직(sort by 상태/시간) 확인 및 개선


### 3. [MAP] 지도의 허비 아이콘 보이기(모두)
**수정 계획:**
- Map 컴포넌트에서 모든 HEOBY 데이터 fetch 로직 확인
- API 호출 시 필터링 조건 제거 (모든 HEOBY 데이터 가져오기)
- Marker 컴포넌트가 배열의 모든 항목에 대해 렌더링되는지 확인 (map 함수 체크)
- SVG 아이콘이 assets/icons 또는 svg 폴더에 추가되면 import하여 적용
- zIndex 설정으로 마커가 겹칠 때 우선순위 조정
- 마커 크기 조정 (너무 크면 서로 가림)

### 4. [MAP] 지도 허비 선택시 selected Heoby
**수정 계획:**
- Marker onPress 이벤트에 selectedHeobyId state 업데이트 추가
- 선택된 Heoby의 Marker에 다른 스타일/색상 적용 (예: scale 확대, 색상 변경)
- 선택 시 하단에 상세 정보 카드 표시

## 🟡 Medium Priority (UX 개선 및 디자인 일관성)

### 5. [COMMON] 상단 하단에 간격이 없어서 답답한 느낌을 준다
**수정 계획:**
- 전역 Container 컴포넌트에 paddingVertical: 16-24 추가
- SafeAreaView 적용 여부 확인
- 각 섹션 사이 marginBottom/marginTop 통일 (예: 16px)

### 6. [COMMON] 박스 HEADER 글자 semibold + 글자 크기
**수정 계획:**
- 공통 Header 컴포넌트의 Text 스타일 수정
- fontWeight: '600' (semibold) 적용
- fontSize: 18-20으로 증가
- theme/typography.ts에 헤더용 스타일 정의

### 7. [APPBAR] 허비 → 로고로 변경
**수정 계획:**
- AppBar 컴포넌트에서 "허비" 텍스트를 Image 컴포넌트로 교체
- assets/images/logo.svg(또는 .png) 추가
- 로고 크기: height 24-32px 정도로 설정

### 8. [APPBAR] 다른 페이지의 경우에는 bold + 글자 크기 키우기
**수정 계획:**
- Stack.Screen options의 headerTitleStyle 수정
- fontWeight: '700' (bold), fontSize: 20-22 적용
- 각 페이지별 headerTitleStyle 일관성 유지

### 9. [HEOBY] 목록에 상태에 대한 색상 변경
**수정 계획:**
- 상태별 색상 매핑 객체 생성 (예: IDLE: gray, WORKING: green, ERROR: red)
- StatusBadge 컴포넌트 생성 또는 기존 컴포넌트 수정
- backgroundColor, color를 상태값에 따라 동적으로 적용

### 10. [HEOBY] 시간에 대한 정보를 간소화 하여 표현
**수정 계획:**
- date-fns 또는 moment 사용하여 상대 시간 표시 (예: "2시간 전", "어제")
- 또는 "MM/DD HH:mm" 형식으로 간소화
- formatDate 유틸 함수 작성

### 11. [MAP] 상세 정보에 대한 내용 수정 및 배터리 부분 사이즈 고려
**수정 계획:**
- 상세 정보 카드의 레이아웃 재구성 (필수 정보만 표시)
- 배터리 아이콘 크기 조정 (예: 24x12px)
- Progress bar 형식으로 배터리 표시 고려

### 12. [NOTIFICATION] 알림 초기 페이지 수정
**수정 계획:**
- 알림이 없을 때 Empty State 컴포넌트 추가
- 아이콘 + "알림이 없습니다" 메시지 표시
- 중앙 정렬 및 적절한 padding 적용

### 13. [NOTIFICATION] 알림 페이지에서는 알림 아이콘이 보이면 안됨
**수정 계획:**
- Notification 페이지의 headerRight 옵션을 null로 설정
- 또는 conditional rendering으로 현재 route가 Notification일 때 아이콘 숨김

### 14. [BOTTOM] bottom Navigation Bar 터치 시 애니메이션 수정
**수정 계획:**
- react-native-reanimated로 scale, opacity 애니메이션 추가
- Pressable의 onPressIn/onPressOut에 Animated.timing 적용
- scale: 0.95 효과로 눌림 피드백 강화

### 15. [CCTV] 상단 HEADER에 ROW(아이콘, COLUMN(온라인, 숫자))
**수정 계획:**
- CCTV 페이지 헤더에 View로 Row 레이아웃 구성
- flexDirection: 'row' + alignItems: 'center'
- 아이콘(Circle/Dot) + Text("온라인 3대") 형식으로 배치

### 16. [DASHBOARD] 작업 중 + 알림 이렇게?
**수정 계획:**
- Dashboard 상단에 StatusCard 컴포넌트 추가
- "작업 중: 3대" + "새 알림: 2개" 형식으로 표시
- 각각 다른 배경색으로 구분 (예: 작업 중 - blue, 알림 - red)

## 🟢 Low Priority (스타일 미세 조정)

### 17. [WEATHER] 날씨 데이터에 맞는 SVG 찾아보기
**수정 계획:**
- weather-icons 라이브러리 또는 react-native-vector-icons 사용
- 날씨 상태별 아이콘 매핑 (sunny, cloudy, rainy, snowy 등)
- assets/icons/weather 폴더에 SVG 파일 추가

### 18. [HEOBY] 목록에 있는 my, other의 svg 디자인 고려
**수정 계획:**
- 커스텀 SVG 아이콘 디자인 또는 기존 아이콘 라이브러리 활용
- "my": user-check, "other": users 같은 직관적인 아이콘 선택
- 색상: my - primary color, other - gray 톤으로 구분

### 19. [CCTV] CCTV 스트림 상단 borderRadius 수정
**수정 계획:**
- Video 또는 Image 컴포넌트의 borderTopLeftRadius, borderTopRightRadius만 적용
- 값: 12-16px
- overflow: 'hidden' 추가하여 radius 적용 보장

### 20. [PROFILE] 로그아웃 디자인 수정
**수정 계획:**
- Button 컴포넌트 스타일 변경: outline 또는 danger variant
- 빨간색 텍스트 + 빨간색 테두리
- 아이콘 추가 (log-out icon)

### 21. [NOTIFICATION] 뒤로가기 버튼의 색상 수정
**수정 계획:**
- headerLeft의 tintColor 수정
- theme의 primary color 또는 dark gray로 변경
- 전체 앱의 뒤로가기 버튼 색상 통일

### 22. [COMMON] 상단 status 색상 어둡게 수정
**수정 계획:**
- StatusBar 컴포넌트의 barStyle을 'dark-content'로 설정
- Android의 경우 backgroundColor를 어두운 색으로 설정
- SafeAreaView의 backgroundColor와 일치시키기

### 23. [COMMON] 전체적인 그림자 수정
**수정 계획:**
- 공통 shadow 스타일 유틸 함수 생성
- iOS: shadowColor, shadowOffset, shadowOpacity, shadowRadius
- Android: elevation 값 조정 (2-8 범위)
- theme/shadows.ts 파일에 small, medium, large 그림자 정의
