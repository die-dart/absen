import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/widgets/app_button.dart';
import '../core/localization/app_localizations.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // Clear previous error
    setState(() {
      _errorMessage = null;
    });

    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Show loading state
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // TODO: Replace with actual login logic
    // For demo purposes, check simple credentials
    if (_emailController.text == 'admin@horizon.com' && 
        _passwordController.text == 'password') {
      // Success - navigate to home with bottom nav
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const HomeScreen(
              employeeName: 'Admin',
              employeeId: 'EMP-2026-001',
              jobPosition: 'Software Engineer',
              department: 'IT Department',
            ),
          ),
        );
      }
    } else {
      // Show error
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = context.tr('login.error_invalid_credentials');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo
                  Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/logo-he.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback if image not found
                            return Icon(
                              Icons.business,
                              size: 60,
                              color: AppColors.primary,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Company Name
                  Text(
                    context.tr('login.title'),
                    style: AppTextStyles.h3,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    context.tr('login.subtitle'),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    enabled: !_isLoading,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email address',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.tr('login.error_email_required');
                      }
                      if (!value.contains('@')) {
                        return context.tr('login.error_email_invalid');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    enabled: !_isLoading,
                    decoration: InputDecoration(
                      labelText: context.tr('login.password'),
                      hintText: context.tr('login.password_hint'),
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.tr('login.error_password_required');
                      }
                      if (value.length < 6) {
                        return context.tr('login.error_password_short');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Error Message
                  if (_errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.error.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: AppColors.error,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (_errorMessage != null) const SizedBox(height: 24),

                  // Login Button
                  AppButton(
                    text: context.tr('login.login_button'),
                    fullWidth: true,
                    isLoading: _isLoading,
                    onPressed: _isLoading ? null : _handleLogin,
                  ),
                  const SizedBox(height: 16),

                  // Forgot Password Link
                  Center(
                    child: TextButton(
                      onPressed: _isLoading ? null : () {
                        // TODO: Navigate to forgot password
                      },
                      child: Text(
                        'Forgot Password?',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Demo Credentials Info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.info.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.info.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: AppColors.info,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Demo Credentials',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.info,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Email: admin@horizon.com\nPassword: password',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.info,
                          ),
                        ),
                      ],
                    ),
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
