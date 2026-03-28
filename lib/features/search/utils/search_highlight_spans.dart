import 'package:flutter/material.dart';

/// Zerlegt [text] in [TextSpan]s: Vorkommen von [query] (case-insensitiv) mit [highlightStyle].
///
/// Leerer [query] → ein Span mit gesamtem [text] in [style].
List<TextSpan> searchHighlightSpans({
  required String text,
  required String query,
  required TextStyle style,
  required TextStyle highlightStyle,
}) {
  final q = query.trim();
  if (q.isEmpty) {
    return [TextSpan(text: text, style: style)];
  }
  final lowerText = text.toLowerCase();
  final lowerQ = q.toLowerCase();
  final spans = <TextSpan>[];
  var start = 0;
  while (true) {
    final i = lowerText.indexOf(lowerQ, start);
    if (i < 0) {
      if (start < text.length) {
        spans.add(TextSpan(text: text.substring(start), style: style));
      }
      break;
    }
    if (i > start) {
      spans.add(TextSpan(text: text.substring(start, i), style: style));
    }
    final end = i + q.length;
    spans.add(TextSpan(text: text.substring(i, end), style: highlightStyle));
    start = end;
  }
  return spans;
}
