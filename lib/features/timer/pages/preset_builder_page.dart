import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chelnok_boxing_timer/features/timer/models/timer_block.dart';
import 'package:chelnok_boxing_timer/features/timer/models/timer_custom_preset.dart';
import 'package:chelnok_boxing_timer/features/timer/providers/timer_provider.dart';
import 'package:chelnok_boxing_timer/features/timer/widgets/app_bar_timer.dart';
import 'package:chelnok_boxing_timer/features/timer/widgets/custom_block_card.dart';
import 'package:chelnok_boxing_timer/features/timer/widgets/timer_block_dialog.dart';
import 'package:chelnok_boxing_timer/router/open_timer.dart';
import 'package:chelnok_boxing_timer/shared/theme/app_colors.dart';
import 'package:chelnok_boxing_timer/shared/theme/app_fonts.dart';
import 'package:chelnok_boxing_timer/widgets/button.dart';
//import 'package:chelnok_boxing_timer/widgets/outlined_section.dart';

class PresetBuilderPage extends ConsumerStatefulWidget {
  const PresetBuilderPage({super.key, this.editingCustomPresetIndex});

  final int? editingCustomPresetIndex;

  @override
  ConsumerState<PresetBuilderPage> createState() => _PresetBuilderPageState();
}

class _PresetBuilderPageState extends ConsumerState<PresetBuilderPage> {
  final TextEditingController _nameController = TextEditingController();
  final List<_DraftBlock> _blocks = [];

  List<TimerBlock> get _acceptedBlocks => _blocks
      .where((block) => !block.isRestSuggestion)
      .map((block) => block.block)
      .toList();

  bool get _isEditing => widget.editingCustomPresetIndex != null;

  @override
  void initState() {
    super.initState();

    final editingIndex = widget.editingCustomPresetIndex;
    final presets = ref.read(timerProvider).customPresets;

    if (editingIndex == null ||
        editingIndex < 0 ||
        editingIndex >= presets.length) {
      return;
    }

    final preset = presets[editingIndex];
    _nameController.text = preset.name;
    _blocks.addAll(preset.blocks.map(_DraftBlock.new));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _addBlock() async {
    final block = await _openBlockDialog(
      fallbackName: 'Block #${_acceptedBlocks.length + 1}',
    );
    if (block == null) return;

    setState(() {
      _blocks
        ..add(_DraftBlock(block))
        ..add(
          _DraftBlock(
            const TimerBlock(name: 'Rest', durationMs: 60000),
            isRestSuggestion: true,
          ),
        );
    });
  }

  Future<void> _editBlock(int index) async {
    final draft = _blocks[index];
    if (draft.isRestSuggestion) return;

    final block = await _openBlockDialog(
      fallbackName: draft.block.name,
      initialBlock: draft.block,
    );
    if (block == null) return;

    setState(() => _blocks[index] = _DraftBlock(block));
  }

  Future<TimerBlock?> _openBlockDialog({
    required String fallbackName,
    TimerBlock? initialBlock,
  }) {
    return showDialog<TimerBlock>(
      context: context,
      builder: (context) => TimerBlockDialog(
        fallbackName: fallbackName,
        initialBlock: initialBlock,
      ),
    );
  }

  TimerCustomPreset? _buildPreset({required bool showDuplicateAlert}) {
    final notifier = ref.read(timerProvider.notifier);
    final name = _nameController.text.trim().isEmpty
        ? notifier.nextCustomPresetName()
        : _nameController.text.trim();
    final blocks = _acceptedBlocks;

    if (blocks.isEmpty) return null;
    if (notifier.hasCustomPresetName(
      name,
      excludingIndex: widget.editingCustomPresetIndex,
    )) {
      if (showDuplicateAlert) _showNameAlert(name);
      return null;
    }

    return TimerCustomPreset(name: name, blocks: List.unmodifiable(blocks));
  }

  void _showNameAlert(String name) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.blackSurface,
        title: Text(
          'Name already exists',
          style: AppTextStyles.heading.copyWith(fontSize: 24),
        ),
        content: Text(
          '"$name" is already saved. Choose another preset name.',
          style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _savePreset() {
    final preset = _buildPreset(showDuplicateAlert: true);
    if (preset == null) return;

    final notifier = ref.read(timerProvider.notifier);
    final editingIndex = widget.editingCustomPresetIndex;

    if (editingIndex == null) {
      notifier.addCustomPreset(preset);
    } else {
      notifier.updateCustomPreset(editingIndex, preset);
    }

    Navigator.pop(context);
  }

  void _startPreset() {
    final preset = _buildPreset(showDuplicateAlert: true);
    if (preset == null) return;

    final notifier = ref.read(timerProvider.notifier);
    final editingIndex = widget.editingCustomPresetIndex;

    if (editingIndex == null) {
      notifier.addCustomPreset(preset);
    } else {
      notifier.updateCustomPreset(editingIndex, preset);
    }

    notifier
      ..startCustomPreset(preset)
      ..start();
    openTimerRunPage(context);
  }

  void _reorderBlock(int oldIndex, int newIndex) {
    setState(() {
      final block = _blocks.removeAt(oldIndex);
      _blocks.insert(newIndex, block);
    });
  }

  void _acceptRest(int index) {
    setState(() => _blocks[index] = _DraftBlock(_blocks[index].block));
  }

  void _removeBlock(int index) {
    setState(() => _blocks.removeAt(index));
  }

  //UI/////////////////////////////////////////////////////////////UI/////////////

  @override
  Widget build(BuildContext context) {
    final canUsePreset = _acceptedBlocks.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.blackBg,
      appBar: const TimerAppBar(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              sliver: SliverList.list(
                children: [
                  Text(
                    _isEditing ? 'Edit Custom Preset' : 'Custom Preset',
                    style: AppTextStyles.heading,
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _nameController,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    decoration: _inputDecoration("e.g. \"light sparring\""),
                  ),
                  const SizedBox(height: 12),
                  const _BlocksHeader(),
                  if (_blocks.isEmpty) ...[
                    const SizedBox(height: 7),
                    Text(
                      'Add your first workout block',
                      style: AppTextStyles.label,
                    ),
                  ],
                ],
              ),
            ),
            if (_blocks.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                sliver: SliverReorderableList(
                  itemCount: _blocks.length,
                  onReorderStart: (_) => HapticFeedback.vibrate(),
                  onReorderItem: _reorderBlock,
                  proxyDecorator: _dragProxy,
                  itemBuilder: (context, index) {
                    final draft = _blocks[index];
                    return Padding(
                      key: ObjectKey(draft),
                      padding: const EdgeInsets.only(bottom: 10),
                      child: CustomBlockCard(
                        index: index,
                        block: draft.block,
                        isRestSuggestion: draft.isRestSuggestion,
                        onEdit: () => _editBlock(index),
                        onAcceptRest: () => _acceptRest(index),
                        onRejectRest: () => _removeBlock(index),
                        onDelete: () => _removeBlock(index),
                      ),
                    );
                  },
                ),
              ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              sliver: SliverList.list(
                children: [
                  AppButton(
                    text: 'Add Block',
                    leading: const Icon(Icons.add),
                    backgroundColor: AppColors.blackSurface,
                    borderColor: AppColors.cyanLight,
                    textColor: AppColors.cyanLight,
                    iconColor: AppColors.cyanLight,
                    filled: false,
                    onPressed: _addBlock,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          text: _isEditing ? 'UPDATE' : 'SAVE',
                          leading: const Icon(Icons.save),
                          backgroundColor: AppColors.blackSurface,
                          borderColor: AppColors.cyanLight,
                          textColor: AppColors.cyanLight,
                          iconColor: AppColors.cyanLight,
                          filled: false,
                          enabled: canUsePreset,
                          onPressed: _savePreset,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AppButton(
                          text: 'START',
                          leading: const Icon(Icons.play_arrow),
                          backgroundColor: AppColors.cyanLight,
                          textColor: AppColors.blackBg,
                          iconColor: AppColors.blackBg,
                          enabled: canUsePreset,
                          onPressed: _startPreset,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dragProxy(Widget child, int index, Animation<double> animation) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.72, end: 0.86).animate(animation),
      child: Material(
        color: Colors.transparent,
        shadowColor: Colors.transparent,
        child: child,
      ),
    );
  }
}

class _DraftBlock {
  const _DraftBlock(this.block, {this.isRestSuggestion = false});

  final TimerBlock block;
  final bool isRestSuggestion;
}

class _BlocksHeader extends StatelessWidget {
  const _BlocksHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Blocks',
          style: AppTextStyles.title.copyWith(color: AppColors.textPrimary),
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
