// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'webrtc_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SignalingMessageImpl _$$SignalingMessageImplFromJson(
  Map<String, dynamic> json,
) => _$SignalingMessageImpl(
  type: $enumDecode(_$SignalingMessageTypeEnumMap, json['type']),
  payload: json['payload'] as Map<String, dynamic>?,
  from: json['from'] as String?,
  to: json['to'] as String?,
  roomId: json['roomId'] as String?,
  timestamp: (json['timestamp'] as num?)?.toInt(),
);

Map<String, dynamic> _$$SignalingMessageImplToJson(
  _$SignalingMessageImpl instance,
) => <String, dynamic>{
  'type': _$SignalingMessageTypeEnumMap[instance.type]!,
  'payload': instance.payload,
  'from': instance.from,
  'to': instance.to,
  'roomId': instance.roomId,
  'timestamp': instance.timestamp,
};

const _$SignalingMessageTypeEnumMap = {
  SignalingMessageType.offer: 'offer',
  SignalingMessageType.answer: 'answer',
  SignalingMessageType.iceCandidate: 'ice-candidate',
  SignalingMessageType.join: 'join',
  SignalingMessageType.leave: 'leave',
  SignalingMessageType.error: 'error',
};

_$SDPPayloadImpl _$$SDPPayloadImplFromJson(Map<String, dynamic> json) =>
    _$SDPPayloadImpl(sdp: json['sdp'] as String, type: json['type'] as String);

Map<String, dynamic> _$$SDPPayloadImplToJson(_$SDPPayloadImpl instance) =>
    <String, dynamic>{'sdp': instance.sdp, 'type': instance.type};

_$ICECandidatePayloadImpl _$$ICECandidatePayloadImplFromJson(
  Map<String, dynamic> json,
) => _$ICECandidatePayloadImpl(
  candidate: json['candidate'] as String,
  sdpMid: json['sdpMid'] as String?,
  sdpMLineIndex: (json['sdpMLineIndex'] as num?)?.toInt(),
);

Map<String, dynamic> _$$ICECandidatePayloadImplToJson(
  _$ICECandidatePayloadImpl instance,
) => <String, dynamic>{
  'candidate': instance.candidate,
  'sdpMid': instance.sdpMid,
  'sdpMLineIndex': instance.sdpMLineIndex,
};
