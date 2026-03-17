import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:invoice_manager/main.dart';

void main() {
  testWidgets('App shows Rechnungsliste', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: InvoiceManagerApp(),
      ),
    );
    expect(find.text('Rechnungsliste'), findsOneWidget);
  });
}
