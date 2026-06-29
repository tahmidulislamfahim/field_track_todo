import 'package:field_track_todo/core/common/app_color.dart';
import 'package:field_track_todo/core/widgets/custom_button.dart';
import 'package:field_track_todo/core/widgets/custom_text_form_field.dart';
import 'package:field_track_todo/features/auth/registration/controller/registration_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Instantiate RegistrationScreenController
    final controller = Get.put(RegistrationScreenController());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Form(
              key: controller.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: theme.primaryColor.withValues(alpha: 0.2),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: isDark
                          ? AppColors.darkBackground
                          : AppColors.lightBackground,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Create your account',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    'Join your team on FieldTrack',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 15,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 36),

                  CustomTextFormField(
                    controller: controller.nameController,
                    labelText: 'Full name',
                    hintText: 'John Doe',
                    prefixIcon: const Icon(Icons.person_outline),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    validator: controller.validateName,
                  ),
                  const SizedBox(height: 20),

                  CustomTextFormField(
                    controller: controller.emailController,
                    labelText: 'Email',
                    hintText: 'john.doe@example.com',
                    prefixIcon: const Icon(Icons.mail_outline),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: controller.validateEmail,
                  ),
                  const SizedBox(height: 20),

                  Obx(
                    () => CustomTextFormField(
                      controller: controller.passwordController,
                      labelText: 'Password',
                      hintText: 'Create a password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      obscureText: !controller.isPasswordVisible.value,
                      validator: controller.validatePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordVisible.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                        splashRadius: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),

                  Obx(() {
                    return CustomButton(
                      text: 'Create account',
                      isLoading: controller.isLoading.value,
                      onPressed: controller.register,
                    );
                  }),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Text(
                          'Sign in',
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
