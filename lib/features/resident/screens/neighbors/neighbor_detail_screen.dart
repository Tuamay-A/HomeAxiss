
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../cubits/neighbor_cubit.dart';
import '../../cubits/neighbor_state.dart';
import '../../widgets/common/resident_app_bar.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/gold_button.dart';
import '../../../../shared/theme/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class NeighborDetailScreen extends StatefulWidget {
  final String neighborId;

  const NeighborDetailScreen({
    super.key,
    required this.neighborId,
  });

  @override
  State<NeighborDetailScreen> createState() => _NeighborDetailScreenState();
}

class _NeighborDetailScreenState extends State<NeighborDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NeighborCubit>().loadNeighborDetails(widget.neighborId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResidentAppBar(
        title: 'Neighbor Details',
        showBackButton: true,
        onNotificationTap: () {},
        onProfileTap: () {},
      ),
      body: BlocBuilder<NeighborCubit, NeighborState>(
        builder: (context, state) {
          if (state is NeighborLoading) {
            return const LoadingIndicator(message: 'Loading neighbor details...');
          }

          if (state is NeighborError) {
            return ResidentErrorWidget(
              message: state.message,
              onRetry: () {
                context.read<NeighborCubit>().loadNeighborDetails(widget.neighborId);
              },
            );
          }

          if (state is NeighborDetailsLoaded) {
            final neighbor = state.neighbor;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primaryGold.withOpacity(0.1),
                    child: neighbor.profilePhoto != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              neighbor.profilePhoto!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  color: AppColors.primaryGold,
                                  size: 50,
                                );
                              },
                            ),
                          )
                        : Icon(
                            Icons.person,
                            color: AppColors.primaryGold,
                            size: 50,
                          ),
                  ),
                  const SizedBox(height: 16),

                  // Name
                  Text(
                    neighbor.fullName,
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textWhite,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Unit
                  Text(
                    neighbor.unitDisplay,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.textGray,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Verified Badge
                  if (neighbor.isVerified)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.successGreen.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified,
                            color: AppColors.successGreen,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Verified Resident',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.successGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),

                  // Contact Info Card
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
                          'Contact Information',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textWhite,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildContactItem(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: neighbor.email,
                        ),
                        _buildContactItem(
                          icon: Icons.phone_outlined,
                          label: 'Phone',
                          value: neighbor.phoneNumber,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Contact Buttons
                  Row(
                    children: [
                      Expanded(
                        child: GoldButton(
                          text: 'Message',
                          variant: ButtonVariant.primary,
                          size: ButtonSize.small,
                          onPressed: () {
                            // Navigate to chat
                          },
                          icon: Icons.chat_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GoldButton(
                          text: 'Call',
                          variant: ButtonVariant.secondary,
                          size: ButtonSize.small,
                          onPressed: () {
                            _makePhoneCall(neighbor.phoneNumber);
                          },
                          icon: Icons.phone_outlined,
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

  Widget _buildContactItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primaryGold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryGold,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textGray,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textWhite,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not make phone call'),
          backgroundColor: AppColors.errorRed,
        ),
      );
    }
  }
}