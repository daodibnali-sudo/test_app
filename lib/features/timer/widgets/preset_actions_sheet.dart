import 'package:flutter/material.dart';
import 'package:test_app/shared/theme/app_colors.dart';
import 'package:test_app/shared/theme/app_fonts.dart';

Future<void> showPresetActions({
  required BuildContext context,
  required String title,
  required String editLabel,
  required VoidCallback onEdit,
  VoidCallback? onRemove,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.blackSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cyanDeep.withAlpha(120)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.title.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                _PresetActionTile(
                  icon: Icons.edit_outlined,
                  label: editLabel,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    onEdit();
                  },
                ),
                if (onRemove != null)
                  _PresetActionTile(
                    icon: Icons.delete_outline,
                    label: 'REMOVE',
                    isDestructive: true,
                    onTap: () {
                      Navigator.pop(sheetContext);
                      onRemove();
                    },
                  ),
                _PresetActionTile(
                  icon: Icons.close,
                  label: 'CANCEL',
                  onTap: () => Navigator.pop(sheetContext),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Future<bool> showRemovePresetConfirmation(BuildContext context) async {
  final shouldRemove = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: AppColors.blackSurface,
        title: Text(
          'Remove preset?',
          style: AppTextStyles.heading.copyWith(fontSize: 24),
        ),
        content: Text(
          'This action cannot be undone.',
          style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              'CANCEL',
              style: AppTextStyles.title.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              'REMOVE',
              style: AppTextStyles.title.copyWith(color: AppColors.error),
            ),
          ),
        ],
      );
    },
  );

  return shouldRemove ?? false;
}

class _PresetActionTile extends StatelessWidget {
  const _PresetActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.error : AppColors.textPrimary;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label, style: AppTextStyles.title.copyWith(color: color)),
      onTap: onTap,
    );
  }
}
