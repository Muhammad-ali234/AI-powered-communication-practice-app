import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:communication_practice/controllers/settings_controller.dart';
import 'package:communication_practice/controllers/auth_controller.dart';
import 'package:communication_practice/utils/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDataManagementExpanded = false;
  bool _isExportingData = false;
  bool _isDeletingData = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<SettingsController>(
        builder: (context, settings, _) {
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              // THEME CUSTOMIZATION
              _buildSectionHeader(context, 'Appearance'),
              _buildThemeOptions(context, settings),
              const Divider(),
              
              // NOTIFICATION PREFERENCES
              _buildSectionHeader(context, 'Notifications'),
              SwitchListTile(
                title: const Text('Practice Reminders'),
                subtitle: const Text('Get daily reminders to practice'),
                value: settings.practiceReminders,
                onChanged: (value) => settings.togglePracticeReminders(value),
                secondary: const Icon(Icons.alarm),
              ),
              SwitchListTile(
                title: const Text('New Feature Alerts'),
                subtitle: const Text('Get notified about new app features'),
                value: settings.newFeatureAlerts,
                onChanged: (value) => settings.toggleNewFeatureAlerts(value),
                secondary: const Icon(Icons.new_releases),
              ),
              SwitchListTile(
                title: const Text('Weekly Progress Reports'),
                subtitle: const Text('Receive weekly summaries of your progress'),
                value: settings.weeklyProgressReports,
                onChanged: (value) => settings.toggleWeeklyProgressReports(value),
                secondary: const Icon(Icons.summarize),
              ),
              const Divider(),
              
              // LANGUAGE SETTINGS
              _buildSectionHeader(context, 'Language'),
              _buildLanguageSelector(context, settings),
              const Divider(),
              
              // DATA MANAGEMENT
              _buildSectionHeader(context, 'Data Management'),
              SwitchListTile(
                title: const Text('Auto-save Conversations'),
                subtitle: const Text('Automatically save your practice sessions'),
                value: settings.autoSaveConversations,
                onChanged: (value) => settings.toggleAutoSaveConversations(value),
                secondary: const Icon(Icons.save),
              ),
              ExpansionPanelList(
                elevation: 0,
                expandedHeaderPadding: EdgeInsets.zero,
                expansionCallback: (index, isExpanded) {
                  setState(() {
                    _isDataManagementExpanded = !isExpanded;
                  });
                },
                children: [
                  ExpansionPanel(
                    headerBuilder: (context, isExpanded) {
                      return const ListTile(
                        title: Text('Advanced Data Options'),
                        subtitle: Text('Export or delete your data'),
                        leading: Icon(Icons.storage),
                      );
                    },
                    body: Column(
                      children: [
                        ListTile(
                          title: const Text('Export Data'),
                          subtitle: const Text('Download all your data as a file'),
                          leading: const Icon(Icons.download),
                          trailing: _isExportingData 
                              ? const SizedBox(
                                  width: 20, 
                                  height: 20, 
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: _isExportingData ? null : () => _exportData(settings),
                        ),
                        ListTile(
                          title: const Text('Delete All Data'),
                          subtitle: const Text('Permanently delete all your data'),
                          leading: const Icon(Icons.delete_forever, color: AppColors.error),
                          trailing: _isDeletingData 
                              ? const SizedBox(
                                  width: 20, 
                                  height: 20, 
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.arrow_forward_ios, size: 16),
                          textColor: AppColors.error,
                          onTap: _isDeletingData ? null : () => _confirmDataDeletion(context, settings),
                        ),
                      ],
                    ),
                    isExpanded: _isDataManagementExpanded,
                  ),
                ],
              ),
              const Divider(),
              
              // PRIVACY SETTINGS
              _buildSectionHeader(context, 'Privacy'),
              SwitchListTile(
                title: const Text('Analytics'),
                subtitle: const Text('Allow anonymous usage data collection to improve the app'),
                value: settings.analyticsEnabled,
                onChanged: (value) => settings.toggleAnalytics(value),
                secondary: const Icon(Icons.analytics),
              ),
              SwitchListTile(
                title: const Text('Personalized Content'),
                subtitle: const Text('Receive content tailored to your practice habits'),
                value: settings.personalizedContent,
                onChanged: (value) => settings.togglePersonalizedContent(value),
                secondary: const Icon(Icons.person),
              ),
              ListTile(
                title: const Text('Privacy Policy'),
                subtitle: const Text('Read our privacy policy'),
                leading: const Icon(Icons.policy),
                trailing: const Icon(Icons.open_in_new, size: 16),
                onTap: () => _launchURL('https://example.com/privacy'),
              ),
              const Divider(),
              
              // ABOUT SECTION
              _buildSectionHeader(context, 'About'),
              ListTile(
                title: const Text('Version'),
                subtitle: Text(settings.appVersion),
                leading: const Icon(Icons.info),
              ),
              ListTile(
                title: const Text('Terms of Service'),
                leading: const Icon(Icons.description),
                trailing: const Icon(Icons.open_in_new, size: 16),
                onTap: () => _launchURL('https://example.com/terms'),
              ),
              ListTile(
                title: const Text('Rate App'),
                leading: const Icon(Icons.star),
                trailing: const Icon(Icons.open_in_new, size: 16),
                onTap: () => _launchURL('https://play.google.com/store/apps'),
              ),
              ListTile(
                title: const Text('Share App'),
                leading: const Icon(Icons.share),
                onTap: _shareApp,
              ),
              Consumer<AuthController>(
                builder: (context, auth, _) {
                  return ListTile(
                    title: const Text('Sign Out', style: TextStyle(color: AppColors.error)),
                    leading: const Icon(Icons.logout, color: AppColors.error),
                    onTap: () => _confirmSignOut(context, auth),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
  
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  Widget _buildThemeOptions(BuildContext context, SettingsController settings) {
    return Column(
      children: [
        RadioListTile<ThemeMode>(
          title: const Text('System Theme'),
          subtitle: const Text('Follow system settings'),
          value: ThemeMode.system,
          groupValue: settings.themeMode,
          onChanged: (value) => settings.setThemeMode(value!),
          secondary: const Icon(Icons.brightness_auto),
        ),
        RadioListTile<ThemeMode>(
          title: const Text('Light Theme'),
          subtitle: const Text('Always use light mode'),
          value: ThemeMode.light,
          groupValue: settings.themeMode,
          onChanged: (value) => settings.setThemeMode(value!),
          secondary: const Icon(Icons.brightness_5),
        ),
        RadioListTile<ThemeMode>(
          title: const Text('Dark Theme'),
          subtitle: const Text('Always use dark mode'),
          value: ThemeMode.dark,
          groupValue: settings.themeMode,
          onChanged: (value) => settings.setThemeMode(value!),
          secondary: const Icon(Icons.brightness_4),
        ),
      ],
    );
  }
  
  Widget _buildLanguageSelector(BuildContext context, SettingsController settings) {
    return ListTile(
      title: const Text('Language'),
      subtitle: Text(settings.languageName),
      leading: const Icon(Icons.language),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _showLanguageSelectionDialog(context, settings),
    );
  }
  
  void _showLanguageSelectionDialog(BuildContext context, SettingsController settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: settings.supportedLanguages.length,
            itemBuilder: (context, index) {
              final language = settings.supportedLanguages[index];
              final isSelected = language['code'] == settings.languageCode;
              
              return ListTile(
                title: Text(language['name']!),
                trailing: isSelected ? const Icon(Icons.check, color: AppColors.primary) : null,
                onTap: () {
                  settings.setLanguage(language['code']!);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
  
  Future<void> _exportData(SettingsController settings) async {
    setState(() {
      _isExportingData = true;
    });
    
    try {
      await settings.exportData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data export successful'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() {
        _isExportingData = false;
      });
    }
  }
  
  void _confirmDataDeletion(BuildContext context, SettingsController settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Data?'),
        content: const Text(
          'This will permanently delete all your data including practice history, '
          'statistics, and settings. This action cannot be undone.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAllData(settings);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
  
  Future<void> _deleteAllData(SettingsController settings) async {
    setState(() {
      _isDeletingData = true;
    });
    
    try {
      await settings.deleteAllData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All data deleted successfully'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Deletion failed: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() {
        _isDeletingData = false;
      });
    }
  }
  
  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not launch URL'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
  
  void _shareApp() {
    SharePlus.instance.share(
      ShareParams(
        text: 'Check out Communication Practice app to improve your communication skills: '
            'https://example.com/app',
      ),
    );
  }
  
  void _confirmSignOut(BuildContext context, AuthController auth) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out?'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              auth.logout();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
} 