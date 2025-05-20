// ignore_for_file: avoid_function_literals_in_foreach_calls, deprecated_member_use

import 'package:finpay/config/images.dart';
import 'package:finpay/controller/signup_controller.dart';
import 'package:finpay/view/country/country_residence_screen.dart';
import 'package:finpay/view/login/login_screen.dart';
import 'package:finpay/widgets/custom_button.dart';
import 'package:finpay/widgets/custom_textformfield.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../config/textstyle.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final signUpController = Get.put(SignUpController());
  final List<FocusNode> _focusNodes = List.generate(7, (_) => FocusNode());

  @override
  void initState() {
    signUpController.isVisible.value = false;
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
                  const SizedBox(height: 10),
                  Text(
                    "Comenzar",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "¡Crea una cuenta para continuar!",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: const Color(0xffA2A0A8),
                        ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        _buildCarDataSection(),
                        const SizedBox(height: 24),
                        _buildPersonalDataSection(),
                        const SizedBox(height: 24),
                        _buildTermsAndConditions(),
                        const SizedBox(height: 32),
                        _buildSignUpButton(context),
                        _buildLoginButton(context),
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

  Widget _buildCarDataSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Datos del Auto",
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          focusNode: _focusNodes[0],
          prefix: Padding(
            padding: const EdgeInsets.all(14.0),
            child: SvgPicture.asset(
              DefaultImages.car,
              color: _focusNodes[0].hasFocus
                  ? HexColor(AppTheme.primaryColorString!)
                  : const Color(0xffA2A0A8),
            ),
          ),
          hintText: "Marca del Auto",
          inputType: TextInputType.text,
          textEditingController: signUpController.brandController.value,
          capitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          focusNode: _focusNodes[1],
          prefix: Padding(
            padding: const EdgeInsets.all(14.0),
            child: SvgPicture.asset(
              DefaultImages.car,
              color: _focusNodes[1].hasFocus
                  ? HexColor(AppTheme.primaryColorString!)
                  : const Color(0xffA2A0A8),
            ),
          ),
          hintText: "Modelo del Auto",
          inputType: TextInputType.text,
          textEditingController: signUpController.modelController.value,
          capitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          focusNode: _focusNodes[2],
          prefix: Padding(
            padding: const EdgeInsets.all(14.0),
            child: SvgPicture.asset(
              DefaultImages.car,
              color: _focusNodes[2].hasFocus
                  ? HexColor(AppTheme.primaryColorString!)
                  : const Color(0xffA2A0A8),
            ),
          ),
          hintText: "Chapa del Auto",
          inputType: TextInputType.text,
          textEditingController: signUpController.plateController.value,
          capitalization: TextCapitalization.characters,
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          focusNode: _focusNodes[3],
          prefix: Padding(
            padding: const EdgeInsets.all(14.0),
            child: SvgPicture.asset(
              DefaultImages.car,
              color: _focusNodes[3].hasFocus
                  ? HexColor(AppTheme.primaryColorString!)
                  : const Color(0xffA2A0A8),
            ),
          ),
          hintText: "Observaciones (Color, Detalles, etc)",
          inputType: TextInputType.text,
          textEditingController: signUpController.observationsController.value,
          capitalization: TextCapitalization.sentences,
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildPersonalDataSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Datos Personales",
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          focusNode: _focusNodes[4],
          prefix: Padding(
            padding: const EdgeInsets.all(14.0),
            child: SvgPicture.asset(
              DefaultImages.userName,
              color: _focusNodes[4].hasFocus
                  ? HexColor(AppTheme.primaryColorString!)
                  : const Color(0xffA2A0A8),
            ),
          ),
          hintText: "Nombre Completo",
          inputType: TextInputType.text,
          textEditingController: signUpController.nameController.value,
          capitalization: TextCapitalization.words,
          limit: [
            FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]'))
          ],
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          focusNode: _focusNodes[5],
          prefix: Padding(
            padding: const EdgeInsets.all(14.0),
            child: SvgPicture.asset(
              DefaultImages.phone,
              color: _focusNodes[5].hasFocus
                  ? HexColor(AppTheme.primaryColorString!)
                  : const Color(0xffA2A0A8),
            ),
          ),
          hintText: "+595 9XX XXX XXX",
          inputType: TextInputType.phone,
          textEditingController: signUpController.mobileController.value,
          capitalization: TextCapitalization.none,
          limit: [
            LengthLimitingTextInputFormatter(12),
            FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() {
          return CustomTextFormField(
            focusNode: _focusNodes[6],
            sufix: InkWell(
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                signUpController.isVisible.value = !signUpController.isVisible.value;
              },
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Icon(
                  signUpController.isVisible.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: signUpController.isVisible.value
                      ? HexColor(AppTheme.primaryColorString!)
                      : const Color(0xffA2A0A8),
                ),
              ),
            ),
            prefix: Padding(
              padding: const EdgeInsets.all(14.0),
              child: SvgPicture.asset(
                DefaultImages.pswd,
                color: _focusNodes[6].hasFocus
                    ? HexColor(AppTheme.primaryColorString!)
                    : const Color(0xffA2A0A8),
              ),
            ),
            hintText: "Contraseña",
            obscure: !signUpController.isVisible.value,
            textEditingController: signUpController.pswdController.value,
            capitalization: TextCapitalization.none,
            limit: [
              FilteringTextInputFormatter.singleLineFormatter,
            ],
            inputType: TextInputType.visiblePassword,
          );
        }),
      ],
    );
  }

  Widget _buildTermsAndConditions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            setState(() {
              signUpController.isAgree.value = !signUpController.isAgree.value;
            });
          },
          child: Container(
            height: 24,
            width: 24,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffDCDBE0)),
              color: signUpController.isAgree.value
                  ? HexColor(AppTheme.primaryColorString!)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.check,
              size: 15,
              color: signUpController.isAgree.value
                  ? Colors.white
                  : Colors.transparent,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: "Al crear una cuenta, aceptas nuestros ",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: AppTheme.isLightTheme == false
                            ? const Color(0xffA2A0A8)
                            : const Color(0xff211F32),
                      ),
                ),
                TextSpan(
                  text: "Términos y Condiciones",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: HexColor(AppTheme.primaryColorString!),
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return Obx(() {
      return InkWell(
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          if (signUpController.isCarDataValid.value &&
              signUpController.isPersonalDataValid.value &&
              signUpController.isAgree.value) {
            // TODO: Implementar lógica de registro
            Get.to(
              const LoginScreen(),
              transition: Transition.rightToLeft,
              duration: const Duration(milliseconds: 500),
            );
          }
        },
        child: customButton(
          signUpController.isCarDataValid.value &&
                  signUpController.isPersonalDataValid.value &&
                  signUpController.isAgree.value
              ? HexColor(AppTheme.primaryColorString!)
              : Colors.grey,
          "Registrarse",
          HexColor(AppTheme.secondaryColorString!),
          context,
        ),
      );
    });
  }

  Widget _buildLoginButton(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        Get.to(
          const LoginScreen(),
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
              "¿Ya tienes una cuenta?",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: const Color(0xffA2A0A8),
                  ),
            ),
            const SizedBox(width: 4),
            Text(
              "Inicia sesión",
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
}
