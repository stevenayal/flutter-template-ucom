import 'package:finpay/config/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? textEditingController;
  final String? hintText;
  final TextInputType? inputType;
  final bool obscure;
  final Widget? prefix;
  final Widget? sufix;
  final List<TextInputFormatter>? limit;
  final TextCapitalization capitalization;
  final FocusNode? focusNode;
  final int? maxLines;

  const CustomTextFormField({
    super.key,
    this.textEditingController,
    this.hintText,
    this.inputType,
    this.obscure = false,
    this.prefix,
    this.sufix,
    this.limit,
    this.capitalization = TextCapitalization.none,
    this.focusNode,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: maxLines == 1 ? 56 : null,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffE8E8E8)),
        borderRadius: BorderRadius.circular(16),
        color: HexColor(AppTheme.secondaryColorString!),
      ),
      child: TextFormField(
        focusNode: focusNode,
        controller: textEditingController,
        obscureText: obscure,
        keyboardType: inputType,
        textCapitalization: capitalization,
        inputFormatters: limit,
        maxLines: maxLines,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: AppTheme.isLightTheme == false
                  ? const Color(0xffA2A0A8)
                  : const Color(0xff211F32),
            ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: const Color(0xffA2A0A8),
              ),
          prefixIcon: prefix,
          suffixIcon: sufix,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}
