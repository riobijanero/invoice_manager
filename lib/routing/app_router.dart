import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../common/layout/invoice_layout_breakpoints.dart';
import '../features/form/invoice_form_screen.dart';
import '../features/layout/invoice_split_placeholder.dart';
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
    ShellRoute(
      builder: (context, state, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= kInvoiceLayoutBreakpoint;
            if (!isWide) {
              final path = state.uri.path;
              if (path == '/' || path.isEmpty) {
                return const InvoiceListScreen();
              }
              return child;
            }

            final path = state.uri.path;
            final Widget rightPane;
            if (path == '/' || path.isEmpty) {
              rightPane = const InvoiceSplitPlaceholder();
            } else {
              rightPane = child;
            }

            return Scaffold(
              body: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    width: 400,
                    child: InvoiceListScreen(),
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(child: rightPane),
                ],
              ),
            );
          },
        );
      },
      routes: <RouteBase>[
        GoRoute(
          path: _routeHome,
          name: 'home',
          builder: (context, state) => const SizedBox.shrink(),
        ),
        GoRoute(
          path: _routeNewInvoice,
          name: 'newInvoice',
          builder: (context, state) => const InvoiceFormScreen(
            key: ValueKey<String>('invoice-new'),
            invoiceId: null,
          ),
        ),
        GoRoute(
          path: _routePreview,
          name: 'preview',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return PreviewScreen(
              key: ValueKey<String>('invoice-preview-$id'),
              invoiceId: id,
            );
          },
        ),
        GoRoute(
          path: _routeEditInvoice,
          name: 'editInvoice',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return InvoiceFormScreen(
              key: ValueKey<String>('invoice-edit-$id'),
              invoiceId: id,
            );
          },
        ),
      ],
    ),
  ],
);
