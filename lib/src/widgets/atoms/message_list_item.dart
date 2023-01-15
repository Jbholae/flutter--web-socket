import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    show
        BorderRadius,
        BoxDecoration,
        BuildContext,
        CircleAvatar,
        Colors,
        Container,
        CrossAxisAlignment,
        EdgeInsets,
        Key,
        NetworkImage,
        Radius,
        Row,
        SizedBox,
        StatelessWidget,
        Text,
        TextDirection,
        Theme,
        Widget;
import 'package:provider/provider.dart' show ReadContext;
import 'package:sizer/sizer.dart';

import '../../models/chat_message_model.dart';
import '../../providers/auth_provider.dart';

class MessageListItem extends StatelessWidget {
  MessageListItem({
    Key? key,
    required this.message,
    required this.messageUp,
    required this.messageDown,
    required this.index,
    required this.lastIndex,
  }) : super(key: key);
  final radius50 = const Radius.circular(24);
  final radius8 = const Radius.circular(8);

  final ChatMessage message;
  final ChatMessage messageUp;
  final ChatMessage messageDown;
  final int index;
  final int lastIndex;

  late final isGroupUpFalse = messageUp.userId != message.userId;

  late final isGroupDownTrue = messageDown.userId == message.userId;
  late final isGroupDownFalse = messageDown.userId != message.userId;

  @override
  Widget build(BuildContext context) {
    final isUser = context.read<AuthProvider>().user!.uid == message.userId;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          textDirection: isUser ? TextDirection.rtl : TextDirection.ltr,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isUser) ...[
              if (isGroupDownFalse || index == 0)
                const CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://randomuser.me/api/portraits/men/7.jpg"),
                  maxRadius: 12,
                )
              else
                const SizedBox(width: 24),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: isUser
                      ? BorderRadius.only(
                          topLeft: radius50,
                          bottomLeft: radius50,
                          topRight: isGroupUpFalse || index == lastIndex
                              ? radius50
                              : radius8,
                          bottomRight: isGroupDownTrue && index != 0
                              ? radius8
                              : radius50,
                        )
                      : BorderRadius.only(
                          topLeft: isGroupUpFalse || index == lastIndex
                              ? radius50
                              : radius8,
                          bottomLeft: isGroupDownTrue && index != 0
                              ? radius8
                              : radius50,
                          bottomRight: radius50,
                          topRight: radius50,
                        ),
                  color: !isUser ? Colors.grey[800] : Colors.blue[400],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  message.text.trim(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.white),
                ),
              ),
            ),
            SizedBox(width: 24.w),
          ],
        ),
        if (isUser && index == 0)
          Text(
            message.status,
            style: Theme.of(context).textTheme.caption?.copyWith(
              color: Colors.grey[400]
            ),
          ),
      ],
    );
  }
}
