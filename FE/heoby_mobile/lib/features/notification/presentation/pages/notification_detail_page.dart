import 'package:flutter/material.dart';
import 'package:heoby_mobile/core/theme/theme.dart';
import 'package:heoby_mobile/features/notification/domain/entities/notification_entity.dart';
import 'package:heoby_mobile/features/notification/presentation/widgets/notification_detail.dart';
import 'package:heoby_mobile/shared/widgets/layout/notification_layout.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationDetailPage extends StatelessWidget {
  const NotificationDetailPage({super.key, required this.alert});

  final NotificationAlertEntity alert;

  @override
  Widget build(BuildContext context) {
    return NotificationLayout(
      title: '알림 상세',
      hideNotificationIcon: true,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppSpacing.borderRadiusLg,
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                    child: NotificationDetail(alert: alert),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            final lat = alert.location.lat;
                            final lng = alert.location.lon;
                            final name = Uri.encodeComponent(alert.heobyName);

                            // 네이버 지도 앱 URL 스킴
                            final naverMapUrl = Uri.parse(
                              'nmap://route/public?dlat=$lat&dlng=$lng&dname=$name&appname=com.heoby.mobile',
                            );

                            // 네이버 지도 웹 URL (앱이 없을 경우 대체)
                            final naverMapWebUrl = Uri.parse(
                              'https://map.naver.com/?lng=$lng&lat=$lat&title=$name',
                            );

                            try {
                              if (await canLaunchUrl(naverMapUrl)) {
                                await launchUrl(naverMapUrl);
                              } else {
                                await launchUrl(naverMapWebUrl, mode: LaunchMode.externalApplication);
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('길찾기를 열 수 없습니다.'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red.shade600,
                            side: BorderSide(color: Colors.red.shade300),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('길 찾기', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      AppSpacing.gapHorizontalSm,
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('근처 119에 신고했습니다.'),
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).size.height - 150,
                                  left: 20,
                                  right: 20,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade500,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('신고하기', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        AppSpacing.gapVerticalLg,
      ],
    );
  }
}
