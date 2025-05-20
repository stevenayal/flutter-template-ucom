import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
//login
  Rx<TextEditingController> mobileController = TextEditingController().obs;
  Rx<TextEditingController> pswdController = TextEditingController().obs;
  RxBool isVisible = false.obs;
  RxBool isPasswordValid = false.obs;
  RxBool isPhoneValid = false.obs;

  // Validación de teléfono
  bool validatePhone(String phone) {
    // Verifica que comience con 09 y tenga 10 dígitos
    final phoneRegex = RegExp(r'^09\d{8}$');
    return phoneRegex.hasMatch(phone);
  }

  // Validación de contraseña
  bool validatePassword(String password) {
    // Verifica que tenga al menos 2 mayúsculas
    final upperCaseRegex = RegExp(r'[A-Z]');
    final upperCaseCount = upperCaseRegex.allMatches(password).length;
    
    // Verifica que tenga minúsculas
    final lowerCaseRegex = RegExp(r'[a-z]');
    final hasLowerCase = lowerCaseRegex.hasMatch(password);
    
    // Verifica que tenga al menos un carácter especial
    final specialCharRegex = RegExp(r'[!@#\$%\^&\*(),.?":{}|<>]');
    final hasSpecialChar = specialCharRegex.hasMatch(password);

    return upperCaseCount >= 2 && hasLowerCase && hasSpecialChar;
  }

  // Actualiza el estado de validación del teléfono
  void updatePhoneValidation(String phone) {
    isPhoneValid.value = validatePhone(phone);
  }

  // Actualiza el estado de validación de la contraseña
  void updatePasswordValidation(String password) {
    isPasswordValid.value = validatePassword(password);
  }

  @override
  void onInit() {
    super.onInit();
    // Agregar listeners para validación en tiempo real
    mobileController.value.addListener(() {
      updatePhoneValidation(mobileController.value.text);
    });
    pswdController.value.addListener(() {
      updatePasswordValidation(pswdController.value.text);
    });
  }

  @override
  void onClose() {
    mobileController.value.dispose();
    pswdController.value.dispose();
    super.onClose();
  }
}
