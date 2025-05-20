// ignore_for_file: avoid_function_literals_in_foreach_calls, library_private_types_in_public_api, deprecated_member_use

import 'package:finpay/config/images.dart';
import 'package:finpay/controller/login_controller.dart';
import 'package:finpay/view/signup/signup_screen.dart';
import 'package:finpay/view/tab_screen.dart';
import 'package:finpay/widgets/custom_button.dart';
import 'package:finpay/widgets/custom_textformfield.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../config/textstyle.dart';
import 'password_recovery_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final loginController = Get.put(LoginController());
  final List<FocusNode> _focusNodes = [
    FocusNode(),
    FocusNode(),
  ];

  @override
  void initState() {
    loginController.isVisible.value = false;
    _focusNodes.forEach((node) {
      node.addListener(() {
        setState(() {});
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return false;
        },
        child: InkWell(
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            color: AppTheme.isLightTheme == false
                ? const Color(0xff15141F)
                : const Color(0xffFFFFFF),
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: AppBar().preferredSize.height,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 38),
                  Text(
                    "¡Bienvenido!",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Ingresa a tu cuenta",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: const Color(0xffA2A0A8),
                        ),
                  ),
                  Expanded(
                    child: ListView(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        Column(
                          children: [
                            const SizedBox(height: 30),
                            _buildPhoneField(),
                            const SizedBox(height: 24),
                            _buildPasswordField(),
                            const SizedBox(height: 16),
                            _buildForgotPasswordButton(context),
                            const SizedBox(height: 32),
                            _buildLoginButton(),
                            _buildSignUpButton(context),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildDivider(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            focusNode: _focusNodes[0],
            prefix: Padding(
              padding: const EdgeInsets.all(14.0),
              child: SvgPicture.asset(
                DefaultImages.phone,
                color: _focusNodes[0].hasFocus
                    ? HexColor(AppTheme.primaryColorString!)
                    : const Color(0xffA2A0A8),
              ),
            ),
            hintText: "+595 9XX XXX XXX",
            inputType: TextInputType.phone,
            textEditingController: loginController.mobileController.value,
            capitalization: TextCapitalization.none,
            limit: [
              LengthLimitingTextInputFormatter(12),
              FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
            ],
          ),
          if (!loginController.isPhoneValid.value &&
              loginController.mobileController.value.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 16.0),
              child: Text(
                "El número debe comenzar con +595 y tener 8 dígitos después",
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildPasswordField() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            focusNode: _focusNodes[1],
            sufix: InkWell(
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                loginController.isVisible.value = !loginController.isVisible.value;
              },
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Icon(
                  loginController.isVisible.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: loginController.isVisible.value
                      ? HexColor(AppTheme.primaryColorString!)
                      : const Color(0xffA2A0A8),
                ),
              ),
            ),
            prefix: Padding(
              padding: const EdgeInsets.all(14.0),
              child: SvgPicture.asset(
                DefaultImages.pswd,
                color: _focusNodes[1].hasFocus
                    ? HexColor(AppTheme.primaryColorString!)
                    : const Color(0xffA2A0A8),
              ),
            ),
            hintText: "Clave",
            obscure: !loginController.isVisible.value,
            textEditingController: loginController.pswdController.value,
            capitalization: TextCapitalization.none,
            limit: [
              FilteringTextInputFormatter.singleLineFormatter,
            ],
            inputType: TextInputType.visiblePassword,
          ),
          if (!loginController.isPasswordValid.value &&
              loginController.pswdController.value.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 16.0),
              child: Text(
                "La contraseña debe tener al menos 2 mayúsculas, minúsculas y un carácter especial",
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildForgotPasswordButton(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        Get.to(
          const PasswordRecoveryScreen(),
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 500),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "¿Olvidaste tu contraseña?",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: HexColor(AppTheme.primaryColorString!),
                ),
          )
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return Obx(() {
      return InkWell(
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          if (loginController.isPhoneValid.value &&
              loginController.isPasswordValid.value) {
            Get.to(
              const TabScreen(),
              transition: Transition.rightToLeft,
              duration: const Duration(milliseconds: 500),
            );
          }
        },
        child: customButton(
          loginController.isPhoneValid.value &&
                  loginController.isPasswordValid.value
              ? HexColor(AppTheme.primaryColorString!)
              : Colors.grey,
          "Ingresar",
          HexColor(AppTheme.secondaryColorString!),
          context,
        ),
      );
    });
  }

  Widget _buildSignUpButton(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        Get.to(
          const SignUpScreen(),
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 500),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "¿No tienes una cuenta?",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: const Color(0xffA2A0A8),
                  ),
            ),
            const SizedBox(width: 4),
            Text(
              "Regístrate",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: HexColor(AppTheme.primaryColorString!),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: const Color(0xffE8E8E8),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: const Color(0xffE8E8E8),
          ),
        )
      ],
    );
  }
}
