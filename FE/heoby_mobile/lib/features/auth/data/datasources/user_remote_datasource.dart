import 'package:heoby_mobile/core/constants/api_endpoints.dart';
import 'package:heoby_mobile/core/network/dio_client.dart';
import 'package:heoby_mobile/features/auth/data/models/user_model.dart';

class UserRemoteDatasource {
  final DioClient _client;
  UserRemoteDatasource(this._client);

  Future<UserModel> getUser() async {
    final response = await _client.get(UserApi.me);

    return UserModel(
      userUuid: response.data['userUuid'],
      email: response.data['email'],
      username: response.data['username'],
      role: response.data['role'],
      villageId: response.data['userVillageId'],
    );
  }
}
