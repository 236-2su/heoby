# Clean Architecture in Flutter

이 프로젝트는 Clean Architecture 원칙을 따릅니다. 이 문서에서는 왜 이런 구조를 사용하는지, 각 레이어의 역할이 무엇인지 설명합니다.

## 목차
- [Clean Architecture란?](#clean-architecture란)
- [레이어 구조](#레이어-구조)
- [Model vs Entity](#model-vs-entity)
- [폴더 구조](#폴더-구조)
- [실제 예시: Weather Feature](#실제-예시-weather-feature)
- [장단점](#장단점)

---

## Clean Architecture란?

Clean Architecture는 **관심사의 분리(Separation of Concerns)**를 통해 코드를 구조화하는 방법입니다.

### 핵심 원칙

1. **의존성 규칙(Dependency Rule)**
   ```
   Presentation → Domain ← Data
                    ↑
              (의존성 방향)
   ```
   - **외부 레이어**가 **내부 레이어**에 의존합니다
   - **내부 레이어**(Domain)는 외부를 모릅니다
   - Domain은 Presentation과 Data에 대해 알지 못합니다

2. **추상화에 의존**
   - 구체적인 구현이 아닌 인터페이스(추상 클래스)에 의존
   - 예: `WeatherRepository` (인터페이스) ← `WeatherRepositoryImpl` (구현)

3. **테스트 가능성**
   - 각 레이어를 독립적으로 테스트 가능
   - Mock 객체로 쉽게 대체 가능

---

## 레이어 구조

### 1. Domain Layer (비즈니스 로직의 핵심)

**위치:** `lib/features/{feature_name}/domain/`

**역할:**
- 앱의 핵심 비즈니스 로직
- 외부 의존성 없음 (순수 Dart 코드)
- 다른 레이어의 변경에 영향받지 않음

**구성:**
```
domain/
  ├── entities/        # 비즈니스 데이터 모델
  ├── repositories/    # 데이터 접근 인터페이스
  └── usecases/        # 비즈니스 규칙/유스케이스
```

**예시:**
```dart
// domain/entities/weather_entity.dart
// 순수한 비즈니스 객체 - JSON, API와 무관
class WeatherEntity {
  final String time;
  final double temperature;
  final double humidity;
  // 비즈니스 로직
  bool get isHot => temperature > 30;
}

// domain/repositories/weather_repository.dart
// 인터페이스만 정의 (구현은 Data Layer에)
abstract class WeatherRepository {
  Future<List<WeatherEntity>> getTodayForecast();
}

// domain/usecases/get_today_forecast.dart
// 하나의 비즈니스 유스케이스
class GetTodayForecast {
  final WeatherRepository repository;

  Future<List<WeatherEntity>> call() {
    return repository.getTodayForecast();
  }
}
```

---

### 2. Data Layer (데이터 처리)

**위치:** `lib/features/{feature_name}/data/`

**역할:**
- 외부 데이터 소스와의 통신 (API, DB, etc)
- Domain Entity로 변환
- Repository 인터페이스 구현

**구성:**
```
data/
  ├── models/          # API 응답 DTO (Data Transfer Object)
  ├── datasources/     # 실제 API 호출
  └── repositories/    # Repository 구현
```

**예시:**
```dart
// data/models/weather_model.dart
// JSON 직렬화를 위한 DTO
@freezed
class WeatherModel with _$WeatherModel {
  const factory WeatherModel({
    required String time,
    required double temperature,
    // @JsonKey로 API 필드명 매핑
    @JsonKey(name: 'wind_speed') required double windSpeed,
  }) = _WeatherModel;

  // JSON 파싱
  factory WeatherModel.fromJson(Map<String, dynamic> json) =>
      _$WeatherModelFromJson(json);
}

// Model → Entity 변환
extension WeatherModelX on WeatherModel {
  WeatherEntity toEntity() => WeatherEntity(
    time: time,
    temperature: temperature,
    windSpeed: windSpeed,
  );
}

// data/datasources/weather_remote_data_source.dart
// 실제 API 호출
class WeatherRemoteDataSource {
  final Dio dio;

  Future<List<WeatherModel>> fetchWeather() async {
    final response = await dio.get('/weather');
    return (response.data as List)
        .map((e) => WeatherModel.fromJson(e))
        .toList();
  }
}

// data/repositories/weather_repository_impl.dart
// Repository 인터페이스 구현
class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource dataSource;

  @override
  Future<List<WeatherEntity>> getTodayForecast() async {
    final models = await dataSource.fetchWeather();
    return models.map((model) => model.toEntity()).toList();
  }
}
```

---

### 3. Presentation Layer (UI)

**위치:** `lib/features/{feature_name}/presentation/`

**역할:**
- 사용자 인터페이스
- 상태 관리 (Riverpod, Bloc, etc)
- UseCase 호출

**구성:**
```
presentation/
  ├── providers/       # 상태 관리 (Riverpod)
  ├── pages/           # 화면
  └── widgets/         # UI 컴포넌트
```

**예시:**
```dart
// presentation/providers/weather_providers.dart
@riverpod
WeatherRepository weatherRepository(WeatherRepositoryRef ref) {
  return WeatherRepositoryImpl(
    dataSource: ref.watch(weatherDataSourceProvider),
  );
}

@riverpod
Future<List<WeatherEntity>> todayForecast(TodayForecastRef ref) {
  final usecase = GetTodayForecast(
    repository: ref.watch(weatherRepositoryProvider),
  );
  return usecase.call();
}

// presentation/pages/weather_page.dart
class WeatherPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forecast = ref.watch(todayForecastProvider);

    return forecast.when(
      data: (weather) => WeatherTable(weather: weather),
      loading: () => CircularProgressIndicator(),
      error: (e, s) => Text('Error: $e'),
    );
  }
}
```

---

## Model vs Entity

이게 가장 헷갈리는 부분입니다. 왜 같은 데이터를 두 번 정의할까요?

### Entity (Domain Layer)

```dart
// domain/entities/weather_entity.dart
class WeatherEntity {
  final String time;
  final double temperature;
  final double humidity;

  // 순수한 비즈니스 로직
  bool get isHot => temperature > 30;
  bool get isHumid => humidity > 70;
  String get weatherAdvice {
    if (isHot && isHumid) return '매우 더워요! 물 많이 드세요';
    if (isHot) return '더워요!';
    return '쾌적해요';
  }
}
```

**특징:**
- ✅ 순수 Dart 코드 (외부 의존성 없음)
- ✅ 비즈니스 로직 포함 가능
- ✅ API 변경에 영향받지 않음
- ❌ JSON 직렬화 없음
- ❌ API 필드명과 무관

### Model (Data Layer)

```dart
// data/models/weather_model.dart
@freezed
class WeatherModel with _$WeatherModel {
  const factory WeatherModel({
    required String time,
    @JsonKey(name: 'temp') required double temperature,
    @JsonKey(name: 'hum') required double humidity,
    @JsonKey(name: 'condition_code') required String? conditionCode,
  }) = _WeatherModel;

  factory WeatherModel.fromJson(Map<String, dynamic> json) =>
      _$WeatherModelFromJson(json);
}

extension WeatherModelX on WeatherModel {
  WeatherEntity toEntity() => WeatherEntity(
    time: time,
    temperature: temperature,
    humidity: humidity,
  );
}
```

**특징:**
- ✅ JSON 직렬화/역직렬화
- ✅ API 응답 구조와 1:1 매핑
- ✅ `@JsonKey`로 필드명 변환
- ✅ API 전용 필드 처리 (conditionCode)
- ❌ 비즈니스 로직 없음

### 왜 분리하나요?

#### 1. **API 변경으로부터 보호**

```
API가 변경되면:
  ┌─────────────┐
  │ WeatherModel│ ← API 응답 변경
  └──────┬──────┘
         │ Mapper만 수정
         ↓
  ┌──────────────┐
  │WeatherEntity │ ← 비즈니스 로직 영향 없음
  └──────────────┘
         ↓
  ┌──────────────┐
  │ Presentation │ ← UI 영향 없음
  └──────────────┘
```

**예시:**
API가 `temperature` → `temp_celsius`로 변경된다면?

```dart
// Model만 수정
@JsonKey(name: 'temp_celsius') required double temperature,

// Entity, UseCase, UI는 변경 없음!
```

#### 2. **비즈니스 로직 집중**

```dart
// ❌ Model에 비즈니스 로직 (안티패턴)
class WeatherModel {
  bool get isHot => temperature > 30; // API와 무관한 로직
}

// ✅ Entity에 비즈니스 로직
class WeatherEntity {
  bool get isHot => temperature > 30; // 순수 비즈니스 규칙
}
```

#### 3. **데이터 소스 독립성**

```dart
// 같은 Entity를 여러 소스에서 사용
class WeatherEntity { ... }

// REST API Model
class WeatherModel {
  WeatherEntity toEntity() { ... }
}

// GraphQL Model (나중에 추가)
class WeatherGraphQLModel {
  WeatherEntity toEntity() { ... } // 같은 Entity 사용!
}

// Local DB Model (나중에 추가)
class WeatherDbModel {
  WeatherEntity toEntity() { ... }
}
```

#### 4. **테스트 용이성**

```dart
// Entity는 순수 Dart → 쉬운 테스트
test('Weather should be hot when temperature > 30', () {
  final entity = WeatherEntity(temperature: 35, ...);
  expect(entity.isHot, true);
});

// Model은 JSON 파싱 테스트
test('Model should parse from JSON', () {
  final json = {'temp': 25.5, 'hum': 60};
  final model = WeatherModel.fromJson(json);
  expect(model.temperature, 25.5);
});
```

### 실전 예시: 허수아비 API

**API 응답:**
```json
{
  "scarecrow_uuid": "abc123",
  "name": "우리집 허수아비",
  "location": {"lat": 37.5, "lon": 127.0},
  "status": "active"
}
```

**Model (Data Layer):**
```dart
@freezed
class HeobyModel with _$HeobyModel {
  const factory HeobyModel({
    @JsonKey(name: 'scarecrow_uuid') required String scarecrowUuid,
    required String name,
    required Location location,
    required String status,
  }) = _HeobyModel;

  factory HeobyModel.fromJson(Map<String, dynamic> json) =>
      _$HeobyModelFromJson(json);
}

extension HeobyModelX on HeobyModel {
  HeobyEntity toEntity() => HeobyEntity(
    id: scarecrowUuid,  // 필드명 변경
    name: name,
    location: location,
    isActive: status == 'active',  // String → bool 변환
  );
}
```

**Entity (Domain Layer):**
```dart
class HeobyEntity {
  final String id;
  final String name;
  final Location location;
  final bool isActive;

  // 비즈니스 로직
  bool get isOperational => isActive;
  String get displayName => isActive ? '$name ✓' : '$name (정지됨)';
  double distanceFrom(Location userLocation) {
    // 거리 계산 로직
  }
}
```

---

## 폴더 구조

### Feature별 구조

```
lib/
  ├── core/                        # 공통 기능
  │   ├── models/
  │   │   └── location.dart        # 여러 feature에서 사용
  │   ├── network/
  │   │   └── dio_client.dart
  │   └── constants/
  │
  ├── features/
  │   ├── weather/                 # Weather Feature
  │   │   ├── data/
  │   │   │   ├── models/
  │   │   │   │   └── weather_model.dart
  │   │   │   ├── datasources/
  │   │   │   │   └── weather_remote_data_source.dart
  │   │   │   └── repositories/
  │   │   │       └── weather_repository_impl.dart
  │   │   ├── domain/
  │   │   │   ├── entities/
  │   │   │   │   └── weather_entity.dart
  │   │   │   ├── repositories/
  │   │   │   │   └── weather_repository.dart
  │   │   │   └── usecases/
  │   │   │       └── get_today_forecast.dart
  │   │   └── presentation/
  │   │       ├── providers/
  │   │       │   └── weather_providers.dart
  │   │       ├── pages/
  │   │       │   └── weather_page.dart
  │   │       └── widgets/
  │   │           └── weather_table.dart
  │   │
  │   └── heoby/                   # Heoby Feature (허수아비)
  │       ├── data/
  │       │   ├── models/
  │       │   │   ├── heoby_model.dart
  │       │   │   └── heoby_list_response.dart
  │       │   ├── datasources/
  │       │   │   └── heoby_remote_data_source.dart
  │       │   └── repositories/
  │       │       └── heoby_repository_impl.dart
  │       ├── domain/
  │       │   ├── entities/
  │       │   │   └── heoby_entity.dart
  │       │   ├── repositories/
  │       │   │   └── heoby_repository.dart
  │       │   └── usecases/
  │       │       ├── get_my_scarecrows.dart
  │       │       └── get_village_scarecrows.dart
  │       └── presentation/
  │           ├── providers/
  │           ├── pages/
  │           └── widgets/
  │
  └── main.dart
```

### 왜 이렇게 나누나요?

#### 1. **Feature 기반 분리**
```
❌ 나쁜 구조 (Layer별 분리)
lib/
  ├── models/           # 모든 feature의 model
  ├── repositories/     # 모든 feature의 repository
  └── pages/            # 모든 feature의 UI

✅ 좋은 구조 (Feature별 분리)
lib/features/
  ├── weather/          # Weather 관련 모든 것
  └── heoby/            # Heoby 관련 모든 것
```

**장점:**
- 기능 단위로 코드를 찾기 쉬움
- 한 feature 수정 시 다른 feature에 영향 없음
- Feature 단위로 삭제/추가 가능

#### 2. **Data, Domain, Presentation 분리**

```
weather/
  ├── data/         ← API, DB와 통신
  ├── domain/       ← 비즈니스 로직 (외부 의존 없음)
  └── presentation/ ← UI
```

**의존성 흐름:**
```
┌──────────────┐
│ Presentation │ ──depends on──→ ┌────────┐
└──────────────┘                  │ Domain │
                                  └────────┘
┌──────────────┐                      ↑
│     Data     │ ──implements────────┘
└──────────────┘
```

**장점:**
- Domain은 독립적 (API 변경에도 안전)
- Data 소스 교체 가능 (REST → GraphQL)
- 레이어별 테스트 가능

#### 3. **Core: 공통 기능**

```
core/
  ├── models/
  │   └── location.dart      # weather, heoby 모두 사용
  ├── network/
  │   └── dio_client.dart    # 공통 HTTP 클라이언트
  ├── constants/
  └── utils/
```

**언제 core에 넣나요?**
- 2개 이상의 feature에서 사용
- 비즈니스 로직 없는 순수 유틸리티
- 앱 전체 설정/상수

---

## 실제 예시: Weather Feature

프로젝트의 `weather` feature를 예시로 데이터 흐름을 살펴봅시다.

### 1. 사용자가 날씨 화면을 열면

```dart
// presentation/pages/weather_page.dart
class WeatherPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Provider 구독
    final forecast = ref.watch(todayForecastProvider);

    return forecast.when(
      data: (weatherList) => WeatherTable(weather: weatherList),
      loading: () => CircularProgressIndicator(),
      error: (e, s) => ErrorWidget(e),
    );
  }
}
```

### 2. Provider가 UseCase 호출

```dart
// presentation/providers/weather_providers.dart
@riverpod
Future<List<WeatherEntity>> todayForecast(TodayForecastRef ref) {
  final repository = ref.watch(weatherRepositoryProvider);
  final usecase = GetTodayForecast(repository);
  return usecase.call();
}
```

### 3. UseCase가 Repository 호출

```dart
// domain/usecases/get_today_forecast.dart
class GetTodayForecast {
  final WeatherRepository repository;

  Future<List<WeatherEntity>> call() async {
    // 비즈니스 규칙 적용 (예: 오늘 날짜만 필터)
    return repository.getTodayForecast();
  }
}
```

### 4. Repository 구현체가 DataSource 호출

```dart
// data/repositories/weather_repository_impl.dart
class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource dataSource;

  @override
  Future<List<WeatherEntity>> getTodayForecast() async {
    try {
      // DataSource에서 Model 받음
      final models = await dataSource.fetchWeather();

      // Model → Entity 변환
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
```

### 5. DataSource가 실제 API 호출

```dart
// data/datasources/weather_remote_data_source.dart
class WeatherRemoteDataSource {
  final Dio dio;

  Future<List<WeatherModel>> fetchWeather() async {
    final response = await dio.get('/api/weather');

    // JSON → WeatherModel
    return (response.data['forecasts'] as List)
        .map((json) => WeatherModel.fromJson(json))
        .toList();
  }
}
```

### 6. Model이 Entity로 변환

```dart
// data/models/weather_model.dart
extension WeatherModelX on WeatherModel {
  WeatherEntity toEntity() => WeatherEntity(
    time: time,
    temperature: temperature,
    humidity: humidity,
    precipitationProbability: precipitationProbability,
    windSpeed: windSpeed,
    condition: condition,
  );
}
```

### 전체 흐름 요약

```
사용자 클릭
    ↓
┌──────────────────┐
│  WeatherPage     │ (Presentation)
└────────┬─────────┘
         ↓
┌──────────────────┐
│ todayForecast    │ (Provider)
│ Provider         │
└────────┬─────────┘
         ↓
┌──────────────────┐
│ GetTodayForecast │ (UseCase - Domain)
└────────┬─────────┘
         ↓
┌──────────────────┐
│ WeatherRepository│ (Interface - Domain)
└────────┬─────────┘
         ↓
┌──────────────────┐
│WeatherRepository │ (Implementation - Data)
│     Impl         │
└────────┬─────────┘
         ↓
┌──────────────────┐
│WeatherRemote     │ (DataSource - Data)
│  DataSource      │
└────────┬─────────┘
         ↓
    API 서버
         ↓
    WeatherModel (JSON → Dart)
         ↓
    WeatherEntity (toEntity())
         ↓
    UI에 표시
```

---

## 장단점

### 장점

#### 1. **유지보수성**
- 각 레이어가 독립적
- 버그 발생 시 레이어 단위로 추적 가능
- 코드 변경 영향 범위 제한

#### 2. **테스트 용이성**
```dart
// Domain 테스트 (Mock 없이)
test('Weather should be hot', () {
  final entity = WeatherEntity(temperature: 35);
  expect(entity.isHot, true);
});

// Repository 테스트 (Mock DataSource)
test('Repository should return entities', () async {
  final mockDataSource = MockWeatherDataSource();
  final repository = WeatherRepositoryImpl(mockDataSource);

  when(mockDataSource.fetchWeather())
      .thenAnswer((_) async => [mockWeatherModel]);

  final result = await repository.getTodayForecast();
  expect(result, isA<List<WeatherEntity>>());
});
```

#### 3. **확장성**
- 새 feature 추가 시 기존 코드 영향 없음
- 데이터 소스 교체 가능 (REST → GraphQL → Local DB)
- 새 UseCase 추가 용이

#### 4. **협업**
- 레이어별로 작업 분담 가능
- API 개발 전에 Domain/Presentation 작업 가능 (Mock 사용)

### 단점

#### 1. **초기 설정 복잡**
- 보일러플레이트 코드 많음
- 간단한 CRUD도 많은 파일 필요

#### 2. **러닝 커브**
- 신규 개발자가 구조 이해에 시간 필요
- Clean Architecture 개념 학습 필요

#### 3. **오버 엔지니어링 위험**
- 작은 프로젝트에는 과도할 수 있음
- MVP에는 부담될 수 있음

### 언제 사용하나요?

#### ✅ Clean Architecture 추천
- 중대형 프로젝트
- 장기 유지보수 예정
- 복잡한 비즈니스 로직
- 팀 협업
- 테스트 커버리지 중요

#### ❌ 불필요한 경우
- 프로토타입/MVP
- 단순 CRUD 앱
- 1인 개발 + 짧은 기간
- 학습 프로젝트 (학습 목적 제외)

---

## 결론

### 핵심 정리

1. **Model (Data)**: API와 통신하는 DTO
   - JSON 직렬화
   - API 필드명 매핑
   - Entity로 변환

2. **Entity (Domain)**: 비즈니스 핵심
   - 순수 Dart
   - 비즈니스 로직
   - 외부 의존 없음

3. **폴더 구조**: Feature + Layer
   - Feature별 독립
   - 레이어별 책임 분리
   - 공통 기능은 core에

### 이 프로젝트에서는

```
weather feature (완성됨)
  → Model, Entity 분리
  → UseCase 사용
  → Repository 패턴

heoby feature (작업 중)
  → weather 패턴 따라가기
  → 같은 구조로 확장

공통 (Location)
  → core/models/ 에 분리
  → 여러 feature에서 재사용
```

---

## 참고 자료

- [Clean Architecture (Uncle Bob)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter Clean Architecture (Reso Coder)](https://resocoder.com/flutter-clean-architecture-tdd/)
- [Flutter Architecture Samples](https://github.com/brianegan/flutter_architecture_samples)
