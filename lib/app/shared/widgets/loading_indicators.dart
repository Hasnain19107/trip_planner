import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// Standard circular loading indicator
class AppLoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;
  final double strokeWidth;

  const AppLoadingIndicator({
    super.key,
    this.size = 40,
    this.color,
    this.strokeWidth = 3,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppColors.primary,
        ),
      ),
    );
  }
}

/// Full screen loading overlay
class AppFullScreenLoader extends StatelessWidget {
  final String? message;
  final Color? backgroundColor;
  final Color? indicatorColor;

  const AppFullScreenLoader({
    super.key,
    this.message,
    this.backgroundColor,
    this.indicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? Colors.black54,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppLoadingIndicator(
              color: indicatorColor ?? AppColors.textOnPrimary,
              size: 48,
            ),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textOnPrimary,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Loading indicator for inline content (e.g., in a button or list)
class AppInlineLoader extends StatelessWidget {
  final double size;
  final Color? color;

  const AppInlineLoader({
    super.key,
    this.size = 20,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppColors.primary,
        ),
      ),
    );
  }
}

/// Pulsing dots loading indicator
class AppDotsLoader extends StatefulWidget {
  final double dotSize;
  final Color? color;
  final int dotCount;
  final Duration animationDuration;

  const AppDotsLoader({
    super.key,
    this.dotSize = 10,
    this.color,
    this.dotCount = 3,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<AppDotsLoader> createState() => _AppDotsLoaderState();
}

class _AppDotsLoaderState extends State<AppDotsLoader>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.dotCount,
      (index) => AnimationController(
        vsync: this,
        duration: widget.animationDuration,
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    _startAnimation();
  }

  void _startAnimation() async {
    while (mounted) {
      for (var i = 0; i < widget.dotCount; i++) {
        if (!mounted) return;
        await _controllers[i].forward();
        await _controllers[i].reverse();
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.dotCount, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: widget.dotSize / 4),
              width: widget.dotSize,
              height: widget.dotSize + (_animations[index].value * widget.dotSize / 2),
              decoration: BoxDecoration(
                color: (widget.color ?? AppColors.primary)
                    .withValues(alpha: 0.5 + _animations[index].value * 0.5),
                borderRadius: BorderRadius.circular(widget.dotSize / 2),
              ),
            );
          },
        );
      }),
    );
  }
}

/// Shimmer loading effect for placeholder content
class AppShimmerLoader extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const AppShimmerLoader({
    super.key,
    this.width = double.infinity,
    this.height = 20,
    this.borderRadius = 8,
  });

  @override
  State<AppShimmerLoader> createState() => _AppShimmerLoaderState();
}

class _AppShimmerLoaderState extends State<AppShimmerLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value + 1, 0),
              colors: [
                Colors.grey.shade300,
                Colors.grey.shade100,
                Colors.grey.shade300,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}

/// Card shimmer loader for list items
class AppCardShimmer extends StatelessWidget {
  const AppCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const AppShimmerLoader(
                  width: 48,
                  height: 48,
                  borderRadius: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppShimmerLoader(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 16,
                      ),
                      const SizedBox(height: 8),
                      AppShimmerLoader(
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: 12,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const AppShimmerLoader(height: 14),
            const SizedBox(height: 8),
            const AppShimmerLoader(height: 14),
            const SizedBox(height: 8),
            AppShimmerLoader(
              width: MediaQuery.of(context).size.width * 0.6,
              height: 14,
            ),
          ],
        ),
      ),
    );
  }
}

/// Center loading widget with optional message
class CenteredLoader extends StatelessWidget {
  final String? message;

  const CenteredLoader({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AppLoadingIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
