import 'package:flutter/widgets.dart';

/// Below this width the app uses full-screen navigation (stack-based).
/// At or above, the list stays on the left and the form/preview on the right.
const double kInvoiceLayoutBreakpoint = 840;

bool isWideInvoiceLayout(BuildContext context) {
  return MediaQuery.sizeOf(context).width >= kInvoiceLayoutBreakpoint;
}
