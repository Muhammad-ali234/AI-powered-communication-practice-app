import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:communication_practice/controllers/auth_controller.dart';
import 'package:communication_practice/utils/theme.dart';
import 'package:communication_practice/widgets/custom_button.dart';
import 'package:communication_practice/widgets/custom_textfield.dart';

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
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: _isEmailSent
                ? _buildSuccessView(context)
                : _buildResetForm(context, authController),
          ),
        ),
      ),
    );
  }
  
  Widget _buildResetForm(BuildContext context, AuthController authController) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          const Icon(
            Icons.lock_reset_rounded,
            size: 64,
            color: AppColors.primary,
          ),
          const SizedBox(height: 24),
          Text(
            'Forgot Password',
            style: Theme.of(context).textTheme.displaySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Enter your email and we\'ll send you instructions to reset your password',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          
          // Error message
          if (authController.error != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                authController.error!,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: AppColors.error,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
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
          const SizedBox(height: 24),
          
          // Send button
          CustomButton(
            onPressed: _sendResetEmail,
            label: 'Send Reset Link',
            isLoading: authController.isLoading,
          ),
          const SizedBox(height: 16),
          
          // Back to login
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Back to Login'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSuccessView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Success icon
        const Icon(
          Icons.check_circle_outline_rounded,
          size: 80,
          color: AppColors.success,
        ),
        const SizedBox(height: 24),
        Text(
          'Email Sent',
          style: Theme.of(context).textTheme.displaySmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'We\'ve sent password reset instructions to ${_emailController.text}',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        CustomButton(
          onPressed: () {
            Navigator.pop(context);
          },
          label: 'Back to Login',
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {
            setState(() {
              _isEmailSent = false;
            });
          },
          child: Text('Try another email'),
        ),
      ],
    );
  }
}