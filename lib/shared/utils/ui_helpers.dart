import 'package:flutter/material.dart';

void showSnack(BuildContext context, String message) => ScaffoldMessenger.of(context)
    .showSnackBar(SnackBar(content: Text(message), behavior: SnackBarBehavior.floating));

Future<T?> pushPage<T>(BuildContext context, Widget page) =>
    Navigator.push<T>(context, MaterialPageRoute(builder: (_) => page));

Future<bool> confirmDialog(BuildContext context, {required String title, required String message, String confirm = 'Confirm'}) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
        TextButton(onPressed: () => Navigator.pop(c, true), child: Text(confirm)),
      ],
    ),
  );
  return ok ?? false;
}
