import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final quantityNotifier = ValueNotifier<Map<String, int>>({});

Future<void> loadInitialQuantities() async {
  final prefs = await SharedPreferences.getInstance();
  final keys = prefs.getKeys();
  Map<String, int> quantities = {};

  for (var key in keys) {
    quantities[key] = prefs.getInt(key) ?? 0;
  }

  quantityNotifier.value = quantities;
}