import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/widgets/app_button.dart';
import '../core/widgets/app_card.dart';
import '../core/localization/app_localizations.dart';
import '../core/localization/locale_provider.dart';

class ProfileScreen extends StatelessWidget {
  final String employeeName;
  final String employeeId;
  final String jobPosition;
  final String department;

  const ProfileScreen({
    super.key,
    this.employeeName = 'Admin User',
    this.employeeId = 'EMP-2026-001',
    this.jobPosition = 'Software Engineer',
    this.department = 'IT Department',
  });

  Future<void> _handleLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          context.tr('profile.confirm_logout_title'),
          style: AppTextStyles.h4,
        ),
        content: Text(
          context.tr('profile.confirm_logout_message'),
          style: AppTextStyles.bodyMedium,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              context.tr('common.cancel'),
              style: AppTextStyles.button.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.textOnPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              context.tr('profile.logout'),
              style: AppTextStyles.button,
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      // Navigate back to login screen
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(context.tr('profile.title')),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Avatar and Name Section
              Center(
                child: Column(
                  children: [
                    // Avatar
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.2),
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _getInitials(employeeName),
                          style: AppTextStyles.h1.copyWith(
                            color: AppColors.primary,
                            fontSize: 40,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Name
                    Text(
                      employeeName,
                      style: AppTextStyles.h3,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),

                    // Employee ID
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        employeeId,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Employee Information Section
              Text(
                context.tr('profile.employee_information'),
                style: AppTextStyles.h4,
              ),
              const SizedBox(height: 12),

              // Job Position Card
              _buildInfoCard(
                context,
                icon: Icons.work_outline,
                label: context.tr('profile.job_position'),
                value: jobPosition,
                iconColor: AppColors.primary,
              ),
              const SizedBox(height: 12),

              // Department Card
              _buildInfoCard(
                context,
                icon: Icons.business,
                label: context.tr('profile.department'),
                value: department,
                iconColor: AppColors.info,
              ),
              const SizedBox(height: 32),

              // Account Settings Section
              Text(
                context.tr('profile.account_settings'),
                style: AppTextStyles.h4,
              ),
              const SizedBox(height: 12),

              // Language Switcher Card
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.language,
                            color: AppColors.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            context.tr('profile.language'),
                            style: AppTextStyles.labelLarge,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Language Toggle Buttons
                    Row(
                      children: [
                        Expanded(
                          child: _buildLanguageButton(
                            context,
                            label: context.tr('languages.indonesian'),
                            isSelected: localeProvider.isIndonesian,
                            onTap: () => localeProvider.setIndonesian(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildLanguageButton(
                            context,
                            label: context.tr('languages.english'),
                            isSelected: localeProvider.isEnglish,
                            onTap: () => localeProvider.setEnglish(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Change Password
              AppCard(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${context.tr('profile.change_password')} ${context.tr('profile.coming_soon')}',
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.lock_outline,
                        color: AppColors.warning,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        context.tr('profile.change_password'),
                        style: AppTextStyles.labelLarge,
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.textTertiary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // App Settings
              AppCard(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${context.tr('profile.app_settings')} ${context.tr('profile.coming_soon')}',
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.info.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.settings_outlined,
                        color: AppColors.info,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        context.tr('profile.app_settings'),
                        style: AppTextStyles.labelLarge,
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.textTertiary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Logout Button
              OutlinedButton.icon(
                onPressed: () => _handleLogout(context),
                icon: const Icon(Icons.logout),
                label: Text(context.tr('profile.logout')),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error, width: 1.5),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // App Version
              Center(
                child: Text(
                  '${context.tr('profile.version')} 1.0.0',
                  style: AppTextStyles.caption,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageButton(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(
              color: isSelected
                  ? AppColors.textOnPrimary
                  : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return AppCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyles.labelLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }
    return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
  }
}
