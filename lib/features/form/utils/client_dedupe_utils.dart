// Dedupe-Key für gespeicherte Kunden (Rechnungsliste / Kundenauswahl im Formular).
import 'package:invoice_manager/common/models/client.dart';
import 'package:invoice_manager/common/models/invoice.dart';

/// Stabiler String-Schlüssel aus normalisierter Adresse und Namen (Kleinbuchstaben).
String clientDedupeKey(Client c) {
  return [
    c.companyName.trim().toLowerCase(),
    c.name.trim().toLowerCase(),
    c.address.streetNameAndNumber.trim().toLowerCase(),
    c.address.postalCode.toString(),
    c.address.town.trim().toLowerCase(),
    c.address.country.trim().toLowerCase(),
  ].join('|');
}

/// Eine Liste je eindeutigem [clientDedupeKey], Reihenfolge wie erstes Auftreten in [invoices].
List<Client> uniqueClientsFromInvoices(List<Invoice> invoices) {
  final seen = <String>{};
  final clients = <Client>[];
  for (final invoice in invoices) {
    final c = invoice.client;
    final key = clientDedupeKey(c);
    if (seen.add(key)) {
      clients.add(c);
    }
  }
  return clients;
}
