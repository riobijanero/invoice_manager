// Such-Query-Normalisierung für die Rechnungsliste.
/// Trim + Kleinbuchstaben für case-insensitive Teilstring-Suche.
String normalizeInvoiceSearchQuery(String query) => query.trim().toLowerCase();
