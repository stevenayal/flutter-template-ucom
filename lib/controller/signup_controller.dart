import 'package:finpay/config/car_brands.dart';
import 'package:finpay/model/car_data.dart';
import 'package:finpay/model/user_data.dart';
import 'package:finpay/view/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  // Controllers para los campos de texto
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController customBrandController = TextEditingController();
  final TextEditingController customModelController = TextEditingController();
  final TextEditingController licensePlateController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController colorController = TextEditingController();

  // Variables reactivas
  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
  final RxBool isPasswordValid = false.obs;
  final RxBool isPhoneValid = false.obs;
  final RxBool isEmailValid = false.obs;
  final RxBool isNameValid = false.obs;
  final RxBool isConfirmPasswordValid = false.obs;
  final RxBool isLicensePlateValid = false.obs;
  final RxBool isYearValid = false.obs;
  final RxBool isColorValid = false.obs;
  final RxBool isCustomBrand = false.obs;
  final RxBool isCustomModel = false.obs;

  // Variables para la selección de marca y modelo
  final RxString selectedBrand = ''.obs;
  final RxString selectedModel = ''.obs;
  final RxList<String> availableModels = <String>[].obs;
  final RxList<String> availableBrands = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    availableBrands.value = CarBrands.getBrands();
    
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
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    customBrandController.dispose();
    customModelController.dispose();
    licensePlateController.dispose();
    yearController.dispose();
    colorController.dispose();
    super.onClose();
  }

  void validateName() {
    isNameValid.value = nameController.text.length >= 3;
  }

  void validateEmail() {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    isEmailValid.value = emailRegex.hasMatch(emailController.text);
  }

  void validatePhone() {
    final phoneRegex = RegExp(r'^\+595\s?9\d{8}$');
    isPhoneValid.value = phoneRegex.hasMatch(phoneController.text);
  }

  void validatePassword() {
    final hasUpperCase = RegExp(r'[A-Z]').hasMatch(passwordController.text);
    final hasLowerCase = RegExp(r'[a-z]').hasMatch(passwordController.text);
    final hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(passwordController.text);
    final hasMinLength = passwordController.text.length >= 8;
    
    isPasswordValid.value = hasUpperCase && hasLowerCase && hasSpecialChar && hasMinLength;
  }

  void validateConfirmPassword() {
    isConfirmPasswordValid.value = confirmPasswordController.text == passwordController.text;
  }

  void validateLicensePlate() {
    final plateRegex = RegExp(r'^[A-Z]{3}\d{3}$');
    isLicensePlateValid.value = plateRegex.hasMatch(licensePlateController.text);
  }

  void validateYear() {
    final year = int.tryParse(yearController.text);
    final currentYear = DateTime.now().year;
    isYearValid.value = year != null && year >= 1900 && year <= currentYear;
  }

  void validateColor() {
    isColorValid.value = colorController.text.length >= 3;
  }

  void validateCustomBrand() {
    isCustomBrand.value = customBrandController.text.length >= 2;
  }

  void validateCustomModel() {
    isCustomModel.value = customModelController.text.length >= 2;
  }

  void onBrandChanged(String? brand) {
    if (brand == null) return;
    
    selectedBrand.value = brand;
    if (brand == 'Otros') {
      isCustomBrand.value = true;
      availableModels.value = [];
      selectedModel.value = '';
    } else {
      isCustomBrand.value = false;
      availableModels.value = CarBrands.getModelsForBrand(brand);
      availableModels.add('Otros');
    }
  }

  void onModelChanged(String? model) {
    if (model == null) return;
    
    selectedModel.value = model;
    if (model == 'Otros') {
      isCustomModel.value = true;
    } else {
      isCustomModel.value = false;
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  bool get isFormValid {
    return isNameValid.value &&
           isEmailValid.value &&
           isPhoneValid.value &&
           isPasswordValid.value &&
           isConfirmPasswordValid.value &&
           isLicensePlateValid.value &&
           isYearValid.value &&
           isColorValid.value &&
           ((selectedBrand.value.isNotEmpty && selectedModel.value.isNotEmpty) ||
            (isCustomBrand.value && isCustomModel.value));
  }

  void signup() {
    if (!isFormValid) return;

    final userData = UserData(
      name: nameController.text,
      email: emailController.text,
      phone: phoneController.text,
      password: passwordController.text,
    );

    final carData = CarData(
      brand: isCustomBrand.value ? customBrandController.text : selectedBrand.value,
      model: isCustomModel.value ? customModelController.text : selectedModel.value,
      licensePlate: licensePlateController.text,
      year: int.parse(yearController.text),
      color: colorController.text,
    );

    // TODO: Implementar la lógica de registro
    print('User Data: $userData');
    print('Car Data: $carData');

    // Navegar a la pantalla de login
    Get.offAll(() => const LoginScreen());
  }
}
