import 'package:flutter/material.dart';
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

    // Staggered entrance for each card based on its index
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
        child: Card(
          elevation: isDark ? 0 : 4,
          shadowColor: color.withValues(alpha: 0.2), // Themed shadow
          child: Padding(
            padding: EdgeInsets.all(16.0.responsive(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Glowing Icon Header
                Container(
                  padding: EdgeInsets.all(12.responsive(context)),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16.responsive(context)),
                  ),
                  child: Icon(icon, color: color, size: 32.responsive(context)),
                ),
                SizedBox(height: 16.responsive(context)),
                // Number Counter Widget
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                    SizedBox(height: 4.responsive(context)),
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
