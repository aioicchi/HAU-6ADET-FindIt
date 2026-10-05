import 'package:flutter/material.dart';

import 'package:findit/core/utils/validators.dart';
import 'package:findit/data/app_store.dart';
import 'package:findit/shared/shared.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: store.user!.name);
  late final _studentId = TextEditingController(text: store.user!.studentId);
  late final _phone = TextEditingController(text: store.user!.phone);

  @override
  void dispose() {
    for (final c in [_name, _studentId, _phone]) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    if (!_form.currentState!.validate()) return;
    store.updateProfile(name: _name.text, studentId: _studentId.text, phone: _phone.text);
    Navigator.pop(context);
    showSnack(context, 'Profile updated.');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Edit Profile')),
        body: Form(
          key: _form,
          child: ListView(padding: const EdgeInsets.all(14), children: [
            const FieldLabel('Full name'),
            TextFormField(controller: _name, validator: Validators.required),
            const FieldLabel('Email'),
            ReadOnlyField(store.user!.email, icon: Icons.lock_outline),
            const FieldLabel('Student ID'),
            TextFormField(controller: _studentId),
            const FieldLabel('Phone'),
            TextFormField(controller: _phone, keyboardType: TextInputType.phone),
            const SizedBox(height: 24),
            FilledButton(onPressed: _save, child: const Text('Save Changes')),
          ]),
        ),
      );
}
