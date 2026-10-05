import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_colors.dart';

class MessageInput extends StatefulWidget {
  const MessageInput({super.key, required this.onSend});

  final ValueChanged<String> onSend;

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(children: [
            Expanded(
              child: TextField(
                controller: _controller,
                onSubmitted: (_) => _send(),
                decoration: const InputDecoration(hintText: 'Write a message...'),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              tooltip: 'Send message',
              onPressed: _send,
              icon: const Icon(Icons.send, size: 18),
              style: IconButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: AppColors.onNavy),
            ),
          ]),
        ),
      );
}
