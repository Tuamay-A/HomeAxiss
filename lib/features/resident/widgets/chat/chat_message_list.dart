
import 'package:flutter/material.dart';
import '../../../../shared/theme/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../resident/models/message_model.dart';
import 'chat_bubble.dart';
import 'chat_typing_indicator.dart';

class ChatMessageList extends StatelessWidget {
  final List<MessageModel> messages;
  final bool isTyping;
  final bool isLoading;
  final String currentUserId;
  final ScrollController? scrollController;

  const ChatMessageList({
    super.key,
    required this.messages,
    required this.isTyping,
    required this.isLoading,
    required this.currentUserId,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGold),
          ),
        ),
      );
    }

    if (messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              color: AppColors.textDark,
              size: 48,
            ),
            const SizedBox(height: 8),
            Text(
              'No messages yet',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textGray,
              ),
            ),
            Text(
              'Start the conversation!',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      itemCount: messages.length + (isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == messages.length && isTyping) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: ChatTypingIndicator(),
          );
        }

        final message = messages[index];
        final isSender = message.senderId == currentUserId;

        return ChatBubble(
          message: message,
          isSender: isSender,
        );
      },
    );
  }
}