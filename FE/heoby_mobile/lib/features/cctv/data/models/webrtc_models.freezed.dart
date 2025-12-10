// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'webrtc_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SignalingMessage _$SignalingMessageFromJson(Map<String, dynamic> json) {
  return _SignalingMessage.fromJson(json);
}

/// @nodoc
mixin _$SignalingMessage {
  SignalingMessageType get type => throw _privateConstructorUsedError;
  Map<String, dynamic>? get payload => throw _privateConstructorUsedError;
  String? get from => throw _privateConstructorUsedError;
  String? get to => throw _privateConstructorUsedError;
  String? get roomId => throw _privateConstructorUsedError;
  int? get timestamp => throw _privateConstructorUsedError;

  /// Serializes this SignalingMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SignalingMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SignalingMessageCopyWith<SignalingMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignalingMessageCopyWith<$Res> {
  factory $SignalingMessageCopyWith(
    SignalingMessage value,
    $Res Function(SignalingMessage) then,
  ) = _$SignalingMessageCopyWithImpl<$Res, SignalingMessage>;
  @useResult
  $Res call({
    SignalingMessageType type,
    Map<String, dynamic>? payload,
    String? from,
    String? to,
    String? roomId,
    int? timestamp,
  });
}

/// @nodoc
class _$SignalingMessageCopyWithImpl<$Res, $Val extends SignalingMessage>
    implements $SignalingMessageCopyWith<$Res> {
  _$SignalingMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SignalingMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? payload = freezed,
    Object? from = freezed,
    Object? to = freezed,
    Object? roomId = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as SignalingMessageType,
            payload: freezed == payload
                ? _value.payload
                : payload // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            from: freezed == from
                ? _value.from
                : from // ignore: cast_nullable_to_non_nullable
                      as String?,
            to: freezed == to
                ? _value.to
                : to // ignore: cast_nullable_to_non_nullable
                      as String?,
            roomId: freezed == roomId
                ? _value.roomId
                : roomId // ignore: cast_nullable_to_non_nullable
                      as String?,
            timestamp: freezed == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SignalingMessageImplCopyWith<$Res>
    implements $SignalingMessageCopyWith<$Res> {
  factory _$$SignalingMessageImplCopyWith(
    _$SignalingMessageImpl value,
    $Res Function(_$SignalingMessageImpl) then,
  ) = __$$SignalingMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    SignalingMessageType type,
    Map<String, dynamic>? payload,
    String? from,
    String? to,
    String? roomId,
    int? timestamp,
  });
}

/// @nodoc
class __$$SignalingMessageImplCopyWithImpl<$Res>
    extends _$SignalingMessageCopyWithImpl<$Res, _$SignalingMessageImpl>
    implements _$$SignalingMessageImplCopyWith<$Res> {
  __$$SignalingMessageImplCopyWithImpl(
    _$SignalingMessageImpl _value,
    $Res Function(_$SignalingMessageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SignalingMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? payload = freezed,
    Object? from = freezed,
    Object? to = freezed,
    Object? roomId = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(
      _$SignalingMessageImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as SignalingMessageType,
        payload: freezed == payload
            ? _value._payload
            : payload // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        from: freezed == from
            ? _value.from
            : from // ignore: cast_nullable_to_non_nullable
                  as String?,
        to: freezed == to
            ? _value.to
            : to // ignore: cast_nullable_to_non_nullable
                  as String?,
        roomId: freezed == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String?,
        timestamp: freezed == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SignalingMessageImpl implements _SignalingMessage {
  const _$SignalingMessageImpl({
    required this.type,
    final Map<String, dynamic>? payload,
    this.from,
    this.to,
    this.roomId,
    this.timestamp,
  }) : _payload = payload;

  factory _$SignalingMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$SignalingMessageImplFromJson(json);

  @override
  final SignalingMessageType type;
  final Map<String, dynamic>? _payload;
  @override
  Map<String, dynamic>? get payload {
    final value = _payload;
    if (value == null) return null;
    if (_payload is EqualUnmodifiableMapView) return _payload;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? from;
  @override
  final String? to;
  @override
  final String? roomId;
  @override
  final int? timestamp;

  @override
  String toString() {
    return 'SignalingMessage(type: $type, payload: $payload, from: $from, to: $to, roomId: $roomId, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignalingMessageImpl &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other._payload, _payload) &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.to, to) || other.to == to) &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    type,
    const DeepCollectionEquality().hash(_payload),
    from,
    to,
    roomId,
    timestamp,
  );

  /// Create a copy of SignalingMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SignalingMessageImplCopyWith<_$SignalingMessageImpl> get copyWith =>
      __$$SignalingMessageImplCopyWithImpl<_$SignalingMessageImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SignalingMessageImplToJson(this);
  }
}

abstract class _SignalingMessage implements SignalingMessage {
  const factory _SignalingMessage({
    required final SignalingMessageType type,
    final Map<String, dynamic>? payload,
    final String? from,
    final String? to,
    final String? roomId,
    final int? timestamp,
  }) = _$SignalingMessageImpl;

  factory _SignalingMessage.fromJson(Map<String, dynamic> json) =
      _$SignalingMessageImpl.fromJson;

  @override
  SignalingMessageType get type;
  @override
  Map<String, dynamic>? get payload;
  @override
  String? get from;
  @override
  String? get to;
  @override
  String? get roomId;
  @override
  int? get timestamp;

  /// Create a copy of SignalingMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SignalingMessageImplCopyWith<_$SignalingMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SDPPayload _$SDPPayloadFromJson(Map<String, dynamic> json) {
  return _SDPPayload.fromJson(json);
}

/// @nodoc
mixin _$SDPPayload {
  String get sdp => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;

  /// Serializes this SDPPayload to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SDPPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SDPPayloadCopyWith<SDPPayload> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SDPPayloadCopyWith<$Res> {
  factory $SDPPayloadCopyWith(
    SDPPayload value,
    $Res Function(SDPPayload) then,
  ) = _$SDPPayloadCopyWithImpl<$Res, SDPPayload>;
  @useResult
  $Res call({String sdp, String type});
}

/// @nodoc
class _$SDPPayloadCopyWithImpl<$Res, $Val extends SDPPayload>
    implements $SDPPayloadCopyWith<$Res> {
  _$SDPPayloadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SDPPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? sdp = null, Object? type = null}) {
    return _then(
      _value.copyWith(
            sdp: null == sdp
                ? _value.sdp
                : sdp // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SDPPayloadImplCopyWith<$Res>
    implements $SDPPayloadCopyWith<$Res> {
  factory _$$SDPPayloadImplCopyWith(
    _$SDPPayloadImpl value,
    $Res Function(_$SDPPayloadImpl) then,
  ) = __$$SDPPayloadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String sdp, String type});
}

/// @nodoc
class __$$SDPPayloadImplCopyWithImpl<$Res>
    extends _$SDPPayloadCopyWithImpl<$Res, _$SDPPayloadImpl>
    implements _$$SDPPayloadImplCopyWith<$Res> {
  __$$SDPPayloadImplCopyWithImpl(
    _$SDPPayloadImpl _value,
    $Res Function(_$SDPPayloadImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SDPPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? sdp = null, Object? type = null}) {
    return _then(
      _$SDPPayloadImpl(
        sdp: null == sdp
            ? _value.sdp
            : sdp // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SDPPayloadImpl implements _SDPPayload {
  const _$SDPPayloadImpl({required this.sdp, required this.type});

  factory _$SDPPayloadImpl.fromJson(Map<String, dynamic> json) =>
      _$$SDPPayloadImplFromJson(json);

  @override
  final String sdp;
  @override
  final String type;

  @override
  String toString() {
    return 'SDPPayload(sdp: $sdp, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SDPPayloadImpl &&
            (identical(other.sdp, sdp) || other.sdp == sdp) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, sdp, type);

  /// Create a copy of SDPPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SDPPayloadImplCopyWith<_$SDPPayloadImpl> get copyWith =>
      __$$SDPPayloadImplCopyWithImpl<_$SDPPayloadImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SDPPayloadImplToJson(this);
  }
}

abstract class _SDPPayload implements SDPPayload {
  const factory _SDPPayload({
    required final String sdp,
    required final String type,
  }) = _$SDPPayloadImpl;

  factory _SDPPayload.fromJson(Map<String, dynamic> json) =
      _$SDPPayloadImpl.fromJson;

  @override
  String get sdp;
  @override
  String get type;

  /// Create a copy of SDPPayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SDPPayloadImplCopyWith<_$SDPPayloadImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ICECandidatePayload _$ICECandidatePayloadFromJson(Map<String, dynamic> json) {
  return _ICECandidatePayload.fromJson(json);
}

/// @nodoc
mixin _$ICECandidatePayload {
  String get candidate => throw _privateConstructorUsedError;
  String? get sdpMid => throw _privateConstructorUsedError;
  int? get sdpMLineIndex => throw _privateConstructorUsedError;

  /// Serializes this ICECandidatePayload to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ICECandidatePayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ICECandidatePayloadCopyWith<ICECandidatePayload> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ICECandidatePayloadCopyWith<$Res> {
  factory $ICECandidatePayloadCopyWith(
    ICECandidatePayload value,
    $Res Function(ICECandidatePayload) then,
  ) = _$ICECandidatePayloadCopyWithImpl<$Res, ICECandidatePayload>;
  @useResult
  $Res call({String candidate, String? sdpMid, int? sdpMLineIndex});
}

/// @nodoc
class _$ICECandidatePayloadCopyWithImpl<$Res, $Val extends ICECandidatePayload>
    implements $ICECandidatePayloadCopyWith<$Res> {
  _$ICECandidatePayloadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ICECandidatePayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? candidate = null,
    Object? sdpMid = freezed,
    Object? sdpMLineIndex = freezed,
  }) {
    return _then(
      _value.copyWith(
            candidate: null == candidate
                ? _value.candidate
                : candidate // ignore: cast_nullable_to_non_nullable
                      as String,
            sdpMid: freezed == sdpMid
                ? _value.sdpMid
                : sdpMid // ignore: cast_nullable_to_non_nullable
                      as String?,
            sdpMLineIndex: freezed == sdpMLineIndex
                ? _value.sdpMLineIndex
                : sdpMLineIndex // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ICECandidatePayloadImplCopyWith<$Res>
    implements $ICECandidatePayloadCopyWith<$Res> {
  factory _$$ICECandidatePayloadImplCopyWith(
    _$ICECandidatePayloadImpl value,
    $Res Function(_$ICECandidatePayloadImpl) then,
  ) = __$$ICECandidatePayloadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String candidate, String? sdpMid, int? sdpMLineIndex});
}

/// @nodoc
class __$$ICECandidatePayloadImplCopyWithImpl<$Res>
    extends _$ICECandidatePayloadCopyWithImpl<$Res, _$ICECandidatePayloadImpl>
    implements _$$ICECandidatePayloadImplCopyWith<$Res> {
  __$$ICECandidatePayloadImplCopyWithImpl(
    _$ICECandidatePayloadImpl _value,
    $Res Function(_$ICECandidatePayloadImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ICECandidatePayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? candidate = null,
    Object? sdpMid = freezed,
    Object? sdpMLineIndex = freezed,
  }) {
    return _then(
      _$ICECandidatePayloadImpl(
        candidate: null == candidate
            ? _value.candidate
            : candidate // ignore: cast_nullable_to_non_nullable
                  as String,
        sdpMid: freezed == sdpMid
            ? _value.sdpMid
            : sdpMid // ignore: cast_nullable_to_non_nullable
                  as String?,
        sdpMLineIndex: freezed == sdpMLineIndex
            ? _value.sdpMLineIndex
            : sdpMLineIndex // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ICECandidatePayloadImpl implements _ICECandidatePayload {
  const _$ICECandidatePayloadImpl({
    required this.candidate,
    this.sdpMid,
    this.sdpMLineIndex,
  });

  factory _$ICECandidatePayloadImpl.fromJson(Map<String, dynamic> json) =>
      _$$ICECandidatePayloadImplFromJson(json);

  @override
  final String candidate;
  @override
  final String? sdpMid;
  @override
  final int? sdpMLineIndex;

  @override
  String toString() {
    return 'ICECandidatePayload(candidate: $candidate, sdpMid: $sdpMid, sdpMLineIndex: $sdpMLineIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ICECandidatePayloadImpl &&
            (identical(other.candidate, candidate) ||
                other.candidate == candidate) &&
            (identical(other.sdpMid, sdpMid) || other.sdpMid == sdpMid) &&
            (identical(other.sdpMLineIndex, sdpMLineIndex) ||
                other.sdpMLineIndex == sdpMLineIndex));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, candidate, sdpMid, sdpMLineIndex);

  /// Create a copy of ICECandidatePayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ICECandidatePayloadImplCopyWith<_$ICECandidatePayloadImpl> get copyWith =>
      __$$ICECandidatePayloadImplCopyWithImpl<_$ICECandidatePayloadImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ICECandidatePayloadImplToJson(this);
  }
}

abstract class _ICECandidatePayload implements ICECandidatePayload {
  const factory _ICECandidatePayload({
    required final String candidate,
    final String? sdpMid,
    final int? sdpMLineIndex,
  }) = _$ICECandidatePayloadImpl;

  factory _ICECandidatePayload.fromJson(Map<String, dynamic> json) =
      _$ICECandidatePayloadImpl.fromJson;

  @override
  String get candidate;
  @override
  String? get sdpMid;
  @override
  int? get sdpMLineIndex;

  /// Create a copy of ICECandidatePayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ICECandidatePayloadImplCopyWith<_$ICECandidatePayloadImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
