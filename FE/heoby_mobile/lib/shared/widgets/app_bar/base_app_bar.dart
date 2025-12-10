import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:heoby_mobile/core/constants/app_constants.dart';
import 'package:heoby_mobile/core/theme/theme.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BaseAppBar({
    super.key,
    required this.title,
    this.hideNotificationIcon = false,
    this.backButtonColor = Colors.black,
  });

  final String title;
  final bool hideNotificationIcon;
  final Color backButtonColor;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    // 홈 페이지인 경우 로고 표시, 다른 페이지는 제목 표시
    final isHomePage = title == '허비';
    final canPop = Navigator.of(context).canPop();

    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      leading: canPop
          ? IconButton(
              icon: Icon(LucideIcons.chevronLeft, color: backButtonColor),
              onPressed: () => Navigator.of(context).maybePop(),
            )
          : null,
      iconTheme: IconThemeData(color: backButtonColor),
      title: isHomePage
          ? Image.asset(
              'assets/icons/logo.png',
              height: 40,
              fit: BoxFit.contain,
            )
          : Text(
              title,
              style: context.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 22,
              ),
            ),

      // const TextStyle(color: Colors.black)),
      backgroundColor: Colors.transparent,
      centerTitle: false,
      elevation: 2,
      surfaceTintColor: Colors.transparent,
      actions: hideNotificationIcon
          ? null
          : [
              IconButton(
                icon: Icon(LucideIcons.bell, color: backButtonColor),
                onPressed: () {
                  context.push(AppConstants.notificationPath.path);
                },
              ),
            ],
    );
  }
}
