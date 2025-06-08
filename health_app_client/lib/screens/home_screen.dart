import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as cs;

class AppColors {
  static const primaryColor = Color(0xFF1A2835);
  static const secondaryColor = Color(0xFF6CE8DA);
  static const accentColor = Color(0xFF6367F2);
  static const textPrimary = Color(0xFFF0F4F8);
  static const textSecondary = Color(0xFFC7D4E0);
  static const backgroundColor = Color(0xFF0E1A26);
  static const cardBackground = Color(0xFF243342);
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin { // 修正混合类
  final List<Map<String, dynamic>> _features = [
    {'icon': Icons.health_and_safety, 'label': 'AI面诊'},
    {'icon': Icons.language, 'label': 'AI舌诊'},
    {'icon': Icons.chat, 'label': 'AI问诊'},
    {'icon': Icons.favorite, 'label': 'AI脉诊'},
    {'icon': Icons.assignment_ind, 'label': '体质检测'},
    {'icon': Icons.contact_support, 'label': '线上问诊'},
    {'icon': Icons.health_and_safety, 'label': '健康档案'},
    {'icon': Icons.more_horiz, 'label': '更多功能'},
  ];
  int _selectedTabIndex = 0;
  int _currentBannerIndex = 0;
  late TabController _tabController;
  late AnimationController _bannerAnimationController;
  late AnimationController _featuresAnimationController;
  late AnimationController _contentAnimationController;
  late FocusNode _searchFocusNode;
  final List<AnimationController> _iconScaleControllers = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _searchFocusNode = FocusNode();

    _bannerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();

    _featuresAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _contentAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    for (var i = 0; i < _features.length; i++) {
      _iconScaleControllers.add(
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 100),
        ),
      );
    }
  }

  @override
  void dispose() {
    _bannerAnimationController.dispose();
    _featuresAnimationController.dispose();
    _contentAnimationController.dispose();
    _searchFocusNode.dispose();
    for (var controller in _iconScaleControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: _buildSearchBar(),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildNavBar(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildAnimatedBanner(),
          const Divider(height: 24, color: Color(0xFF2A3B4D)),
          _buildAnimatedFeatures(),
          const SizedBox(height: 24),
          _buildAnimatedContent(),
        ],
      ),
    );
  }

  Widget _buildAnimatedBanner() {
    return AnimatedBuilder(
      animation: _bannerAnimationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - _bannerAnimationController.value)),
          child: Opacity(
            opacity: _bannerAnimationController.value,
            child: child,
          ),
        );
      },
      child: _buildBannerSection(),
    );
  }

  Widget _buildBannerSection() {
    return Column(
      children: [
        Container(
          height: 188,
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: cs.CarouselSlider(
            items: [1, 2, 3].map((i) => _buildBannerItem(i)).toList(),
            options: cs.CarouselOptions(
              viewportFraction: 1.0,
              padEnds: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 5),
              enableInfiniteScroll: false,
              height: 188,
              onPageChanged: (index, reason) {
                setState(() => _currentBannerIndex = index);
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) => _buildIndicator(index)),
        )
      ],
    );
  }

  Widget _buildIndicator(int index) {
    return Container(
      width: _currentBannerIndex == index ? 8 : 4,
      height: _currentBannerIndex == index ? 8 : 4,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentBannerIndex == index ? AppColors.accentColor : AppColors.textSecondary.withAlpha(60),
        border: _currentBannerIndex == index ? Border.all(color: AppColors.accentColor, width: 2) : null,
      ),
    );
  }

  Widget _buildBannerItem(int index) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: const DecorationImage(
              image: AssetImage('assets/banners/banner_1.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('名老中医经验分享',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text('传承千年中医智慧',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeatureItem(Map<String, dynamic> item, int index) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTapDown: (_) => _iconScaleControllers[index].forward(),
        onTapUp: (_) => _iconScaleControllers[index].reverse(),
        onTapCancel: () => _iconScaleControllers[index].reverse(),
        child: AnimatedBuilder(
          animation: _iconScaleControllers[index],
          builder: (context, child) {
            return Transform.scale(
              scale: 1 - _iconScaleControllers[index].value * 0.1,
              child: child,
            );
          },
          child: Container(
            width: 56,
            height: 56,
            padding: const EdgeInsets.all(4),
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.secondaryColor.withAlpha(30),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Icon(item['icon'],
                      color: AppColors.secondaryColor.withAlpha(230), size: 32),
                ),
                const SizedBox(height: 4),
                Text(item['label'],
                    style: TextStyle(color: AppColors.textPrimary, fontSize: 12),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text('特色功能',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w500)),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.9,
            ),
            itemCount: _features.length,
            itemBuilder: (context, index) => _buildFeatureItem(_features[index], index),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedFeatures() {
    return AnimatedBuilder(
      animation: _featuresAnimationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - _featuresAnimationController.value)),
          child: Opacity(
            opacity: _featuresAnimationController.value,
            child: child,
          ),
        );
      },
      child: _buildFeatureGrid(),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: _searchFocusNode.hasFocus
                    ? AppColors.secondaryColor
                    : AppColors.textSecondary.withAlpha(30),
                width: 1.5,
              ),
              gradient: LinearGradient(
                colors: _searchFocusNode.hasFocus
                    ? [AppColors.secondaryColor.withAlpha(50), Colors.transparent]
                    : [AppColors.secondaryColor.withAlpha(10), Colors.transparent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Icon(Icons.search, color: AppColors.textSecondary),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    focusNode: _searchFocusNode,
                    style: TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration.collapsed(
                      hintText: '搜索 体质辨识/药膳/穴位',
                      hintStyle: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        _buildVipBadge(),
      ],
    );
  }

  Widget _buildVipBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.accentColor, AppColors.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(Icons.diamond, color: Colors.white, size: 18),
          SizedBox(width: 6),
          Text('铂金会员', style: TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildAnimatedContent() {
    return AnimatedBuilder(
      animation: _contentAnimationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - _contentAnimationController.value)),
          child: Opacity(
            opacity: _contentAnimationController.value,
            child: child,
          ),
        );
      },
      child: _buildContentSection(),
    );
  }

  Widget _buildContentSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildSectionTitle("精选内容"),
          TabBar(
            controller: _tabController,
            indicatorColor: AppColors.secondaryColor,
            labelColor: AppColors.textPrimary,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: const [
              Tab(text: '视频课程'),
              Tab(text: '专家讲座'),
              Tab(text: '养生文章'),
            ],
            onTap: (index) => setState(() => _selectedTabIndex = index),
          ),
          IndexedStack(
            index: _selectedTabIndex,
            children: [
              _buildVideoCourses(),
              _buildLectures(),
              _buildArticles(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Text(title,
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600)),
          const Spacer(),
          TextButton(
            onPressed: () {},
            child: Text('更多',
                style: TextStyle(
                    color: AppColors.secondaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
          )
        ],
      ),
    );
  }

  Widget _buildVideoCourses() {
    return Column(
      children: [
        _buildCourseCard(),
        const SizedBox(height: 16),
        _buildCourseCard(),
      ],
    );
  }

  Widget _buildCourseCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withAlpha((0.3 * 255).toInt()),
            blurRadius: 20,
            spreadRadius: 1,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('中医体质辨识与调理',
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.person, color: AppColors.secondaryColor, size: 16),
              const SizedBox(width: 6),
              Text('张教授',
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 14)),
              const Spacer(),
              Icon(Icons.access_time, color: AppColors.secondaryColor, size: 16),
              const SizedBox(width: 6),
              Text('18:25',
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: AssetImage('assets/courses/course_1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLectures() {
    return Column(
      children: [
        _buildLectureCard(),
        const SizedBox(height: 16),
        _buildLectureCard(),
      ],
    );
  }

  Widget _buildLectureCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withAlpha((0.3 * 255).toInt()),
            blurRadius: 20,
            spreadRadius: 1,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('中医养生大讲堂',
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.school, color: AppColors.secondaryColor, size: 16),
              const SizedBox(width: 6),
              Text('李教授',
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 14)),
              const Spacer(),
              Text('45分钟',
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildArticles() {
    return Column(
      children: [
        _buildArticleCard(),
        const SizedBox(height: 16),
        _buildArticleCard(),
      ],
    );
  }

  Widget _buildArticleCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('四季养生指南',
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.visibility, color: AppColors.textSecondary, size: 14),
              const SizedBox(width: 4),
              Text('1.2万浏览',
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 12)),
              const SizedBox(width: 12),
              Icon(Icons.favorite_border, color: AppColors.textSecondary, size: 14),
              const SizedBox(width: 4),
              Text('856点赞',
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.2 * 255).toInt()),
            blurRadius: 16,
            offset: const Offset(0, -4),
          )
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        selectedItemColor: AppColors.secondaryColor,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(icon: Icon(Icons.science), label: 'AI体验'),
          BottomNavigationBarItem(icon: Icon(Icons.recommend), label: '智能推介'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: '药膳商城'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
        ],
      ),
    );
  }
}