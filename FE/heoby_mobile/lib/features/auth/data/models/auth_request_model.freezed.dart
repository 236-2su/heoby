// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AuthRequestModel _$AuthRequestModelFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'login':
      return LoginRequest.fromJson(json);
    case 'logout':
      return LogoutRequest.fromJson(json);
    case 'refreshToken':
      return RefreshTokenRequest.fromJson(json);

    default:
      throw CheckedFromJsonException(
        json,
        'runtimeType',
        'AuthRequestModel',
        'Invalid union type "${json['runtimeType']}"!',
      );
  }
}

/// @nodoc
mixin _$AuthRequestModel {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password) login,
    required TResult Function(String refreshToken) logout,
    required TResult Function(String refreshToken) refreshToken,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password)? login,
    TResult? Function(String refreshToken)? logout,
    TResult? Function(String refreshToken)? refreshToken,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password)? login,
    TResult Function(String refreshToken)? logout,
    TResult Function(String refreshToken)? refreshToken,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoginRequest value) login,
    required TResult Function(LogoutRequest value) logout,
    required TResult Function(RefreshTokenRequest value) refreshToken,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginRequest value)? login,
    TResult? Function(LogoutRequest value)? logout,
    TResult? Function(RefreshTokenRequest value)? refreshToken,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginRequest value)? login,
    TResult Function(LogoutRequest value)? logout,
    TResult Function(RefreshTokenRequest value)? refreshToken,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Serializes this AuthRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthRequestModelCopyWith<$Res> {
  factory $AuthRequestModelCopyWith(
    AuthRequestModel value,
    $Res Function(AuthRequestModel) then,
  ) = _$AuthRequestModelCopyWithImpl<$Res, AuthRequestModel>;
}

/// @nodoc
class _$AuthRequestModelCopyWithImpl<$Res, $Val extends AuthRequestModel>
    implements $AuthRequestModelCopyWith<$Res> {
  _$AuthRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthRequestModel
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LoginRequestImplCopyWith<$Res> {
  factory _$$LoginRequestImplCopyWith(
    _$LoginRequestImpl value,
    $Res Function(_$LoginRequestImpl) then,
  ) = __$$LoginRequestImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String email, String password});
}

/// @nodoc
class __$$LoginRequestImplCopyWithImpl<$Res>
    extends _$AuthRequestModelCopyWithImpl<$Res, _$LoginRequestImpl>
    implements _$$LoginRequestImplCopyWith<$Res> {
  __$$LoginRequestImplCopyWithImpl(
    _$LoginRequestImpl _value,
    $Res Function(_$LoginRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? email = null, Object? password = null}) {
    return _then(
      _$LoginRequestImpl(
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable()
class _$LoginRequestImpl with DiagnosticableTreeMixin implements LoginRequest {
  const _$LoginRequestImpl({
    required this.email,
    required this.password,
    final String? $type,
  }) : $type = $type ?? 'login';

  factory _$LoginRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginRequestImplFromJson(json);

  @override
  final String email;
  @override
  final String password;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AuthRequestModel.login(email: $email, password: $password)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AuthRequestModel.login'))
      ..add(DiagnosticsProperty('email', email))
      ..add(DiagnosticsProperty('password', password));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginRequestImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email, password);

  /// Create a copy of AuthRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginRequestImplCopyWith<_$LoginRequestImpl> get copyWith =>
      __$$LoginRequestImplCopyWithImpl<_$LoginRequestImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password) login,
    required TResult Function(String refreshToken) logout,
    required TResult Function(String refreshToken) refreshToken,
  }) {
    return login(email, password);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password)? login,
    TResult? Function(String refreshToken)? logout,
    TResult? Function(String refreshToken)? refreshToken,
  }) {
    return login?.call(email, password);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password)? login,
    TResult Function(String refreshToken)? logout,
    TResult Function(String refreshToken)? refreshToken,
    required TResult orElse(),
  }) {
    if (login != null) {
      return login(email, password);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoginRequest value) login,
    required TResult Function(LogoutRequest value) logout,
    required TResult Function(RefreshTokenRequest value) refreshToken,
  }) {
    return login(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginRequest value)? login,
    TResult? Function(LogoutRequest value)? logout,
    TResult? Function(RefreshTokenRequest value)? refreshToken,
  }) {
    return login?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginRequest value)? login,
    TResult Function(LogoutRequest value)? logout,
    TResult Function(RefreshTokenRequest value)? refreshToken,
    required TResult orElse(),
  }) {
    if (login != null) {
      return login(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginRequestImplToJson(this);
  }
}

abstract class LoginRequest implements AuthRequestModel {
  const factory LoginRequest({
    required final String email,
    required final String password,
  }) = _$LoginRequestImpl;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =
      _$LoginRequestImpl.fromJson;

  String get email;
  String get password;

  /// Create a copy of AuthRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginRequestImplCopyWith<_$LoginRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LogoutRequestImplCopyWith<$Res> {
  factory _$$LogoutRequestImplCopyWith(
    _$LogoutRequestImpl value,
    $Res Function(_$LogoutRequestImpl) then,
  ) = __$$LogoutRequestImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String refreshToken});
}

/// @nodoc
class __$$LogoutRequestImplCopyWithImpl<$Res>
    extends _$AuthRequestModelCopyWithImpl<$Res, _$LogoutRequestImpl>
    implements _$$LogoutRequestImplCopyWith<$Res> {
  __$$LogoutRequestImplCopyWithImpl(
    _$LogoutRequestImpl _value,
    $Res Function(_$LogoutRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? refreshToken = null}) {
    return _then(
      _$LogoutRequestImpl(
        refreshToken: null == refreshToken
            ? _value.refreshToken
            : refreshToken // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LogoutRequestImpl
    with DiagnosticableTreeMixin
    implements LogoutRequest {
  const _$LogoutRequestImpl({required this.refreshToken, final String? $type})
    : $type = $type ?? 'logout';

  factory _$LogoutRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$LogoutRequestImplFromJson(json);

  @override
  final String refreshToken;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AuthRequestModel.logout(refreshToken: $refreshToken)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AuthRequestModel.logout'))
      ..add(DiagnosticsProperty('refreshToken', refreshToken));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LogoutRequestImpl &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, refreshToken);

  /// Create a copy of AuthRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LogoutRequestImplCopyWith<_$LogoutRequestImpl> get copyWith =>
      __$$LogoutRequestImplCopyWithImpl<_$LogoutRequestImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password) login,
    required TResult Function(String refreshToken) logout,
    required TResult Function(String refreshToken) refreshToken,
  }) {
    return logout(this.refreshToken);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password)? login,
    TResult? Function(String refreshToken)? logout,
    TResult? Function(String refreshToken)? refreshToken,
  }) {
    return logout?.call(this.refreshToken);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password)? login,
    TResult Function(String refreshToken)? logout,
    TResult Function(String refreshToken)? refreshToken,
    required TResult orElse(),
  }) {
    if (logout != null) {
      return logout(this.refreshToken);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoginRequest value) login,
    required TResult Function(LogoutRequest value) logout,
    required TResult Function(RefreshTokenRequest value) refreshToken,
  }) {
    return logout(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginRequest value)? login,
    TResult? Function(LogoutRequest value)? logout,
    TResult? Function(RefreshTokenRequest value)? refreshToken,
  }) {
    return logout?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginRequest value)? login,
    TResult Function(LogoutRequest value)? logout,
    TResult Function(RefreshTokenRequest value)? refreshToken,
    required TResult orElse(),
  }) {
    if (logout != null) {
      return logout(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$LogoutRequestImplToJson(this);
  }
}

abstract class LogoutRequest implements AuthRequestModel {
  const factory LogoutRequest({required final String refreshToken}) =
      _$LogoutRequestImpl;

  factory LogoutRequest.fromJson(Map<String, dynamic> json) =
      _$LogoutRequestImpl.fromJson;

  String get refreshToken;

  /// Create a copy of AuthRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LogoutRequestImplCopyWith<_$LogoutRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RefreshTokenRequestImplCopyWith<$Res> {
  factory _$$RefreshTokenRequestImplCopyWith(
    _$RefreshTokenRequestImpl value,
    $Res Function(_$RefreshTokenRequestImpl) then,
  ) = __$$RefreshTokenRequestImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String refreshToken});
}

/// @nodoc
class __$$RefreshTokenRequestImplCopyWithImpl<$Res>
    extends _$AuthRequestModelCopyWithImpl<$Res, _$RefreshTokenRequestImpl>
    implements _$$RefreshTokenRequestImplCopyWith<$Res> {
  __$$RefreshTokenRequestImplCopyWithImpl(
    _$RefreshTokenRequestImpl _value,
    $Res Function(_$RefreshTokenRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? refreshToken = null}) {
    return _then(
      _$RefreshTokenRequestImpl(
        refreshToken: null == refreshToken
            ? _value.refreshToken
            : refreshToken // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable()
class _$RefreshTokenRequestImpl
    with DiagnosticableTreeMixin
    implements RefreshTokenRequest {
  const _$RefreshTokenRequestImpl({
    required this.refreshToken,
    final String? $type,
  }) : $type = $type ?? 'refreshToken';

  factory _$RefreshTokenRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$RefreshTokenRequestImplFromJson(json);

  @override
  final String refreshToken;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AuthRequestModel.refreshToken(refreshToken: $refreshToken)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AuthRequestModel.refreshToken'))
      ..add(DiagnosticsProperty('refreshToken', refreshToken));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RefreshTokenRequestImpl &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, refreshToken);

  /// Create a copy of AuthRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RefreshTokenRequestImplCopyWith<_$RefreshTokenRequestImpl> get copyWith =>
      __$$RefreshTokenRequestImplCopyWithImpl<_$RefreshTokenRequestImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String email, String password) login,
    required TResult Function(String refreshToken) logout,
    required TResult Function(String refreshToken) refreshToken,
  }) {
    return refreshToken(this.refreshToken);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String email, String password)? login,
    TResult? Function(String refreshToken)? logout,
    TResult? Function(String refreshToken)? refreshToken,
  }) {
    return refreshToken?.call(this.refreshToken);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String email, String password)? login,
    TResult Function(String refreshToken)? logout,
    TResult Function(String refreshToken)? refreshToken,
    required TResult orElse(),
  }) {
    if (refreshToken != null) {
      return refreshToken(this.refreshToken);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoginRequest value) login,
    required TResult Function(LogoutRequest value) logout,
    required TResult Function(RefreshTokenRequest value) refreshToken,
  }) {
    return refreshToken(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginRequest value)? login,
    TResult? Function(LogoutRequest value)? logout,
    TResult? Function(RefreshTokenRequest value)? refreshToken,
  }) {
    return refreshToken?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginRequest value)? login,
    TResult Function(LogoutRequest value)? logout,
    TResult Function(RefreshTokenRequest value)? refreshToken,
    required TResult orElse(),
  }) {
    if (refreshToken != null) {
      return refreshToken(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RefreshTokenRequestImplToJson(this);
  }
}

abstract class RefreshTokenRequest implements AuthRequestModel {
  const factory RefreshTokenRequest({required final String refreshToken}) =
      _$RefreshTokenRequestImpl;

  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) =
      _$RefreshTokenRequestImpl.fromJson;

  String get refreshToken;

  /// Create a copy of AuthRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RefreshTokenRequestImplCopyWith<_$RefreshTokenRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
