import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heoby_mobile/core/theme/theme.dart';
import 'package:heoby_mobile/features/cctv/data/models/webrtc_models.dart';
import 'package:heoby_mobile/features/cctv/presentation/widgets/rtc_video_view.dart';
import 'package:heoby_mobile/features/heoby/domain/entities/heoby_entity.dart';
import 'package:heoby_mobile/shared/widgets/box/base_box.dart';

class CctvVideoSection extends StatelessWidget {
  final HeobyEntity? selectedHeoby;
  final RTCStatus status;
  final AsyncValue<MediaStream>? streamAsync;
  final String? serial;

  const CctvVideoSection({
    super.key,
    required this.selectedHeoby,
    required this.status,
    required this.streamAsync,
    required this.serial,
  });

  @override
  Widget build(BuildContext context) {
    final mediaStream = streamAsync?.valueOrNull;

    return BaseBox(
      title: selectedHeoby?.name ?? 'CCTV 피드',
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1F1F1F),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(AppSpacing.md),
                  bottomRight: Radius.circular(AppSpacing.md),
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: mediaStream != null
                        ? CctvVideoView(stream: mediaStream)
                        : _VideoPlaceholder(
                            selectedHeoby: selectedHeoby,
                            status: status,
                            serial: serial,
                          ),
                  ),
                  Positioned(
                    top: AppSpacing.lg,
                    left: AppSpacing.lg,
                    child: _StatusChip(status: status, serial: serial),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoPlaceholder extends StatelessWidget {
  final HeobyEntity? selectedHeoby;
  final RTCStatus status;
  final String? serial;

  const _VideoPlaceholder({
    required this.selectedHeoby,
    required this.status,
    required this.serial,
  });

  String _formatCoordinates(HeobyEntity heoby) {
    final lat = heoby.location.lat.toStringAsFixed(4);
    final lon = heoby.location.lon.toStringAsFixed(4);
    return '$lat, $lon';
  }

  String _connectionLabel(RTCStatus status, String? serial) {
    if (serial == null) return '연결 대기 중';
    switch (status) {
      case RTCStatus.connected:
        return '연결됨';
      case RTCStatus.connecting:
        return '연결 중...';
      case RTCStatus.failed:
        return '연결 실패';
      case RTCStatus.disconnected:
        return '연결 대기 중';
    }
  }

  String _connectionDescription(RTCStatus status) {
    switch (status) {
      case RTCStatus.connected:
        return 'CCTV 스트림을 수신하는 중입니다';
      case RTCStatus.connecting:
        return '연결 시도 중입니다';
      case RTCStatus.failed:
        return '연결에 실패했습니다';
      case RTCStatus.disconnected:
        return '연결을 시작하려면 허수아비를 선택하세요';
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationText = selectedHeoby != null ? _formatCoordinates(selectedHeoby!) : '허수아비를 선택해주세요';
    final statusText = serial == null ? '시리얼 번호 없음' : _connectionDescription(status);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.videocam,
            size: AppSpacing.iconXl2,
            color: AppColors.textMuted,
          ),
          AppSpacing.gapVerticalLg,
          Text(
            _connectionLabel(status, serial),
            style: AppTypography.titleMedium.copyWith(color: AppColors.textMuted),
          ),
          AppSpacing.gapVerticalSm,
          Text(
            locationText,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
          ),
          AppSpacing.gapVerticalXs,
          Text(
            statusText,
            style: AppTypography.caption.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final RTCStatus status;
  final String? serial;

  const _StatusChip({
    required this.status,
    required this.serial,
  });

  @override
  Widget build(BuildContext context) {
    Color background;
    String label;

    if (serial == null) {
      background = AppColors.danger;
      label = '연결 불가';
    } else {
      switch (status) {
        case RTCStatus.connected:
          background = AppColors.success;
          label = '연결됨';
          break;
        case RTCStatus.connecting:
          background = AppColors.warning;
          label = '연결 중';
          break;
        case RTCStatus.failed:
          background = AppColors.danger;
          label = '연결 실패';
          break;
        case RTCStatus.disconnected:
          background = AppColors.danger;
          label = '연결 안됨';
          break;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs + 2),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: AppColors.textOnPrimary,
          fontWeight: AppTypography.fontWeightSemiBold,
        ),
      ),
    );
  }
}
