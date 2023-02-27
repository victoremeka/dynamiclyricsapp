import 'package:flutter/material.dart';

class LyricData{
  static ValueNotifier<int?> index = ValueNotifier(null);
  static ValueNotifier<List<String>> lyrics = ValueNotifier([]);
}