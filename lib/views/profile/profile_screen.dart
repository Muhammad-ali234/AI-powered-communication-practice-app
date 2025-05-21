import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:communication_practice/controllers/user_controller.dart';
import 'package:communication_practice/controllers/achievement_controller.dart';
import 'package:communication_practice/models/user_model.dart';
import 'package:communication_practice/utils/theme.dart';
import 'package:communication_practice/views/profile/components/stats_dashboard.dart';
import 'package:communication_practice/views/profile/components/achievements_tab.dart';
import 'package:communication_practice/views/profile/components/progress_charts.dart';
import 'package:communication_practice/views/profile/edit_profile_screen.dart';
import 'package:communication_practice/widgets/empty_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserController>(
        builder: (context, userController, child) {
          if (userController.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (userController.user == null) {
            return EmptyState(
              icon: Icons.person_off_outlined,
              title: 'Not Signed In',
              message: 'Please sign in to view your profile',
              action: ElevatedButton(
                onPressed: () {
                  // Navigate to sign in page in a real app
                },
                child: const Text('Sign In'),
              ),
            );
          }
          
          final user = userController.user!;
          
          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                _buildAppBar(context, user),
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      controller: _tabController,
                      labelColor: AppColors.primary,
                      unselectedLabelColor: Theme.of(context).brightness == Brightness.light
                          ? AppColors.textSecondary
                          : AppColors.darkTextSecondary,
                      indicatorColor: AppColors.primary,
                      tabs: const [
                        Tab(text: 'STATS'),
                        Tab(text: 'ACHIEVEMENTS'),
                        Tab(text: 'PROGRESS'),
                      ],
                    ),
                  ),
                  pinned: true,
                ),
              ];
            },
                          body: TabBarView(
                controller: _tabController,
                children: const [
                  StatsDashboard(),
                  AchievementsTab(),
                  ProgressCharts(),
                ],
              ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _shareProfile(context),
        backgroundColor: AppColors.secondary,
        child: const Icon(Icons.share_outlined),
      ),
    );
  }
  
  SliverAppBar _buildAppBar(BuildContext context, UserModel user) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    backgroundImage: user.photoUrl.isNotEmpty
                        ? NetworkImage(user.photoUrl) as ImageProvider
                        : const AssetImage('assets/images/default_avatar.png'),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    user.bio.isNotEmpty ? user.bio : 'No bio added yet',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_outlined),
          onPressed: () => _navigateToEditProfile(context),
        ),
      ],
    );
  }
  
  void _navigateToEditProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditProfileScreen(),
      ),
    );
  }
  
  void _shareProfile(BuildContext context) {
    final user = Provider.of<UserController>(context, listen: false).user;
    if (user == null) return;
    
    final stats = [
      'Conversations: ${user.conversationsCompleted}',
      'Streak: ${user.streak} days',
      'Average Score: ${user.averageScore.toStringAsFixed(1)}/5.0',
    ].join('\n');
    
    final shareText = 'Check out my progress in Communication Practice!\n\n'
        'Name: ${user.name}\n'
        '$stats\n\n'
        'Download the app to improve your communication skills too!';
    
    // In a real app, implement platform-specific sharing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile shared!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  
  _SliverAppBarDelegate(this._tabBar);
  
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }
  
  @override
  double get maxExtent => _tabBar.preferredSize.height;
  
  @override
  double get minExtent => _tabBar.preferredSize.height;
  
  @override
  bool shouldRebuild(covariant _SliverAppBarDelegate oldDelegate) {
    return false;
  }
} 