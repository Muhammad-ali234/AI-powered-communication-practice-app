import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:communication_practice/controllers/auth_controller.dart';
import 'package:communication_practice/utils/routes.dart';
import 'package:communication_practice/utils/theme.dart';
import 'package:communication_practice/widgets/custom_button.dart';
import 'package:communication_practice/widgets/custom_textfield.dart';
import 'package:communication_practice/widgets/social_login_button.dart';
import 'package:communication_practice/utils/responsive.dart';

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
    final responsive = ResponsiveUtil(context);
    
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: responsive.responsivePadding(all: 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Icon(
                    Icons.forum_rounded,
                    size: responsive.iconSize(64),
                    color: AppColors.primary,
                  ),
                  SizedBox(height: responsive.lg),
                  Text(
                    'Welcome Back',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontSize: responsive.fontSize(Theme.of(context).textTheme.displaySmall?.fontSize ?? 32),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: responsive.xs),
                  Text(
                    'Sign in to continue practicing your communication skills',
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
                  SizedBox(height: responsive.md),
                  
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
                      child: Text(
                        'Forgot Password?',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: responsive.fontSize(Theme.of(context).textTheme.labelLarge?.fontSize ?? 14),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: responsive.lg),
                  
                  // Login button
                  CustomButton(
                    onPressed: _login,
                    label: 'Sign In',
                    isLoading: authController.isLoading,
                  ),
                  SizedBox(height: responsive.lg),
                  
                  // Divider
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: responsive.responsivePadding(horizontal: 16),
                        child: Text(
                          'Or sign in with',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: responsive.fontSize(Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14),
                          ),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  SizedBox(height: responsive.lg),
                  
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
                      SizedBox(width: responsive.md),
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
                  SizedBox(height: responsive.lg),
                  
                  // Sign up link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: responsive.fontSize(Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.signup);
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: responsive.fontSize(14),
                          ),
                        ),
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