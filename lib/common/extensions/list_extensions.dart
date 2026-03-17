import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;

extension ListtExtension on List {
  /// Intersperses [between] between all elements of instance
  List<Widget> intersperse(Widget between) {
    return fold(<Widget>[], (previousValue, element) {
      if (previousValue.isNotEmpty) {
        previousValue.add(between);
      }
      previousValue.add(element);
      return previousValue;
    });
  }
}

extension ListExtension on List<pw.Widget> {
  List<pw.Widget> intersperse(pw.Widget between) {
    return fold(<pw.Widget>[], (previousValue, element) {
      if (previousValue.isNotEmpty) {
        previousValue.add(between);
      }
      previousValue.add(element);
      return previousValue;
    });
  }
}
