import 'package:flutter/material.dart';
import 'package:le_bon_mot/services/book.dart';

class Services extends InheritedWidget {
  final BookService bookService;

  const Services({
    Key? key,
    required this.bookService,
    required Widget child,
  }) : super(key: key, child: child);

  static Services of(BuildContext context) {
    final Services? services =
        context.dependOnInheritedWidgetOfExactType<Services>();
    return services!;
  }

  @override
  bool updateShouldNotify(Services oldWidget) {
    return true;
  }
}
