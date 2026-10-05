import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_colors.dart';
import 'package:findit/data/models/message.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble(this.message, {super.key});

  final Message message;

  @override
  Widget build(BuildContext context) => Align(
        alignment: message.fromMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          constraints: const BoxConstraints(maxWidth: 280),
          decoration: BoxDecoration(
            color: message.fromMe ? AppColors.navy : Colors.white,
            border: Border.all(color: AppColors.line),
          ),
          child: Text(message.text, style: TextStyle(color: message.fromMe ? Colors.white : Colors.black87, fontSize: 13)),
        ),
      );
}
