import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/localization/app_localizations.dart';
import 'dashboard_screen.dart';
import 'attendance_history_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final String employeeName;
  final String employeeId;
  final String jobPosition;
  final String department;

  const HomeScreen({
    super.key,
    this.employeeName = 'Admin',
    this.employeeId = 'EMP-2026-001',
    this.jobPosition = 'Software Engineer',
    this.department = 'IT Department',
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      DashboardScreen(employeeName: widget.employeeName),
      const AttendanceHistoryScreen(),
      ProfileScreen(
        employeeName: widget.employeeName,
        employeeId: widget.employeeId,
        jobPosition: widget.jobPosition,
        department: widget.department,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiary,
        selectedLabelStyle: AppTextStyles.labelSmall.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextStyles.labelSmall,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard_outlined),
            activeIcon: const Icon(Icons.dashboard),
            label: context.tr('dashboard.title'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.history_outlined),
            activeIcon: const Icon(Icons.history),
            label: context.tr('attendance.history'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: context.tr('profile.title'),
          ),
        ],
      ),
    );
  }
}
