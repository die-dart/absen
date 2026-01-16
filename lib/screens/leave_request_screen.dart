import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/widgets/app_button.dart';
import '../core/localization/app_localizations.dart';
import '../core/widgets/app_card.dart';

class LeaveRequestScreen extends StatefulWidget {
  const LeaveRequestScreen({super.key});

  @override
  State<LeaveRequestScreen> createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();

  // Form fields
  String _requestType = 'Leave';
  DateTime? _selectedDate;
  String? _attachmentName;
  bool _isSubmitting = false;
  
  // Request status: null (not submitted), 'pending', 'approved', 'rejected'
  String? _requestStatus;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
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
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickAttachment() async {
    // TODO: Implement actual file picker
    // For demo, simulate file selection
    setState(() {
      _attachmentName = 'medical_certificate.pdf';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Attachment selected (demo)'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _removeAttachment() {
    setState(() {
      _attachmentName = null;
    });
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a date'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isSubmitting = false;
        _requestStatus = 'pending'; // Simulating successful submission
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Request submitted successfully'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Leave & Sick Request'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Page Title
                Text(
                  'Submit a Request',
                  style: AppTextStyles.h3,
                ),
                const SizedBox(height: 8),
                Text(
                  'Fill in the details below to request leave or sick day',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),

                // Request Type Dropdown
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Request Type',
                        style: AppTextStyles.labelLarge,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _requestType,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.surfaceVariant,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.border,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.border,
                            ),
                          ),
                          prefixIcon: Icon(
                            _requestType == 'Leave'
                                ? Icons.beach_access
                                : Icons.medical_services,
                            color: AppColors.primary,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Leave',
                            child: Text('Leave'),
                          ),
                          DropdownMenuItem(
                            value: 'Sick',
                            child: Text('Sick Day'),
                          ),
                        ],
                        onChanged: _requestStatus == null
                            ? (value) {
                                setState(() {
                                  _requestType = value!;
                                  // Clear attachment if switching from Sick to Leave
                                  if (_requestType == 'Leave') {
                                    _attachmentName = null;
                                  }
                                });
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Date Picker
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Start Date',
                        style: AppTextStyles.labelLarge,
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: _requestStatus == null ? _selectDate : null,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
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
                                  _selectedDate != null
                                      ? DateFormat('EEEE, d MMMM yyyy')
                                          .format(_selectedDate!)
                                      : 'Select date',
                                  style: _selectedDate != null
                                      ? AppTextStyles.bodyMedium
                                      : AppTextStyles.bodyMedium.copyWith(
                                          color: AppColors.textTertiary,
                                        ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                color: _requestStatus == null
                                    ? AppColors.textSecondary
                                    : AppColors.textTertiary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Reason Text Area
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reason',
                        style: AppTextStyles.labelLarge,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _reasonController,
                        maxLines: 5,
                        enabled: _requestStatus == null,
                        decoration: const InputDecoration(
                          hintText: 'Enter your reason here...',
                          alignLabelWithHint: true,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a reason';
                          }
                          if (value.trim().length < 10) {
                            return 'Reason must be at least 10 characters';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Attachment Upload (for Sick Day)
                if (_requestType == 'Sick')
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Attachment',
                              style: AppTextStyles.labelLarge,
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.textTertiary.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Optional',
                                style: AppTextStyles.caption,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Upload medical certificate or sick note',
                          style: AppTextStyles.bodySmall,
                        ),
                        const SizedBox(height: 12),
                        
                        if (_attachmentName == null)
                          OutlinedButton.icon(
                            onPressed: _requestStatus == null
                                ? _pickAttachment
                                : null,
                            icon: const Icon(Icons.attach_file),
                            label: const Text('Choose File'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.success.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.insert_drive_file,
                                  color: AppColors.success,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _attachmentName!,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.success,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (_requestStatus == null)
                                  IconButton(
                                    icon: const Icon(Icons.close, size: 18),
                                    color: AppColors.error,
                                    onPressed: _removeAttachment,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                const SizedBox(height: 24),

                // Status Display (if request submitted)
                if (_requestStatus != null) ...[
                  AppCard(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _getStatusColor().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _getStatusIcon(),
                            color: _getStatusColor(),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Request Status',
                                style: AppTextStyles.labelMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _getStatusText(),
                                style: AppTextStyles.h4.copyWith(
                                  color: _getStatusColor(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Submit Button
                if (_requestStatus == null)
                  AppButton(
                    text: 'Submit Request',
                    icon: Icons.send,
                    fullWidth: true,
                    isLoading: _isSubmitting,
                    onPressed: _isSubmitting ? null : _submitRequest,
                  )
                else
                  AppButton(
                    text: 'Back to Dashboard',
                    icon: Icons.home,
                    fullWidth: true,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                const SizedBox(height: 16),

                // Info Text
                Center(
                  child: Text(
                    _requestStatus == null
                        ? 'Your request will be reviewed by HR'
                        : 'You will be notified when your request is processed',
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

  Color _getStatusColor() {
    switch (_requestStatus) {
      case 'pending':
        return AppColors.warning;
      case 'approved':
        return AppColors.success;
      case 'rejected':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getStatusIcon() {
    switch (_requestStatus) {
      case 'pending':
        return Icons.schedule;
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  String _getStatusText() {
    switch (_requestStatus) {
      case 'pending':
        return 'Pending Review';
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      default:
        return 'Unknown';
    }
  }
}
