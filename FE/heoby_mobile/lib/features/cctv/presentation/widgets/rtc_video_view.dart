import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;

/// WebRTC 비디오 뷰어 위젯
class CctvVideoView extends StatefulWidget {
  final rtc.MediaStream? stream;
  final bool mirror;
  final rtc.RTCVideoViewObjectFit objectFit;

  const CctvVideoView({
    super.key,
    this.stream,
    this.mirror = false,
    this.objectFit = rtc.RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
  });

  @override
  State<CctvVideoView> createState() => _CctvVideoViewState();
}

class _CctvVideoViewState extends State<CctvVideoView> {
  final rtc.RTCVideoRenderer _renderer = rtc.RTCVideoRenderer();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initRenderer();
  }

  Future<void> _initRenderer() async {
    try {
      await _renderer.initialize();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      debugPrint('Failed to initialize renderer: $e');
    }
  }

  @override
  void didUpdateWidget(CctvVideoView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stream != widget.stream) {
      _renderer.srcObject = widget.stream;
    }
  }

  @override
  void dispose() {
    _renderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized || widget.stream == null) {
      return Container(
        color: Colors.grey.shade900,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.videocam_off, size: 64, color: Colors.grey.shade600),
              const SizedBox(height: 16),
              Text(
                'CCTV 연결 대기 중...',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      );
    }

    _renderer.srcObject = widget.stream;

    return rtc.RTCVideoView(
      _renderer,
      mirror: widget.mirror,
      objectFit: widget.objectFit,
    );
  }
}
