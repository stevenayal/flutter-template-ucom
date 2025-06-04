// ignore_for_file: deprecated_member_use

import 'package:finpay/config/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

Widget circleCard({String? image, String? title}) {
  Widget imageWidget;

  if (image != null && image.toLowerCase().endsWith('.svg')) {
    imageWidget = SvgPicture.asset(
      image,
      fit: BoxFit.fill,
      color: AppTheme.isLightTheme == false
          ? Colors.white
          : HexColor(AppTheme.primaryColorString!),
    );
  } else if (image != null) {
    imageWidget = Image.asset(
      image,
      fit: BoxFit.contain, // Use BoxFit.contain for PNGs
      // You might need to adjust the color or use a ColorFiltered if needed for light/dark theme
    );
  } else {
    imageWidget = const SizedBox(); // Placeholder if no image
  }

  return Column(
    children: [
      Container(
        height: 72,
        width: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.isLightTheme == false
              ? const Color(0xff211F32)
              : Colors.transparent,
          border: Border.all(
            color: HexColor(AppTheme.primaryColorString!).withOpacity(0.10),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 24, // Adjust size as needed
              width: 24, // Adjust size as needed
              child: imageWidget,
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 8,
      ),
      Text(
        title!,
        style: Theme.of(Get.context!).textTheme.bodyLarge!.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
      )
    ],
  );
}
