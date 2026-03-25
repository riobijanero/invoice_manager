import 'package:flutter/material.dart';
import 'package:invoice_manager/common/extensions/list_extensions.dart';

class FieldRow extends StatelessWidget {
  const FieldRow({
    super.key,
    this.columnGap = 12.0,
    required this.left,
    required this.right,
    this.middle,
  });

  final double columnGap;
  final Widget left;
  final Widget? middle;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        if (middle != null) Expanded(child: middle!),
        Expanded(child: right),
      ].intersperse(SizedBox(width: columnGap)),
    );
  }
}
