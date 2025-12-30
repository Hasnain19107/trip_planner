import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/app_buttons.dart';
import '../../../../shared/widgets/app_dropdown_field.dart';
import '../../../../shared/widgets/app_text_fields.dart';
import '../providers/signup_providers.dart';

class LetsGetStartedScreen extends ConsumerStatefulWidget {
  const LetsGetStartedScreen({super.key});

  @override
  ConsumerState<LetsGetStartedScreen> createState() => _LetsGetStartedScreenState();
}

class _LetsGetStartedScreenState extends ConsumerState<LetsGetStartedScreen> {
  final _formKey = GlobalKey<FormState>();

  Future<void> selectDate(BuildContext context, TextEditingController dobController) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      // Format: YYYY-MM-DD
      dobController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final controllers = ref.watch(letsGetStartedControllersProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(24),
                // Titles
                Center(
                  child: Text(
                    "Let's Get Started!",
                    style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const Gap(8),
                Center(
                  child: Text(
                    "Create an account to TripPlanner",
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const Gap(32),

                // Name
                AppTextField(
                  label: "Name*",
                  hintText: "Enter your name",
                  controller: controllers.nameController,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Name is required' : null,
                ),
                const Gap(16),

                // Date of Birth
                AppTextField(
                  label: "Date of Birth",
                  hintText: "Select Date of Birth",
                  controller: controllers.dobController,
                  readOnly: true,
                  onTap: () => selectDate(context, controllers.dobController),
                  suffixIcon: const Icon(Icons.calendar_today_outlined,
                      color: AppColors.textSecondary),
                ),
                const Gap(16),

                // Select Country
                AppDropdownField(
                  label: "Select Country",
                  hintText: "Select Country",
                  controller: controllers.countryController,
                  items: const ['USA', 'India', 'UK', 'Australia', 'France'],
                ),
                const Gap(16),

                // Select Gender
                AppDropdownField(
                  label: "Select Gender",
                  hintText: "Select Gender",
                  controller: controllers.genderController,
                  items: const ['Male', 'Female', 'Other'],
                ),
                const Gap(16),

                // Select Language
                AppDropdownField(
                  label: "Select Language",
                  hintText: "Select Language",
                  controller: controllers.languageController,
                  items: const ['English', 'Spanish', 'French', 'German'],
                ),
                const Gap(40),

                // Create Button
                AppPrimaryButton(
                  text: 'Create',
                  onPressed: () {
                    if (controllers.validate(_formKey.currentState)) {
                      // Perform Create Logic (e.g., update profile)
                      // For now, navigate to Home
                      AppRoutes.navigateAndClearStack(context, AppRoutes.home);
                    }
                  },
                ),
                 const Gap(16),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Text(
                        "Alread have an account? ",
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          AppRoutes.navigateAndClearStack(context, AppRoutes.login);
                        },
                        child: Text(
                          "Log In",
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                 const Gap(24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
