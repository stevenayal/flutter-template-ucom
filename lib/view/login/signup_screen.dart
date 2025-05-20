import 'package:finpay/config/textstyle.dart';
import 'package:finpay/controller/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    return Scaffold(
      appBar: AppBar(
        title: Text('signup'.tr),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'personal_info'.tr,
                style: AppTextStyle.textStyle16w600,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: controller.nameController,
                label: 'name'.tr,
                hint: 'enter_name'.tr,
                prefixIcon: Icons.person,
                validator: (value) => controller.isNameValid.value ? null : 'invalid_name'.tr,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: controller.emailController,
                label: 'email'.tr,
                hint: 'enter_email'.tr,
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) => controller.isEmailValid.value ? null : 'invalid_email'.tr,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: controller.phoneController,
                label: 'phone'.tr,
                hint: '+595 9XXXXXXXX',
                prefixIcon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (value) => controller.isPhoneValid.value ? null : 'invalid_phone'.tr,
              ),
              const SizedBox(height: 15),
              _buildPasswordField(
                controller: controller.passwordController,
                label: 'password'.tr,
                hint: 'enter_password'.tr,
                isVisible: controller.isPasswordVisible,
                onToggle: controller.togglePasswordVisibility,
                validator: (value) => controller.isPasswordValid.value ? null : 'invalid_password'.tr,
              ),
              const SizedBox(height: 15),
              _buildPasswordField(
                controller: controller.confirmPasswordController,
                label: 'confirm_password'.tr,
                hint: 'confirm_password'.tr,
                isVisible: controller.isConfirmPasswordVisible,
                onToggle: controller.toggleConfirmPasswordVisibility,
                validator: (value) => controller.isConfirmPasswordValid.value ? null : 'passwords_dont_match'.tr,
              ),
              const SizedBox(height: 30),
              Text(
                'car_info'.tr,
                style: AppTextStyle.textStyle16w600,
              ),
              const SizedBox(height: 20),
              Obx(() => _buildDropdown(
                label: 'brand'.tr,
                value: controller.selectedBrand.value,
                items: controller.availableBrands,
                onChanged: controller.onBrandChanged,
              )),
              const SizedBox(height: 15),
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
              const SizedBox(height: 15),
              Obx(() => controller.isCustomModel.value
                ? _buildTextField(
                    controller: controller.customModelController,
                    label: 'custom_model'.tr,
                    hint: 'enter_model'.tr,
                    prefixIcon: Icons.directions_car,
                    validator: (value) => controller.isCustomModel.value ? null : 'invalid_model'.tr,
                  )
                : const SizedBox.shrink()),
              const SizedBox(height: 15),
              _buildTextField(
                controller: controller.licensePlateController,
                label: 'license_plate'.tr,
                hint: 'ABC123',
                prefixIcon: Icons.confirmation_number,
                textCapitalization: TextCapitalization.characters,
                validator: (value) => controller.isLicensePlateValid.value ? null : 'invalid_plate'.tr,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: controller.yearController,
                label: 'year'.tr,
                hint: 'YYYY',
                prefixIcon: Icons.calendar_today,
                keyboardType: TextInputType.number,
                validator: (value) => controller.isYearValid.value ? null : 'invalid_year'.tr,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: controller.colorController,
                label: 'color'.tr,
                hint: 'enter_color'.tr,
                prefixIcon: Icons.color_lens,
                validator: (value) => controller.isColorValid.value ? null : 'invalid_color'.tr,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: Obx(() => ElevatedButton(
                  onPressed: controller.isFormValid ? controller.signup : null,
                  child: Text('signup'.tr),
                )),
              ),
            ],
          ),
        ),
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
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(prefixIcon),
        border: const OutlineInputBorder(),
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
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(isVisible.value ? Icons.visibility_off : Icons.visibility),
          onPressed: onToggle,
        ),
        border: const OutlineInputBorder(),
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
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
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