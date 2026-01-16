import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/widgets/app_button.dart';
import '../core/widgets/app_card.dart';
import '../core/localization/app_localizations.dart';
import 'check_in_screen.dart';
import 'check_out_screen.dart';
import 'leave_request_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String employeeName;

  const DashboardScreen({
    super.key,
    this.employeeName = 'Employee',
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Attendance status: 'not_checked_in', 'checked_in', 'completed'
  String _attendanceStatus = 'not_checked_in';
  DateTime? _checkInTime;
  DateTime? _checkOutTime;
  
  String _currentTime = '';
  String _currentDate = '';

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
      _currentDate = DateFormat('EEEE, d MMMM yyyy').format(now);
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return context.tr('dashboard.greeting_morning');
    } else if (hour < 17) {
      return context.tr('dashboard.greeting_afternoon');
    } else {
      return context.tr('dashboard.greeting_evening');
    }
  }

  void _handleCheckIn() {
    setState(() {
      _attendanceStatus = 'checked_in';
      _checkInTime = DateTime.now();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Checked in at ${DateFormat('HH:mm').format(_checkInTime!)}'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _handleCheckOut() {
    setState(() {
      _attendanceStatus = 'completed';
      _checkOutTime = DateTime.now();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Checked out at ${DateFormat('HH:mm').format(_checkOutTime!)}'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(context.tr('dashboard.title')),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Text(
                '${_getGreeting()}, ${widget.employeeName}!',
                style: AppTextStyles.h2,
              ),
              const SizedBox(height: 8),
              Text(
                'Have a productive day',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),

              // Current Date and Time Card
              AppCard(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.calendar_today,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _currentDate,
                            style: AppTextStyles.labelMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _currentTime,
                            style: AppTextStyles.h3.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Attendance Status Card
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          context.tr('dashboard.attendance_status'),
                          style: AppTextStyles.h4,
                        ),
                        const Spacer(),
                        _buildStatusBadge(),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Check In Time
                    if (_checkInTime != null) ...[
                      _buildTimeRow(
                        icon: Icons.login,
                        label: 'Check In',
                        time: DateFormat('HH:mm').format(_checkInTime!),
                        color: AppColors.success,
                      ),
                      const SizedBox(height: 12),
                    ],
                    
                    // Check Out Time
                    if (_checkOutTime != null) ...[
                      _buildTimeRow(
                        icon: Icons.logout,
                        label: 'Check Out',
                        time: DateFormat('HH:mm').format(_checkOutTime!),
                        color: AppColors.error,
                      ),
                      const SizedBox(height: 12),
                    ],
                    
                    // Working Hours (if completed)
                    if (_attendanceStatus == 'completed' && _checkInTime != null && _checkOutTime != null) ...[
                      const Divider(height: 24),
                      _buildTimeRow(
                        icon: Icons.timer,
                        label: 'Working Hours',
                        time: _calculateWorkingHours(),
                        color: AppColors.info,
                      ),
                    ],
                    
                    // Message when not checked in
                    if (_attendanceStatus == 'not_checked_in')
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'You haven\'t checked in today',
                            style: AppTextStyles.bodySmall,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Primary Actions Section
              Text(
                'Quick Actions',
                style: AppTextStyles.h4,
              ),
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: context.tr('dashboard.check_in'),
                      icon: Icons.login,
                      onPressed: _attendanceStatus == 'not_checked_in'
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CheckInScreen(),
                                ),
                              );
                            }
                          : null,
                      fullWidth: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      text: context.tr('dashboard.check_out'),
                      icon: Icons.logout,
                      type: ButtonType.secondary,
                      onPressed: _attendanceStatus == 'checked_in'
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CheckOutScreen(
                                    checkInTime: _checkInTime,
                                  ),
                                ),
                              );
                            }
                          : null,
                      fullWidth: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Secondary Actions Section
              Text(
                context.tr('dashboard.more_options'),
                style: AppTextStyles.h4,
              ),
              const SizedBox(height: 12),
              
              _buildMenuCard(
                icon: Icons.medical_services_outlined,
                title: context.tr('leave_request.title'),
                subtitle: context.tr('leave_request.submit_request'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LeaveRequestScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color bgColor;
    Color textColor;
    String text;
    IconData icon;

    switch (_attendanceStatus) {
      case 'checked_in':
        bgColor = AppColors.success.withOpacity(0.1);
        textColor = AppColors.success;
        text = 'Checked In';
        icon = Icons.check_circle;
        break;
      case 'completed':
        bgColor = AppColors.info.withOpacity(0.1);
        textColor = AppColors.info;
        text = 'Completed';
        icon = Icons.done_all;
        break;
      default:
        bgColor = AppColors.warning.withOpacity(0.1);
        textColor = AppColors.warning;
        text = 'Not Checked In';
        icon = Icons.pending;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 6),
          Text(
            text,
            style: AppTextStyles.labelSmall.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRow({
    required IconData icon,
    required String label,
    required String time,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.labelMedium,
          ),
        ),
        Text(
          time,
          style: AppTextStyles.bodyMedium.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.labelLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: AppColors.textTertiary,
          ),
        ],
      ),
    );
  }

  String _calculateWorkingHours() {
    if (_checkInTime == null || _checkOutTime == null) return '0h 0m';
    
    final duration = _checkOutTime!.difference(_checkInTime!);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    
    return '${hours}h ${minutes}m';
  }
}
