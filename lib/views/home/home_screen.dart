// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:communication_practice/controllers/auth_controller.dart';
// import 'package:communication_practice/controllers/category_controller.dart';
// import 'package:communication_practice/models/category_model.dart';
// import 'package:communication_practice/utils/theme.dart';
// import 'package:communication_practice/views/home/category_card.dart';
// import 'package:communication_practice/views/home/quick_action_card.dart';
// import 'package:communication_practice/widgets/custom_search_bar.dart';
// import 'package:communication_practice/widgets/loading_indicator.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   String _searchQuery = '';
//   CategoryDifficulty? _selectedFilter;
  
//   @override
//   void initState() {
//     super.initState();
    
//     // Fetch categories if not already loaded
//     final categoryController = Provider.of<CategoryController>(context, listen: false);
//     if (categoryController.categories.isEmpty) {
//       categoryController.fetchCategories();
//     }
//   }
  
//   void _onSearchChanged(String query) {
//     setState(() {
//       _searchQuery = query;
//     });
//   }
  
//   void _onFilterSelected(CategoryDifficulty? difficulty) {
//     setState(() {
//       if (_selectedFilter == difficulty) {
//         _selectedFilter = null; // Toggle off if already selected
//       } else {
//         _selectedFilter = difficulty;
//       }
//     });
//   }
  
//   List<CategoryModel> _getFilteredCategories(List<CategoryModel> categories) {
//     if (_searchQuery.isEmpty && _selectedFilter == null) {
//       return categories;
//     }
    
//     return categories.where((category) {
//       // Apply search filter
//       final matchesSearch = _searchQuery.isEmpty || 
//                            category.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
//                            category.description.toLowerCase().contains(_searchQuery.toLowerCase());
      
//       // Apply difficulty filter
//       final matchesDifficulty = _selectedFilter == null || category.difficulty == _selectedFilter;
      
//       return matchesSearch && matchesDifficulty;
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authController = Provider.of<AuthController>(context);
//     final categoryController = Provider.of<CategoryController>(context);
    
//     final filteredCategories = _getFilteredCategories(categoryController.categories);
    
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header
//             Padding(
//               padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Hello, ${authController.currentUser?.name.split(' ').first ?? 'there'}!',
//                         style: Theme.of(context).textTheme.headlineMedium,
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         'What would you like to practice today?',
//                         style: Theme.of(context).textTheme.bodyLarge!.copyWith(
//                           color: AppColors.textSecondary,
//                         ),
//                       ),
//                     ],
//                   ),
//                   CircleAvatar(
//                     radius: 24,
//                     backgroundColor: AppColors.primary,
//                     backgroundImage: NetworkImage(
//                       authController.currentUser?.photoUrl ?? 'https://randomuser.me/api/portraits/men/32.jpg',
//                     ),
//                   ),
//                 ],
//               ),
//             ),
            
//             // Search bar
//             Padding(
//               padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
//               child: CustomSearchBar(
//                 onChanged: _onSearchChanged,
//                 hint: 'Search categories...',
//               ),
//             ),
            
//             // Filter chips
//             SizedBox(
//               height: 48,
//               child: ListView(
//                 scrollDirection: Axis.horizontal,
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 children: [
//                   const SizedBox(width: 8),
//                   FilterChip(
//                     label: const Text('Beginner'),
//                     selected: _selectedFilter == CategoryDifficulty.beginner,
//                     onSelected: (_) => _onFilterSelected(CategoryDifficulty.beginner),
//                     backgroundColor: Colors.white,
//                     selectedColor: Colors.green.withOpacity(0.2),
//                     checkmarkColor: Colors.green,
//                     labelStyle: TextStyle(
//                       color: _selectedFilter == CategoryDifficulty.beginner
//                           ? Colors.green
//                           : AppColors.textPrimary,
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   FilterChip(
//                     label: const Text('Intermediate'),
//                     selected: _selectedFilter == CategoryDifficulty.intermediate,
//                     onSelected: (_) => _onFilterSelected(CategoryDifficulty.intermediate),
//                     backgroundColor: Colors.white,
//                     selectedColor: Colors.blue.withOpacity(0.2),
//                     checkmarkColor: Colors.blue,
//                     labelStyle: TextStyle(
//                       color: _selectedFilter == CategoryDifficulty.intermediate
//                           ? Colors.blue
//                           : AppColors.textPrimary,
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   FilterChip(
//                     label: const Text('Advanced'),
//                     selected: _selectedFilter == CategoryDifficulty.advanced,
//                     onSelected: (_) => _onFilterSelected(CategoryDifficulty.advanced),
//                     backgroundColor: Colors.white,
//                     selectedColor: Colors.orange.withOpacity(0.2),
//                     checkmarkColor: Colors.orange,
//                     labelStyle: TextStyle(
//                       color: _selectedFilter == CategoryDifficulty.advanced
//                           ? Colors.orange
//                           : AppColors.textPrimary,
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   FilterChip(
//                     label: const Text('Expert'),
//                     selected: _selectedFilter == CategoryDifficulty.expert,
//                     onSelected: (_) => _onFilterSelected(CategoryDifficulty.expert),
//                     backgroundColor: Colors.white,
//                     selectedColor: Colors.red.withOpacity(0.2),
//                     checkmarkColor: Colors.red,
//                     labelStyle: TextStyle(
//                       color: _selectedFilter == CategoryDifficulty.expert
//                           ? Colors.red
//                           : AppColors.textPrimary,
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                 ],
//               ),
//             ),
            
//             // Quick actions
//             Padding(
//               padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
//               child: Text(
//                 'Quick Actions',
//                 style: Theme.of(context).textTheme.titleLarge,
//               ),
//             ),
//             SizedBox(
//               height: 120,
//               child: ListView(
//                 scrollDirection: Axis.horizontal,
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 children: const [
//                   QuickActionCard(
//                     title: 'Random Practice',
//                     description: 'Start a practice session with a random topic',
//                     icon: Icons.shuffle_rounded,
//                     color: Color(0xFF3563E9),
//                   ),
//                   QuickActionCard(
//                     title: 'Resume Latest',
//                     description: 'Continue where you left off',
//                     icon: Icons.play_arrow_rounded,
//                     color: Color(0xFF8C62EC),
//                   ),
//                   QuickActionCard(
//                     title: 'Daily Challenge',
//                     description: 'Complete today\'s challenge',
//                     icon: Icons.emoji_events_rounded,
//                     color: Color(0xFFFFA500),
//                   ),
//                 ],
//               ),
//             ),
            
//             // Categories label
//             Padding(
//               padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Categories',
//                     style: Theme.of(context).textTheme.titleLarge,
//                   ),
//                   if (filteredCategories.isNotEmpty)
//                     Text(
//                       '${filteredCategories.length} ${filteredCategories.length == 1 ? 'category' : 'categories'}',
//                       style: Theme.of(context).textTheme.bodyMedium,
//                     ),
//                 ],
//               ),
//             ),
            
//             // Categories grid
//             Expanded(
//               child: categoryController.isLoading
//                   ? const Center(child: LoadingIndicator())
//                   : categoryController.error != null
//                       ? Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Icon(
//                                 Icons.error_outline_rounded,
//                                 size: 48,
//                                 color: AppColors.error,
//                               ),
//                               const SizedBox(height: 16),
//                               Text(
//                                 'Failed to load categories',
//                                 style: Theme.of(context).textTheme.titleMedium,
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 categoryController.error!,
//                                 style: Theme.of(context).textTheme.bodyMedium,
//                                 textAlign: TextAlign.center,
//                               ),
//                             ],
//                           ),
//                         )
//                       : filteredCategories.isEmpty
//                           ? Center(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   const Icon(
//                                     Icons.search_off_rounded,
//                                     size: 48,
//                                     color: AppColors.textSecondary,
//                                   ),
//                                   const SizedBox(height: 16),
//                                   Text(
//                                     'No categories found',
//                                     style: Theme.of(context).textTheme.titleMedium,
//                                   ),
//                                   const SizedBox(height: 8),
//                                   Text(
//                                     'Try a different search term or filter',
//                                     style: Theme.of(context).textTheme.bodyMedium,
//                                   ),
//                                 ],
//                               ),
//                             )
//                           : GridView.builder(
//                               padding: const EdgeInsets.all(16),
//                               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: 2,
//                                 childAspectRatio: 0.9,
//                                 crossAxisSpacing: 16,
//                                 mainAxisSpacing: 16,
//                               ),
//                               itemCount: filteredCategories.length,
//                               itemBuilder: (context, index) {
//                                 return CategoryCard(
//                                   category: filteredCategories[index],
//                                 );
//                               },
//                             ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:communication_practice/controllers/auth_controller.dart';
import 'package:communication_practice/controllers/category_controller.dart';
import 'package:communication_practice/models/category_model.dart';
import 'package:communication_practice/utils/theme.dart';
import 'package:communication_practice/utils/responsive.dart';
import 'package:communication_practice/views/home/category_card.dart';
import 'package:communication_practice/views/home/quick_action_card.dart';
import 'package:communication_practice/widgets/custom_search_bar.dart';
import 'package:communication_practice/widgets/loading_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  CategoryDifficulty? _selectedFilter;
  
  @override
  void initState() {
    super.initState();
    
    // Fetch categories if not already loaded
    final categoryController = Provider.of<CategoryController>(context, listen: false);
    if (categoryController.categories.isEmpty) {
      categoryController.fetchCategories();
    }
  }
  
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }
  
  void _onFilterSelected(CategoryDifficulty? difficulty) {
    setState(() {
      if (_selectedFilter == difficulty) {
        _selectedFilter = null; // Toggle off if already selected
      } else {
        _selectedFilter = difficulty;
      }
    });
  }
  
  List<CategoryModel> _getFilteredCategories(List<CategoryModel> categories) {
    if (_searchQuery.isEmpty && _selectedFilter == null) {
      return categories;
    }
    
    return categories.where((category) {
      // Apply search filter
      final matchesSearch = _searchQuery.isEmpty || 
                           category.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                           category.description.toLowerCase().contains(_searchQuery.toLowerCase());
      
      // Apply difficulty filter
      final matchesDifficulty = _selectedFilter == null || category.difficulty == _selectedFilter;
      
      return matchesSearch && matchesDifficulty;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    final categoryController = Provider.of<CategoryController>(context);
    final responsive = ResponsiveUtil(context);
    
    final filteredCategories = _getFilteredCategories(categoryController.categories);
    
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(responsive.lg, responsive.md, responsive.lg, responsive.xs),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, ${authController.currentUser?.name.split(' ').first ?? 'there'}!',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: responsive.fontSize(Theme.of(context).textTheme.headlineMedium?.fontSize ?? 24),
                        ),
                      ),
                      SizedBox(height: responsive.xs),
                      Text(
                        'What would you like to practice today?',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: responsive.fontSize(Theme.of(context).textTheme.bodyLarge?.fontSize ?? 16),
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: responsive.iconSize(24),
                    backgroundColor: AppColors.primary,
                    backgroundImage: NetworkImage(
                      authController.currentUser?.photoUrl ?? 'https://randomuser.me/api/portraits/men/32.jpg',
                    ),
                  ),
                ],
              ),
            ),
            
            // Search bar
            Padding(
              padding: EdgeInsets.fromLTRB(responsive.lg, responsive.md, responsive.lg, responsive.xs),
              child: CustomSearchBar(
                onChanged: _onSearchChanged,
                hint: 'Search categories...',
              ),
            ),
            
            // Filter chips
            SizedBox(
              height: responsive.isSmallScreen ? 40 : 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: responsive.md),
                children: [
                  SizedBox(width: responsive.xs),
                  FilterChip(
                    label: Text(
                      'Beginner',
                      style: TextStyle(
                        fontSize: responsive.fontSize(14),
                        color: _selectedFilter == CategoryDifficulty.beginner
                            ? Colors.green
                            : AppColors.textPrimary,
                      ),
                    ),
                    selected: _selectedFilter == CategoryDifficulty.beginner,
                    onSelected: (_) => _onFilterSelected(CategoryDifficulty.beginner),
                    backgroundColor: Colors.white,
                    selectedColor: Colors.green.withOpacity(0.2),
                    checkmarkColor: Colors.green,
                    padding: responsive.responsivePadding(horizontal: 8, vertical: 2),
                  ),
                  SizedBox(width: responsive.xs),
                  FilterChip(
                    label: Text(
                      'Intermediate',
                      style: TextStyle(
                        fontSize: responsive.fontSize(14),
                        color: _selectedFilter == CategoryDifficulty.intermediate
                            ? Colors.blue
                            : AppColors.textPrimary,
                      ),
                    ),
                    selected: _selectedFilter == CategoryDifficulty.intermediate,
                    onSelected: (_) => _onFilterSelected(CategoryDifficulty.intermediate),
                    backgroundColor: Colors.white,
                    selectedColor: Colors.blue.withOpacity(0.2),
                    checkmarkColor: Colors.blue,
                    padding: responsive.responsivePadding(horizontal: 8, vertical: 2),
                  ),
                  SizedBox(width: responsive.xs),
                  FilterChip(
                    label: Text(
                      'Advanced',
                      style: TextStyle(
                        fontSize: responsive.fontSize(14),
                        color: _selectedFilter == CategoryDifficulty.advanced
                            ? Colors.orange
                            : AppColors.textPrimary,
                      ),
                    ),
                    selected: _selectedFilter == CategoryDifficulty.advanced,
                    onSelected: (_) => _onFilterSelected(CategoryDifficulty.advanced),
                    backgroundColor: Colors.white,
                    selectedColor: Colors.orange.withOpacity(0.2),
                    checkmarkColor: Colors.orange,
                    padding: responsive.responsivePadding(horizontal: 8, vertical: 2),
                  ),
                  SizedBox(width: responsive.xs),
                  FilterChip(
                    label: Text(
                      'Expert',
                      style: TextStyle(
                        fontSize: responsive.fontSize(14),
                        color: _selectedFilter == CategoryDifficulty.expert
                            ? Colors.red
                            : AppColors.textPrimary,
                      ),
                    ),
                    selected: _selectedFilter == CategoryDifficulty.expert,
                    onSelected: (_) => _onFilterSelected(CategoryDifficulty.expert),
                    backgroundColor: Colors.white,
                    selectedColor: Colors.red.withOpacity(0.2),
                    checkmarkColor: Colors.red,
                    padding: responsive.responsivePadding(horizontal: 8, vertical: 2),
                  ),
                  SizedBox(width: responsive.xs),
                ],
              ),
            ),
            
            // Quick actions
            Padding(
              padding: EdgeInsets.fromLTRB(responsive.lg, responsive.md, responsive.lg, responsive.xs),
              child: Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: responsive.fontSize(Theme.of(context).textTheme.titleLarge?.fontSize ?? 20),
                ),
              ),
            ),
            SizedBox(
              height: responsive.isSmallScreen ? 100 : 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: responsive.md),
                children: const [
                  QuickActionCard(
                    title: 'Random Practice',
                    description: 'Start a practice session with a random topic',
                    icon: Icons.shuffle_rounded,
                    color: Color(0xFF3563E9),
                  ),
                  QuickActionCard(
                    title: 'Resume Latest',
                    description: 'Continue where you left off',
                    icon: Icons.play_arrow_rounded,
                    color: Color(0xFF8C62EC),
                  ),
                  QuickActionCard(
                    title: 'Daily Challenge',
                    description: 'Complete today\'s challenge',
                    icon: Icons.emoji_events_rounded,
                    color: Color(0xFFFFA500),
                  ),
                ],
              ),
            ),
            
            // Categories label
            Padding(
              padding: EdgeInsets.fromLTRB(responsive.lg, responsive.md, responsive.lg, responsive.xs),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categories',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: responsive.fontSize(Theme.of(context).textTheme.titleLarge?.fontSize ?? 20),
                    ),
                  ),
                  if (filteredCategories.isNotEmpty)
                    Text(
                      '${filteredCategories.length} ${filteredCategories.length == 1 ? 'category' : 'categories'}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: responsive.fontSize(Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14),
                      ),
                    ),
                ],
              ),
            ),
            
            // Categories grid
            Expanded(
              child: categoryController.isLoading
                  ? const Center(child: LoadingIndicator())
                  : categoryController.error != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                                size: responsive.iconSize(48),
                                color: AppColors.error,
                              ),
                              SizedBox(height: responsive.md),
                              Text(
                                'Failed to load categories',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontSize: responsive.fontSize(Theme.of(context).textTheme.titleMedium?.fontSize ?? 16),
                                ),
                              ),
                              SizedBox(height: responsive.xs),
                              Text(
                                categoryController.error!,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: responsive.fontSize(Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : filteredCategories.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_off_rounded,
                                    size: responsive.iconSize(48),
                                    color: AppColors.textSecondary,
                                  ),
                                  SizedBox(height: responsive.md),
                                  Text(
                                    'No categories found',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontSize: responsive.fontSize(Theme.of(context).textTheme.titleMedium?.fontSize ?? 16),
                                    ),
                                  ),
                                  SizedBox(height: responsive.xs),
                                  Text(
                                    'Try a different search term or filter',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontSize: responsive.fontSize(Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : GridView.builder(
                              padding: EdgeInsets.all(responsive.md),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.9,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                              itemCount: filteredCategories.length,
                              itemBuilder: (context, index) {
                                return CategoryCard(
                                  category: filteredCategories[index],
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}