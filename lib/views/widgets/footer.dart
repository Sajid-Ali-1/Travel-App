import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/utils/app_theme.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Container(
      width: double.infinity,
      color: theme.accent1,
      padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 12.h),
      child: Column(
        children: [
          Text(
            '@ 2025 FIRST MONTANA TITLE APP',
            style: AppTheme.of(context).labelLarge.copyWith(
              color: AppTheme.of(context).primaryBackground,
              fontWeight: FontWeight.w900,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          Text(
            'APPLICATION DESIGN BY SKYPOINT STUDIOS',
            style: AppTheme.of(
              context,
            ).bodySmall.copyWith(color: AppTheme.of(context).primaryBackground),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
