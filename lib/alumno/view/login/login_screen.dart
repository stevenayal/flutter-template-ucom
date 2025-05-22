// Archivo del alumno
// Este archivo es parte del trabajo realizado por el alumno y puede contener modificaciones.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart'; // Importar para FilteringTextInputFormatter
import 'package:flutter_svg/flutter_svg.dart';
import '../../controller/login_controller.dart';
import '../../config/app_theme.dart' as theme;
import '../../config/textstyle.dart' as text;
// Assuming PasswordRecoveryScreen is outside alumno for now, keep original import if necessary, otherwise create it in alumno
// import '../../../view/login/password_recovery_screen.dart';
// Consider importing custom widgets from alumno if applicable (CustomTextField, CustomButton)

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    // Ensure the phone controller starts with '+595 '
    if (controller.phoneController.text.isEmpty) {
      controller.phoneController.text = '+595 ';
      // Position cursor at the end of the text
      controller.phoneController.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.phoneController.text.length));
    }

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
          'Login',
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
              Obx(() => TextField(
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(9),
                ],
                onChanged: (value) => controller.validatePhone(value),
                decoration: theme.AppTheme.textFieldDecoration.copyWith(
                  labelText: 'Teléfono',
                  prefixIcon: Icon(Icons.phone, color: theme.AppTheme.primaryColor),
                  hintText: '9XXXXXXXX',
                  errorText: controller.isPhoneValid.value || controller.phoneController.text.isEmpty 
                    ? null 
                    : 'Número inválido (ej: 9XXXXXXXX)',
                ),
              )),
              SizedBox(height: theme.AppTheme.spacing),
              Obx(() => TextField(
                controller: controller.passwordController,
                obscureText: !controller.isPasswordVisible.value,
                onChanged: (value) => controller.validatePassword(value),
                decoration: theme.AppTheme.textFieldDecoration.copyWith(
                  labelText: 'Contraseña',
                  prefixIcon: Icon(Icons.lock_outline, color: theme.AppTheme.primaryColor),
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                      color: theme.AppTheme.primaryColor,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                  errorText: controller.isPasswordValid.value || controller.passwordController.text.isEmpty 
                    ? null 
                    : 'La contraseña debe tener al menos 6 caracteres',
                ),
              )),
              SizedBox(height: theme.AppTheme.largeSpacing),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Get.toNamed('/password-recovery');
                  },
                  child: Text(
                    '¿Olvidaste tu contraseña?',
                    style: text.AppTextStyle.textStyle12w400.copyWith(
                      color: theme.AppTheme.primaryColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: theme.AppTheme.largeSpacing),
              Obx(() => ElevatedButton(
                onPressed: controller.isFormValid.value && !controller.isLoading.value
                    ? () => controller.login()
                    : null,
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
                child: controller.isLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        'Iniciar Sesión',
                        style: text.AppTextStyle.textStyle16w600.copyWith(color: Colors.white),
                      ),
              )),
              SizedBox(height: theme.AppTheme.spacing * 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¿No tienes cuenta?',
                    style: text.AppTextStyle.textStyle14w400.copyWith(color: theme.AppTheme.textColor),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.toNamed('/signup');
                    },
                    child: Text(
                      'Regístrate',
                      style: text.AppTextStyle.textStyle14w400.copyWith(
                        color: theme.AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 