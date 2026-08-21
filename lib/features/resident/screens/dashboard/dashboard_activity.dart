
import 'package:flutter/material.dart';
import '../../../../shared/theme/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardActivity extends StatelessWidget {
  final List<Map<String, dynamic>> activities;
  final VoidCallback? onSeeAllTap;

  const DashboardActivity({
    super.key,
    required this.activities,
    this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Activity',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textWhite,
              ),
            ),
            TextButton(
              onPressed: onSeeAllTap,
              child: Text(
                'See All',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryGold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Activity List
        if (activities.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.secondaryBlack,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.textDark.withOpacity(0.2),
              ),
            ),
            child: Text(
              'No recent activity',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textGray,
              ),
            ),
          )
        else
          ...activities.map((activity) {
            return _buildActivityItem(context, activity);
          }),
      ],
    );
  }

  Widget _buildActivityItem(BuildContext context, Map<String, dynamic> activity) {
    final icon = activity['icon'] as String? ?? '📌';
    final title = activity['title'] as String? ?? '';
    final description = activity['description'] as String? ?? '';
    final time = activity['time'] as String? ?? 'Just now';
    final status = activity['status'] as String?;
    final onTap = activity['onTap'] as VoidCallback?;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.textDark.withOpacity(0.2),
            ),
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryGold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  icon,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textWhite,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textGray,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Status & Time
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (status != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      status,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: _getStatusColor(status),
                      ),
                    ),
                  ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
      case 'completed':
      case 'resolved':
        return AppColors.successGreen;
      case 'pending':
        return AppColors.warningYellow;
      case 'rejected':
      case 'cancelled':
        return AppColors.errorRed;
      default:
        return AppColors.textGray;
    }
  }
}