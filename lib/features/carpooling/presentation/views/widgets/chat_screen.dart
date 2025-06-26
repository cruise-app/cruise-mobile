import 'package:flutter/material.dart';
import 'package:cruise/util/shared/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cruise/features/carpooling/presentation/manager/chat_manager/chat_bloc.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String tripId;
  final String userId;
  final String tripName;

  const ChatScreen({
    Key? key,
    required this.tripId,
    required this.userId,
    required this.tripName,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late ChatBloc _chatBloc;

  @override
  void initState() {
    super.initState();
    _chatBloc = ChatBloc();
    _chatBloc.add(JoinTripChat(
      tripId: widget.tripId,
      userId: widget.userId,
    ));
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      _chatBloc.add(SendChatMessage(
        tripId: widget.tripId,
        userId: widget.userId,
        content: _messageController.text.trim(),
      ));
      _messageController.clear();
      _chatBloc.add(UpdateTypingStatus(
        tripId: widget.tripId,
        userId: widget.userId,
        isTyping: false,
      ));
    }
  }

  void _handleTyping(String text) {
    _chatBloc.add(UpdateTypingStatus(
      tripId: widget.tripId,
      userId: widget.userId,
      isTyping: text.isNotEmpty,
    ));
  }

  @override
  void dispose() {
    _chatBloc.close();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _chatBloc,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.black,
          title: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              if (state is ChatLoaded) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.tripName,
                      style: const TextStyle(
                        color: MyColors.lightYellow,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (state.typingUsers.isNotEmpty)
                      Text(
                        '${state.typingUsers.length} typing...',
                        style: const TextStyle(
                          color: MyColors.lightGrey,
                          fontSize: 12,
                        ),
                      ),
                  ],
                );
              }
              return Text(
                widget.tripName,
                style: const TextStyle(
                  color: MyColors.lightYellow,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          iconTheme: const IconThemeData(color: MyColors.lightYellow),
        ),
        body: Container(
          color: MyColors.black,
          child: Column(
            children: [
              Expanded(
                child: BlocConsumer<ChatBloc, ChatState>(
                  listener: (context, state) {
                    if (state is ChatLoaded) {
                      Future.delayed(
                        const Duration(milliseconds: 100),
                        _scrollToBottom,
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is ChatLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: MyColors.lightYellow,
                        ),
                      );
                    }
                    if (state is ChatLoaded) {
                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(8),
                        itemCount: state.messages.length,
                        itemBuilder: (context, index) {
                          final message = state.messages[index];
                          final isMe = message['senderId'] == widget.userId;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: isMe
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width * 0.7,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isMe
                                        ? MyColors.lightYellow
                                        : MyColors.darkGrey,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: isMe
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        message['content'],
                                        style: TextStyle(
                                          color: isMe
                                              ? MyColors.black
                                              : MyColors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        DateFormat('HH:mm').format(
                                            DateTime.parse(
                                                message['createdAt'])),
                                        style: TextStyle(
                                          color: isMe
                                              ? MyColors.black.withOpacity(0.6)
                                              : MyColors.white.withOpacity(0.6),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                    if (state is ChatError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                color: MyColors.darkGrey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        onChanged: _handleTyping,
                        style: const TextStyle(color: MyColors.white),
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(color: MyColors.lightGrey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      color: MyColors.lightYellow,
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
