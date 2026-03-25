import 'package:flutter/material.dart';
import 'package:invoice_manager/common/models/discount_type.dart';

class DiscountControl extends StatelessWidget {
  const DiscountControl({
    super.key,
    required this.discountType,
    required this.onDiscountTypeChanged,
    required this.discountValueController,
  });

  final DiscountType discountType;
  final ValueChanged<DiscountType> onDiscountTypeChanged;
  final TextEditingController discountValueController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Rabatt: '),
        const SizedBox(width: 4),
        SegmentedButton<DiscountType>(
          showSelectedIcon: false,
          segments: const [
            ButtonSegment(value: DiscountType.percent, label: Text('%')),
            ButtonSegment(value: DiscountType.amount, label: Text('Betrag')),
          ],
          selected: {discountType},
          onSelectionChanged: (s) => onDiscountTypeChanged(s.first),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 140,
          child: TextFormField(
            controller: discountValueController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return null;
              final n = double.tryParse(v.replaceFirst(',', '.'));
              if (n == null || n < 0) return 'Ungültig';
              return null;
            },
          ),
        ),
      ],
    );
  }
}

