import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/widgets/app_card.dart';

// Attendance record model
class AttendanceRecord {
  final DateTime date;
  final String? checkInTime;
  final String? checkOutTime;
  final String status; // 'on_time', 'late', 'leave', 'sick'

  AttendanceRecord({
    required this.date,
    this.checkInTime,
    this.checkOutTime,
    required this.status,
  });
}

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  State<AttendanceHistoryScreen> createState() => _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  DateTime? _filterDate;
  List<AttendanceRecord> _records = [];

  @override
  void initState() {
    super.initState();
    _loadSampleData();
  }

  void _loadSampleData() {
    // Generate sample attendance records for the past 2 weeks
    final now = DateTime.now();
    _records = List.generate(14, (index) {
      final date = now.subtract(Duration(days: index));
      
      // Skip weekends for some variety
      if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
        return null;
      }

      // Vary the status
      String status;
      String? checkIn;
      String? checkOut;
      
      if (index == 2) {
        status = 'sick';
      } else if (index == 5) {
        status = 'leave';
      } else if (index == 1) {
        status = 'late';
        checkIn = '09:15:00';
        checkOut = '18:00:00';
      } else {
        status = 'on_time';
        checkIn = '08:30:00';
        checkOut = '17:30:00';
      }

      return AttendanceRecord(
        date: date,
        checkInTime: checkIn,
        checkOutTime: checkOut,
        status: status,
      );
    }).whereType<AttendanceRecord>().toList();
  }

  List<AttendanceRecord> get _filteredRecords {
    if (_filterDate == null) {
      return _records;
    }
    
    return _records.where((record) {
      return record.date.year == _filterDate!.year &&
          record.date.month == _filterDate!.month &&
          record.date.day == _filterDate!.day;
    }).toList();
  }

  Future<void> _selectFilterDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _filterDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.textOnPrimary,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _filterDate = picked;
      });
    }
  }

  void _clearFilter() {
    setState(() {
      _filterDate = null;
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'on_time':
        return AppColors.success;
      case 'late':
        return AppColors.warning;
      case 'leave':
        return AppColors.info;
      case 'sick':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'on_time':
        return Icons.check_circle;
      case 'late':
        return Icons.schedule;
      case 'leave':
        return Icons.beach_access;
      case 'sick':
        return Icons.medical_services;
      default:
        return Icons.info;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'on_time':
        return 'On Time';
      case 'late':
        return 'Late';
      case 'leave':
        return 'Leave';
      case 'sick':
        return 'Sick';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredRecords = _filteredRecords;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Attendance History'),
      ),
      body: Column(
        children: [
          // Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.surfaceVariant,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filter by Date',
                  style: AppTextStyles.labelMedium,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: _selectFilterDate,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.border,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                color: AppColors.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _filterDate != null
                                      ? DateFormat('d MMMM yyyy').format(_filterDate!)
                                      : 'All dates',
                                  style: _filterDate != null
                                      ? AppTextStyles.bodyMedium
                                      : AppTextStyles.bodyMedium.copyWith(
                                          color: AppColors.textTertiary,
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (_filterDate != null) ...[
                      const SizedBox(width: 12),
                      IconButton(
                        onPressed: _clearFilter,
                        icon: const Icon(Icons.close),
                        color: AppColors.error,
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.error.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Records Count
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  '${filteredRecords.length} ${filteredRecords.length == 1 ? 'record' : 'records'}',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Attendance List
          Expanded(
            child: filteredRecords.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 16,
                    ),
                    itemCount: filteredRecords.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 16,
                      color: AppColors.borderLight,
                    ),
                    itemBuilder: (context, index) {
                      return _buildAttendanceItem(filteredRecords[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceItem(AttendanceRecord record) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date and Status Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('EEEE').format(record.date),
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DateFormat('d MMMM yyyy').format(record.date),
                      style: AppTextStyles.labelLarge,
                    ),
                  ],
                ),
              ),
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(record.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getStatusIcon(record.status),
                      size: 14,
                      color: _getStatusColor(record.status),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _getStatusText(record.status),
                      style: AppTextStyles.labelSmall.copyWith(
                        color: _getStatusColor(record.status),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Check-in and Check-out times
          if (record.checkInTime != null || record.checkOutTime != null) ...[
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                // Check-in Time
                if (record.checkInTime != null)
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.login,
                            size: 16,
                            color: AppColors.success,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'In',
                              style: AppTextStyles.caption,
                            ),
                            Text(
                              record.checkInTime!.substring(0, 5), // HH:mm
                              style: AppTextStyles.labelMedium.copyWith(
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                
                // Check-out Time
                if (record.checkOutTime != null)
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.logout,
                            size: 16,
                            color: AppColors.error,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Out',
                              style: AppTextStyles.caption,
                            ),
                            Text(
                              record.checkOutTime!.substring(0, 5), // HH:mm
                              style: AppTextStyles.labelMedium.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            'No records found',
            style: AppTextStyles.h4.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _filterDate != null
                ? 'No attendance records for this date'
                : 'Your attendance history will appear here',
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
