import 'package:flutter/material.dart';
import 'package:plexus_noc/core/constant/app_colors.dart';
import 'package:plexus_noc/core/extensions/responsive_extensions.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final int value;
  final IconData icon;
  final Color color;
  final int delayIndex;
  final AnimationController animationController;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.delayIndex,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardAnimation = CurvedAnimation(
      parent: animationController,
      curve: Interval(
        (delayIndex * 0.1).clamp(0.0, 1.0),
        1.0,
        curve: Curves.easeOutCubic,
      ),
    );

    return ScaleTransition(
      scale: Tween<double>(begin: 0.9, end: 1.0).animate(cardAnimation),
      child: FadeTransition(
        opacity: cardAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.surfaceDark
                : Colors.white,
            borderRadius: BorderRadius.circular(16.responsive(context)),
            border: Border.all(
              color: isDark ? color.withValues(alpha: 0.4) : color.withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          padding: EdgeInsets.all(14.responsive(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon in a rounded container
              Container(
                padding: EdgeInsets.all(8.responsive(context)),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: isDark ? 0.15 : 0.1),
                  borderRadius: BorderRadius.circular(10.responsive(context)),
                ),
                child: Icon(icon, color: color, size: 24.responsive(context)),
              ),
              const Spacer(),
              // Animated counter
              TweenAnimationBuilder<int>(
                tween: IntTween(begin: 0, end: value),
                duration: const Duration(seconds: 1),
                curve: Curves.easeOutCubic,
                builder: (context, currentValue, child) {
                  return Text(
                    currentValue.toString(),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  );
                },
              ),
              SizedBox(height: 2.responsive(context)),
              // Subtitle
              Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
