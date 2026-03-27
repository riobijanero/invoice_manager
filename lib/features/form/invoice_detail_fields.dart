import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:invoice_manager/common/extensions/list_extensions.dart';

import 'package:invoice_manager/common/models/discount_type.dart';
import 'package:invoice_manager/common/models/due_date_type.dart';
import 'package:invoice_manager/common/models/invoice_item.dart';
import 'package:invoice_manager/common/utils/currency_format.dart';
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
    required this.serviceDates,
    required this.useServiceDate,
    required this.unitTypes,
    required this.quantityControllers,
    required this.unitPriceControllers,
    required this.onUnitTypeChanged,
    required this.serviceDescriptionControllers,
    required this.onServicePeriodModeChanged,
    required this.onServiceMonthChanged,
    required this.onServiceYearChanged,
    required this.onServiceDateTap,
    required this.onClearServiceDate,
    required this.onAddInvoiceItem,
    required this.onRemoveInvoiceItem,
    required this.invoiceItemRowIds,
    required this.onReorderInvoiceItems,
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
  final List<DateTime?> serviceDates;
  final List<bool> useServiceDate;
  final List<UnitType> unitTypes;
  final List<TextEditingController> quantityControllers;
  final List<TextEditingController> unitPriceControllers;
  final void Function(int index, UnitType type) onUnitTypeChanged;
  final List<TextEditingController> serviceDescriptionControllers;
  final void Function(int index, bool useDate) onServicePeriodModeChanged;
  final void Function(int index, int? value) onServiceMonthChanged;
  final void Function(int index, int? value) onServiceYearChanged;
  final void Function(int index) onServiceDateTap;
  final void Function(int index) onClearServiceDate;
  final VoidCallback onAddInvoiceItem;
  final void Function(int index) onRemoveInvoiceItem;
  final List<String> invoiceItemRowIds;
  final void Function(int oldIndex, int newIndex) onReorderInvoiceItems;
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

  Widget _buildInvoiceItem(
    BuildContext context, {
    required int i,
    required bool reorderable,
    required String Function(UnitType) unitLabel,
    required double Function(int) itemTotalFor,
  }) {
    final descriptionField = TextFormField(
      controller: serviceDescriptionControllers[i],
      decoration: const InputDecoration(
        labelText: 'Leistungsbeschreibung',
        border: OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
      maxLines: 5,
      validator: (v) => (v == null || v.trim().isEmpty) ? 'Pflichtfeld' : null,
    );

    final posField = InputDecorator(
      decoration: const InputDecoration(
        labelText: 'Pos.',
        border: OutlineInputBorder(),
      ),
      child: Text('${i + 1}'),
    );

    final quantityField = TextFormField(
      controller: quantityControllers[i],
      decoration: const InputDecoration(
        labelText: 'Anzahl',
        border: OutlineInputBorder(),
      ),
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
      ),
      validator: (v) {
        if (v == null || v.trim().isEmpty) {
          return 'Pflichtfeld';
        }
        final n = double.tryParse(v.replaceFirst(',', '.'));
        if (n == null || n < 0) return 'Ungültige Zahl';
        return null;
      },
    );

    final unitField = DropdownButtonFormField<UnitType>(
      value: unitTypes[i],
      decoration: const InputDecoration(
        labelText: 'Einheit',
        border: OutlineInputBorder(),
      ),
      items: UnitType.values
          .map(
            (t) => DropdownMenuItem<UnitType>(
              value: t,
              child: Text(unitLabel(t)),
            ),
          )
          .toList(),
      onChanged: (v) {
        if (v != null) onUnitTypeChanged(i, v);
      },
    );

    final priceField = TextFormField(
      controller: unitPriceControllers[i],
      decoration: const InputDecoration(
        labelText: 'Einzelpreis (€)',
        border: OutlineInputBorder(),
      ),
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
      ),
      validator: (v) {
        if (v == null || v.trim().isEmpty) {
          return 'Pflichtfeld';
        }
        final n = double.tryParse(v.replaceFirst(',', '.'));
        if (n == null || n < 0) return 'Ungültige Zahl';
        return null;
      },
    );

    final totalField = ValueListenableBuilder<TextEditingValue>(
      valueListenable: unitPriceControllers[i],
      builder: (context, _, __) {
        return ValueListenableBuilder<TextEditingValue>(
          valueListenable: quantityControllers[i],
          builder: (context, __, ___) {
            return InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Gesamt',
                border: OutlineInputBorder(),
              ),
              child: Text(formatCurrency(itemTotalFor(i))),
            );
          },
        );
      },
    );

    final dateControls = useServiceDate[i]
        ? InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Leistungsdatum',
              border: OutlineInputBorder(),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => onServiceDateTap(i),
                    child: Text(
                      serviceDates[i] != null
                          ? DateFormat('dd.MM.yyyy').format(serviceDates[i]!)
                          : 'Datum wählen',
                    ),
                  ),
                ),
                if (serviceDates[i] != null)
                  IconButton(
                    onPressed: () => onClearServiceDate(i),
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
          )
        : FieldRow(
            left: DropdownButtonFormField<int?>(
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
            right: DropdownButtonFormField<int?>(
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
          );

    final itemChildren = <Widget>[
      const SizedBox(height: 8),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (reorderable) ...[
            ReorderableDragStartListener(
              index: i,
              child: MouseRegion(
                cursor: SystemMouseCursors.grab,
                child: Semantics(
                  label: 'Reihenfolge ändern',
                  button: true,
                  child: Icon(
                    Icons.drag_handle,
                    size: 22,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
          ],
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
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SegmentedButton<bool>(
              segments: const [
                ButtonSegment<bool>(
                  value: false,
                  label: Text('Zeitraum'),
                ),
                ButtonSegment<bool>(
                  value: true,
                  label: Text('Datum'),
                ),
              ],
              selected: {useServiceDate[i]},
              onSelectionChanged: (s) => onServicePeriodModeChanged(i, s.first),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: dateControls,
          ),
        ],
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 60, child: posField),
                const SizedBox(width: 12),
                Expanded(child: descriptionField),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: quantityField),
                const SizedBox(width: 12),
                Expanded(child: unitField),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      priceField,
                      const SizedBox(height: 12),
                      totalField,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ];
    final spaced = itemChildren.intersperse(
      const SizedBox(height: 16),
    );
    if (i < serviceMonths.length - 1) {
      spaced.add(const SizedBox(height: 16));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: spaced,
    );
  }

  @override
  Widget build(BuildContext context) {
    String unitLabel(UnitType t) {
      switch (t) {
        case UnitType.hours:
          return 'Stunden';
        case UnitType.minutes:
          return 'Minuten';
        case UnitType.amount:
          return 'Anzahl';
      }
    }

    double itemTotalFor(int index) {
      final q = double.tryParse(
              quantityControllers[index].text.replaceFirst(',', '.')) ??
          0.0;
      final p = double.tryParse(
              unitPriceControllers[index].text.replaceFirst(',', '.')) ??
          0.0;
      return q * p;
    }

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
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Pflichtfeld' : null,
          ),
          right: InkWell(
            onTap: onInvoiceDateTap,
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Rechnungsdatum',
                border: OutlineInputBorder(),
              ),
              child: Text(
                invoiceDate != null
                    ? DateFormat('dd.MM.yyyy').format(invoiceDate!)
                    : '',
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
                        paidOn != null
                            ? DateFormat('dd.MM.yyyy').format(paidOn!)
                            : 'Datum wählen',
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
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Pflichtfeld' : null,
        ),
        // Invoice item list (one block per invoice item / one table row in PDF).
        // Full width so fields match the rest of the form (parent Column is start-aligned).
        SizedBox(
          width: double.infinity,
          child: serviceMonths.length > 1
              ? ReorderableListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  buildDefaultDragHandles: false,
                  onReorder: onReorderInvoiceItems,
                  children: [
                    for (int i = 0; i < serviceMonths.length; i++)
                      Builder(
                        key: ValueKey(invoiceItemRowIds[i]),
                        builder: (_) => _buildInvoiceItem(
                          context,
                          i: i,
                          reorderable: true,
                          unitLabel: unitLabel,
                          itemTotalFor: itemTotalFor,
                        ),
                      ),
                  ],
                )
              : _buildInvoiceItem(
                  context,
                  i: 0,
                  reorderable: false,
                  unitLabel: unitLabel,
                  itemTotalFor: itemTotalFor,
                ),
        ),

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
          InkWell(
            onTap: onCustomDueDateTap,
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Fälligkeitsdatum',
                border: OutlineInputBorder(),
              ),
              child: Text(
                customDueDate != null
                    ? DateFormat('dd.MM.yyyy').format(customDueDate!)
                    : 'Datum wählen',
              ),
            ),
          ),
        ],
      ].intersperse(const SizedBox(height: 16)),
    );
  }
}
