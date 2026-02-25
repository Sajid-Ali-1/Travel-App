import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travel_app/utils/app_theme.dart';
import 'package:travel_app/views/screens/web_view_screen.dart';
import 'package:travel_app/views/widgets/footer.dart';

class CommunityContactsScreen extends StatelessWidget {
  const CommunityContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community Contacts'),
        centerTitle: true,
        backgroundColor: AppTheme.of(context).accent1,
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          CommunityListTile(
            title: 'School Zone Map',
            onTap: () => Get.to(
              () => const WebViewScreen(
                url: 'https://www.croppermap.com/billings/',
                title: 'School Zone Map',
              ),
            ),
          ),
          Divider(thickness: 1.2),
          CommunityListTile(
            title: 'Utility Contacts',
            onTap: () => Get.to(
              () => const WebViewScreen(
                url: 'https://www.billingschamber.com/',
                title: 'Billings Chamber of Commerce',
              ),
            ),
          ),
          Divider(thickness: 1.2),
          CommunityListTile(
            title: 'Billings Chamber of Commerce Contact',
            onTap: () => Get.to(
              () => const WebViewScreen(
                url: 'https://www.billingschamber.com/',
                title: 'Billings Chamber of Commerce',
              ),
            ),
          ),
          Divider(thickness: 1.2),
          CommunityListTile(
            title: 'Billings Association of Realtors',
            onTap: () => Get.to(
              () => const WebViewScreen(
                url: 'https://billings.org/',
                title: 'Billings Association of Realtors',
              ),
            ),
          ),
          Divider(thickness: 1.2),
          CommunityListTile(
            title: 'Homebuilders Association of Billings',
            onTap: () => Get.to(
              () => const WebViewScreen(
                url: 'https://hbabillings.net/',
                title: 'Homebuilders Association of Billings',
              ),
            ),
          ),
          Divider(thickness: 1.2),
          Spacer(),
          Footer(),
        ],
      ),
    );
  }
}

class CommunityListTile extends StatelessWidget {
  const CommunityListTile({
    super.key,
    required this.title,
    required this.onTap,
  });

  final String title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 17.r),
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Icon(Icons.arrow_forward_ios, size: 16.sp),
          ],
        ),
      ),
    );
  }
}
