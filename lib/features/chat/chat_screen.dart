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
            return Scaffold(appBar: AppBar(), body: const EmptyState('This item is no longer available.'));
          }
          final messages = store.thread(item.id);

          return Scaffold(
            appBar: AppBar(title: Text(item.name)),
            body: Column(children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                color: AppColors.banner,
                child: Text(
                  'Contact: ${item.contact}\nDescribe identifying details to verify ownership.',
                  style: const TextStyle(fontSize: 11, color: AppColors.muted),
                ),
              ),
              Expanded(
                child: messages.isEmpty
                    ? const EmptyState('No messages yet. Say hello!', icon: Icons.chat_bubble_outline)
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
