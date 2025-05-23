import 'package:flutter/material.dart';
import 'package:communication_practice/views/splash_screen.dart';
import 'package:communication_practice/views/onboarding/onboarding_screen.dart';
import 'package:communication_practice/views/auth/login_screen.dart';
import 'package:communication_practice/views/auth/signup_screen.dart';
import 'package:communication_practice/views/auth/forgot_password_screen.dart';
import 'package:communication_practice/views/home/home_screen.dart';
import 'package:communication_practice/views/category/category_detail_screen.dart';
import 'package:communication_practice/views/chat/chat_screen.dart';
import 'package:communication_practice/views/history/conversation_history_screen.dart';
import 'package:communication_practice/views/profile/profile_screen.dart';
import 'package:communication_practice/views/settings/settings_screen.dart';
import 'package:communication_practice/views/main_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String main = '/main';
  static const String home = '/home';
  static const String categoryDetail = '/category-detail';
  static const String chat = '/chat';
  static const String conversationHistory = '/conversation-history';
  static const String profile = '/profile';
  static const String settings = '/settings';
  
  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashScreen(),
    onboarding: (context) => const OnboardingScreen(),
    login: (context) => const LoginScreen(),
    signup: (context) => const SignupScreen(),
    forgotPassword: (context) => const ForgotPasswordScreen(),
    main: (context) => const MainScreen(),
    categoryDetail: (context) => const CategoryDetailScreen(),
    chat: (context) => const ChatScreen(),
    conversationHistory: (context) => const ConversationHistoryScreen(),
    profile: (context) => const ProfileScreen(),
    settings: (context) => const SettingsScreen(),
  };
}