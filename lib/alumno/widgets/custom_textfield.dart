// Archivo del alumno
// Este archivo es parte del trabajo realizado por el alumno y puede contener modificaciones.

import 'package:flutter/material.dart';
import '../config/app_theme.dart' as theme;

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData prefixIcon;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.prefixIcon,
    this.keyboardType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: theme.AppTheme.textFieldDecoration.copyWith(
        labelText: label,
        prefixIcon: Icon(prefixIcon, color: theme.AppTheme.primaryColor),
      ),
    );
  }
} 