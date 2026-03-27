import 'package:flutter/material.dart';

/// Formular-Abschnitt mit animiertem Ein-/Ausklappen (Pfeil rechts ↔ unten).
class ExpandableFormSection extends StatefulWidget {
  const ExpandableFormSection({
    super.key,
    required this.title,
    required this.child,
    this.initiallyExpanded = true,
    this.expandTooltip,
    this.collapseTooltip,

    /// Wenn gesetzt: bei eingeklapptem Zustand `title (summary)` anzeigen und bei Änderungen neu bauen.
    this.collapsedSummary,
    this.summaryListenables = const [],
  });

  final String title;
  final Widget child;
  final bool initiallyExpanded;

  /// Returning empty/nullish text → nur [title] anzeigen.
  final String Function()? collapsedSummary;

  /// Controller o.ä., damit die Überschrift live aktualisiert wird.
  final List<Listenable> summaryListenables;

  /// Tooltip wenn der Abschnitt eingeklappt ist (Tippen zum Ausklappen).
  final String? expandTooltip;

  /// Tooltip wenn der Abschnitt ausgeklappt ist (Tippen zum Einklappen).
  final String? collapseTooltip;

  @override
  State<ExpandableFormSection> createState() => _ExpandableFormSectionState();
}

class _ExpandableFormSectionState extends State<ExpandableFormSection> with SingleTickerProviderStateMixin {
  static const Duration _expandDuration = Duration(milliseconds: 280);

  late final AnimationController _expandController;
  late final CurvedAnimation _expandCurve;
  late final Animation<double> _iconTurns;

  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
    _expandController = AnimationController(
      vsync: this,
      duration: _expandDuration,
    );
    _expandCurve = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOut,
    );
    _iconTurns = Tween<double>(begin: 0, end: 0.25).animate(_expandCurve);
    if (_expanded) {
      _expandController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant ExpandableFormSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initiallyExpanded != widget.initiallyExpanded) {
      _expanded = widget.initiallyExpanded;
      if (_expanded) {
        _expandController.forward();
      } else {
        _expandController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _expandCurve.dispose();
    _expandController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _expanded = !_expanded;
      if (_expanded) {
        _expandController.forward();
      } else {
        _expandController.reverse();
      }
    });
  }

  String get _tooltipCollapse => widget.collapseTooltip ?? '${widget.title} einklappen';

  String get _tooltipExpand => widget.expandTooltip ?? '${widget.title} ausklappen';

  String _titleLabel() {
    if (_expanded || widget.collapsedSummary == null) {
      return widget.title;
    }
    final hint = widget.collapsedSummary!().trim();
    if (hint.isEmpty) return widget.title;
    return '${widget.title} ($hint)';
  }

  Widget _headerTitle(BuildContext context) {
    return Text(
      _titleLabel(),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final listenables = widget.summaryListenables;
    final hasSummary = widget.collapsedSummary != null && listenables.isNotEmpty;

    Widget headerTile() {
      final fullHint = (!_expanded && widget.collapsedSummary != null) ? widget.collapsedSummary!().trim() : '';
      final tooltipMessage = fullHint.isNotEmpty
          ? '${_expanded ? _tooltipCollapse : _tooltipExpand}\n$fullHint'
          : (_expanded ? _tooltipCollapse : _tooltipExpand);

      return Tooltip(
        message: tooltipMessage,
        child: Focus(
          canRequestFocus: false,
          skipTraversal: true,
          child: InkWell(
            onTap: _toggleExpanded,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RotationTransition(
                    turns: _iconTurns,
                    child: const Icon(Icons.keyboard_arrow_right, size: 28),
                  ),
                  const SizedBox(width: 4),
                  Expanded(child: _headerTitle(context)),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasSummary)
          AnimatedBuilder(
            animation: Listenable.merge(listenables),
            builder: (context, _) => headerTile(),
          )
        else
          headerTile(),
        ClipRect(
          child: SizeTransition(
            axisAlignment: -1,
            axis: Axis.vertical,
            sizeFactor: _expandCurve,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: widget.child,
            ),
          ),
        ),
      ],
    );
  }
}
