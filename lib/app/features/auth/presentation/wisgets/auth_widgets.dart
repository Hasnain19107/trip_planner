import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Auth header widget with logo and title
class AuthHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? logo;

  const AuthHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.logo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (logo != null) ...[
          logo!,
          const SizedBox(height: 24),
        ],
        Text(
          title,
          style: AppTextStyles.h2.copyWith(
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

/// Social login buttons section
class SocialLoginSection extends StatelessWidget {
  final VoidCallback? onGooglePressed;
  final VoidCallback? onApplePressed;
  final VoidCallback? onFacebookPressed;
  final bool showDivider;
  final String dividerText;

  const SocialLoginSection({
    super.key,
    this.onGooglePressed,
    this.onApplePressed,
    this.onFacebookPressed,
    this.showDivider = true,
    this.dividerText = 'or continue with',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showDivider) ...[
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  dividerText,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 24),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (onGooglePressed != null)
              _SocialButton(
                icon: Icons.g_mobiledata,
                onPressed: onGooglePressed,
              ),
            if (onApplePressed != null) ...[
              const SizedBox(width: 16),
              _SocialButton(
                icon: Icons.apple,
                onPressed: onApplePressed,
              ),
            ],
            if (onFacebookPressed != null) ...[
              const SizedBox(width: 16),
              _SocialButton(
                icon: Icons.facebook,
                backgroundColor: const Color(0xFF1877F2),
                iconColor: Colors.white,
                onPressed: onFacebookPressed,
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;

  const _SocialButton({
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 56,
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(
            icon,
            size: 28,
            color: iconColor ?? AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

/// Auth footer with link to alternative action
class AuthFooter extends StatelessWidget {
  final String text;
  final String linkText;
  final VoidCallback onLinkPressed;

  const AuthFooter({
    super.key,
    required this.text,
    required this.linkText,
    required this.onLinkPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: onLinkPressed,
          child: Text(
            linkText,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

/// Password strength indicator
class PasswordStrengthIndicator extends StatelessWidget {
  final String password;

  const PasswordStrengthIndicator({
    super.key,
    required this.password,
  });

  int _calculateStrength() {
    if (password.isEmpty) return 0;
    int strength = 0;
    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[a-z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;
    return strength;
  }

  Color _getColor(int strength) {
    if (strength <= 1) return AppColors.error;
    if (strength <= 2) return Colors.orange;
    if (strength <= 3) return Colors.yellow.shade700;
    if (strength <= 4) return Colors.lightGreen;
    return AppColors.success;
  }

  String _getLabel(int strength) {
    if (strength <= 1) return 'Weak';
    if (strength <= 2) return 'Fair';
    if (strength <= 3) return 'Good';
    if (strength <= 4) return 'Strong';
    return 'Very Strong';
  }

  @override
  Widget build(BuildContext context) {
    final strength = _calculateStrength();
    final color = _getColor(strength);

    if (password.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          children: List.generate(5, (index) {
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: index < 4 ? 4 : 0),
                decoration: BoxDecoration(
                  color: index < strength ? color : AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 4),
        Text(
          _getLabel(strength),
          style: AppTextStyles.labelSmall.copyWith(color: color),
        ),
      ],
    );
  }
}
