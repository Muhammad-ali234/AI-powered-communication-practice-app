import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:communication_practice/controllers/auth_controller.dart';
import 'package:communication_practice/utils/routes.dart';
import 'package:communication_practice/utils/theme.dart';
import 'package:communication_practice/widgets/custom_button.dart';
import 'package:communication_practice/widgets/custom_textfield.dart';
import 'package:communication_practice/widgets/social_login_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _acceptTerms = false;
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }
  
  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    });
  }
  
  void _toggleTerms(bool? value) {
    setState(() {
      _acceptTerms = value ?? false;
    });
  }
  
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    return null;
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
  
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
  
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }
  
  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the Terms of Service and Privacy Policy'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    
    final authController = Provider.of<AuthController>(context, listen: false);
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    
    final success = await authController.signup(name, email, password);
    
    if (success && mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.main);
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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Text(
                    'Create Account',
                    style: Theme.of(context).textTheme.displaySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign up to start improving your communication skills',
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
                  
                  // Name input
                  CustomTextField(
                    controller: _nameController,
                    label: 'Full Name',
                    hint: 'Enter your full name',
                    keyboardType: TextInputType.name,
                    prefixIcon: Icons.person_outline,
                    validator: _validateName,
                  ),
                  const SizedBox(height: 16),
                  
                  // Email input
                  CustomTextField(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 16),
                  
                  // Password input
                  CustomTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: 'Create a password',
                    obscureText: !_isPasswordVisible,
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                    onSuffixIconPressed: _togglePasswordVisibility,
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 16),
                  
                  // Confirm Password input
                  CustomTextField(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password',
                    hint: 'Confirm your password',
                    obscureText: !_isConfirmPasswordVisible,
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
                    onSuffixIconPressed: _toggleConfirmPasswordVisibility,
                    validator: _validateConfirmPassword,
                  ),
                  const SizedBox(height: 16),
                  
                  // Terms and conditions
                  Row(
                    children: [
                      Checkbox(
                        value: _acceptTerms,
                        onChanged: _toggleTerms,
                        activeColor: AppColors.primary,
                      ),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: 'I agree to the ',
                            style: Theme.of(context).textTheme.bodyMedium,
                            children: [
                              TextSpan(
                                text: 'Terms of Service',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                                // Add gesture recognizer in a real app
                              ),
                              const TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                                // Add gesture recognizer in a real app
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Signup button
                  CustomButton(
                    onPressed: _signup,
                    label: 'Sign Up',
                    isLoading: authController.isLoading,
                  ),
                  const SizedBox(height: 24),
                  
                  // Divider
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Or sign up with',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Social login buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialLoginButton(
                        type: SocialLoginType.google,
                        onPressed: () async {
                          final success = await authController.loginWithGoogle();
                          if (success && mounted) {
                            Navigator.pushReplacementNamed(context, AppRoutes.main);
                          }
                        },
                      ),
                      const SizedBox(width: 16),
                      SocialLoginButton(
                        type: SocialLoginType.apple,
                        onPressed: () async {
                          final success = await authController.loginWithApple();
                          if (success && mounted) {
                            Navigator.pushReplacementNamed(context, AppRoutes.main);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Login link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Sign In'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}