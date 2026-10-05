import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_colors.dart';
import 'package:findit/data/app_store.dart';
import 'package:findit/shared/shared.dart';

import 'widgets/message_bubble.dart';
import 'widgets/message_input.dart';

/// Contact finder/owner: a message thread tied to one item.
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key, required this.itemId});

  final String itemId;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final item = store.findItem(itemId);
          if (item == null) {
            return const MissingReport();
          }
          final messages = store.thread(item.id);
          final isMine = item.ownerId == store.user?.id;

          return Scaffold(
            appBar: AppBar(title: Text(item.name)),
            body: Column(children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                color: AppColors.banner,
                child: Text(
                  // Contact info stays private, as promised on the report form.
                  isMine
                      ? 'Ask for identifying details before handing the item over. Your contact info stays hidden.'
                      : "The reporter's contact info is private. Describe identifying details to verify ownership.",
                  style: TextStyle(fontSize: 11, color: AppColors.muted),
                ),
              ),
              Expanded(
                child: messages.isEmpty
                    ? EmptyState(
                        isMine
                            ? 'No one has messaged about this report yet. You\'ll get a notification when they do.'
                            : 'Say hello below, and mention a detail that shows the item is yours.',
                        title: isMine ? 'No messages yet' : 'Start the conversation',
                        icon: Icons.chat_bubble_outline,
                      )
                    : ListView(
                        padding: const EdgeInsets.all(12),
                        children: [for (final m in messages) MessageBubble(m)],
                      ),
              ),
              MessageInput(onSend: (text) => store.sendMessage(item, text)),
            ]),
          );
        },
      );
}
