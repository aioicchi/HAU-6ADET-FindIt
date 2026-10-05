import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_colors.dart';
import 'package:findit/core/theme/app_text_styles.dart';
import 'package:findit/data/app_store.dart';
import 'package:findit/data/models/item.dart';
import 'package:findit/shared/shared.dart';

/// Claim someone's found item by answering the finder's verification question.
class ClaimScreen extends StatefulWidget {
  const ClaimScreen({super.key, required this.item});

  final Item item;

  @override
  State<ClaimScreen> createState() => _ClaimScreenState();
}

class _ClaimScreenState extends State<ClaimScreen> {
  final _form = GlobalKey<FormState>();
  final _answer = TextEditingController();

  @override
  void dispose() {
    _answer.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_form.currentState!.validate()) return;
    store.submitClaim(widget.item, _answer.text);
    Navigator.pop(context);
    showSnack(context, 'Claim sent. The finder will review your answer.');
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Scaffold(
      appBar: AppBar(title: const Text('Claim Item')),
      body: Form(
        key: _form,
        child: ListView(padding: const EdgeInsets.all(14), children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white, border: Border.all(color: AppColors.line)),
            child: Row(children: [
              SizedBox(width: 56, child: ItemPhoto(item, height: 56)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(item.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  Text(item.location, style: AppTextStyles.caption),
                  Text(item.whenLabel, style: AppTextStyles.caption),
                ]),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          const Text('VERIFY OWNERSHIP', style: AppTextStyles.label),
          const SizedBox(height: 4),
          const Text(
            "To make sure the item goes back to the right person, answer the finder's question. "
            'Be specific: details only the owner would know work best.',
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: AppColors.banner,
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.help_outline, size: 18, color: AppColors.navy),
              const SizedBox(width: 8),
              Expanded(child: Text(item.claimQuestion, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
            ]),
          ),
          const FieldLabel('Your answer'),
          TextFormField(
            controller: _answer,
            maxLines: 4,
            decoration: const InputDecoration(hintText: 'Describe the color, marks, stickers, contents...'),
            validator: (v) => (v ?? '').trim().length < 10 ? 'Add a bit more detail (at least 10 characters).' : null,
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _submit,
            icon: const Icon(Icons.verified_user_outlined, size: 18),
            label: const Text('Submit Claim'),
          ),
        ]),
      ),
    );
  }
}
