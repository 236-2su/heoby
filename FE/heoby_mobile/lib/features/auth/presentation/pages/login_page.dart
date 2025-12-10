import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heoby_mobile/shared/widgets/box/base_box.dart';
import 'package:heoby_mobile/shared/widgets/log/debug_log.dart';

import '../providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    debugPrintLog('🔵 [LOGIN_PAGE] _handleLogin 호출됨');

    if (!_formKey.currentState!.validate()) {
      debugPrintLog('🔵 [LOGIN_PAGE] 폼 검증 실패');
      return;
    }

    debugPrintLog('🔵 [LOGIN_PAGE] 폼 검증 성공 - 로그인 시도');

    try {
      // AuthProvider를 사용한 로그인
      debugPrintLog('🔵 [LOGIN_PAGE] authProvider.login 호출 직전');
      await ref.read(authProvider.notifier).login(email: _emailController.text, password: _passwordController.text);
      debugPrintLog('🔵 [LOGIN_PAGE] authProvider.login 완료');

      if (mounted) {
        debugPrintLog('🔵 [LOGIN_PAGE] 로그인 성공 - SnackBar 표시');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('로그인 성공!')));
        // Router Guard가 자동으로 홈으로 리다이렉트
      }
    } catch (e) {
      debugPrintLog('🔵 [LOGIN_PAGE] 로그인 실패: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('로그인에 실패했습니다: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // AuthProvider 상태 감지
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xffeeedec), Color(0xfff0e6c6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: BaseBox(
                  title: '로그인',
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 아이디 입력
                        const Text(
                          '아이디',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: '아이디를 입력하세요',
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.blue, width: 2),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '아이디를 입력해주세요';
                            }
                            if (!value.contains('@')) {
                              return '올바른 이메일 형식이 아닙니다';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // 비밀번호 입력
                        const Text(
                          '비밀번호',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: '••••••••',
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.blue, width: 2),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '비밀번호를 입력해주세요';
                            }
                            if (value.length < 6) {
                              return '비밀번호는 6자 이상이어야 합니다';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // 로그인 버튼
                        SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade600,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.grey.shade400,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              elevation: 0,
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  )
                                : const Text('로그인', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 회원가입 링크
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('아직 계정이 없으신가요? ', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                              GestureDetector(
                                onTap: () {
                                  context.push('/signup');
                                },
                                child: const Text(
                                  '회원가입',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
