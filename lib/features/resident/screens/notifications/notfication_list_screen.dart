
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/notification_cubit.dart';
import '../../cubits/notification_state.dart';
import '../../widgets/common/resident_app_bar.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/empty_state_widget.dart';
import '../../widgets/notifications/notification_item.dart';
import '../../../../shared/theme/colors.dart';
import 'notfication_detail_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>().loadNotifications();
    context.read<NotificationCubit>().loadUnreadCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResidentAppBar(
        title: 'Notifications',
        onNotificationTap: () {},
        onProfileTap: () {},
      ),
      body: BlocConsumer<NotificationCubit, NotificationState>(
        listener: (context, state) {
          if (state is NotificationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.errorRed,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const LoadingIndicator(message: 'Loading notifications...');
          }

          if (state is NotificationError) {
            return ResidentErrorWidget(
              message: state.message,
              onRetry: () {
                context.read<NotificationCubit>().loadNotifications();
              },
            );
          }

          if (state is NotificationListLoaded) {
            final notifications = state.notifications;

            return Column(
              children: [
                // Filter Chips
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('All', 'all'),
                        const SizedBox(width: 8),
                        _buildFilterChip('Unread', 'unread'),
                        const SizedBox(width: 8),
                        _buildFilterChip('Payment', 'payment'),
                        const SizedBox(width: 8),
                        _buildFilterChip('Announcement', 'announcement'),
                        const SizedBox(width: 8),
                        _buildFilterChip('Report', 'report'),
                      ],
                    ),
                  ),
                ),

                // Mark All as Read Button
                if (notifications.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          context.read<NotificationCubit>().markAllAsRead();
                        },
                        child: Text(
                          'Mark all as read',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryGold,
                          ),
                        ),
                      ),
                    ),
                  ),

                // Notification List
                Expanded(
                  child: notifications.isEmpty
                      ? const EmptyStateWidget(
                          title: 'No Notifications',
                          message: 'You\'re all caught up!',
                          icon: Icons.notifications_off_outlined,
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            final notification = notifications[index];
                            return NotificationItem(
                              notification: notification,
                              onTap: () {
                                if (!notification.isRead) {
                                  context.read<NotificationCubit>().markAsRead(notification.id);
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => NotificationDetailScreen(
                                      notificationId: notification.id,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = value;
        });
        context.read<NotificationCubit>().loadNotifications(
              isRead: value == 'unread'
                  ? false
                  : null,
              type: value == 'payment' || value == 'announcement' || value == 'report'
                  ? value
                  : null,
            );
      },
      backgroundColor: AppColors.secondaryBlack,
      selectedColor: AppColors.primaryGold.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primaryGold : AppColors.textGray,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? AppColors.primaryGold : AppColors.textDark,
      ),
    );
  }
}