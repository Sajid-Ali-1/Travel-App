import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travel_app/controllers/calculator_controller.dart';
import 'package:travel_app/services/email_service.dart';
import 'package:travel_app/utils/app_theme.dart';
import 'package:travel_app/utils/constants/financial_constants.dart';
import 'package:travel_app/views/widgets/custom_button.dart';
import 'package:travel_app/views/widgets/footer.dart';
import 'package:travel_app/views/widgets/result_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class NetSheetResultScreen extends StatelessWidget {
  const NetSheetResultScreen({super.key});

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
          // Use salePrice if available, otherwise use propertyPriceController
          final sellingPrice = controller.salePrice > 0
              ? controller.salePrice
              : controller.propertyPriceController;
          final loanPayoff = controller.estimatedLoanPayoff;
          final closingFees = controller.closingFees;
          final sellerPaids = controller.sellerToPayClosingCost;
          final titleInsurance = controller
              .calculateSellersTitleInsuranceCost();
          final processingFees = FinancialConstants.defaultProcessingFees;
          final commission = controller.calculateSellerCommission();
          final net = controller.calculateSellerNetProceeds();

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
                          "Net Sheet Result:",
                          style: AppTheme.of(context).titleLarge,
                        ),
                        SizedBox(height: 10.h),
                        // Selling Price with +/- icons
                        Row(
                          children: [
                            Expanded(
                              child: ResultTile(
                                title: "Selling Price:",
                                value: sellingPrice.toStringAsFixed(2),
                              ),
                            ),
                            Container(
                              color: AppTheme.of(context).primaryBackground,
                              padding: EdgeInsets.symmetric(horizontal: 14.r),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => controller.increaseSalePrice(),
                                    child: Icon(
                                      Icons.add_circle,
                                      color: Colors.green,
                                      size: 30.sp,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => controller.decreaseSalePrice(),
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
                        SizedBox(height: 10.h),
                        // Loan Payoff with +/- icons
                        Row(
                          children: [
                            Expanded(
                              child: ResultTile(
                                title: "Loan Payoff:",
                                value: loanPayoff.toStringAsFixed(2),
                              ),
                            ),
                            Container(
                              color: AppTheme.of(context).primaryBackground,
                              padding: EdgeInsets.symmetric(horizontal: 14.r),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => controller
                                        .increaseEstimatedLoanPayoff(),
                                    child: Icon(
                                      Icons.add_circle,
                                      color: Colors.green,
                                      size: 30.sp,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => controller
                                        .decreaseEstimatedLoanPayoff(),
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
                        // SizedBox(height: 10.h),
                        // Text(
                        //   "See Range",
                        //   style: AppTheme.of(context).labelLarge,
                        // ),
                        SizedBox(height: 20.h),
                        // Fixed fees
                        ResultTile(
                          title: "Closing Fees:",
                          value: closingFees.toStringAsFixed(2),
                        ),
                        SizedBox(height: 10.h),
                        ResultTile(
                          title: "Seller Paids:",
                          value: sellerPaids.toStringAsFixed(2),
                        ),
                        SizedBox(height: 10.h),
                        ResultTile(
                          title: "Title Insurance:",
                          value: titleInsurance.toStringAsFixed(2),
                        ),
                        SizedBox(height: 10.h),
                        ResultTile(
                          title: "Processing Fees:",
                          value: processingFees.toStringAsFixed(2),
                        ),
                        SizedBox(height: 10.h),
                        ResultTile(
                          title: "Commission:",
                          value: commission.toStringAsFixed(2),
                        ),
                        SizedBox(height: 20.h),
                        // Net result
                        ResultTile(
                          title: "Net:",
                          value: net.toStringAsFixed(2),
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
                                .generateNetSheetEmailBody();
                            await EmailService.sendEmail(
                              subject: 'Net Sheet Calculator Results',
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
                  queryParameters: {'body': 'Net Sheet Results'},
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
                    'subject': 'Net Sheet Results',
                    'body': 'Net Sheet Results',
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
