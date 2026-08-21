
import 'package:flutter/material.dart';
import '../../../../shared/theme/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatTypingIndicator extends StatelessWidget {
  final String? name;

  const ChatTypingIndicator({
    super.key,
    this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primaryGold.withOpacity(0.1),
            child: Icon(
              Icons.person,
              color: AppColors.primaryGold,
              size: 18,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.secondaryBlack,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                if (name != null) ...[
                  Text(
                    '$name ',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textGray,
                    ),
                  ),
                ],
                _buildTypingDots(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDots() {
    return SizedBox(
      width: 40,
      height: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildDot(0),
          _buildDot(1),
          _buildDot(2),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        width: 6,
        height: 6,
        decoration: const BoxDecoration(
          color: AppColors.primaryGold,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}