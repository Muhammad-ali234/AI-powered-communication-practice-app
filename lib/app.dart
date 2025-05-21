import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:communication_practice/controllers/settings_controller.dart';
import 'package:communication_practice/utils/theme.dart';
import 'package:communication_practice/utils/routes.dart';

class CommunicationPracticeApp extends StatelessWidget {
  const CommunicationPracticeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsController>(
      builder: (context, settings, child) {
    return MaterialApp(
      title: 'Communication Practice',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
          themeMode: settings.themeMode,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
        );
      },
    );
  }
}