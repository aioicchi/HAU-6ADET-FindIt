import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_text_styles.dart';
import 'package:findit/core/utils/validators.dart';
import 'package:findit/data/app_store.dart';
import 'package:findit/shared/shared.dart';

import '../widgets/auth_scaffold.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _studentId = TextEditingController();
  final _password = TextEditingController();
  String? _error;

  @override
  void dispose() {
    for (final c in [_name, _email, _studentId, _password]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (!_form.currentState!.validate()) return;
    final err = store.register(name: _name.text, email: _email.text, studentId: _studentId.text, password: _password.text);
    if (err != null) {
      setState(() => _error = err);
    } else {
      // AuthGate underneath now shows the main app.
      Navigator.popUntil(context, (r) => r.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) => AuthScaffold(
        showBack: true,
        title: 'Create Account',
        subtitle: 'Use your university email to register.',
        children: [
          Form(
            key: _form,
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              const FieldLabel('Full name'),
              TextFormField(controller: _name, validator: Validators.required),
              const FieldLabel('University email'),
              TextFormField(controller: _email, keyboardType: TextInputType.emailAddress, validator: Validators.email),
              const FieldLabel('Student ID'),
              TextFormField(controller: _studentId, validator: Validators.required),
              const FieldLabel('Password'),
              TextFormField(controller: _password, obscureText: true, validator: Validators.password),
              const FieldLabel('Confirm password'),
              TextFormField(obscureText: true, validator: (v) => v != _password.text ? 'Passwords do not match' : null),
              if (_error != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_error!, style: AppTextStyles.error)),
              const SizedBox(height: 20),
              FilledButton(onPressed: _submit, child: const Text('Register')),
            ]),
          ),
        ],
      );
}
