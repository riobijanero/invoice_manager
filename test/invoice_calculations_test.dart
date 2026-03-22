import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_manager/common/models/bank_details.dart';
import 'package:invoice_manager/common/models/client.dart';
import 'package:invoice_manager/common/models/discount_type.dart';
import 'package:invoice_manager/common/models/due_date_type.dart';
import 'package:invoice_manager/common/models/invoice.dart';
import 'package:invoice_manager/common/models/invoice_item.dart';
import 'package:invoice_manager/common/models/sender.dart';
import 'package:invoice_manager/common/utils/invoice_calculations.dart';

Invoice _minimalInvoice({
  required List<InvoiceItem> items,
  DiscountType discountType = DiscountType.percent,
  double discountValue = 0,
}) {
  final now = DateTime(2024, 6, 1);
  return Invoice(
    id: 't',
    createdAt: now,
    updatedAt: now,
    invoiceNumber: 'R-1',
    sender: Sender(
      name: 'S',
      jobDescription: '',
      address: '',
      phoneNumber: '',
      email: '',
      website: '',
      ustId: '',
      taxNumber: '',
    ),
    client: Client(companyName: '', name: 'C', address: ''),
    bankDetails: BankDetails(
      accountHolder: 'x',
      institution: 'y',
      iban: 'z',
      bic: 'w',
    ),
    invoiceDate: now,
    invoiceItemList: items,
    discountType: discountType,
    discountValue: discountValue,
    dueDateType: DueDateType.twoWeeks,
  );
}

void main() {
  group('computeTotals', () {
    test('applies percent discount to net and gross', () {
      final inv = _minimalInvoice(
        items: [
          InvoiceItem.hourlyRateService(
            serviceMonth: 5,
            serviceYear: 2024,
            hours: 10,
            hourlyRate: 100,
            serviceDescription: 'x',
          ),
        ],
        discountType: DiscountType.percent,
        discountValue: 10,
      );
      final t = computeTotals(inv);
      expect(t.subtotal, 1000.0);
      expect(t.discountAmount, 100.0);
      expect(t.net, 900.0);
      expect(t.vat, closeTo(171.0, 0.001));
      expect(t.gross, closeTo(1071.0, 0.001));
    });

    test('applies fixed amount (Betrag) discount', () {
      final inv = _minimalInvoice(
        items: [
          InvoiceItem.hourlyRateService(
            serviceMonth: 5,
            serviceYear: 2024,
            hours: 5,
            hourlyRate: 200,
            serviceDescription: 'x',
          ),
        ],
        discountType: DiscountType.amount,
        discountValue: 250,
      );
      final t = computeTotals(inv);
      expect(t.subtotal, 1000.0);
      expect(t.discountAmount, 250.0);
      expect(t.net, 750.0);
    });

    test('caps discount at subtotal', () {
      final inv = _minimalInvoice(
        items: [
          InvoiceItem.fixedPriceService(
            serviceMonth: 1,
            serviceYear: 2024,
            fixedPrice: 100,
            serviceDescription: 'x',
          ),
        ],
        discountType: DiscountType.amount,
        discountValue: 500,
      );
      final t = computeTotals(inv);
      expect(t.discountAmount, 100.0);
      expect(t.net, 0.0);
    });
  });
}
