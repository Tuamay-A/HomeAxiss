
// ignore_for_file: unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/notification_cubit.dart';
import '../../cubits/notification_state.dart';
import '../../widgets/common/resident_app_bar.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/notifications/notification_type_icon.dart';
import '../../../../shared/theme/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationDetailScreen extends StatefulWidget {
  final String notificationId;

  const NotificationDetailScreen({
    super.key,
    required this.notificationId,
  });

  @override
  State<NotificationDetailScreen> createState() => _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>().loadNotificationDetails(widget.notificationId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResidentAppBar(
        title: 'Notification',
        showBackButton: true,
        onNotificationTap: () {},
        onProfileTap: () {},
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const LoadingIndicator(message: 'Loading notification...');
          }

          if (state is NotificationError) {
            return ResidentErrorWidget(
              message: state.message,
              onRetry: () {
                context.read<NotificationCubit>().loadNotificationDetails(
                      widget.notificationId,
                    );
              },
            );
          }

          if (state is NotificationDetailsLoaded) {
            final notification = state.notification;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      NotificationTypeIcon(type: notification.type),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification.title,
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textWhite,
                              ),
                            ),
                            Text(
                              notification.typeLabel,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.textGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Date
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: AppColors.textDark,
                        size: 14,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        notification.createdAt,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Divider
                  Divider(
                    color: AppColors.textDark.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),

                  // Body
                  Text(
                    notification.body,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: AppColors.textGray,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Data (if any)
                  if (notification.data != null && notification.data!.isNotEmpty) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryBlack,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primaryGold.withOpacity(0.1),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Additional Information',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textWhite,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...notification.data!.entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    entry.key,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppColors.textGray,
                                    ),
                                  ),
                                  Text(
                                    entry.value.toString(),
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textWhite,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],

                  // Status
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        notification.isRead
                            ? Icons.check_circle_outline
                            : Icons.circle_outlined,
                        color: notification.isRead
                            ? AppColors.successGreen
                            : AppColors.primaryGold,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        notification.isRead ? 'Read' : 'Unread',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: notification.isRead
                              ? AppColors.successGreen
                              : AppColors.primaryGold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}