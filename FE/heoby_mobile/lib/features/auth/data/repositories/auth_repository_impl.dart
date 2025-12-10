import 'package:heoby_mobile/features/auth/data/models/auth_response_model.dart';

import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

/// Auth Repository Implementation (Data Layer)
/// Implements the domain repository interface
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<AuthEntity> login({
    required String email,
    required String password,
  }) async {
    // Call API
    final response = await remoteDataSource.login(
      email: email,
      password: password,
    );

    // Convert to entity
    final authResult = response.toEntity();

    // Save tokens to local storage
    await localDataSource.save(response.refreshToken);

    return authResult;
  }

  @override
  Future<void> logout() async {
    // Call API (optional, can be fire-and-forget)
    try {
      final String? refreshToken = await localDataSource.get();

      await remoteDataSource.logout(refreshToken!);
    } catch (e) {
      // Continue even if API call fails
    }

    // Clear local tokens
    await localDataSource.clear();
  }

  @override
  Future<AuthEntity> refresh(String refreshToken) async {
    // Call API
    final response = await remoteDataSource.refreshToken(refreshToken);

    // Convert to entity
    final authResult = response.toEntity();

    // Save new tokens
    await localDataSource.save(response.refreshToken);

    return authResult;
  }

  @override
  Future<String?> getRefreshToken() async {
    return await localDataSource.get();
  }
}
