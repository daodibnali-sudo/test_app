import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chelnok_boxing_timer/features/timer/formatters/timer_formatter.dart';
import 'package:chelnok_boxing_timer/features/timer/models/timer_block.dart';
import 'package:chelnok_boxing_timer/shared/theme/app_colors.dart';
import 'package:chelnok_boxing_timer/shared/theme/app_fonts.dart';

class CustomBlockCard extends StatelessWidget {
  const CustomBlockCard({
    super.key,
    required this.index,
    required this.block,
    required this.isRestSuggestion,
    required this.onEdit,
    required this.onAcceptRest,
    required this.onRejectRest,
    required this.onDelete,
  });

  final int index;
  final TimerBlock block;
  final bool isRestSuggestion;
  final VoidCallback onEdit;
  final VoidCallback onAcceptRest;
  final VoidCallback onRejectRest;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isRestSuggestion ? Colors.transparent : AppColors.blackShadow,
        borderRadius: BorderRadius.circular(8),
        border: isRestSuggestion
            ? null
            : Border.all(color: AppColors.controlBorder),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 12),
            child: _TwoStripeHandle(),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: InkWell(
              onTap: isRestSuggestion ? null : onEdit,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isRestSuggestion ? 'Suggested rest' : block.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: isRestSuggestion ? 14 : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatTime(block.durationMs),
                      style: AppTextStyles.label,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isRestSuggestion) ...[
            _compactIconButton(
              icon: Icons.check,
              color: AppColors.success,
              tooltip: 'Accept rest',
              onPressed: onAcceptRest,
            ),
            _compactIconButton(
              icon: Icons.close,
              color: AppColors.error,
              tooltip: 'Reject rest',
              onPressed: onRejectRest,
            ),
          ] else
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
              color: AppColors.error,
              tooltip: 'Delete block',
            ),
        ],
      ),
    );

    final decoratedCard = isRestSuggestion
        ? CustomPaint(painter: _DashedBorderPainter(), child: card)
        : card;

    return ReorderableDelayedDragStartListener(
      index: index,
      child: decoratedCard,
    );
  }

  Widget _compactIconButton({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      color: color,
      iconSize: 20,
      constraints: const BoxConstraints.tightFor(width: 34, height: 34),
      padding: EdgeInsets.zero,
      tooltip: tooltip,
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 8.0;
    const dashGap = 5.0;
    final paint = Paint()
      ..color = AppColors.controlBorder
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(8),
    );
    final path = Path()..addRRect(rect);

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance = next + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TwoStripeHandle extends StatelessWidget {
  const _TwoStripeHandle();

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => HapticFeedback.selectionClick(),
      child: SizedBox(
        width: 20,
        height: 22,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_stripe(), const SizedBox(height: 5), _stripe()],
        ),
      ),
    );
  }

  Widget _stripe() {
    return Container(
      width: 18,
      height: 3,
      decoration: BoxDecoration(
        color: AppColors.textSecondary,
        borderRadius: BorderRadius.circular(99),
      ),
    );
  }
}
