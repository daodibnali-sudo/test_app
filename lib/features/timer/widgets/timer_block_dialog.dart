import 'package:flutter/material.dart';
import 'package:test_app/features/timer/models/timer_block.dart';
import 'package:test_app/features/timer/widgets/duration_picker.dart';
import 'package:test_app/shared/theme/app_colors.dart';
import 'package:test_app/shared/theme/app_fonts.dart';

class TimerBlockDialog extends StatefulWidget {
  const TimerBlockDialog({
    super.key,
    required this.fallbackName,
    this.initialBlock,
  });

  final String fallbackName;
  final TimerBlock? initialBlock;

  @override
  State<TimerBlockDialog> createState() => _TimerBlockDialogState();
}

class _TimerBlockDialogState extends State<TimerBlockDialog> {
  late final TextEditingController _nameController;
  late int _minutes;
  late int _seconds;

  @override
  void initState() {
    super.initState();

    final initialBlock = widget.initialBlock;
    _nameController = TextEditingController(text: initialBlock?.name ?? '');
    _minutes = initialBlock == null ? 1 : initialBlock.durationMs ~/ 60000;
    _seconds = initialBlock == null
        ? 0
        : initialBlock.durationMs % 60000 ~/ 1000;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveBlock() {
    final name = _nameController.text.trim().isEmpty
        ? widget.fallbackName
        : _nameController.text.trim();
    final durationMs = ((_minutes * 60) + _seconds) * 1000;

    if (durationMs <= 0) return;

    Navigator.pop(context, TimerBlock(name: name, durationMs: durationMs));
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialBlock != null;

    return AlertDialog(
      backgroundColor: AppColors.blackSurface,
      title: Text(
        isEditing ? 'Edit Block' : 'Add Block',
        style: AppTextStyles.heading.copyWith(fontSize: 24),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
            decoration: _inputDecoration('e.g. "Work"'),
          ),
          const SizedBox(height: 12),
          DurationPicker(
            minutes: _minutes,
            seconds: _seconds,
            onMinutesChanged: (value) => setState(() {
              _minutes = value;
            }),
            onSecondsChanged: (value) => setState(() {
              _seconds = value;
            }),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _saveBlock,
          child: Text(isEditing ? 'Save' : 'Add'),
        ),
      ],
    );
  }
}

InputDecoration _inputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: AppTextStyles.label,
    filled: true,
    fillColor: AppColors.blackSurface,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.cyanDeep.withAlpha(120)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.cyanLight),
    ),
  );
}
