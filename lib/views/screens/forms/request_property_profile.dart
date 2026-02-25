import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travel_app/controllers/property_profile_controller.dart';
import 'package:travel_app/utils/app_theme.dart';
import 'package:travel_app/utils/app_validators.dart';
import 'package:travel_app/views/widgets/custom_button.dart';
import 'package:travel_app/views/widgets/custom_text_form_field.dart';
import 'package:travel_app/views/widgets/footer.dart';

class RequestPropertyProfileScreen extends StatefulWidget {
  const RequestPropertyProfileScreen({super.key});

  @override
  State<RequestPropertyProfileScreen> createState() =>
      _RequestPropertyProfileScreenState();
}

class _RequestPropertyProfileScreenState
    extends State<RequestPropertyProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameOfOwnerController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController zipController = TextEditingController();

  bool covenantsOnly = false;

  final PropertyProfileController _controller = Get.put(
    PropertyProfileController(),
  );

  void _showValidationDialog(String message) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return _CustomValidationDialog(message: message);
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut),
            ),
            child: child,
          ),
        );
      },
    );
  }

  String? _validateFields() {
    if (emailController.text.trim().isEmpty) {
      return 'Please enter Email Address';
    }
    if (!GetUtils.isEmail(emailController.text.trim())) {
      return 'Please enter a valid Email';
    }
    if (nameOfOwnerController.text.trim().isEmpty) {
      return 'Please enter Name';
    }
    if (nameOfOwnerController.text.trim().length < 3) {
      return 'Name must be at least 3 characters';
    }
    if (addressController.text.trim().isEmpty) {
      return 'Please enter Address';
    }
    if (cityController.text.trim().isEmpty) {
      return 'Please enter City';
    }
    if (stateController.text.trim().isEmpty) {
      return 'Please enter State';
    }
    if (zipController.text.trim().isEmpty) {
      return 'Please enter Zip';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Request'.toUpperCase(),
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
                        labelText: "Your Email",
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                            AppValidators.validateEmail(value),
                      ),
                      SizedBox(height: 15.h),
                      CustomTextFormField(
                        labelText: "Name of owner",
                        controller: nameOfOwnerController,
                        keyboardType: TextInputType.name,
                        validator: (value) =>
                            AppValidators.validateFullName(value),
                      ),
                      SizedBox(height: 15.h),
                      CustomTextFormField(
                        labelText: "Address",
                        controller: addressController,
                        keyboardType: TextInputType.streetAddress,
                        validator: (value) =>
                            AppValidators.validateNotEmpty(value, 'Address'),
                      ),
                      SizedBox(height: 15.h),
                      CustomTextFormField(
                        labelText: "City",
                        controller: cityController,
                        keyboardType: TextInputType.text,
                        validator: (value) =>
                            AppValidators.validateNotEmpty(value, 'City'),
                      ),
                      SizedBox(height: 15.h),
                      CustomTextFormField(
                        labelText: "State",
                        controller: stateController,
                        keyboardType: TextInputType.text,
                        validator: (value) =>
                            AppValidators.validateNotEmpty(value, 'State'),
                      ),
                      SizedBox(height: 15.h),
                      CustomTextFormField(
                        labelText: "Zip",
                        controller: zipController,
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            AppValidators.validateNotEmpty(value, 'Zip Code'),
                      ),
                      SizedBox(height: 15.h),
                      Divider(thickness: 1.2),
                      SizedBox(height: 15.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.r,
                          vertical: 10.r,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.of(context).textFieldColor,
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              value: covenantsOnly,
                              onChanged: (value) {
                                setState(() {
                                  covenantsOnly = value ?? false;
                                });
                              },
                              activeColor: AppTheme.of(context).accent1,
                              checkColor: AppTheme.of(
                                context,
                              ).primaryBackground,
                            ),
                            Text(
                              "Covenants & Restrictions Only",
                              style: AppTheme.of(context).bodyMedium.copyWith(
                                color: AppTheme.of(context).primaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30.h),
                      CustomButton(
                        buttonText: "Submit",
                        onTap: () async {
                          final validationError = _validateFields();
                          if (validationError != null) {
                            _showValidationDialog(validationError);
                            return;
                          }

                          final result = await _controller
                              .sendPropertyProfileEmail(
                                email: emailController.text,
                                nameOfOwner: nameOfOwnerController.text,
                                address: addressController.text,
                                city: cityController.text,
                                state: stateController.text,
                                zip: zipController.text,
                              );

                          if (!context.mounted) return;

                          if (result == EmailSendResult.success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Opening email client...'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Unable to open email client. Please check your email settings.',
                                ),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
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

class _CustomValidationDialog extends StatelessWidget {
  const _CustomValidationDialog({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.r),
      child: Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'First Montana Title App',
              style: AppTheme.of(context).titleLarge.copyWith(
                color: AppTheme.of(context).primaryBackground,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              message,
              style: AppTheme.of(context).bodyMedium.copyWith(
                color: AppTheme.of(context).primaryBackground,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.of(context).primary.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(5.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 50.r, vertical: 10.r),
                child: Text(
                  'OK',
                  style: AppTheme.of(context).bodyMedium.copyWith(
                    color: AppTheme.of(context).primaryBackground,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            // CustomButton(
            //   buttonText: 'OK',
            //   onTap: () {
            //     Navigator.of(context).pop();
            //   },
            //   isExpanded: true,
            // ),
          ],
        ),
      ),
    );
  }
}
