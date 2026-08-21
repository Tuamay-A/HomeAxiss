
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/dashboard_cubit.dart';
import '../../cubits/dashboard_state.dart';
import '../../widgets/common/resident_app_bar.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/empty_state_widget.dart';
import '../../widgets/dashboard/dashboard_state_card.dart';
import '../../widgets/dashboard/dashboard_activity_item.dart';
import '../../widgets/dashboard/dashboard_quick_action.dart';
import '../../widgets/dashboard/dashboard_announcement_card.dart';
import '../../../../shared/theme/colors.dart';
import '../payments/make_payment_screen.dart';
import '../reports/create_report_screen.dart';
import '../lost_found/lost_found_list_screen.dart';
import '../chat/chat_list_screen.dart';

class ResidentDashboardScreen extends StatefulWidget {
  const ResidentDashboardScreen({super.key});

  @override
  State<ResidentDashboardScreen> createState() => _ResidentDashboardScreenState();
}

class _ResidentDashboardScreenState extends State<ResidentDashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardCubit>().loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResidentAppBar(
        title: 'HomeAxis',
        onNotificationTap: () {
          // Navigate to notifications
        },
        onProfileTap: () {
          // Navigate to profile
        },
      ),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const LoadingIndicator(message: 'Loading dashboard...');
          }

          if (state is DashboardError) {
            return ResidentErrorWidget(
              message: state.message,
              onRetry: () {
                context.read<DashboardCubit>().loadDashboard();
              },
            );
          }

          if (state is DashboardLoaded) {
            final data = state.data;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Message
                  Text(
                    'Welcome back!',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.textWhite
                          : AppColors.textPrimaryLight,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Here\'s what\'s happening in your condo',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.textGray
                          : AppColors.textSecondaryLight,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Stats Row
                  Row(
                    children: [
                      Expanded(
                        child: DashboardStatCard(
                          icon: Icons.payments_outlined,
                          value: 'ETB ${data.totalPayments.toStringAsFixed(2)}',
                          label: 'Total Paid',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DashboardStatCard(
                          icon: Icons.pending_actions,
                          value: data.pendingPayments.toString(),
                          label: 'Pending',
                          iconColor: AppColors.warningYellow,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: DashboardStatCard(
                          icon: Icons.report_problem_outlined,
                          value: data.openReports.toString(),
                          label: 'Open Reports',
                          iconColor: AppColors.errorRed,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DashboardStatCard(
                          icon: Icons.people_outline,
                          value: data.activeGroups.toString(),
                          label: 'Active Groups',
                          iconColor: AppColors.successGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Pinned Announcements
                  if (data.pinnedAnnouncements.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '📌 Pinned Announcements',
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? AppColors.textWhite
                                : AppColors.textPrimaryLight,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to all announcements
                          },
                          child: Text(
                            'See All',
                            style: TextStyle(
                              color: AppColors.primaryGold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...data.pinnedAnnouncements.map((announcement) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: DashboardAnnouncementCard(
                          announcement: announcement,
                          onTap: () {
                            // Navigate to announcement details
                          },
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                  ],

                  // Quick Actions
                  Text(
                    'Quick Actions',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.textWhite
                          : AppColors.textPrimaryLight,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      DashboardQuickAction(
                        icon: Icons.payments_outlined,
                        label: 'Pay Now',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MakePaymentScreen(),
                            ),
                          );
                        },
                      ),
                      DashboardQuickAction(
                        icon: Icons.report_problem_outlined,
                        label: 'Report',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CreateReportScreen(),
                            ),
                          );
                        },
                      ),
                      DashboardQuickAction(
                        icon: Icons.search_outlined,
                        label: 'Lost/Found',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LostFoundListScreen(),
                            ),
                          );
                        },
                      ),
                      DashboardQuickAction(
                        icon: Icons.chat_outlined,
                        label: 'Chat',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ChatListScreen(),
                            ),
                          );
                        },
                      ),
                      DashboardQuickAction(
                        icon: Icons.bar_chart_outlined,
                        label: 'Stats',
                        onTap: () {
                          // Navigate to stats
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Recent Activity
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Activity',
                        style: TextStyle(
                          color: AppColors.textWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to all activity
                        },
                        child: Text(
                          'See All',
                          style: TextStyle(
                            color: AppColors.primaryGold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (data.recentActivity.isEmpty)
                    const EmptyStateWidget(
                      title: 'No Activity',
                      message: 'Your recent activity will appear here',
                    )
                  else
                    ...data.recentActivity.map((activity) {
                      return DashboardActivityItem(
                        activity: activity,
                        onTap: () {
                          // Navigate to activity details
                        },
                      );
                    }),
                  const SizedBox(height: 20),
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