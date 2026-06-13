import 'package:flutter/material.dart';
import 'package:chelnok_boxing_timer/features/timer/pages/preset_builder_page.dart';
import 'package:chelnok_boxing_timer/features/timer/pages/preset_list_page.dart';
import 'package:chelnok_boxing_timer/features/timer/pages/timer_run_page.dart';
import 'package:chelnok_boxing_timer/features/timer/pages/timer_set_page.dart';

Future<void> openTimerSetPage(
  BuildContext context, {
  int? editingTimerPresetIndex,
}) {
  return Navigator.push(
    context,
    _animatedRoute(
      builder: (_) =>
          TimerSetPage(editingTimerPresetIndex: editingTimerPresetIndex),
    ),
  );
}

Future<void> openTimerRunPage(BuildContext context) {
  return Navigator.push(
    context,
    _animatedRoute(builder: (_) => const TimerRunPage()),
  );
}

Future<void> openPresetBuilderPage(
  BuildContext context, {
  int? editingCustomPresetIndex,
}) {
  return Navigator.push(
    context,
    _animatedRoute(
      builder: (_) =>
          PresetBuilderPage(editingCustomPresetIndex: editingCustomPresetIndex),
    ),
  );
}

Future<void> openPresetListPage(
  BuildContext context, {
  required PresetListType type,
}) {
  return Navigator.push(
    context,
    _animatedRoute(builder: (_) => PresetListPage(type: type)),
  );
}

PageRouteBuilder<void> _animatedRoute({required WidgetBuilder builder}) {
  return PageRouteBuilder<void>(
    transitionDuration: const Duration(milliseconds: 260),
    reverseTransitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );

      return FadeTransition(
        opacity: curvedAnimation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.08, 0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        ),
      );
    },
  );
}
