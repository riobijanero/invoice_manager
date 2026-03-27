import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:invoice_manager/common/layout/invoice_layout_breakpoints.dart';
import 'package:invoice_manager/common/providers/providers.dart';
import 'package:invoice_manager/common/utils/date_utils.dart';
import 'package:uuid/uuid.dart';

import 'package:invoice_manager/common/models/bank_details.dart';
import 'package:invoice_manager/common/models/client.dart';
import 'package:invoice_manager/common/models/discount_type.dart';
import 'package:invoice_manager/common/models/due_date_type.dart';
import 'package:invoice_manager/common/models/invoice.dart';
import 'package:invoice_manager/common/models/invoice_defaults.dart';
import 'package:invoice_manager/common/models/invoice_item.dart';
import 'package:invoice_manager/common/models/adress.dart';
import 'package:invoice_manager/common/models/sender.dart';
import 'package:invoice_manager/features/form/ui/widgets/overdue_chip.dart';
import 'package:invoice_manager/features/form/bank_details_fields.dart';
import 'package:invoice_manager/features/form/client_fields.dart';
import 'package:invoice_manager/features/form/invoice_detail_fields.dart';
import 'package:invoice_manager/features/form/sender_fields.dart';
import 'package:invoice_manager/features/form/utils/utils.dart';
import '../../routing/app_router.dart';

class InvoiceFormScreen extends ConsumerStatefulWidget {
  const InvoiceFormScreen({super.key, this.invoiceId});

  final String? invoiceId;

  @override
  ConsumerState<InvoiceFormScreen> createState() => _InvoiceFormScreenState();
}

class _InvoiceFormScreenState extends ConsumerState<InvoiceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _invoiceNumber;
  late TextEditingController _senderName;
  late TextEditingController _senderStreetNameAndNumber;
  late TextEditingController _senderPostalCode;
  late TextEditingController _senderTown;
  late TextEditingController _senderCountry;
  late TextEditingController _senderPhone;
  late TextEditingController _senderEmail;
  late TextEditingController _senderWebsite;
  late TextEditingController _clientName;
  late TextEditingController _clientCompanyName;
  late TextEditingController _clientStreetNameAndNumber;
  late TextEditingController _clientPostalCode;
  late TextEditingController _clientTown;
  late TextEditingController _clientCountry;
  late TextEditingController _clientId;
  late TextEditingController _contractNumber;
  late TextEditingController _accountHolder;
  late TextEditingController _institution;
  late TextEditingController _iban;
  late TextEditingController _bic;
  late List<UnitType> _unitTypes;
  late List<TextEditingController> _quantityControllers;
  late List<TextEditingController> _unitPriceControllers;
  late TextEditingController _discountValue;
  late TextEditingController _jobDescription;
  late TextEditingController _introductoryText;
  late List<TextEditingController> _serviceDescriptionControllers;
  late TextEditingController _ustId;
  late TextEditingController _taxNumber;

  DateTime? _invoiceDate;
  DateTime? _paidOn;
  List<int?> _serviceMonths = [null];
  List<int?> _serviceYears = [null];
  List<DateTime?> _serviceDates = [null];
  List<bool> _useServiceDate = [false];
  late List<String> _invoiceItemRowIds;
  DiscountType _discountType = DiscountType.percent;
  double _vat = 0.19;
  DueDateType _dueDateType = DueDateType.twoWeeks;
  DateTime? _customDueDate;
  Invoice? _loadedInvoice;
  InvoiceDefaults? _defaults;
  final Set<String> _deletedClientKeys = <String>{};
  bool _initialized = false;
  bool _hasQrCode = false;

  bool _hasAnyText(TextEditingController c) => c.text.trim().isNotEmpty;

  /// Matches [SenderFields] validators: Name, Straße, PLZ, Ort, Land.
  bool _senderMandatoryComplete() {
    if (!_hasAnyText(_senderName)) return false;
    if (!_hasAnyText(_senderStreetNameAndNumber)) return false;
    final plz = _senderPostalCode.text.trim();
    final plzN = int.tryParse(plz);
    if (plz.isEmpty || plzN == null || plzN <= 0) return false;
    if (!_hasAnyText(_senderTown)) return false;
    if (!_hasAnyText(_senderCountry)) return false;
    return true;
  }

  /// Matches [BankDetailsFields] validators.
  bool _bankMandatoryComplete() {
    if (!_hasAnyText(_accountHolder)) return false;
    if (!_hasAnyText(_institution)) return false;
    if (!_hasAnyText(_bic)) return false;
    final iban = _iban.text.trim();
    if (iban.isEmpty || !isValidIban(iban)) return false;
    return true;
  }

  /// Matches [ClientFields] validators: Firma oder Name, Adresse, PLZ, Ort, Land.
  bool _clientMandatoryComplete() {
    final company = _clientCompanyName.text.trim();
    final name = _clientName.text.trim();
    if (company.isEmpty && name.isEmpty) return false;
    if (!_hasAnyText(_clientStreetNameAndNumber)) return false;
    final plz = _clientPostalCode.text.trim();
    final plzN = int.tryParse(plz);
    if (plz.isEmpty || plzN == null || plzN <= 0) return false;
    if (!_hasAnyText(_clientTown)) return false;
    if (!_hasAnyText(_clientCountry)) return false;
    return true;
  }

  @override
  void initState() {
    super.initState();
    _invoiceNumber = TextEditingController();
    _senderName = TextEditingController();
    _senderStreetNameAndNumber = TextEditingController();
    _senderPostalCode = TextEditingController();
    _senderTown = TextEditingController();
    _senderCountry = TextEditingController(text: 'Deutschland');
    _senderPhone = TextEditingController();
    _senderEmail = TextEditingController();
    _senderWebsite = TextEditingController();
    _clientName = TextEditingController();
    _clientCompanyName = TextEditingController();
    _clientStreetNameAndNumber = TextEditingController();
    _clientPostalCode = TextEditingController();
    _clientTown = TextEditingController();
    _clientCountry = TextEditingController(text: 'Deutschland');
    _clientId = TextEditingController();
    _contractNumber = TextEditingController();
    _accountHolder = TextEditingController();
    _institution = TextEditingController();
    _iban = TextEditingController();
    _bic = TextEditingController();
    _unitTypes = [UnitType.hours];
    _quantityControllers = [TextEditingController()];
    _unitPriceControllers = [TextEditingController()];
    _discountValue = TextEditingController(text: '0');
    _jobDescription = TextEditingController();
    _introductoryText = TextEditingController(
      text: 'Sehr geehrte Damen und Herren,\nfür das Erbringen meiner Dienstleistungen berechne ich Ihnen:',
    );
    _serviceDescriptionControllers = [TextEditingController()];
    _ustId = TextEditingController();
    _taxNumber = TextEditingController();
    _invoiceDate = DateTime.now();
    _paidOn = null;
    _invoiceItemRowIds = [Uuid().v4()];
  }

  @override
  void didUpdateWidget(InvoiceFormScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Without a route-level [ValueKey], the same State can be reused when
    // switching invoices in the split layout; reset so [_applyInvoice] runs again.
    if (widget.invoiceId != oldWidget.invoiceId) {
      _initialized = false;
      _loadedInvoice = null;
      if (widget.invoiceId == null) {
        _defaults = null;
      }
    }
  }

  @override
  void dispose() {
    _invoiceNumber.dispose();
    _senderName.dispose();
    _senderStreetNameAndNumber.dispose();
    _senderPostalCode.dispose();
    _senderTown.dispose();
    _senderCountry.dispose();
    _senderPhone.dispose();
    _senderEmail.dispose();
    _senderWebsite.dispose();
    _clientName.dispose();
    _clientCompanyName.dispose();
    _clientStreetNameAndNumber.dispose();
    _clientPostalCode.dispose();
    _clientTown.dispose();
    _clientCountry.dispose();
    _clientId.dispose();
    _contractNumber.dispose();
    _accountHolder.dispose();
    _institution.dispose();
    _iban.dispose();
    _bic.dispose();
    for (final c in _quantityControllers) {
      c.dispose();
    }
    for (final c in _unitPriceControllers) {
      c.dispose();
    }
    _discountValue.dispose();
    _jobDescription.dispose();
    _introductoryText.dispose();
    for (final c in _serviceDescriptionControllers) {
      c.dispose();
    }
    _ustId.dispose();
    _taxNumber.dispose();
    super.dispose();
  }

  void _applyInvoice(Invoice inv) {
    _invoiceNumber.text = inv.invoiceNumber;
    _senderName.text = inv.sender.name;
    _senderStreetNameAndNumber.text = inv.sender.address.streetNameAndNumber;
    _senderPostalCode.text = inv.sender.address.postalCode == 0 ? '' : inv.sender.address.postalCode.toString();
    _senderTown.text = inv.sender.address.town;
    _senderCountry.text = inv.sender.address.country.isNotEmpty ? inv.sender.address.country : 'Deutschland';
    _senderPhone.text = inv.sender.phoneNumber;
    _senderEmail.text = inv.sender.email;
    _senderWebsite.text = inv.sender.website;
    _ustId.text = inv.sender.ustId;
    _taxNumber.text = inv.sender.taxNumber;
    _clientName.text = inv.client.name;
    _clientCompanyName.text = inv.client.companyName;
    _clientStreetNameAndNumber.text = inv.client.address.streetNameAndNumber;
    _clientPostalCode.text = inv.client.address.postalCode == 0 ? '' : inv.client.address.postalCode.toString();
    _clientTown.text = inv.client.address.town;
    _clientCountry.text = inv.client.address.country.isNotEmpty ? inv.client.address.country : 'Deutschland';
    _clientId.text = inv.client.clientId;
    _contractNumber.text = inv.contractNumber;
    _accountHolder.text = inv.bankDetails.accountHolder;
    _institution.text = inv.bankDetails.institution;
    _iban.text = inv.bankDetails.iban;
    _bic.text = inv.bankDetails.bic;
    _invoiceDate = inv.invoiceDate;
    _paidOn = inv.paidOn;
    final items = inv.invoiceItemList.isNotEmpty
        ? inv.invoiceItemList
        : [
            const InvoiceItem(
              position: 1,
              serviceMonth: null,
              serviceYear: null,
              unitType: UnitType.hours,
              quantity: 0,
              unitPrice: 0,
              serviceDescription: '',
            ),
          ];

    _serviceMonths = items.map((e) => e.serviceMonth).toList();
    _serviceYears = items.map((e) => e.serviceYear).toList();
    _serviceDates = items.map((e) => e.serviceDate).toList();
    _useServiceDate = items.map((e) => e.serviceDate != null).toList();
    _invoiceItemRowIds = List<String>.generate(items.length, (_) => Uuid().v4());

    for (final c in _quantityControllers) {
      c.dispose();
    }
    for (final c in _unitPriceControllers) {
      c.dispose();
    }
    for (final c in _serviceDescriptionControllers) {
      c.dispose();
    }

    _unitTypes = items.map((e) => e.unitType).toList();
    _quantityControllers = items.map((e) => TextEditingController(text: e.quantity.toString())).toList();
    _unitPriceControllers = items.map((e) => TextEditingController(text: e.unitPrice.toString())).toList();
    _serviceDescriptionControllers = items.map((e) => TextEditingController(text: e.serviceDescription)).toList();
    _discountType = inv.discountType;
    _vat = inv.vat;
    _discountValue.text = inv.discountValue.toString();
    _dueDateType = inv.dueDateType;
    _hasQrCode = inv.hasQrCode;
    _customDueDate = inv.customDueDate;
    _jobDescription.text = inv.sender.jobDescription;
    _introductoryText.text = inv.introductoryText;
    // invoiceItemList already handled above
  }

  void _applyDefaults(InvoiceDefaults d) {
    if (_loadedInvoice != null) return;

    _paidOn = null;
    _unitTypes = [UnitType.hours];
    _serviceMonths = [null];
    _serviceYears = [null];
    _serviceDates = [null];
    _useServiceDate = [false];
    _invoiceItemRowIds = [Uuid().v4()];
    if (_quantityControllers.isEmpty) {
      _quantityControllers = [TextEditingController()];
    }
    if (_unitPriceControllers.isEmpty) {
      _unitPriceControllers = [TextEditingController()];
    }

    // Prefill invoice number for "new invoice" screens:
    // lastInvoiceNumber + 1 (preserve possible prefix and zero-padding).
    _invoiceNumber.text = nextInvoiceNumber(d.lastInvoiceNumber);

    _senderName.text = d.sender.name;
    _senderStreetNameAndNumber.text = d.sender.address.streetNameAndNumber;
    _senderPostalCode.text = d.sender.address.postalCode == 0 ? '' : d.sender.address.postalCode.toString();
    _senderTown.text = d.sender.address.town;
    _senderCountry.text = d.sender.address.country.isNotEmpty ? d.sender.address.country : 'Deutschland';
    _senderPhone.text = d.sender.phoneNumber;
    _senderEmail.text = d.sender.email;
    _senderWebsite.text = d.sender.website;
    // New invoices: do not prefill client fields (enter per invoice).
    _clientName.clear();
    _clientCompanyName.clear();
    _clientStreetNameAndNumber.clear();
    _clientPostalCode.clear();
    _clientTown.clear();
    _clientCountry.text = 'Deutschland';
    _clientId.clear();
    _contractNumber.text = d.contractNumber;
    if (d.bankDetails != null) {
      _accountHolder.text = d.bankDetails!.accountHolder;
      _institution.text = d.bankDetails!.institution;
      _iban.text = d.bankDetails!.iban;
      _bic.text = d.bankDetails!.bic;
    }
    _unitPriceControllers[0].text = d.hourlyRate > 0 ? d.hourlyRate.toString() : '0';
    _discountType = d.discountType;
    _vat = 0.19;
    _discountValue.text = d.discountValue.toString();
    _dueDateType = d.dueDateType;
    _hasQrCode = false;
    _jobDescription.text = d.sender.jobDescription;
    // Prefill the invoice greeting text for new invoices.
    _introductoryText.text =
        'Sehr geehrte Damen und Herren,\nfür das Erbringen meiner Dienstleistungen berechne ich Ihnen:';
    final m0 = _serviceMonths.first;
    final y0 = _serviceYears.first;
    if (d.serviceDescriptionTemplate.isNotEmpty) {
      var text = d.serviceDescriptionTemplate;
      if (m0 != null && y0 != null) {
        text = text.replaceAll('{PERIOD}', _periodPlaceholderFor(m0, y0));
      }
      _serviceDescriptionControllers[0].text = text;
    } else {
      if (m0 != null && y0 != null) {
        _serviceDescriptionControllers[0].text = defaultServiceDescriptionTemplate.replaceAll(
          '{PERIOD}',
          _periodPlaceholderFor(m0, y0),
        );
      } else {
        _serviceDescriptionControllers[0].text = defaultServiceDescriptionTemplate;
      }
    }
    _ustId.text = d.sender.ustId.isNotEmpty ? d.sender.ustId : d.ustId;
    _taxNumber.text = d.sender.taxNumber;
  }

  void _backFromForm(BuildContext context) {
    if (isWideInvoiceLayout(context)) {
      context.go('/');
    } else if (context.canPop()) {
      context.pop();
    } else {
      context.go('/');
    }
  }

  bool _isOverdueInForm() {
    if (widget.invoiceId == null) return false;
    if (_invoiceDate == null) return false;
    if (_loadedInvoice == null) return false;

    // Build a snapshot invoice using the current form fields so the helper
    // can compute the due date accurately (including custom due dates).
    final snapshot = _loadedInvoice!.copyWith(
      invoiceDate: _invoiceDate!,
      paidOn: _paidOn,
      dueDateType: _dueDateType,
      customDueDate: _dueDateType == DueDateType.custom ? _customDueDate : null,
    );

    return isOverdueUnpaid(snapshot);
  }

  String _periodPlaceholderFor(int month, int year) {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 0);
    final fmt = DateFormat('dd.MM.yyyy');
    return '${fmt.format(start)} - ${fmt.format(end)}';
  }

  String _serviceDatePlaceholderFor(DateTime d) {
    final fmt = DateFormat('dd.MM.yyyy');
    return fmt.format(d);
  }

  bool _hasPeriodAt(int index) {
    if (_useServiceDate[index]) {
      return _serviceDates[index] != null;
    }
    final m = _serviceMonths[index];
    final y = _serviceYears[index];
    return m != null && y != null;
  }

  /// Updates the Leistungsbeschreibung so the date range matches the chosen
  /// Leistungszeitraum (month/year). Replaces {PERIOD} or any existing
  /// dd.MM.yyyy - dd.MM.yyyy range with the current period.
  void _updateItemPeriodInDescription(int index) {
    if (!_hasPeriodAt(index)) return;
    final t = _serviceDescriptionControllers[index].text;
    final newPeriod = _useServiceDate[index]
        ? _serviceDatePlaceholderFor(_serviceDates[index]!)
        : _periodPlaceholderFor(_serviceMonths[index]!, _serviceYears[index]!);
    if (t.contains('{PERIOD}')) {
      _serviceDescriptionControllers[index].text = t.replaceAll('{PERIOD}', newPeriod);
      return;
    }
    // Replace existing date range (e.g. "01.03.2026 - 31.03.2026") with new period
    final periodPattern = RegExp(r'\d{2}\.\d{2}\.\d{4}\s*-\s*\d{2}\.\d{2}\.\d{4}');
    if (periodPattern.hasMatch(t)) {
      _serviceDescriptionControllers[index].text = t.replaceFirst(periodPattern, newPeriod);
    }
  }

  void _addInvoiceItem() {
    final baseQuantityText = _quantityControllers.isNotEmpty ? _quantityControllers.last.text : '';
    final baseUnitPriceText = _unitPriceControllers.isNotEmpty ? _unitPriceControllers.last.text : '';
    final baseServiceDescriptionText =
        _serviceDescriptionControllers.isNotEmpty ? _serviceDescriptionControllers.last.text : '';
    final baseUnitType = _unitTypes.isNotEmpty ? _unitTypes.last : UnitType.hours;

    setState(() {
      _serviceMonths.add(null);
      _serviceYears.add(null);
      _serviceDates.add(null);
      _useServiceDate.add(false);
      _invoiceItemRowIds.add(Uuid().v4());
      _unitTypes.add(baseUnitType);
      _quantityControllers.add(TextEditingController(text: baseQuantityText));
      _unitPriceControllers.add(TextEditingController(text: baseUnitPriceText));
      _serviceDescriptionControllers.add(TextEditingController(text: baseServiceDescriptionText));
      // The new item starts with the same month/year as the last one, so no
      // period replacement is needed until the user changes the month/year.
    });
  }

  void _removeInvoiceItem(int index) {
    if (index < 0 || index >= _serviceMonths.length || _serviceMonths.length <= 1) {
      return;
    }
    setState(() {
      _quantityControllers[index].dispose();
      _unitPriceControllers[index].dispose();
      _serviceDescriptionControllers[index].dispose();

      _serviceMonths.removeAt(index);
      _serviceYears.removeAt(index);
      _serviceDates.removeAt(index);
      _useServiceDate.removeAt(index);
      _invoiceItemRowIds.removeAt(index);
      _unitTypes.removeAt(index);
      _quantityControllers.removeAt(index);
      _unitPriceControllers.removeAt(index);
      _serviceDescriptionControllers.removeAt(index);
    });
  }

  void _onUnitTypeChanged(int index, UnitType type) {
    setState(() {
      _unitTypes[index] = type;
    });
  }

  void _onReorderInvoiceItems(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      void move<T>(List<T> list) {
        final item = list.removeAt(oldIndex);
        list.insert(newIndex, item);
      }

      move(_invoiceItemRowIds);
      move(_serviceMonths);
      move(_serviceYears);
      move(_serviceDates);
      move(_useServiceDate);
      move(_unitTypes);
      move(_quantityControllers);
      move(_unitPriceControllers);
      move(_serviceDescriptionControllers);
    });
  }

  List<Client> _existingClientsFromInvoices(List<Invoice> invoices) {
    final seen = <String>{};
    final clients = <Client>[];
    for (final invoice in invoices) {
      final c = invoice.client;
      final dedupeKey = [
        c.companyName.trim().toLowerCase(),
        c.name.trim().toLowerCase(),
        c.address.streetNameAndNumber.trim().toLowerCase(),
        c.address.postalCode.toString(),
        c.address.town.trim().toLowerCase(),
        c.address.country.trim().toLowerCase(),
      ].join('|');
      if (seen.add(dedupeKey)) {
        clients.add(c);
      }
    }
    return clients;
  }

  String _clientKey(Client c) {
    return [
      c.companyName.trim().toLowerCase(),
      c.name.trim().toLowerCase(),
      c.address.streetNameAndNumber.trim().toLowerCase(),
      c.address.postalCode.toString(),
      c.address.town.trim().toLowerCase(),
      c.address.country.trim().toLowerCase(),
    ].join('|');
  }

  void _applySelectedClient(Client client) {
    _clientCompanyName.text = client.companyName;
    _clientName.text = client.name;
    _clientStreetNameAndNumber.text = client.address.streetNameAndNumber;
    _clientPostalCode.text = client.address.postalCode == 0 ? '' : client.address.postalCode.toString();
    _clientTown.text = client.address.town;
    _clientCountry.text = client.address.country.isNotEmpty ? client.address.country : 'Deutschland';
    _clientId.text = client.clientId;
  }

  @override
  Widget build(BuildContext context) {
    final isNew = widget.invoiceId == null;
    final asyncInvoice = widget.invoiceId != null ? ref.watch(invoiceDetailProvider(widget.invoiceId!)) : null;
    final asyncDefaults = ref.watch(defaultsProvider);
    final asyncInvoiceList = ref.watch(invoiceListProvider);
    final allExistingClients =
        asyncInvoiceList.hasValue ? _existingClientsFromInvoices(asyncInvoiceList.value!) : <Client>[];
    final existingClients = allExistingClients.where((c) => !_deletedClientKeys.contains(_clientKey(c))).toList();

    if (widget.invoiceId != null) {
      ref.listen<AsyncValue<Invoice?>>(
        invoiceDetailProvider(widget.invoiceId!),
        (prev, next) {
          next.whenData((inv) {
            if (inv == null) return;
            if (!_initialized) {
              if (inv != _loadedInvoice) {
                _loadedInvoice = inv;
                _applyInvoice(inv);
                _initialized = true;
              }
              return;
            }
            // Same invoice reloaded (e.g. "bezahlt am" updated from list in split layout).
            if (_loadedInvoice != null && inv.id == _loadedInvoice!.id && inv != _loadedInvoice) {
              setState(() {
                _paidOn = inv.paidOn;
                _loadedInvoice = inv;
              });
            }
          });
        },
      );
    }

    if (widget.invoiceId == null && asyncDefaults.hasValue && _defaults == null && !_initialized) {
      _defaults = asyncDefaults.value;
      _applyDefaults(asyncDefaults.value!);
      _initialized = true;
    }
    if (widget.invoiceId != null && asyncInvoice?.hasValue == true && asyncInvoice?.value != null && !_initialized) {
      _loadedInvoice = asyncInvoice!.value;
      _applyInvoice(asyncInvoice.value!);
      if (asyncDefaults.hasValue) {
        _defaults = asyncDefaults.value;
      }
      _initialized = true;
    }

    // Eingeklappt, sobald alle Pflichtfelder des Blocks gültig befüllt sind.
    final senderExpanded = !_senderMandatoryComplete();
    final bankExpanded = !_bankMandatoryComplete();
    final clientExpanded = !_clientMandatoryComplete();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Text(
                isNew ? 'Neue Rechnung' : 'Rechnung bearbeiten',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (!isNew && _isOverdueInForm()) ...[
              const SizedBox(width: 8),
              const OverdueChip(),
            ],
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _backFromForm(context),
          tooltip: 'Zurück',
        ),
        actions: [
          TextButton.icon(
            onPressed: () => _backFromForm(context),
            icon: const Icon(Icons.close),
            label: const Text('Abbrechen'),
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: () => _save(context, ref),
            icon: const Icon(Icons.save_outlined),
            label: const Text('Speichern'),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: () => _saveAndPreview(context, ref),
            icon: const Icon(Icons.picture_as_pdf_outlined),
            label: const Text('Vorschau'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      // Only block the form on the *initial* load. A refetch (e.g. invalidate)
      // would otherwise swap in a spinner and reset scroll.
      body:
          asyncInvoice != null && widget.invoiceId != null && asyncInvoice.isLoading && asyncInvoice.valueOrNull == null
              ? const Center(child: CircularProgressIndicator())
              : Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Zeile 1: Absender + Bankverbindung
                          SenderFields(
                            senderNameController: _senderName,
                            jobDescriptionController: _jobDescription,
                            senderStreetNameAndNumberController: _senderStreetNameAndNumber,
                            senderPostalCodeController: _senderPostalCode,
                            senderTownController: _senderTown,
                            senderCountryController: _senderCountry,
                            senderPhoneController: _senderPhone,
                            senderEmailController: _senderEmail,
                            senderWebsiteController: _senderWebsite,
                            ustIdController: _ustId,
                            taxNumberController: _taxNumber,
                            initiallyExpanded: senderExpanded,
                          ),
                          const SizedBox(height: 20),
                          BankDetailsFields(
                            accountHolderController: _accountHolder,
                            institutionController: _institution,
                            ibanController: _iban,
                            bicController: _bic,
                            initiallyExpanded: bankExpanded,
                          ),
                          const SizedBox(height: 30),
                          // Zeile 2: Kunde
                          ClientFields(
                            existingClients: existingClients,
                            onExistingClientPicked: (client) => setState(() => _applySelectedClient(client)),
                            onDeleteClientKey: (key) {
                              setState(() {
                                _deletedClientKeys.add(key);
                              });
                            },
                            clientCompanyNameController: _clientCompanyName,
                            clientNameController: _clientName,
                            clientStreetNameAndNumberController: _clientStreetNameAndNumber,
                            clientPostalCodeController: _clientPostalCode,
                            clientTownController: _clientTown,
                            clientCountryController: _clientCountry,
                            clientIdController: _clientId,
                            contractNumberController: _contractNumber,
                            initiallyExpanded: clientExpanded,
                          ),
                          const SizedBox(height: 30),
                          // Zeile 3: Rechnungsdetails
                          InvoiceDetailFields(
                            invoiceNumberController: _invoiceNumber,
                            invoiceDate: _invoiceDate,
                            onInvoiceDateTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: _invoiceDate ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (date != null) setState(() => _invoiceDate = date);
                            },
                            paidOn: _paidOn,
                            onPaidOnTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: _paidOn ?? _invoiceDate ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (date != null) setState(() => _paidOn = date);
                            },
                            onClearPaidOn: () => setState(() => _paidOn = null),
                            introductoryTextController: _introductoryText,
                            serviceMonths: _serviceMonths,
                            serviceYears: _serviceYears,
                            serviceDates: _serviceDates,
                            useServiceDate: _useServiceDate,
                            unitTypes: _unitTypes,
                            quantityControllers: _quantityControllers,
                            unitPriceControllers: _unitPriceControllers,
                            onUnitTypeChanged: _onUnitTypeChanged,
                            serviceDescriptionControllers: _serviceDescriptionControllers,
                            onServicePeriodModeChanged: (index, useDate) {
                              setState(() {
                                _useServiceDate[index] = useDate;
                                if (useDate) {
                                  _serviceMonths[index] = null;
                                  _serviceYears[index] = null;
                                } else {
                                  _serviceDates[index] = null;
                                }
                              });
                            },
                            onServiceMonthChanged: (index, v) {
                              setState(() {
                                _serviceMonths[index] = v;
                                if (_hasPeriodAt(index)) {
                                  _updateItemPeriodInDescription(index);
                                }
                              });
                            },
                            onServiceYearChanged: (index, v) {
                              setState(() {
                                _serviceYears[index] = v;
                                if (_hasPeriodAt(index)) {
                                  _updateItemPeriodInDescription(index);
                                }
                              });
                            },
                            onServiceDateTap: (index) async {
                              final initial = _serviceDates[index] ?? _invoiceDate ?? DateTime.now();
                              final date = await showDatePicker(
                                context: context,
                                initialDate: initial,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (date != null) {
                                setState(() {
                                  _serviceDates[index] = date;
                                  if (_hasPeriodAt(index)) {
                                    _updateItemPeriodInDescription(index);
                                  }
                                });
                              }
                            },
                            onClearServiceDate: (index) {
                              setState(() {
                                _serviceDates[index] = null;
                              });
                            },
                            onAddInvoiceItem: _addInvoiceItem,
                            onRemoveInvoiceItem: _removeInvoiceItem,
                            invoiceItemRowIds: _invoiceItemRowIds,
                            onReorderInvoiceItems: _onReorderInvoiceItems,
                            discountType: _discountType,
                            onDiscountTypeChanged: (v) => setState(() => _discountType = v),
                            discountValueController: _discountValue,
                            vat: _vat,
                            onVatChanged: (v) => setState(() => _vat = v),
                            hasQrCode: _hasQrCode,
                            onHasQrCodeChanged: (v) => setState(() => _hasQrCode = v),
                            dueDateType: _dueDateType,
                            onDueDateTypeChanged: (v) => setState(() => _dueDateType = v),
                            customDueDate: _customDueDate,
                            onCustomDueDateTap: () async {
                              final d = await showDatePicker(
                                context: context,
                                initialDate:
                                    _customDueDate ?? _invoiceDate?.add(const Duration(days: 14)) ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (d != null) setState(() => _customDueDate = d);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }

  Future<void> _saveAndPreview(BuildContext context, WidgetRef ref) async {
    if (!_formKey.currentState!.validate()) return;
    final (invoice, _) = _buildInvoiceFromForm();
    if (invoice == null) return;
    await ref.read(invoiceRepositoryProvider).save(invoice);
    await _updateDefaultsFromForm(ref);
    ref.invalidate(invoiceListProvider);
    ref.invalidate(invoiceDetailProvider(invoice.id));
    ref.invalidate(defaultsProvider);
    if (!context.mounted) return;
    if (isWideInvoiceLayout(context)) {
      context.go(pathPreview(invoice.id));
    } else {
      context.push(pathPreview(invoice.id));
    }
  }

  Future<void> _updateDefaultsFromForm(WidgetRef ref) async {
    final defaultsRepo = ref.read(defaultsRepositoryProvider);
    final current = await defaultsRepo.load();
    final hourlyIndex = _unitTypes.indexOf(UnitType.hours);
    final double rate = hourlyIndex >= 0 && hourlyIndex < _unitPriceControllers.length
        ? (double.tryParse(
              _unitPriceControllers[hourlyIndex].text.replaceFirst(',', '.'),
            ) ??
            0.0)
        : 0.0;
    await defaultsRepo.save(current.copyWith(
      lastInvoiceNumber: widget.invoiceId == null ? _invoiceNumber.text.trim() : current.lastInvoiceNumber,
      sender: Sender(
        name: _senderName.text.trim(),
        jobDescription: _jobDescription.text.trim(),
        address: Adress(
          streetNameAndNumber: _senderStreetNameAndNumber.text.trim(),
          town: _senderTown.text.trim(),
          country: _senderCountry.text.trim(),
          postalCode: int.tryParse(_senderPostalCode.text.trim()) ?? 0,
        ),
        phoneNumber: _senderPhone.text.trim(),
        email: _senderEmail.text.trim(),
        website: _senderWebsite.text.trim(),
        ustId: _ustId.text.trim(),
        taxNumber: _taxNumber.text.trim(),
      ),
      client: Client(
        clientId: _clientId.text.trim(),
        companyName: _clientCompanyName.text.trim(),
        name: _clientName.text.trim(),
        address: Adress(
          streetNameAndNumber: _clientStreetNameAndNumber.text.trim(),
          town: _clientTown.text.trim(),
          country: _clientCountry.text.trim(),
          postalCode: int.tryParse(_clientPostalCode.text.trim()) ?? 0,
        ),
      ),
      contractNumber: _contractNumber.text.trim(),
      bankDetails: BankDetails(
        accountHolder: _accountHolder.text.trim(),
        institution: _institution.text.trim(),
        iban: _iban.text.trim(),
        bic: _bic.text.trim(),
      ),
      ustId: _ustId.text.trim(),
      hourlyRate: rate,
      discountType: _discountType,
      discountValue: double.tryParse(_discountValue.text.replaceFirst(',', '.')) ?? 0,
      dueDateType: _dueDateType,
    ));
  }

  (Invoice?, String?) _buildInvoiceFromForm() {
    final discount = double.tryParse(_discountValue.text.replaceFirst(',', '.')) ?? 0;

    final items = List<InvoiceItem>.generate(_serviceMonths.length, (i) {
      final serviceDescription = _serviceDescriptionControllers[i].text.trim();
      final quantity = double.tryParse(
            _quantityControllers[i].text.replaceFirst(',', '.'),
          ) ??
          0;
      final unitPrice = double.tryParse(
            _unitPriceControllers[i].text.replaceFirst(',', '.'),
          ) ??
          0;
      return InvoiceItem(
        position: i + 1,
        serviceMonth: _useServiceDate[i] ? null : _serviceMonths[i],
        serviceYear: _useServiceDate[i] ? null : _serviceYears[i],
        serviceDate: _useServiceDate[i] ? _serviceDates[i] : null,
        unitType: _unitTypes[i],
        quantity: quantity,
        unitPrice: unitPrice,
        serviceDescription: serviceDescription,
      );
    });

    final subtotal = items.fold<double>(
      0.0,
      (sum, item) => sum + item.itemTotal,
    );
    final discountAmount = _discountType == DiscountType.percent ? subtotal * (discount / 100) : discount;
    if (discountAmount > subtotal) {
      return (null, 'Rabatt darf den Zwischensummenbetrag nicht übersteigen.');
    }
    final id = widget.invoiceId ?? _loadedInvoice?.id ?? const Uuid().v4();
    // Only use [DateTime.now] for brand-new invoices; never reset createdAt on edit.
    final haveLoadedSnapshot = _loadedInvoice != null && _loadedInvoice!.id == id;
    final createdAt = haveLoadedSnapshot ? _loadedInvoice!.createdAt : DateTime.now();
    final invoice = Invoice(
      id: id,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      invoiceNumber: _invoiceNumber.text.trim(),
      sender: Sender(
        name: _senderName.text.trim(),
        jobDescription: _jobDescription.text.trim(),
        address: Adress(
          streetNameAndNumber: _senderStreetNameAndNumber.text.trim(),
          town: _senderTown.text.trim(),
          country: _senderCountry.text.trim(),
          postalCode: int.tryParse(_senderPostalCode.text.trim()) ?? 0,
        ),
        phoneNumber: _senderPhone.text.trim(),
        email: _senderEmail.text.trim(),
        website: _senderWebsite.text.trim(),
        ustId: _ustId.text.trim(),
        taxNumber: _taxNumber.text.trim(),
      ),
      client: Client(
        clientId: _clientId.text.trim(),
        companyName: _clientCompanyName.text.trim(),
        name: _clientName.text.trim(),
        address: Adress(
          streetNameAndNumber: _clientStreetNameAndNumber.text.trim(),
          town: _clientTown.text.trim(),
          country: _clientCountry.text.trim(),
          postalCode: int.tryParse(_clientPostalCode.text.trim()) ?? 0,
        ),
      ),
      contractNumber: _contractNumber.text.trim(),
      bankDetails: BankDetails(
        accountHolder: _accountHolder.text.trim(),
        institution: _institution.text.trim(),
        iban: _iban.text.trim(),
        bic: _bic.text.trim(),
      ),
      invoiceDate: _invoiceDate!,
      paidOn: _paidOn,
      invoiceItemList: items,
      discountType: _discountType,
      discountValue: discount,
      vat: _vat,
      dueDateType: _dueDateType,
      hasQrCode: _hasQrCode,
      customDueDate: _dueDateType == DueDateType.custom ? _customDueDate : null,
      introductoryText: _introductoryText.text.trim(),
    );
    return (invoice, null);
  }

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    if (!_formKey.currentState!.validate()) return;
    final (invoice, error) = _buildInvoiceFromForm();
    if (invoice == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error ?? 'Ungültige Eingabe')),
        );
      }
      return;
    }
    await ref.read(invoiceRepositoryProvider).save(invoice);
    await _updateDefaultsFromForm(ref);
    ref.invalidate(defaultsProvider);
    ref.invalidate(invoiceListProvider);
    // Do not invalidate invoiceDetailProvider here: that would put the watched
    // provider into loading, replace the form with a spinner, and reset scroll.
    // Controllers already hold the saved data; disk matches after save.
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rechnung gespeichert')),
      );
      if (isWideInvoiceLayout(context)) {
        final target = pathEdit(invoice.id);
        if (GoRouterState.of(context).uri.path != target) {
          context.go(target);
        }
      } else {
        context.go('/');
      }
    }
  }
}
