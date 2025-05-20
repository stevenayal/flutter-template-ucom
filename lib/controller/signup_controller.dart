import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/car_data.dart';

class SignUpController extends GetxController {
  // Datos personales
  final nameController = TextEditingController().obs;
  final mobileController = TextEditingController().obs;
  final pswdController = TextEditingController().obs;
  
  // Datos del auto
  final brandController = TextEditingController().obs;
  final modelController = TextEditingController().obs;
  final plateController = TextEditingController().obs;
  final observationsController = TextEditingController().obs;

  // Estados
  final isVisible = false.obs;
  final isAgree = false.obs;
  final isCarDataValid = false.obs;
  final isPersonalDataValid = false.obs;

  // Validaciones
  void validatePhone(String value) {
    final phoneRegex = RegExp(r'^\+595[0-9]{8}$');
    final isValid = phoneRegex.hasMatch(value);
    updatePersonalDataValidation();
  }

  void validatePassword(String value) {
    final hasUpperCase = RegExp(r'[A-Z]').allMatches(value).length >= 2;
    final hasLowerCase = RegExp(r'[a-z]').hasMatch(value);
    final hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);
    
    final isValid = hasUpperCase && hasLowerCase && hasSpecialChar;
    updatePersonalDataValidation();
  }

  void validateCarData() {
    final isBrandValid = brandController.value.text.isNotEmpty;
    final isModelValid = modelController.value.text.isNotEmpty;
    final isPlateValid = plateController.value.text.isNotEmpty;
    
    isCarDataValid.value = isBrandValid && isModelValid && isPlateValid;
  }

  void updatePersonalDataValidation() {
    final isNameValid = nameController.value.text.isNotEmpty;
    final isPhoneValid = RegExp(r'^\+595[0-9]{8}$').hasMatch(mobileController.value.text);
    final isPasswordValid = RegExp(r'^(?=.*[A-Z].*[A-Z])(?=.*[a-z])(?=.*[!@#$%^&*(),.?":{}|<>]).*$')
        .hasMatch(pswdController.value.text);
    
    isPersonalDataValid.value = isNameValid && isPhoneValid && isPasswordValid;
  }

  CarData getCarData() {
    return CarData(
      brand: brandController.value.text,
      model: modelController.value.text,
      plate: plateController.value.text,
      observations: observationsController.value.text,
    );
  }

  @override
  void onInit() {
    super.onInit();
    // Agregar listeners para validación en tiempo real
    nameController.value.addListener(updatePersonalDataValidation);
    mobileController.value.addListener(() => validatePhone(mobileController.value.text));
    pswdController.value.addListener(() => validatePassword(pswdController.value.text));
    
    brandController.value.addListener(validateCarData);
    modelController.value.addListener(validateCarData);
    plateController.value.addListener(validateCarData);
  }

  @override
  void onClose() {
    // Limpiar listeners y controladores
    nameController.value.dispose();
    mobileController.value.dispose();
    pswdController.value.dispose();
    brandController.value.dispose();
    modelController.value.dispose();
    plateController.value.dispose();
    observationsController.value.dispose();
    super.onClose();
  }
}
