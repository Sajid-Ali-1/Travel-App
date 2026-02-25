import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travel_app/controllers/calculator_controller.dart';
import 'package:travel_app/utils/enums/loan_type.dart';

import 'package:travel_app/utils/app_theme.dart';
import 'package:travel_app/utils/app_validators.dart';
import 'package:travel_app/views/screens/buyer_quick_estimate_calculator/quick_estimate_result.dart';
import 'package:travel_app/views/widgets/custom_button.dart';
import 'package:travel_app/views/widgets/custom_dropdown.dart';
import 'package:travel_app/views/widgets/custom_text_form_field.dart';
import 'package:travel_app/views/widgets/footer.dart';

class QuickEstimateCalculatorScreen extends StatelessWidget {
  QuickEstimateCalculatorScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  final TextEditingController homePriceController = TextEditingController();
  final TextEditingController loanAmountController = TextEditingController();
  final TextEditingController yearsController = TextEditingController();
  final TextEditingController interestRateController = TextEditingController();
  final TextEditingController taxesController = TextEditingController();
  final TextEditingController homeOwnersInsuranceController =
      TextEditingController();

  final CalculatorController calculatorController = Get.put(
    CalculatorController(),
  );
  @override
  Widget build(BuildContext context) {
    yearsController.text = 30.toString();
    interestRateController.text = 6.5.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quick Estimate Calculator'.toUpperCase(),
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
                      CustomDropdown<LoanType>(
                        labelText: 'Loan Type',
                        value: calculatorController.loanType,
                        items: LoanType.values,
                        displayStringForOption: (loanType) => loanType.fullName,
                        onChanged: (value) => {
                          if (value != null)
                            calculatorController.loanType = value,
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select an option';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15.h),
                      CustomTextFormField(
                        labelText: "Home Price",
                        controller: homePriceController,
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            AppValidators.validateNotEmpty(value, 'Home Price'),
                        onChanged: (value) {
                          calculatorController.propertyPriceController =
                              double.tryParse(value) ?? 0;
                          taxesController.text = calculatorController
                              .calculateRatePerThousandTax(
                                propertyValue: double.tryParse(value) ?? 0,
                              )
                              .toString();
                          homeOwnersInsuranceController.text =
                              calculatorController
                                  .calculateHomeownersInsurancePremium(
                                    dwellingCoverageAmount:
                                        double.tryParse(value) ?? 0,
                                  )
                                  .toString();
                          calculatorController.annualTax =
                              double.tryParse(taxesController.text) ?? 0;
                          calculatorController.annualInsurance =
                              double.tryParse(
                                homeOwnersInsuranceController.text,
                              ) ??
                              0;

                          calculatorController.update();
                        },
                      ),
                      SizedBox(height: 15.h),
                      CustomTextFormField(
                        labelText: "Loan Amount",
                        controller: loanAmountController,
                        keyboardType: TextInputType.number,
                        validator: (value) => AppValidators.validateNotEmpty(
                          value,
                          'Loan Amount',
                        ),
                        onChanged: (value) => {
                          calculatorController.loanAmount =
                              double.tryParse(value) ?? 0,
                        },
                      ),
                      SizedBox(height: 15.h),
                      CustomTextFormField(
                        labelText: "Years",
                        controller: yearsController,
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            AppValidators.validateNotEmpty(value, 'Years'),
                        onChanged: (value) => {
                          calculatorController.loanTermYears =
                              double.tryParse(value) ?? 0,
                        },
                      ),
                      SizedBox(height: 15.h),
                      CustomTextFormField(
                        labelText: "Interest Rate",
                        controller: interestRateController,
                        keyboardType: TextInputType.number,
                        validator: (value) => AppValidators.validateNotEmpty(
                          value,
                          'Interest Rate',
                        ),
                        onChanged: (value) => {
                          calculatorController.annualIntrestRatePercentage =
                              double.tryParse(value) ?? 0,
                        },
                      ),
                      SizedBox(height: 15.h),
                      CustomTextFormField(
                        labelText: "Taxes (Annual)",
                        controller: taxesController,
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            AppValidators.validateNotEmpty(value, 'Taxes'),
                        onChanged: (value) => {
                          calculatorController.annualTax =
                              double.tryParse(value) ?? 0,
                        },
                      ),
                      SizedBox(height: 15.h),
                      CustomTextFormField(
                        labelText: "Home Owner's Insurance (Annual)",
                        controller: homeOwnersInsuranceController,
                        keyboardType: TextInputType.number,
                        validator: (value) => AppValidators.validateNotEmpty(
                          value,
                          "Home Owner's Insurance",
                        ),
                        textInputAction: TextInputAction.done,
                        onChanged: (value) => {
                          calculatorController.annualInsurance =
                              double.tryParse(value) ?? 0,
                        },
                      ),
                      SizedBox(height: 30.h),
                      CustomButton(
                        buttonText: "Submit",
                        onTap: () {
                          // if (_formKey.currentState!.validate()) {
                          //   Get.to(() => QuickEstimateResultScreen());
                          // }
                          Get.to(() => QuickEstimateResultScreen());
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
