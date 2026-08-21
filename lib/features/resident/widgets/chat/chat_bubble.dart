
import 'package:flutter/material.dart';
import '../../../../shared/theme/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../resident/models/message_model.dart';

class ChatBubble extends StatelessWidget {
  final MessageModel message;
  final bool isSender;
  final String? profileImage;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isSender,
    this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isSender) ...[
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
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isSender ? AppColors.primaryGold : AppColors.secondaryBlack,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: isSender ? const Radius.circular(12) : const Radius.circular(4),
                  bottomRight: isSender ? const Radius.circular(4) : const Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: isSender ? AppColors.primaryBlack : AppColors.textWhite,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getTime(message.timestamp),
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                      color: isSender
                          ? AppColors.primaryBlack.withOpacity(0.6)
                          : AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isSender) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primaryGold.withOpacity(0.1),
              child: Icon(
                Icons.person,
                color: AppColors.primaryGold,
                size: 18,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getTime(String timestamp) {
    // Simple placeholder - will use actual date formatter
    return '12:30 PM';
  }
}