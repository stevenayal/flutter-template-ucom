// Archivo del alumno
// Este archivo es parte del trabajo realizado por el alumno y puede contener modificaciones.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  
  final isPasswordVisible = false.obs;
  final isPhoneValid = true.obs; // Siempre válido
  final isPasswordValid = true.obs; // Siempre válido
  final isFormValid = true.obs; // Siempre válido

  void validatePhone(String value) {
    // Validación eliminada
    isPhoneValid.value = true;
    validateForm();
  }

  void validatePassword(String value) {
    // Validación eliminada
    isPasswordValid.value = true;
    validateForm();
  }

  void validateForm() {
    // La forma siempre es válida al eliminar validaciones
    isFormValid.value = true;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  @override
  void onInit() {
    super.onInit();
    // Ya no es necesario añadir listeners si no hay validación
    // phoneController.addListener(() => validatePhone(phoneController.text));
    // passwordController.addListener(() => validatePassword(passwordController.text));
  }

  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
} 