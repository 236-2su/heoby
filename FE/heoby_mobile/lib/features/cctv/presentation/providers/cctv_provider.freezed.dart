// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cctv_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CctvState {
  WorkersEntity? get data => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of CctvState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CctvStateCopyWith<CctvState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CctvStateCopyWith<$Res> {
  factory $CctvStateCopyWith(CctvState value, $Res Function(CctvState) then) =
      _$CctvStateCopyWithImpl<$Res, CctvState>;
  @useResult
  $Res call({WorkersEntity? data, bool isLoading, String? error});
}

/// @nodoc
class _$CctvStateCopyWithImpl<$Res, $Val extends CctvState>
    implements $CctvStateCopyWith<$Res> {
  _$CctvStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CctvState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(
      _value.copyWith(
            data: freezed == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as WorkersEntity?,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CctvStateImplCopyWith<$Res>
    implements $CctvStateCopyWith<$Res> {
  factory _$$CctvStateImplCopyWith(
    _$CctvStateImpl value,
    $Res Function(_$CctvStateImpl) then,
  ) = __$$CctvStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({WorkersEntity? data, bool isLoading, String? error});
}

/// @nodoc
class __$$CctvStateImplCopyWithImpl<$Res>
    extends _$CctvStateCopyWithImpl<$Res, _$CctvStateImpl>
    implements _$$CctvStateImplCopyWith<$Res> {
  __$$CctvStateImplCopyWithImpl(
    _$CctvStateImpl _value,
    $Res Function(_$CctvStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CctvState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(
      _$CctvStateImpl(
        data: freezed == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as WorkersEntity?,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$CctvStateImpl implements _CctvState {
  const _$CctvStateImpl({this.data, this.isLoading = false, this.error});

  @override
  final WorkersEntity? data;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;

  @override
  String toString() {
    return 'CctvState(data: $data, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CctvStateImpl &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data, isLoading, error);

  /// Create a copy of CctvState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CctvStateImplCopyWith<_$CctvStateImpl> get copyWith =>
      __$$CctvStateImplCopyWithImpl<_$CctvStateImpl>(this, _$identity);
}

abstract class _CctvState implements CctvState {
  const factory _CctvState({
    final WorkersEntity? data,
    final bool isLoading,
    final String? error,
  }) = _$CctvStateImpl;

  @override
  WorkersEntity? get data;
  @override
  bool get isLoading;
  @override
  String? get error;

  /// Create a copy of CctvState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CctvStateImplCopyWith<_$CctvStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
