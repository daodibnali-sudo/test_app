import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.subtitle,
    this.subtitleOnTop = false,

    this.filled = true,
    this.leading,
    this.trailing,
    this.image,

    this.height = 56,
    this.width = double.infinity,
    this.radius = 16,

    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1,
    this.gradient,

    this.textColor,
    this.iconColor,
    this.subtitleStyle,
    this.textStyle,
    this.textSize,
    this.fontWeight,
    this.textAlign = TextAlign.center,
    this.contentAlignment = MainAxisAlignment.center,

    this.iconSize = 22,
    this.gap = 8,
    this.subtitleGap = 2,

    this.iconBackgroundColor,
    this.iconBackgroundGradient,
    this.iconBorderColor,
    this.iconBorderWidth = 1,
    this.iconShape = BoxShape.circle,
    this.iconBorderRadius = 12,
    this.iconPadding = const EdgeInsets.all(8),

    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.enabled = true,
  });

  final String text;
  final String? subtitle;
  final bool subtitleOnTop;
  final VoidCallback? onPressed;

  final bool filled;
  final Widget? leading;
  final Widget? trailing;
  final ImageProvider? image;

  final double height;
  final double width;
  final double radius;

  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final Gradient? gradient;

  final Color? textColor;
  final Color? iconColor;

  final TextStyle? textStyle;
  final TextStyle? subtitleStyle;
  final double? textSize;
  final FontWeight? fontWeight;
  final TextAlign textAlign;
  final MainAxisAlignment contentAlignment;

  final double iconSize;
  final double gap;
  final double subtitleGap;

  final Color? iconBackgroundColor;
  final Gradient? iconBackgroundGradient;
  final Color? iconBorderColor;
  final double iconBorderWidth;
  final BoxShape iconShape;
  final double iconBorderRadius;
  final EdgeInsetsGeometry iconPadding;

  final EdgeInsetsGeometry padding;
  final bool enabled;

  CrossAxisAlignment get _textCrossAxisAlignment {
    if (textAlign == TextAlign.start || textAlign == TextAlign.left) {
      return CrossAxisAlignment.start;
    }

    if (textAlign == TextAlign.end || textAlign == TextAlign.right) {
      return CrossAxisAlignment.end;
    }

    return CrossAxisAlignment.center;
  }

  Widget _withIconBox(Widget child) {
    final isCircle = iconShape == BoxShape.circle;

    return Container(
      padding: iconPadding,
      decoration: BoxDecoration(
        shape: iconShape,
        color: iconBackgroundGradient == null ? iconBackgroundColor : null,
        gradient: iconBackgroundGradient,
        border: iconBorderColor == null
            ? null
            : Border.all(color: iconBorderColor!, width: iconBorderWidth),
        borderRadius: isCircle ? null : BorderRadius.circular(iconBorderRadius),
      ),
      child: IconTheme(
        data: IconThemeData(color: iconColor, size: iconSize),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasGradient = gradient != null;

    final titleWidget = Text(
      text,
      textAlign: textAlign,
      style:
          textStyle ??
          TextStyle(
            color: textColor,
            fontSize: textSize,
            fontWeight: fontWeight,
          ),
    );

    final subtitleWidget = subtitle == null
        ? null
        : Text(
            subtitle!,
            textAlign: textAlign,
            style:
                subtitleStyle ??
                TextStyle(
                  color: textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
          );

    final textColumn = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: _textCrossAxisAlignment,
      children: subtitleWidget == null
          ? [titleWidget]
          : subtitleOnTop
          ? [subtitleWidget, SizedBox(height: subtitleGap), titleWidget]
          : [titleWidget, SizedBox(height: subtitleGap), subtitleWidget],
    );

    final imageWidget = image == null
        ? null
        : ClipOval(
            child: Image(
              image: image!,
              width: iconSize,
              height: iconSize,
              fit: BoxFit.cover,
            ),
          );

    final child = Row(
      mainAxisAlignment: contentAlignment,
      mainAxisSize: MainAxisSize.max,
      children: [
        if (imageWidget != null) ...[
          _withIconBox(imageWidget),
          SizedBox(width: gap),
        ],
        if (leading != null) ...[_withIconBox(leading!), SizedBox(width: gap)],
        Flexible(child: textColumn),
        if (trailing != null) ...[
          SizedBox(width: gap),
          _withIconBox(trailing!),
        ],
      ],
    );

    final style = ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(
        hasGradient
            ? Colors.transparent
            : filled
            ? backgroundColor
            : Colors.transparent,
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

    final button = filled
        ? FilledButton(
            style: style,
            onPressed: enabled ? onPressed : null,
            child: child,
          )
        : OutlinedButton(
            style: style,
            onPressed: enabled ? onPressed : null,
            child: child,
          );

    return AnimatedOpacity(
      opacity: enabled ? 1 : 0.48,
      duration: const Duration(milliseconds: 150),
      child: SizedBox(
        width: width,
        height: height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: enabled ? gradient : null,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: button,
        ),
      ),
    );
  }
}
