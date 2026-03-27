// Baut Domain-Modelle aus Rohtext der Rechnungsmaske (trim, PLZ-Parsing).
import 'package:invoice_manager/common/models/adress.dart';
import 'package:invoice_manager/common/models/bank_details.dart';
import 'package:invoice_manager/common/models/client.dart';
import 'package:invoice_manager/common/models/sender.dart';

/// [Sender] aus den Absender-Feldern des Formulars.
Sender senderFromFormFields({
  required String name,
  required String jobDescription,
  required String street,
  required String town,
  required String country,
  required String postalCodeText,
  required String phone,
  required String email,
  required String website,
  required String ustId,
  required String taxNumber,
}) {
  return Sender(
    name: name.trim(),
    jobDescription: jobDescription.trim(),
    address: Adress(
      streetNameAndNumber: street.trim(),
      town: town.trim(),
      country: country.trim(),
      postalCode: int.tryParse(postalCodeText.trim()) ?? 0,
    ),
    phoneNumber: phone.trim(),
    email: email.trim(),
    website: website.trim(),
    ustId: ustId.trim(),
    taxNumber: taxNumber.trim(),
  );
}

/// [Client] aus den Kunden-Feldern des Formulars.
Client clientFromFormFields({
  required String clientId,
  required String companyName,
  required String name,
  required String street,
  required String town,
  required String country,
  required String postalCodeText,
}) {
  return Client(
    clientId: clientId.trim(),
    companyName: companyName.trim(),
    name: name.trim(),
    address: Adress(
      streetNameAndNumber: street.trim(),
      town: town.trim(),
      country: country.trim(),
      postalCode: int.tryParse(postalCodeText.trim()) ?? 0,
    ),
  );
}

/// [BankDetails] aus den Bank-Feldern des Formulars.
BankDetails bankDetailsFromFormFields({
  required String accountHolder,
  required String institution,
  required String iban,
  required String bic,
}) {
  return BankDetails(
    accountHolder: accountHolder.trim(),
    institution: institution.trim(),
    iban: iban.trim(),
    bic: bic.trim(),
  );
}
