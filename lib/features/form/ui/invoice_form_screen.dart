import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:invoice_manager/common/layout/invoice_layout_breakpoints.dart';
import 'package:invoice_manager/common/providers/providers.dart';
import 'package:invoice_manager/common/utils/date_utils.dart';
import 'package:invoice_manager/common/utils/quantity_format.dart';
import 'package:uuid/uuid.dart';

import 'package:invoice_manager/common/models/client.dart';
import 'package:invoice_manager/common/models/discount_type.dart';
import 'package:invoice_manager/common/models/due_date_type.dart';
import 'package:invoice_manager/common/models/invoice.dart';
import 'package:invoice_manager/common/models/invoice_defaults.dart';
import 'package:invoice_manager/common/models/invoice_item.dart';
import 'package:invoice_manager/features/form/ui/widgets/overdue_chip.dart';
import 'package:invoice_manager/features/form/services/invoice_form_defaults_sync.dart';
import 'package:invoice_manager/features/form/services/invoice_form_dto_builders.dart';
import 'package:invoice_manager/features/form/services/invoice_form_invoice_builder.dart';
import 'package:invoice_manager/features/form/services/invoice_line_items_builder.dart';
import 'package:invoice_manager/features/form/ui/sections/bank_details_fields.dart';
import 'package:invoice_manager/features/form/ui/sections/client_fields.dart';
import 'package:invoice_manager/features/form/ui/sections/invoice_detail_fields.dart';
import 'package:invoice_manager/features/form/ui/sections/sender_fields.dart';
import 'package:invoice_manager/features/form/utils/client_dedupe_utils.dart';
import 'package:invoice_manager/features/form/utils/form_mandatory_sections.dart';
import 'package:invoice_manager/features/form/utils/service_period_description.dart';
import 'package:invoice_manager/features/form/utils/utils.dart';
import '../../../routing/app_router.dart';

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
    _quantityControllers = items
        .map((e) => TextEditingController(text: formatQuantityForDisplay(e.quantity)))
        .toList();
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
        text = text.replaceAll('{PERIOD}', periodPlaceholderForMonthYear(m0, y0));
      }
      _serviceDescriptionControllers[0].text = text;
    } else {
      if (m0 != null && y0 != null) {
        _serviceDescriptionControllers[0].text = defaultServiceDescriptionTemplate.replaceAll(
          '{PERIOD}',
          periodPlaceholderForMonthYear(m0, y0),
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

  void _updateItemPeriodInDescription(int index) {
    if (!hasSelectedServicePeriod(
      useServiceDate: _useServiceDate[index],
      serviceDate: _serviceDates[index],
      serviceMonth: _serviceMonths[index],
      serviceYear: _serviceYears[index],
    )) {
      return;
    }
    final t = _serviceDescriptionControllers[index].text;
    final newPeriod = _useServiceDate[index]
        ? serviceDatePlaceholder(_serviceDates[index]!)
        : periodPlaceholderForMonthYear(_serviceMonths[index]!, _serviceYears[index]!);
    _serviceDescriptionControllers[index].text = replaceServicePeriodInDescription(t, newPeriod);
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
        asyncInvoiceList.hasValue ? uniqueClientsFromInvoices(asyncInvoiceList.value!) : <Client>[];
    final existingClients = allExistingClients.where((c) => !_deletedClientKeys.contains(clientDedupeKey(c))).toList();

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
    final senderExpanded = !isSenderMandatoryComplete(
      name: _senderName.text,
      street: _senderStreetNameAndNumber.text,
      postalCodeText: _senderPostalCode.text,
      town: _senderTown.text,
      country: _senderCountry.text,
    );
    final bankExpanded = !isBankMandatoryComplete(
      accountHolder: _accountHolder.text,
      institution: _institution.text,
      iban: _iban.text,
      bic: _bic.text,
    );
    final clientExpanded = !isClientMandatoryComplete(
      companyName: _clientCompanyName.text,
      personName: _clientName.text,
      street: _clientStreetNameAndNumber.text,
      postalCodeText: _clientPostalCode.text,
      town: _clientTown.text,
      country: _clientCountry.text,
    );

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
                                if (hasSelectedServicePeriod(
                                  useServiceDate: _useServiceDate[index],
                                  serviceDate: _serviceDates[index],
                                  serviceMonth: _serviceMonths[index],
                                  serviceYear: _serviceYears[index],
                                )) {
                                  _updateItemPeriodInDescription(index);
                                }
                              });
                            },
                            onServiceYearChanged: (index, v) {
                              setState(() {
                                _serviceYears[index] = v;
                                if (hasSelectedServicePeriod(
                                  useServiceDate: _useServiceDate[index],
                                  serviceDate: _serviceDates[index],
                                  serviceMonth: _serviceMonths[index],
                                  serviceYear: _serviceYears[index],
                                )) {
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
                                  if (hasSelectedServicePeriod(
                                    useServiceDate: _useServiceDate[index],
                                    serviceDate: _serviceDates[index],
                                    serviceMonth: _serviceMonths[index],
                                    serviceYear: _serviceYears[index],
                                  )) {
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
    final rate = hourlyRateFromUnitTypeRow(
      unitTypes: _unitTypes,
      unitPriceFieldTexts: _unitPriceControllers.map((c) => c.text).toList(),
    );
    await persistInvoiceDefaultsFromForm(
      defaultsRepo: defaultsRepo,
      isNewInvoice: widget.invoiceId == null,
      invoiceNumber: _invoiceNumber.text,
      sender: senderFromFormFields(
        name: _senderName.text,
        jobDescription: _jobDescription.text,
        street: _senderStreetNameAndNumber.text,
        town: _senderTown.text,
        country: _senderCountry.text,
        postalCodeText: _senderPostalCode.text,
        phone: _senderPhone.text,
        email: _senderEmail.text,
        website: _senderWebsite.text,
        ustId: _ustId.text,
        taxNumber: _taxNumber.text,
      ),
      client: clientFromFormFields(
        clientId: _clientId.text,
        companyName: _clientCompanyName.text,
        name: _clientName.text,
        street: _clientStreetNameAndNumber.text,
        town: _clientTown.text,
        country: _clientCountry.text,
        postalCodeText: _clientPostalCode.text,
      ),
      contractNumber: _contractNumber.text,
      bankDetails: bankDetailsFromFormFields(
        accountHolder: _accountHolder.text,
        institution: _institution.text,
        iban: _iban.text,
        bic: _bic.text,
      ),
      ustId: _ustId.text,
      hourlyRate: rate,
      discountType: _discountType,
      discountValue: double.tryParse(_discountValue.text.replaceFirst(',', '.')) ?? 0,
      dueDateType: _dueDateType,
    );
  }

  (Invoice?, String?) _buildInvoiceFromForm() {
    final discount = double.tryParse(_discountValue.text.replaceFirst(',', '.')) ?? 0;
    final items = parseInvoiceLineItemsFromForm(
      rowCount: _serviceMonths.length,
      useServiceDate: _useServiceDate,
      serviceMonths: _serviceMonths,
      serviceYears: _serviceYears,
      serviceDates: _serviceDates,
      unitTypes: _unitTypes,
      quantityTexts: _quantityControllers.map((c) => c.text).toList(),
      unitPriceTexts: _unitPriceControllers.map((c) => c.text).toList(),
      serviceDescriptions: _serviceDescriptionControllers.map((c) => c.text).toList(),
    );
    return buildStoredInvoice(
      routeInvoiceId: widget.invoiceId,
      loadedInvoice: _loadedInvoice,
      invoiceNumber: _invoiceNumber.text,
      invoiceDate: _invoiceDate!,
      paidOn: _paidOn,
      sender: senderFromFormFields(
        name: _senderName.text,
        jobDescription: _jobDescription.text,
        street: _senderStreetNameAndNumber.text,
        town: _senderTown.text,
        country: _senderCountry.text,
        postalCodeText: _senderPostalCode.text,
        phone: _senderPhone.text,
        email: _senderEmail.text,
        website: _senderWebsite.text,
        ustId: _ustId.text,
        taxNumber: _taxNumber.text,
      ),
      client: clientFromFormFields(
        clientId: _clientId.text,
        companyName: _clientCompanyName.text,
        name: _clientName.text,
        street: _clientStreetNameAndNumber.text,
        town: _clientTown.text,
        country: _clientCountry.text,
        postalCodeText: _clientPostalCode.text,
      ),
      contractNumber: _contractNumber.text,
      bankDetails: bankDetailsFromFormFields(
        accountHolder: _accountHolder.text,
        institution: _institution.text,
        iban: _iban.text,
        bic: _bic.text,
      ),
      items: items,
      discountType: _discountType,
      discountValue: discount,
      vat: _vat,
      dueDateType: _dueDateType,
      hasQrCode: _hasQrCode,
      customDueDate: _customDueDate,
      introductoryText: _introductoryText.text,
    );
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
    // Must refresh detail cache or reopening this invoice shows stale [AsyncData].
    // [Speichern & Vorschau] already did this; plain Speichern must match.
    ref.invalidate(invoiceDetailProvider(invoice.id));
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
