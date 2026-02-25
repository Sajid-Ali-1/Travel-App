import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travel_app/controllers/calculator_controller.dart';
import 'package:travel_app/utils/app_theme.dart';
import 'package:travel_app/utils/app_validators.dart';
import 'package:travel_app/utils/constants/financial_constants.dart';
import 'package:travel_app/views/screens/seller_net_sheet_calculator/net_sheet_result.dart';
import 'package:travel_app/views/widgets/custom_button.dart';
import 'package:travel_app/views/widgets/custom_text_form_field.dart';
import 'package:travel_app/views/widgets/footer.dart';

class NetSheetCalculatorScreen extends StatefulWidget {
  const NetSheetCalculatorScreen({super.key});

  @override
  State<NetSheetCalculatorScreen> createState() =>
      _NetSheetCalculatorScreenState();
}

class _NetSheetCalculatorScreenState extends State<NetSheetCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController priceController = TextEditingController();
  final TextEditingController estimatedPayoffController =
      TextEditingController();
  final TextEditingController closingFeeController = TextEditingController();
  final TextEditingController commisionController = TextEditingController();
  final TextEditingController sellerToPayClosingCost = TextEditingController();

  final CalculatorController calculatorController = Get.put(
    CalculatorController(),
  );

  @override
  void initState() {
    super.initState();
    // Initialize default values
    closingFeeController.text = FinancialConstants.defaultSellerClosingFees
        .toString();
    commisionController.text = FinancialConstants.defaultCommissionPercentage
        .toString();
    // Set initial values in controller
    calculatorController.closingFees =
        FinancialConstants.defaultSellerClosingFees;
    calculatorController.commissionPercentage =
        FinancialConstants.defaultCommissionPercentage;
  }

  @override
  void dispose() {
    priceController.dispose();
    estimatedPayoffController.dispose();
    closingFeeController.dispose();
    commisionController.dispose();
    sellerToPayClosingCost.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Net Sheet Calculator'.toUpperCase(),
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextFormField(
                        labelText: "Price",
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            AppValidators.validateNotEmpty(value, 'Price'),
                        onChanged: (value) => {
                          calculatorController.propertyPriceController =
                              double.tryParse(value) ?? 0,
                        },
                      ),
                      SizedBox(height: 15.h),
                      CustomTextFormField(
                        labelText: "Estimated Payoff",
                        controller: estimatedPayoffController,
                        keyboardType: TextInputType.number,
                        validator: (value) => AppValidators.validateNotEmpty(
                          value,
                          'Estimated Payoff',
                        ),
                        onChanged: (value) => {
                          calculatorController.estimatedLoanPayoff =
                              double.tryParse(value) ?? 0,
                        },
                      ),
                      SizedBox(height: 15.h),
                      CustomTextFormField(
                        labelText: "Closing Fee",
                        controller: closingFeeController,
                        keyboardType: TextInputType.number,
                        validator: (value) => AppValidators.validateNotEmpty(
                          value,
                          'Closing Fee',
                        ),
                        onChanged: (value) => {
                          calculatorController.closingFees =
                              double.tryParse(value) ?? 0,
                        },
                      ),
                      SizedBox(height: 15.h),
                      CustomTextFormField(
                        labelText: "Commision(%)",
                        controller: commisionController,
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            AppValidators.validateNotEmpty(value, 'Commision'),
                        onChanged: (value) => {
                          calculatorController.commissionPercentage =
                              double.tryParse(value) ?? 0,
                        },
                      ),
                      SizedBox(height: 15.h),
                      CustomTextFormField(
                        labelText: "Seller to pay closing cost",
                        controller: sellerToPayClosingCost,
                        keyboardType: TextInputType.number,
                        validator: (value) => AppValidators.validateNotEmpty(
                          value,
                          'Seller to pay',
                        ),
                        onChanged: (value) => {
                          calculatorController.sellerToPayClosingCost =
                              double.tryParse(value) ?? 0,
                        },
                      ),

                      SizedBox(height: 30.h),
                      CustomButton(
                        buttonText: "Submit",
                        onTap: () {
                          // if (_formKey.currentState!.validate()) {
                          // Set salePrice to propertyPriceController for calculations
                          calculatorController.salePrice =
                              calculatorController.propertyPriceController;
                          Get.to(() => const NetSheetResultScreen());
                          // }
                        },
                      ),
                    ],
                  ),
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
