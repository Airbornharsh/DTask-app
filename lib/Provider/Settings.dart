import 'package:flutter/material.dart';

class Settings with ChangeNotifier {
  final Color _color1 = const Color.fromARGB(255, 14, 124, 123);

  Color get getPrimary {
    return _color1;
  }
}
