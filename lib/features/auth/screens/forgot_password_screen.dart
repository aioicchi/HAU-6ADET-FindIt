import 'package:flutter/material.dart';

import 'package:findit/core/utils/validators.dart';
import 'package:findit/shared/shared.dart';

import '../widgets/auth_scaffold.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_form.currentState!.validate()) return;
    showSnack(context, 'Reset link sent to ${_email.text.trim()} (demo).');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => AuthScaffold(
        showBack: true,
        title: 'Reset Password',
        subtitle: "Enter your email and we'll send a reset link.",
        children: [
          Form(
            key: _form,
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              const FieldLabel('University email'),
              TextFormField(controller: _email, validator: Validators.email, decoration: const InputDecoration(hintText: 'name@hau.edu.ph')),
              const SizedBox(height: 20),
              FilledButton(onPressed: _submit, child: const Text('Send Reset Link')),
            ]),
          ),
        ],
      );
}
