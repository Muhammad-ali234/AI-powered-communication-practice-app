import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:communication_practice/controllers/auth_controller.dart';
import 'package:communication_practice/utils/theme.dart';
import 'package:communication_practice/widgets/custom_button.dart';
import 'package:communication_practice/widgets/custom_textfield.dart';
import 'package:communication_practice/utils/responsive.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isEmailSent = false;
  
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
  
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }
  
  Future<void> _sendResetEmail() async {
    if (!_formKey.currentState!.validate()) return;
    
    final authController = Provider.of<AuthController>(context, listen: false);
    final email = _emailController.text.trim();
    
    final success = await authController.forgotPassword(email);
    
    if (success && mounted) {
      setState(() {
        _isEmailSent = true;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    final responsive = ResponsiveUtil(context);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: responsive.iconSize(24)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: responsive.responsivePadding(all: 24),
            child: _isEmailSent
                ? _buildSuccessView(context)
                : _buildResetForm(context, authController),
          ),
        ),
      ),
    );
  }
  
  Widget _buildResetForm(BuildContext context, AuthController authController) {
    final responsive = ResponsiveUtil(context);
    
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Icon(
            Icons.lock_reset_rounded,
            size: responsive.iconSize(64),
            color: AppColors.primary,
          ),
          SizedBox(height: responsive.lg),
          Text(
            'Forgot Password',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontSize: responsive.fontSize(Theme.of(context).textTheme.displaySmall?.fontSize ?? 32),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: responsive.xs),
          Text(
            'Enter your email and we\'ll send you instructions to reset your password',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: AppColors.textSecondary,
              fontSize: responsive.fontSize(Theme.of(context).textTheme.bodyLarge?.fontSize ?? 16),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: responsive.xl),
          
          // Error message
          if (authController.error != null) ...[
            Container(
              padding: responsive.responsivePadding(all: 16),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(responsive.md),
              ),
              child: Text(
                authController.error!,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: AppColors.error,
                  fontSize: responsive.fontSize(Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: responsive.md),
          ],
          
          // Email input
          CustomTextField(
            controller: _emailController,
            label: 'Email',
            hint: 'Enter your email',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            validator: _validateEmail,
          ),
          SizedBox(height: responsive.lg),
          
          // Send button
          CustomButton(
            onPressed: _sendResetEmail,
            label: 'Send Reset Link',
            isLoading: authController.isLoading,
          ),
          SizedBox(height: responsive.md),
          
          // Back to login
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Back to Login',
              style: TextStyle(
                fontSize: responsive.fontSize(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSuccessView(BuildContext context) {
    final responsive = ResponsiveUtil(context);
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Success icon
        Icon(
          Icons.check_circle_outline_rounded,
          size: responsive.iconSize(80),
          color: AppColors.success,
        ),
        SizedBox(height: responsive.lg),
        Text(
          'Email Sent',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontSize: responsive.fontSize(Theme.of(context).textTheme.displaySmall?.fontSize ?? 32),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: responsive.md),
        Text(
          'We\'ve sent password reset instructions to ${_emailController.text}',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: AppColors.textSecondary,
            fontSize: responsive.fontSize(Theme.of(context).textTheme.bodyLarge?.fontSize ?? 16),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: responsive.xl),
        CustomButton(
          onPressed: () {
            Navigator.pop(context);
          },
          label: 'Back to Login',
        ),
        SizedBox(height: responsive.md),
        TextButton(
          onPressed: () {
            setState(() {
              _isEmailSent = false;
            });
          },
          child: Text(
            'Try another email',
            style: TextStyle(
              fontSize: responsive.fontSize(14),
            ),
          ),
        ),
      ],
    );
  }
}