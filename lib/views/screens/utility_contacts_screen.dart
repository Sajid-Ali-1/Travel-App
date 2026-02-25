import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travel_app/utils/app_theme.dart';
import 'package:travel_app/views/screens/web_view_screen.dart';
import 'package:travel_app/views/widgets/footer.dart';

class UtilityContactsScreen extends StatelessWidget {
  const UtilityContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final utilities = [
      {
        'name': 'NorthWestern Energy (electric & natural gas)',
        'url': 'https://www.northwesternenergy.com/',
      },
      {
        'name': 'MontanaDakota Utilities Co. (gas & electric)',
        'url': 'https://www.montana-dakota.com/',
      },
      {
        'name': 'Yellowstone Valley Electric Cooperative (rural/distribution electric)',
        'url': 'https://www.yvec.com/',
      },
      {
        'name': 'County Water District of Billings Heights (water)',
        'url': 'https://www.heightswaterdistrict.com/',
      },
      {
        'name': 'City of Billings Public Works – Utilities (city water, sewer, stormwater, waste)',
        'url': 'https://www.billingsmtpublicworks.gov/248/Payments-Utility-Account-Services',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Utility Contacts'),
        centerTitle: true,
        backgroundColor: AppTheme.of(context).accent1,
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                ...utilities.map((utility) => [
                      UtilityListTile(
                        title: utility['name']!,
                        onTap: () => Get.to(
                          () => WebViewScreen(
                            url: utility['url']!,
                            title: utility['name']!,
                          ),
                        ),
                      ),
                      Divider(thickness: 1.2),
                    ]).expand((element) => element),
              ],
            ),
          ),
          Footer(),
        ],
      ),
    );
  }
}

class UtilityListTile extends StatelessWidget {
  const UtilityListTile({
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
        child: Text(title),
      ),
    );
  }
}

