import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:invoice_manager/common/extensions/list_extensions.dart';

import 'package:invoice_manager/common/models/discount_type.dart';
import 'package:invoice_manager/common/models/due_date_type.dart';
import 'package:invoice_manager/common/models/invoice_item.dart';
import 'package:invoice_manager/features/form/widgets/field_row.dart';
import 'package:invoice_manager/features/form/widgets/discount_control.dart';
import 'package:invoice_manager/features/form/widgets/vat_control.dart';

class InvoiceDetailFields extends StatelessWidget {
  const InvoiceDetailFields({
    super.key,
    required this.invoiceNumberController,
    required this.invoiceDate,
    required this.onInvoiceDateTap,
    required this.paidOn,
    required this.onPaidOnTap,
    required this.onClearPaidOn,
    required this.hasQrCode,
    required this.onHasQrCodeChanged,
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
  final bool hasQrCode;
  final ValueChanged<bool> onHasQrCodeChanged;
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

        FieldRow(
          left: TextFormField(
            controller: invoiceNumberController,
            decoration: const InputDecoration(
              labelText: 'Rechnungsnummer',
              border: OutlineInputBorder(),
            ),
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Pflichtfeld' : null,
          ),
          right: InkWell(
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
        ),
        FieldRow(
            left: InputDecorator(
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
            right: const SizedBox.shrink()),

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
        // Invoice item list (one block per invoice item / one table row in PDF).
        for (int i = 0; i < serviceMonths.length; i++) ...[
          const SizedBox(height: 8),
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
          FieldRow(
            left: DropdownButtonFormField<int?>(
              initialValue: serviceMonths[i],
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
            right: DropdownButtonFormField<int?>(
              initialValue: serviceYears[i],
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
          if (itemTypes[i] == InvoiceItemType.hourlyRateService) ...[
            FieldRow(
              left: TextFormField(
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
              right: TextFormField(
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

        Row(
          children: [
            VatControl(vat: vat, onVatChanged: onVatChanged),
            const SizedBox(width: 30),
            DiscountControl(
              discountType: discountType,
              onDiscountTypeChanged: onDiscountTypeChanged,
              discountValueController: discountValueController,
            ),
          ],
        ),

        Row(
          children: [
            Checkbox(
              value: hasQrCode,
              onChanged: (v) => onHasQrCodeChanged(v ?? false),
            ),
            const Text('QR-Code hinzufügen'),
          ],
        ),

        DropdownButtonFormField<DueDateType>(
          initialValue: dueDateType,
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
      ].intersperse(const SizedBox(height: 16)),
    );
  }
}
