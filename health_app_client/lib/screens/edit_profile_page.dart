// lib/screens/edit_profile_page.dart
import 'package:flutter/material.dart';
import '../models/user.dart';

class EditProfilePage extends StatefulWidget {
  final User initialUser;

  const EditProfilePage({
    super.key,
    required this.initialUser,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late User _editedUser;

  @override
  void initState() {
    super.initState();
    _editedUser = widget.initialUser.copyWith();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('编辑资料')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              initialValue: _editedUser.username,
              decoration: const InputDecoration(labelText: '用户名'),
              onChanged: (value) => setState(() {
                _editedUser = _editedUser.copyWith(username: value);
              }),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, _editedUser),
              child: const Text('保存修改'),
            ),
          ],
        ),
      ),
    );
  }
}