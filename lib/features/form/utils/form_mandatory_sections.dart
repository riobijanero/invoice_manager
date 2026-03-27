// Pflichtfeld-Logik für kollabierbare Formular-Abschnitte (muss mit den
// Validatoren in [SenderFields], [BankDetailsFields], [ClientFields] übereinstimmen).
import 'package:invoice_manager/features/form/utils/utils.dart';

/// `true`, wenn alle Absender-Pflichtfelder gültig befüllt sind (Name, Straße, PLZ, Ort, Land).
bool isSenderMandatoryComplete({
  required String name,
  required String street,
  required String postalCodeText,
  required String town,
  required String country,
}) {
  bool has(String s) => s.trim().isNotEmpty;
  if (!has(name)) return false;
  if (!has(street)) return false;
  final plz = postalCodeText.trim();
  final plzN = int.tryParse(plz);
  if (plz.isEmpty || plzN == null || plzN <= 0) return false;
  if (!has(town)) return false;
  if (!has(country)) return false;
  return true;
}

/// `true`, wenn Kontoinhaber, Institut, IBAN ([isValidIban]) und BIC gesetzt sind.
bool isBankMandatoryComplete({
  required String accountHolder,
  required String institution,
  required String iban,
  required String bic,
}) {
  bool has(String s) => s.trim().isNotEmpty;
  if (!has(accountHolder)) return false;
  if (!has(institution)) return false;
  if (!has(bic)) return false;
  final rawIban = iban.trim();
  if (rawIban.isEmpty || !isValidIban(rawIban)) return false;
  return true;
}

/// `true`, wenn mindestens Firma oder Name und die vollständige Adresse inkl. gültiger PLZ gesetzt sind.
bool isClientMandatoryComplete({
  required String companyName,
  required String personName,
  required String street,
  required String postalCodeText,
  required String town,
  required String country,
}) {
  final company = companyName.trim();
  final name = personName.trim();
  if (company.isEmpty && name.isEmpty) return false;
  bool has(String s) => s.trim().isNotEmpty;
  if (!has(street)) return false;
  final plz = postalCodeText.trim();
  final plzN = int.tryParse(plz);
  if (plz.isEmpty || plzN == null || plzN <= 0) return false;
  if (!has(town)) return false;
  if (!has(country)) return false;
  return true;
}
