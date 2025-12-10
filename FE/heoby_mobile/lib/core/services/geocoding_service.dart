import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

class GeocodingService {
  final Dio _dio = Dio();
  final Logger _logger = Logger();

  /// Reverse Geocoding: 위도/경도로 주소 가져오기
  Future<String?> getAddressFromCoordinates(double lat, double lon) async {
    final clientId = dotenv.env['NAVER_MAP_CLIENT_ID'];
    final clientSecret = dotenv.env['NAVER_MAP_CLIENT_SECRET'];

    _logger.d('Geocoding - Client ID: $clientId');
    _logger.d('Geocoding - Coordinates: $lat, $lon');

    if (clientId == null || clientSecret == null) {
      _logger.e('Geocoding - API keys not found');
      return null;
    }

    try {
      // Naver Reverse Geocoding API
      // coords: 경도,위도 순서
      final response = await _dio.get(
        'https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc',
        queryParameters: {
          'coords': '$lon,$lat',
          'orders': 'roadaddr,addr', // 도로명주소 우선, 지번주소 대체
          'output': 'json',
        },
        options: Options(
          headers: {
            'X-NCP-APIGW-API-KEY-ID': clientId,
            'X-NCP-APIGW-API-KEY': clientSecret,
          },
        ),
      );

      _logger.d('Geocoding - Status: ${response.statusCode}');
      _logger.d('Geocoding - Response: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        final results = data['results'] as List?;

        if (results != null && results.isNotEmpty) {
          final result = results[0];
          final region = result['region'];
          final land = result['land'];

          // 도로명 주소가 있으면 사용
          if (region != null && land != null) {
            final area1 = region['area1']?['name'] ?? '';
            final area2 = region['area2']?['name'] ?? '';
            final area3 = region['area3']?['name'] ?? '';
            final area4 = region['area4']?['name'] ?? '';

            // 상세 주소 조합
            final parts = [area1, area2, area3, area4]
                .where((part) => part.isNotEmpty)
                .toList();

            if (parts.isNotEmpty) {
              final address = parts.join(' ');
              _logger.i('Geocoding - Success: $address');
              return address;
            }
          }
        }
      }
    } catch (e) {
      _logger.e('Geocoding - Error: $e');
      if (e is DioException && e.response != null) {
        _logger.e('Geocoding - Error Response: ${e.response?.data}');
        _logger.e('Geocoding - Error Status: ${e.response?.statusCode}');
      }
      return null;
    }

    _logger.w('Geocoding - No address found');
    return null;
  }
}
