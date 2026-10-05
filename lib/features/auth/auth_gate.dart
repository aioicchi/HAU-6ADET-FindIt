import 'package:flutter/material.dart';

import 'package:findit/data/app_store.dart';
import 'package:findit/features/shell/main_shell.dart';

import 'screens/login_screen.dart';

/// Shows login or the main app depending on whether a user is signed in.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: store,
        builder: (_, _) => store.user == null ? const LoginScreen() : const MainShell(),
      );
}
