// ignore_for_file: avoid_function_literals_in_foreach_calls, deprecated_member_use

import 'package:finpay/config/images.dart';
import 'package:finpay/config/app_theme.dart' as theme;
import 'package:finpay/config/textstyle.dart';
import 'package:finpay/controller/signup_controller.dart';
import 'package:finpay/view/country/country_residence_screen.dart';
import 'package:finpay/view/login/login_screen.dart';
import 'package:finpay/widgets/custom_button.dart';
import 'package:finpay/widgets/custom_textformfield.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final controller = Get.put(SignupController());
  final List<FocusNode> _focusNodes = List.generate(7, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    _focusNodes.forEach((node) {
      node.addListener(() {
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    _focusNodes.forEach((node) => node.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: theme.AppTheme.textColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'signup'.tr,
          style: theme.AppTheme.subheadingStyle,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(theme.AppTheme.spacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo y título
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logo_ucom.png',
                      height: 80,
                    ),
                    SizedBox(height: theme.AppTheme.spacing),
                    Text(
                      'personal_info'.tr,
                      style: theme.AppTheme.headingStyle,
                    ),
                  ],
                ),
              ),
              SizedBox(height: theme.AppTheme.largeSpacing),

              // Campos de información personal
              _buildSection(
                title: 'personal_info'.tr,
                icon: Icons.person_outline,
                children: [
                  _buildTextField(
                    controller: controller.nameController,
                    label: 'name'.tr,
                    hint: 'enter_name'.tr,
                    prefixIcon: Icons.person,
                    validator: (value) => controller.isNameValid.value ? null : 'invalid_name'.tr,
                  ),
                  SizedBox(height: theme.AppTheme.spacing),
                  _buildTextField(
                    controller: controller.emailController,
                    label: 'email'.tr,
                    hint: 'enter_email'.tr,
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => controller.isEmailValid.value ? null : 'invalid_email'.tr,
                  ),
                  SizedBox(height: theme.AppTheme.spacing),
                  _buildTextField(
                    controller: controller.phoneController,
                    label: 'phone'.tr,
                    hint: '+595 9XXXXXXXX',
                    prefixIcon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    validator: (value) => controller.isPhoneValid.value ? null : 'invalid_phone'.tr,
                  ),
                  SizedBox(height: theme.AppTheme.spacing),
                  _buildPasswordField(
                    controller: controller.passwordController,
                    label: 'password'.tr,
                    hint: 'enter_password'.tr,
                    isVisible: controller.isPasswordVisible,
                    onToggle: controller.togglePasswordVisibility,
                    validator: (value) => controller.isPasswordValid.value ? null : 'invalid_password'.tr,
                  ),
                  SizedBox(height: theme.AppTheme.spacing),
                  _buildPasswordField(
                    controller: controller.confirmPasswordController,
                    label: 'confirm_password'.tr,
                    hint: 'confirm_password'.tr,
                    isVisible: controller.isConfirmPasswordVisible,
                    onToggle: controller.toggleConfirmPasswordVisibility,
                    validator: (value) => controller.isConfirmPasswordValid.value ? null : 'passwords_dont_match'.tr,
                  ),
                ],
              ),

              SizedBox(height: theme.AppTheme.largeSpacing),

              // Campos de información del vehículo
              _buildSection(
                title: 'car_info'.tr,
                icon: Icons.directions_car_outlined,
                children: [
                  Obx(() => _buildDropdown(
                    label: 'brand'.tr,
                    value: controller.selectedBrand.value,
                    items: controller.availableBrands,
                    onChanged: controller.onBrandChanged,
                  )),
                  SizedBox(height: theme.AppTheme.spacing),
                  Obx(() => controller.isCustomBrand.value
                    ? _buildTextField(
                        controller: controller.customBrandController,
                        label: 'custom_brand'.tr,
                        hint: 'enter_brand'.tr,
                        prefixIcon: Icons.directions_car,
                        validator: (value) => controller.isCustomBrand.value ? null : 'invalid_brand'.tr,
                      )
                    : _buildDropdown(
                        label: 'model'.tr,
                        value: controller.selectedModel.value,
                        items: controller.availableModels,
                        onChanged: controller.onModelChanged,
                      )),
                  SizedBox(height: theme.AppTheme.spacing),
                  Obx(() => controller.isCustomModel.value
                    ? _buildTextField(
                        controller: controller.customModelController,
                        label: 'custom_model'.tr,
                        hint: 'enter_model'.tr,
                        prefixIcon: Icons.directions_car,
                        validator: (value) => controller.isCustomModel.value ? null : 'invalid_model'.tr,
                      )
                    : const SizedBox.shrink()),
                  if (controller.isCustomModel.value)
                    SizedBox(height: theme.AppTheme.spacing),
                  _buildTextField(
                    controller: controller.licensePlateController,
                    label: 'license_plate'.tr,
                    hint: 'ABC123',
                    prefixIcon: Icons.confirmation_number,
                    textCapitalization: TextCapitalization.characters,
                    validator: (value) => controller.isLicensePlateValid.value ? null : 'invalid_plate'.tr,
                  ),
                  SizedBox(height: theme.AppTheme.spacing),
                  _buildTextField(
                    controller: controller.yearController,
                    label: 'year'.tr,
                    hint: 'YYYY',
                    prefixIcon: Icons.calendar_today,
                    keyboardType: TextInputType.number,
                    validator: (value) => controller.isYearValid.value ? null : 'invalid_year'.tr,
                  ),
                  SizedBox(height: theme.AppTheme.spacing),
                  _buildTextField(
                    controller: controller.colorController,
                    label: 'color'.tr,
                    hint: 'enter_color'.tr,
                    prefixIcon: Icons.color_lens,
                    validator: (value) => controller.isColorValid.value ? null : 'invalid_color'.tr,
                  ),
                ],
              ),

              SizedBox(height: theme.AppTheme.largeSpacing),

              // Botón de registro
              SizedBox(
                width: double.infinity,
                child: Obx(() => ElevatedButton(
                  onPressed: controller.isFormValid ? controller.signup : null,
                  style: theme.AppTheme.primaryButtonStyle,
                  child: Text(
                    'signup'.tr,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: theme.AppTheme.cardDecoration,
      padding: EdgeInsets.all(theme.AppTheme.spacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: theme.AppTheme.primaryColor),
              SizedBox(width: theme.AppTheme.smallSpacing),
              Text(title, style: theme.AppTheme.subheadingStyle),
            ],
          ),
          SizedBox(height: theme.AppTheme.spacing),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData prefixIcon,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: theme.AppTheme.textFieldDecoration.copyWith(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(prefixIcon, color: theme.AppTheme.primaryColor),
      ),
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      validator: validator,
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required RxBool isVisible,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return Obx(() => TextFormField(
      controller: controller,
      decoration: theme.AppTheme.textFieldDecoration.copyWith(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(Icons.lock, color: theme.AppTheme.primaryColor),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible.value ? Icons.visibility_off : Icons.visibility,
            color: theme.AppTheme.primaryColor,
          ),
          onPressed: onToggle,
        ),
      ),
      obscureText: !isVisible.value,
      validator: validator,
    ));
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value.isEmpty ? null : value,
      decoration: theme.AppTheme.textFieldDecoration.copyWith(
        labelText: label,
        prefixIcon: Icon(Icons.arrow_drop_down, color: theme.AppTheme.primaryColor),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
