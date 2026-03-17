/// Discount applied as percentage or fixed amount.
enum DiscountType {
  percent,
  amount,
}

extension DiscountTypeX on DiscountType {
  String get displayName {
    switch (this) {
      case DiscountType.percent:
        return '%';
      case DiscountType.amount:
        return 'Betrag';
    }
  }
}
