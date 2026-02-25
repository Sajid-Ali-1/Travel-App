import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_app/utils/app_theme.dart';
import 'package:travel_app/utils/app_validators.dart';
import 'package:travel_app/views/widgets/custom_button.dart';
import 'package:travel_app/views/widgets/custom_text_form_field.dart';
import 'package:travel_app/views/widgets/footer.dart';

// SharedPreferences keys
const String _kFirstNameKey = 'user_first_name';
const String _kLastNameKey = 'user_last_name';
const String _kEmailKey = 'user_email';
const String _kPhoneKey = 'user_phone';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedSettings();
  }

  Future<void> _loadSavedSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      firstNameController.text = prefs.getString(_kFirstNameKey) ?? '';
      lastNameController.text = prefs.getString(_kLastNameKey) ?? '';
      emailController.text = prefs.getString(_kEmailKey) ?? '';
      phoneController.text = prefs.getString(_kPhoneKey) ?? '';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kFirstNameKey, firstNameController.text);
    await prefs.setString(_kLastNameKey, lastNameController.text);
    await prefs.setString(_kEmailKey, emailController.text);
    await prefs.setString(_kPhoneKey, phoneController.text);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings'.toUpperCase(),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'You can update your information here.',
                        style: AppTheme.of(context).labelMedium,
                      ),
                      SizedBox(height: 25.h),
                      CustomTextFormField(
                        labelText: "First Name",
                        controller: firstNameController,
                        keyboardType: TextInputType.name,
                        validator: (value) =>
                            AppValidators.validateFullName(value),
                      ),
                      SizedBox(height: 15.h),
                      CustomTextFormField(
                        labelText: "Last Name",
                        controller: lastNameController,
                        keyboardType: TextInputType.name,
                        validator: (value) =>
                            AppValidators.validateFullName(value),
                      ),
                      SizedBox(height: 15.h),
                      CustomTextFormField(
                        labelText: "Your Email",
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                            AppValidators.validateEmail(value),
                      ),
                      SizedBox(height: 15.h),
                      CustomTextFormField(
                        labelText: "Phone Number",
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) => AppValidators.validateNotEmpty(
                          value,
                          'Phone number',
                        ),
                      ),
                      SizedBox(height: 30.h),
                      CustomButton(
                        buttonText: "Submit",
                        onTap: () async {
                          // if (_formKey.currentState!.validate()) {
                          await _saveSettings();
                          if (context.mounted) {
                            Get.back();
                          }
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
