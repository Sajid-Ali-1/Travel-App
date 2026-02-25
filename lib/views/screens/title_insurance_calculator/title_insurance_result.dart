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

class TitleInsuranceResultScreen extends StatelessWidget {
  const TitleInsuranceResultScreen({super.key});

  void _showSendResultsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (BuildContext context) {
        return _SendResultsBottomSheet();
      },
    );
  }

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
      body: GetBuilder(
        init: Get.find<CalculatorController>(),
        builder: (controller) {
          // Calculate values
          final ownerPolicyValue = controller.salePrice > 0
              ? controller.salePrice
              : controller.propertyPriceController;
          final lenderPolicyValue = controller.loanAmount;
          final sellersTitleInsuranceCost = controller
              .calculateSellersTitleInsuranceCost();
          final loanTitleInsuranceCost = controller
              .calculateLoanTitleInsuranceCost();

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Title Insurance Result:",
                          style: AppTheme.of(context).titleLarge,
                        ),
                        SizedBox(height: 10.h),
                        ResultTile(
                          title: "Owner's Policy:",
                          value: ownerPolicyValue.toStringAsFixed(2),
                        ),
                        SizedBox(height: 10.h),
                        ResultTile(
                          title: "Lender's Policy:",
                          value: lenderPolicyValue.toStringAsFixed(2),
                        ),
                        SizedBox(height: 10.h),
                        ResultTile(
                          title: "Seller's Title Insurance:",
                          value: sellersTitleInsuranceCost.toStringAsFixed(2),
                        ),
                        SizedBox(height: 10.h),
                        ResultTile(
                          title: "Loan Title Insurance:",
                          value: loanTitleInsuranceCost.toStringAsFixed(2),
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          "Seller is responsible for their portion of the taxes.",
                          style: AppTheme.of(context).labelLarge,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 30.h),
                        CustomButton(
                          buttonText: "Send Results",
                          onTap: () async {
                            final body = await controller
                                .generateTitleInsuranceEmailBody();
                            await EmailService.sendEmail(
                              subject: 'Title Insurance Calculator Results',
                              formattedBody: body,
                            );
                          },
                        ),
                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                ),
              ),

              // Footer
              Footer(),
            ],
          );
        },
      ),
    );
  }
}

class _SendResultsBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20.h),
            Text(
              'Choose',
              style: AppTheme.of(context).titleLarge.copyWith(
                color: AppTheme.of(context).primaryBackground,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            _BottomSheetOption(
              title: 'SMS',
              onTap: () async {
                Navigator.of(context).pop();
                final Uri smsUri = Uri(
                  scheme: 'sms',
                  path: '',
                  queryParameters: {'body': 'Title Insurance Results'},
                );
                if (await canLaunchUrl(smsUri)) {
                  await launchUrl(smsUri);
                }
              },
            ),
            Divider(color: Colors.grey.shade700, thickness: 0.5),
            _BottomSheetOption(
              title: 'Email',
              onTap: () async {
                Navigator.of(context).pop();
                final Uri emailUri = Uri(
                  scheme: 'mailto',
                  path: '',
                  queryParameters: {
                    'subject': 'Title Insurance Results',
                    'body': 'Title Insurance Results',
                  },
                );
                if (await canLaunchUrl(emailUri)) {
                  await launchUrl(emailUri);
                }
              },
            ),
            Divider(color: Colors.grey.shade700, thickness: 0.5),
            _BottomSheetOption(
              title: 'Cancel',
              isCancel: true,
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}

class _BottomSheetOption extends StatelessWidget {
  const _BottomSheetOption({
    required this.title,
    required this.onTap,
    this.isCancel = false,
  });

  final String title;
  final VoidCallback onTap;
  final bool isCancel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 20.r),
        decoration: BoxDecoration(
          border: isCancel ? Border.all(color: Colors.red, width: 2.0) : null,
          borderRadius: isCancel ? BorderRadius.circular(8.r) : null,
        ),
        child: Text(
          title,
          style: AppTheme.of(context).bodyLarge.copyWith(
            color: isCancel
                ? Colors.red
                : AppTheme.of(context).primaryBackground,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
