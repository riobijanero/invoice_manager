import 'package:flutter/material.dart';

class VatControl extends StatelessWidget {
  const VatControl({
    super.key,
    required this.vat,
    required this.onVatChanged,
  });

  final double vat;
  final ValueChanged<double> onVatChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('MwSt: '),
        const SizedBox(width: 4),
        SegmentedButton<double>(
          showSelectedIcon: false,
          segments: const [
            ButtonSegment(value: 0.19, label: Text('19%')),
            ButtonSegment(value: 0.0, label: Text('0%')),
          ],
          selected: {vat},
          onSelectionChanged: (s) => onVatChanged(s.first),
        ),
      ],
    );
  }
}
