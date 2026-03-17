import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:invoice_manager/common/providers/providers.dart';
import 'package:uuid/uuid.dart';

import 'package:invoice_manager/common/models/bank_details.dart';
import 'package:invoice_manager/common/models/client.dart';
import 'package:invoice_manager/common/models/discount_type.dart';
import 'package:invoice_manager/common/models/due_date_type.dart';
import 'package:invoice_manager/common/models/invoice.dart';
import 'package:invoice_manager/common/models/invoice_defaults.dart';
import 'package:invoice_manager/common/models/sender.dart';
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
  late TextEditingController _senderAddress;
  late TextEditingController _senderPhone;
  late TextEditingController _senderEmail;
  late TextEditingController _senderWebsite;
  late TextEditingController _clientName;
  late TextEditingController _clientAddress;
  late TextEditingController _contractNumber;
  late TextEditingController _accountHolder;
  late TextEditingController _institution;
  late TextEditingController _iban;
  late TextEditingController _bic;
  late TextEditingController _hours;
  late TextEditingController _hourlyRate;
  late TextEditingController _discountValue;
  late TextEditingController _jobDescription;
  late TextEditingController _serviceDescription;
  late TextEditingController _ustId;
  late TextEditingController _businessTitle;

  DateTime? _invoiceDate;
  int _serviceMonth = DateTime.now().month;
  int _serviceYear = DateTime.now().year;
  DiscountType _discountType = DiscountType.percent;
  DueDateType _dueDateType = DueDateType.twoWeeks;
  DateTime? _customDueDate;
  Invoice? _loadedInvoice;
  InvoiceDefaults? _defaults;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _invoiceNumber = TextEditingController();
    _senderName = TextEditingController();
    _senderAddress = TextEditingController();
    _senderPhone = TextEditingController();
    _senderEmail = TextEditingController();
    _senderWebsite = TextEditingController();
    _clientName = TextEditingController();
    _clientAddress = TextEditingController();
    _contractNumber = TextEditingController();
    _accountHolder = TextEditingController();
    _institution = TextEditingController();
    _iban = TextEditingController();
    _bic = TextEditingController();
    _hours = TextEditingController();
    _hourlyRate = TextEditingController();
    _discountValue = TextEditingController(text: '0');
    _jobDescription = TextEditingController();
    _serviceDescription = TextEditingController();
    _ustId = TextEditingController();
    _businessTitle = TextEditingController(text: 'App und Webentwicklung');
    _invoiceDate = DateTime.now();
  }

  @override
  void dispose() {
    _invoiceNumber.dispose();
    _senderName.dispose();
    _senderAddress.dispose();
    _senderPhone.dispose();
    _senderEmail.dispose();
    _senderWebsite.dispose();
    _clientName.dispose();
    _clientAddress.dispose();
    _contractNumber.dispose();
    _accountHolder.dispose();
    _institution.dispose();
    _iban.dispose();
    _bic.dispose();
    _hours.dispose();
    _hourlyRate.dispose();
    _discountValue.dispose();
    _jobDescription.dispose();
    _serviceDescription.dispose();
    _ustId.dispose();
    _businessTitle.dispose();
    super.dispose();
  }

  void _applyInvoice(Invoice inv) {
    _invoiceNumber.text = inv.invoiceNumber;
    _senderName.text = inv.sender.name;
    _senderAddress.text = inv.sender.address;
    _senderPhone.text = inv.sender.phoneNumber;
    _senderEmail.text = inv.sender.email;
    _senderWebsite.text = inv.sender.website;
    _ustId.text = inv.sender.ustId;
    _clientName.text = inv.client.name;
    _clientAddress.text = inv.client.address;
    _contractNumber.text = inv.contractNumber;
    _accountHolder.text = inv.bankDetails.accountHolder;
    _institution.text = inv.bankDetails.institution;
    _iban.text = inv.bankDetails.iban;
    _bic.text = inv.bankDetails.bic;
    _invoiceDate = inv.invoiceDate;
    _businessTitle.text = inv.businessTitle;
    _serviceMonth = inv.serviceMonth;
    _serviceYear = inv.serviceYear;
    _hours.text = inv.hours.toString();
    _hourlyRate.text = inv.hourlyRate.toString();
    _discountType = inv.discountType;
    _discountValue.text = inv.discountValue.toString();
    _dueDateType = inv.dueDateType;
    _customDueDate = inv.customDueDate;
    _jobDescription.text = inv.jobDescription;
    _serviceDescription.text = inv.serviceDescription;
  }

  void _applyDefaults(InvoiceDefaults d) {
    if (_loadedInvoice != null) return;

    // Prefill invoice number for "new invoice" screens:
    // lastInvoiceNumber + 1 (preserve possible prefix and zero-padding).
    _invoiceNumber.text = nextInvoiceNumber(d.lastInvoiceNumber);

    _senderName.text = d.sender.name;
    _senderAddress.text = d.sender.address;
    _senderPhone.text = d.sender.phoneNumber;
    _senderEmail.text = d.sender.email;
    _senderWebsite.text = d.sender.website;
    _clientName.text = d.client.name;
    _clientAddress.text = d.client.address;
    _contractNumber.text = d.contractNumber;
    if (d.bankDetails != null) {
      _accountHolder.text = d.bankDetails!.accountHolder;
      _institution.text = d.bankDetails!.institution;
      _iban.text = d.bankDetails!.iban;
      _bic.text = d.bankDetails!.bic;
    }
    _hourlyRate.text = d.hourlyRate > 0 ? d.hourlyRate.toString() : '';
    _discountType = d.discountType;
    _discountValue.text = d.discountValue.toString();
    _dueDateType = d.dueDateType;
    _jobDescription.text = d.sender.jobDescription;
    if (d.serviceDescriptionTemplate.isNotEmpty) {
      final period = _periodPlaceholder();
      _serviceDescription.text = d.serviceDescriptionTemplate.replaceAll('{PERIOD}', period);
    } else {
      _serviceDescription.text = defaultServiceDescriptionTemplate.replaceAll('{PERIOD}', _periodPlaceholder());
    }
    _ustId.text = d.sender.ustId.isNotEmpty ? d.sender.ustId : d.ustId;
    _businessTitle.text = d.businessTitle;
  }

  String _periodPlaceholder() {
    final start = DateTime(_serviceYear, _serviceMonth, 1);
    final end = DateTime(_serviceYear, _serviceMonth + 1, 0);
    final fmt = DateFormat('dd.MM.yyyy');
    return '${fmt.format(start)} - ${fmt.format(end)}';
  }

  /// Updates the Leistungsbeschreibung so the date range matches the chosen
  /// Leistungszeitraum (month/year). Replaces {PERIOD} or any existing
  /// dd.MM.yyyy - dd.MM.yyyy range with the current period.
  void _updatePeriodInDescription() {
    final t = _serviceDescription.text;
    final newPeriod = _periodPlaceholder();
    if (t.contains('{PERIOD}')) {
      _serviceDescription.text = t.replaceAll('{PERIOD}', newPeriod);
      return;
    }
    // Replace existing date range (e.g. "01.03.2026 - 31.03.2026") with new period
    final periodPattern = RegExp(r'\d{2}\.\d{2}\.\d{4}\s*-\s*\d{2}\.\d{2}\.\d{4}');
    if (periodPattern.hasMatch(t)) {
      _serviceDescription.text = t.replaceFirst(periodPattern, newPeriod);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isNew = widget.invoiceId == null;
    final asyncInvoice = widget.invoiceId != null ? ref.watch(invoiceDetailProvider(widget.invoiceId!)) : null;
    final asyncDefaults = ref.watch(defaultsProvider);

    if (widget.invoiceId != null) {
      ref.listen<AsyncValue<Invoice?>>(
        invoiceDetailProvider(widget.invoiceId!),
        (prev, next) {
          next.whenData((inv) {
            if (inv != null && inv != _loadedInvoice && !_initialized) {
              _loadedInvoice = inv;
              _applyInvoice(inv);
              _initialized = true;
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
        _businessTitle.text = _defaults!.businessTitle.isNotEmpty ? _defaults!.businessTitle : 'App und Webentwicklung';
      }
      _initialized = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isNew ? 'Neue Rechnung Nr ${_invoiceNumber.text}' : 'Rechnung (${_invoiceNumber.text}) bearbeiten'),
      ),
      body: asyncInvoice != null && asyncInvoice.isLoading && widget.invoiceId != null
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Wrap(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: Column(
                            children: [
                              SenderFields(
                                senderNameController: _senderName,
                                jobDescriptionController: _jobDescription,
                                senderAddressController: _senderAddress,
                                senderPhoneController: _senderPhone,
                                senderEmailController: _senderEmail,
                                senderWebsiteController: _senderWebsite,
                                ustIdController: _ustId,
                              ),
                              const SizedBox(height: 20),
                              BankDetailsFields(
                                accountHolderController: _accountHolder,
                                institutionController: _institution,
                                ibanController: _iban,
                                bicController: _bic,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ClientFields(
                                clientNameController: _clientName,
                                clientAddressController: _clientAddress,
                                contractNumberController: _contractNumber,
                              ),
                              const SizedBox(height: 30),
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
                                serviceMonth: _serviceMonth,
                                serviceYear: _serviceYear,
                                onServiceMonthChanged: (v) {
                                  setState(() {
                                    _serviceMonth = v;
                                    _updatePeriodInDescription();
                                  });
                                },
                                onServiceYearChanged: (v) {
                                  setState(() {
                                    _serviceYear = v;
                                    _updatePeriodInDescription();
                                  });
                                },
                                hoursController: _hours,
                                hourlyRateController: _hourlyRate,
                                discountType: _discountType,
                                onDiscountTypeChanged: (v) => setState(() => _discountType = v),
                                discountValueController: _discountValue,
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
                                serviceDescriptionController: _serviceDescription,
                                businessTitleController: _businessTitle,
                              ),
                              const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () => context.go('/'),
                                    child: const Text('abbrechen'),
                                  ),
                                  const SizedBox(width: 12),
                                  TextButton(
                                    onPressed: () => _save(context, ref),
                                    child: const Text('Speichern'),
                                  ),
                                  const SizedBox(width: 12),
                                  FilledButton(
                                    onPressed: () => _saveAndPreview(context, ref),
                                    child: const Text('Vorschau'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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
    if (context.mounted) context.push(pathPreview(invoice.id));
  }

  Future<void> _updateDefaultsFromForm(WidgetRef ref) async {
    final defaultsRepo = ref.read(defaultsRepositoryProvider);
    final current = await defaultsRepo.load();
    final rate = double.tryParse(_hourlyRate.text.replaceFirst(',', '.')) ?? 0;
    await defaultsRepo.save(current.copyWith(
      lastInvoiceNumber: widget.invoiceId == null ? _invoiceNumber.text.trim() : current.lastInvoiceNumber,
      sender: Sender(
        name: _senderName.text.trim(),
        jobDescription: _jobDescription.text.trim(),
        address: _senderAddress.text.trim(),
        phoneNumber: _senderPhone.text.trim(),
        email: _senderEmail.text.trim(),
        website: _senderWebsite.text.trim(),
        ustId: _ustId.text.trim(),
      ),
      client: Client(
        name: _clientName.text.trim(),
        address: _clientAddress.text.trim(),
      ),
      contractNumber: _contractNumber.text.trim(),
      bankDetails: BankDetails(
        accountHolder: _accountHolder.text.trim(),
        institution: _institution.text.trim(),
        iban: _iban.text.trim(),
        bic: _bic.text.trim(),
      ),
      ustId: _ustId.text.trim(),
      businessTitle: _businessTitle.text.trim().isEmpty ? 'App und Webentwicklung' : _businessTitle.text.trim(),
      hourlyRate: rate,
      discountType: _discountType,
      discountValue: double.tryParse(_discountValue.text.replaceFirst(',', '.')) ?? 0,
      dueDateType: _dueDateType,
    ));
  }

  (Invoice?, String?) _buildInvoiceFromForm() {
    final hours = double.tryParse(_hours.text.replaceFirst(',', '.')) ?? 0;
    final rate = double.tryParse(_hourlyRate.text.replaceFirst(',', '.')) ?? 0;
    final discount = double.tryParse(_discountValue.text.replaceFirst(',', '.')) ?? 0;
    final subtotal = hours * rate;
    final discountAmount = _discountType == DiscountType.percent ? subtotal * (discount / 100) : discount;
    if (discountAmount > subtotal) return (null, 'Rabatt darf den Zwischensummenbetrag nicht übersteigen.');
    final id = widget.invoiceId ?? _loadedInvoice?.id ?? const Uuid().v4();
    final createdAt = _loadedInvoice?.createdAt ?? DateTime.now();
    final invoice = Invoice(
      id: id,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      invoiceNumber: _invoiceNumber.text.trim(),
      sender: Sender(
        name: _senderName.text.trim(),
        jobDescription: _jobDescription.text.trim(),
        address: _senderAddress.text.trim(),
        phoneNumber: _senderPhone.text.trim(),
        email: _senderEmail.text.trim(),
        website: _senderWebsite.text.trim(),
        ustId: _ustId.text.trim(),
      ),
      client: Client(
        name: _clientName.text.trim(),
        address: _clientAddress.text.trim(),
      ),
      contractNumber: _contractNumber.text.trim(),
      bankDetails: BankDetails(
        accountHolder: _accountHolder.text.trim(),
        institution: _institution.text.trim(),
        iban: _iban.text.trim(),
        bic: _bic.text.trim(),
      ),
      invoiceDate: _invoiceDate!,
      businessTitle: _businessTitle.text.trim().isEmpty ? 'App und Webentwicklung' : _businessTitle.text.trim(),
      serviceMonth: _serviceMonth,
      serviceYear: _serviceYear,
      hours: hours,
      hourlyRate: rate,
      discountType: _discountType,
      discountValue: discount,
      dueDateType: _dueDateType,
      customDueDate: _dueDateType == DueDateType.custom ? _customDueDate : null,
      jobDescription: _jobDescription.text.trim(),
      serviceDescription: _serviceDescription.text.trim(),
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
    ref.invalidate(invoiceDetailProvider(invoice.id));
    ref.invalidate(defaultsProvider);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rechnung gespeichert')),
      );
      context.go('/');
    }
  }
}
