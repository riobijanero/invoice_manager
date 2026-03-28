import 'package:flutter/material.dart';

/// [InputDecoration] with an [Icons.close] suffix when [controller] has text.
/// Preserves an existing [InputDecoration.suffixIcon] (e.g. dropdown) after the clear control.
InputDecoration inputDecorationWithClear({
  required TextEditingController controller,
  required InputDecoration decoration,
  String clearTooltip = 'Leeren',
  VoidCallback? onAfterClear,
}) {
  final existingSuffix = decoration.suffixIcon;
  final base = decoration.copyWith(suffixIcon: null);
  return base.copyWith(
    suffixIcon: ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final showClear = value.text.isNotEmpty;
        return Visibility(
          visible: showClear || existingSuffix != null,
          maintainSize: false,
          maintainAnimation: false,
          maintainState: false,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showClear)
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  tooltip: clearTooltip,
                  onPressed: () {
                    controller.clear();
                    onAfterClear?.call();
                  },
                  visualDensity: VisualDensity.compact,
                  style: IconButton.styleFrom(
                    padding: const EdgeInsets.all(8),
                    minimumSize: const Size(40, 40),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              if (existingSuffix != null) existingSuffix,
            ],
          ),
        );
      },
    ),
  );
}
