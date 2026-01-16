import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_text_styles.dart';
import 'core/widgets/app_button.dart';
import 'core/widgets/app_card.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const HorizonAttendanceApp());
}

class HorizonAttendanceApp extends StatelessWidget {
  const HorizonAttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Horizon Attendance',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Horizon Attendance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Text(
                'Welcome back!',
                style: AppTextStyles.h2,
              ),
              const SizedBox(height: 8),
              Text(
                'Manage your attendance efficiently',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),

              // Quick Actions Card
              AppCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _QuickActionButton(
                            icon: Icons.login,
                            label: 'Check In',
                            color: AppColors.success,
                            onTap: () {},
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _QuickActionButton(
                            icon: Icons.logout,
                            label: 'Check Out',
                            color: AppColors.error,
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Today's Status Card
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today\'s Status',
                      style: AppTextStyles.h4,
                    ),
                    const SizedBox(height: 16),
                    _StatusItem(
                      icon: Icons.access_time,
                      label: 'Check In',
                      value: '08:30 AM',
                      valueColor: AppColors.success,
                    ),
                    const SizedBox(height: 12),
                    _StatusItem(
                      icon: Icons.timer_outlined,
                      label: 'Working Hours',
                      value: '6h 30m',
                      valueColor: AppColors.info,
                    ),
                    const SizedBox(height: 12),
                    _StatusItem(
                      icon: Icons.location_on_outlined,
                      label: 'Location',
                      value: 'Office - Main Building',
                      valueColor: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Button Showcase
              Text(
                'Design System Preview',
                style: AppTextStyles.h4,
              ),
              const SizedBox(height: 16),

              // Primary Button
              AppButton(
                text: 'Primary Button',
                fullWidth: true,
                onPressed: () {},
              ),
              const SizedBox(height: 12),

              // Secondary Button
              AppButton(
                text: 'Secondary Button',
                type: ButtonType.secondary,
                fullWidth: true,
                onPressed: () {},
              ),
              const SizedBox(height: 12),

              // Outlined Button
              AppButton(
                text: 'Outlined Button',
                type: ButtonType.outlined,
                fullWidth: true,
                onPressed: () {},
              ),
              const SizedBox(height: 12),

              // Button with Icon
              AppButton(
                text: 'Button with Icon',
                icon: Icons.calendar_today,
                fullWidth: true,
                onPressed: () {},
              ),
              const SizedBox(height: 12),

              // Small Button
              Row(
                children: [
                  AppButton(
                    text: 'Small',
                    size: ButtonSize.small,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 12),
                  AppButton(
                    text: 'Medium',
                    size: ButtonSize.medium,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 12),
                  AppButton(
                    text: 'Large',
                    size: ButtonSize.large,
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Input Field Example
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Employee ID',
                  hintText: 'Enter your employee ID',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  hintText: 'Add notes (optional)',
                  prefixIcon: Icon(Icons.note_outlined),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.qr_code_scanner),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  const _StatusItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.labelSmall,
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: valueColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
