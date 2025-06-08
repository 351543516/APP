import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/user.dart';
import './add_user_screen.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('用户列表')),
      body: userProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : userProvider.error != null
          ? Center(child: Text(userProvider.error!))
          : ListView.builder(
        itemCount: userProvider.users.length,
        itemBuilder: (ctx, index) {
          final user = userProvider.users[index];
          return ListTile(
            title: Text(user.username),
            subtitle: Text(user.name ?? '未设置姓名'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await userProvider.deleteUser(user.id.toString());
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('用户已删除')),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => const AddUserScreen()),
        ),
      ),
    );
  }
}