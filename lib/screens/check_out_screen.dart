import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/widgets/app_button.dart';
import '../core/localization/app_localizations.dart';
import '../core/widgets/app_card.dart';

class CheckOutScreen extends StatefulWidget {
  final DateTime? checkInTime;

  const CheckOutScreen({
    super.key,
    this.checkInTime,
  });

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  bool _isCheckedOut = false;
  bool _isLoading = false;
  DateTime? _checkOutTime;
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

  String _calculateWorkingHours() {
    if (widget.checkInTime == null || _checkOutTime == null) return '0h 0m';
    
    final duration = _checkOutTime!.difference(widget.checkInTime!);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    
    return '${hours}h ${minutes}m';
  }

  Future<void> _showConfirmationDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Confirm Check Out',
          style: AppTextStyles.h4,
        ),
        content: Text(
          'Are you sure you want to check out now?',
          style: AppTextStyles.bodyMedium,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: AppTextStyles.button.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textOnPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Check Out',
              style: AppTextStyles.button,
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      _handleCheckOut();
    }
  }

  Future<void> _handleCheckOut() async {
    // Clear previous error
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // TODO: Replace with actual check-out logic
    // For demo, simulate success (90% chance) or error (10% chance)
    final isSuccess = DateTime.now().millisecond % 10 != 0;

    if (mounted) {
      if (isSuccess) {
        setState(() {
          _isLoading = false;
          _isCheckedOut = true;
          _checkOutTime = DateTime.now();
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to check out. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Check Out'),
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
                      
                      // Current Time
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Current Time',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _currentTime,
                              style: AppTextStyles.h2.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Check-In Time Card
                if (widget.checkInTime != null)
                  AppCard(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.login,
                            color: AppColors.success,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Check-In Time',
                                style: AppTextStyles.labelMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat('HH:mm:ss').format(widget.checkInTime!),
                                style: AppTextStyles.h4.copyWith(
                                  color: AppColors.success,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 32),

                // Status Message (Not Checked Out)
                if (!_isCheckedOut && _errorMessage == null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.info.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.info.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.info,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Ready to check out',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.info,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Success Message
                if (_isCheckedOut && _checkOutTime != null)
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
                                'Check-out successful!',
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
                                Icons.logout,
                                color: AppColors.success,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Checked out at ${DateFormat('HH:mm:ss').format(_checkOutTime!)}',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Working Hours
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.info.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.timer,
                                color: AppColors.info,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Working Hours: ${_calculateWorkingHours()}',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.info,
                                  fontWeight: FontWeight.w600,
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

                // Check Out Button
                if (!_isCheckedOut)
                  AppButton(
                    text: 'Check Out',
                    icon: Icons.logout,
                    fullWidth: true,
                    isLoading: _isLoading,
                    onPressed: _isLoading ? null : _showConfirmationDialog,
                  ),

                // Back to Dashboard Button (after check-out)
                if (_isCheckedOut)
                  AppButton(
                    text: 'Back to Dashboard',
                    icon: Icons.home,
                    fullWidth: true,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

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
                    'Your check-out will be recorded',
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
