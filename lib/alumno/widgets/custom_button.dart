// Archivo del alumno
// Este archivo es parte del trabajo realizado por el alumno y puede contener modificaciones.

import 'package:flutter/material.dart';
import '../config/app_theme.dart' as theme;
import '../config/textstyle.dart' as text;

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String buttonText;
  final bool isPrimary;

  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.buttonText,
    this.isPrimary = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: isPrimary
          ? theme.AppTheme.primaryButtonStyle
          : theme.AppTheme.secondaryButtonStyle,
      child: Text(
        buttonText,
        style: text.AppTextStyle.textStyle16w600.copyWith(
          color: isPrimary ? Colors.white : theme.AppTheme.primaryColor,
        ),
      ),
    );
  }
} 