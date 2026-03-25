import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:invoice_manager/common/models/discount_type.dart';
import 'package:invoice_manager/common/models/due_date_type.dart';
import 'package:invoice_manager/common/models/invoice_item.dart';
import 'package:invoice_manager/features/form/widgets/field_row.dart';

class InvoiceDetailFields extends StatelessWidget {
  const InvoiceDetailFields({
    super.key,
    required this.invoiceNumberController,
    required this.invoiceDate,
    required this.onInvoiceDateTap,
    required this.paidOn,
    required this.onPaidOnTap,
    required this.onClearPaidOn,
    required this.introductoryTextController,
    required this.serviceMonths,
    required this.serviceYears,
    required this.hoursControllers,
    required this.hourlyRateControllers,
    required this.itemTypes,
    required this.fixedPriceControllers,
    required this.onItemTypeChanged,
    required this.serviceDescriptionControllers,
    required this.onServiceMonthChanged,
    required this.onServiceYearChanged,
    required this.onAddInvoiceItem,
    required this.onRemoveInvoiceItem,
    required this.discountType,
    required this.onDiscountTypeChanged,
    required this.discountValueController,
    required this.vat,
    required this.onVatChanged,
    required this.dueDateType,
    required this.onDueDateTypeChanged,
    required this.customDueDate,
    required this.onCustomDueDateTap,
  });

  final TextEditingController invoiceNumberController;
  final DateTime? invoiceDate;
  final VoidCallback onInvoiceDateTap;
  final DateTime? paidOn;
  final VoidCallback onPaidOnTap;
  final VoidCallback onClearPaidOn;
  final TextEditingController introductoryTextController;
  final List<int?> serviceMonths;
  final List<int?> serviceYears;
  final List<TextEditingController> hoursControllers;
  final List<TextEditingController> hourlyRateControllers;
  final List<InvoiceItemType> itemTypes;
  final List<TextEditingController> fixedPriceControllers;
  final void Function(int index, InvoiceItemType type) onItemTypeChanged;
  final List<TextEditingController> serviceDescriptionControllers;
  final void Function(int index, int? value) onServiceMonthChanged;
  final void Function(int index, int? value) onServiceYearChanged;
  final VoidCallback onAddInvoiceItem;
  final void Function(int index) onRemoveInvoiceItem;
  final DiscountType discountType;
  final ValueChanged<DiscountType> onDiscountTypeChanged;
  final TextEditingController discountValueController;
  final double vat;
  final ValueChanged<double> onVatChanged;
  final DueDateType dueDateType;
  final ValueChanged<DueDateType> onDueDateTypeChanged;
  final DateTime? customDueDate;
  final VoidCallback onCustomDueDateTap;

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

        const SizedBox(height: 16),
        FieldRow(
          left: TextFormField(
            controller: invoiceNumberController,
            decoration: const InputDecoration(
              labelText: 'Rechnungsnummer',
              border: OutlineInputBorder(),
            ),
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Pflichtfeld' : null,
          ),
          middle: InkWell(
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
          right: InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Bezahlt am (optional)',
              border: OutlineInputBorder(),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: onPaidOnTap,
                    child: Text(
                      paidOn != null ? DateFormat('dd.MM.yyyy').format(paidOn!) : 'Datum wählen',
                    ),
                  ),
                ),
                if (paidOn != null)
                  IconButton(
                    onPressed: onClearPaidOn,
                    icon: const Icon(Icons.close),
                    tooltip: 'Datum entfernen',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    style: IconButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                    ),
                  ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),
        TextFormField(
          controller: introductoryTextController,
          decoration: const InputDecoration(
            labelText: 'Einleitungstext',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
          maxLines: 3,
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Pflichtfeld' : null,
        ),
        const SizedBox(height: 16),
        // Invoice item list (one block per invoice item / one table row in PDF).
        for (int i = 0; i < serviceMonths.length; i++) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  'Leistungsposition ${i + 1}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              if (serviceMonths.length > 1)
                IconButton(
                  onPressed: () => onRemoveInvoiceItem(i),
                  icon: const Icon(Icons.remove_circle_outline),
                  tooltip: 'Position entfernen',
                  style: IconButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          SegmentedButton<InvoiceItemType>(
            segments: const [
              ButtonSegment(
                value: InvoiceItemType.hourlyRateService,
                label: Text('Stunden'),
              ),
              ButtonSegment(
                value: InvoiceItemType.fixedPriceService,
                label: Text('Pauschal'),
              ),
            ],
            selected: {itemTypes[i]},
            onSelectionChanged: (s) {
              onItemTypeChanged(i, s.first);
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int?>(
                  value: serviceMonths[i],
                  decoration: const InputDecoration(
                    labelText: 'Leistungszeitraum Monat',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem<int?>(
                      value: null,
                      child: Text('—'),
                    ),
                    ...List.generate(
                      12,
                      (j) => DropdownMenuItem<int?>(
                        value: _months[j],
                        child: Text(_monthLabels[j]),
                      ),
                    ),
                  ],
                  onChanged: (v) => onServiceMonthChanged(i, v),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<int?>(
                  value: serviceYears[i],
                  decoration: const InputDecoration(
                    labelText: 'Leistungszeitraum Jahr',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem<int?>(
                      value: null,
                      child: Text('—'),
                    ),
                    ...List.generate(
                      5,
                      (j) {
                        final y = DateTime.now().year - 2 + j;
                        return DropdownMenuItem<int?>(
                          value: y,
                          child: Text('$y'),
                        );
                      },
                    ),
                  ],
                  onChanged: (v) => onServiceYearChanged(i, v),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (itemTypes[i] == InvoiceItemType.hourlyRateService) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: hoursControllers[i],
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
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: hourlyRateControllers[i],
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
                ),
              ],
            ),
            const SizedBox(height: 16),
          ] else ...[
            TextFormField(
              controller: fixedPriceControllers[i],
              decoration: const InputDecoration(
                labelText: 'Festpreis (€)',
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
          ],
          TextFormField(
            controller: serviceDescriptionControllers[i],
            decoration: const InputDecoration(
              labelText: 'Leistungsbeschreibung',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            maxLines: 5,
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Pflichtfeld' : null,
          ),
          const SizedBox(height: 16),
        ],

        // Add another invoice item above the discount section.
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            onPressed: onAddInvoiceItem,
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Weitere Leistungsposition hinzufügen',
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Row(
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
            ),
            const SizedBox(width: 30),
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
            Expanded(
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
