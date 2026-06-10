import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,

    this.filled = true,

    this.leading,
    this.trailing,

    this.height = 56,
    this.width = double.infinity,
    this.radius = 16,

    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1,

    this.textColor,
    this.iconColor,

    this.textStyle,
    this.textSize,
    this.fontWeight,

    this.iconSize = 22,
    this.gap = 8,

    this.padding = const EdgeInsets.symmetric(horizontal: 16),

    this.enabled = true,
  });

  final String text;
  final VoidCallback? onPressed;

  final bool filled;

  final Widget? leading;
  final Widget? trailing;

  final double height;
  final double width;
  final double radius;

  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;

  final Color? textColor;
  final Color? iconColor;

  final TextStyle? textStyle;
  final double? textSize;
  final FontWeight? fontWeight;

  final double iconSize;
  final double gap;

  final EdgeInsetsGeometry padding;

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leading != null) ...[
          IconTheme(
            data: IconThemeData(color: iconColor, size: iconSize),
            child: leading!,
          ),
          SizedBox(width: gap),
        ],

        Text(
          text,
          style:
              textStyle ??
              TextStyle(
                color: textColor,
                fontSize: textSize,
                fontWeight: fontWeight,
              ),
        ),

        if (trailing != null) ...[
          SizedBox(width: gap),
          IconTheme(
            data: IconThemeData(color: iconColor, size: iconSize),
            child: trailing!,
          ),
        ],
      ],
    );

    final style = ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(
        filled ? backgroundColor : Colors.transparent,
      ),
      side: WidgetStatePropertyAll(
        BorderSide(
          color: borderColor ?? Colors.transparent,
          width: borderWidth,
        ),
      ),
      minimumSize: WidgetStatePropertyAll(Size(width, height)),
      fixedSize: WidgetStatePropertyAll(Size(width, height)),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      ),
      padding: WidgetStatePropertyAll(padding),
    );

    return AnimatedOpacity(
      opacity: enabled ? 1 : 0.48,
      duration: const Duration(milliseconds: 150),
      child: SizedBox(
        width: width,
        height: height,
        child: filled
            ? FilledButton(
                style: style,
                onPressed: enabled ? onPressed : null,
                child: child,
              )
            : OutlinedButton(
                style: style,
                onPressed: enabled ? onPressed : null,
                child: child,
              ),
      ),
    );
  }
}
