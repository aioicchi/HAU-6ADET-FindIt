import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_colors.dart';
import 'package:findit/core/utils/date_format.dart';
import 'package:findit/data/models/message.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble(this.message, {super.key});

  final Message message;

  @override
  Widget build(BuildContext context) {
    final mine = message.fromMe;
    final sender = message.sender;
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!mine && sender != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(sender, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.muted)),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            constraints: const BoxConstraints(maxWidth: 280),
            decoration: BoxDecoration(
              color: mine ? AppColors.navy : AppColors.surface,
              border: Border.all(color: AppColors.line),
            ),
            child: Text(message.text, style: TextStyle(color: mine ? AppColors.onNavy : AppColors.text, fontSize: 13)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 10),
            child: Text(timeAgo(message.time), style: TextStyle(fontSize: 9, color: AppColors.hint)),
          ),
        ],
      ),
    );
  }
}
