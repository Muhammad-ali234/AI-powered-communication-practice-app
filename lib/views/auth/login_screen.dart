import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:communication_practice/controllers/auth_controller.dart';
import 'package:communication_practice/utils/routes.dart';
import 'package:communication_practice/utils/theme.dart';
import 'package:communication_practice/widgets/custom_button.dart';
import 'package:communication_practice/widgets/custom_textfield.dart';
import 'package:communication_practice/widgets/social_login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
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
  
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    
    final authController = Provider.of<AuthController>(context, listen: false);
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    
    final success = await authController.login(email, password);
    
    if (success && mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.main);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    
    return Scaffold(
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
                  const Icon(
                    Icons.forum_rounded,
                    size: 64,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Welcome Back',
                    style: Theme.of(context).textTheme.displaySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to continue practicing your communication skills',
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
                  const SizedBox(height: 16),
                  
                  // Password input
                  CustomTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: 'Enter your password',
                    obscureText: !_isPasswordVisible,
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                    onSuffixIconPressed: _togglePasswordVisibility,
                    validator: _validatePassword,
                  ),
                  
                  // Forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.forgotPassword);
                      },
                      child: Text('Forgot Password?', style: Theme.of(context).textTheme.labelLarge),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Login button
                  CustomButton(
                    onPressed: _login,
                    label: 'Sign In',
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
                          'Or sign in with',
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
                  
                  // Sign up link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.signup);
                        },
                        child: Text('Sign Up'),
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