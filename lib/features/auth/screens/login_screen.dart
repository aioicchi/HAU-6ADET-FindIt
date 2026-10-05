import 'package:flutter/material.dart';

import 'package:findit/core/theme/app_text_styles.dart';
import 'package:findit/data/app_store.dart';
import 'package:findit/data/mock_data.dart';
import 'package:findit/shared/shared.dart';

import '../widgets/auth_scaffold.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Prefilled with the demo account for quick testing.
  final _email = TextEditingController(text: MockData.demoEmail);
  final _password = TextEditingController(text: MockData.demoPassword);
  bool _obscure = true;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    final err = store.login(_email.text, _password.text);
    if (err != null) setState(() => _error = err);
  }

  @override
  Widget build(BuildContext context) => AuthScaffold(
        title: 'FindIt',
        subtitle: 'Sign in to report and find lost items on campus.',
        children: [
          const FieldLabel('University email'),
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'name@hau.edu.ph'),
          ),
          const FieldLabel('Password'),
          TextField(
            controller: _password,
            obscureText: _obscure,
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              hintText: 'Password',
              suffixIcon: IconButton(
                icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, size: 18),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
          ),
          if (_error != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_error!, style: AppTextStyles.error)),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => pushPage(context, const ForgotPasswordScreen()),
              child: const Text('Forgot password?'),
            ),
          ),
          FilledButton(onPressed: _submit, child: const Text('Sign In')),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => pushPage(context, const RegisterScreen()),
            child: const Text('Create Account'),
          ),
        ],
      );
}
