import 'package:flutter/material.dart';
import 'package:communication_practice/utils/routes.dart';
import 'package:communication_practice/views/onboarding/onboarding_page.dart';
import 'package:communication_practice/widgets/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  final List<OnboardingPageData> _pages = [
    OnboardingPageData(
      title: 'Practice Communication',
      description: 'Improve your communication skills through interactive conversations with our AI assistant.',
      image: 'assets/images/onboarding_1.png',
      icon: Icons.forum_rounded,
    ),
    OnboardingPageData(
      title: 'Various Scenarios',
      description: 'Choose from 20+ categories like job interviews, public speaking, and social situations.',
      image: 'assets/images/onboarding_2.png',
      icon: Icons.category_rounded,
    ),
    OnboardingPageData(
      title: 'Track Your Progress',
      description: 'Get feedback on your conversations and track your improvements over time.',
      image: 'assets/images/onboarding_3.png',
      icon: Icons.insights_rounded,
    ),
    OnboardingPageData(
      title: 'Ready to Start?',
      description: 'Create an account to save your progress and access all features.',
      image: 'assets/images/onboarding_4.png',
      icon: Icons.rocket_launch_rounded,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _onFinishOnboarding();
    }
  }

  void _onPreviousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _onFinishOnboarding() {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_pages.length, (index) {
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.withOpacity(0.5),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: _onFinishOnboarding,
                  child: Text('Skip', style: Theme.of(context).textTheme.labelLarge),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(data: _pages[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  _buildPageIndicator(),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentPage > 0)
                        CustomButton(
                          onPressed: _onPreviousPage,
                          label: 'Back',
                          icon: Icons.arrow_back_rounded,
                          type: ButtonType.outline,
                        )
                      else
                        const SizedBox(width: 120),
                      CustomButton(
                        onPressed: _onNextPage,
                        label: _currentPage < _pages.length - 1 ? 'Next' : 'Get Started',
                        icon: _currentPage < _pages.length - 1
                            ? Icons.arrow_forward_rounded
                            : Icons.check_rounded,
                        showIconAfterLabel: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}