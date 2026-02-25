import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travel_app/controllers/calculator_controller.dart';
import 'package:travel_app/services/email_service.dart';
import 'package:travel_app/utils/app_theme.dart';
import 'package:travel_app/views/widgets/custom_button.dart';
import 'package:travel_app/views/widgets/footer.dart';
import 'package:travel_app/views/widgets/result_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class QuickEstimateResultScreen extends StatelessWidget {
  const QuickEstimateResultScreen({super.key});

  // void _showSendResultsBottomSheet(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Colors.transparent,
  //     isDismissible: true,
  //     enableDrag: true,
  //     builder: (BuildContext context) {
  //       return _SendResultsBottomSheet();
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Result'.toUpperCase(),
          style: AppTheme.of(
            context,
          ).titleLarge.copyWith(color: AppTheme.of(context).primaryBackground),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.of(context).accent1,
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: GetBuilder(
                  init: Get.find<CalculatorController>(),
                  builder: (controller) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${controller.loanType.abbreviation} Loan Results:",
                          style: AppTheme.of(context).titleLarge,
                        ),

                        SizedBox(height: 10.h),
                        ResultTile(
                          title: "Payment (PITI):",
                          value: controller.calculatePITI().toStringAsFixed(2),
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Expanded(
                              child: ResultTile(
                                title: "Home",
                                value: controller.propertyPriceController
                                    .toStringAsFixed(2),
                              ),
                            ),
                            Container(
                              color: AppTheme.of(context).primaryBackground,
                              padding: EdgeInsets.symmetric(horizontal: 14.r),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () =>
                                        controller.increasePropertyPrice(),
                                    child: Icon(
                                      Icons.add_circle,
                                      color: Colors.green,
                                      size: 30.sp,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () =>
                                        controller.decreasePropertyPrice(),
                                    child: Icon(
                                      Icons.remove_circle,
                                      color: AppTheme.of(context).accent1,
                                      size: 30.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ResultTile(
                                title: "Loan",
                                value: controller.loanAmount.toStringAsFixed(2),
                              ),
                            ),
                            Container(
                              color: AppTheme.of(context).primaryBackground,
                              padding: EdgeInsets.symmetric(horizontal: 14.r),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () =>
                                        controller.increaseLoanAmount(),
                                    child: Icon(
                                      Icons.add_circle,
                                      color: Colors.green,
                                      size: 30.sp,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () =>
                                        controller.decreaseLoanAmount(),
                                    child: Icon(
                                      Icons.remove_circle,
                                      color: AppTheme.of(context).accent1,
                                      size: 30.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30.h),
                        // ----------------------------------- Fixed Closing Cost -----------------------------------
                        Text(
                          "Fixed Closing Cost:",
                          style: AppTheme.of(context).titleLarge,
                        ),
                        SizedBox(height: 10.h),
                        // Build ResultTile widgets from lists so the UI is easier to maintain.
                        ...controller
                            .getFixedClosingCosts()
                            .toList()
                            .asMap()
                            .entries
                            .map((entry) {
                              final idx = entry.key;
                              final cost = entry.value;
                              final shouldColor =
                                  idx % 2 == 1; // color every second
                              final isTotal =
                                  idx ==
                                  controller
                                          .getFixedClosingCosts()
                                          .toList()
                                          .length -
                                      1;
                              return ResultTile(
                                title: cost.key,
                                value: cost.value,
                                color: shouldColor
                                    ? AppTheme.of(context).primaryBackground
                                    : null,
                                isTotal: isTotal,
                              );
                            }),
                        SizedBox(height: 30.h),

                        // ----------------------------------- ----------------- -----------------------------------
                        Text(
                          "This is just an estimate. Contact your lender for detailed closing costs.",
                          style: AppTheme.of(context).labelLarge,
                          textAlign: TextAlign.center,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Call 406-248-3000 for more information",
                            style: AppTheme.of(context).labelLarge,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 30.h),
                        CustomButton(
                          buttonText: "Send Results",
                          onTap: () async {
                            final body = await controller
                                .generateQuickEstimateEmailBody();
                            await EmailService.sendEmail(
                              subject: 'Quick Estimate Calculator Results',
                              formattedBody: body,
                            );
                          },
                        ),
                        SizedBox(height: 30.h),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          Footer(),
        ],
      ),
    );
  }
}
