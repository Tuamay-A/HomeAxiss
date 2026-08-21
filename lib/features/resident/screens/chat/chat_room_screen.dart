
// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/chat_cubit.dart';
import '../../cubits/chat_state.dart';
import '../../widgets/common/resident_app_bar.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/chat/chat_message_list.dart';
import '../../widgets/chat/chat_input_field.dart';
import '../../../../shared/theme/colors.dart';

class ChatRoomScreen extends StatefulWidget {
  final String chatId;

  const ChatRoomScreen({
    super.key,
    required this.chatId,
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().loadChatMessages(widget.chatId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResidentAppBar(
        title: 'Chat',
        showBackButton: true,
        onNotificationTap: () {},
        onProfileTap: () {},
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const LoadingIndicator(message: 'Loading messages...');
          }

          if (state is ChatError) {
            return ResidentErrorWidget(
              message: state.message,
              onRetry: () {
                context.read<ChatCubit>().loadChatMessages(widget.chatId);
              },
            );
          }

          if (state is ChatMessagesLoaded) {
            return Column(
              children: [
                Expanded(
                  child: ChatMessageList(
                    messages: state.messages,
                    isTyping: false,
                    isLoading: false,
                    currentUserId: 'current_user_id', // Should come from auth
                    scrollController: _scrollController,
                  ),
                ),
                ChatInputField(
                  onSend: (message) {
                    context.read<ChatCubit>().sendMessage(
                          chatId: widget.chatId,
                          content: message,
                        );
                  },
                  isLoading: state is ChatLoading,
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}