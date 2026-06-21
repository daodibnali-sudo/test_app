import 'package:flutter/material.dart';
import 'package:chelnok_boxing_timer/shared/theme/app_colors.dart';

class ScrollCard extends StatelessWidget {
  const ScrollCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon,
    this.leading,
    this.onTap,
    this.onLongPress,
    this.isSelected = false,
    this.width = 136,
    this.height,
    this.radius = 8,
    this.iconSize = 22,
    this.imageSize = 22,
    this.gap = 3,
    this.padding = const EdgeInsets.all(10),
    this.margin = const EdgeInsets.only(right: 12),
    this.backgroundColor,
    this.borderColor,
    this.selectedBorderColor,
    this.borderWidth = 2,
    this.iconColor,
    this.titleStyle,
    this.subtitleStyle,
  });

  final String title;
  final String subtitle;

  final IconData? icon;
  final Widget? leading;

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isSelected;

  final double width;
  final double? height;
  final double radius;
  final double iconSize;
  final double imageSize;
  final double gap;
  final double borderWidth;

  final EdgeInsets padding;
  final EdgeInsetsGeometry margin;

  final Color? backgroundColor;
  final Color? borderColor;
  final Color? selectedBorderColor;
  final Color? iconColor;

  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor = isSelected
        ? selectedBorderColor ?? borderColor
        : borderColor;

    return AnimatedScale(
      scale: isSelected ? 0.97 : 1,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOutCubic,
      child: Container(
        width: width,
        height: height,
        margin: margin,
        child: Material(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(radius),
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            borderRadius: BorderRadius.circular(radius),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOutCubic,
              padding: padding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                boxShadow: AppColors.cardShadows,
                border: Border.all(
                  color: effectiveBorderColor ?? Colors.transparent,
                  width: AppColors.isLight ? 1 : borderWidth,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (leading != null)
                    SizedBox(
                      width: imageSize,
                      height: imageSize,
                      child: leading,
                    )
                  else if (icon != null)
                    Icon(icon, color: iconColor, size: iconSize),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: titleStyle,
                      ),
                      SizedBox(height: gap),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: subtitleStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
