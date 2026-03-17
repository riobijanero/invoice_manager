import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'routing/app_router.dart';

void main() {
  runApp(
    const ProviderScope(
      child: InvoiceManagerApp(),
    ),
  );
}

class InvoiceManagerApp extends StatelessWidget {
  const InvoiceManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Rechnungsverwaltung',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}
