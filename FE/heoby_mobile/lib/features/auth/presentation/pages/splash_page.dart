import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    // main.dart에서 이미 initializeAuth()를 호출했으므로 여기서는 불필요
    // GoRouter의 redirect가 자동으로 인증 상태에 따라 페이지 이동 처리
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 앱 로고 (아이콘으로 대체, 실제로는 이미지 사용)
            Icon(
              Icons.security,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            // 앱 이름
            Text(
              'Heoby',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 48),
            // 로딩 인디케이터
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
