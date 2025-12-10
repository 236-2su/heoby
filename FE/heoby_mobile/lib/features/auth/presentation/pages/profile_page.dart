import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heoby_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:heoby_mobile/features/auth/presentation/providers/user_provider.dart';
import 'package:heoby_mobile/core/theme/theme.dart';
import 'package:heoby_mobile/shared/widgets/app_bar/base_app_bar.dart';

/// 프로필 페이지
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    // final user = UserEntity(
    //   userUuid: 'userUuid',
    //   email: 'email',
    //   username: 'username',
    //   role: UserRole.admin,
    //   villageId: 13,
    // );

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
        appBar: const BaseAppBar(title: '프로필'),
        body: Column(
          children: [
            // 프로필 헤더 섹션
            Padding(
              padding: AppSpacing.paddingLg,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl3, horizontal: AppSpacing.xl2),
                decoration: BoxDecoration(
                  gradient: AppColors.profileGradient,
                  borderRadius: AppSpacing.borderRadiusXl,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF667eea).withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // 아바타
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 50, color: Color(0xFF667eea)),
                      ),
                    ),
                    AppSpacing.gapVerticalLg,

                    // 사용자 이름
                    Text(
                      user.username,
                      style: AppTypography.headlineLarge.copyWith(
                        color: AppColors.textOnPrimary,
                      ),
                    ),

                    AppSpacing.gapVerticalSm,

                    // 이메일
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs + 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: AppSpacing.borderRadiusXl,
                      ),
                      child: Text(
                        user.email,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textOnPrimary,
                        ),
                      ),
                    ),

                    AppSpacing.gapVerticalSm,

                    // 역할 뱃지
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.textOnPrimary,
                        borderRadius: AppSpacing.borderRadiusXl,
                      ),
                      child: Text(
                        user.role.displayName,
                        style: AppTypography.labelMedium.copyWith(
                          color: const Color(0xFF667eea),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Spacer로 남은 공간 채우기
            const Spacer(),

            // 로그아웃 버튼
            Padding(
              padding: AppSpacing.paddingLg,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        title: const Text('로그아웃'),
                        content: const Text('정말 로그아웃 하시겠습니까?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('취소'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            style: TextButton.styleFrom(foregroundColor: Colors.red),
                            child: const Text('확인'),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await ref.read(authProvider.notifier).logout();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surface,
                    foregroundColor: AppColors.danger,
                    elevation: 0,
                    padding: AppSpacing.paddingVerticalLg,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppSpacing.borderRadiusMd,
                      side: BorderSide(color: AppColors.danger, width: 1.5),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.logout_rounded),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        '로그아웃',
                        style: AppTypography.button.copyWith(
                          color: AppColors.danger,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
