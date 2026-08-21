
// ignore_for_file: unused_field, unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/neighbor_cubit.dart';
import '../../cubits/neighbor_state.dart';
import '../../widgets/common/resident_app_bar.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/empty_state_widget.dart';
import '../../widgets/common/gold_text_field.dart';
import '../../../../shared/theme/colors.dart';
import 'neighbor_detail_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class NeighborListScreen extends StatefulWidget {
  const NeighborListScreen({super.key});

  @override
  State<NeighborListScreen> createState() => _NeighborListScreenState();
}

class _NeighborListScreenState extends State<NeighborListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<NeighborCubit>().loadNeighbors();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResidentAppBar(
        title: 'Neighbors',
        onNotificationTap: () {},
        onProfileTap: () {},
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.secondaryBlack,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryGold.withOpacity(0.2),
                ),
              ),
              child: TextField(
                controller: _searchController,
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Search neighbors by name or unit...',
                  hintStyle: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.primaryGold,
                    size: 20,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: AppColors.textDark,
                            size: 18,
                          ),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            });
                            context.read<NeighborCubit>().loadNeighbors();
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                  context.read<NeighborCubit>().loadNeighbors(
                        search: value.isNotEmpty ? value : null,
                      );
                },
              ),
            ),
          ),

          // Neighbor List
          Expanded(
            child: BlocBuilder<NeighborCubit, NeighborState>(
              builder: (context, state) {
                if (state is NeighborLoading) {
                  return const LoadingIndicator(message: 'Loading neighbors...');
                }

                if (state is NeighborError) {
                  return ResidentErrorWidget(
                    message: state.message,
                    onRetry: () {
                      context.read<NeighborCubit>().loadNeighbors();
                    },
                  );
                }

                if (state is NeighborListLoaded) {
                  final neighbors = state.neighbors;

                  if (neighbors.isEmpty) {
                    return const EmptyStateWidget(
                      title: 'No Neighbors Found',
                      message: 'Try adjusting your search or check back later',
                      icon: Icons.people_outline,
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: neighbors.length,
                    itemBuilder: (context, index) {
                      final neighbor = neighbors[index];
                      return _buildNeighborCard(context, neighbor);
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNeighborCard(BuildContext context, dynamic neighbor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NeighborDetailScreen(neighborId: neighbor.id),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.secondaryBlack,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primaryGold.withOpacity(0.05),
          ),
        ),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primaryGold.withOpacity(0.1),
              child: neighbor.profilePhoto != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.network(
                        neighbor.profilePhoto!,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.person,
                            color: AppColors.primaryGold,
                            size: 28,
                          );
                        },
                      ),
                    )
                  : Icon(
                      Icons.person,
                      color: AppColors.primaryGold,
                      size: 28,
                    ),
            ),
            const SizedBox(width: 12),

            // Name & Unit
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    neighbor.fullName,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textWhite,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    neighbor.unitDisplay,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textGray,
                    ),
                  ),
                ],
              ),
            ),

            // Verified Badge
            if (neighbor.isVerified)
              Icon(
                Icons.verified,
                color: AppColors.successGreen,
                size: 18,
              ),

            // Arrow
            Icon(
              Icons.chevron_right,
              color: AppColors.textDark,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}