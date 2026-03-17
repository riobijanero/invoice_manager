/// How the invoice due date is determined.
enum DueDateType {
  twoWeeks,
  thirtyDays,
  custom,
}

extension DueDateTypeX on DueDateType {
  String get displayName {
    switch (this) {
      case DueDateType.twoWeeks:
        return '2 Wochen ab Rechnungsdatum';
      case DueDateType.thirtyDays:
        return '30 Tage ab Rechnungsdatum';
      case DueDateType.custom:
        return 'Benutzerdefiniert';
    }
  }
}
