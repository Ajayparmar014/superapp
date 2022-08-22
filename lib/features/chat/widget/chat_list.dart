import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:supperapp/common/enum/message_enum.dart';
import 'package:supperapp/common/provider/message_replay_provider.dart';
import 'package:supperapp/features/chat/controller/chat_controller.dart';
import 'package:supperapp/models/message.dart';
import 'package:supperapp/widgets/loader.dart';
import 'package:supperapp/features/chat/widget/my_message_card.dart';
import 'package:supperapp/features/chat/widget/sender_message_card.dart';

class ChatList extends ConsumerStatefulWidget {
  final String recieverUserId;
  final bool isGroupChat;
  const ChatList({
    Key? key,
    required this.recieverUserId,
    required this.isGroupChat,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  void onMessageSwipe(String message, bool isMe, MessageEnum messageEnum) {
    ref.read(messageReplyProvider.state).update(
          (state) => MessageReply(
            message: message,
            isMe: isMe,
            messageEnum: messageEnum,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream: widget.isGroupChat
            ? ref.read(chatControllerProvider).chatStream(widget.recieverUserId)
            : ref
                .read(chatControllerProvider)
                .chatStream(widget.recieverUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          SchedulerBinding.instance.addPostFrameCallback((_) {
            messageController
                .jumpTo(messageController.position.maxScrollExtent);
          });
          //singlechildScrollview  add kara
          return SingleChildScrollView(
            child: Column(
              children: [
                //i add expanded wi
                Expanded(
                  child: ListView.builder(
                      controller: messageController,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        final messageData = snapshot.data![index];
                        final timeSent =
                            DateFormat.Hm().format(messageData.timeSent);
                        //message auto seen feature implement
                        if (!messageData.isSeen &&
                            messageData.recieverId ==
                                FirebaseAuth.instance.currentUser!.uid) {
                          ref.read(chatControllerProvider).setChatMessageSeen(
                                context,
                                widget.recieverUserId,
                                messageData.messageId,
                              );
                        }
                        if (messageData.senderId ==
                            FirebaseAuth.instance.currentUser!.uid) {
                          return MyMessageCard(
                            message: messageData.text,
                            date: timeSent,
                            type: messageData.type,
                            repliedText: messageData.repliedMessage,
                            username: messageData.repliedTo,
                            repliedMessagetype: messageData.repliedMessageType,
                            onLeftSwipe: () => onMessageSwipe(
                              messageData.text,
                              true,
                              messageData.type,
                            ),
                            isSeen: messageData.isSeen,
                          );
                        }
                        return SenderMessageCard(
                          message: messageData.text,
                          date: timeSent,
                          type: messageData.type,
                          username: messageData.repliedTo,
                          repliedMessagetype: messageData.repliedMessageType,
                          repliedText: messageData.repliedMessage,
                          onRightSwipe: () => onMessageSwipe(
                            messageData.text,
                            false,
                            messageData.type,
                          ),
                        );
                      }),
                ),
              ],
            ),
          );
        });
  }
}
