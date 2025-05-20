import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../controller/signup_controller.dart';
import '../../config/app_theme.dart' as theme;
import '../../config/textstyle.dart' as text;

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);

  final controller = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: theme.AppTheme.primaryColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Registro',
          style: text.AppTextStyle.textStyle16w600.copyWith(
            color: theme.AppTheme.primaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(theme.AppTheme.spacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/logo_ucom.png',
                  height: 100,
                ),
              ),
              SizedBox(height: theme.AppTheme.spacing * 2),
              _buildSection(
                title: 'Información Personal',
                icon: Icons.person_outline,
                children: [
                  _buildTextField(
                    controller: controller.nameController,
                    label: 'Nombre completo',
                    prefixIcon: Icons.person,
                  ),
                  SizedBox(height: theme.AppTheme.spacing),
                  _buildTextField(
                    controller: controller.emailController,
                    label: 'Correo electrónico',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: theme.AppTheme.spacing),
                  _buildTextField(
                    controller: controller.phoneController,
                    label: 'Teléfono',
                    prefixIcon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: theme.AppTheme.spacing),
                  _buildPasswordField(
                    controller: controller.passwordController,
                    label: 'Contraseña',
                  ),
                  SizedBox(height: theme.AppTheme.spacing),
                  _buildPasswordField(
                    controller: controller.confirmPasswordController,
                    label: 'Confirmar contraseña',
                  ),
                ],
              ),
              SizedBox(height: theme.AppTheme.spacing * 2),
              _buildSection(
                title: 'Información del Vehículo',
                icon: Icons.directions_car_outlined,
                children: [
                  _buildDropdown(
                    value: controller.selectedBrand.value,
                    items: controller.availableBrands,
                    label: 'Marca',
                    onChanged: controller.onBrandChanged,
                  ),
                  SizedBox(height: theme.AppTheme.spacing),
                  if (controller.selectedBrand.value == 'Otros')
                    _buildTextField(
                      controller: controller.customBrandController,
                      label: 'Especifique la marca',
                      prefixIcon: Icons.directions_car,
                    ),
                  SizedBox(height: theme.AppTheme.spacing),
                  _buildDropdown(
                    value: controller.selectedModel.value,
                    items: controller.availableModels,
                    label: 'Modelo',
                    onChanged: controller.onModelChanged,
                  ),
                  SizedBox(height: theme.AppTheme.spacing),
                  if (controller.selectedModel.value == 'Otros')
                    _buildTextField(
                      controller: controller.customModelController,
                      label: 'Especifique el modelo',
                      prefixIcon: Icons.directions_car,
                    ),
                  SizedBox(height: theme.AppTheme.spacing),
                  _buildTextField(
                    controller: controller.licensePlateController,
                    label: 'Placa',
                    prefixIcon: Icons.confirmation_number,
                  ),
                  SizedBox(height: theme.AppTheme.spacing),
                  _buildTextField(
                    controller: controller.yearController,
                    label: 'Año',
                    prefixIcon: Icons.calendar_today,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: theme.AppTheme.spacing),
                  _buildTextField(
                    controller: controller.colorController,
                    label: 'Color',
                    prefixIcon: Icons.color_lens,
                  ),
                ],
              ),
              SizedBox(height: theme.AppTheme.spacing * 2),
              Obx(() => ElevatedButton(
                    onPressed: controller.isFormValid ? controller.signup : null,
                    style: theme.AppTheme.primaryButtonStyle.copyWith(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.disabled)) {
                            return theme.AppTheme.lightTextColor.withOpacity(0.5);
                          }
                          return theme.AppTheme.primaryColor;
                        },
                      ),
                    ),
                    child: Text(
                      'Registrarse',
                      style: text.AppTextStyle.textStyle16w600.copyWith(color: Colors.white),
                    ),
                  )),
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
      padding: EdgeInsets.all(theme.AppTheme.spacing),
      decoration: theme.AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: theme.AppTheme.primaryColor),
              SizedBox(width: theme.AppTheme.smallSpacing),
              Text(
                title,
                style: text.AppTextStyle.textStyle16w600.copyWith(
                  color: theme.AppTheme.primaryColor,
                ),
              ),
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
    required IconData prefixIcon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: (value) {
        if (controller == this.controller.nameController) {
          this.controller.validateName();
        } else if (controller == this.controller.emailController) {
          this.controller.validateEmail();
        } else if (controller == this.controller.phoneController) {
          this.controller.validatePhone();
        } else if (controller == this.controller.licensePlateController) {
          this.controller.validateLicensePlate();
        } else if (controller == this.controller.yearController) {
          this.controller.validateYear();
        } else if (controller == this.controller.colorController) {
          this.controller.validateColor();
        } else if (controller == this.controller.customBrandController) {
          this.controller.validateCustomBrand();
        } else if (controller == this.controller.customModelController) {
          this.controller.validateCustomModel();
        }
      },
      decoration: theme.AppTheme.textFieldDecoration.copyWith(
        labelText: label,
        prefixIcon: Icon(prefixIcon, color: theme.AppTheme.primaryColor),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
  }) {
    final isPassword = controller == this.controller.passwordController;
    return Obx(() => TextField(
          controller: controller,
          obscureText: isPassword ? !this.controller.isPasswordVisible.value : !this.controller.isConfirmPasswordVisible.value,
          onChanged: (value) {
            if (isPassword) {
              this.controller.validatePassword();
            } else {
              this.controller.validateConfirmPassword();
            }
          },
          decoration: theme.AppTheme.textFieldDecoration.copyWith(
            labelText: label,
            prefixIcon: Icon(Icons.lock_outline, color: theme.AppTheme.primaryColor),
            suffixIcon: IconButton(
              icon: Icon(
                isPassword ? 
                  (this.controller.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off) :
                  (this.controller.isConfirmPasswordVisible.value ? Icons.visibility : Icons.visibility_off),
                color: theme.AppTheme.primaryColor,
              ),
              onPressed: isPassword ? 
                this.controller.togglePasswordVisibility : 
                this.controller.toggleConfirmPasswordVisibility,
            ),
          ),
        ));
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required String label,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: theme.AppTheme.spacing),
      decoration: BoxDecoration(
        border: Border.all(color: theme.AppTheme.lightTextColor),
        borderRadius: BorderRadius.circular(theme.AppTheme.borderRadius),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(label),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (String? newValue) {
            onChanged(newValue);
            if (newValue == 'Otros') {
              if (label == 'Marca') {
                this.controller.validateCustomBrand();
              } else {
                this.controller.validateCustomModel();
              }
            }
          },
        ),
      ),
    );
  }
} 