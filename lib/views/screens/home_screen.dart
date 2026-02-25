import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travel_app/views/screens/community_contacts.dart';
import 'package:travel_app/views/screens/seller_net_sheet_calculator/net_sheet_calculator.dart';
import 'package:travel_app/views/screens/buyer_quick_estimate_calculator/quick_estimate_calculator.dart';
import 'package:travel_app/views/screens/forms/request_property_profile.dart';
import 'package:travel_app/views/screens/forms/settings_screen.dart';
import 'package:travel_app/views/screens/title_insurance_calculator/title_insurance_calculator.dart';
import 'package:travel_app/utils/app_theme.dart';
import 'package:travel_app/views/widgets/footer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'FIRST MONTANA TITLE APP',
              style: theme.titleLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
              ),
            ),
            Text(
              'COMPANY OF BILLINGS',
              style: theme.bodySmall.copyWith(
                color: Colors.white,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: AppTheme.of(context).accent1,
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      backgroundColor: theme.primaryBackground,
      body: Column(
        children: [
          // Main Content - Grid
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.r,
                  mainAxisSpacing: 16.r,
                  childAspectRatio: 0.85,
                ),
                children: [
                  HomeActionCard(
                    title: 'Quick Estimate (For Buyer)',
                    imagePath: 'assets/images/quick_estimate.png',
                    onTap: () => Get.to(() => QuickEstimateCalculatorScreen()),
                  ),
                  HomeActionCard(
                    title: 'Net sheet calculator (for seller)',
                    imagePath: 'assets/images/net_sheet_calculator.png',
                    onTap: () => Get.to(() => NetSheetCalculatorScreen()),
                  ),
                  HomeActionCard(
                    title: 'Title insurance calculator',
                    imagePath: 'assets/images/title_insurance_calculator.png',
                    onTap: () => Get.to(() => TitleInsuranceScreen()),
                  ),
                  HomeActionCard(
                    title: 'Request a property profile',
                    imagePath: 'assets/images/request_property.png',
                    onTap: () => Get.to(() => RequestPropertyProfileScreen()),
                  ),
                  HomeActionCard(
                    title: 'Community Contacts',
                    imagePath: 'assets/images/community_contacts.png',
                    onTap: () => Get.to(() => CommunityContactsScreen()),
                  ),
                  HomeActionCard(
                    title: 'Settings',
                    imagePath: 'assets/images/settings.png',
                    onTap: () => Get.to(() => SettingsScreen()),
                  ),
                ],
              ),
            ),
          ),
          // Footer Banner
          Footer(),
        ],
      ),
    );
  }
}

class HomeActionCard extends StatelessWidget {
  const HomeActionCard({
    super.key,
    required this.title,
    required this.imagePath,
    this.onTap,
  });

  final String title;
  final String imagePath;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 10.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 70.r,
              width: 70.r,
              color: Colors.white,
            ),
            SizedBox(height: 12.h),
            Text(
              title.toUpperCase(),
              style: theme.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 14.sp,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
