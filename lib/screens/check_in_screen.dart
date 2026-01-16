import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/widgets/app_button.dart';
import '../core/localization/app_localizations.dart';
import '../core/widgets/app_card.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  bool _isCheckedIn = false;
  bool _isLoading = false;
  DateTime? _checkInTime;
  String? _errorMessage;
  
  String _currentTime = '';
  String _currentDate = '';
  String _currentDay = '';

  @override
  void initState() {
    super.initState();
    _updateDateTime();
    // Update time every second
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        _updateDateTime();
        return true;
      }
      return false;
    });
  }

  void _updateDateTime() {
    final now = DateTime.now();
    setState(() {
      _currentTime = DateFormat('HH:mm:ss').format(now);
      _currentDate = DateFormat('d MMMM yyyy').format(now);
      _currentDay = DateFormat('EEEE').format(now);
    });
  }

  Future<void> _handleCheckIn() async {
    // Clear previous error
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // TODO: Replace with actual check-in logic
    // For demo, simulate success (90% chance) or error (10% chance)
    final isSuccess = DateTime.now().millisecond % 10 != 0;

    if (mounted) {
      if (isSuccess) {
        setState(() {
          _isLoading = false;
          _isCheckedIn = true;
          _checkInTime = DateTime.now();
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to check in. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Check In'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Date and Time Display Card
                AppCard(
                  child: Column(
                    children: [
                      // Day of Week
                      Text(
                        _currentDay,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      
                      // Date
                      Text(
                        _currentDate,
                        style: AppTextStyles.h4,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      
                      // Time
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _currentTime,
                          style: AppTextStyles.h2.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Status Message
                if (!_isCheckedIn && _errorMessage == null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.warning.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.warning,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'You have not checked in today',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.warning,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Success Message
                if (_isCheckedIn && _checkInTime != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.success.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: AppColors.success,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Check-in successful!',
                                style: AppTextStyles.labelLarge.copyWith(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.access_time,
                                color: AppColors.success,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Checked in at ${DateFormat('HH:mm:ss').format(_checkInTime!)}',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                // Error Message
                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
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
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.error,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 32),

                // Check In Button
                if (!_isCheckedIn)
                  AppButton(
                    text: 'Check In',
                    icon: Icons.login,
                    fullWidth: true,
                    isLoading: _isLoading,
                    onPressed: _isLoading ? null : _handleCheckIn,
                  ),

                // Success Actions (after check-in)
                if (_isCheckedIn) ...[
                  AppButton(
                    text: 'Back to Dashboard',
                    icon: Icons.home,
                    fullWidth: true,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    text: 'Check Out',
                    icon: Icons.logout,
                    type: ButtonType.outlined,
                    fullWidth: true,
                    onPressed: () {
                      // TODO: Navigate to check-out screen or handle check-out
                    },
                  ),
                ],

                // Retry Button (if error)
                if (_errorMessage != null) ...[
                  const SizedBox(height: 12),
                  AppButton(
                    text: 'Try Again',
                    type: ButtonType.outlined,
                    fullWidth: true,
                    onPressed: () {
                      setState(() {
                        _errorMessage = null;
                      });
                    },
                  ),
                ],

                const SizedBox(height: 24),

                // Info Text
                Center(
                  child: Text(
                    'Your attendance will be recorded',
                    style: AppTextStyles.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
