import 'package:flutter/material.dart';

/// Placeholder row for an unsaved new invoice (wide layout + `/invoice/new` only).
class NewInvoiceDraftListTile extends StatelessWidget {
  const NewInvoiceDraftListTile({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      selected: true,
      selectedTileColor: theme.colorScheme.surfaceContainerHighest,
      leading: Icon(
        Icons.edit_note_outlined,
        color: theme.colorScheme.primary,
      ),
      title: const Text('Neue Rechnung'),
      subtitle: Text(
        'Noch nicht gespeichert',
        style: TextStyle(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      onTap: onTap,
    );
  }
}
