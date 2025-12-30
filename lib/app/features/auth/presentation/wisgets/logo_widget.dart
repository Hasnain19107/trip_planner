import 'package:flutter/material.dart';
import '../../../../core/constants/app_images.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppImages.logo,
      height: 120, // Adjust height as needed
      width: 120,
      fit: BoxFit.contain,
    );
  }
}
