// Archivo del alumno
// Este archivo es parte del trabajo realizado por el alumno y puede contener modificaciones.

import '../config/car_brands.dart';
import '../model/car_data.dart';
import '../model/user_data.dart';
import '../view/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  // Controladores de texto
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final licensePlateController = TextEditingController();
  final yearController = TextEditingController();
  final colorController = TextEditingController();
  final customBrandController = TextEditingController();
  final customModelController = TextEditingController();

  // Variables reactivas
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isNameValid = false.obs;
  final isEmailValid = false.obs;
  final isPhoneValid = false.obs;
  final isPasswordValid = false.obs;
  final isConfirmPasswordValid = false.obs;
  final isLicensePlateValid = false.obs;
  final isYearValid = false.obs;
  final isColorValid = false.obs;
  final isCustomBrandValid = false.obs;
  final isCustomModelValid = false.obs;
  final selectedBrand = ''.obs;
  final selectedModel = ''.obs;
  final isCustomBrand = false.obs;
  final isCustomModel = false.obs;

  // Listas de opciones
  final List<String> availableBrands = [
    'Subaru',
    'Toyota',
    'Honda',
    'Nissan',
    'Mitsubishi',
    'Otros'
  ];

  final List<String> availableModels = [
    'WRX',
    'Impreza',
    'Forester',
    'Outback',
    'Legacy',
    'Otros'
  ];

  // Validaciones
  void validateName() {
    isNameValid.value = nameController.text.length >= 3;
    validateForm();
  }

  void validateEmail() {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    isEmailValid.value = emailRegex.hasMatch(emailController.text);
    validateForm();
  }

  void validatePhone() {
    final phoneRegex = RegExp(r'^\+595\s?\d{10}$');
    isPhoneValid.value = phoneRegex.hasMatch(phoneController.text);
    validateForm();
  }

  void validatePassword() {
    final passwordRegex = RegExp(r'^(?=.*[A-Z].*[A-Z])(?=.*[a-z].*[a-z])(?=.*[!@#$&*])(?=.*[0-9].*[0-9]).{8,}$');
    isPasswordValid.value = passwordRegex.hasMatch(passwordController.text);
    validateForm();
  }

  void validateConfirmPassword() {
    isConfirmPasswordValid.value = passwordController.text == confirmPasswordController.text;
    validateForm();
  }

  void validateLicensePlate() {
    final plateRegex = RegExp(r'^[A-Z]{3}\d{3}$');
    isLicensePlateValid.value = plateRegex.hasMatch(licensePlateController.text);
    validateForm();
  }

  void validateYear() {
    final year = int.tryParse(yearController.text);
    isYearValid.value = year != null && year >= 1900 && year <= DateTime.now().year;
    validateForm();
  }

  void validateColor() {
    isColorValid.value = colorController.text.length >= 2;
    validateForm();
  }

  void validateCustomBrand() {
    isCustomBrandValid.value = customBrandController.text.length >= 2;
    validateForm();
  }

  void validateCustomModel() {
    isCustomModelValid.value = customModelController.text.length >= 2;
    validateForm();
  }

  // Validación del formulario completo
  final isFormValid = false.obs;

  void validateForm() {
    isFormValid.value = isNameValid.value &&
        isEmailValid.value &&
        isPhoneValid.value &&
        isPasswordValid.value &&
        isConfirmPasswordValid.value &&
        isLicensePlateValid.value &&
        isYearValid.value &&
        isColorValid.value &&
        (selectedBrand.value != 'Otros' || isCustomBrandValid.value) &&
        (selectedModel.value != 'Otros' || isCustomModelValid.value);
  }

  // Métodos para manejar la visibilidad de las contraseñas
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  // Métodos para manejar los dropdowns
  void onBrandChanged(String? value) {
    if (value != null) {
      selectedBrand.value = value;
      isCustomBrand.value = value == 'Otros';
      if (value != 'Otros') {
        selectedModel.value = '';
      }
    }
    validateForm();
  }

  void onModelChanged(String? value) {
    if (value != null) {
      selectedModel.value = value;
      isCustomModel.value = value == 'Otros';
    }
    validateForm();
  }

  // Método para el registro
  void signup() {
    if (isFormValid.value) {
      // Aquí iría la lógica de registro
      final userData = UserData(
        id: '', // Generar ID
        nombre: nameController.text.trim(),
        email: emailController.text.trim(),
        telefono: phoneController.text.trim(),
        password: passwordController.text, // Considerar hashing
      );

      final carData = CarData(
        brand: selectedBrand.value == 'Otros' ? customBrandController.text.trim() : selectedBrand.value,
        model: selectedModel.value == 'Otros' ? customModelController.text.trim() : selectedModel.value,
        licensePlate: licensePlateController.text.trim(),
        year: int.parse(yearController.text.trim()),
        color: colorController.text.trim(),
        observations: null, // Agregar campo de observaciones si es necesario
      );

      print('User Data: ${userData.toString()}');
      print('Car Data: ${carData.toString()}');

      Get.snackbar(
        'Registro exitoso',
        'Tu cuenta ha sido creada correctamente',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.offAllNamed('/login');
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Agregar listeners para validación en tiempo real
    nameController.addListener(validateName);
    emailController.addListener(validateEmail);
    phoneController.addListener(validatePhone);
    passwordController.addListener(validatePassword);
    confirmPasswordController.addListener(validateConfirmPassword);
    licensePlateController.addListener(validateLicensePlate);
    yearController.addListener(validateYear);
    colorController.addListener(validateColor);
    customBrandController.addListener(validateCustomBrand);
    customModelController.addListener(validateCustomModel);
  }

  @override
  void onClose() {
    // Limpiar los controladores
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    licensePlateController.dispose();
    yearController.dispose();
    colorController.dispose();
    customBrandController.dispose();
    customModelController.dispose();
    super.onClose();
  }
} 