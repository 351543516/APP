// lib/screens/my_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/user.dart';
import 'edit_profile_page.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'health_record_page.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  late Future<User?> _userProfileFuture;

  @override
  void initState() {
    super.initState();
    _userProfileFuture = _checkLoginStatus();
  }

  Future<User?> _checkLoginStatus() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final isLoggedIn = await userProvider.isLoggedIn();
    return isLoggedIn ? userProvider.fetchUserProfile() : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildPremiumAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0x1A2B3D86), Colors.white],
          ),
        ),
        child: FutureBuilder<User?>(
          future: _userProfileFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingIndicator();
            }
            if (snapshot.hasError) {
              return _buildErrorState(snapshot);
            }
            return snapshot.data == null
                ? _buildAuthButtons()
                : _buildUserContent(snapshot.data!);
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildPremiumAppBar() {
    return AppBar(
      title: const Text('我的', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2B3D86), Color(0xFF3A4D9C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      elevation: 4,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  Widget _buildLoadingIndicator() => Center(
    child: CircularProgressIndicator.adaptive(
      strokeWidth: 2,
      valueColor: const AlwaysStoppedAnimation(Color(0xFF2B3D86)),
    ),
  );

  Widget _buildErrorState(AsyncSnapshot<User?> snapshot) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, color: Colors.red, size: 48),
        const SizedBox(height: 20),
        Text('加载失败，请检查网络', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          icon: const Icon(Icons.refresh, size: 20),
          label: const Text('重试'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF2B3D86),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          ),
          onPressed: () => setState(() => _userProfileFuture = _checkLoginStatus()),
        ),
      ],
    ),
  );

  Widget _buildAuthButtons() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 80),
        _buildAuthButton(
          '登录',
          Icons.fingerprint,
              () => _navigateTo(const LoginPage()),
        ),
        const SizedBox(height: 32),
        _buildAuthButton(
          '注册',
          Icons.app_registration,
              () => _navigateTo(const RegisterPage()),
        ),
      ],
    ),
  );

  Widget _buildAuthButton(String text, IconData icon, VoidCallback action) => Container(
    width: 240,
    child: ElevatedButton.icon(
      icon: Icon(icon, size: 24),
      label: Text(text, style: const TextStyle(fontSize: 18)),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF2B3D86),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: action,
    ),
  );

  Widget _buildUserContent(User user) => CustomScrollView(
    slivers: [
      SliverToBoxAdapter(child: _buildUserCard(user)),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        sliver: SliverList(
          delegate: SliverChildListDelegate([
            _buildFunctionTile(Icons.book, '我的课程'),
            _buildFunctionTile(Icons.favorite_border, '我的收藏'),
            _buildFunctionTile(Icons.account_balance_wallet, '积分中心'),
            _buildFunctionTile(Icons.health_and_safety, '健康档案',
                onTap: () => _navigateToHealthRecord(user.id)),
          ]),
        ),
      ),
    ],
  );

  Widget _buildUserCard(User user) => Container(
    margin: const EdgeInsets.all(16),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 6))],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF2B3D86), width: 2),
            image: DecorationImage(
              image: user.avatarUrl != null
                  ? NetworkImage(user.avatarUrl!)
                  : const AssetImage('assets/default_avatar.png') as ImageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.username, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF2B3D86))),
              const SizedBox(height: 8),
              _buildBadge('VIP ${user.constitutionType ?? '普通会员'}', Icons.stars),
              _buildBadge('${user.age ?? 0} 积分', Icons.workspace_premium),
            ],
          ),
        ),
        _buildEditButton(user),
      ],
    ),
  );

  Widget _buildBadge(String text, IconData icon) => Container(
    margin: const EdgeInsets.only(bottom: 6),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: const Color(0x1A2B3D86),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF2B3D86)),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 14, color: Color(0xFF2B3D86), fontWeight: FontWeight.w500)),
      ],
    ),
  );

  Widget _buildEditButton(User user) => InkWell(
    onTap: () => _navigateToEditProfile(context, user),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xE62B3D86),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          const Icon(Icons.edit, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          const Text('编辑资料', style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500)),
        ],
      ),
    ),
  );

  Widget _buildFunctionTile(IconData icon, String title, {VoidCallback? onTap}) => Card(
    margin: const EdgeInsets.only(bottom: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0x1A2B3D86),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: const Color(0xFF2B3D86)),
      ),
      title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[800])),
      trailing: Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey[500], size: 18),
      onTap: onTap,
    ),
  );

  void _navigateTo(Widget page) => Navigator.push(context, MaterialPageRoute(builder: (_) => page));

  void _navigateToHealthRecord(String userId) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => HealthRecordPage(userId: userId),
    ),
  );

  void _navigateToEditProfile(BuildContext context, User user) => Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (_, __, ___) => EditProfilePage(
        key: const ValueKey('EditProfilePage'),
        initialUser: user,
      ),
      transitionsBuilder: (context, animation, __, child) => FadeTransition(
        opacity: animation,
        child: child,
      ),
    ),
  );
}