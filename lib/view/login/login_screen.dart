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
import 'package:finpay/utils/utiles.dart';
import 'package:flutter_svg/svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final loginController = Get.put(LoginController());
  final List<FocusNode> _focusNodes = List.generate(2, (index) => FocusNode());
  SvgPicture? phoneIcon;
  SvgPicture? lockIcon;
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    
    loginController.isVisible.value = false;
    _focusNodes.forEach((node) {
      node.addListener(_onFocusChange);
    });

    // Inicializar los iconos inmediatamente
    _initializeIcons();
  }

  Future<void> _initializeIcons() async {
    try {
      final phone = await _loadSvgAsset(DefaultImages.phone);
      final lock = await _loadSvgAsset(DefaultImages.pswd);
      
      if (mounted) {
        setState(() {
          phoneIcon = phone;
          lockIcon = lock;
          _isLoading = false;
        });
        _animationController.forward();
      }
    } catch (e) {
      print('Error loading SVG assets: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<SvgPicture> _loadSvgAsset(String assetName) async {
    return SvgPicture.asset(
      assetName,
      cacheColorFilter: true,
      placeholderBuilder: (context) => const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (var node in _focusNodes) {
      node.removeListener(_onFocusChange);
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return false;
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            color: AppTheme.isLightTheme == false
                ? const Color(0xff15141F)
                : const Color(0xffFFFFFF),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 38),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                        ],
                      ),
                    ),
                    Expanded(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextFormField(
          focusNode: _focusNodes[0],
          prefix: Padding(
            padding: const EdgeInsets.all(14.0),
            child: phoneIcon != null
                ? ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      _focusNodes[0].hasFocus
                          ? HexColor(AppTheme.primaryColorString!)
                          : const Color(0xffA2A0A8),
                      BlendMode.srcIn,
                    ),
                    child: phoneIcon!,
                  )
                : _buildIconPlaceholder(),
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
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextFormField(
          focusNode: _focusNodes[1],
          sufix: Obx(
            () => InkWell(
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
          ),
          prefix: Padding(
            padding: const EdgeInsets.all(14.0),
            child: lockIcon != null
                ? ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      _focusNodes[1].hasFocus
                          ? HexColor(AppTheme.primaryColorString!)
                          : const Color(0xffA2A0A8),
                      BlendMode.srcIn,
                    ),
                    child: lockIcon!,
                  )
                : _buildIconPlaceholder(),
          ),
          hintText: "Clave",
          inputType: TextInputType.text,
          textEditingController: loginController.pswdController.value,
          obscure: !loginController.isVisible.value,
          capitalization: TextCapitalization.none,
        ),
      ],
    );
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
    return InkWell(
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        Get.to(
          const TabScreen(),
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 500),
        );
      },
      child: customButton(
        HexColor(AppTheme.primaryColorString!),
        "Ingresar",
        HexColor(AppTheme.secondaryColorString!),
        context,
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        Get.to(
          const SignupScreen(),
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

  Widget _buildIconPlaceholder() {
    return const SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(strokeWidth: 2),
    );
  }
}
