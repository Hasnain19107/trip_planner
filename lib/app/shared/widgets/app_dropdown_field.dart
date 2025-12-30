import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import 'app_text_fields.dart';

class AppDropdownField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final List<String> items;
  final ValueChanged<String?>? onChanged;
  final FormFieldValidator<String>? validator;

  const AppDropdownField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    required this.items,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return MenuAnchor(
              style: MenuStyle(
                minimumSize: MaterialStateProperty.all(Size(constraints.maxWidth, 0)),
                maximumSize: MaterialStateProperty.all(Size(constraints.maxWidth, 300)), // Limit height if needed
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                backgroundColor: MaterialStateProperty.all(AppColors.surface),
                elevation: MaterialStateProperty.all(4),
              ),
              builder: (context, menuController, child) {
                return AppTextField(
                  label: label,
                  hintText: hintText,
                  controller: controller,
                  readOnly: true,
                  onTap: () {
                    FocusScope.of(context).unfocus(); // Close keyboard to allow space for menu
                    if (menuController.isOpen) {
                      menuController.close();
                    } else {
                      menuController.open();
                    }
                  },
                  validator: validator ?? (value) {
                    if (value == null || value.isEmpty) {
                      return '$label is required';
                    }
                     return null;
                  },
                  suffixIcon: const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
                  ),
                );
              },
              menuChildren: items.map((item) {
                final isSelected = controller.text == item;
                return MenuItemButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith((states) {
                      if (isSelected) return AppColors.primary.withValues(alpha: 0.1);
                      if (states.contains(MaterialState.hovered)) return AppColors.background;
                      return null;
                    }),
                    textStyle: MaterialStateProperty.all(
                      AppTextStyles.bodyMedium.copyWith(
                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  onPressed: () {
                    controller.text = item;
                    onChanged?.call(item);
                  },
                  child: Container(
                    width: constraints.maxWidth - 32, 
                    child: Text(item),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
