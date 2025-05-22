// Archivo del alumno
// Este archivo es parte del trabajo realizado por el alumno y puede contener modificaciones.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  
  final isPasswordVisible = false.obs;
  final isPhoneValid = false.obs;
  final isPasswordValid = false.obs;
  final isFormValid = false.obs;
  final isLoading = false.obs;

  void validatePhone(String value) {
    // Validar que el número tenga 9 dígitos y comience con 9
    if (value.length == 9 && value.startsWith('9')) {
      isPhoneValid.value = true;
    } else {
      isPhoneValid.value = false;
    }
    validateForm();
  }

  void validatePassword(String value) {
    // Validar que la contraseña tenga al menos 6 caracteres
    isPasswordValid.value = value.length >= 6;
    validateForm();
  }

  void validateForm() {
    isFormValid.value = isPhoneValid.value && isPasswordValid.value;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    if (!isFormValid.value) return;

    try {
      isLoading.value = true;
      
      // Aquí iría la llamada a tu API de autenticación
      // Por ahora simulamos un delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Simular login exitoso
      // En un caso real, aquí guardarías el token y datos del usuario
      Get.offAllNamed('/home'); // Navegar a la pantalla principal
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al iniciar sesión. Por favor, intente nuevamente.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
} 