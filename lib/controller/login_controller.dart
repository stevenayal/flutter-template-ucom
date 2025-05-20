import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
//login
  final mobileController = TextEditingController().obs;
  final pswdController = TextEditingController().obs;
  final isVisible = false.obs;
  final isPasswordValid = false.obs;
  final isPhoneValid = false.obs;

  void validatePhone(String value) {
    // Validar que el número comience con +595 y tenga 12 dígitos en total
    final phoneRegex = RegExp(r'^\+595[0-9]{8}$');
    isPhoneValid.value = phoneRegex.hasMatch(value);
  }

  void validatePassword(String value) {
    // Validar que la contraseña tenga al menos:
    // - 2 letras mayúsculas
    // - 1 letra minúscula
    // - 1 carácter especial
    final hasUpperCase = RegExp(r'[A-Z]').allMatches(value).length >= 2;
    final hasLowerCase = RegExp(r'[a-z]').hasMatch(value);
    final hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);
    
    isPasswordValid.value = hasUpperCase && hasLowerCase && hasSpecialChar;
  }

  void updatePasswordValidation() {
    validatePassword(pswdController.value.text);
  }

  void updatePhoneValidation() {
    validatePhone(mobileController.value.text);
  }

  @override
  void onInit() {
    super.onInit();
    // Agregar listeners para validación en tiempo real
    pswdController.value.addListener(updatePasswordValidation);
    mobileController.value.addListener(updatePhoneValidation);
  }

  @override
  void onClose() {
    // Limpiar listeners y controladores
    pswdController.value.removeListener(updatePasswordValidation);
    mobileController.value.removeListener(updatePhoneValidation);
    pswdController.value.dispose();
    mobileController.value.dispose();
    super.onClose();
  }
}
