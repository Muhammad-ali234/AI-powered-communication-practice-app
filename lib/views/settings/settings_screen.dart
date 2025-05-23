import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:communication_practice/controllers/settings_controller.dart';
import 'package:communication_practice/controllers/auth_controller.dart';
import 'package:communication_practice/utils/theme.dart';
import 'package:communication_practice/utils/responsive.dart';
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
    final responsive = ResponsiveUtil(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: responsive.fontSize(20),
          ),
        ),
      ),
      body: Consumer<SettingsController>(
        builder: (context, settings, _) {
          return ListView(
            padding: responsive.responsivePadding(vertical: 16),
            children: [
              // THEME CUSTOMIZATION
              _buildSectionHeader(context, 'Appearance', responsive),
              _buildThemeOptions(context, settings, responsive),
              const Divider(),
              
              // NOTIFICATION PREFERENCES
              _buildSectionHeader(context, 'Notifications', responsive),
              _buildSwitchListTile(
                context,
                'Practice Reminders',
                'Get daily reminders to practice',
                settings.practiceReminders,
                (value) => settings.togglePracticeReminders(value),
                Icons.alarm,
                responsive,
              ),
              _buildSwitchListTile(
                context,
                'New Feature Alerts',
                'Get notified about new app features',
                settings.newFeatureAlerts,
                (value) => settings.toggleNewFeatureAlerts(value),
                Icons.new_releases,
                responsive,
              ),
              _buildSwitchListTile(
                context,
                'Weekly Progress Reports',
                'Receive weekly summaries of your progress',
                settings.weeklyProgressReports,
                (value) => settings.toggleWeeklyProgressReports(value),
                Icons.summarize,
                responsive,
              ),
              const Divider(),
              
              // LANGUAGE SETTINGS
              _buildSectionHeader(context, 'Language', responsive),
              _buildLanguageSelector(context, settings, responsive),
              const Divider(),
              
              // DATA MANAGEMENT
              _buildSectionHeader(context, 'Data Management', responsive),
              _buildSwitchListTile(
                context,
                'Auto-save Conversations',
                'Automatically save your practice sessions',
                settings.autoSaveConversations,
                (value) => settings.toggleAutoSaveConversations(value),
                Icons.save,
                responsive,
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
                      return ListTile(
                        title: Text(
                          'Advanced Data Options',
                          style: TextStyle(
                            fontSize: responsive.fontSize(16),
                          ),
                        ),
                        subtitle: Text(
                          'Export or delete your data',
                          style: TextStyle(
                            fontSize: responsive.fontSize(14),
                          ),
                        ),
                        leading: Icon(
                          Icons.storage,
                          size: responsive.iconSize(24),
                        ),
                      );
                    },
                    body: Column(
                      children: [
                        _buildDataManagementTile(
                          context,
                          'Export Data',
                          'Download all your data as a file',
                          Icons.download,
                          _isExportingData,
                          () => _exportData(settings),
                          responsive,
                        ),
                        _buildDataManagementTile(
                          context,
                          'Delete All Data',
                          'Permanently delete all your data',
                          Icons.delete_forever,
                          _isDeletingData,
                          () => _confirmDataDeletion(context, settings),
                          responsive,
                          isDestructive: true,
                        ),
                      ],
                    ),
                    isExpanded: _isDataManagementExpanded,
                  ),
                ],
              ),
              const Divider(),
              
              // PRIVACY SETTINGS
              _buildSectionHeader(context, 'Privacy', responsive),
              _buildSwitchListTile(
                context,
                'Analytics',
                'Allow anonymous usage data collection to improve the app',
                settings.analyticsEnabled,
                (value) => settings.toggleAnalytics(value),
                Icons.analytics,
                responsive,
              ),
              _buildSwitchListTile(
                context,
                'Personalized Content',
                'Receive content tailored to your practice habits',
                settings.personalizedContent,
                (value) => settings.togglePersonalizedContent(value),
                Icons.person,
                responsive,
              ),
              _buildListTile(
                context,
                'Privacy Policy',
                'Read our privacy policy',
                Icons.policy,
                () => _launchURL('https://example.com/privacy'),
                responsive,
              ),
              const Divider(),
              
              // ABOUT SECTION
              _buildSectionHeader(context, 'About', responsive),
              _buildListTile(
                context,
                'Version',
                settings.appVersion,
                Icons.info,
                null,
                responsive,
              ),
              _buildListTile(
                context,
                'Terms of Service',
                null,
                Icons.description,
                () => _launchURL('https://example.com/terms'),
                responsive,
              ),
              _buildListTile(
                context,
                'Rate App',
                null,
                Icons.star,
                () => _launchURL('https://play.google.com/store/apps'),
                responsive,
              ),
              _buildListTile(
                context,
                'Share App',
                null,
                Icons.share,
                _shareApp,
                responsive,
              ),
              Consumer<AuthController>(
                builder: (context, auth, _) {
                  return _buildListTile(
                    context,
                    'Sign Out',
                    null,
                    Icons.logout,
                    () => _confirmSignOut(context, auth),
                    responsive,
                    isDestructive: true,
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
  
  Widget _buildSectionHeader(BuildContext context, String title, ResponsiveUtil responsive) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        responsive.md,
        responsive.md,
        responsive.md,
        responsive.sm,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: responsive.fontSize(Theme.of(context).textTheme.titleMedium?.fontSize ?? 16),
        ),
      ),
    );
  }
  
  Widget _buildThemeOptions(BuildContext context, SettingsController settings, ResponsiveUtil responsive) {
    return Column(
      children: [
        _buildRadioListTile(
          context,
          'System Theme',
          'Follow system settings',
          ThemeMode.system,
          settings.themeMode,
          (value) => settings.setThemeMode(value!),
          Icons.brightness_auto,
          responsive,
        ),
        _buildRadioListTile(
          context,
          'Light Theme',
          'Always use light mode',
          ThemeMode.light,
          settings.themeMode,
          (value) => settings.setThemeMode(value!),
          Icons.brightness_5,
          responsive,
        ),
        _buildRadioListTile(
          context,
          'Dark Theme',
          'Always use dark mode',
          ThemeMode.dark,
          settings.themeMode,
          (value) => settings.setThemeMode(value!),
          Icons.brightness_4,
          responsive,
        ),
      ],
    );
  }
  
  Widget _buildLanguageSelector(BuildContext context, SettingsController settings, ResponsiveUtil responsive) {
    return ListTile(
      title: Text(
        'Language',
        style: TextStyle(
          fontSize: responsive.fontSize(16),
        ),
      ),
      subtitle: Text(
        settings.languageName,
        style: TextStyle(
          fontSize: responsive.fontSize(14),
        ),
      ),
      leading: Icon(
        Icons.language,
        size: responsive.iconSize(24),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: responsive.iconSize(16),
      ),
      onTap: () => _showLanguageSelectionDialog(context, settings),
    );
  }
  
  Widget _buildSwitchListTile(
    BuildContext context,
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
    IconData icon,
    ResponsiveUtil responsive, {
    bool isDestructive = false,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: responsive.fontSize(16),
          color: isDestructive ? AppColors.error : null,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: responsive.fontSize(14),
        ),
      ),
      value: value,
      onChanged: onChanged,
      secondary: Icon(
        icon,
        size: responsive.iconSize(24),
        color: isDestructive ? AppColors.error : null,
      ),
    );
  }
  
  Widget _buildRadioListTile(
    BuildContext context,
    String title,
    String subtitle,
    ThemeMode value,
    ThemeMode groupValue,
    Function(ThemeMode?) onChanged,
    IconData icon,
    ResponsiveUtil responsive,
  ) {
    return RadioListTile<ThemeMode>(
      title: Text(
        title,
        style: TextStyle(
          fontSize: responsive.fontSize(16),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: responsive.fontSize(14),
        ),
      ),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      secondary: Icon(
        icon,
        size: responsive.iconSize(24),
      ),
    );
  }
  
  Widget _buildListTile(
    BuildContext context,
    String title,
    String? subtitle,
    IconData icon,
    VoidCallback? onTap,
    ResponsiveUtil responsive, {
    bool isDestructive = false,
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: responsive.fontSize(16),
          color: isDestructive ? AppColors.error : null,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                fontSize: responsive.fontSize(14),
              ),
            )
          : null,
      leading: Icon(
        icon,
        size: responsive.iconSize(24),
        color: isDestructive ? AppColors.error : null,
      ),
      trailing: onTap != null
          ? Icon(
              Icons.arrow_forward_ios,
              size: responsive.iconSize(16),
            )
          : null,
      onTap: onTap,
    );
  }
  
  Widget _buildDataManagementTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    bool isLoading,
    VoidCallback onTap,
    ResponsiveUtil responsive, {
    bool isDestructive = false,
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: responsive.fontSize(16),
          color: isDestructive ? AppColors.error : null,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: responsive.fontSize(14),
        ),
      ),
      leading: Icon(
        icon,
        size: responsive.iconSize(24),
        color: isDestructive ? AppColors.error : null,
      ),
      trailing: isLoading
          ? SizedBox(
              width: responsive.iconSize(20),
              height: responsive.iconSize(20),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isDestructive ? AppColors.error : Theme.of(context).primaryColor,
                ),
              ),
            )
          : Icon(
              Icons.arrow_forward_ios,
              size: responsive.iconSize(16),
            ),
      onTap: isLoading ? null : onTap,
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