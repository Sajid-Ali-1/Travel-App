import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travel_app/controllers/calculator_controller.dart';
import 'package:travel_app/utils/app_theme.dart';
import 'package:travel_app/utils/app_validators.dart';
import 'package:travel_app/views/screens/title_insurance_calculator/title_insurance_result.dart';
import 'package:travel_app/views/widgets/custom_button.dart';
import 'package:travel_app/views/widgets/custom_text_form_field.dart';
import 'package:travel_app/views/widgets/footer.dart';

class TitleInsuranceScreen extends StatelessWidget {
  TitleInsuranceScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  final TextEditingController salesPriceController = TextEditingController();
  final TextEditingController loanAmountController = TextEditingController();

  final CalculatorController calculatorController = Get.put(
    CalculatorController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Title Insurance Calculator'.toUpperCase(),
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
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomTextFormField(
                        labelText: "Sales Price",
                        controller: salesPriceController,
                        keyboardType: TextInputType.number,
                        validator: (value) => AppValidators.validateNotEmpty(
                          value,
                          'Sales Price',
                        ),
                        onChanged: (value) => {
                          calculatorController.salePrice =
                              double.tryParse(value) ?? 0,
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

                      SizedBox(height: 30.h),
                      CustomButton(
                        buttonText: "Submit",
                        onTap: () {
                          // if (_formKey.currentState!.validate()) {
                          // Set propertyPriceController to salePrice for calculations
                          calculatorController.propertyPriceController =
                              calculatorController.salePrice;
                          Get.to(() => const TitleInsuranceResultScreen());
                        },
                        // },
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
