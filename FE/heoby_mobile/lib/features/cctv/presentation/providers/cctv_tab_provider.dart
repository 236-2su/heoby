import 'package:flutter_riverpod/flutter_riverpod.dart';

class CctvTabNotifier extends StateNotifier<bool> {
  CctvTabNotifier() : super(false);

  void setActive(bool active) {
    if (state == active) return;
    state = active;
  }
}

final cctvTabActiveProvider = StateNotifierProvider<CctvTabNotifier, bool>((ref) {
  return CctvTabNotifier();
});
