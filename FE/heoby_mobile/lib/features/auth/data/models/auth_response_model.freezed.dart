// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AuthResponseModel _$AuthResponseModelFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'login':
      return LoginResponseModel.fromJson(json);
    case 'refresh':
      return RefreshResponseModel.fromJson(json);

    default:
      throw CheckedFromJsonException(
        json,
        'runtimeType',
        'AuthResponseModel',
        'Invalid union type "${json['runtimeType']}"!',
      );
  }
}

/// @nodoc
mixin _$AuthResponseModel {
  String get accessToken => throw _privateConstructorUsedError;
  int get accessTokenExpiresIn => throw _privateConstructorUsedError;
  String get refreshToken => throw _privateConstructorUsedError;
  int get refreshTokenExpiresIn => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String accessToken,
      int accessTokenExpiresIn,
      String refreshToken,
      int refreshTokenExpiresIn,
      UserModel user,
    )
    login,
    required TResult Function(
      String accessToken,
      int accessTokenExpiresIn,
      String refreshToken,
      int refreshTokenExpiresIn,
      String userUuid,
    )
    refresh,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String accessToken,
      int accessTokenExpiresIn,
      String refreshToken,
      int refreshTokenExpiresIn,
      UserModel user,
    )?
    login,
    TResult? Function(
      String accessToken,
      int accessTokenExpiresIn,
      String refreshToken,
      int refreshTokenExpiresIn,
      String userUuid,
    )?
    refresh,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String accessToken,
      int accessTokenExpiresIn,
      String refreshToken,
      int refreshTokenExpiresIn,
      UserModel user,
    )?
    login,
    TResult Function(
      String accessToken,
      int accessTokenExpiresIn,
      String refreshToken,
      int refreshTokenExpiresIn,
      String userUuid,
    )?
    refresh,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoginResponseModel value) login,
    required TResult Function(RefreshResponseModel value) refresh,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginResponseModel value)? login,
    TResult? Function(RefreshResponseModel value)? refresh,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginResponseModel value)? login,
    TResult Function(RefreshResponseModel value)? refresh,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Serializes this AuthResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthResponseModelCopyWith<AuthResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthResponseModelCopyWith<$Res> {
  factory $AuthResponseModelCopyWith(
    AuthResponseModel value,
    $Res Function(AuthResponseModel) then,
  ) = _$AuthResponseModelCopyWithImpl<$Res, AuthResponseModel>;
  @useResult
  $Res call({
    String accessToken,
    int accessTokenExpiresIn,
    String refreshToken,
    int refreshTokenExpiresIn,
  });
}

/// @nodoc
class _$AuthResponseModelCopyWithImpl<$Res, $Val extends AuthResponseModel>
    implements $AuthResponseModelCopyWith<$Res> {
  _$AuthResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? accessTokenExpiresIn = null,
    Object? refreshToken = null,
    Object? refreshTokenExpiresIn = null,
  }) {
    return _then(
      _value.copyWith(
            accessToken: null == accessToken
                ? _value.accessToken
                : accessToken // ignore: cast_nullable_to_non_nullable
                      as String,
            accessTokenExpiresIn: null == accessTokenExpiresIn
                ? _value.accessTokenExpiresIn
                : accessTokenExpiresIn // ignore: cast_nullable_to_non_nullable
                      as int,
            refreshToken: null == refreshToken
                ? _value.refreshToken
                : refreshToken // ignore: cast_nullable_to_non_nullable
                      as String,
            refreshTokenExpiresIn: null == refreshTokenExpiresIn
                ? _value.refreshTokenExpiresIn
                : refreshTokenExpiresIn // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LoginResponseModelImplCopyWith<$Res>
    implements $AuthResponseModelCopyWith<$Res> {
  factory _$$LoginResponseModelImplCopyWith(
    _$LoginResponseModelImpl value,
    $Res Function(_$LoginResponseModelImpl) then,
  ) = __$$LoginResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String accessToken,
    int accessTokenExpiresIn,
    String refreshToken,
    int refreshTokenExpiresIn,
    UserModel user,
  });

  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class __$$LoginResponseModelImplCopyWithImpl<$Res>
    extends _$AuthResponseModelCopyWithImpl<$Res, _$LoginResponseModelImpl>
    implements _$$LoginResponseModelImplCopyWith<$Res> {
  __$$LoginResponseModelImplCopyWithImpl(
    _$LoginResponseModelImpl _value,
    $Res Function(_$LoginResponseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? accessTokenExpiresIn = null,
    Object? refreshToken = null,
    Object? refreshTokenExpiresIn = null,
    Object? user = null,
  }) {
    return _then(
      _$LoginResponseModelImpl(
        accessToken: null == accessToken
            ? _value.accessToken
            : accessToken // ignore: cast_nullable_to_non_nullable
                  as String,
        accessTokenExpiresIn: null == accessTokenExpiresIn
            ? _value.accessTokenExpiresIn
            : accessTokenExpiresIn // ignore: cast_nullable_to_non_nullable
                  as int,
        refreshToken: null == refreshToken
            ? _value.refreshToken
            : refreshToken // ignore: cast_nullable_to_non_nullable
                  as String,
        refreshTokenExpiresIn: null == refreshTokenExpiresIn
            ? _value.refreshTokenExpiresIn
            : refreshTokenExpiresIn // ignore: cast_nullable_to_non_nullable
                  as int,
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserModel,
      ),
    );
  }

  /// Create a copy of AuthResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res> get user {
    return $UserModelCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginResponseModelImpl implements LoginResponseModel {
  const _$LoginResponseModelImpl({
    required this.accessToken,
    required this.accessTokenExpiresIn,
    required this.refreshToken,
    required this.refreshTokenExpiresIn,
    required this.user,
    final String? $type,
  }) : $type = $type ?? 'login';

  factory _$LoginResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginResponseModelImplFromJson(json);

  @override
  final String accessToken;
  @override
  final int accessTokenExpiresIn;
  @override
  final String refreshToken;
  @override
  final int refreshTokenExpiresIn;
  @override
  final UserModel user;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'AuthResponseModel.login(accessToken: $accessToken, accessTokenExpiresIn: $accessTokenExpiresIn, refreshToken: $refreshToken, refreshTokenExpiresIn: $refreshTokenExpiresIn, user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginResponseModelImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.accessTokenExpiresIn, accessTokenExpiresIn) ||
                other.accessTokenExpiresIn == accessTokenExpiresIn) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.refreshTokenExpiresIn, refreshTokenExpiresIn) ||
                other.refreshTokenExpiresIn == refreshTokenExpiresIn) &&
            (identical(other.user, user) || other.user == user));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    accessToken,
    accessTokenExpiresIn,
    refreshToken,
    refreshTokenExpiresIn,
    user,
  );

  /// Create a copy of AuthResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginResponseModelImplCopyWith<_$LoginResponseModelImpl> get copyWith =>
      __$$LoginResponseModelImplCopyWithImpl<_$LoginResponseModelImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String accessToken,
      int accessTokenExpiresIn,
      String refreshToken,
      int refreshTokenExpiresIn,
      UserModel user,
    )
    login,
    required TResult Function(
      String accessToken,
      int accessTokenExpiresIn,
      String refreshToken,
      int refreshTokenExpiresIn,
      String userUuid,
    )
    refresh,
  }) {
    return login(
      accessToken,
      accessTokenExpiresIn,
      refreshToken,
      refreshTokenExpiresIn,
      user,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String accessToken,
      int accessTokenExpiresIn,
      String refreshToken,
      int refreshTokenExpiresIn,
      UserModel user,
    )?
    login,
    TResult? Function(
      String accessToken,
      int accessTokenExpiresIn,
      String refreshToken,
      int refreshTokenExpiresIn,
      String userUuid,
    )?
    refresh,
  }) {
    return login?.call(
      accessToken,
      accessTokenExpiresIn,
      refreshToken,
      refreshTokenExpiresIn,
      user,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String accessToken,
      int accessTokenExpiresIn,
      String refreshToken,
      int refreshTokenExpiresIn,
      UserModel user,
    )?
    login,
    TResult Function(
      String accessToken,
      int accessTokenExpiresIn,
      String refreshToken,
      int refreshTokenExpiresIn,
      String userUuid,
    )?
    refresh,
    required TResult orElse(),
  }) {
    if (login != null) {
      return login(
        accessToken,
        accessTokenExpiresIn,
        refreshToken,
        refreshTokenExpiresIn,
        user,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoginResponseModel value) login,
    required TResult Function(RefreshResponseModel value) refresh,
  }) {
    return login(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginResponseModel value)? login,
    TResult? Function(RefreshResponseModel value)? refresh,
  }) {
    return login?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginResponseModel value)? login,
    TResult Function(RefreshResponseModel value)? refresh,
    required TResult orElse(),
  }) {
    if (login != null) {
      return login(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginResponseModelImplToJson(this);
  }
}

abstract class LoginResponseModel implements AuthResponseModel {
  const factory LoginResponseModel({
    required final String accessToken,
    required final int accessTokenExpiresIn,
    required final String refreshToken,
    required final int refreshTokenExpiresIn,
    required final UserModel user,
  }) = _$LoginResponseModelImpl;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =
      _$LoginResponseModelImpl.fromJson;

  @override
  String get accessToken;
  @override
  int get accessTokenExpiresIn;
  @override
  String get refreshToken;
  @override
  int get refreshTokenExpiresIn;
  UserModel get user;

  /// Create a copy of AuthResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginResponseModelImplCopyWith<_$LoginResponseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RefreshResponseModelImplCopyWith<$Res>
    implements $AuthResponseModelCopyWith<$Res> {
  factory _$$RefreshResponseModelImplCopyWith(
    _$RefreshResponseModelImpl value,
    $Res Function(_$RefreshResponseModelImpl) then,
  ) = __$$RefreshResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String accessToken,
    int accessTokenExpiresIn,
    String refreshToken,
    int refreshTokenExpiresIn,
    String userUuid,
  });
}

/// @nodoc
class __$$RefreshResponseModelImplCopyWithImpl<$Res>
    extends _$AuthResponseModelCopyWithImpl<$Res, _$RefreshResponseModelImpl>
    implements _$$RefreshResponseModelImplCopyWith<$Res> {
  __$$RefreshResponseModelImplCopyWithImpl(
    _$RefreshResponseModelImpl _value,
    $Res Function(_$RefreshResponseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? accessTokenExpiresIn = null,
    Object? refreshToken = null,
    Object? refreshTokenExpiresIn = null,
    Object? userUuid = null,
  }) {
    return _then(
      _$RefreshResponseModelImpl(
        accessToken: null == accessToken
            ? _value.accessToken
            : accessToken // ignore: cast_nullable_to_non_nullable
                  as String,
        accessTokenExpiresIn: null == accessTokenExpiresIn
            ? _value.accessTokenExpiresIn
            : accessTokenExpiresIn // ignore: cast_nullable_to_non_nullable
                  as int,
        refreshToken: null == refreshToken
            ? _value.refreshToken
            : refreshToken // ignore: cast_nullable_to_non_nullable
                  as String,
        refreshTokenExpiresIn: null == refreshTokenExpiresIn
            ? _value.refreshTokenExpiresIn
            : refreshTokenExpiresIn // ignore: cast_nullable_to_non_nullable
                  as int,
        userUuid: null == userUuid
            ? _value.userUuid
            : userUuid // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RefreshResponseModelImpl implements RefreshResponseModel {
  const _$RefreshResponseModelImpl({
    required this.accessToken,
    required this.accessTokenExpiresIn,
    required this.refreshToken,
    required this.refreshTokenExpiresIn,
    required this.userUuid,
    final String? $type,
  }) : $type = $type ?? 'refresh';

  factory _$RefreshResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RefreshResponseModelImplFromJson(json);

  @override
  final String accessToken;
  @override
  final int accessTokenExpiresIn;
  @override
  final String refreshToken;
  @override
  final int refreshTokenExpiresIn;
  @override
  final String userUuid;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'AuthResponseModel.refresh(accessToken: $accessToken, accessTokenExpiresIn: $accessTokenExpiresIn, refreshToken: $refreshToken, refreshTokenExpiresIn: $refreshTokenExpiresIn, userUuid: $userUuid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RefreshResponseModelImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.accessTokenExpiresIn, accessTokenExpiresIn) ||
                other.accessTokenExpiresIn == accessTokenExpiresIn) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.refreshTokenExpiresIn, refreshTokenExpiresIn) ||
                other.refreshTokenExpiresIn == refreshTokenExpiresIn) &&
            (identical(other.userUuid, userUuid) ||
                other.userUuid == userUuid));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    accessToken,
    accessTokenExpiresIn,
    refreshToken,
    refreshTokenExpiresIn,
    userUuid,
  );

  /// Create a copy of AuthResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RefreshResponseModelImplCopyWith<_$RefreshResponseModelImpl>
  get copyWith =>
      __$$RefreshResponseModelImplCopyWithImpl<_$RefreshResponseModelImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String accessToken,
      int accessTokenExpiresIn,
      String refreshToken,
      int refreshTokenExpiresIn,
      UserModel user,
    )
    login,
    required TResult Function(
      String accessToken,
      int accessTokenExpiresIn,
      String refreshToken,
      int refreshTokenExpiresIn,
      String userUuid,
    )
    refresh,
  }) {
    return refresh(
      accessToken,
      accessTokenExpiresIn,
      refreshToken,
      refreshTokenExpiresIn,
      userUuid,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String accessToken,
      int accessTokenExpiresIn,
      String refreshToken,
      int refreshTokenExpiresIn,
      UserModel user,
    )?
    login,
    TResult? Function(
      String accessToken,
      int accessTokenExpiresIn,
      String refreshToken,
      int refreshTokenExpiresIn,
      String userUuid,
    )?
    refresh,
  }) {
    return refresh?.call(
      accessToken,
      accessTokenExpiresIn,
      refreshToken,
      refreshTokenExpiresIn,
      userUuid,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String accessToken,
      int accessTokenExpiresIn,
      String refreshToken,
      int refreshTokenExpiresIn,
      UserModel user,
    )?
    login,
    TResult Function(
      String accessToken,
      int accessTokenExpiresIn,
      String refreshToken,
      int refreshTokenExpiresIn,
      String userUuid,
    )?
    refresh,
    required TResult orElse(),
  }) {
    if (refresh != null) {
      return refresh(
        accessToken,
        accessTokenExpiresIn,
        refreshToken,
        refreshTokenExpiresIn,
        userUuid,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoginResponseModel value) login,
    required TResult Function(RefreshResponseModel value) refresh,
  }) {
    return refresh(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginResponseModel value)? login,
    TResult? Function(RefreshResponseModel value)? refresh,
  }) {
    return refresh?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginResponseModel value)? login,
    TResult Function(RefreshResponseModel value)? refresh,
    required TResult orElse(),
  }) {
    if (refresh != null) {
      return refresh(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RefreshResponseModelImplToJson(this);
  }
}

abstract class RefreshResponseModel implements AuthResponseModel {
  const factory RefreshResponseModel({
    required final String accessToken,
    required final int accessTokenExpiresIn,
    required final String refreshToken,
    required final int refreshTokenExpiresIn,
    required final String userUuid,
  }) = _$RefreshResponseModelImpl;

  factory RefreshResponseModel.fromJson(Map<String, dynamic> json) =
      _$RefreshResponseModelImpl.fromJson;

  @override
  String get accessToken;
  @override
  int get accessTokenExpiresIn;
  @override
  String get refreshToken;
  @override
  int get refreshTokenExpiresIn;
  String get userUuid;

  /// Create a copy of AuthResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RefreshResponseModelImplCopyWith<_$RefreshResponseModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
