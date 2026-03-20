import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:invoice_manager/common/models/discount_type.dart';
import 'package:invoice_manager/common/models/due_date_type.dart';

class InvoiceDetailFields extends StatelessWidget {
  const InvoiceDetailFields({
    super.key,
    required this.invoiceNumberController,
    required this.invoiceDate,
    required this.onInvoiceDateTap,
    required this.paidOn,
    required this.onPaidOnTap,
    required this.serviceMonth,
    required this.serviceYear,
    required this.onServiceMonthChanged,
    required this.onServiceYearChanged,
    required this.hoursController,
    required this.hourlyRateController,
    required this.discountType,
    required this.onDiscountTypeChanged,
    required this.discountValueController,
    required this.dueDateType,
    required this.onDueDateTypeChanged,
    required this.customDueDate,
    required this.onCustomDueDateTap,
    required this.serviceDescriptionController,
  });

  final TextEditingController invoiceNumberController;
  final DateTime? invoiceDate;
  final VoidCallback onInvoiceDateTap;
  final DateTime? paidOn;
  final VoidCallback onPaidOnTap;
  final int serviceMonth;
  final int serviceYear;
  final ValueChanged<int> onServiceMonthChanged;
  final ValueChanged<int> onServiceYearChanged;
  final TextEditingController hoursController;
  final TextEditingController hourlyRateController;
  final DiscountType discountType;
  final ValueChanged<DiscountType> onDiscountTypeChanged;
  final TextEditingController discountValueController;
  final DueDateType dueDateType;
  final ValueChanged<DueDateType> onDueDateTypeChanged;
  final DateTime? customDueDate;
  final VoidCallback onCustomDueDateTap;
  final TextEditingController serviceDescriptionController;

  static const List<int> _months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  static const List<String> _monthLabels = [
    'Januar',
    'Februar',
    'März',
    'April',
    'Mai',
    'Juni',
    'Juli',
    'August',
    'September',
    'Oktober',
    'November',
    'Dezember',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rechnungsdetails',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: invoiceNumberController,
          decoration: const InputDecoration(
            labelText: 'Rechnungsnummer',
            border: OutlineInputBorder(),
          ),
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Pflichtfeld' : null,
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: onInvoiceDateTap,
          child: InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Rechnungsdatum',
              border: OutlineInputBorder(),
            ),
            child: Text(
              invoiceDate != null ? DateFormat('dd.MM.yyyy').format(invoiceDate!) : '',
            ),
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: onPaidOnTap,
          child: InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Bezahlt am (optional)',
              border: OutlineInputBorder(),
            ),
            child: Text(
              paidOn != null ? DateFormat('dd.MM.yyyy').format(paidOn!) : 'Datum wählen',
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<int>(
                value: serviceMonth,
                decoration: const InputDecoration(
                  labelText: 'Leistungszeitraum Monat',
                  border: OutlineInputBorder(),
                ),
                items: List.generate(
                  12,
                  (i) => DropdownMenuItem(
                    value: _months[i],
                    child: Text(_monthLabels[i]),
                  ),
                ),
                onChanged: (v) {
                  if (v != null) onServiceMonthChanged(v);
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<int>(
                value: serviceYear,
                decoration: const InputDecoration(
                  labelText: 'Leistungszeitraum Jahr',
                  border: OutlineInputBorder(),
                ),
                items: List.generate(
                  5,
                  (i) {
                    final y = DateTime.now().year - 2 + i;
                    return DropdownMenuItem(
                      value: y,
                      child: Text('$y'),
                    );
                  },
                ),
                onChanged: (v) {
                  if (v != null) onServiceYearChanged(v);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: hoursController,
          decoration: const InputDecoration(
            labelText: 'Stunden',
            border: OutlineInputBorder(),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Pflichtfeld';
            final n = double.tryParse(v.replaceFirst(',', '.'));
            if (n == null || n < 0) return 'Ungültige Zahl';
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: hourlyRateController,
          decoration: const InputDecoration(
            labelText: 'Stundensatz (€)',
            border: OutlineInputBorder(),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Pflichtfeld';
            final n = double.tryParse(v.replaceFirst(',', '.'));
            if (n == null || n < 0) return 'Ungültige Zahl';
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: serviceDescriptionController,
          decoration: const InputDecoration(
            labelText: 'Leistungsbeschreibung',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
          maxLines: 5,
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Pflichtfeld' : null,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Text('Rabatt: '),
            SegmentedButton<DiscountType>(
              segments: const [
                ButtonSegment(value: DiscountType.percent, label: Text('%')),
                ButtonSegment(value: DiscountType.amount, label: Text('Betrag')),
              ],
              selected: {discountType},
              onSelectionChanged: (s) => onDiscountTypeChanged(s.first),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 120,
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
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<DueDateType>(
          value: dueDateType,
          decoration: const InputDecoration(
            labelText: 'Fälligkeit',
            border: OutlineInputBorder(),
          ),
          items: DueDateType.values
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e.displayName),
                  ))
              .toList(),
          onChanged: (v) {
            if (v != null) onDueDateTypeChanged(v);
          },
        ),
        if (dueDateType == DueDateType.custom) ...[
          const SizedBox(height: 12),
          InkWell(
            onTap: onCustomDueDateTap,
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Fälligkeitsdatum',
                border: OutlineInputBorder(),
              ),
              child: Text(
                customDueDate != null ? DateFormat('dd.MM.yyyy').format(customDueDate!) : 'Datum wählen',
              ),
            ),
          ),
        ],
      ],
    );
  }
}
