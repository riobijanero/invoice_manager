import 'package:flutter/material.dart';

/// Small red chip shown next to the invoice title when the invoice is overdue.
class OverdueChip extends StatelessWidget {
  const OverdueChip({super.key});

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;
    // Using a simple container avoids `Chip`'s internal theming/elevation
    // which can appear as an opaque background when the AppBar changes
    // color on scroll.
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: errorColor, width: 1),
      ),
      child: Text(
        'überfällig',
        style: TextStyle(
          color: errorColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

