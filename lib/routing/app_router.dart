import 'package:go_router/go_router.dart';

import '../features/form/invoice_form_screen.dart';
import '../features/list/invoice_list_screen.dart';
import '../features/preview/preview_screen.dart';

const String _routeHome = '/';
const String _routeNewInvoice = '/invoice/new';
const String _routeEditInvoice = '/invoice/:id';
const String _routePreview = '/invoice/:id/preview';

String pathEdit(String id) => '/invoice/$id';
String pathPreview(String id) => '/invoice/$id/preview';

final GoRouter appRouter = GoRouter(
  initialLocation: _routeHome,
  routes: <RouteBase>[
    GoRoute(
      path: _routeHome,
      name: 'home',
      builder: (context, state) => const InvoiceListScreen(),
    ),
    GoRoute(
      path: _routeNewInvoice,
      name: 'newInvoice',
      builder: (context, state) => const InvoiceFormScreen(invoiceId: null),
    ),
    GoRoute(
      path: _routeEditInvoice,
      name: 'editInvoice',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return InvoiceFormScreen(invoiceId: id);
      },
    ),
    GoRoute(
      path: _routePreview,
      name: 'preview',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return PreviewScreen(invoiceId: id);
      },
    ),
  ],
);
