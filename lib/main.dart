import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:communication_practice/app.dart';
import 'package:communication_practice/controllers/auth_controller.dart';
import 'package:communication_practice/controllers/achievement_controller.dart';
import 'package:communication_practice/controllers/category_controller.dart';
import 'package:communication_practice/controllers/chat_controller.dart';
import 'package:communication_practice/controllers/settings_controller.dart';
import 'package:communication_practice/controllers/user_controller.dart';
import 'package:communication_practice/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => UserController()),
        ChangeNotifierProvider(create: (_) => CategoryController()),
        ChangeNotifierProvider(create: (_) => ChatController()),
        ChangeNotifierProvider(create: (_) => AchievementController()),
        ChangeNotifierProvider(create: (_) => SettingsController()),
      ],
      child: const CommunicationPracticeApp(),
    ),
  );
}