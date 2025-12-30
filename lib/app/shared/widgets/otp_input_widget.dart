import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class OtpInputWidget extends StatelessWidget {
  final int length;
  final ValueChanged<String>? onCompleted;
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;

  const OtpInputWidget({
    super.key,
    this.length = 5,
    this.onCompleted,
    required this.controllers,
    required this.focusNodes,
  }) : assert(controllers.length == length, 'Controllers length must match length'),
       assert(focusNodes.length == length, 'FocusNodes length must match length');

  void _onChanged(String value, int index) {
    if (value.isNotEmpty) {
      // Move to next field if avaliable
      if (index < length - 1) {
        focusNodes[index + 1].requestFocus();
      } else {
        // Last field, trigger completion
        focusNodes[index].unfocus();
        if (onCompleted != null) {
          String code = controllers.map((c) => c.text).join();
          onCompleted!(code);
        }
      }
    } else {
      // Backspace handled implicitly by delete, but if logic needed for empty:
       if (index > 0) {
        focusNodes[index - 1].requestFocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        length,
        (index) => Container(
          width: 55.67, // Precise width from design
          height: 56,
          decoration: BoxDecoration(
            color: Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border), // Assuming border color remains or needs checking if specific
          ),
          child: Center(
            child: TextField(
              controller: controllers[index],
              focusNode: focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              style: AppTextStyles.h3, 
              decoration: const InputDecoration(
                counterText: '',
              
                isDense: true, 
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (value) => _onChanged(value, index),
              onSubmitted: (_) {
                 if (index < length - 1) {
                   focusNodes[index + 1].requestFocus();
                 }
              },
            ),
          ),
        ),
      ),
    );
  }
}
