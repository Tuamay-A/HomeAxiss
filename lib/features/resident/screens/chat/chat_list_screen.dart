
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/chat_cubit.dart';
import '../../cubits/chat_state.dart';
import '../../widgets/common/resident_app_bar.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/empty_state_widget.dart';
import '../../../../shared/theme/colors.dart';
import 'chat_room_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().loadChatList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResidentAppBar(
        title: 'Chat',
        onNotificationTap: () {},
        onProfileTap: () {},
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const LoadingIndicator(message: 'Loading chats...');
          }

          if (state is ChatError) {
            return ResidentErrorWidget(
              message: state.message,
              onRetry: () {
                context.read<ChatCubit>().loadChatList();
              },
            );
          }

          if (state is ChatListLoaded) {
            final chats = state.chats;

            if (chats.isEmpty) {
              return const EmptyStateWidget(
                title: 'No Chats',
                message: 'You have no conversations yet',
                icon: Icons.chat_outlined,
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primaryGold.withOpacity(0.1),
                    child: Icon(
                      Icons.person,
                      color: AppColors.primaryGold,
                    ),
                  ),
                  title: Text(
                    chat.type == 'admin' ? 'Admin' : 'Guard',
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    chat.content,
                    style: TextStyle(
                      color: AppColors.textGray,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!chat.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryGold,
                            shape: BoxShape.circle,
                          ),
                        ),
                      Text(
                        chat.createdAt.substring(0, 10),
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatRoomScreen(chatId: chat.id),
                      ),
                    );
                  },
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}