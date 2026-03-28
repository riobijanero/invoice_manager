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

/// Anzeigetext für Kunden-Dropdowns (Firma, sonst Name).
String clientMenuLabel(Client client) {
  final company = client.companyName.trim();
  if (company.isNotEmpty) return company;
  final name = client.name.trim();
  if (name.isNotEmpty) return name;
  return 'Unbenannter Kunde';
}

/// Kunden aus Rechnungen plus [defaultsClient], wenn sinnvoll befüllt (ohne Duplikate).
List<Client> mergedClientsForInvoiceListFilter(
  List<Invoice> invoices,
  Client defaultsClient,
) {
  final fromInvoices = uniqueClientsFromInvoices(invoices);
  final seen = {for (final c in fromInvoices) clientDedupeKey(c)};
  final out = List<Client>.from(fromInvoices);
  final d = defaultsClient;
  if (d.companyName.trim().isNotEmpty || d.name.trim().isNotEmpty) {
    final k = clientDedupeKey(d);
    if (!seen.contains(k)) {
      out.add(d);
    }
  }
  return out;
}
