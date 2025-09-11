import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../util/consts.dart';

Future<void> storeTripHistory(String tripId) async {
  final prefs = await SharedPreferences.getInstance();
  final List<String> list = await getHistoryList();
  final String jsonString = jsonEncode(list..add(tripId));
  await prefs.setString(keyOfTripHistory, jsonString);
}

Future<List<String>> getHistoryList() async {
  final prefs = await SharedPreferences.getInstance();
  final String? jsonString = prefs.getString(keyOfTripHistory);
  if (jsonString != null) {
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return List<String>.from(jsonList);
  } else {
    return [];
  }
}

Future<void> removeFromHistory(String tripId) async {
  final prefs = await SharedPreferences.getInstance();
  final List<String> list = await getHistoryList();
  list.remove(tripId);
  final String jsonString = jsonEncode(list);
  await prefs.setString(keyOfTripHistory, jsonString);
}
