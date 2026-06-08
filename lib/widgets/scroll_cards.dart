class ScrollCard extends StatelessWidget {
  const ScrollCard({
    super.key,
    required this.title,
    required this.subtitle,

    this.icon,
    this.leading,

    this.width = 145,
    this.radius = 8,
    this.iconSize = 26,
    this.imageSize = 26,
    this.padding = const EdgeInsets.all(14),

    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 2,

    this.iconColor,

    this.titleStyle,
    this.subtitleStyle,

    this.margin = const EdgeInsets.only(right: 12),
  });

  final IconData? icon;
  final Widget? leading;

  final String title;
  final String subtitle;

  final double width;
  final double radius;
  final double iconSize;
  final double imageSize;
  final double borderWidth;

  final EdgeInsets padding;
  final EdgeInsetsGeometry margin;

  final Color? backgroundColor;
  final Color? borderColor;
  final Color? iconColor;

  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: borderColor ?? Colors.transparent,
          width: borderWidth,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (leading != null)
            SizedBox(
              width: imageSize,
              height: imageSize,
              child: leading,
            )
          else if (icon != null)
            Icon(
              icon,
              color: iconColor,
              size: iconSize,
            ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: titleStyle,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: subtitleStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}